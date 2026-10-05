import Foundation

// MARK: - What the screens show

struct WorkedExample: Decodable, Equatable {
    let situation: String
    let line: String
    let why: String
}

struct CheckOption: Decodable, Equatable {
    let text: String
    let correct: Bool
    let note: String
}

struct ComprehensionCheck: Decodable, Equatable {
    let prompt: String
    let options: [CheckOption]
    let explain: String
}

/// A lesson as this reader should see it: translated, tailored to who they are, with the check
/// options already shuffled so the answer cannot be found by position.
struct LessonDetail: Equatable {
    let id: String
    let order: Int
    let title: String
    let theory: String
    let examples: [WorkedExample]
    let checks: [ComprehensionCheck]
    let mission: String
}

// MARK: - Who is reading

/// The few facts that change the advice. Every field is optional — most readers have answered
/// nothing, and the lesson as written is correct for them.
struct Audience: Equatable {
    var sex: String?
    var ageGroup: String?
    var datingInterest: String?
}

struct VariantConditions: Decodable, Equatable {
    var sex: String?
    var ageGroup: String?
    var ageGroups: [String]?
    var datingInterest: String?
}

/// Optional per-audience versions of a lesson. Empty for almost every lesson; populated where the
/// advice genuinely differs by who is reading, which in practice means Dating and Work.
struct LessonVariant: Decodable, Equatable {
    var when: VariantConditions?
    /// An extra passage, added to the lesson rather than replacing it.
    var noteMd: String?
    /// Replaces the worked examples entirely, when the general ones do not fit.
    var examplesJson: [WorkedExample]?
}

/// A port of `src/lib/curriculum/variants.ts`. Read its comments for why a condition the reader has
/// not answered is a miss and never a guess: showing someone advice written for another audience on
/// the strength of the app inferring who they are is the one failure this matcher exists to avoid.
enum Variants {
    /// How well a variant fits a reader, or nil if it does not fit at all.
    static func score(_ c: VariantConditions, for a: Audience) -> Int? {
        var score = 0

        if let sex = c.sex {
            guard a.sex == sex else { return nil }
            score += 2
        }
        if let band = c.ageGroup {
            guard a.ageGroup == band else { return nil }
            score += 2
        }
        if let bands = c.ageGroups {
            guard let mine = a.ageGroup, bands.contains(mine) else { return nil }
            score += 1
        }
        if let interest = c.datingInterest {
            if a.datingInterest == interest {
                score += 2
            } else if a.datingInterest == "both" {
                // Someone who said "both" is part of the audience for either, more weakly than
                // someone who named one, so an explicit "both" variant still wins.
                score += 1
            } else {
                return nil
            }
        }
        return score
    }

    /// The best-fitting variant, or nil when the lesson as written is the right one — which is the
    /// common case. Strictly greater, so of two equally specific variants the first written wins.
    static func pick(_ variants: [LessonVariant]?, for audience: Audience) -> LessonVariant? {
        var best: LessonVariant?
        var bestScore = 0
        for variant in variants ?? [] {
            if let s = score(variant.when ?? VariantConditions(), for: audience), s > bestScore {
                best = variant
                bestScore = s
            }
        }
        return best
    }
}

// MARK: - Wire format and loading

/// Decodes to nil instead of failing. For the optional extras only: a malformed legacy check or
/// variant should cost the lesson that extra, not the lesson itself.
private struct Lossy<T: Decodable>: Decodable {
    let value: T?
    init(from decoder: Decoder) throws {
        value = try? T(from: decoder)
    }
}

private struct LessonRow: Decodable {
    let id: String
    let skillId: String
    let sortOrder: Int
    let title: String
    let theoryMd: String
    let examplesJson: [WorkedExample]?
    /// Superseded by `checksJson`; kept for any lesson the two-check migrations have not reached.
    let checkJson: Lossy<ComprehensionCheck>?
    let checksJson: [ComprehensionCheck]?
    let missionText: String
    let variantsJson: Lossy<[LessonVariant]>?
}

private struct LessonText: Decodable {
    let title: String?
    let theoryMd: String?
    let examplesJson: [WorkedExample]?
    let checksJson: [ComprehensionCheck]?
    let missionText: String?
}

enum LessonError: Error {
    /// The row came back empty: no such lesson, or one this account may not read. The database
    /// refuses before the difference reaches the app, so the app cannot tell them apart.
    case unavailable
}

struct LessonAPI {
    let client = SupabaseClient.shared

    func lesson(skillID: String, order: Int, locale: AppLocale, audience: Audience,
                accessToken token: String) async throws -> LessonDetail {
        let rows: [LessonRow] = try await client.rows(
            "lessons",
            query: "select=id,skill_id,sort_order,title,theory_md,examples_json,check_json,checks_json,mission_text,variants_json"
                + "&skill_id=eq.\(skillID)&sort_order=eq.\(order)",
            accessToken: token)
        guard let row = rows.first else { throw LessonError.unavailable }

        // Read after the lesson, so the entitlement check happens once, on the lesson itself. If it
        // was refused this never runs, and the translations policy would refuse it too.
        var text: LessonText?
        if locale != .default {
            let found: [LessonText] = try await client.rows(
                "lesson_translations",
                query: "select=title,theory_md,examples_json,checks_json,mission_text&lesson_id=eq.\(row.id)&locale=eq.\(locale.rawValue)",
                accessToken: token)
            text = found.first
        }

        let variant = Variants.pick(row.variantsJson?.value, for: audience)

        // The tailored passage joins the body rather than sitting in a box beside it: a reader who
        // has answered the questions does not need telling which paragraphs were chosen for them.
        let baseTheory = Self.pick(text?.theoryMd, row.theoryMd)
        let theory = [baseTheory, variant?.noteMd].compactMap { $0 }
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .joined(separator: "\n\n")

        let baseExamples = text?.examplesJson ?? row.examplesJson ?? []
        let examples = variant?.examplesJson ?? baseExamples

        var checks = text?.checksJson ?? row.checksJson ?? []
        if checks.isEmpty, let legacy = row.checkJson?.value { checks = [legacy] }
        checks = checks.map { ComprehensionCheck(prompt: $0.prompt, options: $0.options.shuffled(), explain: $0.explain) }

        return LessonDetail(
            id: row.id,
            order: row.sortOrder,
            title: Self.pick(text?.title, row.title),
            theory: theory,
            examples: examples,
            checks: checks,
            mission: Self.pick(text?.missionText, row.missionText))
    }

    /// A translated field counts as present only if it is not nil and not blank.
    private static func pick(_ translated: String?, _ base: String) -> String {
        guard let translated, !translated.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return base }
        return translated
    }
}

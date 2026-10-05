import Foundation

/// What the screens show: the English base row with the reader's translation laid over it.
struct TopicItem: Identifiable, Equatable {
    let id: String
    let slug: String
    let name: String
    let description: String
    let skills: [SkillItem]

    var lessonCount: Int { skills.reduce(0) { $0 + $1.lessons.count } }
}

struct SkillItem: Identifiable, Equatable {
    let id: String
    let slug: String
    let name: String
    let description: String
    let lessons: [LessonItem]
}

struct LessonItem: Identifiable, Equatable {
    let id: String
    let order: Int
    let title: String
    /// One of the lessons a free account can open.
    let isPreview: Bool
}

// MARK: - Wire format

/// The rows as the database sends them. `convertFromSnakeCase` maps `skill_id` → `skillId`.
private struct TopicRow: Decodable {
    let id: String
    let slug: String
    let name: String
    let description: String?
    let skills: [SkillRow]
}

private struct SkillRow: Decodable {
    let id: String
    let slug: String
    let name: String
    let description: String?
}

private struct LessonRow: Decodable {
    let id: String
    let skillId: String
    let sortOrder: Int
    let title: String
    let isPreview: Bool?
}

private struct TopicTranslation: Decodable {
    let topicId: String
    let name: String?
    let description: String?
}

private struct SkillTranslation: Decodable {
    let skillId: String
    let name: String?
    let description: String?
}

private struct LessonTitleTranslation: Decodable {
    let lessonId: String
    let title: String?
}

/// Reads the curriculum the same way the website's `getTopics` does, one query per table, and
/// merges the translation in memory *per field*: a translated field wins, and an empty or
/// missing one falls back to English rather than blanking a heading. That per-field rule is
/// what lets a language ship before it is finished.
struct CurriculumAPI {
    let client = SupabaseClient.shared

    func topics(locale: AppLocale, accessToken token: String) async throws -> [TopicItem] {
        async let topicRows: [TopicRow] = client.rows(
            "topics",
            query: "select=id,slug,name,description,sort_order,skills(id,slug,name,description,sort_order)&order=sort_order&skills.order=sort_order",
            accessToken: token)
        // `lesson_index` rather than `lessons`: the policy on `lessons` hides what a free account
        // has not paid for, which is right for a lesson's body and useless for a list of locks.
        async let lessonRows: [LessonRow] = client.rows(
            "lesson_index", query: "select=id,skill_id,sort_order,title,is_preview&order=sort_order", accessToken: token)

        async let topicText: [TopicTranslation] = translations(
            "topic_translations", select: "topic_id,name,description", locale: locale, token: token)
        async let skillText: [SkillTranslation] = translations(
            "skill_translations", select: "skill_id,name,description", locale: locale, token: token)
        async let titleText: [LessonTitleTranslation] = translations(
            "lesson_title_translations", select: "lesson_id,title", locale: locale, token: token)

        let (topics, lessons, topicT, skillT, titleT) = try await (topicRows, lessonRows, topicText, skillText, titleText)

        // Keep the first row if a table ever holds two for one id, rather than trapping on it.
        let topicByID = Dictionary(topicT.map { ($0.topicId, $0) }, uniquingKeysWith: { first, _ in first })
        let skillByID = Dictionary(skillT.map { ($0.skillId, $0) }, uniquingKeysWith: { first, _ in first })
        let titleByID = Dictionary(titleT.map { ($0.lessonId, $0) }, uniquingKeysWith: { first, _ in first })

        var lessonsBySkill: [String: [LessonItem]] = [:]
        for row in lessons {
            let item = LessonItem(id: row.id, order: row.sortOrder,
                                  title: Self.pick(titleByID[row.id]?.title, row.title),
                                  isPreview: row.isPreview ?? false)
            lessonsBySkill[row.skillId, default: []].append(item)
        }

        return topics.map { topic in
            let text = topicByID[topic.id]
            return TopicItem(
                id: topic.id,
                slug: topic.slug,
                name: Self.pick(text?.name, topic.name),
                description: Self.pick(text?.description, topic.description ?? ""),
                skills: topic.skills.map { skill in
                    let skillTextRow = skillByID[skill.id]
                    return SkillItem(
                        id: skill.id,
                        slug: skill.slug,
                        name: Self.pick(skillTextRow?.name, skill.name),
                        description: Self.pick(skillTextRow?.description, skill.description ?? ""),
                        lessons: (lessonsBySkill[skill.id] ?? []).sorted { $0.order < $1.order })
                })
        }
    }

    /// Whether the account has a subscription. Asks the same database function the row level security
    /// policies ask, rather than reimplementing the rule: two copies of an access rule are two chances
    /// to disagree, and the app's copy would be the wrong one to trust.
    func isPro(accessToken token: String) async throws -> Bool {
        try await client.rpc("is_pro", accessToken: token)
    }

    /// Lessons this reader has read — the sessions of kind `theory`, the same set the website uses to
    /// decide how far into a track someone may go.
    func readLessonIDs(accessToken token: String) async throws -> Set<String> {
        struct Row: Decodable { let lessonId: String? }
        let rows: [Row] = try await client.rows("sessions", query: "select=lesson_id&kind=eq.theory", accessToken: token)
        return Set(rows.compactMap(\.lessonId))
    }

    /// The reader's language is fetched whole, in one query per table, and merged in memory — one
    /// round trip however much of the curriculum has been translated. English needs none.
    private func translations<T: Decodable>(
        _ table: String, select: String, locale: AppLocale, token: String
    ) async throws -> [T] {
        guard locale != .default else { return [] }
        return try await client.rows(table, query: "select=\(select)&locale=eq.\(locale.rawValue)", accessToken: token)
    }

    /// A translated field counts as present only if it is not nil and not blank — a blank string
    /// is what a half-finished translation looks like.
    private static func pick(_ translated: String?, _ base: String) -> String {
        guard let translated, !translated.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return base }
        return translated
    }
}

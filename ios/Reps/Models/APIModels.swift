import Foundation

// The shapes the website's JSON API returns. Decoded with `convertFromSnakeCase`, so the raw
// database rows (`logged_date`) and the API's own camelCase fields both land on the right names.
// Each mirrors a type on the server — see `src/app/api` — and is deliberately thin: the server has
// already decided what is true, and the app only has to show it.

// MARK: - Today

struct TodayData: Decodable, Equatable {
    struct Totals: Decodable, Equatable {
        let repsLogged: Int
        let totalXp: Int
        let currentStreak: Int
        let longestStreak: Int
    }

    struct Rank: Decodable, Equatable {
        struct Next: Decodable, Equatable {
            let name: String
            let note: String
            let conversationsToGo: Int
        }
        let name: String
        let note: String
        let position: Int
        let total: Int
        let xp: Int
        let fraction: Double
        let isMax: Bool
        let next: Next?
    }

    struct Resume: Decodable, Equatable {
        let topicName: String
        let topicSlug: String
        let skillSlug: String
        let skillName: String
        let lessonTitle: String
        let lessonSortOrder: Int
        let nextSortOrder: Int?
    }

    struct Review: Decodable, Equatable {
        let reps: Int
        let skillsTouched: Int
    }

    struct HeatmapDay: Decodable, Equatable {
        let date: String
        let count: Int
    }

    struct Skill: Decodable, Equatable {
        let slug: String
        let name: String
        let level: Int
        let fraction: Double
        let isMax: Bool
        let nextLevel: String?
    }

    struct Topic: Decodable, Equatable {
        let slug: String
        let name: String
        let reps: Int
        let skills: [Skill]
    }

    struct Badge: Decodable, Equatable, Identifiable {
        let id: String
        let name: String
        let description: String
    }

    struct Badges: Decodable, Equatable {
        let earned: [Badge]
        let locked: [Badge]
    }

    struct XPRow: Decodable, Equatable {
        let label: String
        let xp: Int
        let note: String
    }

    let name: String?
    let email: String?
    let fact: String
    let totals: Totals
    let rank: Rank
    let resume: Resume?
    let review: Review
    let heatmap: [HeatmapDay]
    let rehearsals: Int
    let topics: [Topic]
    let openTopicSlug: String?
    let badges: Badges
    let xpTable: [XPRow]
    let theoryRatio: Int
}

// MARK: - Rehearsals

struct PastRehearsal: Decodable, Equatable, Identifiable {
    let id: String
    let status: String
    let mode: String
    let startedAt: String
    let lines: Int
    let average: Double?
    let landed: Bool?
    let fix: String?
}

/// The box at the foot of a lesson: what kind of exercise this is and whether it is open yet.
struct RehearsalBox: Decodable, Equatable {
    let mode: String
    let paid: Bool
    let partnerName: String
    let openness: Int
    let level: Int
    let requiredLevel: Int
    let unlocked: Bool
    let freeLeft: Int?
    let spent: Bool
    let openId: String?
    let xp: Int
    let past: [PastRehearsal]
}

struct StartedRehearsal: Decodable { let id: String }

/// A rehearsal in whatever state it is in. Named `State` rather than `View` to keep clear of SwiftUI.
struct RehearsalState: Decodable, Equatable {
    struct Partner: Decodable, Equatable {
        let name: String
        let role: String
        let openness: Int
    }

    struct Criterion: Decodable, Equatable {
        let key: String
        let label: String
        let description: String
    }

    struct Turn: Decodable, Equatable {
        let role: String
        let content: String
        let correct: Bool?
    }

    struct Line: Decodable, Equatable {
        struct Attempt: Decodable, Equatable {
            struct Verdict: Decodable, Equatable {
                let requirement: String
                let ok: Bool
                let why: String?
            }
            let line: String
            let landed: Bool
            let results: [Verdict]
        }
        struct Model: Decodable, Equatable {
            let line: String
            let why: String
        }
        let says: String?
        let maxChars: Int
        let maxAttempts: Int
        let requirements: [String]
        let attempts: [Attempt]
        let model: Model?
    }

    struct Choice: Decodable, Equatable {
        struct Option: Decodable, Equatable {
            let text: String
            let correct: Bool
            let note: String
        }
        struct Answered: Decodable, Equatable {
            let situation: String
            let chosen: String
            let correct: Bool
            let options: [Option]
        }
        struct Current: Decodable, Equatable {
            struct Pick: Decodable, Equatable {
                let index: Int
                let text: String
            }
            let situation: String
            let prompt: String
            let options: [Pick]
        }
        let total: Int
        let answered: [Answered]
        let current: Current?
    }

    struct Chat: Decodable, Equatable {
        let turnsLeft: Int
        let maxChars: Int
        let instruction: String?
    }

    let id: String
    let mode: String
    let status: String
    let lessonId: String
    let skillSlug: String
    let lessonOrder: Int
    let lessonTitle: String
    let setting: String
    let partner: Partner
    let showPartner: Bool
    let paid: Bool
    let usingRealModel: Bool
    let theMove: String
    let rehearsalNote: String?
    let criteria: [Criterion]
    let mission: String
    let examples: [WorkedExample]
    let transcript: [Turn]
    let unavailable: Bool
    let line: Line?
    let choice: Choice?
    let chat: Chat?
    let result: RehearsalResult?

    var isComplete: Bool { status == "complete" }
}

/// How a finished rehearsal turned out. The server tags the three shapes with `kind`.
enum RehearsalResult: Decodable, Equatable {
    struct Score: Decodable, Equatable {
        let key: String
        let label: String
        let score: Int
    }
    struct Scale: Decodable, Equatable {
        let min: Int
        let max: Int
    }
    struct Rewrite: Decodable, Equatable {
        let original: String
        let better: String
        let why: String
    }

    case drill(landed: Bool, attempts: Int, missed: [String])
    case scene(scale: Scale, scores: [Score], worked: [String], fix: String, rewrite: Rewrite?)
    case ended

    private enum Keys: String, CodingKey {
        case kind, landed, attempts, missed, scale, scores, worked, fix, rewrite
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        switch try c.decode(String.self, forKey: .kind) {
        case "drill":
            self = .drill(landed: try c.decode(Bool.self, forKey: .landed),
                          attempts: try c.decode(Int.self, forKey: .attempts),
                          missed: try c.decode([String].self, forKey: .missed))
        case "scene":
            self = .scene(scale: try c.decode(Scale.self, forKey: .scale),
                          scores: try c.decode([Score].self, forKey: .scores),
                          worked: try c.decode([String].self, forKey: .worked),
                          fix: try c.decode(String.self, forKey: .fix),
                          rewrite: try c.decodeIfPresent(Rewrite.self, forKey: .rewrite))
        default:
            self = .ended
        }
    }
}

struct RehearsalTree: Decodable, Equatable {
    struct Lesson: Decodable, Equatable, Identifiable {
        let lessonId: String
        let sortOrder: Int
        let title: String
        let rehearsals: [PastRehearsal]
        var id: String { lessonId }
    }
    struct Skill: Decodable, Equatable, Identifiable {
        let slug: String
        let name: String
        let total: Int
        let lessons: [Lesson]
        var id: String { slug }
    }
    struct Topic: Decodable, Equatable, Identifiable {
        let slug: String
        let name: String
        let total: Int
        let skills: [Skill]
        var id: String { slug }
    }
    let topics: [Topic]
}

// MARK: - Logging

struct FieldLogEntry: Decodable, Equatable, Identifiable {
    struct SkillRef: Decodable, Equatable {
        struct TopicRef: Decodable, Equatable {
            let slug: String
            let name: String
        }
        let slug: String
        let name: String
        let topics: TopicRef?
    }

    let id: String
    let skillId: String
    let lessonId: String?
    let missionText: String?
    let contextNote: String?
    let went: Int
    let reflection: String?
    let xpAwarded: Int
    let loggedAt: String
    let loggedDate: String
    let otherSex: String?
    let otherAgeGroup: String?
    let skills: SkillRef?
}

struct FieldLogResponse: Decodable, Equatable {
    let entries: [FieldLogEntry]
    let totals: TodayData.Totals
}

struct LoggedRep: Decodable {
    let xp: Int
    let badges: [TodayData.Badge]
}

/// For endpoints that answer `{"ok": true}` and nothing the app needs to read.
struct Acknowledged: Decodable {}

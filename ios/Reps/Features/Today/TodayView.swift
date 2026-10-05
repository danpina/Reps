import SwiftUI

/// The landing screen. The same things the website's Today page shows, in the same order, from the
/// same queries — the server works out ranks, levels and the heatmap, and the app draws them.
struct TodayView: View {
    let goTo: (MainTabView.Tab) -> Void

    @EnvironmentObject private var store: SessionStore
    @EnvironmentObject private var library: LibraryStore

    @State private var today: TodayData?
    @State private var errorText: String?
    @State private var showLog = false
    @State private var lessonSheet: LessonTarget?

    private var strings: Strings { store.strings }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if let today {
                        content(today)
                    } else if let errorText {
                        VStack(spacing: 14) {
                            Text(errorText).multilineTextAlignment(.center).foregroundColor(.secondary)
                            Button(strings.retry) { Task { await load() } }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        ProgressView(strings.loading)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .navigationTitle(greeting)
            .refreshable { await load() }
        }
        // Today shows what the reader has done, so it is read afresh whenever they come back to it.
        .onAppear { Task { await load() } }
        .sheet(isPresented: $showLog) {
            LogRepView(preset: LogPreset()) { Task { await load() } }
        }
        .sheet(item: $lessonSheet) { target in
            NavigationStack {
                LessonView(skill: target.skill, topicName: target.topicName, index: target.index)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(strings.close) { lessonSheet = nil }
                        }
                    }
            }
            .environmentObject(store)
            .environmentObject(library)
        }
    }

    private var greeting: String {
        if let name = today?.name ?? store.profile.displayName?.trimmingCharacters(in: .whitespaces), !name.isEmpty {
            return strings.t("today.greetingWithName", ["name": name])
        }
        return strings.t("today.greeting")
    }

    private func load() async {
        do {
            let data: TodayData = try await store.withToken { try await RepsAPI().get("api/today", token: $0) }
            today = data
            errorText = nil
        } catch is CancellationError {
        } catch let error as URLError where error.code == .cancelled {
        } catch {
            if today == nil { errorText = error.localizedDescription }
        }
    }

    // MARK: Content

    @ViewBuilder private func content(_ data: TodayData) -> some View {
        QuoteBlock(text: "“\(data.fact)”", emphasised: true)
            .italic()
            .foregroundColor(.secondary)

        actionCard(data)
        if let resume = data.resume { resumeCard(resume) }
        if data.review.reps > 0 { weekCard(data.review) }
        if data.totals.repsLogged > 0 { HeatmapView(days: data.heatmap, strings: strings) }
        if !data.topics.isEmpty { standing(data) }
        if !data.badges.earned.isEmpty || data.totals.repsLogged > 0 { badges(data.badges, repsLogged: data.totals.repsLogged) }

        VStack(alignment: .leading, spacing: 4) {
            Text(strings.t("today.signedInAs", ["email": data.email ?? strings.t("today.yourAccount")]))
            Text(strings.t("today.designedBy"))
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }

    // MARK: The main card

    private func actionCard(_ data: TodayData) -> some View {
        let first = data.totals.repsLogged == 0
        return VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(first ? strings.t("today.startATrack") : strings.t("today.hadAConversation"))
                    .font(.headline)
                Text(first ? strings.t("today.startATrackBody") : strings.t("today.logItBody"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 10) {
                PrimaryButton(title: strings.t("today.logARep")) { showLog = true }
                SecondaryButton(title: first ? strings.t("today.browseTopics") : strings.t("today.seeYourReps")) {
                    goTo(first ? .learn : .log)
                }
            }

            // Quiet, and below the two things that matter, because a rehearsal is the warm-up.
            if data.rehearsals > 0 {
                Button { goTo(.rehearsals) } label: {
                    Text("\(strings.t("rehearsalList.rehearsalsCount", ["count": data.rehearsals])) →")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            HStack(alignment: .top) {
                stat(strings.t("today.repsLogged"), "\(data.totals.repsLogged)", note: nil)
                Spacer()
                stat(strings.t("today.currentStreak"), "\(data.totals.currentStreak)",
                     note: data.totals.longestStreak > data.totals.currentStreak
                        ? strings.t("today.bestStreak", ["count": data.totals.longestStreak]) : nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()
            rankSection(data.rank)
            progressExplainer(data)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func stat(_ label: String, _ value: String, note: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value).font(.system(.title, design: .rounded).monospacedDigit())
                if let note { Text(note).font(.caption).foregroundColor(.secondary) }
            }
        }
    }

    /// Named rather than numbered: skills have levels, you have a rank, and two numbers on one screen
    /// invited an arithmetic that does not exist.
    private func rankSection(_ rank: TodayData.Rank) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(rank.name).font(.headline)
                Spacer()
                Text(strings.t("today.rankXp", ["xp": rank.xp, "position": rank.position, "total": rank.total]))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            ProgressBar(fraction: rank.fraction)
                .accessibilityLabel(rank.next.map { strings.t("today.progressToRank", ["name": $0.name]) }
                                    ?? strings.t("today.everyRankEarnedAria"))

            if let next = rank.next {
                // Said in conversations, not points: nobody has a feel for 450 XP, and reps are the
                // only currency the app wants spent.
                Text(emphasised(strings.t("today.moreConversations", ["count": next.conversationsToGo]),
                                then: strings.t("today.toRank", ["name": next.name, "note": next.note])))
                    .font(.footnote)
            } else {
                Text(strings.t("today.everyRankEarned", ["note": rank.note]))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func emphasised(_ first: String, then rest: String) -> AttributedString {
        var lead = AttributedString(first)
        lead.foregroundColor = .primary
        var tail = AttributedString(" " + rest)
        tail.foregroundColor = .secondary
        lead.append(tail)
        return lead
    }

    private func progressExplainer(_ data: TodayData) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(data.xpTable.enumerated()), id: \.offset) { _, row in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(row.label).font(.footnote)
                            Text(row.note).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("+\(row.xp)").font(.footnote.monospacedDigit())
                    }
                }
                Divider()
                Text(strings.t("today.theoryRatio", ["ratio": data.theoryRatio]))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        } label: {
            Text(strings.t("today.howProgressWorks")).font(.caption).foregroundColor(.secondary)
        }
    }

    // MARK: Resume and the week

    private func resumeCard(_ resume: TodayData.Resume) -> some View {
        Card {
            SectionLabel(text: strings.t("today.pickUpWhereYouLeftOff"))
            Text("\(resume.topicName) · \(resume.skillName)").font(.caption).foregroundColor(.secondary)
            Text(strings.t("today.lessonNumber", ["number": resume.lessonSortOrder, "title": resume.lessonTitle]))
                .font(.headline)
            HStack(spacing: 10) {
                PrimaryButton(title: strings.t("today.backToThisLesson")) { open(resume.skillSlug, resume.lessonSortOrder) }
                if let next = resume.nextSortOrder {
                    SecondaryButton(title: strings.t("today.nextLesson")) { open(resume.skillSlug, next) }
                }
            }
        }
    }

    private func open(_ skillSlug: String, _ order: Int) {
        for topic in library.topics {
            if let skill = topic.skills.first(where: { $0.slug == skillSlug }),
               let index = skill.lessons.firstIndex(where: { $0.order == order }) {
                lessonSheet = LessonTarget(skill: skill, topicName: topic.name, index: index)
                return
            }
        }
    }

    private func weekCard(_ review: TodayData.Review) -> some View {
        Card(tint: .orange) {
            SectionLabel(text: strings.t("today.thisWeek"), color: .orange)
            Text(strings.t("today.repsAcrossSkills", ["reps": review.reps, "skills": review.skillsTouched]))
                .font(.subheadline)
        }
    }

    // MARK: Where you are, and badges

    private func standing(_ data: TodayData) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionLabel(text: strings.t("today.whereYouAre"))
            ForEach(data.topics, id: \.slug) { topic in
                DisclosureGroup(isExpanded: expansion(for: topic.slug, open: data.openTopicSlug)) {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(topic.skills, id: \.slug) { skill in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(skill.name).font(.subheadline).foregroundColor(.secondary)
                                    Spacer()
                                    Text(levelLine(skill)).font(.caption.monospacedDigit()).foregroundColor(.secondary)
                                }
                                ProgressBar(fraction: skill.fraction, height: 4)
                                    .accessibilityLabel(strings.t("today.progressToNextLevel", ["name": skill.name]))
                            }
                        }
                    }
                    .padding(.top, 10)
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Text(topic.name).font(.subheadline.weight(.medium))
                        Spacer()
                        Text(strings.t("today.repsAcrossSkills", ["reps": topic.reps, "skills": topic.skills.count]))
                            .font(.caption.monospacedDigit())
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private func levelLine(_ skill: TodayData.Skill) -> String {
        let level = strings.t("today.levelNumber", ["level": skill.level])
        guard !skill.isMax, let next = skill.nextLevel else { return level }
        return "\(level) · \(next)"
    }

    /// The topic they were last reading is the one left open, and nothing on screen says so: a label
    /// explaining why a thing is open is worse than the thing just being open.
    @State private var expanded: Set<String> = []
    @State private var expansionSeeded = false

    private func expansion(for slug: String, open: String?) -> Binding<Bool> {
        Binding(
            get: { expansionSeeded ? expanded.contains(slug) : slug == open },
            set: { isOpen in
                if !expansionSeeded {
                    expansionSeeded = true
                    expanded = open.map { [$0] } ?? []
                }
                if isOpen { expanded.insert(slug) } else { expanded.remove(slug) }
            })
    }

    private func badges(_ badges: TodayData.Badges, repsLogged: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: strings.t("today.badges"))

            if badges.earned.isEmpty {
                Text(strings.t("today.noBadgesYet")).font(.subheadline).foregroundColor(.secondary)
            } else {
                ForEach(badges.earned) { badge in
                    Card(tint: .accentColor) {
                        Text(badge.name).font(.subheadline.weight(.medium))
                        Text(badge.description).font(.footnote).foregroundColor(.secondary)
                    }
                }
            }

            if !badges.locked.isEmpty {
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(badges.locked) { badge in
                            (Text(badge.name).foregroundColor(.secondary) + Text(" — \(badge.description)"))
                                .font(.footnote)
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                    }
                    .padding(.top, 8)
                } label: {
                    Text(strings.t("today.stillToEarn", ["count": badges.locked.count])).font(.caption).foregroundColor(.secondary)
                }
            }
        }
    }
}

/// What opens a lesson from outside the Learn tab.
struct LessonTarget: Identifiable {
    let skill: SkillItem
    let topicName: String
    let index: Int
    var id: String { skill.lessons[index].id }
}

// MARK: - Heatmap

/// Active days as a calendar grid, twelve weeks, Monday first. Deliberately quiet: it is a record of
/// what happened, not a scoreboard, so an empty day is a faint outline rather than a reproach.
struct HeatmapView: View {
    let days: [TodayData.HeatmapDay]
    let strings: Strings

    private var weeks: [[TodayData.HeatmapDay]] {
        stride(from: 0, to: days.count, by: 7).map { Array(days[$0..<min($0 + 7, days.count)]) }
    }

    var body: some View {
        if days.isEmpty {
            EmptyView()
        } else {
            let active = days.filter { $0.count > 0 }.count
            let total = days.reduce(0) { $0 + $1.count }

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    SectionLabel(text: strings.t("heatmap.activeDays"))
                    Spacer()
                    Text("\(strings.t("heatmap.daysCount", ["count": active])) · \(strings.t("heatmap.repsCount", ["count": total]))")
                        .font(.caption.monospacedDigit())
                        .foregroundColor(.secondary)
                }

                HStack(alignment: .top, spacing: 4) {
                    VStack(spacing: 4) {
                        ForEach(Array(initials.enumerated()), id: \.offset) { _, letter in
                            Text(letter).font(.system(size: 9)).foregroundColor(.secondary).frame(width: 12, height: 14)
                        }
                    }
                    ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                        VStack(spacing: 4) {
                            ForEach(week, id: \.date) { day in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(fill(day.count))
                                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(.separator), lineWidth: day.count == 0 ? 0.5 : 0))
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(strings.t("heatmap.summaryAriaLabel", ["active": active, "reps": total, "weeks": weeks.count]))

                HStack(spacing: 14) {
                    legend(fill(0), strings.t("heatmap.legendNone"))
                    legend(fill(1), strings.t("heatmap.legendOne"))
                    legend(fill(2), strings.t("heatmap.legendTwoOrMore"))
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
    }

    private var initials: [String] {
        [strings.t("heatmap.weekdayInitial.0"), strings.t("heatmap.weekdayInitial.1"),
         strings.t("heatmap.weekdayInitial.2"), strings.t("heatmap.weekdayInitial.3"),
         strings.t("heatmap.weekdayInitial.4"), strings.t("heatmap.weekdayInitial.5"),
         strings.t("heatmap.weekdayInitial.6")]
    }

    private func fill(_ count: Int) -> Color {
        switch count {
        case 0: return Color.clear
        case 1: return Color.accentColor.opacity(0.5)
        default: return Color.accentColor
        }
    }

    private func legend(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 3).fill(color)
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(.separator), lineWidth: 0.5))
                .frame(width: 12, height: 12)
            Text(label)
        }
    }
}

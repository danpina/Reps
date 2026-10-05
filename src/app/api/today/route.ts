import { getTranslations } from "next-intl/server";

import { apiRoute } from "@/lib/api/route";
import { getLocale, getProfile, requireUser } from "@/lib/auth/dal";
import { factForLocale } from "@/lib/facts";
import {
  REPS_TO_THEORY_RATIO,
  describeNextLevelLocalized,
  xpTable,
} from "@/lib/progress/explain";
import {
  getBadges,
  getHeatmap,
  getResumePoint,
  getSkillStandings,
  getTotals,
  getWeeklyReview,
  groupByTopic,
} from "@/lib/progress/queries";
import { rankName, rankNote, rankProgress, repsToNextRank } from "@/lib/progress/ranks";
import { XP_AWARD } from "@/lib/progress/rules";
import { countRehearsals } from "@/lib/roleplay/queries";

/**
 * The Today screen as data.
 *
 * The same queries the website's Today page runs, in the same order, with the
 * pieces of text that come out of the data — rank names, badge descriptions,
 * "3 more reps to level 4" — already in the reader's language. The app words
 * the screen around them itself, in its own strings.
 */
export async function GET(request: Request) {
  return apiRoute(request, async ({ email }) => {
    await requireUser();

    const [profile, totals, standings, heatmap, badges, review, resume, rehearsals, locale] =
      await Promise.all([
        getProfile(),
        getTotals(),
        getSkillStandings(),
        getHeatmap(),
        getBadges(),
        getWeeklyReview(),
        getResumePoint(),
        countRehearsals(),
        getLocale(),
      ]);

    const [tRanks, tProgress] = await Promise.all([
      getTranslations("ranks"),
      getTranslations("progress"),
    ]);

    const rank = rankProgress(totals.totalXp);
    // Only skills with something in them, grouped, so a topic only appears once
    // there is something under it — as on the website.
    const started = groupByTopic(standings.filter((s) => s.progress.xp > 0));

    return {
      name: profile?.display_name?.trim() || null,
      email,
      fact: factForLocale(locale).text,
      totals,
      rank: {
        name: rankName(tRanks, rank.rank),
        note: rankNote(tRanks, rank.rank),
        position: rank.position,
        total: rank.total,
        xp: rank.xp,
        fraction: rank.fraction,
        isMax: rank.isMax,
        next: rank.next
          ? {
              name: rankName(tRanks, rank.next),
              note: rankNote(tRanks, rank.next),
              conversationsToGo: repsToNextRank(rank.toNext, XP_AWARD.mission),
            }
          : null,
      },
      resume,
      review: { reps: review.reps, skillsTouched: review.skillsTouched.length },
      heatmap,
      rehearsals,
      topics: started.map((topic) => ({
        slug: topic.slug,
        name: topic.name,
        reps: topic.reps,
        skills: topic.skills.map((skill) => ({
          slug: skill.slug,
          name: skill.name,
          level: skill.progress.level,
          fraction: skill.progress.fraction,
          isMax: skill.progress.isMax,
          nextLevel: skill.progress.isMax ? null : describeNextLevelLocalized(tProgress, skill.progress),
        })),
      })),
      // The topic they were last reading is the one left open on the website.
      openTopicSlug: started.find((t) => t.slug === resume?.topicSlug)?.slug ?? started[0]?.slug ?? null,
      badges: {
        earned: badges.earned.map((b) => ({ id: b.id, name: b.name, description: b.description })),
        locked: badges.locked.map((b) => ({ id: b.id, name: b.name, description: b.description })),
      },
      xpTable: xpTable(tProgress),
      theoryRatio: REPS_TO_THEORY_RATIO,
    };
  });
}

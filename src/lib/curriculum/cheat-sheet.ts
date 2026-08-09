/**
 * The one printable page for a topic.
 *
 * Everything else the curriculum distils is assembled from the lessons, so it
 * cannot drift out of step with them. This one is written by hand on purpose:
 * the value of a cheat sheet is entirely in what was left out, and forty moves
 * assembled automatically is a syllabus rather than something you can hold.
 *
 * The headings are the exception. A group names a skill by slug and the page
 * reads that skill's real name, so renaming a track updates the sheet instead
 * of quietly disagreeing with it.
 *
 * Pure, and free of any import that would tie it to a request, so every sheet
 * the migrations author can be asserted in the test suite. The read itself
 * lives in curriculum/queries beside the rest of the server-side curriculum.
 */

export type CheatConcept = { name: string; body: string };
export type CheatGroup = { skill: string; concepts: CheatConcept[] };
export type CheatSheet = { idea: string; groups: CheatGroup[] };

/** Null for a topic that has not been written yet, rather than an empty page. */
export function asCheatSheet(value: unknown): CheatSheet | null {
  if (typeof value !== "object" || value === null) return null;

  const sheet = value as Record<string, unknown>;
  if (typeof sheet.idea !== "string" || !Array.isArray(sheet.groups)) return null;
  if (sheet.groups.length === 0) return null;

  return { idea: sheet.idea, groups: sheet.groups as CheatGroup[] };
}

export type LaidOutGroup = { heading: string; concepts: CheatConcept[] };

/**
 * The sheet in the order the curriculum runs, with headings from the skills.
 *
 * Pure, so the ordering can be asserted without a database. A group naming a
 * skill the topic does not have is dropped rather than rendered headless —
 * a sheet that outlives a deleted track should lose that section quietly, not
 * print a blank one.
 */
export function layOut(
  sheet: CheatSheet,
  skills: { slug: string; name: string; sort_order: number }[],
): LaidOutGroup[] {
  const bySlug = new Map(skills.map((skill) => [skill.slug, skill]));

  return sheet.groups
    .flatMap((group) => {
      const skill = bySlug.get(group.skill);
      if (!skill || group.concepts.length === 0) return [];
      return [{ skill, heading: skill.name, concepts: group.concepts }];
    })
    .sort((a, b) => a.skill.sort_order - b.skill.sort_order)
    .map(({ heading, concepts }) => ({ heading, concepts }));
}

/** How many concepts the sheet actually carries. */
export function countConcepts(sheet: CheatSheet): number {
  return sheet.groups.reduce((n, group) => n + group.concepts.length, 0);
}

/**
 * Working through in order.
 *
 * A track is written as an argument: lesson two assumes lesson one, and the
 * fifth skill in a topic assumes the four before it. Letting someone open the
 * middle of that is not freedom, it is handing them the paragraph that made
 * least sense on its own and letting them conclude the writing is bad.
 *
 * So the curriculum unlocks forwards. Not as a reward — nothing here is earned
 * by paying or by waiting, only by reading the thing before it.
 *
 * Two rules keep it from ever taking something away.
 *
 * A lesson someone has already read stays open, whatever is behind it. Anyone
 * who read out of order before this existed keeps everything they had, and a
 * gate that removes access to something already seen would be a bug wearing a
 * feature's clothes.
 *
 * And "done" means read, not practised. Requiring a logged conversation to
 * advance would gate the whole curriculum behind the user's week, which is the
 * one thing the app cannot schedule.
 */

export type Progressable = { id: string };

export type ProgressableSkill = {
  id: string;
  lessons: Progressable[];
};

/**
 * Whether the lesson at this position may be opened.
 *
 * @param lessons In track order.
 * @param index   Position in that order, zero-based.
 * @param readIds Lessons the user has read.
 */
export function isLessonUnlocked(
  lessons: Progressable[],
  index: number,
  readIds: Set<string>,
): boolean {
  if (index <= 0) return true;

  const lesson = lessons[index];
  if (lesson && readIds.has(lesson.id)) return true;

  const previous = lessons[index - 1];
  return previous ? readIds.has(previous.id) : true;
}

/** The first lesson in a track that is not yet open. Null when all are. */
export function firstLockedLesson(
  lessons: Progressable[],
  readIds: Set<string>,
): number | null {
  for (let i = 0; i < lessons.length; i++) {
    if (!isLessonUnlocked(lessons, i, readIds)) return i;
  }
  return null;
}

/** Every lesson in the skill has been read. */
export function isSkillComplete(
  skill: ProgressableSkill,
  readIds: Set<string>,
): boolean {
  return (
    skill.lessons.length > 0 && skill.lessons.every((l) => readIds.has(l.id))
  );
}

/**
 * Whether the skill at this position may be opened.
 *
 * Open if it is the first, if the one before it is finished, or if the user
 * has already been inside this one — that last clause is what stops the gate
 * confiscating progress made before it existed.
 */
export function isSkillUnlocked(
  skills: ProgressableSkill[],
  index: number,
  readIds: Set<string>,
): boolean {
  if (index <= 0) return true;

  const skill = skills[index];
  if (skill?.lessons.some((l) => readIds.has(l.id))) return true;

  const previous = skills[index - 1];
  return previous ? isSkillComplete(previous, readIds) : true;
}

/** Where someone should go instead, when they have landed somewhere locked. */
export function nextOpenLesson(
  lessons: Progressable[],
  readIds: Set<string>,
): number {
  for (let i = 0; i < lessons.length; i++) {
    if (!readIds.has(lessons[i].id) && isLessonUnlocked(lessons, i, readIds)) {
      return i;
    }
  }
  return 0;
}

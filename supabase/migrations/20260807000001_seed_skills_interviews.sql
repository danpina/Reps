-- Topic 2: Interviews. Eight skills, in the order they are worth learning
-- rather than the order they happen — the story comes first because it is the
-- only answer you are guaranteed to be asked for, and because it is the first
-- skill in the topic it is also the free sample.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-your-story',
    'Your story',
    $$"Tell me about yourself" — the question you will always be asked, and the one most people improvise.$$,
    $$The Arc: where you started, what you did with it, why you are in this room. Ninety seconds, and it lands on the job you are applying for.$$,
    $$Nobody is asking for your life. They are asking whether the last few years point at this job.

The Arc is three beats and it never changes: a sentence on where you came from, the middle where you say what you actually did, and a landing that names why you are sitting here. The landing is the load-bearing one. An answer that stops at your last role leaves the interviewer to do the connecting, and they will not do it as generously as you would.

Ninety seconds is the target, and it is shorter than it sounds. The way to fit is not to talk faster but to drop the second-best example: one thing said properly beats three things mentioned.

Rehearse it out loud until it is smooth, then rough it up again. A story delivered without a single hesitation sounds like a story you have told a hundred times, which is exactly what it is, and interviewers discount it accordingly. Keep one honest pause in there.

If you keep one thing: end on them, not on you.$$,
    1
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-evidence',
    'Answering with evidence',
    $$Behavioural questions: turning something you did into something they can believe.$$,
    $$Situation is scenery — two sentences at most. Spend your words on what you personally did, and finish on what changed because you did it.$$,
    $$Every behavioural question is the same question: show me you have done this before.

The structure everyone teaches is fine and nobody notices it when it is done well. What they notice is the ratio. Most people spend two-thirds of the answer setting the scene, because the scene is the comfortable part, and then run out of road before the bit that would have got them hired. Two sentences of scenery, then the action, then the result.

"We" is the word that costs you the job. It is honest, it is how you talk at work, and in an interview it makes you invisible — the interviewer cannot hire the team. Say what the team did once, then say what you did inside it.

Finish on a number wherever an honest one exists, and where it does not, finish on the change: what was true afterwards that was not true before. An answer that ends on the action alone sounds like effort. An answer that ends on the outcome sounds like impact.

If you keep one thing: cut the setup in half, and give the time to the verb.$$,
    2
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-failure',
    'Failure, weakness and gaps',
    $$The questions designed to find the crack: what went wrong, what you are bad at, why the two-year hole.$$,
    $$Name it plainly, say what you changed, stop. A weakness that cost you nothing is not a weakness, and everyone in the room can hear the dodge.$$,
    $$These questions are not traps, and treating them as traps is what springs them.

The interviewer is checking two things: whether you can see yourself clearly, and whether you are safe to give bad news to. A polished non-answer fails both at once. "I work too hard" tells them you will not tell them when a project is late.

The shape that works is short. Name the real thing, in one sentence, without flinching. Say what it cost — an actual consequence, because a weakness with no cost is a boast wearing a hat. Then say what you changed, and be specific enough that it sounds like a thing you did rather than a lesson you learned. Then stop talking, which is the hardest part, because the silence afterwards feels like it needs filling and filling it is what turns a good answer into a confession.

Gaps work the same way. A year out is a fact, not a charge. State it, say what it was for, move on. The apologising is what makes it sound like something to apologise for.

If you keep one thing: they are not deciding whether you have flaws. They know. They are deciding whether you know.$$,
    3
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-craft',
    'Talking about the work',
    $$Explaining what you actually do to a room that ranges from expert to entirely lost.$$,
    $$Pitch it at the least technical person in the room, then offer depth. Volunteering the trade-off you made is the seniority signal.$$,
    $$Depth is not demonstrated by vocabulary. It is demonstrated by knowing which detail matters.

Assume a mixed room, because it usually is: the person who will do your job, the person who will manage you, and someone from another function who is there for the culture read. Explain it so the last of those three follows you, and the first will not think less of you for it — they will think you can talk to stakeholders, which is the thing their team is short of.

Then offer the depth rather than pouring it. "I can go into how the migration actually worked, if that is useful" hands them the control and tells them there is more where that came from. It also stops the answer that runs for four minutes while the panel waits for a gap.

The single strongest move in this whole skill is naming the trade-off. Any decision worth mentioning cost you something — speed for correctness, coverage for time, elegance for a deadline. Juniors describe what they built. Seniors describe what they gave up to build it. Saying the cost out loud is a shortcut to being read as the second kind.

If you keep one thing: say what you chose against.$$,
    4
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-rapport',
    'Screening calls and rapport',
    $$The recruiter call, the first five minutes, and being a person down a phone line.$$,
    $$A screen filters on warmth and fit, not on brilliance. Match the caller's register, answer the question they asked, and keep it to the length a phone call can carry.$$,
    $$The screening call is not a formality, and treating it as one is why good candidates lose before anyone technical has met them.

The person on the phone is usually deciding three things: can you hold a conversation, do you want this specific job, and is there anything alarming. They are not qualified to assess your craft and they know it. Answers pitched at a specialist land as evasive, because they cannot tell whether you answered.

Register matters more here than anywhere else in the process, because there is no face to read. If they are brisk, be brisk. If they are chatty, spend the extra thirty seconds. Mirror the length of their sentences and you will be read as easy to work with, which is the entire brief for this call.

Two specifics. Have a one-line answer to "why this company" that could not be said about any other company — it is the question most people fail, and the bar is low. And when you have finished an answer on the phone, stop, even though the silence is longer down a line. The pause you fill is the pause they were using to type.

If you keep one thing: answer the question they asked, at the length they asked it.$$,
    5
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-your-questions',
    'The questions you ask',
    $$"Any questions for us?" — the ten minutes most candidates waste being polite.$$,
    $$Ask what only this person can answer. A question the careers page answers reads as homework not done; a question about the work reads as someone already doing it.$$,
    $$This is the only part of the hour you control, and most people hand it back.

The test for a good question is simple: could this person answer it, and could the website not? "What does success look like in this role in six months" passes. "What is the culture like" fails, because they will say collaborative and you will both know nothing happened.

Aim your questions at the work itself, in the present tense, as though you already had the job. What is the thing the team keeps having to redo. What would you want the person in this seat to have fixed by Christmas. Asking those makes the interviewer picture you in the seat, and that picture is worth more than any answer you gave earlier.

Ask about the person too, once. People remember conversations, not interrogations, and "what made you stay" is the question that most reliably turns an interview back into a conversation.

Keep one in reserve for the end, and do not ask about money here — that is its own skill and its own moment.

If you keep one thing: the questions you ask are an answer.$$,
    6
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-money',
    'Salary and offers',
    $$Expectations, ranges, and the conversation after "we would like to make you an offer".$$,
    $$Whoever names a number first frames the conversation, so be ready to name one you can justify. A range with a reason beats a number with an apology.$$,
    $$The number is decided by whoever is calmer, and calm here is almost entirely preparation.

Know two figures before you speak to anyone: what the market pays for this work in this place, and the number below which you would say no. The second one is private and never spoken aloud, and it is what stops you negotiating against yourself at nine in the evening.

When asked early for expectations, you have three honest moves: give a researched range, deflect once to learn the band they have budgeted, or ask what the range is. Deflecting twice starts to read as gamesmanship. If you give a range, give it with a reason — the reason is what turns a number into a position rather than a hope.

After an offer, the whole game is asking rather than arguing. "Is there flexibility on the base" is a question, and questions do not put anyone on the defensive. Then say nothing, because the silence after that question is where the flexibility appears.

Say thank you, ask for it in writing, and take a night on it. Nothing you gain by answering immediately is worth what you lose by not thinking.

If you keep one thing: never negotiate against a number nobody has said yet.$$,
    7
  ),
  (
    (select id from public.topics where slug = 'interviews'),
    'interview-closing',
    'Closing and following up',
    $$The last five minutes, the note afterwards, and what to do with a no.$$,
    $$Say plainly that you want it, ask what would stop them, then follow up once with something useful rather than something eager.$$,
    $$Interviews are lost in the last five minutes more often than anyone admits, usually to politeness.

Two sentences close an interview. One is that you want the job, said as a statement rather than implied by enthusiasm — surprisingly few candidates ever say it, and it is the thing the panel repeats to each other afterwards. The other is a question about hesitation: is there anything about my background that gives you pause. It is uncomfortable to ask and it is the only chance you will ever get to answer an objection before it is discussed in a room you are not in.

The follow-up note is short and does one job: it adds something. A link, a better version of an answer you fumbled, a thought about the problem they described. Gratitude alone is fine and forgettable. Do it once. The second nudge undoes the first.

And a no is worth one reply. Thank them, ask what would make you a better candidate next time, and mean it — hiring managers move, remember the person who took it well, and the industry is smaller than it looks from inside a rejection email.

If you keep one thing: ask them what would stop them, while you are still in the room.$$,
    8
  );

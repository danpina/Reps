-- The nine tracks. Lessons are seeded per track in their own migrations.

insert into public.skills (slug, name, description, core_idea, sort_order)
values
  (
    'openers',
    'Openers',
    $$Starting a conversation from nothing, without needing to be clever.$$,
    $$FORD+ — Family, Occupation, Recreation, Dreams, plus Environment. Environment openers are zero-risk and always available.$$,
    1
  ),
  (
    'going-deeper',
    'Going deeper',
    $$Moving a conversation past the exchange of facts.$$,
    $$The Curiosity Ladder: Fact, then Feeling, then Why or Future. Never three facts in a row — that is an interview.$$,
    2
  ),
  (
    'listening-and-labeling',
    'Listening & labeling',
    $$Making someone feel heard well enough that they keep talking.$$,
    $$Repeat back their own word as a statement, then stop talking. People fill silence.$$,
    3
  ),
  (
    'reciprocity',
    'Reciprocity & self-disclosure',
    $$Giving enough of yourself that the other person can meet you.$$,
    $$Asking questions only is its own failure mode — it reads as evasive. Match their disclosure depth, then go one step further.$$,
    4
  ),
  (
    'banter',
    'Banter & humour',
    $$Playfulness that lands, without stepping on anyone.$$,
    $$Playful mislabeling, callbacks, mock-stakes. Tease the situation before you tease the person.$$,
    5
  ),
  (
    'flirting-calibration',
    'Flirting: calibration',
    $$Warmth offered a notch at a time, and checked each time.$$,
    $$Signal, read, adjust. Escalate warmth one notch and check whether it is matched.$$,
    6
  ),
  (
    'reading-disinterest',
    'Reading disinterest & backing off',
    $$Noticing when interest is not mutual, and leaving warmly.$$,
    $$Short answers, closed posture, no reciprocal questions: drop a register, no sulking. Being good at this is what makes flirting safe to practise.$$,
    7
  ),
  (
    'groups',
    'Groups: joining and holding the floor',
    $$Entering a conversation already in progress, and earning a turn in it.$$,
    $$Enter on a laugh or a topic change, never mid-sentence. Contribute before you redirect.$$,
    8
  ),
  (
    'exits',
    'Exits',
    $$Ending a conversation on purpose instead of letting it dissolve.$$,
    $$Warm close plus an optional future hook. Leaving badly undoes a good conversation.$$,
    9
  );

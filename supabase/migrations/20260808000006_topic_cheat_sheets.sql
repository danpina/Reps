-- One page per topic, to print and put in a pocket.
--
-- The recap page already distils a single track, and the skill takeaway is the
-- paragraph you keep from one. Neither is the thing you want on a train before
-- walking into a room: the whole topic, on one side of paper, in the order you
-- would actually need it.
--
-- Authored rather than assembled. Everything else in the curriculum that can be
-- derived from the lessons is derived, precisely so it cannot drift — but a
-- cheat sheet is a curation, and curation is the entire value. Forty moves is
-- a syllabus; sixteen is something you can hold.
--
-- What is not authored is the headings. Each group names a skill by slug and
-- the page reads that skill's real name, so renaming a track updates the sheet
-- rather than silently disagreeing with it.

alter table public.topics add column cheatsheet_json jsonb;

comment on column public.topics.cheatsheet_json is
  'One printable page: { idea, groups: [{ skill, concepts: [{ name, body }] }] }. Null until a topic is written.';

update public.topics set cheatsheet_json = $j${
  "idea": "You were never short of things to say. You are short of the seconds in which to say them, because you spend those deciding. Everything below is one of two things: a way to start before you feel ready, or a way to keep going without having to be interesting.",
  "groups": [
    {
      "skill": "before-you-speak",
      "concepts": [
        { "name": "Four seconds", "body": "That is what a flat opener actually costs. You will carry it for an hour; they have forgotten it by the till." },
        { "name": "Go within twenty", "body": "Once you have noticed an opening, go. Waiting does not settle you down — it raises the price and closes the door." },
        { "name": "Decide it beforehand", "body": "Carry two lines that work in any room. Preparation is what courage looks like from the outside." },
        { "name": "Take the next one", "body": "You will walk past openings. That is fine. Just never let the walk-past be the last thing you did today." }
      ]
    },
    {
      "skill": "openers",
      "concepts": [
        { "name": "Name what you are both in", "body": "The queue, the delay, the noise, the thing on the table. True, obvious, and it risks nothing." },
        { "name": "Full stop, not question mark", "body": "A statement offers something. A question asks for something. Lead with the offer." },
        { "name": "The second line is the one that matters", "body": "Conversations rarely die at your opener. They die when your next line comes out of your head instead of their reply." }
      ]
    },
    {
      "skill": "going-deeper",
      "concepts": [
        { "name": "Fact, feeling, future", "body": "Three rungs. Take a fact they already gave you and ask what it was like — offering two feelings (terrifying or freeing?) is far easier to answer than an open question." },
        { "name": "Two questions, then give", "body": "Three in a row is an interview. Put a reaction or an opinion of your own in before the third." }
      ]
    },
    {
      "skill": "listening-and-labeling",
      "concepts": [
        { "name": "Their word, said flat", "body": "Repeat the loaded word back as a statement. No question mark, no advice, no story of your own." },
        { "name": "Then stop talking", "body": "The silence after a label is the tool. Count two slow beats before you allow yourself to fill it." }
      ]
    },
    {
      "skill": "reciprocity",
      "concepts": [
        { "name": "If it fits on a CV, it is not disclosure", "body": "An opinion you actually hold, something you found hard, or something you want. Those three." },
        { "name": "Match, then add one step", "body": "Meet the depth you were handed, then add one clause you did not have to say. That clause is the whole technique." }
      ]
    },
    {
      "skill": "exits",
      "concepts": [
        { "name": "Leave at the peak", "body": "Conversations do not end, they decline. Go on the first small lull after a good stretch, not the third." },
        { "name": "Reason, warmth, go", "body": "A neutral reason, one specific thing from this actual conversation, then actually leave. Nice to meet you is furniture." }
      ]
    },
    {
      "skill": "banter",
      "concepts": [
        { "name": "Tease the situation first", "body": "Joke about what you are both stuck in. Teasing the person comes after they have teased you, never instead." },
        { "name": "Obviously the wrong size", "body": "Call the five-a-side game an empire. If the word could be meant literally, it is a judgement rather than a joke." }
      ]
    },
    {
      "skill": "groups",
      "concepts": [
        { "name": "Join with your feet", "body": "Step into the circle and say nothing for thirty seconds. Groups make room automatically; interruptions they remember." },
        { "name": "Two before you steer", "body": "Add two things to their subject before you change it. That is the price of admission, and it is cheap." },
        { "name": "Bring in the quiet one", "body": "A name plus a specific question they can definitely answer. The highest-status move available in any group." }
      ]
    }
  ]
}$j$::jsonb
where slug = 'small-talk';

-- Four kinds of rehearsal, instead of one shape for everything.
--
-- Every lesson used to be handed the same container: a fourteen-turn chat with
-- a free text box. For "name something you are both in, say it plainly, then
-- stop" that container contradicts the lesson — the one instruction is to stop,
-- and the interface asks you to keep going. Eight lessons already carried a
-- rehearsal_note apologising that a chat window could not test them, which is a
-- missing mode written out as prose.
--
-- So a lesson now says what kind of exercise it is:
--
--   line    One utterance is the whole move. Checked against authored rules,
--           retried freely, and finished by showing the worked examples.
--   beat    A short fixed sequence, where the structure is the lesson.
--   choice  Read and decide, for the lessons where the right answer is often
--           "do not" — which a free text box cannot distinguish from having
--           ignored the question.
--   scene   An open conversation, for moves that only exist across an arc.
--
-- line and choice never call the model. Both are decidable from what is
-- authored here: the partner's beat is written down, so the words the learner
-- ought to pick up are known before anyone types. That makes a drill free, and
-- a free drill can be repeated, which is the entire mechanism of a drill.

alter table public.lessons
  add column rehearsal_mode text not null default 'scene'
    check (rehearsal_mode in ('line', 'beat', 'choice', 'scene')),
  -- One column, four shapes, read through the parsers in lib/roleplay/modes.
  -- A separate table per mode would be four joins to answer one question.
  add column rehearsal_spec jsonb;

-- The mode is recorded on the rehearsal as well as on the lesson. A rehearsal
-- is a record of what somebody actually did, and re-authoring a lesson later
-- must not retroactively change what an old transcript claims to be. It also
-- means every reader — the list, the limits, the entitlement check — knows
-- whether a row cost money without joining back to the curriculum.
alter table public.roleplays
  add column mode text not null default 'scene'
    check (mode in ('line', 'beat', 'choice', 'scene'));

create index roleplays_user_mode_idx on public.roleplays (user_id, mode);

/**
 * Whether this user may start another rehearsal that costs money.
 *
 * Only the AI modes count now. A free account used to get exactly one
 * rehearsal ever, which was the right rule when every rehearsal was a paid
 * conversation. It is the wrong rule for a drill: the drills are the beginner
 * path, they are the lessons someone who cannot manage a first sentence needs
 * most, and they cost nothing to run. Rationing them protected no budget and
 * taught nobody anything.
 */
create or replace function public.rehearsal_allowed(uid uuid default auth.uid())
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select
    public.is_pro(uid)
    or (
      select count(*)
      from public.roleplays r
      where r.user_id = uid and r.mode in ('beat', 'scene')
    ) < 1;
$$;

-- The insert policy has to see the mode of the row being written, or a free
-- account could open an unlimited number of paid scenes by claiming they were
-- drills. `mode` here is the proposed row's column.
drop policy "Users start rehearsals they are entitled to" on public.roleplays;

create policy "Users start rehearsals they are entitled to"
  on public.roleplays for insert
  to authenticated
  with check (
    (select auth.uid()) = user_id
    and (mode in ('line', 'choice') or public.rehearsal_allowed())
  );

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

-- ---------------------------------------------------------------------------
-- line: one utterance, checked against the beat it answers.
--
-- `says` is the partner's literal words. Where it is absent the learner opens
-- cold, which is correct for the two Openers lessons about walking up to
-- somebody. The `words` lists are drawn from `says`, so a check can only ask
-- for something the partner actually put on the table.
--
-- Two lessons carry no checks at all. Saying something mildly exposing, and
-- describing a thing at obviously the wrong scale, are creative acts, and a
-- rule that claimed to mark them would be lying. They stay in this mode and
-- are taught by example instead — which is what the worked examples are for.
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('openers', 1, 'line', $j${
  "model": {"line":"That machine is really working for its money this morning.","why":"Names the thing you are both stuck waiting on, says it plainly, and then stops."},
  "checks": [
    { "kind": "contains_any", "requirement": "Name something you are both already in",
      "words": ["machine", "coffee", "queue", "wait", "waiting", "morning", "cup", "these", "them", "brew", "filter"] },
    { "kind": "max_sentences", "requirement": "One line. Then stop.", "n": 1 },
    { "kind": "max_words", "requirement": "Keep it plain — under twenty words", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('openers', 3, 'line', $j${
  "model": {"line":"I picked this one because it looked like the least dangerous option.","why":"A statement with something of your own in it, and no question mark for them to have to answer."},
  "checks": [
    { "kind": "no_question", "requirement": "No question mark. Not one." },
    { "kind": "max_sentences", "requirement": "Two sentences at the outside", "n": 2 },
    { "kind": "max_words", "requirement": "Under twenty words", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('going-deeper', 3, 'line', $j${
  "model": {"line":"Was the first month terrifying or freeing?","why":"Asks what it was like rather than the facts around it, and offers two feelings so it is easy to reach for one."},
  "says": "I actually retrained into this at thirty-four. I was doing something completely different before.",
  "checks": [
    { "kind": "offers_a_choice", "requirement": "Offer two feelings, so it is easy to answer" },
    { "kind": "forbids_any", "requirement": "Ask what it was like, not the facts around it",
      "words": ["how long", "how many", "what year", "when did", "where did", "how much", "which company"] },
    { "kind": "max_words", "requirement": "Under sixteen words", "n": 16 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('going-deeper', 4, 'line', $j${
  "model": {"line":"Is this the thing you want, or a step towards something else?","why":"Asks what they want out of the thing they are already telling you about, and points forwards rather than back."},
  "says": "I have been training for it since about January, actually. Most mornings before work.",
  "checks": [
    { "kind": "contains_any", "requirement": "Point forwards — ask what they want out of it",
      "words": ["want", "hope", "next", "after", "aiming", "end up", "point", "dream", "plan"] },
    { "kind": "max_words", "requirement": "Keep the phrasing casual — under twenty words", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('listening-and-labeling', 1, 'line', $j${
  "model": {"line":"Brutal.","why":"Their word, said flat, with nothing after it. It hands the sentence straight back for them to unpack."},
  "says": "The last quarter was fine. A bit brutal, if I am honest.",
  "checks": [
    { "kind": "echoes_any", "requirement": "Use one of their own words",
      "words": ["brutal", "fine", "quarter", "honest"] },
    { "kind": "no_question", "requirement": "Say it flat. Not as a question." },
    { "kind": "no_first_person", "requirement": "Do not turn it back towards you" },
    { "kind": "max_words", "requirement": "Under six words. A label is short.", "n": 6 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('listening-and-labeling', 3, 'line', $j${
  "model": {"line":"That sounds like a strange way to finish something.","why":"Names what is under the flatness and offers it as a guess she is free to correct."},
  "says": "So that is that, then. Eighteen months, signed off, boxes archived.",
  "checks": [
    { "kind": "contains_any", "requirement": "Offer it as a guess — sounds like, seems like",
      "words": ["sounds like", "seems like", "sounds", "seems", "feels like", "you do not sound", "must have"] },
    { "kind": "no_question", "requirement": "A guess, not a question" },
    { "kind": "max_words", "requirement": "Under fourteen words", "n": 14 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reciprocity', 4, 'line', $j${
  "model": {"line":"I am reasonably good at mine and not at all sure I want to be doing it in five years.","why":"An opinion and a doubt rather than a fact. It can be disagreed with, which is what makes it worth saying."},
  "says": "I am in the Leeds office, six years now. We look after onboarding.",
  "checks": [
    { "kind": "first_person", "requirement": "Make it about you" },
    { "kind": "forbids_any", "requirement": "Not more biography — an opinion, a difficulty or a want",
      "words": ["i work at", "i work for", "years now", "my team", "my role", "i am based"] },
    { "kind": "min_words", "requirement": "Say enough to be disagreed with", "n": 8 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('banter', 2, 'line', $j${
  "model": {"line":"So it is less a compost heap and more a small pet.","why":"Takes his own material and describes it at obviously the wrong scale, warmly enough that it cannot be taken straight."},
  "says": "I check the temperature of the compost heap. Twice a week. This is normal, by the way.",
  "checks": [
    { "kind": "echoes_any", "requirement": "Build on what they said rather than importing a joke",
      "words": ["temperature", "compost", "twice", "week", "normal", "heap", "check"] },
    { "kind": "max_words", "requirement": "Short enough that they can play along", "n": 18 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('groups', 5, 'line', $j${
  "model": {"line":"Sam, you drove that route last year, didn't you?","why":"Uses his name and asks something he can definitely answer, without making his silence the subject."},
  "says": "...so we thought the Thursday flight, then hire a car from the airport.",
  "checks": [
    { "kind": "contains_any", "requirement": "Use their name", "words": ["sam"] },
    { "kind": "contains_any", "requirement": "Ask something they can definitely answer",
      "words": ["did you", "didn't you", "did not you", "were you", "have you", "you did", "weren't you", "were not you"] },
    { "kind": "max_words", "requirement": "Under sixteen words — no spotlight", "n": 16 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('exits', 2, 'line', $j${
  "model": {"line":"I am going to find my friend. That paperback shelf has made my night.","why":"A reason that is not about them, one specific thing from the conversation, and then you actually go."},
  "says": "...and the second shelf is still, to this day, held up by a paperback.",
  "checks": [
    { "kind": "contains_any", "requirement": "Give a reason that is not about them",
      "words": ["i am going", "i should", "i need to", "i must", "i will go", "going to go", "let me go", "i had better"] },
    { "kind": "echoes_any", "requirement": "Say one specific warm thing from this conversation",
      "words": ["shelf", "paperback", "second shelf", "held up"] },
    { "kind": "max_sentences", "requirement": "Reason, warmth, go. Three sentences at most.", "n": 3 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('exits', 3, 'line', $j${
  "model": {"line":"Let me know how Thursday goes. I am invested now.","why":"Tied to something he actually said, and it asks for nothing on the spot."},
  "says": "I am going to have a proper go at it at home before Thursday.",
  "checks": [
    { "kind": "echoes_any", "requirement": "Tie it to something they actually said",
      "words": ["thursday", "home", "proper go", "go at it"] },
    { "kind": "forbids_any", "requirement": "Ask for nothing on the spot",
      "words": ["your number", "give me your", "are you free", "can we meet", "what is your"] },
    { "kind": "max_sentences", "requirement": "Still a clean exit — three sentences at most", "n": 3 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- beat: a fixed sequence, with the instruction for each turn named as it
-- arrives. "Two questions then something of your own" is three turns, and
-- expecting somebody to hold that shape in their head while also thinking of
-- something to say is how the shape gets dropped.
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('openers', 4, 'beat', $j${
  "turns": [
    { "instruction": "Open in whichever room you are already standing in." },
    { "instruction": "Now use something they said to step into a different room — Occupation into Recreation, say." },
    { "instruction": "Stay in the new room for one more turn rather than bouncing straight back." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('openers', 5, 'beat', $j${
  "turns": [
    { "instruction": "Open with anything reasonable. This turn is not the one being marked." },
    { "instruction": "Now take the most specific word in their reply and go towards it. Do not start a new subject." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('going-deeper', 1, 'beat', $j${
  "turns": [
    { "instruction": "Ask something at fact level — what, where, which." },
    { "instruction": "One rung up: from the fact to what it was like." },
    { "instruction": "One more, if they left you room. Do not skip a rung to get there." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('going-deeper', 2, 'beat', $j${
  "turns": [
    { "instruction": "Ask them something. Anything that gets them talking." },
    { "instruction": "Ask a second one. Two in a row is still fine — it is the third that turns it into an interview." },
    { "instruction": "Now put something of your own in — a reaction, an opinion, a small piece of you. No question this time." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('listening-and-labeling', 2, 'beat', $j${
  "turns": [
    { "instruction": "Label something they said. Their word, said flat." },
    { "instruction": "They have replied. Do not fill the gap — say the shortest thing that keeps it open, or end the scene here." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('listening-and-labeling', 4, 'beat', $j${
  "turns": [
    { "instruction": "Guess at the feeling under what they said, even though you are not sure." },
    { "instruction": "They have corrected you. Take the word they used and give it back to them." },
    { "instruction": "Carry on from their correction rather than defending the guess." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reciprocity', 1, 'beat', $j${
  "turns": [
    { "instruction": "Ask them something that invites more than a yes." },
    { "instruction": "Ask one more, and notice that you still have not given them anything." },
    { "instruction": "Before you ask a third, give them something real about you." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reciprocity', 2, 'beat', $j${
  "turns": [
    { "instruction": "Ask something that invites more than a fact." },
    { "instruction": "Read how deep what they handed you was, and put something of yours down at the same level." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reciprocity', 3, 'beat', $j${
  "turns": [
    { "instruction": "Match what they have just offered you." },
    { "instruction": "Now add one clause you did not have to say, and hand it back to them." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('banter', 1, 'beat', $j${
  "turns": [
    { "instruction": "Joke about the thing you are both stuck in. Not about them." },
    { "instruction": "They have replied. Stay on the situation — do not aim this one at them either." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('banter', 3, 'beat', $j${
  "turns": [
    { "instruction": "Pick something completely trivial and treat it as a crisis." },
    { "instruction": "Commit. Do not wink at it and do not explain the joke." },
    { "instruction": "Let them win it, or let it collapse. Either is a good ending." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('banter', 5, 'beat', $j${
  "turns": [
    { "instruction": "Make a joke. Any joke." },
    { "instruction": "Whatever came back, acknowledge it in three words or fewer and carry straight on." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('groups', 2, 'beat', $j${
  "turns": [
    { "instruction": "They have just laughed. Speak into the space right after it." },
    { "instruction": "Extend what they were already talking about rather than starting something new." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('groups', 4, 'beat', $j${
  "turns": [
    { "instruction": "Take a real turn. Make your point properly rather than hedging it." },
    { "instruction": "Now land it and hand it on deliberately, to someone specific." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('exits', 4, 'beat', $j${
  "turns": [
    { "instruction": "Say one quiet thing to one person." },
    { "instruction": "Now go. No announcement to the group." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- choice: read the situation and decide.
--
-- These are the six lessons where the correct answer is frequently to do
-- nothing, and where a text box cannot tell a good read from a learner who
-- never made one. Four of them already carried a rehearsal_note admitting the
-- chat window could not test them.
--
-- Every wrong option is a real mistake somebody makes, and every note says why
-- rather than that it was wrong.
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('openers', 2, 'choice', $j${
  "beats": [
    {
      "situation": "A platform on a delayed line. The woman next to you has headphones in, is turned away from the concourse, and has her bag already up on her shoulder.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Say something about the delay anyway.", "correct": false,
          "note": "Headphones, turned away, bag up. That is three signals and none of them are an opening. She is not being unfriendly; she is mid-journey." },
        { "text": "Wait. Read again in a minute, and let it go if nothing has changed.", "correct": true,
          "note": "That is the move. Availability is a precondition, not an obstacle to talk your way through." },
        { "text": "Move into her eyeline so she takes the headphones out.", "correct": false,
          "note": "Making someone disengage in order to be talked to is the exact opposite of checking whether they are available." }
      ]
    },
    {
      "situation": "Same platform, five minutes later. The man beside you puts his phone in his pocket, looks up at the board, then glances along the platform at the other people waiting.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Say something about the wait.", "correct": true,
          "note": "Phone away, eyes up, already scanning the platform. That is about as available as a stranger gets." },
        { "text": "Wait for a clearer signal than that.", "correct": false,
          "note": "There is not a clearer one coming. Holding out for certainty is how the whole skill quietly becomes never opening at all." },
        { "text": "Nothing — he did not look at you specifically.", "correct": false,
          "note": "Being looked at is not the signal. Being unoccupied is." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('going-deeper', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You are two minutes into a queue at a sandwich shop. The person ahead of you mentions they have just moved up from Bristol for work. There are three people left in front of them.",
      "prompt": "Where do you take it?",
      "options": [
        { "text": "Ask what made them decide to leave.", "correct": false,
          "note": "That is a top-rung question with ninety seconds left on the clock. They will either give you a thin answer or feel rude for not giving you a real one." },
        { "text": "Say something light about the move and leave it there.", "correct": true,
          "note": "Right size for the time available. Shallow and warm is a complete conversation, not a failed deep one." },
        { "text": "Ask how they are finding it compared to Bristol.", "correct": false,
          "note": "Closer, but still a question that wants a considered answer from somebody about to order lunch." }
      ]
    },
    {
      "situation": "A long train journey. You have been talking on and off for forty minutes and they have just mentioned, unprompted, that they are between jobs.",
      "prompt": "Where do you take it?",
      "options": [
        { "text": "Ask what they want the next one to be.", "correct": true,
          "note": "Time, warmth and an unprompted disclosure. All three conditions are met, and the question points forwards rather than asking them to justify the past." },
        { "text": "Keep it light and change the subject.", "correct": false,
          "note": "They raised it themselves, with an hour of journey left. Steering away now reads as not wanting to hear it." },
        { "text": "Ask what happened at the last one.", "correct": false,
          "note": "Backwards rather than forwards, and the one version of this question they may not want to answer to a stranger." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reading-disinterest', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Ten minutes into a conversation at a party. They have answered everything you asked, pleasantly, in about a sentence each. They have not asked you anything. Their body is angled slightly towards the rest of the room.",
      "prompt": "How do you read it?",
      "options": [
        { "text": "Two signals — no questions back, and turned away. Start winding it down.", "correct": true,
          "note": "That is counting rather than interpreting. Pleasant answers are not a signal; the absence of any question back is the strongest one there is." },
        { "text": "They are being friendly, so it is going fine.", "correct": false,
          "note": "Politeness is the default setting, not evidence. Reading it as interest is the single most common mistake this track exists to fix." },
        { "text": "They are shy. Ask something easier to open them up.", "correct": false,
          "note": "Possible, and it does not change what you do. Working harder against three signals is how a pleasant conversation becomes an uncomfortable one." }
      ]
    },
    {
      "situation": "The same party. They have answered in about a sentence each and have not asked you anything either — but they are facing you squarely, and twice now they have picked up something you said earlier.",
      "prompt": "How do you read it?",
      "options": [
        { "text": "One signal, not three. Carry on.", "correct": true,
          "note": "Short answers on their own are a personality, not a verdict. Facing you and remembering what you said are both attention." },
        { "text": "No questions back means no interest. Wind it down.", "correct": false,
          "note": "This is the mirror mistake: counting one signal as a verdict. The lesson is to count them, which cuts both ways." },
        { "text": "Ask directly whether they want to keep talking.", "correct": false,
          "note": "It makes the conversation the subject of the conversation, which ends it either way." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('reading-disinterest', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have been talking for twenty minutes and genuinely cannot read it. They are warm and engaged, and they have also mentioned a busy morning tomorrow twice.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Treat it as a no, stay exactly as warm, and let the evening go where it goes.", "correct": true,
          "note": "The default when you cannot tell. It costs you nothing, and it is the only reading that is comfortable for both of you if you are wrong." },
        { "text": "Ask something that would settle it one way or the other.", "correct": false,
          "note": "Resolving it is your problem, not theirs. Making someone answer a question they have been avoiding is pressure however lightly it is put." },
        { "text": "Cool off slightly so you are not caught out.", "correct": false,
          "note": "That is the sulk in its early form. Warmth that withdraws the moment it is not certain of a return was never warmth." }
      ]
    },
    {
      "situation": "Later, the same conversation. You are still not sure. They have stayed, twice, at points where leaving would have been easy.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Nothing different. Stay warm and keep enjoying it.", "correct": true,
          "note": "Staying when leaving was easy is real evidence, and it still does not oblige you to do anything about it tonight." },
        { "text": "Read the staying as a yes and step the warmth up two notches.", "correct": false,
          "note": "One piece of evidence, two notches. That is the arithmetic that makes people uncomfortable." },
        { "text": "Decide it is unreadable and leave.", "correct": false,
          "note": "Defaulting to no means not pursuing it, not punishing it by going." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-calibration', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Their friends are leaving and have said so twice. They have said warm, complimentary things all evening. They pick up their coat.",
      "prompt": "What does that tell you?",
      "options": [
        { "text": "Watch what they do next. The coat is not the answer; whether they go is.", "correct": true,
          "note": "This is the whole lesson. Warm words are cheap and pleasant people produce them freely. What someone does with a chance to leave is not cheap." },
        { "text": "The compliments were real, so the coat means nothing.", "correct": false,
          "note": "Reading words over actions, which is exactly the error. Wishful reading always sounds like generosity from the inside." },
        { "text": "They are leaving. It was politeness all along.", "correct": false,
          "note": "Too fast. They have picked up a coat, not walked out — and their friends leaving is a fact about their friends." }
      ]
    },
    {
      "situation": "They put the coat over their arm, say goodbye to their friends, and sit back down.",
      "prompt": "What does that tell you?",
      "options": [
        { "text": "More than everything they said all evening.", "correct": true,
          "note": "They had a clean exit, with cover, and did not take it. That is the signal that counts." },
        { "text": "About the same as the compliments did.", "correct": false,
          "note": "Not the same at all. One cost them nothing and the other cost them their lift home." },
        { "text": "Nothing yet — say the plain thing and find out.", "correct": false,
          "note": "It does tell you something, and this is the read that earns the plain thing later rather than replacing it." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-calibration', 5, 'choice', $j${
  "beats": [
    {
      "situation": "A good conversation, an hour long. You have enjoyed it enormously. They have been friendly and funny, have not stepped towards you once, and have twice mentioned somebody they are seeing at the weekend.",
      "prompt": "Do you say the plain thing?",
      "options": [
        { "text": "No. The conditions are not met, and a good conversation is already the whole prize.", "correct": true,
          "note": "This lesson only counts when it has been earned both ways. Said here it converts an hour they enjoyed into a moment they have to manage." },
        { "text": "Yes, kindly, so there is no ambiguity.", "correct": false,
          "note": "There was no ambiguity. Removing it is a service to you, not to them." },
        { "text": "Hint at it and see what happens.", "correct": false,
          "note": "A hint against two clear signals is the plain thing with deniability bolted on, which is the version that ages worst." }
      ]
    },
    {
      "situation": "A different evening. It has been warm in both directions for an hour, they have stepped towards you twice, and they stayed when their friends went.",
      "prompt": "Do you say the plain thing?",
      "options": [
        { "text": "Yes, plainly, and phrased so declining costs them nothing.", "correct": true,
          "note": "Earned, mutual, and easy to decline. The escape route is what makes it a question rather than a demand." },
        { "text": "Yes, and make it clear how much the evening meant.", "correct": false,
          "note": "Weight is the thing to avoid. The heavier it is, the harder it is to say no to, and a yes that was hard to refuse is not a yes." },
        { "text": "No — leave it and hope they raise it.", "correct": false,
          "note": "Every condition is met. Requiring them to do the exposed part is not restraint, it is offloading the risk." }
      ]
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- scene: unchanged, and correct for these thirteen. A callback cannot be
-- rehearsed without a conversation long enough to call back into, and reading
-- a register drop needs a register to have been established first.
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('listening-and-labeling', 5, 'scene', null);
select pg_temp.set_mode('reciprocity', 5, 'scene', null);
select pg_temp.set_mode('banter', 4, 'scene', null);
select pg_temp.set_mode('groups', 1, 'scene', null);
select pg_temp.set_mode('groups', 3, 'scene', null);
select pg_temp.set_mode('exits', 1, 'scene', null);
select pg_temp.set_mode('exits', 5, 'scene', null);
select pg_temp.set_mode('reading-disinterest', 2, 'scene', null);
select pg_temp.set_mode('reading-disinterest', 3, 'scene', null);
select pg_temp.set_mode('reading-disinterest', 4, 'scene', null);
select pg_temp.set_mode('flirting-calibration', 1, 'scene', null);
select pg_temp.set_mode('flirting-calibration', 2, 'scene', null);
select pg_temp.set_mode('flirting-calibration', 4, 'scene', null);

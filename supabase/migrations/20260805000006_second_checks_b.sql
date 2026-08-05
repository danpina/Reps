-- Second comprehension beat for tracks 4 to 6.

create or replace function pg_temp.add_check(
  skill_slug text, lesson_order integer, payload jsonb
) returns void language sql as $fn$
  update public.lessons l
    set checks_json = l.checks_json || jsonb_build_array(payload)
    from public.skills s
    where l.skill_id = s.id
      and s.slug = skill_slug
      and l.sort_order = lesson_order;
$fn$;

-- Track 4: Reciprocity & self-disclosure -------------------------------------

select pg_temp.add_check('reciprocity', 1, $j${
  "prompt": "You have asked a lot and given nothing, and you notice. What is the least awkward repair?",
  "options": [
    { "text": "Apologise for interrogating them.", "correct": false, "note": "Names it as a fault and asks them to say it was fine. More awkward than the imbalance was." },
    { "text": "Stop asking questions entirely.", "correct": false, "note": "Fixes the count and leaves them holding a conversation you have gone quiet in." },
    { "text": "Ask them to ask you something.", "correct": false, "note": "Hands them a task. Reciprocity you have requested is not reciprocity." },
    { "text": "Answer the question you just asked them.", "correct": true, "note": "Neat and almost invisible. You have shown your own answer, which balances things without anyone naming it." }
  ],
  "explain": "The cleanest repair is answering your own question. It gives without announcing that you noticed you had not."
}$j$::jsonb);

select pg_temp.add_check('reciprocity', 2, $j${
  "prompt": "Someone tells you their dog died last month. What does matching the depth look like?",
  "options": [
    { "text": "Acknowledging the weight and leaving it with them.", "correct": true, "note": "Matching depth does not always mean matching with a story. Sometimes the right-sized response is recognising what they just handed you." },
    { "text": "Telling them about a pet you lost.", "correct": false, "note": "The instinct, and it moves the subject to you at the moment they least want that." },
    { "text": "Asking what breed it was.", "correct": false, "note": "A detail question answering a disclosure. It declines the offer politely." },
    { "text": "Saying you are sorry and changing the subject.", "correct": false, "note": "Sympathy plus an exit. It reads as not wanting to hear about it." }
  ],
  "explain": "Meeting depth sometimes means matching with your own, and sometimes just means not flinching away from theirs."
}$j$::jsonb);

select pg_temp.add_check('reciprocity', 3, $j${
  "prompt": "Which addition turns a match into a step further?",
  "options": [
    { "text": "A second example of the same thing.", "correct": false, "note": "More volume at the same depth. The conversation stays exactly level." },
    { "text": "What you thought it meant about you at the time.", "correct": true, "note": "Interpretation is the step. Facts stay level; what you concluded about yourself goes down a floor." },
    { "text": "A more precise version of the same fact.", "correct": false, "note": "Detail is not depth. Being specific about something safe keeps it safe." },
    { "text": "A question about their experience.", "correct": false, "note": "Turns it back to them without having gone anywhere yourself." }
  ],
  "explain": "The step past is nearly always the interpretation: not what happened, but what you took it to mean about you."
}$j$::jsonb);

select pg_temp.add_check('reciprocity', 4, $j${
  "prompt": "Which of these is closest to real disclosure?",
  "options": [
    { "text": "I am quite an anxious person.", "correct": false, "note": "It sounds revealing and is a label, applied by you, with nothing behind it. Labels are cheaper than examples." },
    { "text": "I have three sisters.", "correct": false, "note": "Biography. It could be printed on a form." },
    { "text": "I turned down a job last year and I still think about it.", "correct": true, "note": "A decision, a doubt, and an admission that it is unresolved. All three cost something to say." },
    { "text": "I like my job most days.", "correct": false, "note": "An opinion, and the safest possible one. Nobody could disagree or find it interesting." }
  ],
  "explain": "A self-description is not a disclosure. A specific thing you did and still have feelings about is."
}$j$::jsonb);

select pg_temp.add_check('reciprocity', 5, $j${
  "prompt": "How do you tell an actual overshare from having merely spooked yourself?",
  "options": [
    { "text": "By how exposed you feel afterwards.", "correct": false, "note": "The least reliable signal available. Your discomfort says nothing about theirs." },
    { "text": "By how personal the subject was.", "correct": false, "note": "Very personal things land fine all the time. It is proportion to the moment that matters, not subject matter." },
    { "text": "By whether they responded at length.", "correct": false, "note": "Ambiguous. A long careful response can be exactly what an overshare produces." },
    { "text": "By whether their register changed.", "correct": true, "note": "Watch them rather than yourself. If they carried on at the same warmth, nothing happened." }
  ],
  "explain": "Read the other person, not your own pulse. Most oversharing is imagined by the person doing it."
}$j$::jsonb);

-- Track 5: Banter & humour ---------------------------------------------------

select pg_temp.add_check('banter', 1, $j${
  "prompt": "You have been talking to someone for half an hour and it has gone well. Can you tease them now?",
  "options": [
    { "text": "Yes, if they have teased you first.", "correct": true, "note": "Their tease is the licence, and the clearest one available. It says jokes between us are safe." },
    { "text": "Yes, half an hour is plenty.", "correct": false, "note": "Time helps and does not grant permission. Plenty of half-hour conversations stay formal throughout." },
    { "text": "No, wait until you know them properly.", "correct": false, "note": "Over-cautious. Waiting for certainty means never being playful with anyone new." },
    { "text": "Yes, as long as it is clearly affectionate.", "correct": false, "note": "Affection helps and does not settle it. A warm tease from someone who has not earned it still lands as presumption." }
  ],
  "explain": "Being teased is the licence to tease. Until then, aim at the situation."
}$j$::jsonb);

select pg_temp.add_check('banter', 2, $j${
  "prompt": "Someone says they once ran a marathon. Which mislabel works?",
  "options": [
    { "text": "So you are one of those people.", "correct": false, "note": "A category rather than an exaggeration, and one with a real edge. It can be heard as a genuine judgement." },
    { "text": "So basically an Olympian.", "correct": true, "note": "Absurdly too big, obviously untrue, and it hands them an easy modest reply." },
    { "text": "You must be very disciplined.", "correct": false, "note": "A straight compliment. Warm, and not a joke, so there is nothing to play with." },
    { "text": "I could never be bothered with that.", "correct": false, "note": "About you rather than them, and slightly dismissive of something they are proud of." }
  ],
  "explain": "The joke is the size of the gap. If the word could be meant literally, it is a judgement rather than a mislabel."
}$j$::jsonb);

select pg_temp.add_check('banter', 3, $j${
  "prompt": "Your mock-stakes joke gets a real, slightly defensive answer. What happened?",
  "options": [
    { "text": "They have no sense of humour.", "correct": false, "note": "The conclusion that stops you learning anything. It is nearly always the subject rather than the person." },
    { "text": "You did not commit hard enough.", "correct": false, "note": "Committing harder to a joke about something they care about makes it worse." },
    { "text": "You picked something they actually care about.", "correct": true, "note": "Mock stakes only work on subjects with no real stakes. A defensive answer means you found one that mattered." },
    { "text": "It was too early in the conversation.", "correct": false, "note": "Mock stakes on trivia work within seconds. Timing is rarely the problem here." }
  ],
  "explain": "A defensive answer is information: that subject had real stakes. Drop it and pick something emptier."
}$j$::jsonb);

select pg_temp.add_check('banter', 4, $j${
  "prompt": "What makes a callback work?",
  "options": [
    { "text": "That it was funny the first time.", "correct": false, "note": "Helps and is not the mechanism. Callbacks land on things that were barely jokes at all." },
    { "text": "That you delivered it well.", "correct": false, "note": "Delivery matters least here. A flat callback still lands." },
    { "text": "That the whole group heard the original.", "correct": false, "note": "A callback only the two of you understand is stronger, not weaker." },
    { "text": "That enough time passed for it to count as memory.", "correct": true, "note": "The gap is the whole thing. It proves you kept something, which is what people actually respond to." }
  ],
  "explain": "A callback is evidence of attention. Without a gap it is just repetition."
}$j$::jsonb);

select pg_temp.add_check('banter', 5, $j${
  "prompt": "Which recovery from a dead joke reads as most comfortable?",
  "options": [
    { "text": "A shrug and straight back to what they were saying.", "correct": true, "note": "It costs you nothing visibly, which is what tells them your ease does not depend on their laughter." },
    { "text": "Laughing at your own joke to cover it.", "correct": false, "note": "The most visible kind of rescue, and it makes the failure larger." },
    { "text": "Immediately trying a better one.", "correct": false, "note": "Now you are performing, and the second one carries the weight of the first." },
    { "text": "Saying that came out wrong.", "correct": false, "note": "Mild self-correction that still spends another beat on the joke." }
  ],
  "explain": "The recovery is about visible unbotheredness. Anything that spends more time on the joke enlarges it."
}$j$::jsonb);

-- Track 6: Flirting: calibration ---------------------------------------------

select pg_temp.add_check('flirting-calibration', 1, $j${
  "prompt": "Which of these is one notch rather than three?",
  "options": [
    { "text": "Telling them they are the most interesting person here.", "correct": false, "note": "A large claim that requires a response. It is a declaration wearing a compliment's clothes." },
    { "text": "Saying you are glad you got stuck at this end of the table.", "correct": true, "note": "Warm, specific to them, and entirely survivable as ordinary friendliness if that is all they want it to be." },
    { "text": "Asking whether they are seeing anyone.", "correct": false, "note": "Not a notch at all. It makes the frame explicit and asks them to answer inside it." },
    { "text": "Finding a reason to touch their arm.", "correct": false, "note": "Physical escalation is several notches, and much harder to walk back." }
  ],
  "explain": "A notch is deniable. If it cannot be received as ordinary friendliness, it is a declaration."
}$j$::jsonb);

select pg_temp.add_check('flirting-calibration', 2, $j${
  "prompt": "You say something warm and they laugh and change the subject. What is that?",
  "options": [
    { "text": "Shyness. Try again more clearly.", "correct": false, "note": "Reframes a no as an obstacle, which is exactly what this approach exists to prevent." },
    { "text": "Encouragement, since they laughed.", "correct": false, "note": "Laughter is the cheapest signal there is. What they did with the warmth is the real answer." },
    { "text": "A soft no. Return to friendly.", "correct": true, "note": "The laugh is politeness and the subject change is the answer. Both together are a decline, gently done." },
    { "text": "Neutral. Not enough to read either way.", "correct": false, "note": "It is a clear signal. Treating it as neutral is how people end up pressing." }
  ],
  "explain": "A laugh plus a subject change is a decline. The laugh softens it; the subject change is the content."
}$j$::jsonb);

select pg_temp.add_check('flirting-calibration', 3, $j${
  "prompt": "Which behaviour is the strongest evidence of real interest?",
  "options": [
    { "text": "They tell you they are enjoying talking to you.", "correct": false, "note": "Warm words, and the cheapest signal available. Politeness produces these for free." },
    { "text": "They stand closer than they need to.", "correct": false, "note": "Suggestive, and heavily confounded by noise, crowding and how tactile a person simply is." },
    { "text": "They ask you a lot of questions.", "correct": false, "note": "Good evidence of engagement, and some people are curious about everyone." },
    { "text": "They come back after the conversation has already ended.", "correct": true, "note": "Restarting something that had finished is entirely voluntary. Nobody does that out of politeness." }
  ],
  "explain": "Watch what costs them something. Coming back after an exit is the least deniable signal there is."
}$j$::jsonb);

select pg_temp.add_check('flirting-calibration', 4, $j${
  "prompt": "You leave a pause and they fill it with something about themselves. What does that tell you?",
  "options": [
    { "text": "They are willing to carry half of this.", "correct": true, "note": "Filling a pause with something of their own is investment, which is what you were testing for." },
    { "text": "Nothing much. People dislike silence.", "correct": false, "note": "True in general, and here they chose to fill it with disclosure rather than a remark about the room." },
    { "text": "They were waiting for you to stop talking.", "correct": false, "note": "A reading that fits an interruption, not a pause you deliberately left." },
    { "text": "They are uncomfortable and covering it.", "correct": false, "note": "Possible, and unlikely when what fills the gap is personal rather than filler." }
  ],
  "explain": "What someone puts into a silence you left is the clearest measure of how invested they are."
}$j$::jsonb);

select pg_temp.add_check('flirting-calibration', 5, $j${
  "prompt": "Which version makes a no easiest to give?",
  "options": [
    { "text": "We should do this again sometime.", "correct": false, "note": "So vague that declining means reading between the lines. Ambiguity is not kindness here." },
    { "text": "I would like to see you again, if you would.", "correct": true, "note": "Clear about what you want and ends with an explicit door. If you would does all the work." },
    { "text": "Are you free on Thursday?", "correct": false, "note": "Specific, and it forces an excuse rather than an answer." },
    { "text": "I do not suppose you would want to get a drink?", "correct": false, "note": "Pre-emptively apologetic, which makes accepting awkward and declining feel unkind." }
  ],
  "explain": "Be clear about the ask and explicit that no is available. Vagueness is not politeness."
}$j$::jsonb);

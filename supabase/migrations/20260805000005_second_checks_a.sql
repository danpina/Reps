-- Second comprehension beat for tracks 1 to 3.
--
-- The first check on each card tests whether the idea was understood. These
-- test whether it can be applied to a situation the card did not describe.

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

-- Track 1: Openers -----------------------------------------------------------

select pg_temp.add_check('openers', 1, $j${
  "prompt": "You open with a remark about the rain. They say yes, then nothing. What went wrong?",
  "options": [
    { "text": "Nothing necessarily. Some openers land on someone with nothing to add.", "correct": true, "note": "The most likely answer, and the one people skip. A dead opener is usually the moment, not the line. Try another one later." },
    { "text": "The weather is too boring to open with.", "correct": false, "note": "Weather is weak because it is generic, but plenty of dull openers work fine. One flat response is not evidence." },
    { "text": "You should have asked a question instead.", "correct": false, "note": "A question would have forced a longer answer, which is not the same as a better conversation." },
    { "text": "You picked someone who did not want to talk.", "correct": false, "note": "Possible, and you cannot know from one reply. Reading that takes more than a single flat answer." }
  ],
  "explain": "Most openers that go nowhere have not failed. They have simply landed on someone who had nothing to say about that particular thing."
}$j$::jsonb);

select pg_temp.add_check('openers', 2, $j${
  "prompt": "Someone has headphones on but is staring into space rather than working. Available or not?",
  "options": [
    { "text": "Not available. Headphones are the signal.", "correct": false, "note": "Headphones plus momentum is a no. Headphones plus an unfocused stare is closer to a yes." },
    { "text": "Available. Their attention is unspent, whatever is in their ears.", "correct": true, "note": "Availability is about where attention is. Someone staring into space has attention going spare and often welcomes the interruption." },
    { "text": "Impossible to tell without more information.", "correct": false, "note": "You have the information that matters. Waiting for certainty means never opening." },
    { "text": "Available, but only for something very brief.", "correct": false, "note": "A reasonable instinct that under-reads the signal. Someone idle is often glad of a real conversation." }
  ],
  "explain": "Read the attention, not the accessories. Headphones on a busy person mean no; on an idle one they mean very little."
}$j$::jsonb);

select pg_temp.add_check('openers', 3, $j${
  "prompt": "Which statement opener gives the other person the most to work with?",
  "options": [
    { "text": "This place is nice.", "correct": false, "note": "A statement, and an empty one. There is nothing here to agree with, argue with or pick up." },
    { "text": "I have been here before.", "correct": false, "note": "A fact about you with no view attached. It invites a polite acknowledgement and nothing else." },
    { "text": "I always feel underdressed in places with this much glass.", "correct": true, "note": "A view, mildly self-deprecating, specific. They can agree, disagree, or tell you about a worse venue." },
    { "text": "It is busier than I expected.", "correct": false, "note": "Serviceable and true, but it points at the room rather than saying anything about you." }
  ],
  "explain": "A statement works when it carries a view. Without one it is just a fact said out loud."
}$j$::jsonb);

select pg_temp.add_check('openers', 4, $j${
  "prompt": "Someone mentions their commute takes ninety minutes each way. Which room does that most naturally open onto?",
  "options": [
    { "text": "Occupation, since it is about their job.", "correct": false, "note": "It is adjacent to work, and that is the room the conversation is already stuck in." },
    { "text": "Family, since a long commute usually means where they live.", "correct": false, "note": "A leap, and into the room you should let them open." },
    { "text": "Recreation, since it is about what they do with their day.", "correct": false, "note": "Closer, but ninety minutes on a train is not recreation to anyone." },
    { "text": "Dreams, since nobody plans to do that forever.", "correct": true, "note": "The interesting question is what they are hoping changes. Long commutes are always temporary in someone's head." }
  ],
  "explain": "Any complaint about a current arrangement is a door into Dreams. Nobody intends their worst arrangement to be permanent."
}$j$::jsonb);

select pg_temp.add_check('openers', 5, $j${
  "prompt": "They say: I have just come from the dentist, which explains the mood. Which word is the invitation?",
  "options": [
    { "text": "Mood.", "correct": true, "note": "They have named a feeling and made a joke of it. Going there gets you a person rather than an appointment." },
    { "text": "Dentist.", "correct": false, "note": "The obvious noun, and the least interesting. Everyone has a dentist story and nobody wants to hear one." },
    { "text": "Just.", "correct": false, "note": "Timing, which is a detail. It leads to when rather than what it was like." },
    { "text": "Explains.", "correct": false, "note": "A connective, not content. There is nothing behind it to pick up." }
  ],
  "explain": "The loaded word is nearly always the one with feeling attached, not the one carrying the facts."
}$j$::jsonb);

-- Track 2: Going deeper ------------------------------------------------------

select pg_temp.add_check('going-deeper', 1, $j${
  "prompt": "They say they have been at the same company for eleven years. What is the shortest climb?",
  "options": [
    { "text": "Ask whether they have thought about leaving.", "correct": false, "note": "A jump to the third rung from a standing start, and mildly loaded. It can read as an accusation of being stuck." },
    { "text": "Ask what has kept them there.", "correct": true, "note": "Takes their own fact and asks what it is like from the inside. Warm, easy to answer, and it gets you a real answer." },
    { "text": "Ask what the company does.", "correct": false, "note": "Another fact, and one they have answered a hundred times." },
    { "text": "Ask how the company has changed.", "correct": false, "note": "Better, and it is still about the company rather than about them." }
  ],
  "explain": "The shortest climb is always their fact plus what it was like. Here that is what has kept you rather than how long have you been there."
}$j$::jsonb);

select pg_temp.add_check('going-deeper', 2, $j${
  "prompt": "You have asked two questions. Which of these counts as putting something in?",
  "options": [
    { "text": "That is interesting.", "correct": false, "note": "A reaction with no content. It acknowledges without offering, so the roles do not change." },
    { "text": "Really? Say more.", "correct": false, "note": "This is a third question wearing a statement's clothes." },
    { "text": "I tried that once and gave up within a week.", "correct": true, "note": "A small admission with content in it. Now there are two people in the conversation." },
    { "text": "How long have you been doing that?", "correct": false, "note": "The third question, plainly." }
  ],
  "explain": "Putting something in means something of yours with content. Encouraging noises keep you in the interviewer's chair."
}$j$::jsonb);

select pg_temp.add_check('going-deeper', 3, $j${
  "prompt": "They say: we ended up cancelling the wedding and doing it at the registry office. Which reply reaches the experience?",
  "options": [
    { "text": "How many people came in the end?", "correct": false, "note": "A detail question about the least interesting part of a sentence containing the word cancelling." },
    { "text": "Why did you cancel?", "correct": false, "note": "Aimed at the right place but phrased as a request to justify themselves." },
    { "text": "Registry offices can be lovely.", "correct": false, "note": "Reassurance nobody asked for, which quietly closes the subject." },
    { "text": "Was that a relief or a disappointment?", "correct": true, "note": "Two feelings at opposite ends, easy to answer, and it does not assume which one it was." }
  ],
  "explain": "Offering two opposite feelings is the safest way in, because it does not presume which one they had."
}$j$::jsonb);

select pg_temp.add_check('going-deeper', 4, $j${
  "prompt": "When does a why or future question land badly?",
  "options": [
    { "text": "When it points backwards and asks them to justify a choice.", "correct": true, "note": "Why did you do that puts someone on the defensive. What are you hoping for does not, and it is the same rung." },
    { "text": "When the subject is their job.", "correct": false, "note": "Work is one of the easiest places to ask about direction. People are usually pleased to be asked." },
    { "text": "When you have only just met.", "correct": false, "note": "Sometimes, and plenty of strangers enjoy a forward-facing question within minutes." },
    { "text": "When they have not mentioned the future themselves.", "correct": false, "note": "You rarely need them to raise it first. What matters is the direction the question faces." }
  ],
  "explain": "The top rung is safe when it faces forwards. Pointed backwards, the same question asks someone to defend themselves."
}$j$::jsonb);

select pg_temp.add_check('going-deeper', 5, $j${
  "prompt": "Which of these most reliably means the conversation should stay shallow?",
  "options": [
    { "text": "You have only known them a few minutes.", "correct": false, "note": "Depth and acquaintance are less related than people assume. Strangers often go deep quickly." },
    { "text": "You are both standing, and one of you is holding something.", "correct": true, "note": "Standing with your hands full is the posture of a conversation with an end already scheduled." },
    { "text": "They are being brief with you.", "correct": false, "note": "Could mean no appetite, could just be how they talk. Weaker than the physical signal." },
    { "text": "The topic is work.", "correct": false, "note": "Work is a subject, not a depth. Some of the best conversations start there." }
  ],
  "explain": "Posture and hands say more about available time than the topic or how long you have known someone."
}$j$::jsonb);

-- Track 3: Listening & labeling ----------------------------------------------

select pg_temp.add_check('listening-and-labeling', 1, $j${
  "prompt": "They say: it has been a slog, but we got there. Which is the better label?",
  "options": [
    { "text": "You got there.", "correct": false, "note": "Their words, and the wrong half. This labels the resolution and closes the subject." },
    { "text": "Sounds exhausting.", "correct": false, "note": "Your word instead of theirs, and it upgrades slog into something they did not say." },
    { "text": "A slog.", "correct": true, "note": "Their word, and the loaded one. The second half of that sentence is the presentable version; the first half is the true one." },
    { "text": "But you got there in the end.", "correct": false, "note": "Reassurance, which asks them to agree that it was fine and stop talking." }
  ],
  "explain": "When a sentence has two halves, the true one is almost always the first. The second is what they added to be polite."
}$j$::jsonb);

select pg_temp.add_check('listening-and-labeling', 2, $j${
  "prompt": "You label, they pause, and you can feel yourself about to speak. What is actually happening in that pause?",
  "options": [
    { "text": "They are deciding whether to trust you.", "correct": false, "note": "Occasionally, and mostly this over-reads a two-second gap." },
    { "text": "They are waiting for you to explain what you meant.", "correct": false, "note": "Almost never. Labels are understood immediately; that is why they work." },
    { "text": "The conversation has stalled.", "correct": false, "note": "This is the fear that ruins the technique. The silence is the technique working." },
    { "text": "They are working out how much to say.", "correct": true, "note": "Usually exactly this. The pause is composition, and interrupting it gets you the shorter version." }
  ],
  "explain": "A pause after a label is someone deciding how much to tell you. Fill it and you have answered for them."
}$j$::jsonb);

select pg_temp.add_check('listening-and-labeling', 3, $j${
  "prompt": "Which phrasing makes a feeling label easiest to correct?",
  "options": [
    { "text": "That sounds like it was frustrating.", "correct": true, "note": "Sounds like frames it as your impression rather than their fact, so no is easy and costs nothing." },
    { "text": "You must have been furious.", "correct": false, "note": "Confident and specific, so disagreeing means contradicting you rather than adjusting you." },
    { "text": "I bet that was annoying.", "correct": false, "note": "Softer, and I bet still asserts. It invites agreement more than correction." },
    { "text": "Were you angry about that?", "correct": false, "note": "A direct question about an emotion, which people commonly deny on reflex." }
  ],
  "explain": "Sounds like and seems like do the work. They mark the guess as yours, which is what makes correcting it painless."
}$j$::jsonb);

select pg_temp.add_check('listening-and-labeling', 4, $j${
  "prompt": "You have guessed wrong twice in a row about the same thing. What does that mean?",
  "options": [
    { "text": "Keep guessing. The third will land.", "correct": false, "note": "Two misses in the same direction is not bad luck, it is not listening, and a third makes it conspicuous." },
    { "text": "Drop it and follow what they actually said instead.", "correct": true, "note": "Two misses means your read of the situation is off. Return to their words, which have been there the whole time." },
    { "text": "Stop guessing and ask them plainly.", "correct": false, "note": "Better than a third guess, and it puts the work of explaining onto them after you have already misread them twice." },
    { "text": "Apologise for misreading them.", "correct": false, "note": "Turns your inaccuracy into a moment they have to manage." }
  ],
  "explain": "Once is attentive. Twice means you are working from a wrong picture, and the fix is their words rather than another guess."
}$j$::jsonb);

select pg_temp.add_check('listening-and-labeling', 5, $j${
  "prompt": "What makes naming a recurring subject land well rather than badly?",
  "options": [
    { "text": "Saying what you think it means about them.", "correct": false, "note": "This is where it turns unpleasant. Naming the pattern is a gift; interpreting it is a diagnosis." },
    { "text": "Waiting until they mention it a fourth time.", "correct": false, "note": "By then it is obvious to both of you and the observation has lost its edge." },
    { "text": "Naming what recurred and stopping there.", "correct": true, "note": "You have noticed, which is flattering, and they get to supply the meaning, which is the interesting part." },
    { "text": "Asking why they keep bringing it up.", "correct": false, "note": "The same observation phrased as a demand for an explanation." }
  ],
  "explain": "Name the recurrence, then stop. The moment you interpret it, you have stopped listening and started assessing."
}$j$::jsonb);

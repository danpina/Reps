-- Second comprehension beat for tracks 7 to 9.

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

-- Track 7: Reading disinterest & backing off ---------------------------------

select pg_temp.add_check('reading-disinterest', 1, $j${
  "prompt": "Someone gives short answers but keeps asking you questions. How many signals is that?",
  "options": [
    { "text": "Two, because short answers count twice.", "correct": false, "note": "Signals do not stack like that, and this one is contradicted by the questions." },
    { "text": "None. Questions cancel everything.", "correct": false, "note": "Over-corrects. The brevity is still worth noticing, it is simply outweighed." },
    { "text": "One, and it is outweighed by the questions.", "correct": true, "note": "Curiosity is the strongest signal there is, and it points the other way. Brevity is often just how someone talks." },
    { "text": "Impossible to say without seeing their posture.", "correct": false, "note": "Posture adds detail. Reciprocal questions already answer the question." }
  ],
  "explain": "Reciprocal questions are the heaviest signal in the set. Someone asking about you is engaged, however briefly they answer."
}$j$::jsonb);

select pg_temp.add_check('reading-disinterest', 2, $j${
  "prompt": "You drop a register and they immediately relax and become funnier. What happened?",
  "options": [
    { "text": "They were warming up to you all along.", "correct": false, "note": "The most common misreading, and it inverts what the evidence shows." },
    { "text": "They are being polite about the change.", "correct": false, "note": "Politeness produces flatness, not more humour. This is real relief." },
    { "text": "You should try again in a few minutes.", "correct": false, "note": "This is exactly the reading that turns a decline into a problem for them to manage." },
    { "text": "The pressure was the problem, not you.", "correct": true, "note": "They wanted the conversation without the frame. Removing it gave you a genuinely good one." }
  ],
  "explain": "Someone getting warmer once the pressure lifts has told you what they wanted. It was the conversation, not the frame."
}$j$::jsonb);

select pg_temp.add_check('reading-disinterest', 3, $j${
  "prompt": "Which exit line is worst, and why?",
  "options": [
    { "text": "I can tell you are not really in the mood.", "correct": true, "note": "Names the thing you were both politely not naming, and obliges them to either deny it or confirm it. Both are worse than leaving." },
    { "text": "I will let you get on.", "correct": false, "note": "Slightly pointed but survivable. It hints you noticed they were busy without making them answer for it." },
    { "text": "I am going to get another drink.", "correct": false, "note": "The reliable one. Neutral, practical and nothing to do with them." },
    { "text": "Good to meet you, I should circulate.", "correct": false, "note": "Warm and conventional. Nobody has ever been hurt by it." }
  ],
  "explain": "The worst exits are the accurate ones. Naming why you are leaving makes them responsible for how you felt."
}$j$::jsonb);

select pg_temp.add_check('reading-disinterest', 4, $j${
  "prompt": "What is the tell that someone's warmth was conditional?",
  "options": [
    { "text": "They leave quickly after being turned down.", "correct": false, "note": "Leaving is fine and often correct. It is the temperature of the leaving that matters." },
    { "text": "They go polite instead of friendly.", "correct": true, "note": "The shift from warm to correct is the tell. Nothing has been said, and everything has been communicated." },
    { "text": "They stop asking questions.", "correct": false, "note": "A conversation naturally winding down does this too." },
    { "text": "They make a joke about it.", "correct": false, "note": "Often the opposite. A light joke can be the most graceful available response." }
  ],
  "explain": "Warmth dropping to mere politeness is what reveals the earlier warmth as payment. It is felt precisely, and never mentioned."
}$j$::jsonb);

select pg_temp.add_check('reading-disinterest', 5, $j${
  "prompt": "You are building a case in your head for why they might be interested. What is that?",
  "options": [
    { "text": "Reasonable analysis of mixed signals.", "correct": false, "note": "It feels like analysis, and analysis of this kind reliably reaches the conclusion it set out for." },
    { "text": "Useful, as long as you check it against their behaviour.", "correct": false, "note": "The case is already built from their behaviour, selectively. Checking it against the same evidence changes nothing." },
    { "text": "A sign the signals are not there.", "correct": true, "note": "Real interest does not require a case. If you are assembling evidence, you already know what the evidence looks like." },
    { "text": "Normal. Everyone does this.", "correct": false, "note": "True, and it is still the signal. Common does not mean uninformative." }
  ],
  "explain": "Mutual interest is not usually a puzzle. Needing to argue yourself into it is the answer arriving in disguise."
}$j$::jsonb);

-- Track 8: Groups ------------------------------------------------------------

select pg_temp.add_check('groups', 1, $j${
  "prompt": "You step into a circle and nobody acknowledges you. What does that mean?",
  "options": [
    { "text": "They do not want you there.", "correct": false, "note": "Almost never. A group mid-story is absorbed, not hostile." },
    { "text": "You should say something to announce yourself.", "correct": false, "note": "This is the mistake the whole lesson exists to prevent." },
    { "text": "You stood in the wrong place.", "correct": false, "note": "If you are in the circle and nobody moved to close it, the position was fine." },
    { "text": "It is working. You are in the group.", "correct": true, "note": "No reaction is the goal. Being absorbed without ceremony is exactly what joining well looks like." }
  ],
  "explain": "A group that carries on as though you had always been there has accepted you. Acknowledgement would mean you interrupted."
}$j$::jsonb);

select pg_temp.add_check('groups', 2, $j${
  "prompt": "The group laughs, and you have nothing clever. What now?",
  "options": [
    { "text": "Say something ordinary about the same subject.", "correct": true, "note": "The gap after a laugh is forgiving. Ordinary lands fine there, and being in the conversation is the point." },
    { "text": "Wait for the next gap, when you might have something better.", "correct": false, "note": "Gaps are scarcer than they look, and a later entry after long silence is harder, not easier." },
    { "text": "Laugh along and stay quiet.", "correct": false, "note": "Fine once. Repeated, you become an audience member rather than a participant." },
    { "text": "Ask the group a question.", "correct": false, "note": "Questions to everyone are questions to nobody, and often meet a pause." }
  ],
  "explain": "The space after a laugh forgives a weak line. Waiting for a good one usually means never speaking."
}$j$::jsonb);

select pg_temp.add_check('groups', 3, $j${
  "prompt": "You know nothing about the group's subject. Can you contribute?",
  "options": [
    { "text": "No. Wait for the topic to change.", "correct": false, "note": "You may wait a long time, and silence reads as disinterest rather than modesty." },
    { "text": "Yes, by asking something real about it.", "correct": true, "note": "Genuine curiosity counts as contribution. Enthusiasts are delighted to explain, and you have paid the price of admission." },
    { "text": "Yes, by changing it to something you know.", "correct": false, "note": "Redirecting before contributing is the exact move that gets you read as someone who does not listen." },
    { "text": "Yes, by pretending to know a little.", "correct": false, "note": "Risky and unnecessary. Enthusiasts detect this immediately and it costs more than ignorance would." }
  ],
  "explain": "Asking a real question about their subject is contribution. Ignorance is not a barrier; disinterest is."
}$j$::jsonb);

select pg_temp.add_check('groups', 4, $j${
  "prompt": "You are two minutes into a story and the group has gone quiet. What kind of quiet is it?",
  "options": [
    { "text": "Rapt. Keep going.", "correct": false, "note": "Possible, and two minutes is past where a group stays rapt for a story it did not ask for." },
    { "text": "Confused. Add background.", "correct": false, "note": "The instinct that turns two minutes into four." },
    { "text": "Polite. Land it quickly.", "correct": true, "note": "Groups do not interrupt, they wait. Silence at two minutes is usually endurance rather than attention." },
    { "text": "Bored, so abandon the story.", "correct": false, "note": "Stopping without an ending is worse than a rushed one. Land it, then hand on." }
  ],
  "explain": "Groups signal boredom by going quiet, not by interrupting. Past a minute, silence means get to the end."
}$j$::jsonb);

select pg_temp.add_check('groups', 5, $j${
  "prompt": "You ask the quiet person a specific question and they answer in four words. What next?",
  "options": [
    { "text": "Ask a follow-up straight away.", "correct": false, "note": "Two questions in a row with the group watching is a spotlight rather than an invitation." },
    { "text": "Repeat the question differently.", "correct": false, "note": "Implies the answer was inadequate, in front of everyone." },
    { "text": "Say something encouraging about their answer.", "correct": false, "note": "Well meant, and it draws more attention to how little they said." },
    { "text": "Let the group carry on and try again later.", "correct": true, "note": "One offer, accepted or not, and no fuss. Some people are quiet by choice and a second push is pressure." }
  ],
  "explain": "Offer the door once and let it go. Quiet is sometimes a preference, and pushing turns kindness into pressure."
}$j$::jsonb);

-- Track 9: Exits -------------------------------------------------------------

select pg_temp.add_check('exits', 1, $j${
  "prompt": "The conversation is flying and you have somewhere else to be. Leave or stay?",
  "options": [
    { "text": "Leave, and say plainly that you are sorry to.", "correct": true, "note": "The best exit available. Leaving mid-peak with genuine reluctance is the most flattering thing you can do." },
    { "text": "Stay. Never leave a good conversation.", "correct": false, "note": "Misreads the lesson. Leaving at the peak is the advice; there is no rule against leaving well." },
    { "text": "Stay until it dips, then go.", "correct": false, "note": "Deliberately waiting for the decline throws away the peak you already had." },
    { "text": "Leave abruptly to avoid a long goodbye.", "correct": false, "note": "Abruptness after a good conversation reads as something having gone wrong." }
  ],
  "explain": "Leaving a conversation you did not want to leave, and saying so, is the strongest exit there is."
}$j$::jsonb);

select pg_temp.add_check('exits', 2, $j${
  "prompt": "Which is a specific warm thing rather than furniture?",
  "options": [
    { "text": "It was lovely to meet you.", "correct": false, "note": "The definition of furniture. Pleasant, automatic, immediately forgotten." },
    { "text": "I am going to steal that line about the minibus.", "correct": true, "note": "Refers to something only this conversation contained, which is what makes it land." },
    { "text": "We should talk again properly.", "correct": false, "note": "Forward-facing and generic. It says nothing about the conversation you actually had." },
    { "text": "You are very easy to talk to.", "correct": false, "note": "Genuinely nice, and it could be said to anyone. Warmth without specificity." }
  ],
  "explain": "Specific means it could only be said about this conversation. Everything else is a pleasantry."
}$j$::jsonb);

select pg_temp.add_check('exits', 3, $j${
  "prompt": "When should you not use a future hook?",
  "options": [
    { "text": "When you have only just met them.", "correct": false, "note": "Hooks work fine with strangers. Newness is not the constraint." },
    { "text": "When they seemed busy.", "correct": false, "note": "A low-commitment hook asks nothing, so busyness is not a reason to skip it." },
    { "text": "When the conversation was fine but unremarkable.", "correct": true, "note": "A hook on every exit becomes a verbal tic. Withholding it most of the time is what gives it weight." },
    { "text": "When you have no specific plan in mind.", "correct": false, "note": "A hook is deliberately not a plan. Specifics turn it into an invitation." }
  ],
  "explain": "Save it for conversations you actually want to continue. Used every time, it stops meaning anything."
}$j$::jsonb);

select pg_temp.add_check('exits', 4, $j${
  "prompt": "You are in a group of three and want to go. What is the smoothest way?",
  "options": [
    { "text": "Slip out while the other two are talking.", "correct": false, "note": "Works in six, conspicuous in three. Vanishing from a small circle is noticed immediately." },
    { "text": "Wait for someone else to join, then leave.", "correct": false, "note": "Sound tactics, and you may be waiting a while." },
    { "text": "Say goodbye to each of them separately.", "correct": false, "note": "Turns a three-second exit into a small procession." },
    { "text": "One clear line to both of them, then go.", "correct": true, "note": "In a small group a clean line costs nothing and leaving unnoticed is impossible." }
  ],
  "explain": "Match the exit to the size of the group. Slip out of a large one; close cleanly with a small one."
}$j$::jsonb);

select pg_temp.add_check('exits', 5, $j${
  "prompt": "Why does a specific reason work better than a vague one when escaping?",
  "options": [
    { "text": "A vague reason can be joined.", "correct": true, "note": "I should circulate invites company. I need to catch Rob before he goes cannot be accompanied." },
    { "text": "It is more honest.", "correct": false, "note": "Often it is less honest. The case for it is practical, not moral." },
    { "text": "It sounds more urgent.", "correct": false, "note": "Urgency is not the mechanism, and overplaying it makes the exit conspicuous." },
    { "text": "It gives them information they can use.", "correct": false, "note": "They do not need the information. It is about whether the reason can be followed." }
  ],
  "explain": "Vague reasons can be come along with. A named person or obligation cannot be joined, which is the whole point."
}$j$::jsonb);

-- Track 9: Exits. Leaving on purpose, because a bad ending undoes a good
-- conversation.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'exits'),
  1,
  'Leave before it dies',
  $md$Almost everyone leaves conversations too late, and it is the most fixable mistake in this entire curriculum.

The reason is that leaving feels like rejection, so people wait for a natural ending. But conversations do not have natural endings. They have a peak and then a long decline, and the longer you wait the more the decline is what you both remember.

**The move:** leave while it is still good, not when it has run out.

This is counter-intuitive and it is correct. If you go at the peak, the last thing you both felt was that this was enjoyable, and the whole exchange is filed as a success. If you wait until you have run out of things to say, the last thing you both felt was awkwardness, and that colours everything.

The signal to leave is a small lull two or three seconds long, arriving after a genuinely good stretch. That is the moment. Not the third lull, not the one where you are both visibly searching.$md$,
  $j$[
    {
      "situation": "You have had ten good minutes and there is a small comfortable pause.",
      "line": "I should go and find the others. This has been really good.",
      "why": "Leaving at the peak. The last thing either of you felt was that this was going well, which is what gets remembered."
    },
    {
      "situation": "You have both said something twice and the pauses are getting longer.",
      "line": "(you have left it slightly late — go now, warmly)",
      "why": "Not fatal, but every additional lull makes the exit harder to do gracefully. Go on the current one rather than waiting."
    },
    {
      "situation": "The conversation is genuinely flying and there is no lull at all.",
      "line": "(stay)",
      "why": "Leave at the first small lull after a good stretch, not on a timer. If there is no lull, there is no reason to go."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "When should you leave a conversation that has been going well?",
    "options": [
      {
        "text": "At the first small lull after a good stretch.",
        "correct": true,
        "note": "The peak is the right exit point. Both of you file the conversation under enjoyable, which is what you will remember next time."
      },
      {
        "text": "When you run out of things to say.",
        "correct": false,
        "note": "This is where most people leave, and by then the last few minutes were a search for material. That is what gets remembered."
      },
      {
        "text": "When they show signs of wanting to leave.",
        "correct": false,
        "note": "Waiting to be released means the other person has to do the work, and you will usually be slightly late."
      },
      {
        "text": "After a set amount of time, to be safe.",
        "correct": false,
        "note": "Timers ignore how the conversation is actually going. Leaving a flying conversation because ten minutes elapsed is its own mistake."
      }
    ],
    "explain": "Conversations peak and then decline. Leave at the peak and the whole thing is remembered as good."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "left_at_the_peak", "label": "Left while it was still good", "description": "Exited at a lull after a strong stretch rather than after it had run down." },
      { "key": "read_the_lull", "label": "Recognised the right lull", "description": "Distinguished a comfortable pause after a good stretch from a searching silence." },
      { "key": "did_not_wait", "label": "Did not wait to be released", "description": "Took responsibility for ending rather than waiting for the other person." },
      { "key": "no_false_starts", "label": "Left cleanly", "description": "Did not announce leaving and then stay for several more minutes." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A gallery private view. You have been talking to someone for about ten minutes and it has gone well.",
    "partner": {
      "name": "Lena",
      "role": "someone you met by the drinks table",
      "personality": "Engaged and enjoyable company, with a finite amount to say on the current subject. Will keep the conversation going politely well past its natural peak if the user does not end it.",
      "mood": "Enjoying the evening.",
      "openness": 4
    },
    "opening_beat": "Lena finishes a good story, you both laugh, and there is a comfortable two-second pause.",
    "success_looks_like": "The user recognises the pause as the peak and leaves warmly rather than starting a new topic to fill it.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user starts a new topic instead of leaving, engage politely but with steadily less energy and longer pauses.",
      "If the user leaves at the peak, respond with real warmth and say you enjoyed it.",
      "Never end the conversation yourself."
    ]
  }$j$::jsonb,
  $md$End one conversation today while it is still going well. Log how it felt to leave early and what they said as you went.$md$
),
(
  (select id from public.skills where slug = 'exits'),
  2,
  'The warm close',
  $md$An exit has a shape, and it is three short parts that take about four seconds together.

**A reason.** Any reason. It does not have to be true in a deep sense and it should not be about them — going to get a drink, going to find someone, needing to catch someone before they leave.

**A warm statement.** Not a pleasantry. Something specific about the conversation you actually had. *That story about the minibus has made my evening.*

**A clean break.** Say it and go. The single most common failure is announcing the exit and then standing there for another four minutes, which makes the announcement retroactively strange.

**The move:** reason, warmth, go.

The warm part is where almost everyone underinvests. *Nice to meet you* is not warmth, it is furniture. One specific detail turns a generic ending into the thing they remember about you.$md$,
  $j$[
    {
      "situation": "A good ten-minute conversation with someone new.",
      "line": "I am going to go and find my friend. Genuinely, the best conversation I have had all week.",
      "why": "Reason, then specific warmth, then leave. Genuinely does the work of making a compliment sound meant rather than automatic."
    },
    {
      "situation": "A conversation that was pleasant but not remarkable.",
      "line": "I should circulate before I get told off. Good to meet you properly.",
      "why": "Warmth sized correctly. Overclaiming on an ordinary conversation reads as insincere, and properly acknowledges you had actually met before."
    },
    {
      "situation": "You said you were leaving and then carried on talking.",
      "line": "(this is the common failure — say it and go)",
      "why": "An announced exit that does not happen makes the next one harder, because they now discount what you say."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which part of the exit do most people do badly?",
    "options": [
      {
        "text": "The reason for leaving.",
        "correct": false,
        "note": "Usually fine. People manage this bit easily, and almost any neutral reason works."
      },
      {
        "text": "The warm part.",
        "correct": true,
        "note": "Most people substitute furniture like nice to meet you. One specific detail about the actual conversation is what gets remembered."
      },
      {
        "text": "The timing.",
        "correct": false,
        "note": "Also commonly wrong, and it is the subject of the previous lesson rather than a part of the exit's shape."
      },
      {
        "text": "Making eye contact while leaving.",
        "correct": false,
        "note": "Worth doing, and a detail rather than a structural part of the exit."
      }
    ],
    "explain": "Reason, warmth, go. The warmth needs one specific detail, or it is just furniture."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_a_reason", "label": "Gave a neutral reason", "description": "Offered a reason for leaving that was not about the other person." },
      { "key": "specific_warmth", "label": "Was specifically warm", "description": "Referred to something real from the conversation rather than a generic pleasantry." },
      { "key": "clean_break", "label": "Actually left", "description": "Announced the exit and then went, rather than lingering." },
      { "key": "right_size", "label": "Sized the warmth correctly", "description": "Matched the warmth to how the conversation had actually gone." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend's flat-warming. You have been talking to someone in the hallway and it has been genuinely enjoyable.",
    "partner": {
      "name": "Tam",
      "role": "a friend of the host",
      "personality": "Notices sincerity easily. Responds strongly to a specific compliment and flatly to a generic one.",
      "mood": "Happy, enjoying the party.",
      "openness": 4
    },
    "opening_beat": "Tam finishes telling you about a disastrous attempt at making their own furniture, and you both laugh.",
    "success_looks_like": "The user exits with a reason, a specific piece of warmth referencing the conversation, and then actually leaves.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user gives a generic pleasantry as they leave, respond politely and blandly.",
      "If the user refers to something specific from the conversation, respond with real warmth and pleasure.",
      "If the user announces they are leaving and then keeps talking, become slightly confused and check whether they are staying."
    ]
  }$j$::jsonb,
  $md$Today, end one conversation with a reason, one specific warm thing, and an actual departure. Log the specific thing you said.$md$
),
(
  (select id from public.skills where slug = 'exits'),
  3,
  'The future hook',
  $md$Some exits deserve a fourth part: a small piece of forward motion.

A hook is a low-commitment reference to a next time. *Let me know how the move goes. I want to hear how that turns out. We should do this properly at some point.* It costs nothing, requires no arrangement, and it converts an ending into a pause.

**The move:** if you would genuinely like to talk to them again, say one sentence that points forwards.

Two rules. It has to be specific to something in the conversation, or it is a formula and reads as one. And it has to be genuinely low commitment — a hook is not an invitation, and turning it into one puts them on the spot at the exact moment they are trying to leave.

The other rule is not to use it every time. A hook on every exit is a verbal tic. Save it for conversations you actually want to continue, and it will mean something when you use it.$md$,
  $j$[
    {
      "situation": "They mentioned a job interview next week.",
      "line": "Let me know how Thursday goes. I am invested now.",
      "why": "Specific to their material, forward-facing, and asks for nothing. It gives them an easy reason to speak to you again if they want one."
    },
    {
      "situation": "You have discovered you both climb.",
      "line": "We should get on a wall at some point. I need someone better than me to shame me into trying harder.",
      "why": "A real suggestion held loosely. At some point keeps it from being an arrangement they have to answer now."
    },
    {
      "situation": "A pleasant but unremarkable conversation with a colleague.",
      "line": "(no hook needed — a warm close is complete on its own)",
      "why": "Hooks on every exit become meaningless. Withholding it most of the time is what gives it weight when you use it."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "What makes a future hook work rather than land awkwardly?",
    "options": [
      {
        "text": "Being specific about time and place.",
        "correct": false,
        "note": "That is an invitation, not a hook. Specifics at the moment of leaving force an answer they may not be ready to give."
      },
      {
        "text": "Using it on every conversation so it becomes natural.",
        "correct": false,
        "note": "Repetition turns it into a formula. People can tell the difference between a habit and something meant."
      },
      {
        "text": "Referring to something specific from the conversation, with no commitment attached.",
        "correct": true,
        "note": "Specific enough to be genuine, loose enough that nobody has to respond to it. That combination is the whole technique."
      },
      {
        "text": "Asking directly whether they would like to meet again.",
        "correct": false,
        "note": "A fine move in the right context, and it is a direct ask rather than a hook. It requires an answer on the spot."
      }
    ],
    "explain": "Specific to them, loose in commitment. A hook opens a door without asking anyone to walk through it now."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_material", "label": "Built on something specific", "description": "The hook referenced something from the actual conversation." },
      { "key": "low_commitment", "label": "Asked for nothing", "description": "Kept it loose enough that no answer was required on the spot." },
      { "key": "used_it_selectively", "label": "Saved it for the right conversation", "description": "Did not attach a hook to every exit out of habit." },
      { "key": "still_a_clean_exit", "label": "Still left cleanly", "description": "The hook did not turn into a second conversation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of an evening class. You have been paired with someone for the practical part and got on well.",
    "partner": {
      "name": "Owen",
      "role": "someone from the same class",
      "personality": "Friendly and slightly reserved. Responds warmly to a low-commitment hook and becomes awkward if pressed for a specific arrangement.",
      "mood": "Pleased with how the session went, packing up.",
      "openness": 4
    },
    "opening_beat": "Owen mentions he is going to try the thing you were both practising at home before next week, and starts putting his coat on.",
    "success_looks_like": "The user closes warmly and adds a hook specific to what Owen just said, without turning it into an arrangement.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user offers a low-commitment hook tied to something specific, respond warmly and positively.",
      "If the user pushes for a definite arrangement, become vague and slightly uncomfortable.",
      "If the user offers only a generic goodbye, respond politely and leave."
    ]
  }$j$::jsonb,
  $md$Today, end one conversation with a hook tied to something they actually said. Only where you would genuinely like to talk again. Log the hook.$md$
),
(
  (select id from public.skills where slug = 'exits'),
  4,
  'Leaving a group',
  $md$Leaving a group is easier than leaving one person, and most people make it harder than it needs to be.

The mistake is addressing the whole circle — waiting for a gap, announcing your departure to everyone, and stopping the conversation so that five people can say goodbye. It is a small ceremony nobody wanted, and it makes leaving feel like an event.

**The move:** leave sideways, not from the front.

A nod to whoever is nearest, a quiet *see you later* to one person, and step back out of the circle. The conversation continues, nobody has to perform a farewell, and you have not made your exit into a moment. This is entirely normal group behaviour and reads as completely comfortable.

The exception is a group of three, where slipping out is impossible without it being obvious. There, one clear line to all of them is correct — it is a small enough circle that leaving properly costs nothing.$md$,
  $j$[
    {
      "situation": "You are in a circle of six and want to leave.",
      "line": "(a nod to the person beside you, then step back)",
      "why": "No announcement, no ceremony, no pause in the conversation. This is how comfortable people leave groups."
    },
    {
      "situation": "You are in a group of three and cannot leave unnoticed.",
      "line": "I am going to leave you two to it. Good to see you both.",
      "why": "In a small group a clean line is correct. Slipping away from three people is conspicuous rather than smooth."
    },
    {
      "situation": "You are mid-conversation with one person inside a larger group.",
      "line": "I will let you get back to it. Good talking to you.",
      "why": "Closes with the person you were actually talking to and leaves the group undisturbed."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You want to leave a circle of six people mid-conversation. What is the smoothest way?",
    "options": [
      {
        "text": "Wait for a gap and tell the group you are heading off.",
        "correct": false,
        "note": "Creates a small ceremony. Six people stop, say goodbye, and the conversation has to restart afterwards."
      },
      {
        "text": "Nod to the nearest person and step back out of the circle.",
        "correct": true,
        "note": "The conversation continues undisturbed and nobody has to perform a farewell. This is normal, comfortable group behaviour."
      },
      {
        "text": "Say goodbye individually to each person.",
        "correct": false,
        "note": "Turns leaving into a five-minute procession and makes your departure the group's main event."
      },
      {
        "text": "Leave without acknowledging anyone.",
        "correct": false,
        "note": "Close to right, but a complete vanishing can read as abrupt. One small acknowledgement costs nothing."
      }
    ],
    "explain": "Leave a large group sideways with one small acknowledgement. Save the clear announcement for groups of three or fewer."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ceremony", "label": "Did not make it an event", "description": "Left without stopping the group's conversation for a farewell." },
      { "key": "acknowledged_someone", "label": "Acknowledged at least one person", "description": "Gave a nod or a quiet word rather than vanishing entirely." },
      { "key": "sized_to_the_group", "label": "Matched the method to the group size", "description": "Slipped out of a large group, and closed clearly with a small one." },
      { "key": "left_cleanly", "label": "Left promptly", "description": "Did not announce and then linger." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A crowded house party. You are in a circle of six, the conversation is lively, and you want to go and find someone else.",
    "partner": {
      "name": "the group",
      "role": "six people mid-conversation",
      "personality": "Absorbed in their own conversation and entirely relaxed. Happy for people to come and go without ceremony.",
      "mood": "Loud and enjoying themselves.",
      "openness": 4
    },
    "opening_beat": "The group are three deep in an argument about the best route across the city, and nobody is looking at you.",
    "success_looks_like": "The user leaves sideways with a small acknowledgement, and the conversation carries on without a pause.",
    "constraints": [
      "Stay in character as the whole group. Never coach, evaluate or break the scene.",
      "Keep the conversation running energetically throughout.",
      "If the user slips out with a nod or a quiet word, carry on seamlessly and warmly.",
      "If the user announces their departure to the whole group, stop the conversation, have everyone say goodbye at length, and let it become a small awkward ceremony."
    ]
  }$j$::jsonb,
  $md$Today, leave one group conversation sideways. A nod, a quiet word to one person, and out. Log how it went compared to announcing it.$md$
),
(
  (select id from public.skills where slug = 'exits'),
  5,
  'Escaping without insult',
  $md$Sometimes you need to leave a conversation that is genuinely not working, and the difficulty is doing it without the other person feeling it.

The temptation is a hard exit — going flat and abrupt so the message is unmistakable. It works and it costs someone their evening, because they will replay it.

**The move:** raise your warmth slightly as you leave, not lower it.

This sounds backwards and it is the whole technique. A warm exit from a bad conversation is ambiguous in the kindest possible way: they cannot tell whether you left because it was not working or because you had somewhere to be. That ambiguity is a gift, and it costs you nothing but four seconds.

If someone is monopolising you, the reliable structure is to name a specific obligation and go immediately. *I have to go and speak to Rob before he leaves.* Specific reasons are harder to follow you into than vague ones.

You are allowed to leave conversations. Doing it warmly is what makes that fact harmless.$md$,
  $j$[
    {
      "situation": "Someone has been talking at you for fifteen minutes without pause.",
      "line": "I need to catch Rob before he goes. Enjoy the rest of your night.",
      "why": "A specific obligation and a warm close. Specific reasons cannot be joined; vague ones can."
    },
    {
      "situation": "A conversation has become subtly uncomfortable.",
      "line": "I am going to get another drink. Good to talk.",
      "why": "Neutral, warm, immediate. No explanation is required and offering one would only extend the discomfort."
    },
    {
      "situation": "You are leaving a conversation that went badly and they say something friendly.",
      "line": "(answer it warmly, then go)",
      "why": "The last exchange is what they will remember. Answering warmly costs you two seconds and changes what the encounter was."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You need to leave a conversation that is not working. Why raise your warmth on the way out?",
    "options": [
      {
        "text": "Because it makes them more likely to talk to you again.",
        "correct": false,
        "note": "That is not the aim here, and treating warmth as an investment tends to make it visible as one."
      },
      {
        "text": "Because it makes the reason for leaving ambiguous, which is kinder.",
        "correct": true,
        "note": "They cannot tell whether you left because it was not working or because you had somewhere to be. That ambiguity spares them the replay."
      },
      {
        "text": "Because it is more honest.",
        "correct": false,
        "note": "It is arguably slightly less honest. The case for it is kindness, not accuracy."
      },
      {
        "text": "Because a cold exit might cause an argument.",
        "correct": false,
        "note": "It rarely causes conflict. What it causes is someone quietly feeling bad later, which is the actual thing to avoid."
      }
    ],
    "explain": "A warm exit leaves the reason ambiguous. That ambiguity is the kindest thing you can offer someone you are leaving."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "raised_warmth", "label": "Left warmer, not colder", "description": "Increased warmth on exit rather than going flat to signal the problem." },
      { "key": "specific_reason", "label": "Gave a specific reason", "description": "Named a concrete obligation rather than a vague one that could be followed." },
      { "key": "left_promptly", "label": "Left immediately after saying so", "description": "Did not announce and then linger, which undermines the reason." },
      { "key": "no_message_sent", "label": "Sent no message", "description": "The other person was not left with the sense that they had been escaped from." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A work party. Someone has been telling you about their loft conversion in considerable detail for twelve minutes.",
    "partner": {
      "name": "Gordon",
      "role": "a colleague from another department",
      "personality": "Well meaning and entirely unaware of how long he has been talking. Follows vague exits without noticing, and accepts specific ones easily.",
      "mood": "Enthusiastic and settled in.",
      "openness": 5
    },
    "opening_beat": "Gordon pauses for breath, then starts explaining the planning permission process.",
    "success_looks_like": "The user exits with a specific obligation and raised warmth, and Gordon is left feeling perfectly good about the exchange.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Keep talking about the loft conversion at length unless the user leaves.",
      "If the user gives a vague reason such as needing to circulate, offer to come with them and continue the story.",
      "If the user names a specific person or obligation, accept it cheerfully and let them go."
    ]
  }$j$::jsonb,
  $md$Today, leave one conversation that was not working, and be warmer on the way out than you were in the middle. Log the reason you gave.$md$
);

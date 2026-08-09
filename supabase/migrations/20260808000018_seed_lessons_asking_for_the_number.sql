-- Meeting someone, track 6: the close. The topic could start a conversation and
-- run it warm, and then stopped — which meant it taught everything except the
-- only outcome anybody actually wanted from it.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'asking-for-the-number'),
  1,
  'Ask before it peaks',
  $md$Almost everybody asks too late, and it is not nerve that causes it. It is waiting for a moment that does not arrive.

There is no perfect point. What there is, is a stretch where it is obviously going well — you are both laughing, neither of you has checked the time, the conversation keeps finding new places to go — and then a slow decline as the evening, the queue, or the coffee runs out. The ask belongs in the first of those, while it is still climbing.

**The move:** ask while it is still going well, not as you are leaving.

Leaving is the worst available timing and it is the one people default to, because it feels like the natural end of a conversation. But by then the thing has already cooled, you are both half-turned towards the door, and the request arrives with nothing behind it — it has to be justified from scratch instead of following from what just happened.

Asking early has a second advantage nobody mentions. If they say yes, the rest of the conversation is relaxed for both of you, because the question everybody was quietly holding is answered. If they say no, you get to be warm about it and carry on rather than walking away on it.

The cost of asking a few minutes early is nothing. The cost of asking a few minutes late is the whole thing.$md$,
  $j$[
    {
      "situation": "Fifteen good minutes in. Neither of you has looked at a phone.",
      "line": "(ask now, while it is still climbing)",
      "why": "The ask follows from what just happened rather than having to justify itself. There is no better moment coming, only a quieter one."
    },
    {
      "situation": "They have started glancing towards their friends and the energy has dropped.",
      "line": "(ask anyway, straight away, rather than waiting for the door)",
      "why": "Late is worse than early and the door is the latest there is. A slightly flat ask still beats one delivered at a coat rack."
    },
    {
      "situation": "You asked, they said yes, and there are still ten minutes left.",
      "line": "(carry on — it is easier now)",
      "why": "The question everybody was quietly holding is answered, and the rest of the conversation relaxes for both of you. That is the hidden benefit of asking early."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is asking as you leave the worst timing?",
      "options": [
        { "text": "It is polite and it looks like the natural end.", "correct": false, "note": "It looks natural, which is exactly why people default to it. Looking natural and working are different properties." },
        { "text": "The moment has cooled, so the ask has to justify itself from scratch.", "correct": true, "note": "Asked while it is going well, the request follows from what just happened. Asked at the door, it arrives with nothing behind it and both of you are already half-turned away." },
        { "text": "You will not have time to talk after.", "correct": false, "note": "True and secondary. The problem is what the ask has to carry, not what comes after it." },
        { "text": "They will feel ambushed.", "correct": false, "note": "Rarely how it lands. It mostly just lands flat, which is a different failure." }
      ],
      "explain": "Ask while it is climbing. At the door the request has to do all the work by itself."
    },
    {
      "prompt": "You ask early and they say yes. What did that buy?",
      "options": [
        { "text": "Nothing much — the yes is the yes.", "correct": false, "note": "The yes is the yes, and the remaining time changes character completely once it is given." },
        { "text": "You can leave whenever you want.", "correct": false, "note": "A way of describing the benefit that quietly turns the conversation into a transaction." },
        { "text": "The rest of the conversation relaxes, because the held question is answered.", "correct": true, "note": "Both of you were carrying it. Answering it early is why early asks tend to produce better last ten minutes than late ones." },
        { "text": "It proves you were confident.", "correct": false, "note": "Impression management. Something that happens and not the reason to do it." }
      ],
      "explain": "An early yes improves the time you have left. A late one only ends it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "timing", "label": "Asked while it was going well", "description": "Asked during the climb rather than at the exit." },
      { "key": "did_ask", "label": "Actually asked", "description": "Made the request rather than waiting for a better moment." },
      { "key": "warm", "label": "Kept it warm", "description": "Asked in the register of the conversation rather than switching into a formal one." },
      { "key": "carried_on", "label": "Carried on afterwards", "description": "Did not treat the ask as the end of the conversation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A bar. You have been talking for about fifteen minutes and it has been easy the whole way. Their friends are across the room and nobody is in a hurry.",
    "partner": {
      "name": "Nadia",
      "role": "somebody you got talking to at the bar",
      "personality": "Easy company and clearly enjoying this. Will happily keep talking for as long as the user does, and will start drifting back towards her friends if the conversation runs out of places to go.",
      "mood": "Relaxed, good evening so far.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Nadim",
        "role": "somebody you got talking to at the bar",
        "personality": "Easy company and clearly enjoying this. Will happily keep talking for as long as the user does, and will start drifting back towards his friends if the conversation runs out of places to go.",
        "mood": "Relaxed, good evening so far.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"Right — so now I have to actually go and try that place, or you will know I was lying.\"",
    "success_looks_like": "The user asks while the conversation is still going well rather than waiting for an exit.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly to an ask made while the conversation is still lively.",
      "Cool gradually if the conversation runs long without going anywhere, and eventually mention your friends.",
      "Never ask for the user's number yourself."
    ]
  }$j$::jsonb,
  $md$Today, notice one conversation while it is still climbing and name the moment to yourself. Log when the peak was and whether you would have waited past it.$md$
),
(
  (select id from public.skills where slug = 'asking-for-the-number'),
  2,
  'Say what you want to do',
  $md$A number asked for on its own is a request for permission to contact somebody. It is vague, it is open-ended, and the thing they are being asked to agree to is unclear — which is why the honest answer to it is so often a hesitation.

**The move:** attach the ask to a specific thing you would like to do.

That place you both said sounded good. The gig they mentioned. The market on Saturday that came up twenty minutes ago. Something from this conversation, not a generic proposal, because something from this conversation proves you were listening and makes the ask a continuation rather than a swerve.

*Can I get your number?* asks for access. *There is a place near here that does the thing you were describing — give me your number and I will find out if it is any good* asks for a plan. The second is easier to say yes to, because they know what they are agreeing to. It is also easier to say no to, which is not a drawback: an ask that is hard to decline is not really an ask, and everything in the next two lessons depends on this one being answerable both ways.

Keep it small. A coffee, a drink, an hour. A weekend away is not a first proposal, and neither is anything that requires them to rearrange a day for a person they met forty minutes ago.$md$,
  $j$[
    {
      "situation": "They spent five minutes on a food they cannot find anywhere in this city.",
      "line": "There is a place two streets from here that does that. Give me your number and we will go and find out if it is any good.",
      "why": "Specific, small, and drawn from the conversation — which proves you were listening. They know exactly what they are saying yes to."
    },
    {
      "situation": "You are about to say can I get your number.",
      "line": "(find the thing from the last twenty minutes first)",
      "why": "On its own the ask requests access rather than proposing anything, and vagueness is what produces hesitation. Something from the conversation makes it a continuation."
    },
    {
      "situation": "The plan you are about to propose takes up most of a day.",
      "line": "(make it an hour)",
      "why": "Small proposals are easy to accept from somebody you met forty minutes ago. Large ones ask them to commit a day to a stranger."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why attach the ask to something specific?",
      "options": [
        { "text": "It is more romantic.", "correct": false, "note": "Not really the register. It is more concrete, which is a different and more useful thing." },
        { "text": "They know what they are agreeing to.", "correct": true, "note": "A bare number request asks for access without saying what for, and vagueness is what produces the hesitation. A plan can simply be accepted." },
        { "text": "It makes it harder to refuse.", "correct": false, "note": "The opposite, and deliberately. It is easier to refuse too, which is what makes the yes worth having." },
        { "text": "It shows you have thought about it.", "correct": false, "note": "It shows you were listening, which is close and not the mechanism. The mechanism is clarity about what is being asked." }
      ],
      "explain": "Ask for a plan, not for access. A plan can be answered."
    },
    {
      "prompt": "Where should the specific thing come from?",
      "options": [
        { "text": "Somewhere you already wanted to take somebody.", "correct": false, "note": "Perfectly good and it reads as generic, because it is — it existed before they did." },
        { "text": "Whatever is nearest.", "correct": false, "note": "Convenient and arbitrary. Proximity is not a reason they can feel." },
        { "text": "Something safe you know is impressive.", "correct": false, "note": "Impressive raises the stakes and the effort on both sides. Small and specific beats impressive here." },
        { "text": "This conversation.", "correct": true, "note": "It proves you were listening and makes the ask a continuation of what you were already doing rather than a swerve into a different mode." }
      ],
      "explain": "Take the plan from the last twenty minutes. That is what makes it theirs rather than a script."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Named a specific thing", "description": "Proposed an actual plan rather than asking for access." },
      { "key": "from_the_talk", "label": "Took it from the conversation", "description": "Used something they had said rather than a generic outing." },
      { "key": "small", "label": "Kept it small", "description": "An hour or two, not a day." },
      { "key": "clear", "label": "Made the ask clearly", "description": "Actually asked for the number rather than hinting at it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A coffee shop, twenty minutes into a conversation that started by accident. They have spent a good chunk of it describing a kind of food they have not been able to find since moving here.",
    "partner": {
      "name": "Priya",
      "role": "somebody sharing the long table with you",
      "personality": "Talkative and specific. Lights up when something she said earlier comes back, and goes politely vague at anything generic.",
      "mood": "Unhurried, enjoying the detour.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Dev",
        "role": "somebody sharing the long table with you",
        "personality": "Talkative and specific. Lights up when something he said earlier comes back, and goes politely vague at anything generic.",
        "mood": "Unhurried, enjoying the detour.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"...and honestly I have looked. Nowhere in this entire city does it properly.\"",
    "success_looks_like": "The user asks for the number attached to a small, specific plan drawn from what the partner said.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly and concretely to a plan drawn from something you said.",
      "Respond politely and vaguely to a bare request for a number.",
      "Keep replies to a few sentences."
    ]
  }$j$::jsonb,
  $md$Today, turn one thing somebody says into a specific small plan out loud, whether or not you ask for anything. Log what they said and what you proposed.$md$
),
(
  (select id from public.skills where slug = 'asking-for-the-number'),
  3,
  'Make declining free',
  $md$This is the lesson that decides how the ask feels for both of you, and it is the one shy people are best placed to get right — because the instinct behind it is already there.

Somebody who cannot decline comfortably has not really been asked. If the phrasing makes a no expensive — if it would require an excuse, an apology, or a small performance of regret — then what they are answering is not your question but the cost of refusing it. And a yes given under that pressure is not information.

**The move:** build the exit into the sentence.

*If you are up for it.* *No pressure either way.* *Only if you fancy it.* Half a clause, at the end, said lightly. It is not a hedge and it is not an apology — it is the thing that makes a yes mean yes.

Then say it and stop. The most common failure here is not the phrasing, it is filling the silence afterwards: adding a second version of the question, laughing, or talking past it. That takes the exit back, because now they have to interrupt you to answer. Ask, then be quiet, and let the pause be theirs.

There is a line between an exit and an apology, and it is worth seeing clearly. *If you are up for it* gives them room. *Sorry, this is probably weird, but* takes the room and fills it with your discomfort — it asks them to reassure you, which is a bigger favour than the number was.$md$,
  $j$[
    {
      "situation": "You have just proposed the plan and asked for the number.",
      "line": "...if you are up for it.",
      "why": "Half a clause, at the end, said lightly. It costs nothing and it is what makes a yes mean yes rather than mean politeness."
    },
    {
      "situation": "You asked and there is a two-second silence.",
      "line": "(say nothing)",
      "why": "The pause is theirs. Filling it takes the exit back, because now they have to interrupt you in order to answer at all."
    },
    {
      "situation": "You are about to open with sorry, this is probably weird.",
      "line": "(cut it — that is an apology, not an exit)",
      "why": "An exit gives them room. An apology fills that room with your discomfort and asks them to reassure you, which is a bigger favour than the number."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the difference between an exit and an apology?",
      "options": [
        { "text": "An exit gives them room; an apology asks them to reassure you.", "correct": true, "note": "If you are up for it costs them nothing. Sorry, this is probably weird hands them your discomfort to manage, which is a larger ask than the one you came with." },
        { "text": "There is no real difference — both soften it.", "correct": false, "note": "They soften different things. One softens the request, the other softens you, and only one of those helps them answer." },
        { "text": "An apology is more honest.", "correct": false, "note": "Honest about your nerves and it does not make the ask more answerable, which is the job here." },
        { "text": "An exit is what confident people use.", "correct": false, "note": "Style rather than mechanism. An exit works because of what it costs them, not because of who says it." }
      ],
      "explain": "Give them room. Do not give them your nerves to hold."
    },
    {
      "prompt": "You have asked, and there is a silence. What do you do?",
      "options": [
        { "text": "Ask again more lightly, in case it was unclear.", "correct": false, "note": "Two versions of one question is harder to answer than one, and it signals that the first one was not meant." },
        { "text": "Laugh and change the subject.", "correct": false, "note": "It withdraws the ask entirely and leaves them nothing to say yes to." },
        { "text": "Nothing. Let the pause be theirs.", "correct": true, "note": "The commonest failure is not the phrasing, it is filling the silence. Talking past your own question means they have to interrupt you to accept it." },
        { "text": "Add that it is completely fine either way.", "correct": false, "note": "You already built the exit in. Repeating it starts to read as expecting a no." }
      ],
      "explain": "Ask, then stop. A silence after a question belongs to the person answering."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "exit", "label": "Built in an exit", "description": "Made declining cost them nothing." },
      { "key": "not_apology", "label": "Did not apologise", "description": "Gave room rather than handing over their own discomfort." },
      { "key": "stopped", "label": "Stopped talking", "description": "Let the silence after the question belong to them." },
      { "key": "still_asked", "label": "Still made a real ask", "description": "Softened the cost of no without blurring the question." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a long conversation at a friend's party. It has gone well and you have just decided to ask.",
    "partner": {
      "name": "Iris",
      "role": "somebody you met at the party tonight",
      "personality": "Kind and easily made responsible for other people's feelings. Answers a clean ask straightforwardly and starts reassuring the user if the ask arrives wrapped in apology.",
      "mood": "Warm, a little tired, good evening.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Idris",
        "role": "somebody you met at the party tonight",
        "personality": "Kind and easily made responsible for other people's feelings. Answers a clean ask straightforwardly and starts reassuring the user if the ask arrives wrapped in apology.",
        "mood": "Warm, a little tired, good evening.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"I should probably find my coat at some point. That was a much better conversation than I expected to have tonight.\"",
    "success_looks_like": "The user asks with an exit built in, and then stops talking.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Pause briefly before answering any ask, so the silence is real.",
      "Answer a clean, unapologetic ask warmly and directly.",
      "Start reassuring the user if the ask is wrapped in apology, and let that become the subject."
    ]
  }$j$::jsonb,
  $md$Today, ask for one ordinary thing with the exit built in, and then say nothing until they answer. Log what you asked and how long the pause was.$md$
),
(
  (select id from public.skills where slug = 'asking-for-the-number'),
  4,
  'The soft no',
  $md$Most nos are soft, and that is the problem. Almost nobody says no. They say they are quite busy at the moment, or that they are not really on their phone, or they say yes and give you a number with a note in their voice you decide not to hear.

**The move:** treat the first no as final, and be warm about it.

Take the softest available reading as a decline. This is the exact opposite of how it feels — it feels like the ambiguity is an invitation to be clearer, to explain the plan better, to give them a second chance to hear it properly. It is not. A soft no is a no phrased kindly by somebody who is trying to make this easy for you, and answering it with a second ask converts their kindness into a problem they now have to solve harder.

What warmth looks like here is small and specific: accept it in one sentence, do not perform being fine, and stay in the conversation for another minute if there is one to stay in. *No bother — it was good talking to you either way* costs you nothing and leaves the evening intact for both of you.

Two things that are not required of you: an explanation, and an immediate exit. Fleeing tells them the previous forty minutes were a means to an end, which is unkind to something that was actually pleasant.

And the reframe worth keeping. You have not lost anything you had. You have found out something you did not know, in about four seconds, at a cost of one slightly awkward moment — which is a genuinely good exchange rate, and it is the whole reason asking early is cheap.$md$,
  $j$[
    {
      "situation": "\"I am really not on my phone much at the moment, honestly.\"",
      "line": "No bother at all. It was good talking to you either way.",
      "why": "Takes the soft no as a no, in one sentence, without performing disappointment or requiring an explanation. The evening stays intact for both of you."
    },
    {
      "situation": "You are about to explain the plan again, more clearly.",
      "line": "(they heard it)",
      "why": "The ambiguity is not an invitation to be clearer. A second ask turns their kindly phrased no into a problem they now have to solve more directly."
    },
    {
      "situation": "You have accepted the no and there is still a conversation happening.",
      "line": "(stay a minute)",
      "why": "Leaving instantly says the previous forty minutes were a means to an end. Staying says they were not, which is both kinder and true."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "\"I am quite busy at the moment.\" What is that?",
      "options": [
        { "text": "Genuinely about their schedule.", "correct": false, "note": "Sometimes literally true, and it does not change the move. Busy is the most common wrapper there is." },
        { "text": "Ambiguous — worth one clarification.", "correct": false, "note": "The read that turns a kind decline into an uncomfortable few minutes. Ambiguity here is a courtesy, not an opening." },
        { "text": "A no, phrased kindly.", "correct": true, "note": "Almost nobody says the word. Take the softest available reading as a decline and you will almost always be right, and warm when you are not." },
        { "text": "A test of how much you want it.", "correct": false, "note": "A story that justifies asking twice. People are not usually testing you; they are trying to make this easy." }
      ],
      "explain": "Take the first no as final. Softness is somebody being kind, not somebody being unclear."
    },
    {
      "prompt": "You have taken the no warmly. What now?",
      "options": [
        { "text": "Leave quickly so it is not awkward.", "correct": false, "note": "It says the last forty minutes were a means to an end, which is unkind to something that was genuinely pleasant." },
        { "text": "Explain that it is completely fine, at some length.", "correct": false, "note": "Performing being fine asks them to manage your feelings about their answer, which is the one thing they were trying to avoid." },
        { "text": "Ask what the reason was.", "correct": false, "note": "It requires them to produce a justification for a decision that needed none." },
        { "text": "Stay in the conversation for another minute if there is one.", "correct": true, "note": "You lost nothing you had. Staying says the conversation was worth having on its own, and it leaves the evening intact for both of you." }
      ],
      "explain": "One sentence, no performance, and stay if there is something to stay for."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_it", "label": "Read the soft no", "description": "Took a kindly phrased decline as a decline." },
      { "key": "once", "label": "Did not ask twice", "description": "Resisted clarifying, re-proposing or explaining the plan again." },
      { "key": "warm", "label": "Stayed warm", "description": "Accepted it in one sentence without performing disappointment." },
      { "key": "stayed", "label": "Did not flee", "description": "Left the conversation intact rather than exiting on the answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A gig venue between sets. You have been talking for half an hour, you have just asked, and the answer was not a yes.",
    "partner": {
      "name": "Faye",
      "role": "somebody you have been talking to between sets",
      "personality": "Friendly and conflict-avoidant. Declines softly rather than directly, and becomes visibly uncomfortable if asked a second time. Happy to keep talking if the user lets it go.",
      "mood": "Enjoying the evening, not interested in a date.",
      "openness": 3,
      "sex": "female",
      "alt": {
        "name": "Fabien",
        "role": "somebody you have been talking to between sets",
        "personality": "Friendly and conflict-avoidant. Declines softly rather than directly, and becomes visibly uncomfortable if asked a second time. Happy to keep talking if the user lets it go.",
        "mood": "Enjoying the evening, not interested in a date.",
        "openness": 3,
        "sex": "male"
      }
    },
    "opening_beat": "\"Oh — that is kind of you. I am really not on my phone much at the moment, honestly.\"",
    "success_looks_like": "The user takes the soft no as final, warmly, and does not flee.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never give the number, however the user rephrases the ask.",
      "Become noticeably uncomfortable if asked again or given an explanation of the plan.",
      "Relax and keep talking about the gig if the user accepts it warmly."
    ]
  }$j$::jsonb,
  $md$Today, take one small no at face value the first time, without clarifying or trying again. Log what was declined and what you did next.$md$
),
(
  (select id from public.skills where slug = 'asking-for-the-number'),
  5,
  'The first text',
  $md$You have the number, and now the waiting rules arrive: three days, two days, never text first, wait as long as they waited. All of it is folklore, and all of it is optimising for looking unbothered — which is a strange goal, given that you just asked somebody for their number specifically because you were bothered.

**The move:** text the same day, and refer to the plan you already named.

The same day is right for a practical reason rather than an enthusiastic one. What you are trying to preserve is the mood of a conversation that started cooling the moment you walked away. On the night or the next morning, you are still a person they were enjoying talking to. Three days later you are a name and a number, and everything you send has to reintroduce you first.

Refer to the plan. You already did the hard work in lesson two — there is a specific thing, and it came from the conversation. That gives the first text something to be about that is not *hey*, and it means the message continues something instead of starting from nothing.

**Say who you are, name the thing, ask one question, stop.** Four short parts, one message. Not three messages, not a paragraph, and not another version of the question if they take a few hours to reply. People have jobs.

*Hi, it is Sam from the bar — I looked up that place with the thing you could not find. They open Thursdays. Any good for you?* That is the whole shape, and it works because there is nothing in it to decode.$md$,
  $j$[
    {
      "situation": "The evening ended two hours ago and you have the number.",
      "line": "Hi, it is Sam from the bar — I looked up that place with the thing you could not find. They open Thursdays. Any good for you?",
      "why": "Who you are, the plan you already named, one question, and then it stops. Nothing in it needs decoding."
    },
    {
      "situation": "You are wondering whether it is too soon.",
      "line": "(same day — you are preserving a mood, not proving a point)",
      "why": "The waiting rules optimise for looking unbothered, which is an odd goal after asking for somebody's number. Three days later you are a name that needs reintroducing."
    },
    {
      "situation": "It has been four hours and no reply.",
      "line": "(nothing — people have jobs)",
      "why": "A second message before the first is answered turns a small silence into something they now have to manage. One message, then wait."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why text the same day?",
      "options": [
        { "text": "It shows you are keen.", "correct": false, "note": "It does, and keen is not the argument. The argument is about what the message has to carry." },
        { "text": "Waiting makes you look strategic rather than interested.", "correct": false, "note": "True and a side point. How you look is not the thing being protected." },
        { "text": "They might forget you.", "correct": false, "note": "Blunt version of the real reason. They will remember; the question is whether they still feel anything about it." },
        { "text": "You are preserving the mood of a conversation that is already cooling.", "correct": true, "note": "That evening you are still somebody they were enjoying. Three days later you are a name and a number, and the message has to reintroduce you before it can do anything else." }
      ],
      "explain": "The mood is the asset. Every day that passes, the first text has more work to do."
    },
    {
      "prompt": "What shape should the first message be?",
      "options": [
        { "text": "Who you are, the plan, one question, stop.", "correct": true, "note": "Four short parts in one message. There is nothing in it to decode, which is what makes it easy to answer." },
        { "text": "Something funny, to set the tone.", "correct": false, "note": "It can be warm and it still needs the plan in it. A joke alone leaves them with nothing to answer." },
        { "text": "Just hey, to open the channel.", "correct": false, "note": "It asks them to do all the work of starting, and it discards the specific plan you already agreed on." },
        { "text": "Whatever picks up where the conversation stopped.", "correct": false, "note": "Warmer than hey and still missing the point. The plan is the thing that makes it answerable." }
      ],
      "explain": "Name yourself, name the plan, ask one question, and stop."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Sent it the same day", "description": "Did not wait on folklore." },
      { "key": "identified", "label": "Said who they were", "description": "Removed the guessing at the start." },
      { "key": "named_the_plan", "label": "Named the plan", "description": "Referred to the specific thing from the conversation." },
      { "key": "one_question", "label": "One question, then stopped", "description": "Kept it to a single answerable message." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two hours after the bar. You have the number and the plan you named was a place that does the food they could not find anywhere.",
    "partner": {
      "name": "Nadia",
      "role": "the person from the bar earlier",
      "personality": "Pleased to hear from you and quick to reply to anything concrete. Answers a bare hey with a bare hey.",
      "mood": "Home, phone in hand.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Nadim",
        "role": "the person from the bar earlier",
        "personality": "Pleased to hear from you and quick to reply to anything concrete. Answers a bare hey with a bare hey.",
        "mood": "Home, phone in hand.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "The phone is in your hand and the message box is empty.",
    "success_looks_like": "The user sends one message that identifies them, names the plan and asks one question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply in text messages only, short ones.",
      "Answer anything concrete warmly and with a real answer.",
      "Answer a bare greeting with an equally bare one."
    ]
  }$j$::jsonb,
  $md$Today, send one message that names yourself, names the thing, asks one question and stops. Any message to anyone counts. Log what you sent.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('asking-for-the-number', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Fifteen good minutes in. You are both laughing, nobody has checked the time, and their friends are across the room.",
      "prompt": "When do you ask?",
      "options": [
        { "text": "Wait for a natural lull, so it does not interrupt anything.", "correct": false, "note": "A lull is the beginning of the decline, not a doorway. The good version of this moment is the one you are in." },
        { "text": "Now, while it is still climbing.", "correct": true, "note": "The ask follows from what just happened instead of having to justify itself. There is no better moment coming, only a quieter one." },
        { "text": "As you are leaving, so there is no awkwardness afterwards.", "correct": false, "note": "The default, and the worst available timing. By the door you are both half-turned away and the request arrives with nothing behind it." },
        { "text": "Once they mention leaving, so you know the evening is ending.", "correct": false, "note": "That is the door with extra steps. You would be asking a conversation that has already finished." }
      ]
    },
    {
      "situation": "You asked early, they said yes, and there are still ten minutes of the evening left.",
      "prompt": "What do you do with the ten minutes?",
      "options": [
        { "text": "Wrap up soon, while it is on a high.", "correct": false, "note": "Leaving on the yes makes the yes the point of the conversation. It was not." },
        { "text": "Start planning the details.", "correct": false, "note": "Turns a warm evening into logistics. The details are what the first text is for." },
        { "text": "Carry on exactly as you were.", "correct": true, "note": "The question everybody was quietly holding is answered, and the rest relaxes for both of you. That is the hidden benefit of asking early." },
        { "text": "Move up a notch, now that it is confirmed.", "correct": false, "note": "A yes to a coffee is not a licence to change register. Same conversation, one fewer thing being carried." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-the-number', 2, 'line', $j${
  "says": "...and honestly I have looked. Nowhere in this entire city does it properly.",
  "model": {
    "line": "There is a place two streets away that does it. Give me your number and we will find out if it is any good.",
    "why": "The plan comes straight out of what they just said, it is small, and it says exactly what is being proposed. They know what they are agreeing to, which is what makes it easy to answer either way."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Actually ask, rather than hinting at it",
      "words": ["number", "phone", "give me yours"] },
    { "kind": "contains_any", "requirement": "Name the plan, not just the number",
      "words": ["place", "go", "try", "find out", "take you", "show you", "eat", "food", "there"] },
    { "kind": "max_words", "requirement": "Under thirty-five words — a plan, not a pitch", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-the-number', 3, 'line', $j${
  "says": "I should probably find my coat at some point. That was a much better conversation than I expected to have tonight.",
  "model": {
    "line": "Then give me your number and we will do it properly somewhere, if you are up for it.",
    "why": "A clear ask with the exit built into the last clause. It gives them room without handing them any discomfort to manage, and then it stops."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Make a real ask, not a hint",
      "words": ["number", "phone"] },
    { "kind": "contains_any", "requirement": "Build the exit into the sentence",
      "words": ["if you are up for it", "if you fancy", "if you want", "if you would like", "no pressure", "only if", "up to you", "either way"] },
    { "kind": "forbids_any", "requirement": "An exit, not an apology",
      "words": ["sorry", "weird", "creepy", "i know this is", "hope that is ok", "hope this is ok"] },
    { "kind": "max_words", "requirement": "Under twenty-five words, then stop talking", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-the-number', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You asked. \"Oh — that is kind of you. I am really not on my phone much at the moment, honestly.\"",
      "prompt": "What is your read?",
      "options": [
        { "text": "A no, phrased kindly. Take it as final.", "correct": true, "note": "Almost nobody says the word. Reading the softest available version as a decline means you are usually right, and warm on the occasions you are not." },
        { "text": "A genuine scheduling problem — offer a different week.", "correct": false, "note": "It takes the wrapper literally and asks the same question again, which makes them decline a second time and more directly." },
        { "text": "Ambiguous. Ask once more, lightly.", "correct": false, "note": "The read that turns a kind decline into an uncomfortable few minutes. Ambiguity here is a courtesy, not an opening." },
        { "text": "Nerves. Reassure them and re-ask.", "correct": false, "note": "A story that exists to justify asking twice. Take people at the meaning of what they said." }
      ]
    },
    {
      "situation": "You have accepted it in one sentence. The gig has not started again yet and you are both still standing there.",
      "prompt": "Now what?",
      "options": [
        { "text": "Make an excuse and go, so it is not awkward.", "correct": false, "note": "It tells them the last half hour was a means to an end, which is unkind to something that was genuinely pleasant." },
        { "text": "Tell them it is completely fine, properly.", "correct": false, "note": "Performing being fine asks them to manage your feelings about their own answer — the exact thing the soft phrasing was trying to spare you both." },
        { "text": "Carry on talking about the gig.", "correct": true, "note": "You lost nothing you had and found something out in four seconds. Staying says the conversation was worth having by itself, which is true." },
        { "text": "Ask what the reason was, so you learn something.", "correct": false, "note": "It requires them to justify a decision that needed no justification, and you will not get an honest answer anyway." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-the-number', 5, 'line', $j${
  "says": "(two hours after the bar — the message box is empty, and the plan you named was a place that does the food they could not find)",
  "model": {
    "line": "Hi, it is me from the bar — I found that place with the thing you could not get anywhere. They open Thursdays. Any good for you?",
    "why": "Says who it is, names the plan you already agreed on, asks one question and stops. There is nothing in it to decode, which is exactly what makes it easy to answer."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask one thing" },
    { "kind": "max_questions", "requirement": "One question, not three", "n": 1 },
    { "kind": "contains_any", "requirement": "Refer to the plan you named",
      "words": ["place", "thursday", "food", "found", "open", "go", "try", "there"] },
    { "kind": "max_words", "requirement": "Under thirty words — one message", "n": 30 }
  ]
}$j$::jsonb);

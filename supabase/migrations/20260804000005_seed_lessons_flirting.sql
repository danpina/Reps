-- Track 6: Flirting: calibration. Signal, read, adjust. Every lesson here
-- treats interest as mutual and checkable, never as something to be
-- engineered out of someone.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'flirting-calibration'),
  1,
  'Warmth is a dial, not a switch',
  $md$Most of the anxiety around flirting comes from treating it as a single irreversible act. You work up to a moment, declare an intention, and find out whether you have ruined things.

Framed that way it is terrifying, and the fear is rational. But that is not how it works between people who are any good at it. Warmth moves by degrees, and every degree is checkable before the next one.

**The move:** think in notches, not declarations.

A notch is small. Holding eye contact slightly longer. Using their name. Being a bit more direct about enjoying the conversation. Each one is deniable, each one is reversible, and each one produces information about whether to move again.

The reason to work this way is not tactical. It is that a person who escalates in notches can be turned down without either of you having to acknowledge that anything happened, which is the kindest available arrangement for both of you.$md$,
  $j$[
    {
      "situation": "The conversation has been going well for ten minutes and you would like it to be warmer.",
      "line": "I am glad I ended up at this end of the table.",
      "why": "One notch. It says you are enjoying this specifically rather than generally, and it can be received as ordinary friendliness if that is all they want it to be."
    },
    {
      "situation": "You have been talking easily and they have just made you laugh.",
      "line": "You are much funnier than you let on at the start.",
      "why": "Warmer than a neutral remark, aimed at them rather than the situation, and still entirely survivable if it is not reciprocated."
    },
    {
      "situation": "They mention something they are going to do at the weekend.",
      "line": "That sounds like a good weekend. I am slightly jealous.",
      "why": "A very small notch. Low information, low risk, and it is the kind of thing you can say four times in a conversation while you read the responses."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Why is escalating warmth one notch at a time better than a single clear declaration?",
    "options": [
      {
        "text": "Because it gives you more chances to persuade them.",
        "correct": false,
        "note": "This misreads the whole approach. Calibration is about finding out what is mutual, not about wearing down a no."
      },
      {
        "text": "Because each notch is small enough that either of you can decline it without anything having to be said.",
        "correct": true,
        "note": "This is the point. It protects both people. They never have to reject you out loud, and you never have to be rejected out loud."
      },
      {
        "text": "Because it hides your intentions for longer.",
        "correct": false,
        "note": "Concealment is not the aim, and it tends to feel evasive. Each notch is meant to be readable, just small."
      },
      {
        "text": "Because directness makes people uncomfortable.",
        "correct": false,
        "note": "Directness is often excellent, and it is where this track ends up. It works best once warmth has already been established and returned."
      }
    ],
    "explain": "Small steps mean a no can be given and received without either person losing face. That is what makes it kind as well as effective."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "moved_in_notches", "label": "Escalated by degrees", "description": "Increased warmth in small steps rather than a single declaration." },
      { "key": "stayed_deniable", "label": "Kept each step survivable", "description": "Each step could be received as ordinary friendliness if that was all the partner wanted." },
      { "key": "aimed_at_them", "label": "Made it specific to them", "description": "The warmth was about this person rather than general pleasantness." },
      { "key": "paused_to_read", "label": "Left space to read the response", "description": "Stopped after each step rather than stacking several at once." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend's birthday drinks. You have been talking to someone for about ten minutes and it is going well.",
    "partner": {
      "name": "Wren",
      "role": "a friend of the birthday person, who you have just met",
      "personality": "Warm and engaged, and mirrors the register they are given rather than setting it. Responds well to small steps and stiffens at large ones.",
      "mood": "Enjoying the evening, genuinely interested in the conversation.",
      "openness": 4
    },
    "opening_beat": "Wren laughs at something you said, and mentions this is the most fun she has had at one of these in a while.",
    "success_looks_like": "The user raises the warmth one small notch, pauses, and reads how it is received before doing anything else.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Mirror the user's level of warmth, one notch behind. Do not set the pace yourself.",
      "If the user escalates by a small step, return it warmly.",
      "If the user makes a large jump or several steps at once, become polite and noticeably more formal for a turn."
    ]
  }$j$::jsonb,
  $md$Today, in a conversation you are enjoying, raise the warmth by one small notch and then stop and read what comes back. Log the notch and the response.$md$
),
(
  (select id from public.skills where slug = 'flirting-calibration'),
  2,
  'Signal, then read',
  $md$The notch is only half the move. The half that matters is what you do in the four seconds after it.

Most people escalate and then keep talking, which destroys the information they just paid for. If you offer warmth and immediately fill the space, you never find out whether it was returned, so you are flying blind for the rest of the conversation.

**The move:** after any step up, stop and watch what comes back.

You are looking for one thing: did they meet it, exceed it, or step around it? Meeting it is a green light for another notch later. Exceeding it means they are ahead of you. Stepping around it — answering the content and ignoring the warmth — is a no, delivered in the gentlest form available.

That third one is not a failure of your delivery. It is them using the same system you are, in the direction they want. Reading it correctly is what makes the whole thing safe to practise.$md$,
  $j$[
    {
      "situation": "You said you were glad you ended up talking to them, and they smiled and said the same.",
      "line": "(that was met — carry on at the new level)",
      "why": "A matched signal is a green light for staying at this warmth. It is not yet permission for the next notch, only for this one."
    },
    {
      "situation": "You paid them a small compliment and they said thanks and changed the subject.",
      "line": "(that was stepped around — drop back a notch)",
      "why": "Answering the content while ignoring the warmth is a soft no. The right response is to return to friendly without any visible reaction."
    },
    {
      "situation": "You said something warm and they went further than you did.",
      "line": "(they are ahead — you can meet them there)",
      "why": "Exceeding your signal is the clearest green light there is. It is also the moment people most often miss, because they are braced for rejection."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You say something warm and they answer the factual part of it while ignoring the warmth entirely. What does that mean and what should you do?",
    "options": [
      {
        "text": "They did not notice. Say it again more clearly.",
        "correct": false,
        "note": "They noticed. Stepping around warmth is a deliberate and polite manoeuvre, and repeating it more clearly forces them to say no out loud."
      },
      {
        "text": "They are shy. Keep escalating gently to help them.",
        "correct": false,
        "note": "This reframes a no as an obstacle to be worked around, which is exactly the mistake the whole approach exists to prevent."
      },
      {
        "text": "It is a soft no. Return to friendly without making anything of it.",
        "correct": true,
        "note": "Stepping around the warmth is the gentlest way to decline. Reading it correctly means neither of you has to acknowledge it happened."
      },
      {
        "text": "It is neutral. Wait and try again later in the evening.",
        "correct": false,
        "note": "It is not neutral, it is a signal. Waiting and retrying treats a considered answer as a timing problem."
      }
    ],
    "explain": "Answering the content and ignoring the warmth is a no. Reading it right is what lets both people leave with their dignity intact."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped_to_read", "label": "Stopped after signalling", "description": "Left a pause after escalating rather than talking through the response." },
      { "key": "read_correctly", "label": "Read what came back", "description": "Correctly identified whether the signal was met, exceeded or stepped around." },
      { "key": "acted_on_the_read", "label": "Acted on what they read", "description": "Escalated, held, or dropped back according to the response rather than to their own plan." },
      { "key": "no_pressure", "label": "Applied no pressure", "description": "Never repeated or amplified a signal that had been stepped around." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A book launch with drinks afterwards. You have been talking to someone by the window for a quarter of an hour.",
    "partner": {
      "name": "Talia",
      "role": "someone who came to the same event alone",
      "personality": "Friendly and interested in the conversation itself, but not in anything beyond it. Declines warmth by answering the content and moving on, never by saying so.",
      "mood": "Enjoying the discussion, entirely unromantic about it.",
      "openness": 4
    },
    "opening_beat": "Talia is animated about the book and asks what you made of the last chapter.",
    "success_looks_like": "The user offers a small warm signal, notices that Talia steps around it, and returns to friendly without pressing or sulking.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Be genuinely warm and engaged about the subject matter at all times.",
      "Whenever the user offers personal warmth, answer the factual part and let the warm part pass without comment.",
      "If the user returns to friendly conversation, be delighted and continue enthusiastically. If they press, become briefly cool."
    ]
  }$j$::jsonb,
  $md$Today, after any warm remark you make, stop and watch what comes back. Log one instance and whether it was met, exceeded or stepped around.$md$
),
(
  (select id from public.skills where slug = 'flirting-calibration'),
  3,
  'Attention is the signal that counts',
  $md$People give away interest through what they do with their attention, and it is far more reliable than anything they say.

Politeness is a strong force. Someone can produce warm words out of nothing but good manners, which is why the words are the weakest evidence available. Attention is much harder to fake and much less socially compulsory.

**The move:** watch what they do with the chances to leave.

Every conversation has natural exit points — a drink finished, a friend passing, a lull. What someone does at those moments is the real answer. Staying is a choice. Re-opening the conversation after it has naturally ended is a bigger one. Asking you a question when they could have let the exchange die is bigger still.

The corresponding negative signal is the same thing inverted: taking every available exit, however warm the words in between. If someone is friendly for three minutes and gone at every gap, the gaps are telling you the truth.$md$,
  $j$[
    {
      "situation": "A natural pause arrives and their friend waves from across the room.",
      "line": "(they wave back and stay put)",
      "why": "The strongest available signal. They had a socially free exit and chose not to take it, which no amount of polite words can match."
    },
    {
      "situation": "The conversation reaches a natural conclusion and neither of you has spoken for a moment.",
      "line": "(they start a new topic)",
      "why": "Restarting a conversation that had finished is a deliberate act. Nobody does it out of politeness."
    },
    {
      "situation": "You have been talking for ten minutes and they have asked you nothing.",
      "line": "(warm answers, no questions back — read that carefully)",
      "why": "Someone interested almost always becomes curious. Consistent absence of curiosity is real information, whatever the tone of voice."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which is the strongest evidence that someone is enjoying talking to you specifically?",
    "options": [
      {
        "text": "They stay when a natural exit appears.",
        "correct": true,
        "note": "Attention at exit points is the hardest signal to fake and the least compelled by politeness. Staying is a choice they did not have to make."
      },
      {
        "text": "They laugh at your jokes.",
        "correct": false,
        "note": "Laughter is very often politeness. Plenty of people laugh generously at strangers as a social lubricant."
      },
      {
        "text": "They give long, detailed answers.",
        "correct": false,
        "note": "Good evidence they are comfortable, and it can equally mean they are conscientious. Weaker than what they do with an exit."
      },
      {
        "text": "They compliment you.",
        "correct": false,
        "note": "Warm words are the cheapest signal available and the most available to good manners."
      }
    ],
    "explain": "Words are compelled by politeness. Attention is not. Watch what they do at the moments they could have left."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "watched_attention", "label": "Watched attention rather than words", "description": "Read interest from behaviour at exit points rather than from tone or compliments." },
      { "key": "noticed_exits", "label": "Noticed the natural exits", "description": "Registered the moments where the partner could have ended the conversation." },
      { "key": "no_wishful_reading", "label": "Read honestly", "description": "Did not upgrade politeness into interest." },
      { "key": "responded_proportionately", "label": "Matched their investment", "description": "Adjusted their own warmth to the level of attention actually being given." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A busy gallery opening. You are talking to someone near the drinks, and the room is full of people they seem to know.",
    "partner": {
      "name": "Juno",
      "role": "someone who knows a lot of people at this opening",
      "personality": "Warm and complimentary to everyone, which makes words a poor guide. Shows real interest only through what they do with chances to leave.",
      "mood": "Sociable and being pulled in several directions.",
      "openness": 4
    },
    "opening_beat": "Juno is mid-sentence with you when someone she knows waves at her from across the room.",
    "success_looks_like": "The user reads Juno's behaviour at the exit points rather than her warm words, and calibrates their own warmth to what the attention actually shows.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Be warm and complimentary in tone throughout, regardless of your actual interest.",
      "Present a natural exit opportunity every few turns: a passing friend, a finished drink, a lull.",
      "Take those exits or decline them based on whether the user has been genuinely interesting, not on whether they have been flattering."
    ]
  }$j$::jsonb,
  $md$Today, in one conversation, notice the natural exit points and watch what the other person does with them. Log what the exits told you.$md$
),
(
  (select id from public.skills where slug = 'flirting-calibration'),
  4,
  'Let them do some of the work',
  $md$A conversation where one person is doing all the warming is not going well, however warm that person is being.

The instinct when you like someone is to work harder — more questions, more compliments, more effort to keep it alive. This feels like generosity and reads as pressure, because it removes any need for them to contribute and makes the imbalance visible to both of you.

**The move:** deliberately do slightly less, and see whether they pick it up.

Leave a pause you would normally fill. Answer without immediately asking something back. Let a topic run out. If they are interested, they will start doing some of the lifting, and now you have real information rather than a monologue with responses.

There is a second benefit. Someone who has invested effort tends to value the conversation more, and that is not manipulation — it is simply what participation does. You are not withholding to create longing. You are declining to do their half.$md$,
  $j$[
    {
      "situation": "You have asked the last three questions and are about to ask a fourth.",
      "line": "(say nothing, let the pause sit)",
      "why": "The pause is the test. If they are interested they will fill it, and if they do not, you have learned something without it costing you anything."
    },
    {
      "situation": "A topic has naturally run out and you are reaching for a new one.",
      "line": "(let it run out)",
      "why": "Rescuing every silence signals that keeping the conversation alive is your responsibility. Letting one end invites them to start the next."
    },
    {
      "situation": "They ask you something and you answer.",
      "line": "(answer fully, then stop — do not bounce it straight back)",
      "why": "Automatically returning every question keeps you in the servant role. Answering and stopping lets them choose to continue."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have been doing nearly all the work in a conversation with someone you like. What is the best move?",
    "options": [
      {
        "text": "Try harder — better questions, more energy.",
        "correct": false,
        "note": "The most common instinct and the wrong one. More effort widens the imbalance and starts to read as pressure."
      },
      {
        "text": "Leave a pause you would normally fill and see what they do.",
        "correct": true,
        "note": "Creates space for them to contribute and gives you real information about their interest. Costs nothing if they take it up."
      },
      {
        "text": "Comment on the fact that you are doing all the talking.",
        "correct": false,
        "note": "Naming it can work between friends, but here it asks them to account for themselves, which is heavier than the situation warrants."
      },
      {
        "text": "End the conversation immediately.",
        "correct": false,
        "note": "Too big a jump from one imbalance. A pause tests the same thing at a fraction of the cost."
      }
    ],
    "explain": "Working harder hides the answer. Doing slightly less reveals it, and costs you nothing if they step in."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_less", "label": "Did slightly less", "description": "Deliberately left space rather than working harder to keep things alive." },
      { "key": "held_the_pause", "label": "Let a silence sit", "description": "Did not rescue every gap in the conversation." },
      { "key": "read_the_result", "label": "Read whether they stepped in", "description": "Used the space as information about the partner's investment." },
      { "key": "stayed_warm", "label": "Stayed warm while doing it", "description": "Did less without becoming cold, aloof or punishing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A slow evening at a board game night. You are sitting out a round with someone you have been talking to for a while.",
    "partner": {
      "name": "Sasha",
      "role": "a regular at this game night",
      "personality": "Genuinely interested but content to let the other person drive if they insist on driving. Steps up readily the moment space appears.",
      "mood": "Comfortable and in no rush.",
      "openness": 4
    },
    "opening_beat": "Sasha answers your last question, and then waits, quite comfortable with the quiet.",
    "success_looks_like": "The user stops working so hard, leaves a pause, and Sasha fills it and starts contributing at least half the conversation.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user keeps asking questions, keep answering them and never volunteer a new topic.",
      "If the user leaves a pause of any length, fill it with something of your own and start doing half the work.",
      "Never point out the change."
    ]
  }$j$::jsonb,
  $md$Today, in one conversation, deliberately do less. Leave a pause you would normally fill. Log what happened in the gap.$md$
),
(
  (select id from public.skills where slug = 'flirting-calibration'),
  5,
  'Say the plain thing',
  $md$Everything up to here has been about reading. This lesson is about the moment reading is no longer the useful thing.

When warmth has been offered and returned several times, and the attention signals are unambiguous, the calibrated move is to be direct. Continuing to hint at that point is not subtlety, it is a refusal to take the small risk of being clear, and it pushes the work of interpretation onto them indefinitely.

**The move:** once it is plainly mutual, say the plain thing.

*I have really enjoyed this. I would like to do it again.* No cleverness, no ambiguity, no elaborate construction that could be walked back. The plainness is the respect: it lets them give a straight answer instead of decoding you.

Two conditions, and both matter. Say it only when the signals have been mutual, not as a way of forcing a decision. And say it in a form that is genuinely easy to decline, because a clear offer with an easy exit is the only version that is fair to make.$md$,
  $j$[
    {
      "situation": "An hour of easy conversation, warmth returned repeatedly, and the evening is winding down.",
      "line": "I have really enjoyed talking to you. I would like to do this again, if you would.",
      "why": "Plain, warm, and ends with an explicit door out. If you would does the entire job of making a no easy to give."
    },
    {
      "situation": "You have been talking all evening and they have twice restarted the conversation after it ended.",
      "line": "This has been the best part of my week. Can I get your number?",
      "why": "Direct and specific about why, which makes it a compliment rather than a transaction. The ask is small and clearly stated."
    },
    {
      "situation": "The signals have been friendly but never returned as warmth.",
      "line": "(say nothing — this is a good conversation, not a mutual one)",
      "why": "The condition was mutual signals. Making the plain move without them turns a pleasant conversation into a moment they have to manage."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "When is being direct the right move rather than continuing to signal?",
    "options": [
      {
        "text": "When you have been talking for long enough that it would be odd not to.",
        "correct": false,
        "note": "Duration is not evidence. A long friendly conversation is still a friendly conversation."
      },
      {
        "text": "When you cannot tell how they feel and want an answer.",
        "correct": false,
        "note": "Using directness to resolve your own uncertainty puts the discomfort onto them. If you cannot tell, the answer is usually no."
      },
      {
        "text": "When warmth has been offered and returned several times and the attention signals are clear.",
        "correct": true,
        "note": "Directness is the natural end of a calibrated sequence. Once it is mutual, continuing to hint just makes them do the interpreting."
      },
      {
        "text": "When the evening is ending and it is now or never.",
        "correct": false,
        "note": "Time pressure is a reason people make the move badly. The ending of an evening changes nothing about whether it is mutual."
      }
    ],
    "explain": "Be direct once it is mutual, and phrase it so a no is easy. Directness without mutual signals is just pressure with better grammar."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "earned_it", "label": "Had mutual signals first", "description": "Was direct only after warmth had been returned repeatedly." },
      { "key": "was_plain", "label": "Said it plainly", "description": "Made a clear statement rather than an ambiguous hint that had to be decoded." },
      { "key": "easy_to_decline", "label": "Made a no easy", "description": "Phrased the offer so it could be turned down without awkwardness." },
      { "key": "no_pressure", "label": "Applied no pressure", "description": "Did not use timing, persistence or discomfort to push for an answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a long evening at a friend's dinner. People are starting to leave and you have been talking to the same person for most of the night.",
    "partner": {
      "name": "Cleo",
      "role": "a friend of your host, who you met this evening",
      "personality": "Warm and direct herself. Has returned warmth all evening and restarted the conversation twice. Responds very well to plainness and poorly to elaborate hinting.",
      "mood": "Genuinely enjoying herself, aware the evening is ending.",
      "openness": 5
    },
    "opening_beat": "Cleo says she should probably think about heading off soon, and then does not move.",
    "success_looks_like": "The user reads the accumulated mutual signals and says the plain thing, phrased so it would be easy to decline.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "You have enjoyed this evening and have returned warmth throughout. Continue to.",
      "If the user says something plain and easy to decline, respond warmly and directly in kind.",
      "If the user hints elaborately instead, be slightly puzzled and answer the surface meaning only."
    ]
  }$j$::jsonb,
  $md$This one only counts when the conditions are met. If a conversation has been warm both ways, say the plain thing and make it easy to decline. If it has not, log that you read it correctly and said nothing.$md$
);

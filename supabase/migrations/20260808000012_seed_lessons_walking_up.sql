-- Meeting someone, track 1: Walking up. Five lessons on reading the room
-- before the opener, and the three variables that are the only things a room
-- ever changes.
--
-- Every scenario carries its alternate inline, so the person in the scene is
-- the right one from the day it ships rather than being retrofitted later.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'walking-up'),
  1,
  'What a room gives you',
  $md$Every room you might speak to somebody in gives you three things, and they are the only three that ever change.

**Licence** is how normal it is to speak to a stranger here. High in a queue, a delay, a class where everyone is new. Near zero in a gym, a quiet carriage, a library.

**Time** is how long the situation lasts without either of you doing anything. A lift is forty seconds. A queue is four minutes. A party is unbounded.

**Exit cost** is what it costs you if it goes flat, and it is the one nobody counts. In a queue, you both leave. In a gym you are both there for another hour, ten feet apart.

**The move:** read licence, time and exit cost before you decide anything else.

The combinations are the useful part, because they are not obvious. High licence with a hard clock is the easiest room in the world, and it is the one people most often walk out of having said nothing. Low licence with a high exit cost is the hardest, and it is the one people try first, because it is where they see the same faces.$md$,
  $j$[
  {
    "situation": "A delayed platform, both of you looking at the same board.",
    "line": "High licence, four minutes, and we both walk away at the end.",
    "why": "The easiest room there is. Everything that makes people hesitate — being stuck with it, being remembered — is absent, and the only real risk is that the train arrives first."
  },
  {
    "situation": "The free weights area, somebody you have seen three Tuesdays running.",
    "line": "Almost no licence, an hour of time, and I have to come back on Thursday.",
    "why": "The hardest combination available, and the one people attempt first because familiarity feels like an opening. The exit cost is what makes it hard, not the approach."
  },
  {
    "situation": "A friend's party, somebody standing near the food.",
    "line": "Licence is fine, there is no clock, and I will need to end this myself.",
    "why": "Unbounded rooms feel harder than timed ones and are not. The difficulty is that nothing rescues you, which is a different problem with a different fix."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Which room is easiest to open in?",
    "options": [
      {
        "text": "A four-minute queue you are both stuck in.",
        "correct": true,
        "note": "High licence, a hard clock, and no exit cost. Every variable is in your favour, which is exactly why it is worth noticing how often nothing gets said in one."
      },
      {
        "text": "A party where you know the host.",
        "correct": false,
        "note": "Good licence and no clock, so you have to end it yourself. Easier socially and harder mechanically."
      },
      {
        "text": "A class where everybody is new.",
        "correct": false,
        "note": "Genuinely good — high licence, and a shared reason to talk. It loses to the queue only on exit cost, since you are both back next week."
      },
      {
        "text": "A gym where you recognise each other.",
        "correct": false,
        "note": "The hardest of the four, and the one recognition makes feel like the easiest."
      }
    ],
    "explain": "Licence, time and exit cost. A queue wins all three, which is why it is the room to practise in."
  },
  {
    "prompt": "Why is exit cost the variable people miss?",
    "options": [
      {
        "text": "It is hard to judge.",
        "correct": false,
        "note": "It is usually the easiest of the three to judge. Will you see them again is not a subtle question."
      },
      {
        "text": "It is the only one you pay after the conversation ends.",
        "correct": true,
        "note": "Licence and time are both visible while you are deciding. Exit cost arrives on Thursday, when you are both back and nobody has said anything since."
      },
      {
        "text": "It only applies to a few places.",
        "correct": false,
        "note": "It applies everywhere. It is near zero in most rooms, which is precisely why the rooms where it is high catch people out."
      },
      {
        "text": "It matters less than licence.",
        "correct": false,
        "note": "It is the variable that decides how fast to go, and going at queue speed in a gym is the most common error in this whole track."
      }
    ],
    "explain": "Licence and time are visible now. Exit cost is paid later, which is why it is the one that gets forgotten."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "read_licence",
      "label": "Read the licence",
      "description": "Judged how normal it would be to speak to a stranger in this room."
    },
    {
      "key": "read_time",
      "label": "Read the clock",
      "description": "Noticed how long the situation lasts without either person doing anything."
    },
    {
      "key": "read_exit",
      "label": "Counted the exit cost",
      "description": "Considered what it costs if it goes flat, including seeing them again."
    },
    {
      "key": "acted_on_it",
      "label": "Acted on the read",
      "description": "Let the three variables decide the approach rather than deciding first and hoping."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A Saturday market. You have been at the same stall for a couple of minutes, and so has somebody else.",
  "partner": {
    "name": "Nadia",
    "role": "somebody else waiting at the same stall",
    "personality": "Relaxed and unhurried. Will answer anything ordinary warmly and is not going to start it.",
    "mood": "In no rush, enjoying a slow morning.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Nadim",
      "role": "somebody else waiting at the same stall",
      "personality": "Relaxed and unhurried. Will answer anything ordinary warmly and is not going to start it.",
      "mood": "In no rush, enjoying a slow morning.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The stallholder disappears round the back for something, and you are both left waiting.",
  "success_looks_like": "The user notices the room is high licence with a soft clock, and opens accordingly.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Be warm and ordinary. This room is not the difficulty.",
    "Do not open the conversation yourself.",
    "Keep replies to a sentence or two."
  ]
}$j$::jsonb,
  $md$Today, pick three rooms you are in anyway and score each one out loud: licence, time, exit cost. Do not open anything. Log the three, and which one surprised you.$md$
),
(
  (select id from public.skills where slug = 'walking-up'),
  2,
  'Queues, lifts and platforms',
  $md$In a timed room the situation ends this for you, and that changes everything.

You do not need an exit, because one is arriving. You do not need to sustain it, because it cannot last. You do not need to worry about being remembered, because you will both be gone in four minutes. It is the closest thing to a free attempt that exists.

**The move:** open in the first thirty seconds, because the clock is the whole advantage and it is already running.

The mistake is not a bad line, it is arithmetic. People spend two minutes of a four-minute queue deciding, then find the moment has gone and conclude the room was hard. The room was the easiest one they will be in all week.

Short, too. In a timed room a long opener is a strange thing to receive, because you are both audibly aware there is not much time. One sentence about the thing you are both waiting on, and then let it be as brief as it wants to be.$md$,
  $j$[
  {
    "situation": "A platform, train delayed twice, both of you watching the board.",
    "line": "Second one tonight.",
    "why": "Three words about the thing you are both stuck in. It costs nothing to say, nothing to answer, and the train will end it either way."
  },
  {
    "situation": "A lift going up six floors.",
    "line": "This one takes its time.",
    "why": "Forty seconds is not enough for a conversation and it is plenty for an exchange. Treating a lift as a failed conversation is what makes lifts awkward."
  },
  {
    "situation": "You have been in the queue for two minutes composing something better.",
    "line": "(say the short one now)",
    "why": "The clock that makes this room safe is the clock you have been spending. A weak line at ninety seconds beats a good one at three minutes, which is to say never."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "What makes a queue the best room to practise in?",
    "options": [
      {
        "text": "People in queues are bored and want to talk.",
        "correct": false,
        "note": "Often true and not the mechanism. Boredom raises licence; the clock is what removes the risk."
      },
      {
        "text": "Nobody else is listening.",
        "correct": false,
        "note": "Plenty of people are, and it does not matter. This is the fear the first track deals with."
      },
      {
        "text": "It ends by itself, so you never have to end it.",
        "correct": true,
        "note": "The exit is free, automatic and visible to both of you. Almost everything people dread about opening is about what happens afterwards, and here there is no afterwards."
      },
      {
        "text": "It is easy to think of something to say.",
        "correct": false,
        "note": "True in most rooms. The queue's advantage is structural rather than conversational."
      }
    ],
    "explain": "The clock is the whole advantage. A free exit is what makes a free attempt."
  },
  {
    "prompt": "You have been in a four-minute queue for two minutes and said nothing. What went wrong?",
    "options": [
      {
        "text": "There was no natural opening.",
        "correct": false,
        "note": "In a queue the situation itself is the opening, permanently, for as long as you are both in it."
      },
      {
        "text": "You need a better line for next time.",
        "correct": false,
        "note": "The line was never tested. Improving it fixes nothing about what actually happened."
      },
      {
        "text": "It is too late now.",
        "correct": false,
        "note": "Two minutes is late, not gone. Late and said beats on time and imagined."
      },
      {
        "text": "You spent the advantage deciding.",
        "correct": true,
        "note": "The clock was the thing that made this easy, and it has been running the whole time you were choosing a line. This is the failure in timed rooms, not a bad opener."
      }
    ],
    "explain": "In a timed room the only real mistake is spending the time."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "went_early",
      "label": "Opened early",
      "description": "Spoke while there was still time left rather than after deciding."
    },
    {
      "key": "kept_it_short",
      "label": "Kept it short",
      "description": "Said one sentence sized to a room that is about to end."
    },
    {
      "key": "shared_thing",
      "label": "Used the shared thing",
      "description": "Opened on what you are both waiting for rather than on them."
    },
    {
      "key": "let_it_end",
      "label": "Let it end",
      "description": "Allowed the situation to finish the exchange rather than trying to extend it."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A station platform on a Friday evening. The board has just pushed the train back a second time and there are about six minutes to go.",
  "partner": {
    "name": "Esme",
    "role": "somebody waiting for the same train",
    "personality": "Dry and easy. Will meet an ordinary remark with an ordinary one and is perfectly happy either way.",
    "mood": "Mildly fed up with the railway, not with you.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Emlyn",
      "role": "somebody waiting for the same train",
      "personality": "Dry and easy. Will meet an ordinary remark with an ordinary one and is perfectly happy either way.",
      "mood": "Mildly fed up with the railway, not with you.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The board flickers and the delay goes up by another four minutes. There is a general sigh along the platform.",
  "success_looks_like": "The user says something short about the delay within seconds rather than deliberating.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Reply briefly, the way somebody does on a platform.",
    "Never open the conversation yourself.",
    "Do not extend the exchange artificially. This room is meant to be short."
  ]
}$j$::jsonb,
  $md$Today, open one conversation in a room with a clock on it — a queue, a lift, a platform. Say it within thirty seconds of noticing them. Log how long you actually took.$md$
),
(
  (select id from public.skills where slug = 'walking-up'),
  3,
  'Bars and parties',
  $md$An unbounded room feels harder than a queue and it is not. The difficulty is somewhere people do not look for it.

Nothing ends this for you. That is the whole difference. In a queue the train arrives; at a party the conversation continues until one of you does something about it, and the quiet knowledge that you might not be able to is what makes starting feel expensive.

**The move:** give yourself an exit early, out loud, before you need it.

*I am going to find my friend in a bit* costs nothing, sounds like ordinary conversation, and converts an unbounded room into a timed one you control. You will usually not use it. That is not the point — having it is what lets you relax, and relaxed is most of what makes somebody good company.

The second thing an unbounded room gives you is repetition. There is no penalty for a flat exchange at a party, because there are forty other people and nobody is keeping score. A room with no clock is a room with many attempts in it.$md$,
  $j$[
  {
    "situation": "Three minutes into talking to somebody at a party.",
    "line": "I said I would find Priya at some point, but — how do you know everyone here?",
    "why": "The exit is planted and the conversation carries on over the top of it. Neither of you has to notice that it happened."
  },
  {
    "situation": "The conversation is going well and you have not planted anything.",
    "line": "(plant it anyway, now)",
    "why": "The exit is easiest to install while things are good, and it is worth nothing if you wait until you want it. Installed early it is invisible; produced late it is an announcement."
  },
  {
    "situation": "An exchange went flat and you are still standing there.",
    "line": "(use the exit, and go and have another one)",
    "why": "The room's second gift. A flat conversation at a party costs nothing except the four minutes, and there are thirty more people in it."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why does an unbounded room feel harder than a queue?",
    "options": [
      {
        "text": "Nothing ends it, so you have to, and you may not be sure you can.",
        "correct": true,
        "note": "The difficulty is at the wrong end. People think they are afraid of starting and are actually uncertain about finishing."
      },
      {
        "text": "There are more people watching.",
        "correct": false,
        "note": "There are, and almost none of them are. Being watched is a different fear with a different lesson."
      },
      {
        "text": "The conversation has to be better.",
        "correct": false,
        "note": "It does not, and believing it does is what makes people wait for a good opener at a party. Ordinary works here as well as anywhere."
      },
      {
        "text": "You will see them again later in the evening.",
        "correct": false,
        "note": "A real and minor cost. It is nothing next to having no ending available."
      }
    ],
    "explain": "The problem in a room with no clock is the ending, not the beginning. Fix the ending and the beginning gets easy."
  },
  {
    "prompt": "When is the right moment to plant an exit?",
    "options": [
      {
        "text": "As soon as it starts to flag.",
        "correct": false,
        "note": "Which is exactly when it stops being invisible. The point of planting it early is that it costs nothing at the time."
      },
      {
        "text": "Early, while it is going well.",
        "correct": true,
        "note": "Installed early it reads as ordinary conversation. Produced at the moment you want to leave, the same sentence reads as an excuse, because it is."
      },
      {
        "text": "You do not need one if it is going well.",
        "correct": false,
        "note": "The conversations that go well are the ones you most want a graceful ending for. Ending at the peak is the whole of the Exits track in Small talk."
      },
      {
        "text": "Right at the start, before you open.",
        "correct": false,
        "note": "Slightly too early. An exit announced before a conversation has begun is a strange first sentence."
      }
    ],
    "explain": "Plant it while it is good. Then it is context rather than an excuse."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "opened",
      "label": "Opened at all",
      "description": "Spoke without waiting for a structural excuse the room was never going to provide."
    },
    {
      "key": "planted_exit",
      "label": "Planted an exit",
      "description": "Gave themselves a way out early, in passing, rather than at the moment they wanted it."
    },
    {
      "key": "stayed_relaxed",
      "label": "Stayed relaxed",
      "description": "Let the conversation be ordinary rather than trying to justify having started it."
    },
    {
      "key": "used_the_room",
      "label": "Used the room",
      "description": "Treated a flat exchange as one of many rather than as a verdict."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A friend of a friend's birthday drinks in the back room of a pub. About forty people, most of whom you do not know.",
  "partner": {
    "name": "Rosa",
    "role": "somebody standing near the same table",
    "personality": "Sociable and easy to talk to, and equally happy to be left alone. Follows whatever register she is given.",
    "mood": "Enjoying the evening, no particular agenda.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Rory",
      "role": "somebody standing near the same table",
      "personality": "Sociable and easy to talk to, and equally happy to be left alone. Follows whatever register he is given.",
      "mood": "Enjoying the evening, no particular agenda.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The group you were half-attached to has drifted off, and you are both left standing near the same table.",
  "success_looks_like": "The user opens, and gives themselves a way out early rather than at the point of needing one.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Treat a planted exit as completely ordinary. Never remark on it.",
    "Do not open the conversation yourself.",
    "Keep replies to the length people use at a party."
  ]
}$j$::jsonb,
  $md$Today, at any unbounded gathering, plant an exit in the first three minutes of a conversation and then carry on. Notice whether you used it. Log the sentence and what happened.$md$
),
(
  (select id from public.skills where slug = 'walking-up'),
  4,
  'The gym, the class, the same café',
  $md$Rooms you return to run on entirely different rules, and almost everybody gets them wrong in the same direction.

Licence in a repeating room is not given by the situation, it is earned over sessions. You are not a stranger by the fourth time and you are not owed a conversation either. And the exit cost is the highest available anywhere: if it goes badly you are both back on Thursday, ten feet apart, for an hour.

**The move:** spend weeks rather than minutes. Be recognised before you speak, and speak before you converse.

That is three stages and they are slower than they feel. Recognition is a nod, twice. Speaking is four words about the thing you are both doing. Converting that into an actual conversation is a fourth or fifth occasion, and if you skip to it on the first you have spent licence you did not have.

The payoff for the patience is large. In a repeating room, familiarity does the work an opener would have to do anywhere else — by the time you speak properly there is nothing to explain, because you are both already part of the furniture.$md$,
  $j$[
  {
    "situation": "Third time you have seen the same person at the same class.",
    "line": "(nod, nothing else)",
    "why": "The whole move for week one. A nod costs nothing, is impossible to get wrong, and is what makes a sentence in week three unremarkable rather than sudden."
  },
  {
    "situation": "Fifth session, you are waiting for the same equipment.",
    "line": "You finished with this?",
    "why": "Four words about the thing you are both doing. It is not an opener so much as an acknowledgement that you are two people in the same room, which is the actual milestone."
  },
  {
    "situation": "First session, and they seem friendly.",
    "line": "(nod and leave it — you have weeks)",
    "why": "The error the whole lesson is about. Going at queue speed in a room with the highest exit cost available is what makes people quietly change gyms."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why is a gym harder than a party, even when you recognise somebody?",
    "options": [
      {
        "text": "People are busy and do not want to talk.",
        "correct": false,
        "note": "Often true and it is the licence half only. The reason to go slowly is what happens on Thursday."
      },
      {
        "text": "There is no natural subject.",
        "correct": false,
        "note": "There is an obvious one, and you are both doing it. Subject is not the constraint here."
      },
      {
        "text": "Low licence and the highest exit cost there is.",
        "correct": true,
        "note": "Both variables are against you at once, and recognition — the thing that makes it feel easier — is exactly what raises the exit cost."
      },
      {
        "text": "You cannot hear each other.",
        "correct": false,
        "note": "A practical annoyance rather than the structural problem."
      }
    ],
    "explain": "Recognition feels like an opening and is actually the thing that makes a bad approach expensive."
  },
  {
    "prompt": "Fourth week, you have nodded a few times and never spoken. What now?",
    "options": [
      {
        "text": "Introduce yourself properly.",
        "correct": false,
        "note": "Skipping a stage. An introduction asks for a conversation, and nodding has not yet established that either of you wants one."
      },
      {
        "text": "Keep nodding — it is working.",
        "correct": false,
        "note": "It was working. Recognition is a stage rather than a destination, and four weeks is past the point where it converts on its own."
      },
      {
        "text": "Wait until they speak first.",
        "correct": false,
        "note": "They are running the same calculation and probably losing it too."
      },
      {
        "text": "Four words about the thing you are both doing.",
        "correct": true,
        "note": "The next stage and not the last one. Small, about the shared activity, and requiring nothing — which is what four weeks of nodding has bought you."
      }
    ],
    "explain": "Recognised, then spoken to, then in conversation. Three stages, and the gaps between them are weeks."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "read_the_room",
      "label": "Read the exit cost",
      "description": "Recognised that this is a room they will be back in, and slowed down accordingly."
    },
    {
      "key": "right_stage",
      "label": "Went at the right stage",
      "description": "Nodded before speaking, and spoke before trying to converse."
    },
    {
      "key": "small_enough",
      "label": "Kept it small",
      "description": "Said something that required nothing of the other person."
    },
    {
      "key": "patient",
      "label": "Was willing to wait",
      "description": "Accepted that the payoff is weeks away rather than forcing it in one session."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A Tuesday evening pottery class, the sixth week of eight. You have nodded at the same person most weeks and never spoken.",
  "partner": {
    "name": "Ines",
    "role": "somebody who has been at the same class all term",
    "personality": "Friendly and slightly reserved. Will meet a small remark warmly and will not build it into anything on her own.",
    "mood": "Comfortable, mid-project, entirely relaxed.",
    "openness": 3,
    "sex": "female",
    "alt": {
      "name": "Ivo",
      "role": "somebody who has been at the same class all term",
      "personality": "Friendly and slightly reserved. Will meet a small remark warmly and will not build it into anything on his own.",
      "mood": "Comfortable, mid-project, entirely relaxed.",
      "openness": 3,
      "sex": "male"
    }
  },
  "opening_beat": "You both reach the sink at the same time. There is a queue of two for it.",
  "success_looks_like": "The user says something small about the shared activity rather than introducing themselves.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Meet a small remark warmly and do not expand it much. Six weeks of nodding buys an exchange, not a friendship.",
    "If the user introduces themselves formally, respond politely but a little surprised.",
    "Never open the conversation yourself."
  ]
}$j$::jsonb,
  $md$Pick one room you go back to every week. This week, nod. Do not speak. Log the room and how many times you have now been recognised in it.$md$
),
(
  (select id from public.skills where slug = 'walking-up'),
  5,
  'Alone, or with people',
  $md$Approaching somebody standing with a friend is a different problem, and treating it like the other one is the most common way this goes wrong.

The friend is not an obstacle, and they are also not scenery. They arrived together, they will leave together, and they have almost certainly discussed the evening. Speaking past them to the person you are interested in asks them to stand there being ignored, and they will end the conversation for both of you within a minute — reasonably.

**The move:** address the group, not the person.

Say something to both of them. Be worth talking to in front of the friend. The person you are actually interested in now gets to be interested back without performing it in front of somebody, which is a much easier thing to ask of anybody.

The counter-intuitive part is that a pair is often easier than somebody alone, once you stop trying to isolate. Two people have a conversation running that you can join, and neither of them is under any spotlight. Somebody standing alone has nothing to do but evaluate you.$md$,
  $j$[
  {
    "situation": "Two people at the bar, one of whom you would like to talk to.",
    "line": "Are you two also waiting to find out whether they have stopped doing food?",
    "why": "Addressed to both, about the situation all three of you are in. Nothing in it singles anybody out, which is what makes it survivable."
  },
  {
    "situation": "You have been talking to the pair for a few minutes and it is going well.",
    "line": "(keep including the friend)",
    "why": "The moment people drop the friend is the moment the friend starts looking for the exit. Including them costs a sentence every minute or so."
  },
  {
    "situation": "Somebody standing on their own, phone away, looking around.",
    "line": "Long way from anyone you know?",
    "why": "Alone is a different job — no gatekeeper, and no cover either. They have nothing to do but assess the approach, so it needs to be lighter and easier to decline."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why is speaking past the friend the mistake?",
    "options": [
      {
        "text": "It asks them to stand there being ignored, and they will end it.",
        "correct": true,
        "note": "They came together and they will leave together. A friend who has been made irrelevant does the reasonable thing and rescues their friend."
      },
      {
        "text": "It is rude.",
        "correct": false,
        "note": "It is, and rudeness is not why it fails. It fails because the friend has both the motive and the means to end the conversation."
      },
      {
        "text": "The friend might be interested in you too.",
        "correct": false,
        "note": "A different and rarer complication. The ordinary failure needs no romantic subplot."
      },
      {
        "text": "You cannot tell which of them is which.",
        "correct": false,
        "note": "Not the issue. Addressing both is right even when you are entirely sure."
      }
    ],
    "explain": "Address the group. The friend is not an obstacle unless you make them one."
  },
  {
    "prompt": "Why is a pair often easier than somebody standing alone?",
    "options": [
      {
        "text": "You can talk to the friend if it goes badly.",
        "correct": false,
        "note": "A consolation rather than the mechanism, and a slightly odd plan."
      },
      {
        "text": "There is a conversation to join, and nobody is under a spotlight.",
        "correct": true,
        "note": "A pair gives you cover, a subject and a shared audience. Somebody alone has nothing to do but evaluate the approach."
      },
      {
        "text": "Two people are more likely to be friendly.",
        "correct": false,
        "note": "No more or less. The advantage is structural."
      },
      {
        "text": "It is less obvious what you want.",
        "correct": false,
        "note": "Partly true, and deniability is a smaller gain than the cover and the subject."
      }
    ],
    "explain": "A pair hands you a subject and removes the spotlight. Alone gives you neither."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "addressed_both",
      "label": "Addressed the group",
      "description": "Spoke to everybody standing there rather than past them."
    },
    {
      "key": "kept_including",
      "label": "Kept the friend in",
      "description": "Continued to include them rather than dropping them once it was going well."
    },
    {
      "key": "no_isolation",
      "label": "Did not isolate",
      "description": "Avoided manoeuvring the person away from who they came with."
    },
    {
      "key": "right_weight",
      "label": "Sized it to the room",
      "description": "Opened lightly enough that any of them could decline without it being a moment."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A gig, between support and main act. Two people are standing near the bar with a conversation running.",
  "partner": {
    "name": "Freya",
    "role": "one of two friends who came together",
    "personality": "Open and quick, and watches how you treat her friend. Warms up fast if the friend is included and cools immediately if not.",
    "mood": "Having a good night.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Fyfe",
      "role": "one of two friends who came together",
      "personality": "Open and quick, and watches how you treat his friend. Warms up fast if the friend is included and cools immediately if not.",
      "mood": "Having a good night.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The support act has finished and the room has gone from loud to talkable. The two of them are laughing about something.",
  "success_looks_like": "The user opens to both of them and keeps including the friend as it goes on.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Speak for yourself, and mention what your friend says or does so their presence is felt.",
    "Cool off noticeably if the user speaks past your friend or tries to isolate you.",
    "Never open the conversation yourself."
  ]
}$j$::jsonb,
  $md$Today, if you approach anybody standing with somebody else, open to both of them and keep the friend in for the whole conversation. Log who you spoke to and whether you managed it.$md$
);

-- ---------------------------------------------------------------------------
-- Modes. Two read-and-decide and two one-line drills run free, which is most
-- of the track — this is the one people need to repeat before they will do it.
-- ---------------------------------------------------------------------------

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

select pg_temp.set_mode('walking-up', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A hotel breakfast on the second morning of a three-day conference. Somebody is waiting for the toaster, as are you. Neither of you is going anywhere for about ninety seconds.",
      "prompt": "What are the three numbers?",
      "options": [
        {
          "text": "High licence, no clock, no exit cost.",
          "correct": false,
          "note": "The toaster is a clock. Missing it is what turns a ninety-second room into two minutes of deciding."
        },
        {
          "text": "Low licence, a short clock, high exit cost.",
          "correct": false,
          "note": "Conferences run on strangers introducing themselves. Licence here is about as high as it goes outside a queue."
        },
        {
          "text": "High licence, a short clock, no exit cost.",
          "correct": true,
          "note": "Everybody here is a stranger with a reason to be talking, the toaster ends it, and you will both be in a room of two hundred afterwards. About as free as an attempt gets."
        },
        {
          "text": "High licence, a short clock, high exit cost.",
          "correct": false,
          "note": "You will see them again in a hall full of people who all look the same by Thursday. That is not an exit cost."
        }
      ]
    },
    {
      "situation": "The same conference. Somebody is on the treadmill next to you in the hotel gym at seven in the morning, and you have seen them there on both previous days.",
      "prompt": "What has changed?",
      "options": [
        {
          "text": "Nothing much — it is still a conference.",
          "correct": false,
          "note": "The conference is why you are both in the hotel. It is not why you are both on a treadmill, and the treadmill is the room you are actually in."
        },
        {
          "text": "Licence is higher, because you recognise each other.",
          "correct": false,
          "note": "Recognition raises exit cost, not licence. This is the swap that gets people into trouble in repeating rooms."
        },
        {
          "text": "There is no clock now, so it is easier.",
          "correct": false,
          "note": "No clock makes it harder, not easier, and it is the smallest of the three changes here."
        },
        {
          "text": "Licence has dropped and exit cost has gone up.",
          "correct": true,
          "note": "Same building, same people, opposite room. Gyms suspend the ordinary licence to speak, and the fact you have both been here three mornings means a bad approach is still there tomorrow."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('walking-up', 2, 'line', $j${
  "says": "(the board flickers, the delay goes up again, and there is a sigh along the platform)",
  "model": {
    "line": "Second one tonight.",
    "why": "Three words about the thing you are both watching. It arrives before you have had time to talk yourself out of it, which is the entire skill in a room with a clock."
  },
  "checks": [
    {
      "kind": "contains_any",
      "requirement": "Open on the thing you are both waiting for",
      "words": [
        "delay",
        "delayed",
        "train",
        "board",
        "platform",
        "late",
        "again",
        "second",
        "wait"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Under ten words. You are both on a clock.",
      "n": 10
    },
    {
      "kind": "max_sentences",
      "requirement": "One line, and let it be brief",
      "n": 1
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('walking-up', 3, 'beat', $j${
  "turns": [
    {
      "instruction": "Open. Ordinary is fine — this room has no clock, so nothing about the first line is load-bearing."
    },
    {
      "instruction": "Now plant your exit, in passing, while it is still going well. Then carry straight on with the conversation."
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('walking-up', 4, 'choice', $j${
  "beats": [
    {
      "situation": "Week one of an eight-week class. Somebody sits near you, seems friendly, and catches your eye twice.",
      "prompt": "What do you do?",
      "options": [
        {
          "text": "Nod, and nothing else, for now.",
          "correct": true,
          "note": "You have seven weeks. Recognition costs nothing and cannot go wrong, and it is what makes a sentence in week three unremarkable."
        },
        {
          "text": "Introduce yourself — everybody is new.",
          "correct": false,
          "note": "The room is high licence in week one and the exit cost is unchanged: you are both here until March. Being the person who introduced themselves hard is a thing to be for eight weeks."
        },
        {
          "text": "Say something about the class.",
          "correct": false,
          "note": "Not wrong, and a stage early. It works better once you are two people who recognise each other than when you are two strangers."
        },
        {
          "text": "Wait to see whether they speak first.",
          "correct": false,
          "note": "Passive rather than patient. Nodding is doing something; waiting is not."
        }
      ]
    },
    {
      "situation": "Week five. You have nodded most weeks, said four words twice, and it has been easy both times.",
      "prompt": "What is the next stage?",
      "options": [
        {
          "text": "Ask them for a drink after.",
          "correct": false,
          "note": "Two stages at once. The exchange comes before the invitation, and skipping it spends licence that took five weeks to earn."
        },
        {
          "text": "A real exchange about something other than the class.",
          "correct": true,
          "note": "Five weeks of recognition and two small exchanges is exactly what buys this. It will feel like almost nothing has been built, and a lot has."
        },
        {
          "text": "More of the same — it is working.",
          "correct": false,
          "note": "It was working, and the term ends in three weeks. Repeating a stage indefinitely is the other way this goes wrong."
        },
        {
          "text": "Nothing. If they wanted more they would have said.",
          "correct": false,
          "note": "They have met every small thing warmly, twice. That is the signal, and reading it as indifference is how the patient version becomes the never version."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('walking-up', 5, 'line', $j${
  "says": "(the two of them are laughing about something, and the room has just gone quiet enough to talk)",
  "model": {
    "line": "Are you two the only people here who saw the support act as well?",
    "why": "Addressed to both, about the room all three of you are in, and it takes nothing from anybody. The friend is included before there is any question of whether they will be."
  },
  "checks": [
    {
      "kind": "contains_any",
      "requirement": "Address both of them, not one of them",
      "words": [
        "you two",
        "you both",
        "either of you",
        "you lot",
        "you pair",
        "both of you",
        "anyone"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Under twenty words — light enough to be declined",
      "n": 20
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- The printable page. Fifteen concepts across the three tracks, which brings
-- Meeting someone level with the two topics that were already finished.
-- ---------------------------------------------------------------------------

update public.topics set cheatsheet_json = $j${
  "idea": "You do not need a different opener for every room. You need to know what the room is doing to you — how normal it is to speak here, how long the situation lasts on its own, and what it costs if it goes flat. Read those three and most of the difficulty turns out to have been in the room rather than in you.",
  "groups": [
    {
      "skill": "walking-up",
      "concepts": [
        {
          "name": "Licence, time, exit cost",
          "body": "The only three things a room ever changes. Read them before you decide anything else about how to approach."
        },
        {
          "name": "A clock is a free attempt",
          "body": "In a queue the situation ends it for you, so there is no afterwards to dread. It is the easiest room there is and the one people leave having said nothing."
        },
        {
          "name": "In a room with no clock, plant an exit",
          "body": "Say you will find your friend in a bit, early and in passing. You will rarely use it — having it is what lets you relax."
        },
        {
          "name": "Repeating rooms take weeks",
          "body": "Recognised, then spoken to, then in conversation. A gym has the lowest licence and the highest exit cost anywhere, and going at queue speed there is the classic error."
        },
        {
          "name": "Address the group, not the person",
          "body": "The friend arrived with them and will leave with them. Speak past the friend and the friend will end it, reasonably."
        }
      ]
    },
    {
      "skill": "flirting-calibration",
      "concepts": [
        {
          "name": "Warmth is a dial",
          "body": "Notches, not declarations. Each one is deniable, reversible, and produces information about whether to move again."
        },
        {
          "name": "Signal, then read",
          "body": "After any step up, stop and watch what comes back. The reading is the half people skip."
        },
        {
          "name": "Attention is the signal that counts",
          "body": "Warm words are cheap. What somebody does with a chance to leave is not."
        },
        {
          "name": "Do slightly less",
          "body": "Leave a pause you would normally fill and see whether they pick it up. Doing all the work hides whether anybody else wants to."
        },
        {
          "name": "Say the plain thing, once it is earned",
          "body": "When it has been warm both ways, say it plainly and make it easy to decline. The escape route is what makes it a question."
        }
      ]
    },
    {
      "skill": "reading-disinterest",
      "concepts": [
        {
          "name": "Count signals, do not interpret one",
          "body": "Politeness is the default setting, not evidence. The strongest single signal is whether they ever ask you anything back."
        },
        {
          "name": "Drop a register",
          "body": "Step down one level and stay pleasant there. Done well it is invisible and needs no explanation."
        },
        {
          "name": "Leave first, and warmly",
          "body": "End it yourself before it becomes uncomfortable, with a reason that has nothing to do with them."
        },
        {
          "name": "No sulking",
          "body": "Keep your warmth exactly where it was, including after you have decided to go. Warmth that withdraws was never warmth."
        },
        {
          "name": "When you cannot tell, treat it as a no",
          "body": "It costs you nothing and it is the only reading that is comfortable for both of you if you are wrong."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'meeting-someone';

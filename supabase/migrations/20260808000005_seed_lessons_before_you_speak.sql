-- Track: Before you say anything. Five lessons on the stage the curriculum
-- skipped — noticing, deciding, and going — ending on the one habit that
-- undoes a good week.
--
-- Every worked example here is deliberately plain. The rest of the app writes
-- lines like "I have started thinking of the timetable as more of a mood
-- board", which are good lines and set a bar a nervous reader reads as proof
-- they could never do this. That bar is correct in Banter, where wit is the
-- subject. It is wrong in the first thing anybody reads.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'before-you-speak'),
  1,
  'What a bad opener actually costs',
  $md$Ask someone what they are afraid of and they say rejection. Ask them what rejection would actually look like, and they describe a short reply and somebody turning back to their phone.

That is the event. It takes about four seconds, and they have forgotten it before they reach the front of the queue. You will think about it for an hour. They will not think about it at all.

**The move:** say the real worst case to yourself, in plain words, before you speak.

This is not positive thinking, which does not work. It is accuracy, which does. Your body treats a social risk the way it treats a physical one, and on this particular question it is wrong by an enormous margin.

The reason the gap matters is not that it makes you uncomfortable. It is that it makes a four-second event feel like something that requires courage — and then you need to find courage, at a bus stop, before nine in the morning.$md$,
  $j$[
  {
    "situation": "You are about to say something to the person next to you at a bus stop.",
    "line": "Worst case, they say yeah and look back at their phone.",
    "why": "Said to yourself, not out loud. Naming the actual outcome puts the real number next to the felt one, and the felt one never survives the comparison."
  },
  {
    "situation": "A conversation went flat twenty minutes ago and you are still replaying it.",
    "line": "They have already forgotten this. I am the only one still holding it.",
    "why": "Almost always true. People remember their own behaviour in an exchange, not yours, because they were busy managing themselves."
  },
  {
    "situation": "Something genuinely awkward has just happened and you want to leave.",
    "line": "That was awkward and it cost four seconds.",
    "why": "Awkward is real. The point is not to pretend it was fine, it is to price it correctly rather than at the rate your body quoted."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "You open with a remark, they answer in three words and turn away. How long do they remember it?",
    "options": [
      {
        "text": "About as long as it takes them to get their coffee.",
        "correct": true,
        "note": "The honest answer. It was an unremarkable exchange in a day full of them, and it did not survive the walk back to their desk."
      },
      {
        "text": "The rest of the day, at least.",
        "correct": false,
        "note": "This is how long you will remember it, which is the mistake. You are the only person in the room for whom that was an event."
      },
      {
        "text": "They will recognise you and avoid you next time.",
        "correct": false,
        "note": "This requires them to have filed you under something. A short answer is not a filing; it is usually the same short answer they give everybody."
      },
      {
        "text": "It depends how bad the opener was.",
        "correct": false,
        "note": "It genuinely does not. The difference between a weak opener and a good one shows up in whether the conversation happens, not in what happens afterwards."
      }
    ],
    "explain": "The cost of a flat opener is paid almost entirely by you, and almost entirely in the hour afterwards rather than in the moment."
  },
  {
    "prompt": "You say something slightly odd at a party. How many people noticed?",
    "options": [
      {
        "text": "Most of the people nearby.",
        "correct": false,
        "note": "This is the belief the whole lesson is about. People consistently overestimate how much of their behaviour was observed, by a very wide margin."
      },
      {
        "text": "The person you said it to, and nobody else.",
        "correct": true,
        "note": "Everyone else was mid-conversation, managing their own evening. Being watched is the feeling; not being watched is the fact."
      },
      {
        "text": "Nobody. People do not really listen.",
        "correct": false,
        "note": "Overcorrecting. The person you were talking to heard you perfectly well, and it still did not matter."
      },
      {
        "text": "Impossible to know, which is what makes it uncomfortable.",
        "correct": false,
        "note": "It is not unknowable. Ask anyone what somebody else said awkwardly at a party last month and watch them fail to produce an example."
      }
    ],
    "explain": "You are the only person at the party for whom you are the main character. Everyone else is starring in their own evening."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "priced_it",
      "label": "Priced the risk honestly",
      "description": "Named what would actually happen rather than what it felt like."
    },
    {
      "key": "went_anyway",
      "label": "Opened after naming it",
      "description": "Used the read as a reason to go rather than as another thing to consider."
    },
    {
      "key": "no_catastrophe",
      "label": "Did not inflate it",
      "description": "Avoided treating an ordinary flat reply as evidence of anything."
    },
    {
      "key": "let_it_go",
      "label": "Stopped carrying it",
      "description": "Did not spend the following hour rehearsing a four-second exchange."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A supermarket self-checkout area at six in the evening. One machine is broken and three people are waiting for the two that work.",
  "partner": {
    "name": "Erin",
    "role": "someone waiting in front of you",
    "personality": "Ordinary and slightly tired. Not warm, not cold, exactly as engaged as a stranger in a queue.",
    "mood": "Wants to get home.",
    "openness": 3
  },
  "opening_beat": "Erin shifts her basket to the other arm and looks at the broken machine, then at the queue.",
  "success_looks_like": "The user says something and finds out that the outcome, either way, is small.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Reply the way a tired stranger in a queue would: briefly, pleasantly, without hostility.",
    "Never punish the user for a weak opener. A flat reply is the worst thing that happens here.",
    "Do not become the user's friend within three lines. This scene is about the cost being small, not about it going brilliantly."
  ]
}$j$::jsonb,
  $md$Before one conversation today, say the actual worst case to yourself in plain words. Then have the conversation and log what really happened, next to what you predicted.$md$
),
(
  (select id from public.skills where slug = 'before-you-speak'),
  2,
  'You do not have to be interesting',
  $md$The belief that stops most conversations before they start is that you need something worth saying.

You do not. The bar is not interesting. The bar is true and easy to reply to. Almost every conversation you have ever enjoyed began with a remark so ordinary that neither of you could repeat it now.

**The move:** say the ordinary true thing rather than waiting for the good one.

Waiting has a cost that nobody counts. While you are composing, the moment closes — the queue moves, the headphones go back in, somebody else speaks. The ordinary line said now beats the good line said never, and it comfortably beats the good line said thirty seconds late, which arrives with a strange amount of weight on it.

There is a second reason and it is the better one. A clever opener asks to be admired. An ordinary one asks to be answered. Only one of those is an invitation.$md$,
  $j$[
  {
    "situation": "A meeting is late starting and you are sitting next to somebody you do not know.",
    "line": "They are running late.",
    "why": "Four words, completely obvious, and almost impossible not to answer. Nobody has ever thought less of a person for saying the obvious thing out loud."
  },
  {
    "situation": "You are both waiting for the same lift.",
    "line": "This one is slow.",
    "why": "There is nothing in it to admire and nothing to disagree with, which is exactly why it works. It asks for a reply rather than a verdict."
  },
  {
    "situation": "You have thought of something much better, and the moment has been open for fifteen seconds.",
    "line": "(say the plain one, now)",
    "why": "The better line is worth less than the seconds you are spending on it. This is the trade almost everyone gets backwards."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "You are standing next to somebody at a bar waiting to be served. Which line does more for you?",
    "options": [
      {
        "text": "I have started to suspect this bar is a social experiment about patience.",
        "correct": false,
        "note": "A good line, and it arrives asking to be appreciated. Now they have to produce something equally good or feel they have let the exchange down."
      },
      {
        "text": "Nothing, until you think of something better.",
        "correct": false,
        "note": "The most common choice and the only one guaranteed to produce nothing. The moment closes while you are working."
      },
      {
        "text": "Busy tonight.",
        "correct": true,
        "note": "Ordinary, true, and immediately answerable. It asks nothing of them except agreement, and agreement is a turn."
      },
      {
        "text": "Do you come here a lot?",
        "correct": false,
        "note": "Serviceable, and it is a request for information from a stranger rather than a remark you are both inside."
      }
    ],
    "explain": "True and easy to answer beats clever every time. A clever line asks to be admired; an ordinary one asks to be answered."
  },
  {
    "prompt": "Why does waiting for a better line usually make things worse?",
    "options": [
      {
        "text": "Better lines are usually not actually better.",
        "correct": false,
        "note": "Sometimes true and not the point. Even a genuinely better line loses to the ordinary one that was said in time."
      },
      {
        "text": "It makes you look indecisive.",
        "correct": false,
        "note": "Nobody is watching you decide. The cost is the lost opening, not the impression."
      },
      {
        "text": "You will forget the line by the time you say it.",
        "correct": false,
        "note": "A minor practical problem next to the real one, which is that the opening has gone."
      },
      {
        "text": "The moment closes, and a late line carries more weight than an early one.",
        "correct": true,
        "note": "Both halves are true. Openings expire, and a remark delivered after a visible pause has to justify the pause as well as itself."
      }
    ],
    "explain": "The trade is not clever against ordinary. It is ordinary now against clever probably never."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "said_the_plain_one",
      "label": "Said the ordinary thing",
      "description": "Chose a true, unremarkable remark over a line that needed working on."
    },
    {
      "key": "went_early",
      "label": "Went early",
      "description": "Spoke while the opening was still there rather than after composing."
    },
    {
      "key": "answerable",
      "label": "Easy to answer",
      "description": "Left something the other person could agree with in four words."
    },
    {
      "key": "no_performance",
      "label": "Did not perform",
      "description": "Avoided a line that asked to be admired rather than replied to."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "The lift in an office building, going up six floors, mid-morning. One other person got in with you.",
  "partner": {
    "name": "Ruth",
    "role": "somebody who works on a different floor",
    "personality": "Pleasant and unhurried. Will meet an ordinary remark with an ordinary reply, which is all this needs.",
    "mood": "Fine. Holding a coffee and a laptop.",
    "openness": 3
  },
  "opening_beat": "The doors close. Ruth looks at the floor indicator, then briefly at you.",
  "success_looks_like": "The user says something plain within the first few seconds and it is met normally.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Meet an ordinary remark warmly and ordinarily. Do not require wit to engage.",
    "The lift ride is short. Keep replies to a sentence.",
    "If the user says nothing, say nothing. The silence is part of what the lesson is about."
  ]
}$j$::jsonb,
  $md$Today, open one conversation with the most ordinary true thing you can think of. Deliberately do not improve it. Log what you said and what came back.$md$
),
(
  (select id from public.skills where slug = 'before-you-speak'),
  3,
  'Decide the line before you need it',
  $md$Nobody composes well under pressure, and the moment you are trying to open in is the worst available time to be inventing.

The people who look natural at this are not improvising. They have three or four lines they have used a hundred times, and they are not thinking about the words at all — which is precisely why they can pay attention to the person instead.

**The move:** decide your opener before you are in the room, not while you are standing in it.

Two or three is enough, and they should be portable: about the situation rather than about the person, so they work anywhere. *Long queue. They are running late again. First time here.* You are not memorising a script. You are removing the one task that competes with listening.

This is the least romantic advice in the app and the most reliably effective. Preparation is what courage looks like from the outside.$md$,
  $j$[
  {
    "situation": "You are going to an event on Thursday where you will know almost nobody.",
    "line": "First time at one of these.",
    "why": "Works in any room, invites the same admission back, and can be said without thinking about it. Decided on Tuesday, it costs nothing on Thursday."
  },
  {
    "situation": "You start a class or a course next week.",
    "line": "Have you done this before, or are we both new.",
    "why": "Portable across every course anybody has ever attended. Prepared lines are not less genuine for having been prepared; they are just available."
  },
  {
    "situation": "You have a line ready and something better occurs to you as you open your mouth.",
    "line": "(use the prepared one)",
    "why": "The prepared line is already out. Swapping it at the last second puts you back in the composing state the preparation existed to prevent."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Which of these is the most useful line to have prepared?",
    "options": [
      {
        "text": "They are running late again.",
        "correct": true,
        "note": "Portable. It works at a meeting, a class, a gig and a doctor's waiting room, which means you can carry it everywhere and never have to select."
      },
      {
        "text": "That is a really interesting jacket.",
        "correct": false,
        "note": "It depends on the jacket, so it cannot be prepared. Anything about the person has to be invented in the moment, which is the thing you are avoiding."
      },
      {
        "text": "So what brings you here tonight?",
        "correct": false,
        "note": "Portable and it is an interview question from cold. Prepared does not have to mean generic-sounding."
      },
      {
        "text": "I have been looking forward to this all week.",
        "correct": false,
        "note": "Only true sometimes, and a prepared line you have to check for truthfulness is not doing its job."
      }
    ],
    "explain": "A prepared line has to be portable and true almost anywhere, or you are back to selecting under pressure."
  },
  {
    "prompt": "What is the actual benefit of having your opener decided in advance?",
    "options": [
      {
        "text": "Your opener will be better than an improvised one.",
        "correct": false,
        "note": "It usually will not be, and that is fine. The gain is in what you can do afterwards, not in the line itself."
      },
      {
        "text": "You have attention spare for the person in front of you.",
        "correct": true,
        "note": "The real prize. Composing and listening use the same capacity, and whichever you spend it on the other one suffers."
      },
      {
        "text": "You are less likely to say something embarrassing.",
        "correct": false,
        "note": "A minor benefit. Almost nobody says anything embarrassing; they just say nothing."
      },
      {
        "text": "It makes you sound more confident.",
        "correct": false,
        "note": "How it sounds is a side effect. The mechanism is that you are not doing two jobs at once."
      }
    ],
    "explain": "Composing and listening compete for the same attention. Preparing the line is how you free it up for the person."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "was_ready",
      "label": "Had a line ready",
      "description": "Opened with something decided in advance rather than assembled on the spot."
    },
    {
      "key": "portable",
      "label": "Portable",
      "description": "Chose a line that would work in most rooms rather than one tied to this one."
    },
    {
      "key": "used_it",
      "label": "Actually used it",
      "description": "Did not swap the prepared line for something invented at the last second."
    },
    {
      "key": "attention_free",
      "label": "Listened afterwards",
      "description": "Spent the freed attention on their reply rather than on the next line."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "An evening ceramics class you have never been to. People are finding places at a long shared bench and it starts in five minutes.",
  "partner": {
    "name": "Malik",
    "role": "somebody setting up two places along",
    "personality": "Friendly and a bit shy himself. Will happily meet an ordinary opener and is not going to start one.",
    "mood": "Quietly pleased to be there and unsure where anything is kept.",
    "openness": 4
  },
  "opening_beat": "Malik sits down, looks for somewhere to put his bag, and settles for the floor.",
  "success_looks_like": "The user opens with a line that would have worked in any room, rather than one that needed inventing here.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Respond warmly to any ordinary opener. He is glad somebody spoke.",
    "Do not lead. He would not have opened first, which is why he is a useful partner here.",
    "Keep replies to a sentence or two, at the length somebody makes conversation before a class."
  ]
}$j$::jsonb,
  $md$Pick two lines tonight that would work in almost any room. Use one of them tomorrow without changing it. Log which line, where, and whether you were tempted to improve it.$md$
),
(
  (select id from public.skills where slug = 'before-you-speak'),
  4,
  'Twenty seconds, then it is gone',
  $md$Availability has a shelf life. You notice somebody is free, you spend thirty seconds deciding, and by the time you have decided they are on their phone, at the front of the queue, or talking to somebody else.

The waiting does not help, and this is the part people get wrong. The fear does not fall while you stand there. It rises. Standing near somebody rehearsing an opener is the most uncomfortable thing in this whole subject, and it is what most people spend most of their time doing.

**The move:** once you have noticed an opening, go within twenty seconds.

Twenty is not magic. It is short enough that you cannot talk yourself out of it and long enough to say a line you already had. That is why the previous lesson comes first — with a line decided, twenty seconds is generous. Without one, twenty seconds is a panic.

What you are training is not bravery. It is the gap between noticing and acting, which is the only part of this you actually control.$md$,
  $j$[
  {
    "situation": "Somebody at the next table puts their phone face down and looks up.",
    "line": "(go now, with the line you already have)",
    "why": "Phone down and eyes up is the clearest opening there is, and it is also the shortest-lived. Thirty seconds later they have found something else to do."
  },
  {
    "situation": "You have been deciding for a minute and the feeling is getting worse, not better.",
    "line": "(this is the signal, not a reason to wait longer)",
    "why": "Rising discomfort while you wait is the normal shape of it. People read it as a warning and it is simply the cost of standing still."
  },
  {
    "situation": "You counted twenty and the moment has genuinely closed.",
    "line": "(let it go and take the next one)",
    "why": "A closed opening is not a failure, it is information about how long you took. The next one is usually four minutes away."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "You notice an opening and hesitate. What happens to the fear while you wait?",
    "options": [
      {
        "text": "It settles once you have thought it through.",
        "correct": false,
        "note": "This is the belief that produces the walk-past. Thinking it through has no natural end, so the settling never arrives."
      },
      {
        "text": "It stays about the same.",
        "correct": false,
        "note": "It does not. Anticipation is where almost all of the discomfort in this lives, which is why going early costs less than going late."
      },
      {
        "text": "It rises, and the opening closes at the same time.",
        "correct": true,
        "note": "Both, which is why waiting is the worst available option. You are paying more and buying less the longer you stand there."
      },
      {
        "text": "It depends how good your opener is.",
        "correct": false,
        "note": "The opener is barely involved. The discomfort is about the waiting, not about the words."
      }
    ],
    "explain": "Waiting costs more and buys less. Anticipation is the expensive part, and it is the only part you can shorten."
  },
  {
    "prompt": "Why does having a prepared line make the twenty seconds work?",
    "options": [
      {
        "text": "A prepared line is faster to say.",
        "correct": false,
        "note": "The speaking takes the same three seconds either way. The saving is entirely in what happens before it."
      },
      {
        "text": "It makes you less likely to hesitate at all.",
        "correct": false,
        "note": "You will hesitate anyway. The rule is what makes the hesitation short rather than what removes it."
      },
      {
        "text": "It stops you picking the wrong opener.",
        "correct": false,
        "note": "There is barely such a thing as the wrong opener here. There is only the one you said and the one you did not."
      },
      {
        "text": "The twenty seconds is for going, not for writing.",
        "correct": true,
        "note": "With the line decided, twenty seconds is plenty of time to move and speak. Without one it is twenty seconds of composing under a countdown, which is worse than no rule at all."
      }
    ],
    "explain": "The rule and the prepared line are one tool in two parts. Either alone is much weaker than both."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "noticed",
      "label": "Noticed the opening",
      "description": "Registered availability rather than waiting to be spoken to."
    },
    {
      "key": "went_fast",
      "label": "Went quickly",
      "description": "Moved within about twenty seconds instead of deliberating."
    },
    {
      "key": "used_the_line",
      "label": "Had something to say",
      "description": "Arrived with a line rather than composing on the way over."
    },
    {
      "key": "no_rehearsal",
      "label": "Did not rehearse",
      "description": "Avoided standing nearby working on it, which is where the discomfort lives."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "The garden of a pub on a warm evening. Somebody is standing at the end of a bench with a drink, on their own, having just put their phone away.",
  "partner": {
    "name": "Jonty",
    "role": "somebody waiting for friends who are late",
    "personality": "Easy company and slightly bored. Perfectly happy to be spoken to and not going to initiate.",
    "mood": "Killing time.",
    "openness": 4
  },
  "opening_beat": "Jonty pockets his phone, looks around the garden, and takes a sip.",
  "success_looks_like": "The user opens promptly rather than circling, and finds a partner who was always going to be receptive.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Be receptive from the first line. This scene is not about a difficult partner.",
    "Do not open the conversation yourself under any circumstances.",
    "Keep replies short and easy, at the length of somebody chatting while they wait."
  ]
}$j$::jsonb,
  $md$Today, when you notice somebody is available, count to twenty and go before you get there. Log how long you actually took, honestly.$md$
),
(
  (select id from public.skills where slug = 'before-you-speak'),
  5,
  'The one you walked past',
  $md$Everybody working on this has the same recurring event. A clear opening, noticed, not taken, walked past — and then a small private telling-off for the rest of the afternoon.

The telling-off is not the problem. The problem is what the walk-past teaches. Every time you decide not to, you hand yourself evidence that the situation was genuinely dangerous and that avoiding it was the right call. Avoidance is the thing that compounds. A flat conversation teaches you almost nothing; a walk-past teaches you something false, and it teaches it very well.

**The move:** when you walk past one, take the very next opening you get, however small.

Not the same person, and not a better version of the same moment. Anybody — the person at the till, somebody in the lift, whoever you end up sitting next to. The conversation is not the point. The point is that the last thing you did was go rather than not go, because that is the data you keep.

You will walk past plenty. That is fine, and it is not the thing to fix. The thing to fix is letting a walk-past be the last one of the day.$md$,
  $j$[
  {
    "situation": "You saw an obvious opening at lunch and did not take it.",
    "line": "(say something to the next person who serves you)",
    "why": "Small, low stakes, and entirely sufficient. The repair is not about difficulty, it is about not letting the avoidance stand as the day's last entry."
  },
  {
    "situation": "You have walked past three in a row and feel like the day is a write-off.",
    "line": "(take the fourth — the count does not matter)",
    "why": "Three walk-pasts and one attempt is a good day. Three walk-pasts and nothing is the day that makes tomorrow harder."
  },
  {
    "situation": "You walked past one and you are now composing an explanation for why it was sensible.",
    "line": "(it might have been. Take the next one anyway.)",
    "why": "Sometimes the read was right and the moment genuinely was wrong. It changes nothing about what to do next, which is why it is not worth adjudicating."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why is walking past an opening worse for you than an opener that falls flat?",
    "options": [
      {
        "text": "It teaches you the situation was dangerous, and a flat opener teaches you it was not.",
        "correct": true,
        "note": "This is the whole lesson. Avoidance is the only thing here that reliably makes the next attempt harder, and it does so quietly."
      },
      {
        "text": "It is a wasted opportunity to meet somebody.",
        "correct": false,
        "note": "True and much less important. Openings are common; what you learned from skipping this one is what carries into next week."
      },
      {
        "text": "It makes you feel bad about yourself.",
        "correct": false,
        "note": "It does, and feeling bad is not the mechanism. The damage is the lesson your body took from it, not the mood."
      },
      {
        "text": "Other people notice you hesitating.",
        "correct": false,
        "note": "They do not, and it would not matter if they did. This one is entirely between you and the next opening."
      }
    ],
    "explain": "A flat opener is a small correction. A walk-past is a lesson, and it is the wrong lesson learned well."
  },
  {
    "prompt": "You walked past an opening an hour ago. What is the most useful repair?",
    "options": [
      {
        "text": "Go back and take the original opening.",
        "correct": false,
        "note": "Usually gone, and returning to it an hour later is a much harder thing than the one you avoided. This is how a small repair becomes impossible."
      },
      {
        "text": "Say something to the next person you get the chance to, however trivial.",
        "correct": true,
        "note": "Anybody, anything. The repair is about what you did last, not about matching the difficulty of what you skipped."
      },
      {
        "text": "Work out why you did not do it.",
        "correct": false,
        "note": "You already know why. Analysis here is a comfortable way of spending the afternoon not doing the thing."
      },
      {
        "text": "Nothing. Note it and start fresh tomorrow.",
        "correct": false,
        "note": "Tomorrow starts from where today ended. Ending on the walk-past is exactly what makes tomorrow heavier."
      }
    ],
    "explain": "Take the next one, not the one you missed. What matters is what the day ended on."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "noticed_the_pass",
      "label": "Noticed the walk-past",
      "description": "Registered the avoided opening rather than letting it pass unexamined."
    },
    {
      "key": "took_the_next",
      "label": "Took the next one",
      "description": "Opened with somebody, anybody, rather than waiting for an equivalent moment."
    },
    {
      "key": "kept_it_small",
      "label": "Kept the repair small",
      "description": "Chose a low-stakes opening instead of trying to match what was skipped."
    },
    {
      "key": "no_self_audit",
      "label": "Skipped the post-mortem",
      "description": "Did not spend the repair time working out why the first one did not happen."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A cafe counter, ten minutes after you walked past an obvious opening at the table by the window.",
  "partner": {
    "name": "Robin",
    "role": "the person serving you",
    "personality": "Busy and perfectly pleasant. Has thirty seconds and will use them.",
    "mood": "Mid-shift and fine.",
    "openness": 3
  },
  "opening_beat": "Robin puts your coffee on the counter and turns to wipe down the steam wand.",
  "success_looks_like": "The user says something small to somebody easy, and the day stops ending on the avoidance.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Keep it brief. This is a thirty-second exchange over a counter, not a conversation.",
    "Be warm and slightly rushed. The point is that this costs the user almost nothing.",
    "Do not draw the exchange out past a few lines."
  ]
}$j$::jsonb,
  $md$Today, when you walk past an opening — and you will — take the next one within ten minutes, on anybody. Log both: the one you skipped and the one you took.$md$
);

-- ---------------------------------------------------------------------------
-- Modes. The whole on-ramp is free to run and endlessly repeatable, which is
-- the correct shape for the first thing a nervous person meets: three
-- read-and-decide drills where the answer is a judgement, and two one-line
-- drills checked against rules stated before you type.
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

select pg_temp.set_mode('before-you-speak', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You say something to the person beside you in a queue. They say yeah, smile briefly, and go back to their phone.",
      "prompt": "What just happened?",
      "options": [
        {
          "text": "They did not want to be spoken to.",
          "correct": false,
          "note": "Possible and unknowable from one reply, and either way the answer is the same. Reading a short answer as a rejection is how one four-second event becomes a rule."
        },
        {
          "text": "The opener was too weak to earn a proper answer.",
          "correct": false,
          "note": "Openers are rarely the variable. Plenty of excellent openers get exactly this reply from somebody who is nearly at the till."
        },
        {
          "text": "Nothing. That is what an ordinary flat reply looks like.",
          "correct": true,
          "note": "It is the most common outcome of an opener and it is not a verdict on you. They were in a queue, not auditioning conversations."
        },
        {
          "text": "You should have followed it with something else.",
          "correct": false,
          "note": "Filling the gap after a flat reply is the one thing that would actually have made it uncomfortable."
        }
      ]
    },
    {
      "situation": "It is nine in the evening and you are still thinking about it.",
      "prompt": "Where is the other person right now?",
      "options": [
        {
          "text": "Probably thinking it was a bit odd.",
          "correct": false,
          "note": "People remember their own behaviour in an exchange, not yours. If they recall anything, it is what they said."
        },
        {
          "text": "Telling somebody about it.",
          "correct": false,
          "note": "Nothing happened. There is no story in a stranger saying something ordinary in a queue."
        },
        {
          "text": "Impossible to know.",
          "correct": false,
          "note": "Technically true and practically useless. Ask anybody to describe a stranger who spoke to them awkwardly last month and watch them fail."
        },
        {
          "text": "Not thinking about it, and has not since the queue.",
          "correct": true,
          "note": "This is almost certainly true and it is the only fact that matters. The exchange existed for four seconds for them and has lasted five hours for you."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-speak', 2, 'line', $j${
  "model": {
    "line": "This lift is in no hurry today.",
    "why": "Six ordinary words about the thing you are both inside. There is nothing in it to admire, which is exactly why it is easy to answer."
  },
  "checks": [
    {
      "kind": "contains_any",
      "requirement": "Point at the thing you are both in",
      "words": [
        "lift",
        "slow",
        "floor",
        "button",
        "stairs",
        "up",
        "doors"
      ]
    },
    {
      "kind": "no_question",
      "requirement": "Say it, do not ask it"
    },
    {
      "kind": "max_words",
      "requirement": "Ten words at most — ordinary is the point",
      "n": 10
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-speak', 3, 'line', $j${
  "model": {
    "line": "They are running late again.",
    "why": "Five words that would work at a class, a meeting, a gig or a waiting room. Portable is what makes a line worth preparing."
  },
  "checks": [
    {
      "kind": "forbids_any",
      "requirement": "It has to work in any room, not only this one",
      "words": [
        "clay",
        "kiln",
        "glaze",
        "pottery",
        "ceramic",
        "apron",
        "bench"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Short enough to say without thinking about it",
      "n": 9
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-speak', 4, 'choice', $j${
  "beats": [
    {
      "situation": "Somebody at the next table puts their phone face down and looks up. You have a line ready. That was about forty seconds ago and you are still sitting there.",
      "prompt": "What do you do?",
      "options": [
        {
          "text": "Go now, with the line you already had.",
          "correct": true,
          "note": "Late is not gone. Forty seconds in, the opening is narrower and still open, and every further second is spent making it worse rather than safer."
        },
        {
          "text": "Wait for a cleaner moment.",
          "correct": false,
          "note": "There is no cleaner moment coming, and the waiting is the expensive part. This is the decision that becomes a walk-past."
        },
        {
          "text": "Think of something better first, since you have taken this long anyway.",
          "correct": false,
          "note": "Now you are composing under a countdown, which is worse than either doing on its own."
        },
        {
          "text": "Let it go. You have missed it.",
          "correct": false,
          "note": "Forty seconds is late, not missed. Treating it as missed is a decision, and it is the one that teaches you to be slower next time."
        }
      ]
    },
    {
      "situation": "You noticed an opening, hesitated, and the person has now started a conversation with somebody else.",
      "prompt": "What is the useful read?",
      "options": [
        {
          "text": "They were never going to be interested anyway.",
          "correct": false,
          "note": "Comfortable and untrue. They were available, and they were available to whoever spoke first."
        },
        {
          "text": "You were slow, and the fix is the gap rather than the nerve.",
          "correct": true,
          "note": "The correct and least punishing read. The variable you control is how long you take between noticing and moving, and that is genuinely trainable."
        },
        {
          "text": "You are not brave enough for this yet.",
          "correct": false,
          "note": "Bravery is not the variable. Somebody with the same nerves and a shorter gap would have had that conversation."
        },
        {
          "text": "You need a better opener for next time.",
          "correct": false,
          "note": "The opener was never tested. Improving it fixes nothing about the thing that actually happened."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-speak', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You saw an obvious opening at lunch, decided against it, and have been quietly annoyed with yourself since.",
      "prompt": "What is worth doing about it?",
      "options": [
        {
          "text": "Work out what stopped you.",
          "correct": false,
          "note": "You already know what stopped you. Analysis is a comfortable way to spend an afternoon not doing the thing."
        },
        {
          "text": "Set yourself a harder target tomorrow to make up for it.",
          "correct": false,
          "note": "Raising the price after a miss makes the next attempt less likely, not more. The repair should be easier than what you avoided."
        },
        {
          "text": "Say something to the next person you get a chance to, however small.",
          "correct": true,
          "note": "The repair is about what you do next, not about matching what you skipped. A word to somebody at a till counts fully."
        },
        {
          "text": "Nothing. One skipped opening is not important.",
          "correct": false,
          "note": "One is not, and the lesson it teaches is. Ending the day on the avoidance is what makes tomorrow heavier."
        }
      ]
    },
    {
      "situation": "It is the end of the day. You walked past three openings and took one, on the man who sold you a train ticket.",
      "prompt": "How did that day go?",
      "options": [
        {
          "text": "Badly. You avoided three and managed one trivial exchange.",
          "correct": false,
          "note": "This is the arithmetic that makes people stop. Nobody has ever improved at this by scoring their day out of four."
        },
        {
          "text": "Neutral. A ticket office does not really count.",
          "correct": false,
          "note": "It counts completely. The nervous system does not grade the venue, it records whether you went."
        },
        {
          "text": "Impossible to say without knowing how the conversation went.",
          "correct": false,
          "note": "How it went is the least important part. Going is the part being trained."
        },
        {
          "text": "Well. The last thing you did was go.",
          "correct": true,
          "note": "Three passes and one attempt is a good day. The count is not the measure; what the day ended on is."
        }
      ]
    }
  ]
}$j$::jsonb);

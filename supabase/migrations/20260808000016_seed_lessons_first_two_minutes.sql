-- Meeting someone, track 2: The first two minutes.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'first-two-minutes'),
  1,
  'Do not apologise for being there',
  $md$The apology is almost never in the words. It is in the half-step back, the rushed delivery, and the sentence that arrives already explaining itself.

*Sorry to bother you. I will let you get on. This is probably weird.* Each of those tells them the approach was an imposition, and people are agreeable — if you frame it as one, they will accept the frame. Nothing else you say afterwards undoes it, because you told them how to read the whole thing in the first four words.

**The move:** stand still, speak at your normal pace, and let the opener arrive without a preface.

Speed is the tell nobody notices they are producing. A rushed line says you expect to be interrupted, and the fix is not confidence, it is tempo — you can decide to say something at your normal speed regardless of how you feel about saying it.

The other half is staying put. Delivering a line while already angled away is an apology in body language, and it reads as clearly as saying so.

None of this is about seeming bold. It is about not adding a layer of discomfort that was not in the situation.$md$,
  $j$[
  {
    "situation": "You have decided to say something to somebody at a bar.",
    "line": "It is busy in here tonight.",
    "why": "No preface. The remark arrives on its own and is allowed to be an ordinary thing one person says to another, which is what it is."
  },
  {
    "situation": "You catch yourself about to open with sorry.",
    "line": "(cut the first sentence and start at the second)",
    "why": "The apology is nearly always the first clause. Removing it usually leaves a perfectly good opener that was hiding behind it."
  },
  {
    "situation": "You said your line and immediately took half a step back.",
    "line": "(stay where you are)",
    "why": "Retreating after speaking asks them to decide whether to call you back. Standing still lets the remark be what it was."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why does opening with sorry to bother you cost so much?",
    "options": [
      {
        "text": "It tells them how to read the approach, and they will agree.",
        "correct": true,
        "note": "You have supplied the frame before they formed one. People are agreeable, and an imposition is what you called it."
      },
      {
        "text": "It sounds unconfident.",
        "correct": false,
        "note": "It does, and the impression matters less than the frame. A perfectly confident person saying it would get the same result."
      },
      {
        "text": "It wastes time.",
        "correct": false,
        "note": "Four words. The cost is what the words do rather than what they take."
      },
      {
        "text": "It is a cliché.",
        "correct": false,
        "note": "It is, and a fresh apology fails the same way."
      }
    ],
    "explain": "You cannot recover from telling somebody the conversation is an imposition. Do not offer them the frame."
  },
  {
    "prompt": "Which apology is hardest to notice yourself making?",
    "options": [
      {
        "text": "Saying sorry.",
        "correct": false,
        "note": "The most obvious one, and therefore the easiest to catch and remove."
      },
      {
        "text": "Speaking faster than you normally would.",
        "correct": true,
        "note": "It is invisible from the inside and completely audible from outside. A rushed line says you expect to be cut off, which invites being cut off."
      },
      {
        "text": "Standing too far away.",
        "correct": false,
        "note": "Visible to you once you are looking for it, and easier to correct than tempo."
      },
      {
        "text": "Explaining why you are talking to them.",
        "correct": false,
        "note": "Also common, also audible to you as you do it. Speed is the one that runs underneath everything else."
      }
    ],
    "explain": "Tempo is the apology you cannot hear yourself making. You can decide it in advance."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "no_preface",
      "label": "No preface",
      "description": "Opened without an apology, an explanation or a warning."
    },
    {
      "key": "tempo",
      "label": "Normal pace",
      "description": "Said it at the speed they would say anything else."
    },
    {
      "key": "stayed_put",
      "label": "Stayed where they were",
      "description": "Did not retreat physically after speaking."
    },
    {
      "key": "let_it_stand",
      "label": "Let it stand",
      "description": "Allowed a pause rather than filling it with justification."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A busy bar on a Friday. You have ended up beside somebody at the counter, both waiting to be served.",
  "partner": {
    "name": "Talise",
    "role": "somebody waiting at the same bar",
    "personality": "Friendly and quick to mirror. Treats an apologetic approach as an interruption and an ordinary one as ordinary.",
    "mood": "Out with friends, currently alone at the bar.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Tavish",
      "role": "somebody waiting at the same bar",
      "personality": "Friendly and quick to mirror. Treats an apologetic approach as an interruption and an ordinary one as ordinary.",
      "mood": "Out with friends, currently alone at the bar.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The bartender takes somebody else's order first. You are both left waiting.",
  "success_looks_like": "The user opens without a preface and does not explain themselves afterwards.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "If the user apologises or explains why they are talking to you, answer politely and briefly and turn slightly back to the bar.",
    "If they open plainly, respond warmly and normally.",
    "Never open the conversation yourself."
  ]
}$j$::jsonb,
  $md$Today, open one conversation with no preface at all. No sorry, no explanation, no warning. Log what you cut and whether you noticed yourself speeding up.$md$
),
(
  (select id from public.skills where slug = 'first-two-minutes'),
  2,
  'Names, early',
  $md$Swapping names is the cheapest structural change available in the first two minutes, and most people leave it until it is awkward.

Before names, you are a stranger talking to somebody. After them, two people are having a conversation. Nothing else has changed and the category has. It also gives them something to do with the exchange afterwards — a conversation with a name attached is one they can refer to, and one they can pick up if you meet again.

**The move:** give your name around the two-minute mark, then ask theirs.

Giving first is what makes it easy. *I am Sam, by the way* is a small offer that costs them nothing to accept, where *what is your name* on its own is a request from somebody who has not yet given anything.

Leave it much longer and it becomes a moment. At ten minutes, introducing yourself is a small event that interrupts whatever you were talking about; at two, it is punctuation. That is the entire reason for the timing.

If you get it and lose it — which happens — ask again immediately. Asking at minute three is nothing. Asking at minute twenty is a confession.$md$,
  $j$[
  {
    "situation": "Two minutes into a conversation that is going fine.",
    "line": "I am Ravi, by the way.",
    "why": "Given rather than requested, dropped in rather than announced. Almost nobody fails to give theirs back."
  },
  {
    "situation": "You have been talking for ten minutes and never exchanged names.",
    "line": "We have done this entirely anonymously. I am Ravi.",
    "why": "Naming the lateness lightly is better than pretending it is not late. It makes the fix funny rather than awkward."
  },
  {
    "situation": "They said their name and it has already gone.",
    "line": "Sorry — say that again?",
    "why": "Immediately, and it costs nothing. The alternative is twenty minutes of constructing sentences that avoid needing it."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why give your name rather than ask for theirs?",
    "options": [
      {
        "text": "It is more polite.",
        "correct": false,
        "note": "Both are polite. The difference is what it asks of them."
      },
      {
        "text": "It stops you forgetting theirs.",
        "correct": false,
        "note": "If anything it makes forgetting more likely, since you are thinking about your own line."
      },
      {
        "text": "An offer is easier to accept than a request is to answer.",
        "correct": true,
        "note": "Giving first makes returning it automatic and optional at the same time. Asking cold is a small demand from somebody who has offered nothing."
      },
      {
        "text": "It sounds more confident.",
        "correct": false,
        "note": "A side effect. The mechanism is that they do not have to do anything with it."
      }
    ],
    "explain": "Give first. It converts a request into an offer, and offers are easy."
  },
  {
    "prompt": "Why does it get harder the longer you leave it?",
    "options": [
      {
        "text": "They will have decided you are not interested.",
        "correct": false,
        "note": "Almost nobody is tracking it consciously. The cost is the awkwardness of the fix rather than a signal you sent."
      },
      {
        "text": "You will have forgotten to.",
        "correct": false,
        "note": "True and it is the cause rather than the cost."
      },
      {
        "text": "It looks like you were avoiding it.",
        "correct": false,
        "note": "Rarely how it reads. It reads as two people who simply did not get round to it, which is why naming it lightly works."
      },
      {
        "text": "At two minutes it is punctuation; at twenty it is an event.",
        "correct": true,
        "note": "Late introductions interrupt whatever you were talking about and draw attention to the fact that you got this far without one."
      }
    ],
    "explain": "Two minutes is punctuation. Twenty minutes is a moment you now have to manage."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "gave_first",
      "label": "Gave their name first",
      "description": "Offered rather than asked."
    },
    {
      "key": "timing",
      "label": "Did it early",
      "description": "Around two minutes, before it would become an event."
    },
    {
      "key": "lightly",
      "label": "Dropped it in",
      "description": "Made it punctuation rather than an announcement."
    },
    {
      "key": "recovered",
      "label": "Asked again if lost",
      "description": "Where the name went, asked immediately rather than working around it."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A gallery opening. You have been talking to somebody about the room for a couple of minutes and it is going well.",
  "partner": {
    "name": "Odette",
    "role": "somebody you have been talking to for two minutes",
    "personality": "Warm and easy. Will give a name back immediately if offered one and will not offer first.",
    "mood": "Enjoying the evening.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Otto",
      "role": "somebody you have been talking to for two minutes",
      "personality": "Warm and easy. Will give a name back immediately if offered one and will not offer first.",
      "mood": "Enjoying the evening.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "There is a natural gap after they finish a thought about the room.",
  "success_looks_like": "The user gives their name in passing and gets one back.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Give your name back immediately and warmly if theirs is offered.",
    "Never introduce yourself first.",
    "Keep replies short."
  ]
}$j$::jsonb,
  $md$In one conversation today, give your name around the two-minute mark without being asked. Log whether you got one back and what happened to the conversation afterwards.$md$
),
(
  (select id from public.skills where slug = 'first-two-minutes'),
  3,
  'Two minutes, not ten',
  $md$People try to be interesting, and interesting is effortful, legible, and not what is being assessed.

In the first two minutes the other person is answering one question, and it is not whether you are impressive. It is whether this is pleasant. Pleasant is a much lower bar, it is far easier to clear, and it is the only thing that decides whether there is a third minute.

**The move:** aim to be pleasant for two minutes rather than interesting for ten.

The practical difference is what you reach for. Trying to be interesting produces stories, opinions and material — things that require the other person to sit and receive. Trying to be pleasant produces short exchanges, easy questions and space, which is what the first two minutes is actually made of.

It also removes the thing that makes approaching frightening. Being interesting on demand is genuinely hard and you might not manage it. Being pleasant for a hundred and twenty seconds is something you have done thousands of times, including this morning, with a colleague, about nothing.

Aiming low is not settling. It is picking the target that is being marked.$md$,
  $j$[
  {
    "situation": "You have opened and you can feel yourself reaching for something impressive.",
    "line": "(ask them something small instead)",
    "why": "The reach for material is the instinct to override. A small question does the job the story was trying to do, at a fraction of the risk."
  },
  {
    "situation": "Ninety seconds in and it has been entirely unremarkable.",
    "line": "(this is going well)",
    "why": "Unremarkable and warm is the target. Two minutes of ordinary is a success and it feels like nothing from the inside, which is why people abandon it too early."
  },
  {
    "situation": "You have just told a two-minute story and they have said four words.",
    "line": "(hand it back, and keep the next one short)",
    "why": "A long turn early makes them an audience. Audiences are polite and they do not become conversations."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "What is the other person actually deciding in the first two minutes?",
    "options": [
      {
        "text": "Whether this is pleasant.",
        "correct": true,
        "note": "A much lower bar than interesting, and the only one that decides whether there is a third minute. Nobody has ever ended a good exchange because it was not impressive."
      },
      {
        "text": "Whether you are interesting.",
        "correct": false,
        "note": "This is what the person approaching believes is being assessed, and aiming at it produces effortful conversation."
      },
      {
        "text": "Whether they find you attractive.",
        "correct": false,
        "note": "Largely settled before you spoke, and much less decisive about the next two minutes than whether talking to you is easy."
      },
      {
        "text": "Whether you are safe.",
        "correct": false,
        "note": "A real and mostly instantaneous read, and it is answered by how you stand rather than by what you say."
      }
    ],
    "explain": "Pleasant is the bar. It is lower, it is what is being marked, and you cleared it this morning with a colleague."
  },
  {
    "prompt": "What does aiming at interesting actually produce?",
    "options": [
      {
        "text": "A better impression.",
        "correct": false,
        "note": "Occasionally, and at a cost that outweighs it this early. Impressiveness is legible as effort."
      },
      {
        "text": "Long turns that make them an audience.",
        "correct": true,
        "note": "Stories, opinions and material all require somebody to sit and receive. Audiences are polite, and polite is where conversations go to end."
      },
      {
        "text": "Nothing — it works fine.",
        "correct": false,
        "note": "It works for people who are naturally very good at it, which is not who this lesson is for."
      },
      {
        "text": "Nervousness.",
        "correct": false,
        "note": "It does, and that is downstream. The structural problem is what it does to the shape of the conversation."
      }
    ],
    "explain": "Interesting produces monologue. Pleasant produces exchange, and exchange is what a conversation is."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "aimed_low",
      "label": "Aimed at pleasant",
      "description": "Went for ease rather than for impact."
    },
    {
      "key": "short_turns",
      "label": "Kept turns short",
      "description": "Avoided long stories in the first two minutes."
    },
    {
      "key": "asked_small",
      "label": "Asked something small",
      "description": "Used easy questions rather than material."
    },
    {
      "key": "let_it_be_ordinary",
      "label": "Let it be ordinary",
      "description": "Did not abandon an exchange for being unremarkable."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A coffee shop with communal tables. You have exchanged a remark with somebody sitting at the same table and it landed.",
  "partner": {
    "name": "Sunniva",
    "role": "somebody at the same communal table",
    "personality": "Pleasant and unhurried. Meets short exchanges warmly and becomes an audience if talked at.",
    "mood": "Working, but not urgently.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Sunil",
      "role": "somebody at the same communal table",
      "personality": "Pleasant and unhurried. Meets short exchanges warmly and becomes an audience if talked at.",
      "mood": "Working, but not urgently.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "They laugh at the remark and go back to their laptop, but not immediately.",
  "success_looks_like": "The user keeps it small and warm for two minutes rather than reaching for material.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Go quiet and polite if talked at for more than a few sentences.",
    "Engage warmly with short exchanges and small questions.",
    "Keep replies to a sentence or two."
  ]
}$j$::jsonb,
  $md$Today, hold one conversation to two minutes of deliberately ordinary. No stories, no opinions worth having. Log how it felt and how it went.$md$
),
(
  (select id from public.skills where slug = 'first-two-minutes'),
  4,
  'When it stalls at ninety seconds',
  $md$It will stall. That is not a sign of anything, and what you do in the next three seconds decides whether it recovers.

The instinct is to dig — to ask a further question about the subject that just ran out. That is the wrong direction, because the subject running out is exactly the information you were given. A second question about it makes the emptiness both of yours.

**The move:** go back out to the room rather than deeper into the subject.

The room is the thing you still have in common. The queue, the band, the weather that got you both in here, the fact that the coffee is taking a very long time. It is where the conversation started and it is always available, which is what makes it a floor rather than a subject.

The other thing is to let the pause be two seconds rather than filling it instantly. A gap that gets filled at speed reads as panic, and panic is far more noticeable than silence. Two seconds is nothing to them and feels like a minute to you, and learning that gap is real work.

If it stalls twice on the room as well, that is a different signal, and it is covered in the next track.$md$,
  $j$[
  {
    "situation": "The subject you opened on has just run out.",
    "line": "They have not called the taxis yet, either.",
    "why": "Back out to the room. It is not clever and it does not need to be — it is a floor you can always stand on."
  },
  {
    "situation": "There is a two-second gap and you are about to fill it.",
    "line": "(let it be two seconds)",
    "why": "The gap is far shorter to them than to you. Filling it at speed is the tell, not the silence."
  },
  {
    "situation": "You have asked a second question about a subject that clearly ended.",
    "line": "(that is the dig — go outward next time)",
    "why": "A dead subject asked about twice is dead twice. The exhaustion was the information."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "The subject runs out at ninety seconds. What is the recovery?",
    "options": [
      {
        "text": "Another question about the same subject.",
        "correct": false,
        "note": "Digging. The subject ending was the information, and asking again makes the emptiness a joint project."
      },
      {
        "text": "A story of your own to fill the space.",
        "correct": false,
        "note": "Turns them into an audience at the exact moment the conversation needs an exchange."
      },
      {
        "text": "Something about the room you are both in.",
        "correct": true,
        "note": "The room is the one thing still shared, it needs no setup, and it is where the conversation began. A floor rather than a topic."
      },
      {
        "text": "Ask what they do for work.",
        "correct": false,
        "note": "Available and it is a jump from cold. It works, and it costs more than the room does."
      }
    ],
    "explain": "Outward to the room, not downward into the subject."
  },
  {
    "prompt": "How long does a pause have to be before it is actually awkward?",
    "options": [
      {
        "text": "About a second.",
        "correct": false,
        "note": "This is the felt length rather than the real one, and acting on it produces the rushing that is the actual problem."
      },
      {
        "text": "It depends how well it is going.",
        "correct": false,
        "note": "True at the margins and it does not change the practical answer, which is that you can afford two seconds anywhere."
      },
      {
        "text": "Any pause is bad.",
        "correct": false,
        "note": "Pauses are ordinary in every conversation you have with people you know. They only feel dangerous with strangers."
      },
      {
        "text": "Longer than you think — two seconds is nothing.",
        "correct": true,
        "note": "Silence runs at a different speed for the person worrying about it. Filling a two-second gap at speed is far more noticeable than the gap."
      }
    ],
    "explain": "Two seconds is free. The panic in filling it is what gets noticed."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "went_outward",
      "label": "Went outward",
      "description": "Recovered on the room rather than digging into the dead subject."
    },
    {
      "key": "let_the_gap",
      "label": "Let the gap be",
      "description": "Allowed two seconds rather than filling instantly."
    },
    {
      "key": "no_panic",
      "label": "Did not accelerate",
      "description": "Kept tempo when it stalled."
    },
    {
      "key": "read_the_second",
      "label": "Read a second stall",
      "description": "Recognised repeated stalling as information rather than as a personal failure."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A wedding reception during the gap between the meal and the dancing. You have been talking to somebody for about ninety seconds and the subject has just run out.",
  "partner": {
    "name": "Bettina",
    "role": "another guest, on the other side of the family",
    "personality": "Perfectly friendly and not a natural conversation-starter. Will pick up anything offered and will not supply a new subject.",
    "mood": "Enjoying it, slightly at a loose end.",
    "openness": 3,
    "sex": "female",
    "alt": {
      "name": "Bertie",
      "role": "another guest, on the other side of the family",
      "personality": "Perfectly friendly and not a natural conversation-starter. Will pick up anything offered and will not supply a new subject.",
      "mood": "Enjoying it, slightly at a loose end.",
      "openness": 3,
      "sex": "male"
    }
  },
  "opening_beat": "They finish a sentence about the meal, and neither of you says anything for a moment.",
  "success_looks_like": "The user recovers on the room rather than asking a second question about the meal.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Answer a second question about the dead subject briefly and flatly.",
    "Pick up anything about the room warmly and add to it.",
    "Never introduce a new subject yourself."
  ]
}$j$::jsonb,
  $md$Today, let one conversation stall and recover it on the room rather than the subject. Count the pause before you speak. Log how long it actually was.$md$
),
(
  (select id from public.skills where slug = 'first-two-minutes'),
  5,
  'Getting to the second subject',
  $md$An exchange becomes a conversation at the moment it survives its first change of subject, and that transition is the one worth being deliberate about.

Everything up to there has been about the room — the queue, the band, the weather. That is a floor, and floors do not go anywhere. The second subject is the first one that is about a person, and getting there is what separates a pleasant ninety seconds from something that continues.

**The move:** take something they said and ask about the person behind it, once.

They mentioned they came straight from work. They said they never come to these. They said the band is a friend's. Each of those is a door, and it opens because they put it there — a detail volunteered is a detail somebody was willing to talk about.

Once, though. The second subject is a step, not a staircase, and the mistake in the other direction is treating a successful transition as permission to interview. One question about them, then something of your own, and now there are two people in it.

If nothing has been volunteered, ask about the room in a way that only they can answer: how they come to be here rather than what they think of it.$md$,
  $j$[
  {
    "situation": "They mention in passing that they came straight from work.",
    "line": "Straight from work is a hard way to arrive at a gig.",
    "why": "Not a question, and it opens the door anyway. It picks up the volunteered detail and invites them to say more without demanding it."
  },
  {
    "situation": "They said they never normally come to these.",
    "line": "What got you out tonight, then?",
    "why": "Their own words, turned into the one question only they can answer. It is the cleanest transition available and it was handed to you."
  },
  {
    "situation": "Nothing has been volunteered and the room has run its course.",
    "line": "How do you know the people here?",
    "why": "About them rather than about the room, and answerable by nobody else. Where nothing has been offered, this is the door you build."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "What makes a volunteered detail the best door?",
    "options": [
      {
        "text": "They chose to say it, so they are willing to talk about it.",
        "correct": true,
        "note": "Nobody volunteers a detail they want left alone. Picking it up is accepting an offer rather than making a request."
      },
      {
        "text": "It shows you were listening.",
        "correct": false,
        "note": "It does, and that is the smaller benefit. The larger one is that the subject is pre-approved."
      },
      {
        "text": "It is easier than thinking of something.",
        "correct": false,
        "note": "True and beside the point. Ease is why people use it; consent is why it works."
      },
      {
        "text": "It keeps the conversation on their interests.",
        "correct": false,
        "note": "Not necessarily their interests — just something they were happy to mention."
      }
    ],
    "explain": "A volunteered detail is a subject they already agreed to. Take it."
  },
  {
    "prompt": "You have made the transition and they answered warmly. What now?",
    "options": [
      {
        "text": "Ask a follow-up while it is going well.",
        "correct": false,
        "note": "The instinct, and it is the third question in a row from somebody who has offered nothing back."
      },
      {
        "text": "Put something of your own in before asking again.",
        "correct": true,
        "note": "Two people or an interview, and this is the fork. A successful transition is not permission to keep asking."
      },
      {
        "text": "Go back to the room, to keep it light.",
        "correct": false,
        "note": "Retreating from a successful transition. The room was the floor you just left."
      },
      {
        "text": "Change to a third subject.",
        "correct": false,
        "note": "Nothing has run out. Changing subject on a live one is restlessness rather than skill."
      }
    ],
    "explain": "Cross the transition, then give something. Otherwise you have interviewed your way into a conversation."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "used_theirs",
      "label": "Used something they volunteered",
      "description": "Built the transition on a detail they offered rather than on a fresh subject."
    },
    {
      "key": "about_them",
      "label": "Asked about the person",
      "description": "Moved from the room to something only they could answer."
    },
    {
      "key": "once",
      "label": "Asked once",
      "description": "Did not turn a successful transition into a run of questions."
    },
    {
      "key": "gave_back",
      "label": "Put something in",
      "description": "Offered something of their own after the transition landed."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A small gig, between sets. You have been talking about the support act for a couple of minutes and they have just mentioned they came straight from work.",
  "partner": {
    "name": "Marisol",
    "role": "somebody standing near you between sets",
    "personality": "Opens up readily when asked about something she raised herself, and stays polite and brief if interviewed.",
    "mood": "Tired but pleased to be out.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Mariano",
      "role": "somebody standing near you between sets",
      "personality": "Opens up readily when asked about something he raised himself, and stays polite and brief if interviewed.",
      "mood": "Tired but pleased to be out.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "\"Sorry — I came straight from work, I am not quite here yet.\"",
  "success_looks_like": "The user picks up the volunteered detail and then puts something of their own in.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Open up warmly if asked about something you raised yourself.",
    "Become brief and polite if asked three questions without anything offered back.",
    "Never change the subject yourself."
  ]
}$j$::jsonb,
  $md$Today, take one conversation across its first change of subject using something they volunteered. Then put something of your own in before asking anything else. Log the detail you used.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('first-two-minutes', 1, 'line', $j${
  "says": "(the bartender takes somebody else's order first, and you are both left waiting)",
  "model": {
    "line": "It is busy in here tonight.",
    "why": "Six words with nothing in front of them. No sorry, no explanation, no warning — it is allowed to be an ordinary thing one person says to another."
  },
  "checks": [
    {
      "kind": "forbids_any",
      "requirement": "No preface, no apology, no warning",
      "words": [
        "sorry",
        "excuse me",
        "this is weird",
        "i will let you",
        "do not mean to",
        "hope you do not mind",
        "random but",
        "quick question"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Short enough to arrive at normal speed",
      "n": 15
    },
    {
      "kind": "max_sentences",
      "requirement": "One line. Let it stand.",
      "n": 1
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-two-minutes', 2, 'line', $j${
  "says": "(they finish a thought about the room, and there is a natural gap)",
  "model": {
    "line": "I am Ravi, by the way.",
    "why": "Given rather than requested, and dropped in rather than announced. By the way is doing the whole job of making it punctuation."
  },
  "checks": [
    {
      "kind": "first_person",
      "requirement": "Give yours first"
    },
    {
      "kind": "no_question",
      "requirement": "Offer it, do not ask for theirs"
    },
    {
      "kind": "max_words",
      "requirement": "Under twelve words — punctuation, not an announcement",
      "n": 12
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-two-minutes', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Ninety seconds in. It has been entirely unremarkable — the coffee, the table, the rain. Nobody has said anything memorable.",
      "prompt": "How is it going?",
      "options": [
        {
          "text": "Badly — nothing has happened.",
          "correct": false,
          "note": "The read that makes somebody reach for material. Nothing happening is the plan."
        },
        {
          "text": "Fine, but it needs a story soon.",
          "correct": false,
          "note": "The reach, delayed by a minute. A story now turns them into an audience."
        },
        {
          "text": "Well. Unremarkable and warm is the target.",
          "correct": true,
          "note": "This is what a successful first two minutes feels like from the inside, which is almost nothing. People abandon it here because they expected it to feel like more."
        },
        {
          "text": "Impossible to tell.",
          "correct": false,
          "note": "It is quite tellable: they are still standing there and still answering."
        }
      ]
    },
    {
      "situation": "You have just told a good story. It took about two minutes and they said four words at the end of it.",
      "prompt": "What happened?",
      "options": [
        {
          "text": "The story was not good enough.",
          "correct": false,
          "note": "The length is the problem rather than the quality. A better two-minute story has the same effect."
        },
        {
          "text": "They are shy.",
          "correct": false,
          "note": "Possibly, and they had no opening. Four words is what is available at the end of somebody else's turn."
        },
        {
          "text": "They are not interested.",
          "correct": false,
          "note": "Too early to read, and it attributes to them something you caused."
        },
        {
          "text": "You made them an audience, and audiences are polite.",
          "correct": true,
          "note": "A long turn this early converts a conversation into a performance. The four words are not disinterest, they are the role you handed them."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-two-minutes', 4, 'line', $j${
  "says": "(they finish a sentence about the meal, and neither of you says anything for a moment)",
  "model": {
    "line": "They have not called the taxis yet either.",
    "why": "Outward to the room rather than back into the meal. It is not clever, and it does not need to be — the room is a floor you can always stand on."
  },
  "checks": [
    {
      "kind": "forbids_any",
      "requirement": "Do not dig into the subject that just ended",
      "words": [
        "meal",
        "food",
        "dinner",
        "starter",
        "dessert",
        "course",
        "eat"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Under sixteen words",
      "n": 16
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-two-minutes', 5, 'line', $j${
  "says": "Sorry — I came straight from work, I am not quite here yet.",
  "model": {
    "line": "Straight from work is a hard way to arrive at a gig.",
    "why": "Picks up the detail they volunteered and opens it without demanding anything. A detail somebody offers is a subject they have already agreed to."
  },
  "checks": [
    {
      "kind": "echoes_any",
      "requirement": "Use the thing they just volunteered",
      "words": [
        "work",
        "straight",
        "here yet"
      ]
    },
    {
      "kind": "max_questions",
      "requirement": "Once. This is a step, not a staircase.",
      "n": 1
    },
    {
      "kind": "max_words",
      "requirement": "Under twenty words",
      "n": 20
    }
  ]
}$j$::jsonb);

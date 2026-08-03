-- Track 1: Openers. Five lessons, escalating from the zero-risk tool to the
-- line that keeps a conversation alive.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'openers'),
  1,
  'Use what is already in the room',
  $md$Most people stall before a first line because they are hunting for something clever. You do not need clever. You need shared.

An Environment opener points at something you and the other person are both already inside: the queue, the noise, the delay, the thing on the table. It works because it is true, it is obvious, and it risks nothing. You have not claimed anything about yourself, and you have not asked them for anything.

**The move:** name something you are both in, say it plainly, then stop.

That stop is the whole technique. A remark with no pause is a comment. A remark followed by a small silence is an invitation.$md$,
  $j$[
    {
      "situation": "The coffee machine at work is grinding away and taking forever.",
      "line": "That machine is really working for its money this morning.",
      "why": "Points at something you can both hear. There is no opinion to disagree with, so the easiest reply is agreement, and agreement is a turn."
    },
    {
      "situation": "A talk has just finished and the room is slowly emptying.",
      "line": "That ran about twenty minutes longer than I had planned for.",
      "why": "A shared experience plus a mild complaint about the situation. Complaining lightly about circumstances, never about a person, is one of the quickest ways for two strangers to feel like allies."
    },
    {
      "situation": "You are standing near the food at a party where you know almost nobody.",
      "line": "I have been staring at these for a while trying to work out what is in them.",
      "why": "Admits something small and faintly ridiculous about yourself, which lowers the stakes for them too. It also hands them a concrete thing to respond to."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You are both waiting on a train that has been delayed twice. Which opener is doing the most work?",
    "options": [
      {
        "text": "Do you travel this line often?",
        "correct": false,
        "note": "This is about them rather than about the situation, so it arrives as a stranger asking for information. It can work, but it costs more than it needs to."
      },
      {
        "text": "Terrible weather lately.",
        "correct": false,
        "note": "It is technically the environment, but it is so generic that there is nothing to actually reply to."
      },
      {
        "text": "This is the second delay tonight, isn't it?",
        "correct": true,
        "note": "True, shared, and specific enough that they can either agree or correct you. Both of those are a turn."
      },
      {
        "text": "So what do you do for work?",
        "correct": false,
        "note": "That is an Occupation opener. It is a fine room to end up in, but walking straight into it from silence is a jump."
      }
    ],
    "explain": "The strongest Environment openers are specific. Generic ones are safe but inert, because there is no foothold in them."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "shared_anchor", "label": "Anchored in something shared", "description": "Opened with something both people were genuinely already experiencing, not a generic remark." },
      { "key": "left_a_gap", "label": "Left room for a reply", "description": "Stopped talking after the opener instead of filling the silence." },
      { "key": "plainness", "label": "Said it plainly", "description": "Chose a true, ordinary line over a clever or rehearsed one." },
      { "key": "specificity", "label": "Specific enough to answer", "description": "Gave the other person a concrete foothold rather than a generality." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The breakfast buffet of a chain hotel on day two of a three-day work conference. There is a short queue for the coffee machine and it is dispensing very slowly.",
    "partner": {
      "name": "Marta",
      "role": "another attendee you have not met",
      "personality": "Dry and observant. Not unfriendly, but will not do the work of the conversation for you.",
      "mood": "Under-caffeinated and slightly bored.",
      "openness": 3
    },
    "opening_beat": "Marta is watching the coffee machine trickle. She glances at you once, briefly, then back at the machine.",
    "success_looks_like": "The user opens with something you are both inside, then leaves space. Marta takes a real turn without having to be dragged into it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply at the length a real person would at openness 3: a sentence or two, warmer only once the user has earned it.",
      "If the user opens with a personal question before any rapport exists, answer briefly and a little flatly.",
      "Do not volunteer new topics in the first two turns. Let the user steer."
    ]
  }$j$::jsonb,
  $md$Start three conversations today with an Environment opener, something you and the other person are both already in. Say it, then stop talking. Log all three, including the ones that went nowhere.$md$
),
(
  (select id from public.skills where slug = 'openers'),
  2,
  'Check they are available first',
  $md$A good opener at a bad moment fails, and it fails in a way that feels personal even though it was not.

Before you say anything, spend two seconds reading availability. You are looking for three things: are their eyes up, are their hands free, and are they already inside something — a call, a queue they are about to reach the front of, a conversation with someone else.

**The move:** look for one signal that they are open. If you do not find it, wait or move on.

This is not caution for its own sake. Openers land far better on someone who has room for them, so reading first raises your hit rate. And knowing you checked makes a flat response much easier to take.$md$,
  $j$[
    {
      "situation": "Someone at the next desk has headphones on and is typing fast.",
      "line": "Say nothing yet.",
      "why": "Headphones plus momentum is a clear no. Waiting for them to surface costs you nothing, and interrupting would spend goodwill you may want later."
    },
    {
      "situation": "Someone in the queue ahead of you looks up from their phone and glances around the room.",
      "line": "Have you tried the thing everyone here seems to be ordering?",
      "why": "Looking up and scanning is the clearest availability signal there is. They have just told you they have attention to spare."
    },
    {
      "situation": "At a party, someone steps back from a group and looks towards the drinks table.",
      "line": "I think that is my cue to get another one too.",
      "why": "Stepping out of a group is a transition moment. People are most open in the gaps between things, not in the middle of them."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which of these is the strongest sign that someone has room for a conversation?",
    "options": [
      {
        "text": "They lift their eyes and look around the room.",
        "correct": true,
        "note": "Eyes up and scanning means their attention is unspent and looking for somewhere to go. This is the single most reliable signal."
      },
      {
        "text": "They are standing on their own.",
        "correct": false,
        "note": "Being alone is not the same as being available. Plenty of people standing alone are deliberately taking a break."
      },
      {
        "text": "They are standing close to you.",
        "correct": false,
        "note": "Proximity is usually an accident of the room. It says nothing about attention."
      },
      {
        "text": "They smiled when they walked in.",
        "correct": false,
        "note": "A smile on arrival is aimed at the room in general, not at you, and it has usually expired by the time you act on it."
      }
    ],
    "explain": "Availability is about where someone's attention is, not where their body is. Eyes are the tell."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_before_opening", "label": "Read the moment first", "description": "Checked for an availability signal before speaking rather than opening blind." },
      { "key": "chose_a_gap", "label": "Picked a transition", "description": "Approached in a gap between things rather than interrupting momentum." },
      { "key": "accepted_the_read", "label": "Took a no gracefully", "description": "When the signal was absent or the reply was flat, backed off without visible sulking." },
      { "key": "opener_quality", "label": "Opener still landed", "description": "Having found a good moment, still opened with something shared and specific." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A busy co-working space mid-afternoon. You are refilling a water bottle at the kitchen counter.",
    "partner": {
      "name": "Dev",
      "role": "someone who works for a different company on the same floor",
      "personality": "Friendly enough but genuinely busy, and honest about it.",
      "mood": "Mid-task and slightly rushed, with a deadline later today.",
      "openness": 2
    },
    "opening_beat": "Dev is waiting for the kettle, phone in one hand, scrolling. He does not look up when you arrive.",
    "success_looks_like": "The user notices Dev is not available yet, waits or opens lightly without demanding much, and either earns a moment when Dev surfaces or lets it go warmly.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Hold openness 2 firmly. Give short answers and make the user work. Do not warm up just because the user is trying hard.",
      "Only become noticeably warmer if the user reads your busyness accurately and gives you an easy way out.",
      "If the user pushes for a long conversation, stay polite but keep replies clipped."
    ]
  }$j$::jsonb,
  $md$Today, before you open a single conversation, take two seconds to check whether the person is actually available. Do it three times. Log what signal you read and whether your read turned out to be right.$md$
),
(
  (select id from public.skills where slug = 'openers'),
  3,
  'Say something instead of asking something',
  $md$Questions feel safer than statements, which is why nervous people ask so many of them. But a run of questions turns you into an interviewer, and interviewers are hard to warm to. The other person ends up doing all the disclosing while learning nothing about you.

A statement opener does two jobs a question cannot. It reveals a sliver of you — how you see the thing in front of you — and it leaves the other person free to pick up whichever thread they like, rather than answering the one you handed them.

**The move:** replace the question mark with a full stop, and trust the silence to do the asking.

You are not banning questions. You are making sure the first thing out of your mouth is a small offer rather than a small demand.$md$,
  $j$[
    {
      "situation": "You are both looking at a genuinely strange painting in a gallery.",
      "line": "I have been trying to decide for a full minute whether I like this.",
      "why": "The question version would be: what do you think of it? The statement version says something about you first, which makes it easier for them to be honest back."
    },
    {
      "situation": "A colleague is unpacking an enormous and complicated lunch.",
      "line": "That is a serious amount of planning for a Tuesday.",
      "why": "Warm, observational, and it flatters them slightly without being obvious about it. There is nothing to answer, which is exactly why they will."
    },
    {
      "situation": "You are both stuck at the back of a very slow supermarket queue.",
      "line": "I picked this lane because it looked shorter. Bold of me.",
      "why": "Mild self-mockery about a situation you are both in. It gives them the option of commiserating, competing with a worse story, or just laughing."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You sit down next to someone at a workshop and want to open. Which line does the most for you?",
    "options": [
      {
        "text": "Have you been to one of these before?",
        "correct": false,
        "note": "A perfectly fine question, but it puts them on the spot, tells them nothing about you, and can be answered in one word."
      },
      {
        "text": "What made you come to this?",
        "correct": false,
        "note": "A better question than the first, but it is still a request for disclosure before you have offered any."
      },
      {
        "text": "Is this seat taken?",
        "correct": false,
        "note": "Necessary logistics, not an opener. Say it, then open properly."
      },
      {
        "text": "I have no idea what I have signed up for here.",
        "correct": true,
        "note": "It discloses something small, it is honest, and it gives them at least three ways in: reassurance, agreement, or their own story."
      }
    ],
    "explain": "Lead with a small offer about yourself. Questions work far better once something has already been given."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "statement_first", "label": "Opened with a statement", "description": "Led with an observation or disclosure rather than a question." },
      { "key": "self_revealed", "label": "Gave something away", "description": "The opener said something small but real about the user's own view." },
      { "key": "multiple_handles", "label": "Left more than one thread", "description": "Gave the partner several possible ways to reply rather than one narrow answer." },
      { "key": "avoided_interview", "label": "Did not stack questions", "description": "Resisted following up with a run of further questions." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The ten minutes before an evening pottery class starts. People are finding seats at a long shared bench.",
    "partner": {
      "name": "Priya",
      "role": "another student, at this class for the first time as well",
      "personality": "Warm but a little shy. Opens up quickly if the other person goes first, stays quiet if not.",
      "mood": "Slightly nervous and pretending not to be.",
      "openness": 4
    },
    "opening_beat": "Priya sits down two seats along, arranges her apron very carefully, and looks at the lump of clay in front of her without touching it.",
    "success_looks_like": "The user opens with a statement rather than a question, gives something small away about themselves, and Priya visibly relaxes and starts offering things unprompted.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "At openness 4, respond warmly to any genuine self-disclosure and offer a little more each time the user does.",
      "If the user opens with a question instead of a statement, answer briefly and politely but do not expand. Make the difference felt, not explained.",
      "Never point out what the user should have done."
    ]
  }$j$::jsonb,
  $md$Today, open three conversations with a statement rather than a question. No question marks in your first line. Log what you said and what came back.$md$
),
(
  (select id from public.skills where slug = 'openers'),
  4,
  'FORD: the four rooms',
  $md$Environment openers get you in the door. FORD tells you where you can go next.

Family, Occupation, Recreation, Dreams. Four territories that nearly every person has something to say about. They are ordered here by how conventional they are, not by how good they are, and the good material is usually further down the list than people expect.

**The move:** notice which room you are standing in, and remember that you can change rooms.

Most stalled conversations are stuck in Occupation, because it is the default and it is the dullest. Recreation is where people become themselves. Dreams — what someone is planning, saving for, or looking forward to — is where they become interesting, and it is far more reachable than it sounds. Family is the most variable: warm for some people, a landmine for others, so let them open that door.$md$,
  $j$[
    {
      "situation": "A conversation has been circling their job for several minutes and is flagging.",
      "line": "Is this the thing you thought you would end up doing?",
      "why": "Still nominally about work, but it steps sideways from Occupation into Dreams. The energy usually changes immediately."
    },
    {
      "situation": "Someone mentions in passing that they are tired because they were up early.",
      "line": "Up early by choice or up early under protest?",
      "why": "A light way into Recreation. If they were up for something they love, you have found the thing they will happily talk about for ten minutes."
    },
    {
      "situation": "Someone mentions they are going away next month.",
      "line": "Is that a proper break or one of those trips you come back from needing a holiday?",
      "why": "Aims at Dreams and Recreation without asking anything heavy. It also gives them permission to complain, which people enjoy more than they admit."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "A conversation about someone's job has gone flat. Which move most reliably revives it?",
    "options": [
      {
        "text": "Ask a more detailed question about their job.",
        "correct": false,
        "note": "Going deeper into a room that is already flat usually just makes it flatter."
      },
      {
        "text": "Ask what they are hoping to be doing in a few years.",
        "correct": true,
        "note": "This steps from Occupation into Dreams while staying on a thread they already raised. Changing rooms is what revives a stalled conversation."
      },
      {
        "text": "Ask about their family.",
        "correct": false,
        "note": "Family can be excellent, but jumping there uninvited from a flat work conversation is a large and slightly personal leap."
      },
      {
        "text": "Talk about your own job instead.",
        "correct": false,
        "note": "Reciprocity is genuinely valuable, but swapping who is talking does not fix a room that has run out of air."
      }
    ],
    "explain": "When a conversation flags, change rooms rather than digging further into the one you are in."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "room_awareness", "label": "Knew which room they were in", "description": "Tracked whether the conversation was in Family, Occupation, Recreation or Dreams." },
      { "key": "changed_rooms", "label": "Changed rooms when it stalled", "description": "Moved territory rather than pressing harder on a flagging topic." },
      { "key": "used_their_thread", "label": "Moved on something they raised", "description": "Made the change of room from a detail the partner had already offered." },
      { "key": "left_family_to_them", "label": "Let them open Family", "description": "Did not push into family territory uninvited." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A long, slightly awkward taxi share from a conference venue back to the hotel. Twenty-five minutes of unavoidable proximity.",
    "partner": {
      "name": "Tom",
      "role": "a senior person from a company you have been introduced to once before",
      "personality": "Polite and professionally friendly. Defaults to work talk and will stay there indefinitely unless moved.",
      "mood": "Tired, a bit wary of small talk, but not unwilling.",
      "openness": 3
    },
    "opening_beat": "Tom asks what you thought of the afternoon session, then answers his own question with a mild opinion about it. He is settling into work talk.",
    "success_looks_like": "The user notices the conversation is stuck in Occupation, moves it into Recreation or Dreams using something Tom actually said, and Tom becomes visibly more animated.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Default to Occupation. Answer work questions fully and comfortably, and drift back to work if the user does not steer.",
      "If the user moves the conversation into Recreation or Dreams on a thread you raised, become noticeably warmer and offer a real detail.",
      "If the user asks directly about family before you have mentioned it, answer briefly and neutrally and change the subject."
    ]
  }$j$::jsonb,
  $md$Take one conversation today into a room it was not already in, from Occupation into Recreation or Dreams. Use something the other person actually said as the door. Log the move and what changed.$md$
),
(
  (select id from public.skills where slug = 'openers'),
  5,
  'The line after the opener',
  $md$An opener is only a door. Most conversations that die did not die at the first line. They died at the second, when the person who opened had nothing ready and reached for a fresh question instead.

The rule is simple: your second line should come out of their reply, not out of your head.

**The move:** take the most specific word in what they just said, and go towards it.

There is almost always one word carrying more weight than the rest — a place, a number, a slightly odd choice of adjective. That word is the invitation. Ignoring it and asking something unrelated tells them you were waiting to talk rather than listening.$md$,
  $j$[
    {
      "situation": "You opened about the delay. They said: yeah, I have been standing here since half six.",
      "line": "Half six is brutal. What got you out that early?",
      "why": "Half six is the specific thing in that sentence. Going towards it proves you were listening, and it opens onto their actual day."
    },
    {
      "situation": "You opened about the food. They said: I made these, actually, but I panicked about the quantities.",
      "line": "Panicked how? Too much, or nowhere near enough?",
      "why": "Panicked is the loaded word, and it is offered with a bit of self-mockery. Meeting them there is warmer than complimenting the food."
    },
    {
      "situation": "You opened about the class. They said: my sister talked me into it. She does this every January.",
      "line": "Every January is a suspiciously specific habit.",
      "why": "Picks the odd detail rather than the obvious one. The obvious follow-up is about the sister; the interesting one is about the ritual."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You open with a remark about the venue. They reply: I only came because my flatmate bailed on me last minute. What is the best second line?",
    "options": [
      {
        "text": "So what do you do for work?",
        "correct": false,
        "note": "A complete reset. It throws away everything they just offered and starts the conversation again from cold."
      },
      {
        "text": "That is a shame.",
        "correct": false,
        "note": "Sympathetic but terminal. It closes the thread rather than opening it, and now you need a whole new line."
      },
      {
        "text": "Bailed on you? That is a bold move an hour before.",
        "correct": true,
        "note": "Goes straight at the loaded word, matches their wry tone, and lets them tell the story they were clearly ready to tell."
      },
      {
        "text": "Do you live with them?",
        "correct": false,
        "note": "It does use a detail from their reply, but it picks the flattest one and turns into logistics."
      }
    ],
    "explain": "Go towards the word carrying the most weight. Usually that is the one with feeling attached, not the one with information attached."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_words", "label": "Built on their reply", "description": "The second line came out of what the partner actually said rather than a fresh topic." },
      { "key": "picked_the_loaded_word", "label": "Went for the weight", "description": "Chose the detail carrying feeling rather than the most factual one." },
      { "key": "matched_tone", "label": "Matched their register", "description": "Met wry with wry and warm with warm, rather than flattening it." },
      { "key": "did_not_reset", "label": "Did not restart", "description": "Avoided abandoning the thread to open a new topic from cold." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The break between two sets at a small live music night. You are both near the bar waiting to be served.",
    "partner": {
      "name": "Nadia",
      "role": "someone who came to the gig on their own",
      "personality": "Quick and a bit wry. Generous with detail if the user shows they are listening, quiet if they do not.",
      "mood": "Enjoying herself and open to talking.",
      "openness": 4
    },
    "opening_beat": "You have already exchanged a line about the length of the bar queue. Nadia says she only came out because she finished a horrible piece of work this afternoon and could not face the flat.",
    "success_looks_like": "The user picks up the loaded part of what Nadia said rather than resetting, and Nadia opens into a real story.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Leave exactly one clearly loaded word or detail in each reply for the user to pick up.",
      "If the user goes towards it, reward them with a real and specific answer.",
      "If the user ignores it and opens a new topic, answer flatly and briefly, and let the conversation cool a little."
    ]
  }$j$::jsonb,
  $md$Today, in three conversations, make your second line come out of their answer instead of your head. Go for the word with feeling in it. Log the word you picked and where it led.$md$
);

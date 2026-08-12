-- Making friends, track 3: The second time, and the third.
--
-- The load-bearing track. Adult friendships are not usually lost to rejection
-- — they are lost to two people who both enjoyed one coffee and then both
-- waited to be wanted. Somebody has to go twice, and everything here is about
-- making it be you without that costing anything.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'the-second-time'),
  1,
  'Somebody has to go twice',
  $md$Here is the shape that ends most adult friendships before they start, and nothing goes wrong in it at any point.

One coffee happens. Both people enjoy it. Both go home thinking *that was nice, we should do it again.* And then nothing, for eight months, until you run into each other and say *we must do that again* with exactly as much sincerity as the first time.

What happened is that both of you were waiting for evidence you were wanted. You initiated once, they said yes and had a good time, and now it is their turn — because going twice in a row feels like being the keen one, and being the keen one feels like a risk.

**The move:** initiate again anyway, and stop treating whose turn it is as information.

Turn-taking is a rule imported from somewhere else. Nobody agreed to it, nobody is tracking it, and it produces a stalemate that is invisible to both parties: each of you has evidence that the other enjoyed it and no evidence that they want more, because the only thing that would produce that evidence is the thing you are both waiting for.

It is worth checking this against your existing friendships, because the check is quick and it settles the argument. Think about who did the arranging in the first few months of the friendships you value most. In several of them it was not you. Now ask whether you have ever, once, thought less of that person for it.

You have not. Nobody has. That fear is entirely one-directional — it is vivid from the inside and does not exist from the outside, which is the definition of a thing not worth acting on.

If you keep one thing: whose turn it is, is not information. It is a rule you inherited and it is costing you people you liked.$md$,
  $j$[
    {
      "situation": "One coffee happened, it was good, and that was three months ago.",
      "line": "(both of you are waiting to be wanted)",
      "why": "Each has evidence the other enjoyed it and none that they want more — because the only thing producing that evidence is the thing you are both waiting for."
    },
    {
      "situation": "It feels like it is their turn.",
      "line": "(nobody agreed to turns)",
      "why": "It is a rule imported from somewhere else that nobody is tracking, and it produces a stalemate invisible to both people."
    },
    {
      "situation": "You are worried about looking keen.",
      "line": "(name one person you thought less of for organising things)",
      "why": "There is not one. The fear is vivid from inside and does not exist from outside."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually ends most adult friendships before they start?",
      "options": [
        { "text": "One of them was not that interested.", "correct": false, "note": "Both enjoyed it, which is what makes this so wasteful. Disinterest would at least be a reason." },
        { "text": "Both people waiting to be wanted.", "correct": true, "note": "Each has evidence the other had a good time and none that they want more, because producing that evidence requires the move neither is making." },
        { "text": "Life got busy.", "correct": false, "note": "What gets said afterwards. Eight months contains plenty of Thursdays for both of you." },
        { "text": "They already have enough friends.", "correct": false, "note": "The explanation people reach for, and it is rarely true — most adults would take another good friend." }
      ],
      "explain": "Whose turn it is, is not information. It is an inherited rule nobody is tracking."
    },
    {
      "prompt": "How do you settle the keen question?",
      "options": [
        { "text": "Accept that some risk is unavoidable.", "correct": false, "note": "It sounds brave and it leaves the fear intact. There is a check that dissolves it instead." },
        { "text": "Alternate strictly, so it is never one-sided.", "correct": false, "note": "That is the rule causing the problem, formalised." },
        { "text": "Ask who did the arranging early in the friendships you value.", "correct": true, "note": "In several it was not you — and you have never once thought less of them for it. The fear exists only from the inside." },
        { "text": "Wait a decent interval before asking again.", "correct": false, "note": "Intervals are how eight months happen. Nobody is timing you." }
      ],
      "explain": "It is one-directional: vivid from inside, non-existent from outside."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_again", "label": "Initiated again", "description": "Did not wait for their turn." },
      { "key": "no_scorekeeping", "label": "Stopped counting turns", "description": "Treated whose turn it was as irrelevant." },
      { "key": "checked", "label": "Checked the fear", "description": "Tested the too-keen worry against real friendships." },
      { "key": "soon", "label": "Did it soon", "description": "Did not leave a decent interval." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You had one very good coffee with somebody eleven weeks ago. Neither of you has done anything since.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to about it",
      "personality": "Asks who arranged things at the start of your existing friendships, and waits for you to notice the answer.",
      "mood": "Unhurried.",
      "openness": 5
    },
    "opening_beat": "\"Eleven weeks. Whose turn do you think it is?\"",
    "success_looks_like": "The user stops treating turn-taking as meaningful and decides to initiate.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask about the early days of the user's existing friendships if turn-taking comes up.",
      "Be pleased and matter-of-fact about a decision to just ask them.",
      "Never say that turn-taking does not matter — let the user get there."
    ]
  }$j$::jsonb,
  $md$Today, message somebody it is technically not your turn with. Log who and how long it had been.$md$
),
(
  (select id from public.skills where slug = 'the-second-time'),
  2,
  'The keen one does not exist',
  $md$The thing stopping the second invitation deserves to be looked at directly, because it is unusually easy to disprove.

The fear is being *the keen one* — the person who is a bit too available, who always suggests things, who wants it more. It is a specific and vivid social character, and almost everybody can picture them.

**The move:** try to name a real one.

Go through the people you know and find somebody you have privately thought less of for organising things, replying quickly, or being pleased to see you. Most people cannot produce a single name. What they produce instead is a general dread, which is a different object entirely and has never been attached to an actual person.

There is a real version, and it is worth separating out so the fear cannot borrow its clothes. What people dislike is not enthusiasm — it is pressure. Somebody who asks for more than you have offered, who makes you responsible for their evening, who takes a decline personally and lets you know. None of that is proposing a coffee twice.

The difference is entirely in what happens after a no. Warm without pressure means proposing, accepting whatever comes back without comment, and staying exactly as friendly. Do that and you can invite somebody as often as you like, because none of it costs them anything.

And the asymmetry is worth having in front of you. Over-inviting has a worst case, which is being slightly too available to somebody who did not mind. Under-inviting has a worst case too, and it is the one you are already living in: every friendship that did not start, silently, with nobody ever knowing it was available.

If you keep one thing: enthusiasm is not the thing people dislike. Pressure is, and it is easy not to apply.$md$,
  $j$[
    {
      "situation": "You are worried about being the keen one.",
      "line": "(name a real one)",
      "why": "Most people cannot produce a single name. What they have is a general dread, which has never been attached to an actual person."
    },
    {
      "situation": "You want to know where the real line is.",
      "line": "(it is pressure, not enthusiasm)",
      "why": "What people dislike is being made responsible for your evening, or having a decline taken personally. Proposing a coffee twice is neither."
    },
    {
      "situation": "They said no to Thursday.",
      "line": "No bother — another time.",
      "why": "The whole difference is what happens after a no. Accept it without comment, stay exactly as warm, and you can invite as often as you like."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What do people actually dislike?",
      "options": [
        { "text": "Enthusiasm.", "correct": false, "note": "Enthusiasm is pleasant to be on the receiving end of, and almost nobody has ever complained about it." },
        { "text": "Pressure.", "correct": true, "note": "Being made responsible for somebody's evening, or having a decline taken personally. Proposing a coffee twice is neither of those things." },
        { "text": "Being asked too often.", "correct": false, "note": "Frequency is fine if each ask is free to decline. It is what happens after the no that decides everything." },
        { "text": "People who need friends.", "correct": false, "note": "A cruel story people tell themselves about their own position, and not something others are actually scanning for." }
      ],
      "explain": "Warm without pressure costs the other person nothing, and can be repeated indefinitely."
    },
    {
      "prompt": "What is the worst case of under-inviting?",
      "options": [
        { "text": "Fewer friends than you would like.", "correct": false, "note": "True and stated so generally that it does not bite. Say what actually happens." },
        { "text": "You seem aloof.", "correct": false, "note": "A cost to your reputation, and the smaller half. The real cost is not about how you look." },
        { "text": "Nothing much — you keep your dignity.", "correct": false, "note": "Dignity was never at stake. That framing is the fear defending itself." },
        { "text": "Friendships that never started, with nobody knowing they were available.", "correct": true, "note": "Silent, cumulative, and the state most people reading this are already in — which makes it the worse of the two worst cases." }
      ],
      "explain": "Over-inviting risks being slightly too available to somebody who did not mind."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "tested", "label": "Tested the fear", "description": "Tried to name a real person they thought less of." },
      { "key": "separated", "label": "Separated pressure from enthusiasm", "description": "Located where the actual line is." },
      { "key": "clean_no", "label": "Took a no cleanly", "description": "Accepted a decline without comment and stayed warm." },
      { "key": "asked_anyway", "label": "Asked anyway", "description": "Did not let the fear decide." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You suggested Thursday. They cannot do Thursday and have not offered anything else.",
    "partner": {
      "name": "Alex",
      "role": "somebody you had coffee with once",
      "personality": "Genuinely busy and genuinely interested. Warms up considerably when a decline is taken lightly, and becomes uncomfortable if it is dwelt on.",
      "mood": "Rushed, friendly.",
      "openness": 4
    },
    "opening_beat": "\"Ah, I cannot do Thursday — sorry.\"",
    "success_looks_like": "The user takes it lightly and leaves the door open without pressing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Warm up and offer a day yourself if the decline is taken lightly and without comment.",
      "Become uncomfortable and vague if the user apologises, over-explains or presses.",
      "Never offer an alternative day unprompted in your first reply."
    ]
  }$j$::jsonb,
  $md$Today, take one small decline with a single light sentence and no follow-up explanation. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'the-second-time'),
  3,
  'Make it a standing thing',
  $md$Every invitation is a small decision, and small decisions are what stop things happening. The way round that is to make the decision once.

**The move:** turn the second or third meeting into something regular, out loud.

*Shall we just make this a monthly thing?* is one sentence, it is asked once, and it removes the entire arranging problem for a year. It also removes the turn-taking question, the whose-move-is-it question, and the eight-month gap — none of which have to be solved individually once there is a standing arrangement.

People rarely say it because it sounds like a big commitment. It is the opposite: a standing thing is the *lowest*-effort version of a friendship, and it is how most long friendships between busy adults actually work. The first Tuesday of the month. Coffee after the class, every week. The same pub on the way home whenever you are both in.

Attach it to something already happening if you can, because that removes even the diary step. *Are you staying for one afterwards?* asked every week becomes a standing thing without anybody ever proposing one, and it costs nothing at all.

Keep it small and keep it frequent rather than large and rare. An hour a month beats a whole evening twice a year, because the thing you are building needs repetition and not intensity — which is the same principle the first track of this topic was about, applied to one person rather than a room.

And it survives being missed. That is the underrated part: with a standing arrangement, a month you both skip is a skipped month rather than the end of the contact, because the next one already exists. A friendship with no rhythm has to be restarted from scratch every single time.

If you keep one thing: ask once and arrange nothing for a year.$md$,
  $j$[
    {
      "situation": "You have had two good coffees and are about to arrange a third.",
      "line": "Shall we just make this a monthly thing?",
      "why": "One sentence, asked once, that removes the arranging problem, the turn-taking problem and the eight-month gap all at once."
    },
    {
      "situation": "You already see them weekly at a class.",
      "line": "Are you staying for one afterwards?",
      "why": "Asked every week it becomes a standing thing without anybody ever proposing one, and it skips the diary entirely."
    },
    {
      "situation": "You are considering a big dinner every few months instead.",
      "line": "(an hour monthly beats an evening twice a year)",
      "why": "What you are building needs repetition rather than intensity. That is the first track of this topic, applied to one person."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a standing arrangement work so well?",
      "options": [
        { "text": "It shows commitment.", "correct": false, "note": "How it reads, and it is the reason people hesitate rather than the reason it works." },
        { "text": "The decision is made once instead of every time.", "correct": true, "note": "It removes the arranging, the turn-taking and the whose-move-is-it question in a single sentence — none of which then need solving individually." },
        { "text": "It puts it in the diary.", "correct": false, "note": "A mechanism of it, and the benefit is bigger than the calendar entry." },
        { "text": "It makes it harder to cancel.", "correct": false, "note": "It should be easy to cancel. Its resilience comes from the next one already existing, not from obligation." }
      ],
      "explain": "Ask once, arrange nothing for a year."
    },
    {
      "prompt": "What is the underrated benefit?",
      "options": [
        { "text": "You see them more.", "correct": false, "note": "True and obvious. There is a second-order benefit that matters more over years." },
        { "text": "It becomes part of your routine.", "correct": false, "note": "Close, and it describes the feel rather than the property that protects the friendship." },
        { "text": "A missed one is just a missed one.", "correct": true, "note": "The next already exists, so nothing has to be restarted. A friendship with no rhythm has to be rebuilt from scratch every single time." },
        { "text": "Neither of you has to keep suggesting things.", "correct": false, "note": "That is the primary benefit rather than the underrated one." }
      ],
      "explain": "Rhythm is what makes a friendship survive a bad month."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "proposed_rhythm", "label": "Proposed a rhythm", "description": "Suggested making it regular rather than arranging one more." },
      { "key": "small_frequent", "label": "Small and frequent", "description": "An hour often rather than an evening rarely." },
      { "key": "attached", "label": "Attached it to something", "description": "Hung it off an existing fixture where possible." },
      { "key": "easy_to_miss", "label": "Made it easy to miss", "description": "Left it low-obligation so a skipped one costs nothing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of your second coffee. It has been good again and you are both putting coats on.",
    "partner": {
      "name": "Alex",
      "role": "somebody you have now had coffee with twice",
      "personality": "Enthusiastic about anything that removes admin. Says yes readily to a rhythm and vaguely to another one-off.",
      "mood": "Warm, about to leave.",
      "openness": 4
    },
    "opening_beat": "\"That went quickly. Same again at some point?\"",
    "success_looks_like": "The user proposes making it regular rather than arranging one more.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say yes with real enthusiasm to any proposal of a rhythm.",
      "Answer another one-off suggestion with a vague yes and start leaving.",
      "Never propose a rhythm yourself."
    ]
  }$j$::jsonb,
  $md$Today, propose making one thing regular instead of arranging it again. Log what you suggested.$md$
),
(
  (select id from public.skills where slug = 'the-second-time'),
  4,
  'Three or four times is the threshold',
  $md$It helps enormously to know how long this takes, because the alternative is judging it every week against a standard that nothing could meet yet.

Somewhere around the third or fourth time you see somebody outside the context you met them in, it stops being a series of arrangements and becomes a friendship. Before that, every meeting is a small event that somebody organised. After it, you are two people who see each other, and the arranging becomes casual, mutual and mostly unremarked.

**The move:** expect to do most of the work for the first few months, and do not read that as the answer.

That is the whole calibration, and it costs nothing except patience. During the run-up, initiating is not evidence of imbalance — it is what the run-up is. Reading it as imbalance is what makes people stop at two, which guarantees the imbalance is never resolved because the threshold is never reached.

It also evens out on its own, which is worth knowing in advance because it will not feel like it at the time. Nobody sits down and agrees to start reciprocating. It simply changes character once you are established, usually without either of you noticing that it has.

The unglamorous corollary is that friendships are, at the start, disproportionately built by whoever tolerates uncertainty for longest. Not the funniest or the most interesting — the one who kept proposing things while it was still ambiguous. That is a much more available quality than charm, and it is entirely a decision.

And it means the useful question at week six is not *is this working* but *how many times have we actually met?* If the answer is two, there is nothing to assess. Get to four, and then look.

If you keep one thing: three or four, then judge. Before that you are assessing something that has not happened yet.$md$,
  $j$[
    {
      "situation": "You have arranged both of the two times you have met.",
      "line": "(that is what the run-up is)",
      "why": "Initiating during the first few months is not evidence of imbalance. Reading it as imbalance is what makes people stop at two."
    },
    {
      "situation": "Week six and you are wondering whether this is working.",
      "line": "(how many times have you actually met?)",
      "why": "If the answer is two, there is nothing to assess yet. Get to four and then look."
    },
    {
      "situation": "You are waiting to see whether they will reciprocate.",
      "line": "(it changes on its own, after the threshold)",
      "why": "Nobody sits down and agrees to start reciprocating. It shifts once you are established, usually without either of you noticing."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What changes at three or four meetings?",
      "options": [
        { "text": "You know each other well enough to relax.", "correct": false, "note": "That happens too and it is a feeling. The change is structural." },
        { "text": "It stops being a series of arrangements and becomes a friendship.", "correct": true, "note": "After the threshold you are two people who see each other, and the arranging becomes casual and mutual without anybody deciding it should." },
        { "text": "You run out of things to talk about.", "correct": false, "note": "The opposite — the fourth conversation is usually the first properly good one." },
        { "text": "They decide whether they like you.", "correct": false, "note": "They decided that at the first coffee. What was undecided is whether this becomes a thing." }
      ],
      "explain": "Before the threshold you are assessing something that has not happened yet."
    },
    {
      "prompt": "What quality actually builds friendships at the start?",
      "options": [
        { "text": "Being good company.", "correct": false, "note": "It makes each meeting better and does not by itself produce a fourth one." },
        { "text": "Having things in common.", "correct": false, "note": "Discovered during the run-up more often than it causes it." },
        { "text": "Tolerating uncertainty for longest.", "correct": true, "note": "Whoever keeps proposing things while it is still ambiguous. Much more available than charm, and entirely a decision." },
        { "text": "Being easy to get hold of.", "correct": false, "note": "Helpful, and it is passive. Somebody still has to propose." }
      ],
      "explain": "Not the funniest. The one who kept going while it was still ambiguous."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Counted the meetings", "description": "Judged by number rather than by feel." },
      { "key": "did_the_work", "label": "Did the early work", "description": "Kept initiating through the ambiguous phase." },
      { "key": "no_verdict", "label": "Withheld the verdict", "description": "Did not assess before the threshold." },
      { "key": "patient", "label": "Tolerated the uncertainty", "description": "Stayed with it while it was still unclear." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have met somebody twice now, both times because you suggested it, and you are wondering whether to suggest a third.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Asks how many times, and points out how small the number is whenever the user starts drawing conclusions.",
      "mood": "Direct.",
      "openness": 5
    },
    "opening_beat": "\"Both times you asked. How many times is that in total, then?\"",
    "success_looks_like": "The user recognises two is too few to conclude anything and keeps going.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask for the actual number whenever the user offers an interpretation.",
      "Be pleased and brief about a decision to arrange a third.",
      "Never mention a threshold yourself."
    ]
  }$j$::jsonb,
  $md$Today, count how many times you have actually met one new person outside where you met them. Log the number.$md$
),
(
  (select id from public.skills where slug = 'the-second-time'),
  5,
  'When they never initiate',
  $md$Sometimes the threshold is passed, the friendship is real, and it is still always you who arranges everything. This is common, it is not what people assume it is, and it is worth handling deliberately rather than accumulating quietly.

**The move:** separate *does not initiate* from *does not want this*, using what happens when you do.

They are completely different and they look identical if you only count invitations. The evidence is in the response: somebody who says yes readily, turns up, is visibly pleased to be there and picks up the conversation where you left it is a friend who does not organise. Somebody who declines more than they accept, is distracted, and never asks anything about your life is telling you something else.

There are many reasons a person does not initiate and hardly any of them are about you. Some people have never organised anything in their lives and have friendships going back decades. Some are chronically overwhelmed. Some assume that whoever started a thing runs it, in the way somebody who did not book the restaurant does not check the reservation.

So the question to ask yourself is not who is doing the arranging, but what you get when you do. If the answer is a good afternoon with somebody who is glad you exist, the arranging is a small tax on something valuable, and paying it is a reasonable trade rather than a humiliation.

If it does bother you, say it once, lightly, and without an accusation in it. *I would love it if you sometimes picked the day* is the whole sentence — plenty of people simply have not noticed, and a surprising number of them change. What does not work is scorekeeping in silence, which eventually converts affection into resentment about something the other person never knew was happening.

And a real answer is allowed. Some friendships genuinely run on one person's effort and are not worth what they cost. Noticing that is not bitterness, it is the same permission the previous topic gave you about a second date.

If you keep one thing: judge by what happens when you ask, not by who asked.$md$,
  $j$[
    {
      "situation": "You have arranged every one of the last six times.",
      "line": "(what happens when you do?)",
      "why": "Somebody who says yes readily, turns up and is visibly glad to be there is a friend who does not organise. That is a different thing from somebody who is not interested."
    },
    {
      "situation": "It has started to bother you.",
      "line": "I would love it if you sometimes picked the day.",
      "why": "One light sentence with no accusation in it. Plenty of people have never noticed, and a surprising number change."
    },
    {
      "situation": "You have been quietly keeping score for a year.",
      "line": "(that converts affection into resentment)",
      "why": "About something the other person never knew was happening. Say it once or let it go — the middle option is the expensive one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How do you tell the two apart?",
      "options": [
        { "text": "By how often they say yes.", "correct": false, "note": "Part of it, and diaries are genuinely full. Look at the whole response rather than the acceptance rate." },
        { "text": "By whether they ever suggest anything.", "correct": false, "note": "That is the thing you are trying to interpret. It cannot also be the evidence." },
        { "text": "By what you get when you do the arranging.", "correct": true, "note": "Glad to be there, picking up where you left off, asking about your life — that is a friend who does not organise. Distracted and declining is something else." },
        { "text": "By asking them directly.", "correct": false, "note": "Worth doing about the arranging, and it will not get you an honest answer about whether they value the friendship." }
      ],
      "explain": "Judge by the response, not by who sent the message."
    },
    {
      "prompt": "It bothers you. What is the move?",
      "options": [
        { "text": "Stop arranging things and see what happens.", "correct": false, "note": "A test conducted silently, which usually ends the friendship without either of you deciding to." },
        { "text": "Say it once, lightly, with no accusation.", "correct": true, "note": "Plenty of people have simply never noticed, and a surprising number change. Silence is the option that turns affection into resentment." },
        { "text": "Accept it — that is just how they are.", "correct": false, "note": "A fine conclusion after saying something and a poor one instead of saying it." },
        { "text": "Match their effort exactly.", "correct": false, "note": "Scorekeeping formalised, and it costs you the friendship to make a point they never received." }
      ],
      "explain": "Say it once or let it go. The middle option is where the damage happens."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_evidence", "label": "Judged by the response", "description": "Looked at what happens when they ask rather than who asks." },
      { "key": "said_once", "label": "Said it once if it mattered", "description": "Raised it lightly rather than keeping score." },
      { "key": "no_test", "label": "Ran no silent test", "description": "Did not stop arranging to see what happened." },
      { "key": "allowed_answer", "label": "Allowed a real answer", "description": "Accepted that some friendships are not worth what they cost." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have arranged all six of the last six meetings with somebody you genuinely like, and it has started to niggle.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to about it",
      "personality": "Asks what the other person is actually like when you do meet, rather than about the arranging.",
      "mood": "Interested.",
      "openness": 5
    },
    "opening_beat": "\"Six times, all you. What are they like when you actually get there?\"",
    "success_looks_like": "The user judges by the response rather than by who initiates.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Keep returning to what the meetings themselves are like.",
      "Take seriously any decision to say something once, lightly.",
      "Never tell the user what the arranging means."
    ]
  }$j$::jsonb,
  $md$Today, look at one friendship you always organise and judge it by what happens when you do. Log the verdict.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('the-second-time', 1, 'choice', $j${
  "beats": [
    {
      "situation": "One very good coffee, eleven weeks ago. Neither of you has done anything since.",
      "prompt": "What happened?",
      "options": [
        { "text": "They did not enjoy it as much as you did.", "correct": false, "note": "Contradicted by the evening itself, and it is the reading that ends things permanently." },
        { "text": "Both of you were waiting to be wanted.", "correct": true, "note": "Each has evidence the other had a good time and none that they want more — because producing that evidence needs the move neither is making." },
        { "text": "It was a one-off thing and that is fine.", "correct": false, "note": "It became one because nobody moved. Nothing about it was inherently a one-off." },
        { "text": "You left it too long to be able to now.", "correct": false, "note": "Eleven weeks is nothing, and nobody is counting. A message today would be entirely unremarkable." }
      ]
    },
    {
      "situation": "It feels like it is their turn, and going again would make you the keen one.",
      "prompt": "How do you settle that?",
      "options": [
        { "text": "Wait a bit longer and see if they get in touch.", "correct": false, "note": "That is the stalemate continuing, and it is how eleven weeks became eleven weeks." },
        { "text": "Ask, but make it clear you are not bothered either way.", "correct": false, "note": "Hedging the ask so it costs less. It mostly makes it easier to decline and harder to accept." },
        { "text": "Accept some risk and do it anyway.", "correct": false, "note": "Brave, and it leaves the fear intact for next time. There is a check that dissolves it." },
        { "text": "Name somebody you have thought less of for organising things.", "correct": true, "note": "You cannot. Nobody can. The fear is vivid from inside and does not exist from outside, which makes it not worth acting on." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-second-time', 2, 'line', $j${
  "says": "Ah, I cannot do Thursday — sorry.",
  "model": {
    "line": "No bother at all — another time.",
    "why": "The whole difference between warm and pressuring is what happens after a no. Taken lightly and without comment, it costs them nothing, which is what lets you ask again."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No pressure, no apology, no dwelling",
      "words": ["sorry", "no worries if", "was just", "if you would rather not", "you probably", "i understand if", "did i do", "too much"] },
    { "kind": "max_words", "requirement": "One light sentence", "n": 18 },
    { "kind": "max_questions", "requirement": "Do not immediately re-ask", "n": 0 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-second-time', 3, 'line', $j${
  "says": "That went quickly. Same again at some point?",
  "model": {
    "line": "Shall we just make it the first Tuesday of the month and stop arranging it?",
    "why": "One sentence, asked once, that removes the arranging, the turn-taking and the eight-month gap together. A standing thing is the lowest-effort version of a friendship, not the biggest commitment."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Propose a rhythm, not another one-off",
      "words": ["every", "monthly", "weekly", "first tuesday", "same time", "regular", "standing", "each month", "fortnight"] },
    { "kind": "forbids_any", "requirement": "Not another sometime",
      "words": ["sometime", "some time", "at some point", "soon", "in a few weeks", "we should"] },
    { "kind": "max_words", "requirement": "One sentence", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-second-time', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You have met somebody twice, both times because you suggested it. You are wondering whether it is worth a third.",
      "prompt": "What is the useful question?",
      "options": [
        { "text": "Is this working?", "correct": false, "note": "Unanswerable at two meetings. You would be assessing something that has not happened yet." },
        { "text": "Do they actually like me?", "correct": false, "note": "They came twice. That question was settled at the first coffee." },
        { "text": "How many times have we met?", "correct": true, "note": "Two. There is nothing to assess. Get to four and then look — three or four is where it stops being arrangements and becomes a friendship." },
        { "text": "Should I wait for them this time?", "correct": false, "note": "The turn-taking rule again, and applying it before the threshold is what guarantees the threshold is never reached." }
      ]
    },
    {
      "situation": "Somewhere around the fourth or fifth meeting, something shifts.",
      "prompt": "What has changed?",
      "options": [
        { "text": "You have run out of new things to talk about.", "correct": false, "note": "The opposite — the fourth conversation is usually the first properly good one." },
        { "text": "They start reciprocating because they now feel obliged.", "correct": false, "note": "Obligation is not what does it, and a friendship running on obligation would be a worse outcome than none." },
        { "text": "You have become better company.", "correct": false, "note": "You are the same. The relationship crossed a threshold rather than you improving." },
        { "text": "It stopped being a series of arrangements.", "correct": true, "note": "You are now two people who see each other, and the arranging goes casual and mutual without either of you deciding it should." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-second-time', 5, 'line', $j${
  "says": "Six times, all you. What are they like when you actually get there?",
  "model": {
    "line": "Genuinely pleased to be there, and they always pick up whatever we were talking about last time.",
    "why": "That is the evidence that matters. Somebody who never organises but is glad you exist is a friend who does not organise — which is a different thing from somebody who is not interested."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Judge by the response, not by the invitations",
      "words": ["never asks", "always me", "cannot be bothered", "does not care", "one sided", "using me", "taking me for granted"] },
    { "kind": "min_words", "requirement": "Describe what actually happens when you meet", "n": 10 },
    { "kind": "max_words", "requirement": "One observation, not a case", "n": 40 }
  ]
}$j$::jsonb);

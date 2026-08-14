-- Storytelling & speaking, track 4: Holding the floor.
--
-- The track a shorter version would cut, and the one this app's readers need.
-- Everything else written on this subject assumes somebody who wants the floor
-- and needs to be better on it. The reader here believes taking ninety seconds
-- of a table's attention is an imposition, and no amount of craft reaches
-- somebody who has not been argued out of that.
--
-- The scene is landing one that is dying, because a story losing a room can
-- only be rehearsed against a room that is actually losing interest.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'holding-the-floor'),
  1,
  'Nobody resents a good story',
  $md$Before any of the craft is any use, the belief underneath has to be dealt with, and it is this: that taking ninety seconds of a table's attention is something you are taking *from* people.

**The move:** notice that the imposition is quality, not length.

A well-told ninety-second story is a gift, and it is close to the thing people came out for. Nobody has ever gone home resenting somebody who told a good one. What people do resent — and it is worth being exact, because the fear is not baseless — is a badly-told six-minute one, and the difference between those is not confidence or entitlement. It is the two tracks you have just read.

There is a second thing worth seeing, which is what a room with nobody willing to tell one is actually like. It is not relaxed. It is flat, and everybody in it can feel the flatness without being able to name it — and the people most likely to be running this belief are frequently the ones whose stories would improve the evening most.

The fear has a specific shape that makes it worth answering rather than dismissing. It says: everybody is being polite, nobody wants this, and I am making them wait. That is what it feels like from inside a story you are unsure of. From outside, a table listening to a story looks like a table enjoying itself, and the strain you are detecting is almost always your own.

The honest exception: there are moments when a story is genuinely wrong, and that is a timing question rather than a permission one. Somebody has just said something serious, or the food is arriving, or two people are mid-conversation. Reading that is the fourth lesson in this track and it is a real skill — but it is a completely different thing from believing you have nothing worth ninety seconds.

If you keep one thing: the thing you are worried about imposing is the thing people came for.$md$,
  $j$[
    {
      "situation": "You have a story and you decide not to bother the table with it.",
      "line": "(the imposition is quality, not length)",
      "why": "Nobody has ever gone home resenting somebody who told a good ninety-second story. What people resent is a badly-told six-minute one."
    },
    {
      "situation": "The table has gone quiet and nobody is saying much.",
      "line": "(that is not relaxed, it is flat)",
      "why": "Everybody can feel it without naming it, and the people most likely to be sitting on a story are the ones who would fix it."
    },
    {
      "situation": "You feel the room straining while you talk.",
      "line": "(that is usually your own)",
      "why": "From outside, a table listening to a story looks like a table enjoying itself. The strain is being detected from inside."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What do people actually resent?",
      "options": [
        { "text": "Somebody who talks a lot.", "correct": false, "note": "People who talk a lot and tell good stories are the ones everybody wants at dinner." },
        { "text": "A badly-told long one.", "correct": true, "note": "The imposition is quality rather than length, and the difference between the two is structure — which is learnable and is the previous two tracks." },
        { "text": "Being made to listen at all.", "correct": false, "note": "Listening to something good is the opposite of a cost, and it is close to why people go out." },
        { "text": "Somebody who dominates the evening.", "correct": false, "note": "A real thing about proportion, and not what stops the reader of this app from speaking." }
      ],
      "explain": "Nobody has gone home resenting a good ninety-second story."
    },
    {
      "prompt": "What is a room where nobody tells stories?",
      "options": [
        { "text": "Relaxed.", "correct": false, "note": "It feels like that from inside the decision not to speak, and it is not what the room is experiencing." },
        { "text": "Balanced — everybody gets a turn.", "correct": false, "note": "Turns are not the currency, and an evening of short exchanges is not more equal, only thinner." },
        { "text": "Polite.", "correct": false, "note": "Politeness is present and it is not what characterises the evening." },
        { "text": "Flat, and everybody can feel it.", "correct": true, "note": "Without being able to name it — and the people most likely to be sitting on a story are frequently the ones who would fix it." }
      ],
      "explain": "The strain you detect while telling one is almost always your own."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "told_it", "label": "Told the story", "description": "Did not sit on it." },
      { "key": "no_permission", "label": "Did not seek permission", "description": "Took the ninety seconds rather than asking for them." },
      { "key": "quality_not_length", "label": "Aimed at quality", "description": "Worked on the telling rather than shortening out of guilt." },
      { "key": "read_strain", "label": "Read the strain correctly", "description": "Did not mistake their own nerves for the room's patience." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A table of five, a lull in the conversation, and you have a good story you have decided not to tell.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Visibly pleased when anybody starts a story, and the evening noticeably improves. Never asks anybody to tell one.",
      "mood": "Comfortable, slightly bored.",
      "openness": 4
    },
    "opening_beat": "(a lull — somebody looks at their phone)",
    "success_looks_like": "The user tells the story rather than sitting on it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond with obvious pleasure and attention to anybody starting a story.",
      "Let the lull continue if nobody says anything, and describe the table getting quieter.",
      "Never invite the user to speak."
    ]
  }$j$::jsonb,
  $md$Today, tell one story you would normally have kept to yourself. Log what stopped you last time.$md$
),
(
  (select id from public.skills where slug = 'holding-the-floor'),
  2,
  'How long you have got',
  $md$Length is not a rule, it is a reading, and the reading is not difficult once you know what you are looking at.

**The move:** match the length to the setting rather than to the story.

**In a group, sixty to ninety seconds.** That is far shorter than people think, and it is roughly one frame, four or five sentences of build, the turn, and the last line. Almost every conversational story that works is inside it.

**One to one, longer is fine.** Two or three minutes is comfortable, because there is no third person waiting for a gap and the listener can interrupt freely, which changes the whole contract.

**Standing up, or with food arriving, much shorter.** Thirty seconds. People standing at a party are managing their drink, the room and their feet, and a two-minute story asks for a kind of attention the position does not supply.

The reading itself is simple: watch for the moment somebody stops listening and starts waiting. It is visible — a nod that arrives slightly early, a glance towards somebody else, a smile held a beat too long. That is not rudeness and it is not a verdict on the story; it is a signal about time, and the response is to get to the end rather than to speed up.

Two things worth knowing about length. A story that is too long is not a story with too much good material, it is a story with too much material that is neither setting up the turn nor paying it off — which means the fix is the cut test, not compression. And the second-best version of a story, told in ninety seconds, beats the best version told in four minutes, every time, in every setting.

If you keep one thing: ninety seconds in a group. If it does not fit, the problem is what is in it rather than how fast you are saying it.$md$,
  $j$[
    {
      "situation": "You are at a table of six.",
      "line": "(sixty to ninety seconds)",
      "why": "One frame, four or five sentences of build, the turn, and the last line. Almost every conversational story that works is inside that."
    },
    {
      "situation": "Somebody nods slightly early and glances across the table.",
      "line": "(that is a signal about time)",
      "why": "They have stopped listening and started waiting. It is not a verdict on the story, and the response is to get to the end rather than to speed up."
    },
    {
      "situation": "It will not fit into ninety seconds.",
      "line": "(then something in it is not serving the turn)",
      "why": "A story that is too long is not one with too much good material. The fix is the cut test rather than talking faster."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How long is a group story?",
      "options": [
        { "text": "As long as it holds them.", "correct": false, "note": "True in principle and useless in the moment, because holding them is exactly what you cannot judge from inside." },
        { "text": "Sixty to ninety seconds.", "correct": true, "note": "One frame, four or five sentences of build, the turn, the last line. Far shorter than people think, and almost every one that works is inside it." },
        { "text": "Two to three minutes.", "correct": false, "note": "That is the one-to-one length, where there is no third person waiting for a gap." },
        { "text": "It depends entirely on the story.", "correct": false, "note": "It depends much more on the setting, which is the useful half of the answer." }
      ],
      "explain": "The second-best version in ninety seconds beats the best version in four minutes."
    },
    {
      "prompt": "You spot somebody waiting rather than listening. What do you do?",
      "options": [
        { "text": "Speed up.", "correct": false, "note": "It reads as anxiety and makes the rest harder to follow, which loses them faster." },
        { "text": "Stop and apologise.", "correct": false, "note": "It makes their attention the subject and puts everybody in an awkward position over an ordinary moment." },
        { "text": "Get to the end.", "correct": true, "note": "Skip to the turn and deliver the last line. Arriving sooner is the fix; talking faster is not." },
        { "text": "Add something to bring them back.", "correct": false, "note": "More material is the opposite of what a story losing a room needs." }
      ],
      "explain": "It is a signal about time rather than a verdict on the story."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_length", "label": "Matched the setting", "description": "Ninety seconds in a group, shorter standing up." },
      { "key": "read_it", "label": "Read the signal", "description": "Noticed listening turning into waiting." },
      { "key": "arrived", "label": "Got to the end", "description": "Skipped forward rather than speeding up." },
      { "key": "cut_not_compressed", "label": "Cut rather than compressed", "description": "Removed material instead of talking faster." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A table of six. You are about ninety seconds into a story and one person has just glanced at somebody else.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reports the table's attention plainly — who is listening, who has started waiting — without commenting on the story.",
      "mood": "Attentive, watching the room.",
      "openness": 4
    },
    "opening_beat": "(somebody at the far end nods slightly early and looks across the table)",
    "success_looks_like": "The user gets to the turn and ends rather than speeding up or adding.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Describe the table's attention plainly as it changes.",
      "Report attention returning if the teller moves towards the end.",
      "Report it draining further if the teller adds material or speeds up."
    ]
  }$j$::jsonb,
  $md$Today, time one story you tell. Log how long it took and how long you thought it took.$md$
),
(
  (select id from public.skills where slug = 'holding-the-floor'),
  3,
  'Landing one that is dying',
  $md$It is going badly. You can feel it, the table can feel it, and there are still forty seconds of material left. What you do now is a genuine skill and almost nobody has been taught it.

**The move:** skip to the turn, deliver the last line, and stop.

That is the whole manoeuvre. Abandon everything between here and the ending, say the strongest line you have, and finish. It is invisible from outside — nobody knows what you cut, and a story arriving at its ending sooner than expected simply reads as a short story.

What makes it feel impossible is the sense that you owe the table the version you planned. You do not. Nobody has the itinerary but you, and the only person who will ever know it was cut short is you.

Then do not do the three things that turn an ordinary flat moment into a memorable one.

**Do not apologise.** *Sorry, this was funnier at the time* is the sentence people remember, and it converts a mildly flat story into an awkwardness everybody now has to manage.

**Do not explain.** Adding context to rescue it is more material for a story that already had too much, and it prolongs precisely the thing you want to end.

**Do not repeat the ending in different words** in the hope of a better reaction. The reaction is what it is, and asking again is the most uncomfortable version of this available.

A flat story is a completely ordinary event that happens to everybody several times a week and is forgotten in about ninety seconds. What is not forgotten is somebody visibly wounded by one, and the difference between those two outcomes is entirely what you do in the ten seconds afterwards.

The best recovery is no recovery: finish, and then say something to somebody else. Moving on normally is the thing that makes it nothing, and it is available immediately.

If you keep one thing: skip to the last line and stop. Nobody knows what was cut, and nobody minds a short story.$md$,
  $j$[
    {
      "situation": "Forty seconds of material left and the table has gone.",
      "line": "(skip to the turn, say the line, stop)",
      "why": "Invisible from outside. Nobody has the itinerary but you, and a story arriving early just reads as a short story."
    },
    {
      "situation": "It landed flat and you want to say it was funnier at the time.",
      "line": "(that is the sentence people remember)",
      "why": "It converts a mildly flat story into an awkwardness everybody now has to manage."
    },
    {
      "situation": "It is over and the moment is slightly limp.",
      "line": "(say something to somebody else)",
      "why": "Moving on normally is what makes it nothing, and it is available immediately. The best recovery is no recovery."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is cutting short invisible?",
      "options": [
        { "text": "People are not paying close attention.", "correct": false, "note": "They may be paying complete attention and still have no idea, which is the stronger version of the point." },
        { "text": "Nobody has the itinerary but you.", "correct": true, "note": "A story arriving at its ending sooner than planned simply reads as a short story, and the only person who knows it was cut is you." },
        { "text": "Stories are flexible anyway.", "correct": false, "note": "Vague. The reason is specific: the plan existed only in your head." },
        { "text": "You can always tell the rest later.", "correct": false, "note": "You can and mostly will not, and that is not what makes cutting safe." }
      ],
      "explain": "Skip to the turn, deliver the last line, stop."
    },
    {
      "prompt": "What actually makes a flat story memorable?",
      "options": [
        { "text": "That it was long.", "correct": false, "note": "Length makes it worse in the moment and is forgotten as quickly as the rest of it." },
        { "text": "That nobody laughed.", "correct": false, "note": "Happens constantly to everybody and is forgotten in about ninety seconds." },
        { "text": "The apology afterwards.", "correct": true, "note": "Sorry, this was funnier at the time is the part people remember, and it turns an ordinary moment into an awkwardness the table has to manage." },
        { "text": "Telling it to the wrong people.", "correct": false, "note": "A cause of the flatness rather than what makes it stick." }
      ],
      "explain": "The best recovery is no recovery. Finish, and say something to somebody else."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "skipped", "label": "Skipped to the ending", "description": "Cut the remaining material." },
      { "key": "no_apology", "label": "Did not apologise", "description": "No it was funnier at the time." },
      { "key": "no_rescue", "label": "Did not try to rescue it", "description": "No extra context, no repeated ending." },
      { "key": "moved_on", "label": "Moved on normally", "description": "Said something to somebody else immediately after." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are two thirds of the way through a story and it is not working. Two people are looking elsewhere and there is a fair amount left.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reports the room honestly. Warm to a story that simply ends, and visibly uncomfortable if the teller apologises for it or tries to rescue it.",
      "mood": "Politely attentive.",
      "openness": 4
    },
    "opening_beat": "(one person has turned slightly away; somebody else picks up their glass)",
    "success_looks_like": "The user lands it early and moves on without apologising.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond normally and move the conversation on if the story simply ends.",
      "Become visibly awkward if the teller apologises, explains or repeats the ending.",
      "Never reassure the teller that it was good."
    ]
  }$j$::jsonb,
  $md$Today, end one thing early rather than finishing it as planned, and do not apologise. Log what you cut.$md$
),
(
  (select id from public.skills where slug = 'holding-the-floor'),
  4,
  'When not to tell one',
  $md$There are moments when a story is genuinely wrong, and being able to read them is what separates somebody with judgement from somebody with material.

**The move:** check what the room is doing before you start, not after.

Four situations where the answer is no, or not yet.

**Somebody has just said something serious.** The reflex to follow a difficult admission with a related story is well meant — it says *I understand, this happens* — and it frequently lands as changing the subject away from them. Ask something instead; the story can wait.

**Two people are mid-conversation.** A story to the table cuts across whatever those two were building, and they will be polite about it. Wait for the join.

**People are leaving, standing, or eating.** Attention is committed elsewhere and a ninety-second story is asking for something the position does not have.

**Somebody has just told a very good one.** Following it immediately with your own reads as competing even when it is not meant that way, and the reaction to yours will be measured against theirs. A beat and a different subject solves it entirely.

The related discipline is not treating stories as a currency. If somebody tells one and you top it, then they top that, the table is in a contest rather than a conversation — and the person who most often ends up excluded from that contest is the one who needed a moment to think of theirs, which is likely to be you.

None of this is a reason not to tell stories. It is the difference between a story that arrives and one that interrupts, and the check takes about a second: what is the room in the middle of?

If you keep one thing: ask what the room is doing first. The story keeps.$md$,
  $j$[
    {
      "situation": "Somebody has just said something difficult about their year.",
      "line": "(ask them something — the story keeps)",
      "why": "Following a difficult admission with a related story says I understand and lands as changing the subject away from them."
    },
    {
      "situation": "Somebody has just told a very good story.",
      "line": "(a beat, and a different subject)",
      "why": "Following it immediately reads as competing even when it is not, and yours will be measured against theirs."
    },
    {
      "situation": "Two people are deep in something at the other end.",
      "line": "(wait for the join)",
      "why": "A story to the table cuts across what they were building, and they will be polite about it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Somebody has just said something serious. What is the reflex to resist?",
      "options": [
        { "text": "Changing the subject entirely.", "correct": false, "note": "Obviously wrong and not the tempting one. The tempting version looks like empathy." },
        { "text": "Telling a related story of your own.", "correct": true, "note": "It is meant as I understand, this happens — and it lands as moving the attention off them. Ask something instead." },
        { "text": "Saying nothing at all.", "correct": false, "note": "Silence is frequently right here, and it is not the error this lesson is about." },
        { "text": "Offering advice.", "correct": false, "note": "A real hazard and a different one, and it belongs to another topic." }
      ],
      "explain": "The story keeps. Almost all of them do."
    },
    {
      "prompt": "Why not follow a very good story with yours?",
      "options": [
        { "text": "Yours will not be as good.", "correct": false, "note": "It might be better, and it would still be measured against theirs rather than heard on its own." },
        { "text": "It reads as competing, whatever you meant.", "correct": true, "note": "And it starts the contest — which most reliably excludes the person who needed a moment to think of theirs." },
        { "text": "The table has had enough.", "correct": false, "note": "A table that just enjoyed a story is the most receptive audience there is. Timing is the issue rather than appetite." },
        { "text": "It is rude to the person who told it.", "correct": false, "note": "Nobody experiences it as rudeness. They experience it as a contest starting." }
      ],
      "explain": "A beat and a different subject solves it entirely."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "checked", "label": "Checked the room first", "description": "Asked what it was in the middle of." },
      { "key": "held_it", "label": "Held the story", "description": "Waited rather than inserting it." },
      { "key": "asked_instead", "label": "Asked instead", "description": "Followed something serious with a question rather than a story." },
      { "key": "no_contest", "label": "Did not compete", "description": "Left a beat after somebody else's." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Somebody at the table has just said, quite carefully, that their father has not been well. You have a story about your own father that is genuinely relevant.",
    "partner": {
      "name": "Priya",
      "role": "the person who has just said something difficult",
      "personality": "Opens up considerably if asked something, and goes quiet and polite if the subject moves to somebody else's experience.",
      "mood": "Exposed, having said more than intended.",
      "openness": 4
    },
    "opening_beat": "\"...anyway. Sorry. It has been a strange few months.\"",
    "success_looks_like": "The user asks something rather than telling their story.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Open up and say more if asked a question about your situation.",
      "Go quiet and polite if the conversation moves to somebody else's experience.",
      "Never ask the user about their own father."
    ]
  }$j$::jsonb,
  $md$Today, hold one story back because the room was doing something else. Log the moment and what you did instead.$md$
),
(
  (select id from public.skills where slug = 'holding-the-floor'),
  5,
  'Being interrupted',
  $md$You are twenty seconds in and somebody starts talking. This happens constantly, it is rarely hostile, and what you do with it decides whether you tell stories in that group again.

**The move:** finish the sentence you are on, then decide whether to carry on.

Most interruptions are not takeovers. They are somebody reacting — an interjection, a question, a laugh with words attached — and the conversation is expected to return to you. Stopping dead at that point is what quiet people do, and it converts an ordinary reaction into an ending, because the room reads your stopping as being finished.

So finish your sentence. Then, if they have properly taken the floor, you have a choice, and both options are legitimate.

**Come back in.** *Anyway, so he opens the door* — no comment on the interruption, no reclaiming, just the thread picked up. A story resumed as if nothing happened is not awkward, and nobody will remember there was a gap.

**Let it go.** If the conversation has genuinely moved and there is no room, the story keeps. Letting one go is not a defeat and the version people regret is the one delivered into a subject that has already changed.

What does not work is the half version — trailing off, waiting to be invited back, and then telling the rest at reduced energy. That produces exactly the flat ending you were afraid of, and it is caused by the yielding rather than by the interruption.

If it happens repeatedly with the same person, the fix is not in the moment: keep going at the same volume, which is the move from Work's meetings track and works identically here. Same principle, different room.

If you keep one thing: finish your sentence. It is the difference between being interrupted and being ended.$md$,
  $j$[
    {
      "situation": "Somebody starts talking twenty seconds in.",
      "line": "(finish the sentence you are on)",
      "why": "Stopping dead converts an ordinary reaction into an ending, because the room reads your stopping as being finished."
    },
    {
      "situation": "They have properly taken the floor and are two sentences in.",
      "line": "Anyway — so he opens the door.",
      "why": "The thread picked up with no comment on the interruption. A story resumed as if nothing happened is not awkward."
    },
    {
      "situation": "The conversation has genuinely moved on.",
      "line": "(the story keeps)",
      "why": "Letting one go is not a defeat. The version people regret is the one delivered into a subject that has already changed."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does stopping dead cost so much?",
      "options": [
        { "text": "It shows you are easily put off.", "correct": false, "note": "An impression about you, and the mechanical cost is more immediate than that." },
        { "text": "The room reads it as you having finished.", "correct": true, "note": "Most interruptions are reactions rather than takeovers, and stopping converts an ordinary interjection into an ending." },
        { "text": "You lose your place.", "correct": false, "note": "You usually know exactly where you were, which is what makes the stopping so frustrating afterwards." },
        { "text": "It encourages them to do it again.", "correct": false, "note": "Possibly over time, and the cost lands in this story rather than the next one." }
      ],
      "explain": "Finish your sentence. That is the difference between interrupted and ended."
    },
    {
      "prompt": "What is the version that does not work?",
      "options": [
        { "text": "Carrying on immediately.", "correct": false, "note": "One of the two legitimate options, and nobody remembers the gap." },
        { "text": "Letting the story go.", "correct": false, "note": "Also legitimate. The story keeps, and a story delivered into a changed subject is the one people regret." },
        { "text": "Trailing off and waiting to be invited back.", "correct": true, "note": "Then telling the rest at reduced energy, which produces exactly the flat ending you feared — caused by the yielding rather than the interruption." },
        { "text": "Saying you had not finished.", "correct": false, "note": "Direct and entirely fine, and it is a stronger move than the one this question is looking for." }
      ],
      "explain": "Keep going at the same volume — the same move as the meetings track in Work."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "finished_sentence", "label": "Finished the sentence", "description": "Did not stop dead." },
      { "key": "decided", "label": "Made a decision", "description": "Came back in or let it go, deliberately." },
      { "key": "no_trailing", "label": "Did not trail off", "description": "Avoided the half version." },
      { "key": "same_volume", "label": "Same volume", "description": "Did not get quieter or louder." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are twenty seconds into a story. Somebody has just started talking over you with a reaction to the first part.",
    "partner": {
      "name": "Rob",
      "role": "somebody at the table who interrupts without noticing",
      "personality": "Enthusiastic and entirely well meaning. Stops and hands the floor back the moment the teller keeps going, and takes over completely if they stop.",
      "mood": "Cheerful.",
      "openness": 4
    },
    "opening_beat": "\"Oh, that place is terrible, we went there in — sorry, go on, no, it is genuinely terrible though —\"",
    "success_looks_like": "The user finishes the sentence and picks the thread back up.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Stop and hand back the floor warmly if the teller keeps going.",
      "Take over the conversation entirely if the teller stops or trails off.",
      "Never invite them to continue once you have the floor."
    ]
  }$j$::jsonb,
  $md$Today, finish your sentence when somebody talks over you. Log what happened next.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('holding-the-floor', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A lull at a table of five. You have a good story and you have decided not to tell it, because it would take about ninety seconds of everybody's attention.",
      "prompt": "What is that ninety seconds?",
      "options": [
        { "text": "Something you would be taking from them.", "correct": false, "note": "The belief the whole track exists to answer. Nobody has ever gone home resenting somebody who told a good story." },
        { "text": "Reasonable, if the story is good enough to justify it.", "correct": false, "note": "Justification is the wrong frame — it keeps permission at the centre, and it is why the story never gets told." },
        { "text": "Close to the thing people came out for.", "correct": true, "note": "The imposition is quality rather than length, and quality is the two tracks you have already read." },
        { "text": "A risk worth taking occasionally.", "correct": false, "note": "It is not a risk being managed. A room with nobody willing to tell one is flat, and everybody can feel it." }
      ]
    },
    {
      "situation": "You are telling it, and you can feel the table straining.",
      "prompt": "What is that feeling?",
      "options": [
        { "text": "Accurate — they have had enough.", "correct": false, "note": "Possible, and it is what a story you are unsure of feels like from inside regardless of what the room is doing." },
        { "text": "A signal to speed up.", "correct": false, "note": "Speeding up reads as anxiety and makes it harder to follow. Getting to the end is the fix." },
        { "text": "A reason to cut it short and apologise.", "correct": false, "note": "Cutting short is right and the apology is what turns an ordinary moment into a memorable one." },
        { "text": "Almost always your own.", "correct": true, "note": "From outside, a table listening to a story looks like a table enjoying itself. The strain is being detected from the inside." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('holding-the-floor', 2, 'choice', $j${
  "beats": [
    {
      "situation": "You are about ninety seconds into a story at a table of six, with roughly a minute of material left.",
      "prompt": "Where are you?",
      "options": [
        { "text": "Fine — it is a good story and it holds up.", "correct": false, "note": "Quality does not extend the budget. Almost every conversational story that works is inside ninety seconds." },
        { "text": "At the end of the budget, with too much left.", "correct": true, "note": "Sixty to ninety seconds in a group. A minute of remaining material means something in it is neither setting up the turn nor paying it off." },
        { "text": "About halfway, which is normal.", "correct": false, "note": "Three minutes is the one-to-one length. At a table of six it is roughly double what the setting supports." },
        { "text": "Impossible to say without knowing the room.", "correct": false, "note": "The room matters and the setting gives you most of the answer before you start." }
      ]
    },
    {
      "situation": "Somebody nods slightly early and glances at the person next to them.",
      "prompt": "What is that?",
      "options": [
        { "text": "Rudeness.", "correct": false, "note": "It is involuntary, and reading it as rudeness produces a defensive response to an ordinary signal." },
        { "text": "A verdict on the story.", "correct": false, "note": "It is about time rather than quality — the same person would have loved the same story at ninety seconds." },
        { "text": "Nothing — people glance around constantly.", "correct": false, "note": "The early nod is the tell. Together they are the most reliable signal available at a table." },
        { "text": "Listening turning into waiting.", "correct": true, "note": "Visible, ordinary, and a cue to get to the end — which means skipping forward rather than talking faster." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('holding-the-floor', 3, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('holding-the-floor', 4, 'line', $j${
  "says": "...anyway. Sorry. It has been a strange few months. (You have a genuinely relevant story about your own father.)",
  "model": {
    "line": "That sounds like a lot to be carrying. How is he doing now?",
    "why": "The story keeps. Following a difficult admission with a related one of your own is meant as I understand, and it lands as moving the attention off them."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask them something" },
    { "kind": "no_first_person", "requirement": "Keep yourself out of it for now" },
    { "kind": "forbids_any", "requirement": "Not your story, however relevant",
      "words": ["my dad", "my father", "same thing happened", "when my", "i went through", "i know exactly", "we had that", "reminds me"] },
    { "kind": "max_words", "requirement": "Short — the floor is theirs", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('holding-the-floor', 5, 'line', $j${
  "says": "Oh, that place is terrible, we went there in — sorry, go on, no, it is genuinely terrible though —",
  "model": {
    "line": "It is, yes. Anyway — so he opens the door, and he is already holding the box.",
    "why": "The thread picked up with no comment on the interruption and no reclaiming. A story resumed as though nothing happened is not awkward, and nobody remembers there was a gap."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not comment on the interruption or trail off",
      "words": ["as i was saying", "if i can finish", "you interrupted", "where was i", "never mind", "it does not matter", "forget it", "you go ahead"] },
    { "kind": "min_words", "requirement": "Pick the thread back up", "n": 10 },
    { "kind": "max_words", "requirement": "Straight back in", "n": 35 }
  ]
}$j$::jsonb);

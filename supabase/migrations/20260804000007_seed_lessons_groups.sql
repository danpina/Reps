-- Track 8: Groups. Joining a conversation already in progress, and earning a
-- turn in it.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'groups'),
  1,
  'Stand there first',
  $md$Joining a group is mostly a physical problem, and people try to solve it verbally.

The standard failure is approaching a circle and saying something. Everyone stops, turns, and now four people are waiting for your contribution to justify the interruption. It rarely does, because you have no idea what they were talking about.

**The move:** join the group physically, listen, and say nothing at all for a while.

Stand at the edge, angled in, close enough to be part of the circle rather than hovering behind it. Groups almost always open up to make room, because that reflex is deeply automatic. Now you are in it, and you have not asked anyone for anything.

Then listen until you know what the conversation actually is. Thirty seconds is usually plenty, and it is thirty seconds that buys you the right to say something relevant instead of something that resets the topic.

Nobody minds a quiet person in a group. Everyone minds an interruption.$md$,
  $j$[
    {
      "situation": "A group of four are mid-conversation and you know one of them.",
      "line": "(step into the circle beside the person you know, look at whoever is speaking)",
      "why": "Physical entry with no verbal demand. Looking at the speaker rather than your friend marks you as part of the audience rather than a visitor."
    },
    {
      "situation": "You have been standing in the circle for thirty seconds and understand the topic.",
      "line": "(still nothing — wait for a natural gap)",
      "why": "Being in the group is already success. The gap will come, and arriving in it is far better than making one."
    },
    {
      "situation": "Someone in the group glances at you as you join.",
      "line": "(small nod, keep listening)",
      "why": "Acknowledges them without turning it into an introduction that stops the conversation. A nod costs the group nothing."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You want to join a group of four who are mid-conversation. What should you do first?",
    "options": [
      {
        "text": "Introduce yourself to the nearest person.",
        "correct": false,
        "note": "Starts a second conversation inside the first one, which forces that person to choose between you and the group."
      },
      {
        "text": "Wait until they finish and then approach.",
        "correct": false,
        "note": "Group conversations do not finish, they change subject. You will be waiting a long time and hovering while you do."
      },
      {
        "text": "Step into the circle, listen, and say nothing for a while.",
        "correct": true,
        "note": "Physical entry asks nothing of anyone, and groups reflexively make room. Listening first means your eventual contribution is relevant."
      },
      {
        "text": "Make a remark about the room to announce yourself.",
        "correct": false,
        "note": "Stops the conversation and makes four people evaluate your opener. This is the version that feels most awkward for everyone."
      }
    ],
    "explain": "Join with your feet, not your voice. Groups open up automatically, and thirty seconds of listening buys you something relevant to say."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "physical_entry", "label": "Joined physically first", "description": "Stepped into the circle rather than announcing themselves verbally." },
      { "key": "listened_first", "label": "Listened before speaking", "description": "Waited long enough to understand what the conversation actually was." },
      { "key": "no_interruption", "label": "Did not stop the conversation", "description": "Joined without forcing the group to pause and attend to them." },
      { "key": "comfortable_quiet", "label": "Was comfortable being quiet", "description": "Did not rush to justify their presence with a contribution." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A leaving do in a pub function room. A group of four are standing in a loose circle, mid-story, and you know one of them slightly.",
    "partner": {
      "name": "the group",
      "role": "four people mid-conversation, one of whom you have met once",
      "personality": "Absorbed in a story about a disastrous team trip. Friendly and not remotely hostile, but genuinely engaged in what they are already talking about.",
      "mood": "Enjoying themselves, a few drinks in.",
      "openness": 3
    },
    "opening_beat": "One of them is halfway through a story about a minibus breaking down, and the others are laughing. Nobody has noticed you yet.",
    "success_looks_like": "The user joins the circle physically, listens without interrupting, and waits for a real gap before contributing something relevant.",
    "constraints": [
      "Stay in character as the whole group. Never coach, evaluate or break the scene.",
      "Continue the story naturally. If the user joins quietly, make room and carry on without making a fuss of them.",
      "If the user interrupts or introduces themselves mid-story, stop, respond politely and briefly, then return to the story, leaving the user outside it.",
      "Offer a natural gap after two or three turns."
    ]
  }$j$::jsonb,
  $md$Join one group conversation today by standing in it and listening first. Say nothing for thirty seconds. Log how long you waited and what you eventually said.$md$
),
(
  (select id from public.skills where slug = 'groups'),
  2,
  'Enter on a laugh or a turn',
  $md$There are good and bad moments to say your first thing in a group, and the difference is large.

The bad moment is mid-thread, when someone is building towards a point. Speaking there makes you the person who derailed it, regardless of what you said.

The good moments are two. **After a laugh**, when the group has just released and nobody is mid-thought — this is the single most reliable entry point in group conversation. And **at a turn**, when a topic has just concluded and the group is briefly looking for what is next.

**The move:** wait for a laugh to finish, then speak into the space just after it.

The laugh does the work. Attention is unallocated, everyone is relaxed and well disposed, and a contribution there feels like joining in rather than taking over. It is also the moment when a slightly weak line will still land, because the group is already warm.$md$,
  $j$[
    {
      "situation": "The group has just laughed at someone's story and it is dying down.",
      "line": "That is almost exactly what happened to us last year, except worse.",
      "why": "Enters in the space after the laugh and offers to extend the same subject. Low risk, and it flatters the previous speaker."
    },
    {
      "situation": "A topic has just concluded and there is a two-second lull.",
      "line": "Did anyone actually make it to the thing on Friday?",
      "why": "A turn is an invitation for a new topic. Supplying one is genuinely useful to a group that has just run out."
    },
    {
      "situation": "Someone is building to the end of a story.",
      "line": "(wait)",
      "why": "There is no version of speaking here that goes well. The laugh you are waiting for is about four seconds away."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "What is the best moment to make your first contribution to a group conversation?",
    "options": [
      {
        "text": "When someone asks you a direct question.",
        "correct": false,
        "note": "Certainly fine, but it means waiting to be invited. Plenty of groups will not think to include you, and you will stay silent."
      },
      {
        "text": "In the space just after a laugh.",
        "correct": true,
        "note": "Attention is unallocated, everyone is relaxed, and speaking there reads as joining in. The most reliable entry point there is."
      },
      {
        "text": "When you have something genuinely good to say.",
        "correct": false,
        "note": "Quality does not fix timing. An excellent point made mid-thread still lands as an interruption."
      },
      {
        "text": "As soon as you have understood the topic.",
        "correct": false,
        "note": "Understanding is necessary but not sufficient. You still need a gap, and speaking as soon as you are ready usually means creating one."
      }
    ],
    "explain": "Timing beats content. The space after a laugh is when a group is most receptive to a new voice."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "waited_for_the_gap", "label": "Waited for a real gap", "description": "Entered after a laugh or at a topic turn rather than mid-thread." },
      { "key": "did_not_derail", "label": "Did not derail a thread", "description": "Avoided speaking while someone was building towards a point." },
      { "key": "extended_the_topic", "label": "Built on what was there", "description": "Contributed to the existing subject rather than replacing it." },
      { "key": "right_size", "label": "Kept the first contribution small", "description": "Made a proportionate first contribution rather than a long one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A birthday gathering in someone's garden. You have been standing at the edge of a group of five for a minute, listening.",
    "partner": {
      "name": "the group",
      "role": "five people who mostly know each other",
      "personality": "Lively, quick, and talking over each other in a friendly way. Receptive to anyone who times an entry well and mildly irritated by an interruption.",
      "mood": "Warm and animated.",
      "openness": 4
    },
    "opening_beat": "Someone finishes a story about a holiday flat with no hot water, and the group laughs.",
    "success_looks_like": "The user speaks into the space just after the laugh and the group takes the contribution up naturally.",
    "constraints": [
      "Stay in character as the whole group. Never coach, evaluate or break the scene.",
      "Provide a laugh or a topic turn every few turns as a natural entry point.",
      "If the user enters after a laugh or at a turn, take up their contribution warmly and build on it.",
      "If the user speaks mid-thread, have someone finish their sentence over them, then move on."
    ]
  }$j$::jsonb,
  $md$Today, join a group conversation by entering in the space just after a laugh. Log what the laugh was about and what you said next.$md$
),
(
  (select id from public.skills where slug = 'groups'),
  3,
  'Contribute before you redirect',
  $md$A group has a subject, and the subject belongs to the group rather than to you.

The most common mistake after a successful entry is to steer immediately — to use your first contribution to move the conversation somewhere you would prefer. It reads as arriving and rearranging the furniture, and groups are quick to notice.

**The move:** add at least two things to the existing subject before you introduce a new one.

Two contributions is the informal price of admission. It proves you were listening, that you are willing to play the group's game rather than your own, and that you can be relied on not to hijack. After that, a topic change from you is welcome rather than presumptuous, and will usually be followed.

The exception is a group that has visibly run out. Then a new topic is not a hijack but a rescue, and everyone will be grateful.$md$,
  $j$[
    {
      "situation": "You have just made your first contribution to a story about commuting.",
      "line": "(add a second thing about commuting before doing anything else)",
      "why": "Two contributions to their subject is the price of being able to set one. It is a small cost for a large gain in standing."
    },
    {
      "situation": "You have contributed twice and the topic is running out of energy.",
      "line": "Speaking of nightmares, did anyone see what happened with the building work?",
      "why": "Bridges from the old subject to the new rather than cutting. Speaking of does a lot of work in making a change feel continuous."
    },
    {
      "situation": "You have just joined and want to talk about something else entirely.",
      "line": "(wait — you have not earned it yet)",
      "why": "Redirecting on arrival is the single fastest way to be read as someone who does not listen."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have joined a group and contributed once. The topic does not interest you. What should you do?",
    "options": [
      {
        "text": "Change the subject to something you can contribute to properly.",
        "correct": false,
        "note": "One contribution does not buy a topic change. This is exactly the move that reads as rearranging the group's conversation."
      },
      {
        "text": "Contribute again to their subject, then look for a bridge.",
        "correct": true,
        "note": "Two contributions is the informal price of admission, and a bridged change afterwards is usually followed happily."
      },
      {
        "text": "Stay quiet until the subject changes on its own.",
        "correct": false,
        "note": "Safe, and it means you contribute nothing for a long stretch. Groups notice a silent member as much as a disruptive one."
      },
      {
        "text": "Ask someone a question about a different topic.",
        "correct": false,
        "note": "A redirect with a question mark on it. It splits one person off from the group conversation, which is worse rather than better."
      }
    ],
    "explain": "Pay the price of admission first. Two contributions to their subject, then you can set one."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "contributed_first", "label": "Contributed before steering", "description": "Added to the group's existing subject before introducing their own." },
      { "key": "did_not_hijack", "label": "Did not redirect on arrival", "description": "Avoided using a first contribution to change the topic." },
      { "key": "bridged", "label": "Bridged rather than cut", "description": "When changing subject, connected it to what came before." },
      { "key": "read_the_energy", "label": "Read whether a change was wanted", "description": "Judged whether the group had run out or was still enjoying the subject." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A work social. A group of four are deep in a conversation about a television series you have not seen.",
    "partner": {
      "name": "the group",
      "role": "four colleagues mid-conversation",
      "personality": "Enthusiastic about their subject and welcoming to anyone who engages with it. Cool towards anyone who tries to move them off it too early.",
      "mood": "Animated and enjoying the subject.",
      "openness": 3
    },
    "opening_beat": "The group are comparing opinions about a series finale, with some disagreement and a lot of energy.",
    "success_looks_like": "The user finds a way to contribute to a subject they know nothing about, does it twice, and only then bridges to something else.",
    "constraints": [
      "Stay in character as the whole group. Never coach, evaluate or break the scene.",
      "Stay enthusiastically on the television subject unless the user has contributed at least twice.",
      "Welcome any genuine engagement, including questions about the series, as a contribution.",
      "If the user tries to change the subject before contributing twice, briefly acknowledge it and return to the original topic."
    ]
  }$j$::jsonb,
  $md$Today, join a group and add two things to their subject before you try to change it. Log what the subject was and what you contributed.$md$
),
(
  (select id from public.skills where slug = 'groups'),
  4,
  'Hold the floor without keeping it',
  $md$Having a turn in a group is different from having a turn with one person. In a group, attention is on loan and everyone can feel how long you have had it.

Two failure modes. Taking too little — contributing in fragments so short that the group never quite registers you as a participant. And taking too much — a story that runs past its natural length while four people wait politely for the end.

**The move:** make your point, land it, and hand it on deliberately.

Handing on is the part people skip. Ending with a question, or turning to someone who would have something to say, converts your turn from a performance into a pass. *You did something similar, didn't you?* costs you four words and makes you look generous rather than talkative.

The rough measure for a group of four or five: if you have been talking for more than about forty seconds without anyone else speaking, you are holding it too long.$md$,
  $j$[
    {
      "situation": "You have told a short story and it has landed.",
      "line": "You must get that constantly, though.",
      "why": "Hands the floor to a specific person while the group is still warm from your contribution. This is what makes a talker read as generous."
    },
    {
      "situation": "You are thirty seconds into a story and it has more to run.",
      "line": "(compress the rest and get to the end)",
      "why": "Noticing the length mid-story and shortening it is a real skill. Groups forgive a rushed ending far more readily than a long middle."
    },
    {
      "situation": "Someone in the group has been quiet and has relevant experience.",
      "line": "This is more your area than mine, honestly.",
      "why": "Passes the floor and raises someone else's standing. It costs nothing and is remembered warmly."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have just finished making a point to a group of five. What is the strongest thing to do next?",
    "options": [
      {
        "text": "Stop talking and let the group carry on.",
        "correct": false,
        "note": "Fine, and it leaves the floor unallocated. Often someone talks over someone else, and your contribution does not connect to anything."
      },
      {
        "text": "Add a second example to reinforce it.",
        "correct": false,
        "note": "Extends your turn past its natural end. This is the most common way people overstay in group conversation."
      },
      {
        "text": "Hand it to someone specific who would have something to say.",
        "correct": true,
        "note": "Converts your turn into a pass, keeps the conversation flowing, and makes you look generous rather than talkative."
      },
      {
        "text": "Ask the group a general question.",
        "correct": false,
        "note": "Better than nothing, but a question to everyone is a question to nobody, and groups often answer it with a pause."
      }
    ],
    "explain": "End your turn by handing it to a specific person. It costs four words and changes how the group reads you."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "took_a_real_turn", "label": "Took a real turn", "description": "Contributed enough to register as a participant rather than in fragments." },
      { "key": "did_not_overstay", "label": "Did not overstay", "description": "Kept contributions to a proportionate length for the group." },
      { "key": "handed_on", "label": "Handed the floor on", "description": "Passed to a specific person rather than leaving the floor unallocated." },
      { "key": "read_the_room", "label": "Noticed how long they had it", "description": "Was aware of how much of the group's attention they had taken." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A dinner table of six. The conversation is general and you have just been asked about something you know a lot about.",
    "partner": {
      "name": "the table",
      "role": "five other guests at a dinner",
      "personality": "Polite and interested, and will listen for as long as someone talks without ever interrupting. One guest, Nadia, has relevant experience and is quiet.",
      "mood": "Relaxed and sociable.",
      "openness": 4
    },
    "opening_beat": "Someone asks you a direct question about a subject you could talk about for twenty minutes, and the table turns to you.",
    "success_looks_like": "The user answers well, keeps it proportionate, and hands the floor on deliberately rather than talking until interrupted.",
    "constraints": [
      "Stay in character as the whole table. Never coach, evaluate or break the scene.",
      "Never interrupt the user. Listen politely for as long as they talk, however long that is.",
      "If the user talks for a long time without handing on, have the table's energy visibly drop and someone start a side conversation.",
      "If the user hands the floor to Nadia or asks a specific person, have her respond well and the conversation come alive."
    ]
  }$j$::jsonb,
  $md$Today, end one of your turns in a group by handing it to a specific person. Log who you handed it to and what happened.$md$
),
(
  (select id from public.skills where slug = 'groups'),
  5,
  'Bring in the quiet one',
  $md$In almost every group of four or more there is someone who has not spoken for a while, and bringing them in is the highest-status thing you can do in a group conversation.

It costs nothing. It makes you the person who noticed. It earns you real loyalty from the person you brought in, who was very likely looking for a way back and could not find one. And it improves the conversation, because the quiet person has usually been listening more carefully than anyone.

**The move:** address them by name with a specific question they can definitely answer.

Specificity is the whole thing. *What do you think?* is a trap — it puts someone on the spot with no material and nowhere to go. *You were at the last one, weren't you?* gives them a concrete, easy answer and an obvious way to continue.

One caution: some people are quiet because they want to be, and dragging them into a spotlight is not a kindness. Offer the door, do not push them through it.$md$,
  $j$[
    {
      "situation": "Someone has been quiet for several minutes and the subject is one they know about.",
      "line": "Priya, you actually did this last year, didn't you?",
      "why": "Name, specific fact, easy answer. They can say yes and continue, or yes and stop, and both are comfortable."
    },
    {
      "situation": "A quiet person laughed at something but did not speak.",
      "line": "You had a look on your face just then.",
      "why": "Invites without demanding. It references something they actually did, so it does not come out of nowhere."
    },
    {
      "situation": "Someone is quiet and looks perfectly content to be.",
      "line": "(offer once, lightly, and let it go if they do not take it)",
      "why": "Quiet is sometimes a preference rather than exclusion. One light offer respects both possibilities."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone in the group has not spoken for five minutes. What is the best way to bring them in?",
    "options": [
      {
        "text": "Ask them what they think about the topic.",
        "correct": false,
        "note": "The classic trap. It is a spotlight with no material attached, and it usually produces a short answer and more silence."
      },
      {
        "text": "Ask them a specific question you know they can answer.",
        "correct": true,
        "note": "Gives them concrete ground to stand on and an obvious way to continue, with no pressure to perform."
      },
      {
        "text": "Point out that they have been quiet.",
        "correct": false,
        "note": "Makes their silence the subject and asks them to account for it in front of everyone. Deeply uncomfortable."
      },
      {
        "text": "Start a side conversation with them.",
        "correct": false,
        "note": "Kind, but it removes them from the group rather than including them, and splits the conversation in two."
      }
    ],
    "explain": "Give them concrete ground. A specific question they can definitely answer is an invitation; an open one is a spotlight."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_them", "label": "Noticed the quiet person", "description": "Registered that someone had been out of the conversation for a while." },
      { "key": "was_specific", "label": "Gave them something concrete", "description": "Asked a specific question they could definitely answer rather than an open one." },
      { "key": "no_spotlight", "label": "Did not put them on the spot", "description": "Invited without making their silence the subject." },
      { "key": "let_it_go", "label": "Accepted a no", "description": "Offered once and let it go if they did not want to come in." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A group of five at a pub table. One person, Sam, has said almost nothing for ten minutes while the others talk.",
    "partner": {
      "name": "the group including Sam",
      "role": "four talkative people and one quiet one",
      "personality": "The four are lively and not deliberately excluding anyone. Sam is interested and has plenty to say but cannot find a way in, and lights up when given a concrete opening.",
      "mood": "Convivial. Sam is slightly on the edge of it.",
      "openness": 4
    },
    "opening_beat": "The group are discussing a trip they are planning. Sam nods along and opens their mouth twice without managing to speak.",
    "success_looks_like": "The user notices Sam, brings them in with a specific question, and Sam joins the conversation properly.",
    "constraints": [
      "Stay in character as the whole group. Never coach, evaluate or break the scene.",
      "Keep the four talkative members talking over each other so there is no natural gap for Sam.",
      "If the user asks Sam an open question like what do you think, have Sam give a short answer and go quiet again.",
      "If the user asks Sam a specific question they can answer, have Sam respond at length and stay in the conversation from then on."
    ]
  }$j$::jsonb,
  $md$Today, bring one quiet person into a group conversation with a specific question. Log who it was and what they said once they were in.$md$
);

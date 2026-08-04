-- Track 2: Going deeper. The Curiosity Ladder, and the discipline of not
-- collecting facts.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'going-deeper'),
  1,
  'The Curiosity Ladder',
  $md$Every conversation has three rungs available at all times, and most people never leave the first one.

**Fact** is what happened. Where you work, where you went, how long it took. **Feeling** is what it was like. **Why or Future** is what it means to them, or what comes next.

Facts are easy to ask for and easy to give, which is why conversations pile up on that rung and then die of boredom. Nobody has ever walked away from a conversation thinking about the facts they exchanged.

**The move:** notice which rung you are on, and take one step up.

You do not need a clever question to climb. A fact plus the words *what was that like* gets you to the second rung every time.$md$,
  $j$[
    {
      "situation": "They mention they have just moved back from three years abroad.",
      "line": "Three years is long enough to have a life there. What was it like coming back?",
      "why": "The fact was the three years. The climb is asking what it was like, which is the only part they will actually have feelings about."
    },
    {
      "situation": "A colleague says they run their own business at the weekend.",
      "line": "Is that the thing you would do full time if you could?",
      "why": "Skips the second rung and lands on the third. Sometimes you can jump, and Future questions are the ones people are most flattered to be asked."
    },
    {
      "situation": "Someone says they have two kids and one is about to start school.",
      "line": "That is a big one. Are you fine about it or quietly not fine about it?",
      "why": "Names the feeling rung explicitly and gives them permission to admit the less presentable answer, which is usually the true one."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "They tell you they cycle to work, about forty minutes each way. Which reply climbs the ladder?",
    "options": [
      {
        "text": "Which route do you take?",
        "correct": false,
        "note": "Another fact. You now know the route and the conversation is exactly where it was."
      },
      {
        "text": "Forty minutes is serious. Do you enjoy it or endure it?",
        "correct": true,
        "note": "Takes the fact they offered and asks what it is like. That is the second rung, and it is the shortest possible climb."
      },
      {
        "text": "How long have you been doing that?",
        "correct": false,
        "note": "A fact about a fact. Perfectly polite and completely flat."
      },
      {
        "text": "I could never do that.",
        "correct": false,
        "note": "It is a disclosure, which is not nothing, but it closes the topic rather than opening it."
      }
    ],
    "explain": "The shortest climb is taking their own fact and asking what it is like. You almost never need a better question than that."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_the_rung", "label": "Knew which rung they were on", "description": "Tracked whether the conversation was trading facts, feelings or meaning." },
      { "key": "climbed", "label": "Took a step up", "description": "Moved from fact to feeling, or feeling to why, rather than staying level." },
      { "key": "used_their_fact", "label": "Climbed on their material", "description": "Built the climb from something the partner had already said." },
      { "key": "did_not_rush", "label": "Did not force the top rung", "description": "Let the climb happen at a pace the partner was comfortable with." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A long table at a friend-of-a-friend's birthday dinner. You are seated next to someone you have never met, between courses.",
    "partner": {
      "name": "Ellis",
      "role": "a friend of the host you have not met before",
      "personality": "Pleasant and cooperative. Answers exactly what is asked and no more, so a run of factual questions produces a run of factual answers.",
      "mood": "Comfortable, mildly bored by the small talk so far.",
      "openness": 3
    },
    "opening_beat": "Ellis mentions they only got back from six months in Lisbon a few weeks ago, and reaches for the water.",
    "success_looks_like": "The user climbs from the Lisbon fact to what it was actually like, and Ellis opens up with something they clearly have feelings about.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Answer factual questions with facts only, in one flat sentence. Do not volunteer feelings unless asked for them.",
      "When the user asks what something was like or why it mattered, become noticeably warmer and give a real, specific answer.",
      "If the user asks three factual questions in a row, let your answers get shorter."
    ]
  }$j$::jsonb,
  $md$Take one conversation today from a fact to a feeling. Use their own words as the step. Log the fact you started from and what came back.$md$
),
(
  (select id from public.skills where slug = 'going-deeper'),
  2,
  'Three facts in a row is an interview',
  $md$There is a specific way conversations die, and it has a shape you can learn to hear.

You ask where they work. They tell you. You ask how long. They tell you. You ask what that involves. They tell you. Nobody has been rude, nothing has gone wrong, and the whole thing has the atmosphere of a form being filled in.

The problem is not the questions. It is that a run of them puts one person in the chair and one behind the desk. The person answering starts to feel examined, and examined people give shorter answers, which makes you ask more questions, which makes it worse.

**The move:** after two questions, put something in yourself — a reaction, an opinion, a small piece of your own.

You are not taking turns talking. You are proving there are two people here.$md$,
  $j$[
    {
      "situation": "You have just asked two questions about their job and can feel it flattening.",
      "line": "I always assumed that job was mostly meetings. Clearly not.",
      "why": "A reaction rather than a third question. It gives them something to agree with or correct, and it puts a bit of you on the table."
    },
    {
      "situation": "They have told you where they live and how long the commute is.",
      "line": "I did that commute for a year and it broke me. You seem to be handling it better.",
      "why": "Breaks the interview with a small confession. Now they are talking to someone rather than answering someone."
    },
    {
      "situation": "They have answered two questions about their weekend plans.",
      "line": "Honestly that sounds like a much better weekend than mine.",
      "why": "Low effort, warm, and entirely sufficient. The interruption does not need to be clever, it just needs to not be another question."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have asked two questions in a row and the answers are getting shorter. What is the strongest next move?",
    "options": [
      {
        "text": "Say something about yourself on the same topic.",
        "correct": true,
        "note": "Breaks the pattern and changes the roles. Shorter answers are usually a sign of being interviewed, not of disinterest."
      },
      {
        "text": "Ask a more interesting question.",
        "correct": false,
        "note": "A better question is still a question. The third one lands as the third one regardless of quality."
      },
      {
        "text": "Change the subject entirely.",
        "correct": false,
        "note": "It escapes the topic but not the dynamic. You will be interviewing them about something else within a minute."
      },
      {
        "text": "Wait for them to ask you something.",
        "correct": false,
        "note": "They might, but you have trained them into the answering role. Waiting usually produces silence and mutual discomfort."
      }
    ],
    "explain": "Shortening answers usually mean the roles have set, not that the person is bored. Change the role rather than the topic."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "broke_the_run", "label": "Did not stack questions", "description": "Never asked three questions in a row without putting something in." },
      { "key": "offered_something", "label": "Gave a reaction or a piece of themselves", "description": "Interrupted the pattern with an opinion, a confession or a reaction." },
      { "key": "heard_the_flattening", "label": "Noticed answers shortening", "description": "Recognised the interview dynamic from the length of replies." },
      { "key": "stayed_warm", "label": "Kept it easy", "description": "Broke the pattern without making the change of gear awkward." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The kitchen at a house party, twenty minutes in. Someone is refilling a glass slowly.",
    "partner": {
      "name": "Rowan",
      "role": "a friend of the host, in the same room as you by accident",
      "personality": "Friendly but easily turned into a witness. Answers questions dutifully and shrinks under a run of them, opening up quickly when the other person offers something first.",
      "mood": "Fine, slightly tired, willing to talk to someone interesting.",
      "openness": 3
    },
    "opening_beat": "Rowan says they only came because they live two streets away, and it seemed rude not to.",
    "success_looks_like": "The user notices the interview forming and breaks it by offering something of their own, after which Rowan visibly relaxes and starts volunteering material.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Answer each question shorter than the last while the user is only asking questions. By the third, reply in under six words.",
      "The moment the user offers an opinion, a reaction or something about themselves, warm up and give a longer answer.",
      "Never explain that you are doing this."
    ]
  }$j$::jsonb,
  $md$Today, in every conversation, count your questions. After two in a row, put something of your own in before the third. Log the conversation where you caught yourself.$md$
),
(
  (select id from public.skills where slug = 'going-deeper'),
  3,
  'Ask about the feeling, not the detail',
  $md$When someone tells you something, there are always two directions to go: further into the facts, or across into what it was like.

Detail questions feel safer because they are specific and answerable. *What year? Which company? How many people?* But detail is the part they can recite without being present, and reciting is not talking.

**The move:** when you notice yourself about to ask for a detail, ask for the experience instead.

The signal to listen for is any sentence with an obvious hidden feeling in it. *I moved back in with my parents for a bit. We ended up doing it ourselves. It was my first time managing anyone.* Each of those has a whole year of feeling folded inside it, and a detail question steps neatly around it.$md$,
  $j$[
    {
      "situation": "They mention they went freelance about a year ago.",
      "line": "Was the first month terrifying or freeing?",
      "why": "The detail question is what do you charge. This one offers two feelings and lets them pick, which is much easier to answer than an open question about emotions."
    },
    {
      "situation": "Someone says they organised their sister's whole wedding.",
      "line": "Did you enjoy any of it, or was it just relief at the end?",
      "why": "Goes straight at the experience, and the slightly cynical framing gives them permission to be honest rather than gracious."
    },
    {
      "situation": "They say they used to play in a band that broke up.",
      "line": "Do you miss it, or are you glad it is over?",
      "why": "Two feelings, opposite directions, no wrong answer. Offering a choice of feelings is far more answerable than asking how did that feel."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "They say: I did a season working in a ski resort when I was twenty-two. Which reply gets you the good version of that story?",
    "options": [
      {
        "text": "Which resort was it?",
        "correct": false,
        "note": "A detail. They will name a place, you will say you have heard of it, and the story stays untold."
      },
      {
        "text": "How did you end up doing that?",
        "correct": false,
        "note": "Better, because it asks for a story rather than a fact. But it points backwards at logistics rather than at what the season was actually like."
      },
      {
        "text": "Was that the best year of your life or one you would rather forget?",
        "correct": true,
        "note": "Offers two feelings at opposite ends and lets them place themselves. Almost nobody answers this one briefly."
      },
      {
        "text": "Do you still ski?",
        "correct": false,
        "note": "Skips past the season entirely and lands in the present, which is the least interesting available place."
      }
    ],
    "explain": "Offering two opposite feelings is easier to answer than asking someone to describe their emotions from scratch."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_feeling", "label": "Asked about experience, not detail", "description": "Went for what something was like rather than the facts around it." },
      { "key": "made_it_answerable", "label": "Made the feeling easy to reach", "description": "Offered a choice of feelings or a concrete frame rather than an abstract question about emotions." },
      { "key": "heard_the_folded_feeling", "label": "Spotted the loaded sentence", "description": "Noticed a statement with an obvious experience folded inside it." },
      { "key": "allowed_the_unflattering", "label": "Left room for the honest answer", "description": "Framed the question so the less presentable answer was available." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A quiet corner of an office kitchen at four in the afternoon. The kettle is going.",
    "partner": {
      "name": "Yusuf",
      "role": "someone from another team you have spoken to twice",
      "personality": "Reserved and a bit formal at first. Has a genuinely interesting history he will not volunteer, and answers detail questions with detail, no more.",
      "mood": "Winding down, not in a hurry.",
      "openness": 3
    },
    "opening_beat": "Yusuf mentions, almost in passing, that he retrained into this job at thirty-four after doing something completely different.",
    "success_looks_like": "The user aims at the experience rather than the logistics, and Yusuf gives a real answer about what the change was actually like.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Answer detail questions with the plain detail and nothing else.",
      "When asked what something was like, or offered a choice of two feelings, answer honestly and at length.",
      "Do not volunteer the emotional version unless the user reaches for it."
    ]
  }$j$::jsonb,
  $md$Today, catch yourself about to ask for a detail and ask for the experience instead. Offer two feelings if it helps them answer. Log the question you nearly asked and the one you asked instead.$md$
),
(
  (select id from public.skills where slug = 'going-deeper'),
  4,
  'The top rung: why and what next',
  $md$The third rung is where people become themselves. It is also the one most people assume is off limits with someone they barely know.

It is not. *Why* and *what next* questions are usually received as flattering rather than intrusive, because they treat the other person as someone with intentions rather than a set of circumstances.

**The move:** ask what they want out of the thing they are already telling you about.

The trick is that the top rung is not about heavy subjects. It is about direction. *Is this the plan or a stepping stone. Would you do it again. What would you do if the money were the same either way.* None of those are personal in the way people fear, and all of them ask someone to say what they actually want.

Two conditions. Climb here on their material, not yours, and only once the first two rungs have been walked.$md$,
  $j$[
    {
      "situation": "They have been describing their job warmly for a couple of minutes.",
      "line": "Is this the thing, or is it on the way to a different thing?",
      "why": "Light phrasing on a serious question. It gives them the option of a one-line answer or a real one, and most people take the real one."
    },
    {
      "situation": "Someone mentions they have been learning a language for two years.",
      "line": "What is the version of this where it has paid off? Living there, or just being able to?",
      "why": "Asks about the future they are imagining, which is a much more interesting subject than their vocabulary."
    },
    {
      "situation": "They have talked about a hobby they clearly love.",
      "line": "Would you want it to be your job, or would that ruin it?",
      "why": "A why question wearing casual clothes. It also carries a small insight, which makes it feel like a conversation rather than an enquiry."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone has spent two minutes happily describing the allotment they took on last spring. What is the strongest top-rung move?",
    "options": [
      {
        "text": "How big is the plot?",
        "correct": false,
        "note": "First rung. You have gone back down the ladder after they climbed it for you."
      },
      {
        "text": "What are you hoping it looks like in a few years?",
        "correct": true,
        "note": "Asks about the future they are picturing. They have already shown they care, so this is an invitation rather than an interrogation."
      },
      {
        "text": "Do you enjoy it?",
        "correct": false,
        "note": "Second rung, and they have already answered it by talking about it happily for two minutes."
      },
      {
        "text": "Why did you want an allotment?",
        "correct": false,
        "note": "It is genuinely a why question, but pointed backwards it can land like a request to justify themselves. Forward-facing why questions are warmer."
      }
    ],
    "explain": "Point the top rung forwards. What someone wants next is easier and more flattering to answer than why they did something."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reached_the_top", "label": "Got to why or future", "description": "Asked about meaning or direction rather than staying on fact and feeling." },
      { "key": "pointed_forwards", "label": "Aimed forwards", "description": "Asked what they want next rather than demanding they justify the past." },
      { "key": "earned_it", "label": "Climbed in order", "description": "Reached the top rung after the lower ones, not from a standing start." },
      { "key": "kept_it_light", "label": "Kept the phrasing casual", "description": "Asked a serious question in ordinary language rather than solemnly." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A slow Sunday in a climbing gym cafe. You have both stopped for coffee at the same time.",
    "partner": {
      "name": "Bea",
      "role": "someone you have seen at this gym a few times and spoken to once",
      "personality": "Open and easy, with a lot to say once someone asks a question worth answering. Gives thin answers to thin questions without meaning to.",
      "mood": "Relaxed and pleased with her morning.",
      "openness": 4
    },
    "opening_beat": "Bea mentions she has been training for a trip she has been saving for since last year, and does not immediately explain what it is.",
    "success_looks_like": "The user walks the lower rungs and then asks what she actually wants out of it, and Bea says something she clearly has not said out loud much.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Give short factual answers to factual questions, warmer ones to feeling questions.",
      "If the user asks a forward-facing why or future question after some rapport, answer generously and reveal something real.",
      "If the user jumps straight to a why question in the first turn, deflect politely and stay on the surface."
    ]
  }$j$::jsonb,
  $md$Take one conversation to the top rung today. Ask what someone wants out of the thing they are already telling you about. Log the question and how they took it.$md$
),
(
  (select id from public.skills where slug = 'going-deeper'),
  5,
  'Not everything needs the top rung',
  $md$A skill learned recently gets over-applied, and depth is the worst offender.

Not every exchange wants to be meaningful. The person scanning your shopping, the neighbour on the stairs, the colleague you pass twice a day — these are conversations whose entire job is to be brief and warm. Climbing the ladder there is not deep, it is heavy, and it makes people slightly wary of you.

**The move:** read how much time and appetite exists, and match it.

Three signals that the ladder is not wanted: they are mid-task, they are standing rather than sitting, or the exchange has a natural end coming in under a minute. In those cases the win is warmth, not depth. A good thirty-second exchange that stays on the first rung is a success, not a failure.

Depth is a tool. Knowing when not to use it is part of knowing how to use it.$md$,
  $j$[
    {
      "situation": "The person at the corner shop you see three times a week, mid-transaction.",
      "line": "You have been busy today. It was chaos in here on Monday too.",
      "why": "First rung, entirely warm, and correctly sized for a forty-second exchange. Nothing here needs to go deeper to be worth having."
    },
    {
      "situation": "A colleague passes your desk on the way to a meeting they are already late for.",
      "line": "Good luck. Tell me how it goes after.",
      "why": "Reads the time available, keeps it light, and leaves a hook for later. Depth deferred is not depth lost."
    },
    {
      "situation": "Someone at a party has just started telling a story to three other people and you have arrived late.",
      "line": "(listen, laugh, say nothing yet)",
      "why": "Not every moment is yours to steer. Sometimes the skilful thing is recognising the conversation already has a direction."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You are behind someone at the pharmacy counter who is clearly in a hurry, and they make a friendly remark about the queue. What is the best response?",
    "options": [
      {
        "text": "Agree warmly and leave it there.",
        "correct": true,
        "note": "Correctly sized. A brief warm exchange is the whole win here, and trying for more would make them manage you as well as their errand."
      },
      {
        "text": "Ask what they are picking up.",
        "correct": false,
        "note": "A reasonable question in most contexts and a slightly intrusive one at a pharmacy counter with someone in a hurry."
      },
      {
        "text": "Ask whether they always come to this one.",
        "correct": false,
        "note": "Harmless but it starts a conversation neither of you has time to finish, which is its own small awkwardness."
      },
      {
        "text": "Ask how their week has been going.",
        "correct": false,
        "note": "A second-rung question dropped on a thirty-second exchange. It reads as more intimacy than the situation supports."
      }
    ],
    "explain": "Match the depth to the time available. A warm exchange that stays shallow is a success, not a missed opportunity."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_the_appetite", "label": "Read how much was wanted", "description": "Judged the time and appetite available before deciding how deep to go." },
      { "key": "sized_it_right", "label": "Matched depth to the moment", "description": "Stayed shallow where shallow was correct rather than climbing by habit." },
      { "key": "stayed_warm", "label": "Kept it warm anyway", "description": "A brief exchange still felt friendly rather than curt." },
      { "key": "left_a_door", "label": "Left something for next time", "description": "Where appropriate, deferred depth rather than abandoning it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The lift in your building, going up six floors, mid-morning.",
    "partner": {
      "name": "Cass",
      "role": "someone who works on a different floor of the same building",
      "personality": "Perfectly friendly, genuinely pressed for time, and mildly uncomfortable if a lift conversation tries to become a real one.",
      "mood": "Rushed but polite, carrying a laptop and a coffee.",
      "openness": 2
    },
    "opening_beat": "Cass says good morning, mentions the lift has been slow all week, and glances at the floor indicator.",
    "success_looks_like": "The user keeps it brief and warm, reads that this is not a moment for depth, and lets it end naturally without straining for more.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Keep every reply short. You are getting out in under a minute.",
      "If the user asks a feeling or why question, answer briefly and a little awkwardly, then look at the floor indicator again.",
      "If the user keeps it light and warm, be genuinely friendly and end the exchange pleasantly."
    ]
  }$j$::jsonb,
  $md$Today, deliberately keep one conversation shallow and warm when you could have taken it deeper. Notice whether it still felt good. Log why you chose to stay on the first rung.$md$
);

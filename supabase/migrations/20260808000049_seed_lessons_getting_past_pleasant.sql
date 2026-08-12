-- Making friends, track 4: Getting past pleasant.
--
-- The track for the relationship that has all the infrastructure and none of
-- the substance: seen weekly for four years, liked enormously, and completely
-- uninformative in both directions.
--
-- One scene, on the ladder, because reading what comes back after a small
-- disclosure is the only thing here that depends on a reply.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'getting-past-pleasant'),
  1,
  'Four years and nowhere',
  $md$There is a kind of relationship that can run for years without becoming anything, and it is not a failed friendship — it is a stable arrangement that neither person has ever tried to change.

You see them regularly. You like them, genuinely. You talk about work, the football, the weather, the thing in the news, the traffic on the way here. Both of you would describe the other as somebody you get on with. Neither of you could say what the other is actually worried about, pleased about, or dealing with.

**The move:** notice that the barrier is not time and not liking each other.

That is worth stating because both are the usual explanations and both are wrong. You have had the time — four years of it. You have the liking. What has never happened is anybody moving from talking about *things* to talking about *themselves*, and there is no mechanism by which that happens on its own.

The pleasant surface is genuinely comfortable, which is why it persists. Nobody is bored. Every individual conversation is fine. It is only visible as a problem when you notice you would not know if this person were having the worst year of their life, and that they would not know it about you either.

And it is symmetrical, which is the useful part. They are not withholding. They are doing exactly what you are doing — being pleasant, waiting for a natural moment, and never getting one, because the pleasant register has no natural exit. It sustains itself perfectly.

The last thing worth saying: this is where most people's social life actually is. Not lonely in the sense of having nobody, but surrounded by people who do not know them, which is a specific and much less obvious kind of lonely and is not fixed by meeting anybody new.

If you keep one thing: nothing is wrong with it and nothing will change it. Somebody has to move first, and the next lesson is how.$md$,
  $j$[
    {
      "situation": "Four years of weekly conversation with somebody you like.",
      "line": "(what are they worried about?)",
      "why": "If you do not know, and they do not know it about you either, the relationship has been stable rather than developing."
    },
    {
      "situation": "You assume it will deepen given more time.",
      "line": "(you have had four years)",
      "why": "Time and liking are the usual explanations and both are already present. What has never happened is either of you moving from things to yourselves."
    },
    {
      "situation": "You feel surrounded by people and still unknown.",
      "line": "(that is this, and meeting new people does not fix it)",
      "why": "It is a different kind of lonely from having nobody, and it is much less obvious — which is why people try to solve it by adding more of the same."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the pleasant surface persist?",
      "options": [
        { "text": "Because neither of you is that interested.", "correct": false, "note": "You like each other, which is what makes this worth fixing rather than abandoning." },
        { "text": "Because it is comfortable and has no natural exit.", "correct": true, "note": "Nobody is bored, every individual conversation is fine, and the register sustains itself perfectly. There is no moment at which it ends by itself." },
        { "text": "Because you do not see each other enough.", "correct": false, "note": "Weekly for four years is plenty of contact. Frequency is not the missing input here — it was the missing input two tracks ago." },
        { "text": "Because one of you is private.", "correct": false, "note": "Usually neither is. It is symmetrical, and both people are waiting for the same moment." }
      ],
      "explain": "It is a stable arrangement rather than a failing one, which is why it needs somebody to move."
    },
    {
      "prompt": "Why is this kind of lonely hard to spot?",
      "options": [
        { "text": "It only shows up in a crisis.", "correct": false, "note": "That is when it becomes unignorable rather than when it starts." },
        { "text": "People do not admit to it.", "correct": false, "note": "Partly, and it is unnoticed more often than it is concealed." },
        { "text": "You are surrounded by people, so nothing looks wrong.", "correct": true, "note": "Not lonely in the sense of having nobody — surrounded by people who do not know you, which is why meeting more people does not fix it." },
        { "text": "It comes on slowly.", "correct": false, "note": "True of many things and not specific enough to be useful." }
      ],
      "explain": "The fix is depth with the people you already see, not more people."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Noticed the arrangement", "description": "Saw it as stable rather than as developing." },
      { "key": "symmetry", "label": "Saw the symmetry", "description": "Recognised the other person is doing the same thing." },
      { "key": "not_time", "label": "Stopped waiting for time", "description": "Accepted that more of the same changes nothing." },
      { "key": "named_someone", "label": "Named somebody", "description": "Identified an actual person this describes." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has asked about somebody you mention often and see every week, and you have realised you cannot answer basic questions about them.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Asks simple questions about the person — what they are worried about, how their year has been — and lets the silence sit.",
      "mood": "Curious, not making a point.",
      "openness": 5
    },
    "opening_beat": "\"You see them every week. What is going on with them at the moment?\"",
    "success_looks_like": "The user notices the relationship has been stable rather than deepening.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask ordinary questions about the other person's life and wait.",
      "Do not fill the silence when the user cannot answer.",
      "Never name the pattern yourself."
    ]
  }$j$::jsonb,
  $md$Today, pick one person you see often and try to say what they are currently worried about. Log whether you could.$md$
),
(
  (select id from public.skills where slug = 'getting-past-pleasant'),
  2,
  'Offer, do not ask',
  $md$The instinct, once you have noticed the surface, is to ask a bigger question. It does not work, and it is worth knowing why before you spend a good relationship finding out.

*How are you, really?* puts somebody on the spot. It asks them to go first, in a register neither of you has used, with no warning and no cover — and the almost universal response is a deflection, delivered warmly, followed by both of you returning to the weather slightly embarrassed.

**The move:** say one true thing about yourself instead, and make it small.

*I have been finding this year quite hard, actually.* *I am dreading Christmas.* *I have basically no idea what I am doing at work at the moment.* Each of those takes four seconds, requires nothing from the other person, and does the one thing a question cannot: it lowers the level without asking anybody's permission.

The difference is where the exposure sits. A question asks them to take the risk. An offer takes it yourself, and once you have, the register has changed for both of you and they can meet it or not.

What usually comes back is relief, and frequently more than you gave. Most people are running the same pleasant surface, would happily stop, and have been waiting for somebody else to make it possible — which is why the shift often happens inside a single conversation and stays.

Keep it small and keep it true. This is not a confession and it is not a bid for sympathy; the aim is a real thing at low volume, not a heavy thing at high volume. And say it plainly rather than as a joke, because the self-deprecating version is a way of saying something while keeping the exit open, and it usually gets laughed at rather than met.

If you keep one thing: offer, do not ask. Going first is the whole move, and it costs about four seconds.$md$,
  $j$[
    {
      "situation": "You want to get past the weather with somebody you like.",
      "line": "I have been finding this year quite hard, actually.",
      "why": "Four seconds, requires nothing from them, and lowers the level without asking permission. An offer takes the risk yourself."
    },
    {
      "situation": "You are about to ask how they really are.",
      "line": "(that asks them to go first)",
      "why": "In a register neither of you has used, with no warning. The near-universal answer is a warm deflection and a return to the weather."
    },
    {
      "situation": "You are about to say it as a joke so it is deniable.",
      "line": "(say it plainly)",
      "why": "The self-deprecating version keeps the exit open, and it gets laughed at rather than met."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does asking a bigger question fail?",
      "options": [
        { "text": "It is too intrusive.", "correct": false, "note": "It is rarely experienced as intrusive. It is experienced as difficult to answer." },
        { "text": "It asks them to take the risk first.", "correct": true, "note": "In a register neither of you has used, with no cover. The near-universal response is a warm deflection followed by the weather." },
        { "text": "People do not know how they really are.", "correct": false, "note": "They usually do. What they lack is a reason to say it in this particular conversation." },
        { "text": "It sounds rehearsed.", "correct": false, "note": "It can, and even asked perfectly naturally it produces the same deflection." }
      ],
      "explain": "An offer takes the risk yourself, and once taken, the register has changed for both of you."
    },
    {
      "prompt": "What makes a good first offer?",
      "options": [
        { "text": "Something significant, so it is clearly genuine.", "correct": false, "note": "Weight is not what proves it. A heavy thing at high volume is the overshare, and it lands as something they have to hold." },
        { "text": "Something small, true, and said plainly.", "correct": true, "note": "Four seconds, no permission needed, no exit kept open. A real thing at low volume rather than a heavy one at high volume." },
        { "text": "Something you can laugh about.", "correct": false, "note": "The self-deprecating version keeps the exit open, and it gets laughed at rather than met." },
        { "text": "Something you have in common with them.", "correct": false, "note": "You cannot know what that is yet — that is what the whole exercise is for." }
      ],
      "explain": "Small, true, plainly. That is the entire specification."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "offered", "label": "Offered rather than asked", "description": "Said something about themselves instead of asking a big question." },
      { "key": "small", "label": "Kept it small", "description": "A real thing at low volume." },
      { "key": "plain", "label": "Said it plainly", "description": "Did not hide it in a joke." },
      { "key": "true", "label": "It was true", "description": "Said something actually the case rather than something safe." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The usual weekly conversation with somebody you have known for years. It has been about the weather and the parking for about six minutes.",
    "partner": {
      "name": "Alex",
      "role": "somebody you see every week and know almost nothing about",
      "personality": "Pleasant and surface-level by default, and unmistakably relieved when anything real is said — usually returning something bigger.",
      "mood": "Comfortable, unhurried.",
      "openness": 4
    },
    "opening_beat": "\"Shocking out there again. They still have not fixed that drain.\"",
    "success_looks_like": "The user offers something true about themselves rather than asking a question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Deflect warmly and return to the surface if asked a big question.",
      "Meet any genuine offer with something real of your own, and visible relief.",
      "Never say anything real first."
    ]
  }$j$::jsonb,
  $md$Today, say one small true thing about yourself to somebody who does not know it. Log what you said and what came back.$md$
),
(
  (select id from public.skills where slug = 'getting-past-pleasant'),
  3,
  'One rung at a time',
  $md$Disclosure is a ladder in exactly the way touch is, and the same rules apply: one rung, read what comes back, then decide about the next one.

**The move:** go one step past where you are, then stop and look.

The rungs are recognisable once you name them. Facts about your life — where you live, what you did at the weekend. Opinions and preferences — what you think about something that matters slightly. Current difficulties at low volume — the year has been hard, work is strange at the moment. And the things you are actually dealing with, which is where a friendship is.

Almost every stuck relationship is stuck between the first and second rung, and moves one at a time from there.

What you are reading for is whether they meet you. Somebody who receives something real and gives you something back has taken the rung — that is a yes, and the next step is available, usually within the same conversation. Somebody who receives it warmly and gives nothing has not, and the correct response is to stay at that level rather than climbing alone.

Climbing alone is the failure worth naming, because it is what produces the overshare. Nobody plans to say too much. What happens is that one person keeps going up rungs without checking, the gap between them widens, and by the fourth unmet disclosure it has become something the listener has to manage rather than something being shared.

And do not require it in one conversation. The surface reasserts itself — you will have a real exchange in October and be back on the weather in November, which is normal and is not a reversal. It takes a few times before the register settles at the new level, and it settles by repetition rather than by anybody deciding.

If you keep one thing: one rung, then read. The whole difference between depth and oversharing is whether you checked.$md$,
  $j$[
    {
      "situation": "You said something real and they gave you something back.",
      "line": "(rung taken — the next one is available)",
      "why": "Being met is the yes. It is usually available within the same conversation, and it is how a relationship shifts in one afternoon."
    },
    {
      "situation": "You said something real and got warmth and nothing else.",
      "line": "(stay at this level for now)",
      "why": "They have not taken the rung. Climbing alone is precisely what produces an overshare, and nobody plans one."
    },
    {
      "situation": "You had a real conversation in October and it is back to the weather in November.",
      "line": "(that is normal, not a reversal)",
      "why": "The surface reasserts itself. The register settles at a new level by repetition rather than by anybody deciding."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What are you reading for after a disclosure?",
      "options": [
        { "text": "Whether they seemed comfortable.", "correct": false, "note": "Most people look comfortable, because most people are polite. Comfort is not the signal." },
        { "text": "Whether they met you with something of their own.", "correct": true, "note": "Being met is the yes. Warmth with nothing behind it means the rung was not taken, and the level should stay where it is." },
        { "text": "Whether they asked a follow-up question.", "correct": false, "note": "A good sign and it can be pure politeness. Giving something back costs more and means more." },
        { "text": "Whether they changed the subject.", "correct": false, "note": "Useful when it happens and too crude a test. Plenty of people receive something well and then move on naturally." }
      ],
      "explain": "One rung, then read. Being met is what makes the next one available."
    },
    {
      "prompt": "What actually produces an overshare?",
      "options": [
        { "text": "Saying something too heavy.", "correct": false, "note": "Weight matters less than position. A heavy thing said at the right rung is fine." },
        { "text": "Alcohol.", "correct": false, "note": "The occasion rather than the cause, and plenty of oversharing happens over coffee." },
        { "text": "Trusting somebody too quickly.", "correct": false, "note": "How it gets described afterwards. In the moment it is rarely a judgement about them at all." },
        { "text": "Climbing without checking whether they came.", "correct": true, "note": "The gap widens, and by the fourth unmet disclosure it is something the listener has to manage rather than something shared." }
      ],
      "explain": "Nobody plans to say too much. They just never looked back to see who was still with them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_rung", "label": "Went one rung", "description": "Moved a single step rather than several." },
      { "key": "read", "label": "Read what came back", "description": "Checked whether they were met before continuing." },
      { "key": "stayed", "label": "Stayed level when unmet", "description": "Did not climb alone." },
      { "key": "patient", "label": "Allowed it to take a few goes", "description": "Did not treat a return to the surface as a reversal." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You said something honest about your year a moment ago. What happens next depends entirely on what they do with it.",
    "partner": {
      "name": "Alex",
      "role": "somebody you see every week and are just starting to actually know",
      "personality": "Meets a first honest remark with something real of their own, and then follows wherever the level goes — including becoming uncomfortable if it climbs several rungs at once.",
      "mood": "Attentive.",
      "openness": 4
    },
    "opening_beat": "\"...honestly, same. It has been a strange year here too, if I am being straight about it.\"",
    "success_looks_like": "The user takes one further rung rather than several, and keeps reading.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Match the user's level and give something of your own each time you are met.",
      "Become visibly uncomfortable and go quieter if the user jumps several rungs at once.",
      "Never lead the level yourself."
    ]
  }$j$::jsonb,
  $md$Today, go one rung further with somebody than you normally would, then stop and notice whether they came with you. Log both.$md$
),
(
  (select id from public.skills where slug = 'getting-past-pleasant'),
  4,
  'Say the warm thing out loud',
  $md$There is a category of sentence almost nobody says to their friends, and saying it is one of the highest-return things in this entire app.

*I am really glad we started doing this.* *You are one of the few people I can say that to.* *I always feel better after these.* All true, all easy to think, and all somehow unsayable — for a reason worth naming, which is that saying something warm without a joke attached feels enormously exposing, and the reflex is to deflect it into humour before it lands.

**The move:** say the warm thing plainly, once, and do not undercut it.

The undercut is the part to watch. *I am really glad we do this — God, that was cheesy* deletes the sentence you just said, and the listener is left with the retraction rather than the thing. The whole value is in the four seconds where it is allowed to stand.

What it does is disproportionate. Almost nobody hears this. Most people have no idea whether their friends value them specifically, because everybody is running the same reticence — so a plain sentence lands as something unusual and gets remembered for years, which is a strange return on eleven words.

It is also the thing that converts a good acquaintance into a friend faster than any amount of shared time. Depth is not only about difficulties; saying that somebody matters is its own rung, and often an easier one than saying that you are struggling.

Two practical notes. Specific beats general — *these Tuesdays are the best thing in my week* is better than *you are a great friend*, because it names something real rather than awarding a title. And expect awkwardness in the reply: British people in particular will absorb it badly and say something clumsy, and that is not a failure. They heard it, and they will remember it long after the awkward reply.

If you keep one thing: say it and let it sit. The undercut is the only way to get this wrong.$md$,
  $j$[
    {
      "situation": "You have been meeting monthly for a year and it has become the best part of the month.",
      "line": "These Tuesdays are genuinely the best thing in my month.",
      "why": "Specific rather than a title awarded. Almost nobody hears this, which is why eleven words get remembered for years."
    },
    {
      "situation": "You said it and the silence feels enormous.",
      "line": "(do not add anything)",
      "why": "The undercut deletes the sentence and leaves them with the retraction. The value is in the four seconds where it stands."
    },
    {
      "situation": "They reply with something clumsy and change the subject.",
      "line": "(they heard it)",
      "why": "An awkward reply is not a failure. They will remember the sentence long after they have forgotten how they answered it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the only way to get this wrong?",
      "options": [
        { "text": "Saying it too early in a friendship.", "correct": false, "note": "Early is fine, provided it is true and specific. Nobody has minded being told they are good company." },
        { "text": "Undercutting it immediately.", "correct": true, "note": "God, that was cheesy deletes the sentence and leaves them with the retraction. The whole value is in the seconds where it is allowed to stand." },
        { "text": "Making it too specific.", "correct": false, "note": "Specific is the better version. General is a title awarded rather than something noticed." },
        { "text": "Saying it in public.", "correct": false, "note": "Setting barely matters. What matters is whether it survives the next four seconds." }
      ],
      "explain": "Say it and let it sit. The awkward silence afterwards is doing the work."
    },
    {
      "prompt": "Why does it land so hard?",
      "options": [
        { "text": "People are insecure and need reassurance.", "correct": false, "note": "A slightly bleak reading, and it works on entirely secure people too." },
        { "text": "It is unexpected in the moment.", "correct": false, "note": "Surprise is part of it and would fade. This gets remembered for years, which needs a better explanation." },
        { "text": "Almost nobody knows whether their friends value them specifically.", "correct": true, "note": "Everybody is running the same reticence, so most people have simply never been told. That is why eleven ordinary words are remembered." },
        { "text": "It gives them permission to say it back.", "correct": false, "note": "Often happens and is not why it matters. It would land even if they said nothing." }
      ],
      "explain": "Saying somebody matters is its own rung, and frequently an easier one than saying you are struggling."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said it plainly", "description": "Named the warm thing without a joke in front of it." },
      { "key": "no_undercut", "label": "Did not undercut it", "description": "Let it stand rather than retracting." },
      { "key": "specific", "label": "Was specific", "description": "Named something real rather than awarding a title." },
      { "key": "allowed_awkward", "label": "Allowed the awkward reply", "description": "Did not treat a clumsy response as a failure." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a monthly coffee you have been having for a year. It has become the best hour of your month and you have never said so.",
    "partner": {
      "name": "Alex",
      "role": "a friend you have been meeting monthly for a year",
      "personality": "Receives warmth badly and gratefully — says something clumsy, goes slightly pink, and clearly means it. Follows any joke straight back to safety.",
      "mood": "Comfortable, about to leave.",
      "openness": 4
    },
    "opening_beat": "\"Right — same time next month, then.\"",
    "success_looks_like": "The user says the warm thing plainly and does not undercut it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply clumsily and warmly to anything sincere, and do not smooth it over.",
      "Take any joke as an exit and return to logistics immediately.",
      "Never say anything warm first."
    ]
  }$j$::jsonb,
  $md$Today, tell one person one specific thing you value about them, and do not undercut it. Log the sentence.$md$
),
(
  (select id from public.skills where slug = 'getting-past-pleasant'),
  5,
  'When it does not come back',
  $md$Sometimes you go one rung and nothing comes with you. It is worth knowing what that is and what it is not, because the two readings lead to very different places.

**The move:** treat an unmet rung as information about capacity, not about you.

The most common explanations have nothing to do with your worth as a friend. Some people have all the close friends they can maintain and are not looking for another — a completely reasonable position that nobody ever announces. Some are in a period where they have nothing spare. Some do not do this at any depth with anybody, including people they have known thirty years, and are perfectly happy.

None of that is visible from outside, and none of it is a verdict.

What it does mean is that this relationship is what it is, and that is allowed to be fine. A pleasant weekly conversation with somebody you like is a good thing to have. The mistake is not that it stayed pleasant — it is spending three more years assuming it is about to become something, and being quietly disappointed by a relationship that was never failing.

So calibrate rather than withdraw. Do not go cold, do not stop being warm, and do not decide they are a lesser friend. Simply stop investing at a level that is not being met, and put that effort where it is — which is a redirection rather than a punishment, and it is invisible to them.

And leave it open. People change. Somebody who had nothing spare in a bad year is a different person eighteen months later, and a rung that was not taken in March can be taken in the following March by exactly the same two people.

If you keep one thing: it is far better to find out at one rung than at four years. That is the whole point of going first.$md$,
  $j$[
    {
      "situation": "You offered something real and got warmth and nothing back.",
      "line": "(information about capacity, not about you)",
      "why": "Some people have all the close friends they can maintain, some have nothing spare this year, and some do not do this with anybody. None of it is visible from outside."
    },
    {
      "situation": "You are tempted to be a bit cooler with them now.",
      "line": "(calibrate, do not withdraw)",
      "why": "Stop investing at a level that is not met and put it where it is. That is a redirection rather than a punishment, and it is invisible to them."
    },
    {
      "situation": "It has stayed pleasant for another year.",
      "line": "(that is allowed to be a good thing)",
      "why": "The mistake is not that it stayed pleasant. It is three years of assuming it is about to become something else."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does an unmet rung usually mean?",
      "options": [
        { "text": "They do not like you as much as you thought.", "correct": false, "note": "The reading that produces the withdrawal, and it is contradicted by the fact that they keep turning up." },
        { "text": "You misjudged the timing.", "correct": false, "note": "Occasionally, and it implies a right moment exists that you could have found. Usually it is not about timing at all." },
        { "text": "Something about their capacity, which is invisible from outside.", "correct": true, "note": "All the close friends they can maintain, a year with nothing spare, or somebody who does not do this with anybody. None of it is a verdict." },
        { "text": "You went too far too fast.", "correct": false, "note": "Possible and checkable — one small rung is rarely too fast. If it was, the previous lesson covers it." }
      ],
      "explain": "Better to find out at one rung than at four years. That is what going first buys you."
    },
    {
      "prompt": "What is the right response?",
      "options": [
        { "text": "Try again with something bigger.", "correct": false, "note": "Climbing alone, which is what produces the overshare. A rung that was not met is not answered by a larger one." },
        { "text": "Accept the friendship as it is and stop investing above that level.", "correct": true, "note": "Calibration rather than withdrawal. Stay exactly as warm, put the effort where it is met, and leave the door open — people change." },
        { "text": "Be a bit cooler, so it is even.", "correct": false, "note": "A punishment for something that was never a slight, and it is visible in a way the calibration is not." },
        { "text": "Ask them directly whether they want to be closer.", "correct": false, "note": "It makes the relationship the subject of the relationship, and it puts somebody on the spot about something they may not have language for." }
      ],
      "explain": "Redirect the effort, keep the warmth, and leave it open."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_personal", "label": "Did not take it personally", "description": "Read it as capacity rather than as a verdict." },
      { "key": "no_withdrawal", "label": "Did not go cold", "description": "Stayed exactly as warm as before." },
      { "key": "redirected", "label": "Redirected the effort", "description": "Put the investment where it was being met." },
      { "key": "left_open", "label": "Left it open", "description": "Did not close the door on a later go." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You went one rung with somebody two weeks ago. They were kind about it, gave nothing back, and everything since has been exactly as pleasant as before.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to about it",
      "personality": "Asks what the relationship is actually like now, and pushes back on any plan that involves being cooler.",
      "mood": "Level.",
      "openness": 5
    },
    "opening_beat": "\"So they did not bite. What are you going to do about it?\"",
    "success_looks_like": "The user calibrates without withdrawing warmth or taking it personally.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Push back on any plan to cool off or to try again with something bigger.",
      "Accept a plan to keep it as it is and invest elsewhere.",
      "Never offer an explanation for the other person's behaviour."
    ]
  }$j$::jsonb,
  $md$Today, notice one relationship that is pleasant and not going deeper. Decide to enjoy it as it is. Log which.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('getting-past-pleasant', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You have talked to somebody every week for four years. You could not say what they are currently worried about, and they could not say it about you.",
      "prompt": "What is that?",
      "options": [
        { "text": "A friendship that has not had enough time.", "correct": false, "note": "Four years is the time. Nothing about waiting longer changes what has already been demonstrated." },
        { "text": "A stable arrangement neither of you has tried to change.", "correct": true, "note": "Nobody is bored, every conversation is fine, and the pleasant register has no natural exit. It sustains itself perfectly." },
        { "text": "Evidence they are a private person.", "correct": false, "note": "Usually neither of you is. It is symmetrical — they are doing exactly what you are doing." },
        { "text": "Normal for adult friendships.", "correct": false, "note": "Common, which is not the same as inevitable, and it is where most people's social life quietly is." }
      ]
    },
    {
      "situation": "You feel surrounded by people and still not known by any of them.",
      "prompt": "What does that call for?",
      "options": [
        { "text": "Meeting more people.", "correct": false, "note": "It adds more of the same relationship. This is a different kind of lonely from having nobody and it is not solved by volume." },
        { "text": "Accepting that adult friendship is shallower.", "correct": false, "note": "A resignation dressed as realism, and it is contradicted by anybody who has one close friend." },
        { "text": "Depth with the people you already see.", "correct": true, "note": "The infrastructure is already there — weekly contact, mutual liking. What has never happened is either of you moving from things to yourselves." },
        { "text": "Reconnecting with old friends who already know you.", "correct": false, "note": "Worth doing, and it is track five. It does not address the four people you see every week." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('getting-past-pleasant', 2, 'line', $j${
  "says": "Shocking out there again. They still have not fixed that drain.",
  "model": {
    "line": "It is grim. I will be honest, it has been a fairly hard few months generally, so the drain is not helping.",
    "why": "Small, true, said plainly and offered rather than extracted. It lowers the level without asking anybody's permission, and it takes four seconds."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say something about you" },
    { "kind": "no_question", "requirement": "Offer, do not ask — a question puts them on the spot" },
    { "kind": "forbids_any", "requirement": "Do not hide it in a joke or a hedge",
      "words": ["haha", "lol", "ignore me", "do not mind me", "being dramatic", "first world", "sorry to be", "cheesy", "too deep"] },
    { "kind": "min_words", "requirement": "A real thing, not a shrug", "n": 10 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('getting-past-pleasant', 3, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('getting-past-pleasant', 4, 'line', $j${
  "says": "Right — same time next month, then.",
  "model": {
    "line": "Yes. And honestly, these Tuesdays are the best thing in my month.",
    "why": "Specific rather than a title awarded, said plainly, and nothing after it. Almost nobody hears this, which is why eleven words get remembered for years."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not undercut it",
      "words": ["cheesy", "soppy", "sorry", "ignore that", "too much", "anyway", "God", "that was weird", "do not make it", "awkward"] },
    { "kind": "max_sentences", "requirement": "Say it and let it sit", "n": 2 },
    { "kind": "min_words", "requirement": "Name the specific thing", "n": 8 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('getting-past-pleasant', 5, 'line', $j${
  "says": "So they did not bite. What are you going to do about it?",
  "model": {
    "line": "Nothing, really — keep it as it is. It is a good weekly conversation and it does not have to be more than that.",
    "why": "Calibration rather than withdrawal. The relationship was never failing, and the mistake would be three more years of assuming it is about to become something else."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not withdraw, and do not take it personally",
      "words": ["back off", "cool off", "distance", "not worth", "waste", "my fault", "said too much", "embarrassed", "should not have"] },
    { "kind": "min_words", "requirement": "Say what you are actually going to do", "n": 10 },
    { "kind": "max_words", "requirement": "A decision, not a post-mortem", "n": 40 }
  ]
}$j$::jsonb);

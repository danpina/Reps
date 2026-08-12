-- Making friends, track 2: From acquaintance to something.
--
-- The move is the one this app has taught three times already — small,
-- specific, a day in it — and the difference here is entirely the
-- awkwardness. A date has a name and a shape; this has neither, which is why
-- naming it out loud is a whole lesson rather than a footnote.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'first-invitation'),
  1,
  'We should do something has never produced anything',
  $md$Almost everybody has three or four of these: somebody they genuinely get on with, have known for a year or two, and have never once seen outside the room they met them in.

Nothing has gone wrong. You like each other. You have both said *we should do something* and meant it every time. And it has not happened, because that sentence is a sentiment rather than a plan, and sentiments do not put anything in a diary.

**The move:** convert it into a specific thing with a day in it, or accept that it will not happen.

That is a harder sentence than it looks, because the comfortable belief is that these things develop naturally given enough time. They do not. Two years of pleasant contact in one context produces two years of pleasant contact in one context — that is what it has already demonstrated. Left alone, this arrangement is stable forever, and most people have several of them running simultaneously.

The reason it feels like it should resolve itself is that both of you keep signalling. *We should do something* is a real signal and it is meant sincerely, and because it is exchanged repeatedly, both of you have evidence that the other is willing. What neither of you has is a Thursday.

So the thing to notice is that willingness was never the missing ingredient. Nobody is waiting to be persuaded. Somebody is waiting to be asked, on a date, for a specific thing — and the asking is a piece of admin that has been mistaken for a social risk.

If you keep one thing: it will not develop on its own. Two years is already the experiment, and you have the result.$md$,
  $j$[
    {
      "situation": "You have said we should do something to each other four times over two years.",
      "line": "(that is the experiment, and you have the result)",
      "why": "Two years of pleasant contact in one context has produced exactly that. Left alone the arrangement is stable indefinitely."
    },
    {
      "situation": "You are waiting for a natural moment.",
      "line": "(there is not one coming)",
      "why": "Willingness was never missing — you both keep signalling it. What is missing is a Thursday."
    },
    {
      "situation": "It feels like a big social risk to ask.",
      "line": "(it is admin)",
      "why": "Nobody is waiting to be persuaded. Somebody is waiting to be asked for a specific thing on a specific day."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does we should do something never work?",
      "options": [
        { "text": "Neither of you means it.", "correct": false, "note": "Both of you mean it, which is exactly what makes the situation so stable and so frustrating." },
        { "text": "It is a sentiment, and sentiments do not put anything in a diary.", "correct": true, "note": "The only reply available is agreement, which both of you supply sincerely, and then nothing has been arranged." },
        { "text": "You are both too busy.", "correct": false, "note": "Both of you have Thursdays. Busy is what gets said afterwards rather than what prevented it." },
        { "text": "Neither of you wants to seem keen.", "correct": false, "note": "That is the next track's problem. This one fails earlier, on the sentence itself." }
      ],
      "explain": "Willingness was never the missing ingredient. A day was."
    },
    {
      "prompt": "What is the honest reading of two years of this?",
      "options": [
        { "text": "It is developing slowly.", "correct": false, "note": "It has developed as far as it develops. Two years of contact in one context has produced two years of contact in one context." },
        { "text": "They are not that interested.", "correct": false, "note": "They keep saying it too. Reading it as disinterest is the comfortable exit and it is contradicted by the evidence." },
        { "text": "The timing has not been right.", "correct": false, "note": "There have been roughly a hundred Thursdays. Timing has not been the constraint." },
        { "text": "Left alone, it is stable forever.", "correct": true, "note": "The arrangement is not en route to anything. Most people have several of these running at once, indefinitely." }
      ],
      "explain": "Nothing is wrong with it, and nothing is going to change unless somebody proposes a day."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "saw_it", "label": "Saw the stalemate", "description": "Recognised that it will not resolve on its own." },
      { "key": "no_waiting", "label": "Stopped waiting for a moment", "description": "Accepted that no natural opening is coming." },
      { "key": "admin", "label": "Treated it as admin", "description": "Stopped reading the ask as a large social risk." },
      { "key": "picked", "label": "Picked somebody", "description": "Named an actual person rather than the category." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The gym, the school gate, or the corridor — wherever it is you have been seeing this person for two years. They have just said it again.",
    "partner": {
      "name": "Alex",
      "role": "somebody you have got on with for two years and never seen outside this room",
      "personality": "Warm and genuinely willing, and will never propose anything. Says we should do something at least once per conversation and means it every time.",
      "mood": "Pleased to see you, as always.",
      "openness": 4
    },
    "opening_beat": "\"Ha — we say this every week. We should actually do something at some point.\"",
    "success_looks_like": "The user notices this will not resolve itself and moves towards a specific ask.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Agree enthusiastically with any vague suggestion and propose nothing.",
      "Say yes readily and concretely to anything with a day in it.",
      "Never suggest a specific plan yourself."
    ]
  }$j$::jsonb,
  $md$Today, name one person you have said we should do something to more than twice. Log who, and how long it has been.$md$
),
(
  (select id from public.skills where slug = 'first-invitation'),
  2,
  'Name the odd thing',
  $md$Asking somebody to be your friend feels more exposing than asking somebody on a date, and it is worth understanding why rather than pretending it is not true.

A date has a name, a shape and a script. Everybody involved knows what is being proposed, what it means, and what the answer would be to. This has none of that. There is no word for *would you like to be my friend* that an adult can say without sounding like a child, which is why almost nobody says anything and the whole category quietly does not happen.

**The move:** say that it is slightly odd, and then say the thing anyway.

*This is a slightly strange thing to say, but we always end up talking and I would happily do it somewhere that is not a corridor.* That sentence works, reliably, and it works because of the first clause rather than despite it. Naming the awkwardness removes it — the same move as the first ten minutes of a date, applied to a different fear.

What it does for them is more important than what it does for you. Almost everybody is in the same position, with their own list of people they get on with and never see, and nobody says it first. Being the one who says it out loud is close to a gift, and the usual reaction is not awkwardness but relief.

Two things to leave out. Do not over-explain — one clause of acknowledgement, then the proposal, and no paragraph about how you know this is weird. And do not make it about loneliness, yours or theirs; *I do not have many friends* is a true thing that puts weight on the other person and changes what is being offered.

The register that works is light and matter-of-fact, because that is what it actually is: an ordinary suggestion with one honest clause on the front.

If you keep one thing: say it is odd, then say it. The acknowledgement is what makes the rest ordinary.$md$,
  $j$[
    {
      "situation": "You want to propose something and there is no word for it.",
      "line": "This is a slightly strange thing to say, but we always talk and I would happily do it somewhere that is not a corridor.",
      "why": "The first clause is what makes the second one ordinary. Naming the awkwardness removes it, which is the same move as the opening of a date."
    },
    {
      "situation": "You are about to explain at length why this is not weird.",
      "line": "(one clause, then the proposal)",
      "why": "A paragraph of acknowledgement makes the oddness the subject. Say it once, lightly, and move."
    },
    {
      "situation": "You are tempted to explain that you do not have many friends.",
      "line": "(leave that out)",
      "why": "A true thing that puts weight on the other person and changes what is being offered from an invitation into a need."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is this harder than asking somebody on a date?",
      "options": [
        { "text": "There is no script for it.", "correct": true, "note": "A date has a name, a shape and a known answer. There is no adult phrase for would you like to be my friend, which is why almost nobody says anything." },
        { "text": "The rejection would be more personal.", "correct": false, "note": "It would arguably be less — a romantic no is about you specifically in a way this is not." },
        { "text": "You see them regularly, so it would be awkward afterwards.", "correct": false, "note": "A real consideration and much smaller in practice than it feels, because almost nobody minds being asked." },
        { "text": "It sounds needy.", "correct": false, "note": "Only if you make it about needing friends, which is one of the two things to leave out." }
      ],
      "explain": "No script is the whole difficulty. Which is why supplying one — naming it — does most of the work."
    },
    {
      "prompt": "What does naming the awkwardness actually do for them?",
      "options": [
        { "text": "It shows self-awareness.", "correct": false, "note": "How it reflects on you, which is not the useful half." },
        { "text": "It gives them an easy way to decline.", "correct": false, "note": "It does not particularly, and this is not a move about exits." },
        { "text": "It makes the whole thing lighter.", "correct": false, "note": "True and vague. Say what specifically happens on their side." },
        { "text": "They are almost certainly in the same position, and nobody goes first.", "correct": true, "note": "Most people have their own list of people they get on with and never see. The usual reaction is relief rather than awkwardness." }
      ],
      "explain": "Being the one who says it is close to a gift, because almost nobody does."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Named the oddness", "description": "Acknowledged it in one clause." },
      { "key": "then_asked", "label": "Then asked anyway", "description": "Followed the acknowledgement with an actual proposal." },
      { "key": "light", "label": "Kept it light", "description": "One clause, not a paragraph." },
      { "key": "no_need", "label": "Left the loneliness out", "description": "Offered something rather than describing a shortage." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a class you both go to. You have been talking every week for a year and have never seen each other anywhere else.",
    "partner": {
      "name": "Alex",
      "role": "somebody from the class you always talk to",
      "personality": "Warm and slightly relieved when anything real is said. Responds well to a light acknowledgement and stiffens at a long explanation.",
      "mood": "Packing up, unhurried.",
      "openness": 4
    },
    "opening_beat": "\"Same time next week then. Have a good one.\"",
    "success_looks_like": "The user names the oddness lightly and proposes something.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly and easily to a light acknowledgement followed by a proposal.",
      "Become slightly awkward if the user explains at length or mentions having no friends.",
      "Never propose anything yourself."
    ]
  }$j$::jsonb,
  $md$Today, say one true and slightly awkward thing out loud, prefaced by admitting it is slightly awkward. Log what happened.$md$
),
(
  (select id from public.skills where slug = 'first-invitation'),
  3,
  'Small, specific, a day in it',
  $md$You know this move. It is the fourth time this app has asked for it, and it is the same shape every time because it is the only shape that produces anything.

**The move:** something small, something specific, with a day in it.

*There is a decent coffee place two streets from here — Thursday?* An hour, one thing, one question, answerable in one word. Compare it with *we should get a coffee sometime*, which requires them to propose a day, check a diary and reply properly, and therefore receives *yes definitely* and nothing else for eight months.

Small matters more here than anywhere else in the app, and for a reason specific to friendship. There is no established level of intimacy between you, so a large proposal — a whole evening, dinner, a day out — asks for a step neither of you has taken and makes the yes expensive. An hour is nothing. Nobody has ever agonised over whether to agree to a coffee.

Pick something with a natural end, for the same reason a first date is a drink rather than dinner. A coffee, a lunch break, a walk, a pint after the thing you both already do. All of them finish by themselves, which means neither of you has to work out how to leave — and that removes the fear that actually stops people, which is not being rejected but being stuck.

Use what you already share. The thing you both do is the easiest possible bridge: *are you staying for one afterwards?* is barely an invitation at all, and it converts a room you already share into the first time you have seen each other outside it.

If you keep one thing: an hour, a place, a day. It is the same sentence you have already learned, and it works here for exactly the same reason.$md$,
  $j$[
    {
      "situation": "You want to propose something.",
      "line": "There is a decent coffee place two streets away — Thursday?",
      "why": "An hour, one thing, one question, answerable in one word. Nobody has ever agonised over whether to agree to a coffee."
    },
    {
      "situation": "You are thinking of suggesting dinner, to make it a proper thing.",
      "line": "(that asks for a step neither of you has taken)",
      "why": "There is no established level between you yet, so a big proposal makes the yes expensive. An hour is nothing."
    },
    {
      "situation": "You already do a thing together every week.",
      "line": "Are you staying for one afterwards?",
      "why": "Barely an invitation at all, and it converts a room you already share into the first time you have seen each other outside it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does small matter more here than on a date?",
      "options": [
        { "text": "Friendship is lower stakes.", "correct": false, "note": "It does not feel lower stakes to the person asking, which is why this whole track exists." },
        { "text": "There is no established level between you, so a big ask is expensive.", "correct": true, "note": "A whole evening asks for a step neither of you has taken. An hour asks for nothing anybody has to think about." },
        { "text": "People are busier with friends than with dates.", "correct": false, "note": "Diaries are diaries. The size of the proposal is what makes the yes cheap or expensive." },
        { "text": "It is less awkward if it goes badly.", "correct": false, "note": "A benefit and not the mechanism. The mechanism is about what is being agreed to." }
      ],
      "explain": "An hour, a place, a day. Nobody agonises over a coffee."
    },
    {
      "prompt": "Why choose something with a natural end?",
      "options": [
        { "text": "So it does not take up your whole evening.", "correct": false, "note": "Convenient and not the reason. Plenty of people would happily give an evening." },
        { "text": "So you can leave if it is awkward.", "correct": false, "note": "Close, and it frames it as an escape. The benefit arrives before anything happens." },
        { "text": "Because the fear is being stuck, not being rejected.", "correct": true, "note": "A coffee finishes by itself, so neither of you has to work out how to leave — which removes the thing that actually stops people proposing." },
        { "text": "Because short things are easier to arrange.", "correct": false, "note": "Marginally, and it is about the diary rather than about the fear." }
      ],
      "explain": "Same reason a first date is a drink. The situation ends it for you."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Named something specific", "description": "A place or an activity rather than a category." },
      { "key": "a_day", "label": "Put a day in it", "description": "Offered an actual day rather than sometime." },
      { "key": "small", "label": "Kept it to an hour", "description": "Proposed something nobody has to think about." },
      { "key": "natural_end", "label": "Chose something that ends itself", "description": "Picked a thing with a built-in finish." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of the class again. You have just said the slightly awkward thing and they have responded warmly.",
    "partner": {
      "name": "Alex",
      "role": "somebody from the class you always talk to",
      "personality": "Says yes immediately to anything with a day in it. Answers a vague suggestion with an equally vague agreement and starts leaving.",
      "mood": "Warm, packing up.",
      "openness": 4
    },
    "opening_beat": "\"Ha — yes, honestly, I would like that. We are terrible at this.\"",
    "success_looks_like": "The user proposes something small and specific with a day in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say yes concretely and warmly to anything with a day in it.",
      "Answer a vague suggestion with yeah, we definitely should, and start leaving.",
      "Never propose anything yourself."
    ]
  }$j$::jsonb,
  $md$Today, invite one person you already see to something with an hour, a place and a day in it. Log what you proposed.$md$
),
(
  (select id from public.skills where slug = 'first-invitation'),
  4,
  'Go through the group',
  $md$If the direct invitation is the hard version, here is the version that costs almost nothing, and it is the one most people overlook because it does not feel like doing anything.

**The move:** go to a thing other people are already going to.

Joining something already happening is the lowest-stakes invitation there is, because nobody has to decide anything about you. There is no proposal, no yes, no risk that a specific person has to weigh up whether they want an hour alone with you. You are simply there, which is the entire mechanism, and it produces exactly the repeated low-stakes contact this whole topic is built on.

Say yes to things you would normally decline. The colleague's birthday drinks, the leaving do, the five-a-side that needs a body, the friend's thing where you will only know one person. Every one of them is an hour in a room with people you would otherwise never accumulate time with — and accumulating time is the input.

Ask to be brought along. *Can I come to that?* is a completely ordinary sentence that quiet people almost never say, and the answer is nearly always yes said with some enthusiasm, because the person you are asking is being told their thing sounds good.

And this is where friends of friends live, which is the highest-yield source in the topic. Shared context, an easy setting, and somebody who has effectively vouched for both of you — plus no explanation required for why you are there, which is the awkward part removed before it arrives.

The one thing that stops it working: leaving early and talking mostly to the person you came with. That converts the whole evening into a private conversation held in a crowded room, and produces nothing. Arrive with them and then do not stay attached to them.

If you keep one thing: say yes, and ask to be brought along. It is the cheapest thing in this topic and almost nobody does it.$md$,
  $j$[
    {
      "situation": "A colleague mentions their birthday drinks on Friday.",
      "line": "Can I come to that?",
      "why": "A completely ordinary sentence that quiet people almost never say, and the answer is nearly always an enthusiastic yes."
    },
    {
      "situation": "You would only know one person there.",
      "line": "(that is the point — go)",
      "why": "An hour in a room with people you would otherwise never accumulate time with. Accumulating time is the input."
    },
    {
      "situation": "You are at the thing, standing with the person you arrived with.",
      "line": "(do not stay attached)",
      "why": "It converts the evening into a private conversation held in a crowded room, which produces nothing at all."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is joining a group easier than a direct invitation?",
      "options": [
        { "text": "There are more people to talk to.", "correct": false, "note": "More people is not the benefit — it is often the daunting part. The benefit is structural." },
        { "text": "Nobody has to decide anything about you.", "correct": true, "note": "No proposal, no yes, and no specific person weighing up whether they want an hour alone with you. You are simply there." },
        { "text": "You can leave whenever you like.", "correct": false, "note": "True and available in most settings. It is not what makes this cheap." },
        { "text": "It is less obvious what you are doing.", "correct": false, "note": "Framing it as concealment. There is nothing to conceal — going to a thing is just going to a thing." }
      ],
      "explain": "Say yes, and ask to be brought along. The cheapest move in the topic."
    },
    {
      "prompt": "What stops it working?",
      "options": [
        { "text": "Not knowing enough people there.", "correct": false, "note": "Knowing nobody is fine and normal — that is what the shared context is for." },
        { "text": "Having nothing to say.", "correct": false, "note": "Small talk covers this, and in a group there is always something in the room to remark on." },
        { "text": "Staying attached to whoever you arrived with.", "correct": true, "note": "It turns the evening into a private conversation held in a crowded room, and produces nothing." },
        { "text": "Being the odd one out.", "correct": false, "note": "You are new rather than odd, and new is a temporary and entirely ordinary state at any gathering." }
      ],
      "explain": "Arrive with them, then do not stay with them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_yes", "label": "Said yes to something", "description": "Accepted a thing they would normally decline." },
      { "key": "asked_along", "label": "Asked to be brought along", "description": "Said can I come to that." },
      { "key": "detached", "label": "Did not stay attached", "description": "Talked to people beyond whoever they arrived with." },
      { "key": "stayed", "label": "Stayed long enough", "description": "Did not leave before anything had accumulated." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A colleague you like but do not know well is talking about their birthday drinks on Friday, which you have not been invited to and which is not exclusive.",
    "partner": {
      "name": "Priya",
      "role": "a colleague talking about their weekend",
      "personality": "Delighted when somebody asks to come, and will not think to invite anybody who has not asked.",
      "mood": "Cheerful, mid-anecdote.",
      "openness": 4
    },
    "opening_beat": "\"...so it is just a few of us at the place by the station on Friday. Should be good.\"",
    "success_looks_like": "The user asks to come along.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond with genuine pleasure to anybody asking to come.",
      "Never invite the user yourself — it does not occur to you.",
      "Move the conversation on if nothing is asked."
    ]
  }$j$::jsonb,
  $md$Today, ask to come to one thing you were not specifically invited to, or say yes to one you would normally decline. Log which.$md$
),
(
  (select id from public.skills where slug = 'first-invitation'),
  5,
  'When nothing comes back',
  $md$You asked, and you got a vague yes and no follow-through, or nothing at all. This is the point where most people stop for good, and the reading they take from it is usually wrong.

**The move:** ask once more, differently, and then let it go without a verdict.

The second attempt matters because the most common cause of a non-answer is not disinterest. It is a message read at a bus stop, meant to be answered properly later, and then buried. That happens constantly, to everybody, and it produces exactly the same silence that disinterest produces — which is why one attempt is not enough evidence to conclude anything.

Differently means with a specific day attached, if the first one did not have it. A surprising number of first attempts are the sentiment version, and the follow-up is the first real proposal you have made. *Are you around Thursday or Friday?* is a different message from *we should get that coffee.*

Then let it go. Not with a diagnosis about yourself and not with a diagnosis about them — some people have a full life, some are in a bad year, some are simply not organised, and none of that is available to you from outside. Two unanswered proposals is a no for now, delivered by circumstances rather than by anybody.

And stay exactly as warm as you were. This is the part with an actual cost: you will see this person again, and cooling towards somebody because they did not take up an invitation is both visible and unfair. Nothing was owed. You proposed something, which is a good thing to have done regardless of the outcome.

The reframe worth keeping: an unanswered invitation cost you one message. Under-inviting costs you every friendship you did not start, silently, for years — and nobody who over-invites has ever been thought badly of for it.

If you keep one thing: two attempts, then let it be, and do not go cold. The cost of asking was one message.$md$,
  $j$[
    {
      "situation": "You proposed something and got a vague yes and then nothing.",
      "line": "(ask once more, with a day in it)",
      "why": "The commonest cause is a message read at a bus stop and buried, not disinterest — and the first attempt often had no day in it anyway."
    },
    {
      "situation": "Two attempts, nothing back.",
      "line": "(that is a no for now, and it is nobody's fault)",
      "why": "Some people have a full life, some are in a bad year, some are not organised. None of it is available to you from outside."
    },
    {
      "situation": "You see them next week and feel a bit cool towards them.",
      "line": "(nothing was owed)",
      "why": "Cooling towards somebody for not taking up an invitation is visible and unfair. You proposed something, which was a good thing to have done."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is one non-answer not evidence?",
      "options": [
        { "text": "People are polite and do not like to refuse.", "correct": false, "note": "Sometimes, and a soft no usually still contains words. This silence often contains nothing at all." },
        { "text": "Because a buried message produces the same silence as disinterest.", "correct": true, "note": "Read at a bus stop, meant to be answered properly later, and then gone. It happens to everybody constantly and looks identical from outside." },
        { "text": "Because they may not have seen it.", "correct": false, "note": "Rarer than people hope. Seen and buried is the common case, and it is not the same as not interested." },
        { "text": "Because you should never take a first no seriously.", "correct": false, "note": "The opposite of what this app teaches everywhere else. A stated no is a no — this lesson is about the absence of one." }
      ],
      "explain": "Two attempts, the second with a day in it. Then let it be."
    },
    {
      "prompt": "What is the asymmetry worth remembering?",
      "options": [
        { "text": "They lost more than you did.", "correct": false, "note": "Scorekeeping, and it is a way of being hurt with extra steps." },
        { "text": "Asking costs one message; not asking costs friendships you never started.", "correct": true, "note": "And nobody who over-invites has ever been thought badly of for it, whereas under-inviting is invisible and cumulative." },
        { "text": "You can always ask again in a year.", "correct": false, "note": "You can, and that is a fine thing to do rather than the thing that makes this decidable." },
        { "text": "There are plenty of other people.", "correct": false, "note": "True and beside the point, and it slightly misses that this person may still come good later." }
      ],
      "explain": "One message. That was the whole exposure."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_twice", "label": "Asked a second time", "description": "Did not treat one silence as an answer." },
      { "key": "with_a_day", "label": "Made the second one specific", "description": "Attached a day if the first had none." },
      { "key": "let_go", "label": "Let it go after two", "description": "Stopped without a diagnosis of anybody." },
      { "key": "stayed_warm", "label": "Stayed as warm as before", "description": "Did not cool towards them afterwards." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ten days ago you suggested a coffee. You got a warm yes and no follow-up, and you are seeing them tomorrow at the usual thing.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are messaging about it",
      "personality": "Asks what the first message actually said, and whether it had a day in it. Unsentimental and kind.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"So they never replied properly. What did you actually send?\"",
    "success_looks_like": "The user plans a second, more specific attempt rather than concluding anything.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask whether the first message had an actual day in it.",
      "Push back gently on any conclusion drawn from a single silence.",
      "Never tell the user what to send."
    ]
  }$j$::jsonb,
  $md$Today, send one second invitation to somebody who never answered the first. Put a day in it. Log what you sent.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('first-invitation', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Two years of getting on with somebody at the gym. You have both said we should do something at least four times.",
      "prompt": "What is the honest reading?",
      "options": [
        { "text": "It is heading somewhere slowly.", "correct": false, "note": "It has arrived where it goes. Two years of contact in one context has produced two years of contact in one context." },
        { "text": "Left alone, this is stable forever.", "correct": true, "note": "The arrangement is not en route to anything. Most people have several running simultaneously, indefinitely." },
        { "text": "They would have suggested something if they wanted to.", "correct": false, "note": "They keep suggesting something — that is what we should do something is. What neither of you has produced is a Thursday." },
        { "text": "The timing has not worked out.", "correct": false, "note": "There have been about a hundred Thursdays. Timing was never the constraint." }
      ]
    },
    {
      "situation": "You decide to do something about it, and it immediately feels like a big move.",
      "prompt": "What are you actually about to do?",
      "options": [
        { "text": "Take a real social risk.", "correct": false, "note": "The framing that stops people. Nobody is being asked to decide whether they like you — they have been saying so for two years." },
        { "text": "Change the nature of the relationship.", "correct": false, "note": "You are proposing an hour. The nature of it changes later and by itself, if at all." },
        { "text": "Find out whether they actually like you.", "correct": false, "note": "You know they do. Willingness was never the missing ingredient here." },
        { "text": "A piece of admin.", "correct": true, "note": "Somebody is waiting to be asked for a specific thing on a specific day. That is the whole of it, and it has been mistaken for a risk." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-invitation', 2, 'line', $j${
  "says": "Same time next week then. Have a good one.",
  "model": {
    "line": "This is a slightly odd thing to say, but we always end up talking and I would happily do it somewhere that is not a car park.",
    "why": "One clause of acknowledgement, then the actual thing. Naming the awkwardness is what makes the rest ordinary, and most people are relieved somebody said it first."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name that it is a slightly odd thing to say",
      "words": ["odd", "strange", "weird", "random", "out of nowhere", "awkward"] },
    { "kind": "forbids_any", "requirement": "Do not make it about needing friends",
      "words": ["no friends", "not many friends", "lonely", "nobody to", "on my own a lot", "sad", "pathetic"] },
    { "kind": "max_words", "requirement": "One clause, then the point", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-invitation', 3, 'line', $j${
  "says": "Ha — yes, honestly, I would like that. We are terrible at this.",
  "model": {
    "line": "Then there is a decent coffee place two streets from here — Thursday, after this?",
    "why": "An hour, a place, a day, answerable in one word. Small enough that nobody has to weigh it up, and it ends by itself."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Make it answerable" },
    { "kind": "contains_any", "requirement": "Put a day in it",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "tomorrow", "next week", "weekend", "after this"] },
    { "kind": "forbids_any", "requirement": "A plan, not a sentiment",
      "words": ["sometime", "some time", "at some point", "we should", "one of these days", "sort something", "in the diary"] },
    { "kind": "max_words", "requirement": "One sentence", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-invitation', 4, 'choice', $j${
  "beats": [
    {
      "situation": "\"...so it is just a few of us at the place by the station on Friday.\" You have not been invited and it is not exclusive.",
      "prompt": "What do you say?",
      "options": [
        { "text": "Nothing — you would be gatecrashing.", "correct": false, "note": "It is not exclusive and they have mentioned it to you. Not asking is how quiet people miss the cheapest thing in this topic." },
        { "text": "That sounds good — hope it goes well.", "correct": false, "note": "Warm, and it closes the subject. You have responded to the invitation-shaped thing without taking it." },
        { "text": "Can I come to that?", "correct": true, "note": "A completely ordinary sentence quiet people almost never say. The answer is nearly always an enthusiastic yes, because you have just told somebody their thing sounds good." },
        { "text": "Wait to see whether they invite you.", "correct": false, "note": "It will not occur to them. Most people invite whoever asks and never think about who did not." }
      ]
    },
    {
      "situation": "You are at the thing. You know one person and you have been standing with them for forty minutes.",
      "prompt": "What is the problem?",
      "options": [
        { "text": "Nothing — you came and you stayed, which was the goal.", "correct": false, "note": "Being there is necessary and not sufficient. Forty minutes in a private conversation is forty minutes with the room, not in it." },
        { "text": "You should have talked to more people by now.", "correct": false, "note": "Right instinct, phrased as a performance target. The specific issue is what standing there is doing." },
        { "text": "You are having a private conversation in a crowded room.", "correct": true, "note": "It produces nothing, and it is the single commonest way a group invitation gets wasted. Arrive with them, then do not stay attached." },
        { "text": "They will think you are relying on them.", "correct": false, "note": "They almost certainly do not mind. The cost is to you rather than to them." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-invitation', 5, 'line', $j${
  "says": "So they never replied properly. What did you actually send?",
  "model": {
    "line": "Just that we should get that coffee. So I am going to send a proper one — are you around Thursday or Friday?",
    "why": "Notices that the first attempt was the sentiment version, which means the second is really the first proposal. One silence is not evidence of anything."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "One silence is not a verdict",
      "words": ["not interested", "clearly does not", "take the hint", "leave it", "my fault", "should not have", "embarrassing", "learnt my lesson"] },
    { "kind": "contains_any", "requirement": "Make the second attempt specific",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "next week", "weekend", "around"] },
    { "kind": "min_words", "requirement": "Say what you are going to send", "n": 10 }
  ]
}$j$::jsonb);

-- Work, track 2: Your manager.
--
-- The five lessons are the five things the relationship is actually made of,
-- in the order they become available: have the meeting, shape it, disagree
-- inside it, decline inside it, and bring bad news to it early.
--
-- Lesson one is the highest-return sentence in the topic and the one nobody
-- thinks to say, which is why it leads. Disagreeing is the scene, because it
-- is the only one here that depends on what comes back — you cannot rehearse
-- holding a position once and then letting it go against a beat that does not
-- push.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'your-manager'),
  1,
  'Ask for the half hour',
  $md$A great many people have no regular time with their manager and have never asked for any, and the reason is almost always the same: asking looks like it needs a justification, and nothing is wrong.

It does not need one. *Could we do a regular half hour, every couple of weeks?* is a request managers say yes to almost without exception, and it is probably the highest-return sentence in this entire topic. A manager hears it as somebody who wants to be managed well, which is a small gift in a week that mostly contains problems.

**The move:** ask for the time, name the rhythm, and do not build a case for being allowed to talk.

The rhythm is the part people leave out, and it is the part that matters. A one-off chat has to be justified every time it happens; a standing slot is justified once and then simply exists, which means the thing you were dreading raising in three months already has a place to go.

If it is a one-off — you want a specific conversation — the same shape works. Name the subject, name the length, and stop. *Could I get twenty minutes this week about the reporting work?* is complete. What turns it into a problem is the disguise: *if you have a moment at some point, no rush, it is nothing urgent* invites a no by supplying four ways to give one.

And the fear worth naming, because it stops people: *they will think something is wrong.* They will ask, once, and *nothing is wrong — I would just rather not save things up* is the whole answer. Nobody has ever been thought less of for wanting a regular half hour.

If you keep one thing: ask for a rhythm, not a favour. Asked once, it never has to be asked again.$md$,
  $j$[
    {
      "situation": "You have no standing one-to-one and have never asked for one.",
      "line": "Could we do a regular half hour, every couple of weeks?",
      "why": "Names the thing and the rhythm, and asks for nothing else. Managers say yes to this almost without exception, and they hear somebody who wants to be managed well."
    },
    {
      "situation": "You want one specific conversation about the reporting work.",
      "line": "Could I get twenty minutes this week about the reporting?",
      "why": "Subject, length, stop. It is a complete request and there is nothing in it to negotiate."
    },
    {
      "situation": "You are about to write if you have a moment at some point, no rush.",
      "line": "(that is four ways to say no, offered up front)",
      "why": "The disguise is what turns an easy yes into something they have to get round to. Ask plainly and it is answered plainly."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why ask for a rhythm rather than a chat?",
      "options": [
        { "text": "It shows commitment.", "correct": false, "note": "Impression management. The value is structural rather than about how it reflects on you." },
        { "text": "A standing slot is justified once, then simply exists.", "correct": true, "note": "A one-off has to be justified every time. A rhythm means the thing you are dreading raising in three months already has somewhere to go." },
        { "text": "Managers prefer regular meetings.", "correct": false, "note": "Some do and some do not. The benefit here is yours, and it holds either way." },
        { "text": "It gets you more of their time overall.", "correct": false, "note": "Usually true and not the point. Predictable beats plentiful." }
      ],
      "explain": "Ask once for a rhythm and you never have to ask again."
    },
    {
      "prompt": "What is wrong with if you have a moment at some point, no rush?",
      "options": [
        { "text": "It is too informal.", "correct": false, "note": "Informal is fine and often right. The register is not the problem." },
        { "text": "It does not say what you want to discuss.", "correct": false, "note": "A real gap, and a smaller one. You can be vague about the subject and still get the meeting." },
        { "text": "It sounds unsure of yourself.", "correct": false, "note": "How it sounds is the least of it. What it does is more concrete than that." },
        { "text": "It supplies four different ways to say no.", "correct": true, "note": "Every hedge is an exit you handed over. An easy yes becomes something they will get round to, and then do not." }
      ],
      "explain": "Name it, name the length, and stop. The hedges are doing the opposite of what they feel like."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Actually asked", "description": "Made the request rather than hinting at it." },
      { "key": "rhythm", "label": "Named a rhythm or a length", "description": "Asked for something specific rather than for time in general." },
      { "key": "no_justification", "label": "Did not justify it", "description": "Skipped building a case for being allowed to talk." },
      { "key": "no_exits", "label": "Left no easy exits", "description": "Avoided stacking hedges that invite a no." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The kitchen at work. Your manager is making coffee and you have been meaning to ask about a regular catch-up for about four months.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Busy and perfectly approachable. Says yes immediately to a clear request and vaguely to a hedged one, then forgets it.",
      "mood": "Between meetings, not in a hurry for the next thirty seconds.",
      "openness": 4
    },
    "opening_beat": "\"Oh — hello. All good with the project?\"",
    "success_looks_like": "The user asks for a regular slot plainly, without justifying it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say yes warmly and concretely to any clear request with a rhythm or a length in it.",
      "Respond to a hedged or disguised request with a vague yes and move on.",
      "Never offer a meeting yourself."
    ]
  }$j$::jsonb,
  $md$Today, ask one person for a regular slot or a specific length of their time, with no justification attached. Log what you asked for.$md$
),
(
  (select id from public.skills where slug = 'your-manager'),
  2,
  'Bring one thing you want',
  $md$The commonest way to waste a one-to-one is to spend it on status, and it does not feel like waste while it is happening. It feels productive. You arrive, you report, they nod, everybody leaves satisfied, and nothing happened.

Status is what writing is for. It can be read in ninety seconds at a time that suits them, and it does not need anybody's face. Spending a scheduled half hour reciting it burns the only slot in the week where you have one person's whole attention — which is a genuinely scarce thing and the only reason the meeting is worth having.

**The move:** arrive with one thing you actually want from them.

A decision you need made. An introduction. A view on something you are stuck between. Cover for a call you are about to make. Permission to stop doing something. Any of those uses what a manager has and you do not, which is the entire point of the relationship.

One, not four. Four things means the first gets twenty-five minutes and the rest get *let us pick that up next time*, and next time has its own four. Bringing one thing feels like under-using the meeting and is the opposite: it is the only way anything reliably comes out of it.

Say it at the start. The instinct is to work up to the ask through the status, which means the ask lands at minute twenty-eight with somebody already looking at their next meeting. Put it first and the rest of the half hour can be spent on it.

If you have genuinely nothing you want, that is worth noticing rather than filling. Bring a question about direction instead — where they think the work is heading — because a half hour spent on that is still better spent than a half hour spent proving you have been busy.

If you keep one thing: send the status, and use the meeting for the thing writing cannot do.$md$,
  $j$[
    {
      "situation": "You have a one-to-one tomorrow and a list of six updates.",
      "line": "(send the six, bring one thing you want)",
      "why": "Status can be read in ninety seconds at a time that suits them. The meeting is the only slot with their whole attention, and updates do not need attention."
    },
    {
      "situation": "You have four things you would like from them.",
      "line": "(pick the one)",
      "why": "Four means the first gets twenty-five minutes and the rest get picked up next time. Next time will have its own four."
    },
    {
      "situation": "You are planning to work up to the ask through the update.",
      "line": "(put it first)",
      "why": "Worked up to, it arrives at minute twenty-eight with somebody already thinking about their next meeting. Put first, it gets the half hour."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a one-to-one spent on status wasted?",
      "options": [
        { "text": "Your manager already knows most of it.", "correct": false, "note": "Often they do not, which is why it feels necessary. The problem is the medium rather than the content." },
        { "text": "It uses their whole attention on something that did not need it.", "correct": true, "note": "Attention is the scarce thing in the room and the only reason the meeting beats a message. Status can be read in ninety seconds at a time that suits them." },
        { "text": "It makes you look like you need supervision.", "correct": false, "note": "It does not, and worrying about that is what produces the polished update in the first place." },
        { "text": "It takes too long.", "correct": false, "note": "Length is not the issue. A five-minute status in a meeting is still the wrong thing in the wrong container." }
      ],
      "explain": "Send the status. Use the meeting for the thing writing cannot do."
    },
    {
      "prompt": "You have four things you want from them. What do you bring?",
      "options": [
        { "text": "All four, quickly, so none are lost.", "correct": false, "note": "The first gets twenty-five minutes and the other three get picked up next time, which has its own four." },
        { "text": "The two most important.", "correct": false, "note": "Better, and it still splits the half hour. Two asks is one ask with a queue behind it." },
        { "text": "One.", "correct": true, "note": "It feels like under-using the meeting and it is the only way something reliably comes out of it." },
        { "text": "Whichever they are most likely to say yes to.", "correct": false, "note": "That optimises for a yes rather than for the thing you need, and the easy yes is rarely the one worth their attention." }
      ],
      "explain": "One thing, said at the start. Everything else is a message."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_thing", "label": "Brought one thing", "description": "Arrived with a single ask rather than a list." },
      { "key": "a_want", "label": "It was something they wanted", "description": "A decision, an introduction, a view, or cover — not an update." },
      { "key": "first", "label": "Said it early", "description": "Led with the ask rather than working up to it." },
      { "key": "status_elsewhere", "label": "Put the status in writing", "description": "Did not spend the attention on what could be read." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your fortnightly half hour. You are blocked on a decision about the reporting work that only your manager can make, and you also have six updates.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Attentive at the start and increasingly distracted as the half hour goes on. Makes decisions readily when actually asked for one.",
      "mood": "Present, with a meeting after this one.",
      "openness": 4
    },
    "opening_beat": "\"Right — half an hour. What have you got?\"",
    "success_looks_like": "The user leads with the thing they want rather than with the update.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Listen politely to a status update and get visibly shorter as it goes on.",
      "Engage fully and decide when asked directly for a decision.",
      "Never ask the user whether they need anything."
    ]
  }$j$::jsonb,
  $md$Today, go into one meeting with a single thing you want from it, and say it first. Log what you asked for and what happened.$md$
),
(
  (select id from public.skills where slug = 'your-manager'),
  3,
  'Disagree once, in private',
  $md$Your manager has decided something and you think it is wrong. The choice appears to be objecting in front of everybody or saying nothing, and quiet people pick the second almost every time and then carry the decision around for weeks.

There is a third option, and it is the one senior people actually use.

**The move:** disagree once, in private, plainly — then commit in public whichever way it goes.

Every part of that is doing work. *Once*, because the second time is no longer disagreement, it is a campaign, and it converts a reasonable point into a problem with you. *In private*, because a disagreement in the room asks other people to take sides, which raises the cost for your manager and makes it about status rather than about the decision. *Plainly*, because a disagreement wrapped in enough softening to be deniable will be received as a mild concern and filed as nothing.

The last part is what makes the rest of it safe, and it is the part people leave out: say up front that you will back it either way. *I think we are wrong about this, and here is why — and if you still want to go that way I will get behind it properly.* That sentence costs you nothing, because you were going to have to live with the decision regardless, and it buys you the right to say the first half without it reading as a threat to co-operate.

Argue the decision, not the person and not the process. *I think the timeline is the risk* is a position. *I do not think anybody has really thought this through* is an accusation with a position hidden inside it, and only one of them gets answered.

And it does not make you difficult. Somebody who argues privately and supports publicly gets asked their opinion more, not less, because their opinion is safe to ask for.

If you keep one thing: say the disagreement and the commitment in the same breath. The second half is what lets you say the first.$md$,
  $j$[
    {
      "situation": "They have decided to cut the testing week and you think it is a mistake.",
      "line": "I think we are wrong about this, and if you still want to go that way I will get behind it properly.",
      "why": "The commitment is what makes the disagreement safe to say. It costs nothing — you were going to live with the decision anyway — and it stops the objection reading as a threat to co-operate."
    },
    {
      "situation": "You are about to say it in the team meeting.",
      "line": "(privately — the room makes it about status)",
      "why": "A disagreement in front of people asks everybody to take sides and raises the cost for your manager. Same point, much more expensive room."
    },
    {
      "situation": "You have made the point and they have decided anyway.",
      "line": "(that was the once)",
      "why": "A second attempt is a campaign, not a disagreement, and it converts a reasonable point into a problem with you."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does saying I will back it either way actually buy you?",
      "options": [
        { "text": "The right to say the disagreement plainly.", "correct": true, "note": "Without it, a strong objection reads as a threat to co-operate. With it, you can be as direct as you like, and it costs you nothing you were not going to do anyway." },
        { "text": "It softens the disagreement.", "correct": false, "note": "It does not soften the point at all — it lets you sharpen it. Softening is what makes an objection get filed as a mild concern." },
        { "text": "It shows you are a team player.", "correct": false, "note": "A by-product. Framing it that way turns a practical move into a performance." },
        { "text": "It leaves you room to say I told you so.", "correct": false, "note": "That is the opposite of committing, and it is what makes somebody expensive to disagree with." }
      ],
      "explain": "Disagreement and commitment in one breath. The second half is what licenses the first."
    },
    {
      "prompt": "Why once, and only once?",
      "options": [
        { "text": "Because they have heard you.", "correct": false, "note": "True and it is not the reason. Being heard would not by itself rule out saying it again." },
        { "text": "Because repeating it is rude.", "correct": false, "note": "Manners are not the mechanism. Plenty of repetition is polite and still costly." },
        { "text": "Because you might be wrong.", "correct": false, "note": "You might, and that is an argument for saying it once rather than for saying it never." },
        { "text": "Because the second time is a campaign, not a disagreement.", "correct": true, "note": "It converts a reasonable point into a problem with you, and the thing being judged stops being the decision." }
      ],
      "explain": "Once, privately, plainly. Then it is their decision and you are behind it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Actually disagreed", "description": "Stated the position rather than gesturing at a concern." },
      { "key": "plainly", "label": "Said it plainly", "description": "Did not soften it into something deniable." },
      { "key": "committed", "label": "Committed either way", "description": "Made clear they would back the decision whichever way it went." },
      { "key": "the_decision", "label": "Argued the decision", "description": "Kept it off the person and off the process." },
      { "key": "once", "label": "Said it once", "description": "Did not re-open it after the decision held." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A private call with your manager, the day after they announced that the testing week is being cut to hit the launch date. You think it is the wrong call.",
    "partner": {
      "name": "Rae",
      "role": "your manager, who has just made a decision you disagree with",
      "personality": "Reasonable and under pressure from above. Defends the decision once, listens properly to a plain argument, and becomes guarded if the point is made a second time after it has been settled.",
      "mood": "Committed to the date, aware it is tight.",
      "openness": 4
    },
    "opening_beat": "\"You wanted a few minutes? If it is about the testing week, I know, but the date is not moving.\"",
    "success_looks_like": "The user disagrees plainly, once, and makes clear they will back the decision either way.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Defend the decision at least once before conceding anything.",
      "Take a plain, committed disagreement seriously and think about it out loud.",
      "Become noticeably guarded if the user re-opens it after you have settled it.",
      "Never change your mind entirely — at most, agree to look at one part of it."
    ]
  }$j$::jsonb,
  $md$Today, disagree with one decision in private, and say in the same breath that you will back it either way. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'your-manager'),
  4,
  'Say no with a trade',
  $md$Almost every unreasonable workload survives because nobody made the trade visible.

The work arrives one piece at a time, each piece is individually reasonable, and each yes is easier than the conversation a no would require. Then at some point the total is impossible, and by then it looks like a personal capacity problem rather than a series of decisions somebody made.

**The move:** do not refuse. Make the trade explicit.

*I can, if something moves — the migration or the reporting. Which would you rather I dropped?* That is not a no. It is a yes with the arithmetic attached, and it changes the conversation from your willingness — where you will always lose, because you are willing — to their priorities, which is where it belonged and where they are far better equipped to decide than you are.

It also removes the thing you were dreading. A refusal invites a negotiation about you: whether you are stretched, whether you should be, whether other people manage. A trade invites a decision about work, and most managers make it in about four seconds and think no worse of anybody.

Three things to leave out. *Sorry* — there is nothing to apologise for in a scheduling fact. *I will try* — which is a yes wearing a hedge, and the hedge will not be remembered when it lands late. And the silent version, where you take it, absorb it, and let the cost show up later as a missed date somebody else finds out about.

If they say everything has to happen, that is information rather than a defeat, and it is worth having in writing. *Understood — I will do them in this order, so the reporting will land Thursday rather than Tuesday* is not defiance. It is a plan, and it puts the consequence where the decision was made.

If you keep one thing: never say no, and never say yes on its own. Say what it costs and let them choose.$md$,
  $j$[
    {
      "situation": "\"Can you pick up the Henderson report as well?\"",
      "line": "I can, if something moves — the migration or the reporting. Which would you rather I dropped?",
      "why": "A yes with the arithmetic attached. It moves the question from your willingness, where you always lose, to their priorities, where they are better placed to decide."
    },
    {
      "situation": "You are about to say you will try to fit it in.",
      "line": "(that is a yes wearing a hedge)",
      "why": "The hedge will not be remembered when it lands late. Only the yes will."
    },
    {
      "situation": "They say all of it has to happen.",
      "line": "Understood — then the reporting lands Thursday rather than Tuesday.",
      "why": "Not defiance, a plan. It puts the consequence back where the decision was made, and it is worth having in writing."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a trade easier than a refusal?",
      "options": [
        { "text": "It is more polite.", "correct": false, "note": "Politeness is not what is doing the work, and a plain no can be perfectly polite." },
        { "text": "It makes a decision about work instead of about you.", "correct": true, "note": "A refusal invites a negotiation about whether you are stretched and whether you should be. A trade is answered in about four seconds." },
        { "text": "It is harder to argue with.", "correct": false, "note": "It is, and that is a consequence of the reframe rather than the reason it works." },
        { "text": "It sounds more willing.", "correct": false, "note": "You are willing — that was never in question, and it is exactly why the willingness conversation goes badly for you." }
      ],
      "explain": "You will lose an argument about your willingness. You will not lose one about arithmetic."
    },
    {
      "prompt": "They say everything still has to happen. What now?",
      "options": [
        { "text": "Take it and absorb the cost.", "correct": false, "note": "The cost shows up later as a missed date somebody else discovers, which is the worst version of it." },
        { "text": "Push back a second time.", "correct": false, "note": "You made the trade visible and they chose. The second attempt is about you again." },
        { "text": "Escalate to their manager.", "correct": false, "note": "An enormous instrument for an ordinary prioritisation call, and it spends something you will want later." },
        { "text": "Name the order and the consequence, in writing.", "correct": true, "note": "Not defiance, a plan. It puts the consequence back where the decision was actually made." }
      ],
      "explain": "If everything has to happen, say what order it happens in and what that costs."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "trade", "label": "Made the trade visible", "description": "Named what would have to move." },
      { "key": "no_apology", "label": "Did not apologise", "description": "Treated it as a scheduling fact rather than a personal failing." },
      { "key": "no_hedge", "label": "Did not say they would try", "description": "Avoided a yes wearing a hedge." },
      { "key": "let_them_choose", "label": "Let them decide", "description": "Handed the priority call to the person whose call it is." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A message from your manager on a Tuesday. You are already carrying the migration and the reporting work, both with dates on them.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Reasonable and slightly overloaded. Accepts a trade immediately and makes the call; hears a hedged yes as a plain yes and moves on.",
      "mood": "Firefighting, not unkind.",
      "openness": 4
    },
    "opening_beat": "\"Can you pick up the Henderson report as well? Should not be too much on top of what you have.\"",
    "success_looks_like": "The user says yes with the trade attached rather than refusing or hedging.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Make the priority call readily and without complaint when given a trade.",
      "Treat I will try or I will see what I can do as a straightforward yes and move on.",
      "Never offer to take anything off them yourself."
    ]
  }$j$::jsonb,
  $md$Today, say yes to one thing with the trade attached — name what moves. Log what you said and what they chose.$md$
),
(
  (select id from public.skills where slug = 'your-manager'),
  5,
  'Bad news, early and plain',
  $md$Bad news travels upward badly. It arrives late, softened, and usually just after the last point at which anybody could have done something about it — and that combination, rather than the news itself, is what damages people.

The reason it arrives late is not dishonesty. It is hope. You think there is still a chance it comes good, and telling somebody now means admitting something you have not finished admitting to yourself. So you wait for certainty, and certainty arrives at the deadline.

**The move:** say it the day you know, in the plainest available words, with what you would do about it.

Plain is the part that takes practice. *There is a bit of a risk around Friday* is not a warning, it is weather, and it will be heard as one — then when Friday goes, the person you told will genuinely not remember being told, and they will be right, because they were not. *The Friday date is not going to happen* is a warning.

Bring one option with it. Not a solved problem — you do not need to have fixed it, and waiting until you have is how it gets late. *Earliest is Wednesday, and here is what I would cut if that does not work* turns you from somebody delivering a problem into somebody carrying one, and it costs about ten seconds of thinking.

What you get for this is counter-intuitive and reliable: telling somebody early makes it their problem too, which is the point. Managers have levers you do not — they can move a date, buy time upward, take something off you — and every one of those levers works better with three weeks than with three days.

And it is worth being explicit about the fear. Nobody is thinking less of you for a slipped date, which happens constantly. They think less of people who let them walk into a meeting unprepared for a thing that was already known.

If you keep one thing: say it the day you know it, in words that cannot be mistaken for weather.$md$,
  $j$[
    {
      "situation": "You realise on Tuesday that Friday is gone.",
      "line": "The Friday date is not going to happen — earliest is Wednesday.",
      "why": "Said the day it was known, in words that cannot be heard as weather. Three days of warning is worth more than any amount of softening."
    },
    {
      "situation": "You are about to say there is a bit of a risk around Friday.",
      "line": "(that is weather, and it will be heard as weather)",
      "why": "When Friday goes, they will genuinely not remember being told — and they will be right, because they were not."
    },
    {
      "situation": "You want to wait until you have a fix.",
      "line": "(bring one option, not a solution)",
      "why": "Waiting for the fix is how it becomes late news. Here is what I would cut costs ten seconds and is enough."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does bad news arrive late?",
      "options": [
        { "text": "People are avoiding the conversation.", "correct": false, "note": "It looks like avoidance from outside. Underneath it is usually something more specific." },
        { "text": "Hope — you are waiting to be certain.", "correct": true, "note": "Telling somebody now means admitting something you have not finished admitting to yourself, so you wait for certainty. Certainty arrives at the deadline." },
        { "text": "Nobody wants to look incompetent.", "correct": false, "note": "Real, and it is the fear rather than the mechanism. Plenty of confident people do this too." },
        { "text": "There is never a good moment.", "correct": false, "note": "There is: the day you know. The absence of a good moment is what waiting feels like from inside." }
      ],
      "explain": "You are not hiding it. You are waiting to be sure, and sure is too late."
    },
    {
      "prompt": "What is wrong with there is a bit of a risk around Friday?",
      "options": [
        { "text": "It is too vague to act on.", "correct": false, "note": "Close, and it understates it. The problem is not that it is hard to act on but that it does not register as news." },
        { "text": "It sounds like you are not on top of it.", "correct": false, "note": "It sounds fine, which is precisely the problem." },
        { "text": "It does not offer a solution.", "correct": false, "note": "A separate point, and a solution is not required. A plain statement with no option is still a warning." },
        { "text": "It is weather, and it will be heard as weather.", "correct": true, "note": "When Friday goes, they will not remember being warned — and they will be right, because they were not." }
      ],
      "explain": "Plain enough that it cannot be mistaken for a mood. The Friday date is not going to happen."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Said it the day they knew", "description": "Did not wait for certainty." },
      { "key": "plain", "label": "Said it plainly", "description": "Used words that cannot be heard as weather." },
      { "key": "an_option", "label": "Brought one option", "description": "Offered a next step without waiting to have fixed it." },
      { "key": "no_burying", "label": "Did not bury it", "description": "Led with the news rather than putting it after the good parts." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Tuesday morning. You have just worked out that the Friday deadline is not achievable, and your manager is presenting the plan upward on Thursday.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Calm about slipped dates and extremely unhappy about surprises. Hears a softened warning as an ordinary update and does nothing with it.",
      "mood": "Busy, expecting Friday to happen.",
      "openness": 4
    },
    "opening_beat": "\"Morning. Everything still on track for Friday? I am taking the plan up on Thursday.\"",
    "success_looks_like": "The user says plainly that Friday is gone and brings one option.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a plain warning calmly and start working the problem immediately.",
      "Treat any softened or hedged warning as a normal update and carry on assuming Friday.",
      "Never ask whether there is a problem."
    ]
  }$j$::jsonb,
  $md$Today, say one piece of inconvenient news the day you learn it, in words that cannot be mistaken for weather. Log what you said.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('your-manager', 1, 'line', $j${
  "says": "Oh — hello. All good with the project?",
  "model": {
    "line": "All fine. Could we do a regular half hour, every couple of weeks? Nothing wrong, I would just rather not save things up.",
    "why": "Names the thing and the rhythm, answers the only question it raises before it is asked, and justifies nothing else. This is the sentence managers say yes to almost without exception."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Ask for a rhythm or a length, not for time in general",
      "words": ["half hour", "half an hour", "thirty minutes", "20 minutes", "twenty minutes", "weekly", "fortnightly", "regular", "every week", "every couple", "every two weeks", "monthly"] },
    { "kind": "forbids_any", "requirement": "No hedges — every one is an exit you handed over",
      "words": ["sorry", "if you have time", "whenever suits", "no rush", "if you can spare", "not urgent", "at some point", "if that is okay", "if possible"] },
    { "kind": "max_words", "requirement": "Ask, do not build a case", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-manager', 2, 'choice', $j${
  "beats": [
    {
      "situation": "Your fortnightly half hour starts in an hour. You have six updates and one decision you are blocked on.",
      "prompt": "What is the plan for the meeting?",
      "options": [
        { "text": "Run the updates, then raise the decision at the end.", "correct": false, "note": "The ask lands at minute twenty-eight with somebody already thinking about their next meeting. This is the default and it is why so little comes out of these." },
        { "text": "Send the updates beforehand and open with the decision.", "correct": true, "note": "Status can be read in ninety seconds at a time that suits them. The meeting is the only slot with their whole attention, and updates do not need attention." },
        { "text": "Bring both — they should hear the updates in person.", "correct": false, "note": "Should they? Almost nothing in a status update is improved by being spoken, and it costs the only scarce thing in the room." },
        { "text": "Skip the meeting and send everything in writing.", "correct": false, "note": "Overcorrecting. The decision is exactly the thing writing is bad at, which is what the half hour is for." }
      ]
    },
    {
      "situation": "You are in the meeting and you have four things you would genuinely like from them.",
      "prompt": "How many do you raise?",
      "options": [
        { "text": "All four, briskly — none of them are big.", "correct": false, "note": "The first gets twenty-five minutes and the rest get picked up next time, which will arrive with its own four." },
        { "text": "Two, and the rest by message.", "correct": false, "note": "Better, and two asks is still one ask with a queue behind it. The half hour splits and neither gets decided." },
        { "text": "None — ask what they think you should be focusing on.", "correct": false, "note": "A good question to have and a poor substitute for the thing you actually needed. Direction is the fallback when you have nothing." },
        { "text": "One.", "correct": true, "note": "It feels like under-using the meeting and it is the only way something reliably comes out of it." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-manager', 3, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('your-manager', 4, 'line', $j${
  "says": "Can you pick up the Henderson report as well? Should not be too much on top of what you have.",
  "model": {
    "line": "I can, if something moves — the migration or the reporting. Which would you rather I dropped?",
    "why": "A yes with the arithmetic attached. It moves the question off your willingness, where you will always lose, and onto their priorities, where the call belongs and takes them four seconds."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Hand the priority call back to them" },
    { "kind": "contains_any", "requirement": "Name what would have to move",
      "words": ["move", "drop", "instead", "comes out", "slip", "push", "pause", "later", "which"] },
    { "kind": "forbids_any", "requirement": "Not an apology, and not a yes wearing a hedge",
      "words": ["sorry", "i will try", "ill try", "see what i can do", "no problem", "of course", "squeeze", "somehow", "fit it in"] },
    { "kind": "max_words", "requirement": "One sentence and a question", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-manager', 5, 'line', $j${
  "says": "Morning. Everything still on track for Friday? I am taking the plan up on Thursday.",
  "model": {
    "line": "No — the Friday date is not going to happen. Earliest is Wednesday, and I can tell you what I would cut if that does not work.",
    "why": "Said the day it was known, in words that cannot be heard as weather, with one option attached. Three days of warning is worth more than any amount of softening."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Words that cannot be mistaken for weather",
      "words": ["not going to", "will not", "wont", "is not happening", "miss", "missed", "no", "cannot", "slipped", "gone"] },
    { "kind": "forbids_any", "requirement": "No softening — a risk is not a warning",
      "words": ["a bit of a risk", "slight risk", "might be tight", "a bit tight", "hopefully", "should still", "probably fine", "touch and go", "fingers crossed"] },
    { "kind": "min_words", "requirement": "Bring one option with it", "n": 14 },
    { "kind": "max_words", "requirement": "Plain and short", "n": 45 }
  ]
}$j$::jsonb);

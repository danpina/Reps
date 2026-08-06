-- Interviews, track 7: Salary and offers.
--
-- Written without currency symbols throughout. A stray dollar sign inside a
-- dollar-quoted block is a migration that will not parse, and this is the one
-- track where the temptation to type one is constant.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-money'),
  1,
  'Know two numbers before you speak',
  $md$Almost every bad salary conversation is lost before it starts, by someone who has not decided what they think.

Two numbers, worked out in advance, in a quiet room, when nothing is at stake.

**The market number.** What this work pays, in this place, at this level, right now. Sources: people who do the job, recruiters who place it, salary surveys for your field, adverts that publish bands. Triangulate — every single source is biased, and three biased sources are usually enough to find the middle.

**The walk-away number.** The figure below which you would say no. This one is private, it is never spoken aloud to anyone in the process, and it is the most important of the two. It exists for a single purpose: to stop you negotiating against yourself at nine in the evening when an offer arrives and you feel grateful.

**The move:** decide the market number and the walk-away number before anyone asks you anything.

The reason both are needed is that they do different jobs. The market number is what you say. The walk-away number is what you decide with.

Two common errors. Setting the walk-away number at what you currently earn, which imports your last employer's valuation of you into a new company's decision. And setting the market number from what one friend earns, which is a sample of one and usually the friend who was pleased enough to mention it.

Write both down somewhere you can see them during a call. That sounds excessive until the first time you hear a number that is lower than you expected and notice how quickly a well-reasoned position dissolves into wanting the conversation to be over.$md$,
  $j$[
    {
      "situation": "Triangulating a market number from three imperfect sources.",
      "line": "Two adverts for the same title publish a band, a recruiter told me what she has placed people at this quarter, and I know roughly what a friend at a competitor earns. The three of them agree within about ten per cent, so I will use the middle of that.",
      "why": "No single source is trusted, which is correct, because every one of them is biased in a known direction. Agreement between three is much stronger evidence than confidence from one."
    },
    {
      "situation": "Setting a walk-away number that is not the current salary.",
      "line": "I earn X now, and I am not going to use that as the floor. The floor is the number below which I would rather stay where I am, and given the commute, that is actually a bit above what I would have guessed.",
      "why": "Separates what you are paid from what you would accept, which are unrelated facts. Factoring the commute in is the right kind of thinking — the walk-away number is about the whole trade, not just the salary."
    },
    {
      "situation": "Having the numbers visible during the call.",
      "line": "[a sticky note on the monitor, out of shot: market band, and one underlined figure]",
      "why": "Trivial, and it is the single most effective thing in this lesson. A number you can see is a number you do not have to remember while your heart rate is up."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why should the walk-away number never be spoken aloud?",
      "options": [
        {
          "text": "Because it is lower than the market number, and naming it caps you there.",
          "correct": true,
          "note": "The moment a floor is spoken, it becomes the ceiling. It exists to inform your decisions, not their offer."
        },
        {
          "text": "Because it would look inflexible.",
          "correct": false,
          "note": "Stating a minimum is not inflexible, it is just unwise. The problem is what it does to the number you end up with."
        },
        {
          "text": "Because it may change during the process.",
          "correct": false,
          "note": "It sometimes does, as you learn about the job. That is a reason to revisit it privately, not a reason to keep it quiet."
        }
      ],
      "explain": "One number is for saying. The other is for deciding. Confusing them is the most expensive mistake in this whole track."
    },
    {
      "prompt": "What is wrong with basing your expectations on your current salary?",
      "options": [
        {
          "text": "Nothing — it is the most concrete data you have.",
          "correct": false,
          "note": "It is concrete and it is a measurement of a different thing: what one employer paid for a role you already had."
        },
        {
          "text": "It is usually out of date.",
          "correct": false,
          "note": "Often true and not the core issue. Even a current salary agreed last month reflects the wrong decision."
        },
        {
          "text": "It imports your last employer's valuation into a new company's decision.",
          "correct": true,
          "note": "The new role has a market rate of its own, set by what this work is worth here. Your history is not evidence about that."
        },
        {
          "text": "It is confidential and should not be shared.",
          "correct": false,
          "note": "A separate and legitimate point about disclosure. It does not explain why the number is a poor basis for your own thinking."
        }
      ],
      "explain": "Price the job, not your history. What you were paid is a fact about somewhere you are leaving."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "market_number", "label": "Had a market number", "description": "Could state a researched range for the role, from more than one source." },
      { "key": "walk_away", "label": "Had a private floor", "description": "Had decided a walk-away figure and did not disclose it." },
      { "key": "not_anchored_on_history", "label": "Priced the job", "description": "Expectations were based on the role's market rate rather than on their current salary." },
      { "key": "composure", "label": "Held the position", "description": "Did not revise the number downwards in the moment simply to keep things comfortable." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An early call where money comes up sooner than expected, before the candidate has decided what to say.",
    "partner": {
      "name": "Lena Hoffmann",
      "role": "an internal recruiter who raises compensation in the first ten minutes",
      "personality": "Pleasant and businesslike. Asks about expectations early because she has been burned by late mismatches. Accepts a researched range without argument; probes a vague one.",
      "mood": "Efficient and friendly. She wants this to be straightforward.",
      "openness": 3
    },
    "opening_beat": "\"Before we go any further, I want to check we are in the same ballpark so neither of us wastes an afternoon. What are you looking for?\"",
    "success_looks_like": "The user gives a researched range with a reason behind it, does not anchor on their current salary, and does not talk themselves downwards.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user gives a vague answer, ask again more precisely, once.",
      "If the user names a range with a reason, accept it and move on without confirming whether it is inside the band.",
      "If the user mentions their current salary, ask a neutral follow-up about it and note it.",
      "Never tell the user whether their number was high or low."
    ]
  }$j$::jsonb,
  $md$Find out what your work actually pays, from two sources that are not each other. Then say the range out loud to someone and log whether you could say it without flinching or apologising.$md$
),
(
  (select id from public.skills where slug = 'interview-money'),
  2,
  'When they ask first',
  $md$"What are your salary expectations?" arrives early, often in the first call, and the instinct is either to name a low number to stay safe or to refuse to answer at all. There are three honest moves and each is right in different circumstances.

**Give a researched range, with the reason.** "I have been looking at the mid-sixties to mid-seventies for this level of role in this city, based on what I have seen advertised and two conversations with recruiters." The reason is what turns a number into a position. A number alone can be argued down; a number with evidence behind it has to be argued with.

**Ask what the band is.** "Do you have a band for the role?" Perfectly normal, frequently answered, and it costs nothing. Many employers publish bands internally and will simply tell you.

**Deflect, once.** "I would rather understand the role properly first — can we come back to it?" This works exactly one time. A second deflection reads as gamesmanship and starts to irritate.

**The move:** name a researched range with its reason, or ask for theirs — and never deflect twice.

The advice that whoever speaks first loses is mostly wrong for candidates. It is true in a negotiation between equals with symmetric information. In hiring, the employer knows the band and you do not, so refusing to engage usually just delays a conversation you will have anyway, with less goodwill.

Two specifics. If you give a range, be prepared to be offered its bottom — so the bottom of your stated range should be a number you would genuinely accept. And never give a range whose top you cannot justify; the question "why that figure?" will come, and having an answer is most of the battle.

If they will not say the band and press you for a number, give the range. The information asymmetry is not going to resolve itself, and being difficult about it costs more than it wins.$md$,
  $j$[
    {
      "situation": "A range with its reasoning attached.",
      "line": "I have been working to a range of about sixty-five to seventy-five thousand. That comes from three adverts for the same title in the same city and a conversation with a recruiter who places this role, so it is a market number rather than a wish.",
      "why": "The reason is doing the work. 'Market number rather than a wish' pre-empts the assumption that the figure is aspirational, and it is very hard to argue a researched range downwards."
    },
    {
      "situation": "Asking for the band first, lightly.",
      "line": "Happy to give you a number — is there a band for the role? It might save us both a step.",
      "why": "Agrees to answer before asking, which removes any sense of evasion. About half the time you get the band, and then you are answering with much better information."
    },
    {
      "situation": "Deflecting exactly once, and honouring it.",
      "line": "Can I come back to that once I understand the scope? … [later] … You asked about money earlier. Based on what you have described, I would be looking at the upper half of what I said I was working to.",
      "why": "The deflection is honoured without being asked again, which is what makes it land as genuine rather than tactical. Returning to it unprompted also lets you set a number informed by what you have learned."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "A recruiter asks for your expectations in the first five minutes. What is usually the best response?",
      "options": [
        {
          "text": "Refuse until you know more — whoever speaks first loses.",
          "correct": false,
          "note": "That rule comes from negotiations with symmetric information. In hiring they know the band and you do not, so refusing mostly delays and irritates."
        },
        {
          "text": "Ask whether there is a band, and give a researched range if there is not.",
          "correct": true,
          "note": "Costs nothing, often gets you the number, and if it does not you have answered honestly with evidence attached."
        },
        {
          "text": "Say you are flexible for the right opportunity.",
          "correct": false,
          "note": "Reads as having no view, and it will be tested — the next offer you see will be at the bottom of the band."
        },
        {
          "text": "Give your current salary as a reference point.",
          "correct": false,
          "note": "Anchors the whole conversation on what somebody else decided you were worth, for a different job."
        }
      ],
      "explain": "Engage, with evidence. Refusing to answer is a strategy borrowed from a different kind of negotiation."
    },
    {
      "prompt": "You name a range. What should you assume will happen?",
      "options": [
        {
          "text": "They will offer somewhere in the middle.",
          "correct": false,
          "note": "Optimistic. Most offers land at or near the bottom of a stated range, because that is what the range permitted."
        },
        {
          "text": "They will offer the bottom of it.",
          "correct": true,
          "note": "Assume it, and set the bottom of your range at a number you would actually accept. A range's floor is a commitment, whatever you intended."
        },
        {
          "text": "They will ignore it and offer the band's midpoint.",
          "correct": false,
          "note": "Happens where bands are rigid, and it is not something to count on when deciding what to say."
        }
      ],
      "explain": "The bottom of your range is the number you have agreed to. Choose it as though it were the only figure you said."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "engaged", "label": "Engaged with the question", "description": "Answered or asked for the band rather than stonewalling." },
      { "key": "reasoned_range", "label": "Gave a reason", "description": "Any figure came with evidence behind it." },
      { "key": "acceptable_floor", "label": "The floor was real", "description": "The bottom of the stated range was a number they would genuinely accept." },
      { "key": "one_deflection", "label": "Deflected at most once", "description": "Did not repeatedly avoid the question." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A screening call where the recruiter is under instruction to get a number before booking the next stage.",
    "partner": {
      "name": "Ryan Tulloch",
      "role": "an agency recruiter who needs a figure for his notes",
      "personality": "Friendly and persistent. Will not volunteer the band unless asked directly. Comes back to the money question a second time if the first answer was vague.",
      "mood": "Under mild pressure from his client to qualify candidates properly.",
      "openness": 3
    },
    "opening_beat": "\"One thing I have to ask before I can put you forward — what sort of package are you after?\"",
    "success_looks_like": "The user either asks for the band or gives a researched range with a reason, and does not name their current salary or a figure they would be unhappy with.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If asked directly whether there is a band, give one — a plausible range for the role.",
      "If the user is vague or deflects, come back to the money question once more, more directly.",
      "If the user names a current salary, repeat it back as though writing it down.",
      "Never say whether their number is inside or outside the band."
    ]
  }$j$::jsonb,
  $md$Say your range and the reason behind it out loud to someone, as though they had just asked. Log whether you added an apology or a qualifier to the end of it without meaning to.$md$
),
(
  (select id from public.skills where slug = 'interview-money'),
  3,
  'The ask after the offer',
  $md$The moment an offer is made is the only moment in the entire process when your leverage is real, and it lasts about a day.

Everything before it was you competing. Now they have chosen, they have told other candidates no, and the person who made the offer would very much like to stop recruiting. That is not a weapon and it does not need to be. It simply means a reasonable request is likely to be met, and that asking is normal.

The whole technique is one sentence and one silence.

"Thank you — I am pleased. Is there any flexibility on the base?"

Then stop talking.

It is a question, not a demand, so nobody has to defend anything. And the silence afterwards is where the answer comes from. Almost every candidate who loses money here loses it by filling that pause — by explaining, by justifying, by pre-emptively saying it is fine if not.

**The move:** ask whether there is flexibility, then say nothing until they answer.

Three supporting habits.

**Say thank you first and mean it.** Enthusiasm and negotiation are not opposites, and the version of this that goes badly is the one that sounds like disappointment.

**Ask for it in writing, and take a night.** Nothing you gain by accepting on the phone is worth what you lose by not thinking. "Can you send that over? I would like to read it properly and come back to you tomorrow" is completely standard and nobody has ever withdrawn an offer over it.

**One ask, not three rounds.** Ask, hear the answer, decide. A negotiation that goes back and forth four times spends goodwill you will need on your first day.

If the answer is no, that is fine. You have lost nothing — the offer does not evaporate because you asked, and an employer who would withdraw it for that has told you something useful very cheaply.$md$,
  $j$[
    {
      "situation": "The ask, in full.",
      "line": "That is great news, thank you — I am genuinely pleased. Can I ask whether there is any flexibility on the base? [silence]",
      "why": "Warm, brief, and it ends on a question with nothing after it. The silence is the technique; everything a candidate adds here is a concession made before anyone asked for one."
    },
    {
      "situation": "Buying a night without sounding hesitant.",
      "line": "Could you send it over in writing? I would like to read it properly and come back to you tomorrow morning. I am not shopping it around, I just do not want to say yes to something I have only heard once.",
      "why": "Removes the fear that you are using them for leverage, which is what makes employers anxious about delay. The stated reason is honest and completely reasonable."
    },
    {
      "situation": "Accepting a no gracefully and closing.",
      "line": "Understood, thank you for checking. Then yes — I would like to accept.",
      "why": "One ask, a clean answer, an immediate decision. This is what makes the ask cost nothing, and it is why a candidate who asks once is remembered as decisive rather than as difficult."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You ask whether there is flexibility on the base. They pause. What should you do?",
      "options": [
        {
          "text": "Say that you understand if there is not.",
          "correct": false,
          "note": "That is the single most expensive sentence in the conversation. You have answered your own question, in their favour, before they said anything."
        },
        {
          "text": "Explain your reasoning for asking.",
          "correct": false,
          "note": "The question did not need justifying. Filling the pause with reasons invites them to evaluate the reasons instead of answering."
        },
        {
          "text": "Nothing. Wait for them to speak.",
          "correct": true,
          "note": "The pause is where the movement happens. Whoever speaks next concedes, and it does not have to be you."
        },
        {
          "text": "Name a specific figure to make it concrete.",
          "correct": false,
          "note": "Sometimes a reasonable follow-up if they ask what you had in mind. Volunteering it into a silence discards the chance that their number is better than yours."
        }
      ],
      "explain": "Ask, then stop. Almost all the money lost at this stage is lost in the four seconds after the question."
    },
    {
      "prompt": "Is it risky to ask for time to consider a written offer?",
      "options": [
        {
          "text": "Yes — hesitation can make them doubt your enthusiasm.",
          "correct": false,
          "note": "A near-universal fear and it almost never happens, particularly when you have said plainly that you are pleased."
        },
        {
          "text": "Yes, if they have other candidates waiting.",
          "correct": false,
          "note": "They have usually just told those candidates no. An overnight wait does not reopen that."
        },
        {
          "text": "No — it is standard, and it is the only way to read what you are agreeing to.",
          "correct": true,
          "note": "Offers are documents with details in them. Reading one before signing is expected behaviour, not a signal."
        }
      ],
      "explain": "A night costs nothing and buys you the only clear-headed hour in the process."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "thanked_first", "label": "Led with warmth", "description": "Expressed genuine pleasure before raising anything." },
      { "key": "asked_the_question", "label": "Asked about flexibility", "description": "Made the ask, plainly, as a question rather than a demand." },
      { "key": "held_the_silence", "label": "Held the silence", "description": "Did not fill the pause after the question." },
      { "key": "took_the_time", "label": "Took it away to read", "description": "Asked for the offer in writing and time to consider it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A phone call in the early afternoon. The hiring manager is calling personally with good news.",
    "partner": {
      "name": "Alison Kerr",
      "role": "the hiring manager, making the offer herself",
      "personality": "Pleased and slightly nervous — she wants this to be a yes. Has a small amount of room on the base and will use it if asked, but never volunteers it.",
      "mood": "Warm and hopeful. She has just spent two weeks on this process and would like it to be over.",
      "openness": 4
    },
    "opening_beat": "\"I have got good news — we would like to offer you the role. The team were unanimous, which does not happen often. The base would be at the figure we discussed.\"",
    "success_looks_like": "The user thanks her warmly, asks once about flexibility, holds the silence afterwards, and asks for the offer in writing before deciding.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If asked about flexibility, pause before answering — write the hesitation in — and then offer a modest improvement.",
      "If the user fills the silence with reassurance or justification, take it: say the number is fixed and move on.",
      "Agree readily to sending it in writing and to an overnight decision.",
      "Never advise the user on how to negotiate."
    ]
  }$j$::jsonb,
  $md$Practise the sentence out loud with someone: thank them, ask whether there is flexibility, and then stay silent until they respond. Log how long you lasted before speaking.$md$
),
(
  (select id from public.skills where slug = 'interview-money'),
  4,
  'Everything that is not the base',
  $md$Base pay is the number everyone negotiates and often the one with least room in it, because it sits inside a band that somebody else approved. The rest of the package is frequently more flexible and almost nobody asks.

What is usually available.

**Start date.** The cheapest thing to move and worth real money if you have holiday to take or a gap you wanted.

**Holiday.** Sometimes fixed by policy, sometimes not, and often possible as unpaid additional leave even where the paid allowance is rigid.

**A signing amount.** Common where the band is genuinely inflexible, because it comes from a different budget and does not set a precedent for anyone else's salary.

**Working pattern.** Days in the office, hours, a compressed week. This is the request that has changed most in recent years and it is frequently granted.

**Review timing.** A salary review at six months rather than twelve, written down. This is the quiet one: it costs the employer nothing today, so it is often agreed, and it changes what happens next year.

**Title.** Free, and it affects your next job more than this one.

**The move:** if the base will not move, ask what else can.

Say it in exactly those terms. "I understand the base is fixed. Is there flexibility anywhere else?" It is a cooperative question — you have accepted their constraint and invited them to solve the problem with you, and people respond well to being asked for help.

Two cautions. Ask for one or two things, not a list; a list turns a conversation into a negotiation and changes the temperature. And get anything agreed written into the offer letter, kindly and without suspicion — "would you mind putting the review date in the letter, just so it does not get lost when you and I both forget about it in November?" Verbal agreements outlive the manager who made them approximately never.$md$,
  $j$[
    {
      "situation": "Redirecting after a hard no on base.",
      "line": "That is fine, I understand the band is the band. Is there flexibility anywhere else — start date, or the review timing?",
      "why": "Accepts their constraint out loud, which lowers the temperature, then names two specific things rather than asking an open question. Specific asks get answered; open ones get a vague reply."
    },
    {
      "situation": "Asking for the review date rather than more money now.",
      "line": "Could we agree a review at six months rather than twelve, and put it in the letter? If I am worth more by then it is an easy conversation, and if I am not then nothing has been promised.",
      "why": "Costs the employer nothing today, which is why it is so often granted, and the framing makes it easy to say yes to. The second sentence removes any sense of being cornered."
    },
    {
      "situation": "Getting a verbal agreement written down without implying distrust.",
      "line": "Would you mind putting that in the offer letter? Purely because you and I will both have forgotten this conversation by the spring.",
      "why": "The reason given is memory rather than mistrust, which is true and also lets everyone keep their dignity. Managers move, and an agreement that exists only in a phone call moves with them."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "The base is genuinely fixed. Which ask is most likely to be granted?",
      "options": [
        {
          "text": "A more senior job title.",
          "correct": false,
          "note": "Free in cash terms and frequently constrained by internal levelling, which makes it harder than it looks."
        },
        {
          "text": "An earlier salary review, written into the letter.",
          "correct": true,
          "note": "It costs nothing this year, which is the budget anyone is actually defending. It is one of the most reliably granted requests there is."
        },
        {
          "text": "Additional paid holiday.",
          "correct": false,
          "note": "Often fixed by policy across the whole company, because granting it once creates a problem for everyone else."
        },
        {
          "text": "A four-day week.",
          "correct": false,
          "note": "Increasingly possible and still a much larger request than it sounds — it changes the pay and the team's coverage at once."
        }
      ],
      "explain": "Ask for the thing that costs nothing from this year's budget. That is where the flexibility lives."
    },
    {
      "prompt": "How should a non-salary request be framed?",
      "options": [
        {
          "text": "As a list, so they can pick what is easiest.",
          "correct": false,
          "note": "A list reads as a negotiation opening rather than a request, and it invites them to grant the smallest item and consider the matter closed."
        },
        {
          "text": "As one or two specific asks, after accepting their constraint out loud.",
          "correct": true,
          "note": "Acknowledging the constraint makes it collaborative, and specific asks get specific answers where open questions get vague ones."
        },
        {
          "text": "As an open question about what else might be possible.",
          "correct": false,
          "note": "Polite and usually answered with 'not much'. Naming the thing you want makes it far easier for them to say yes."
        }
      ],
      "explain": "Accept the wall, then ask about the door. And name the door."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "accepted_the_constraint", "label": "Accepted the constraint", "description": "Acknowledged the fixed base out loud before asking for anything else." },
      { "key": "specific_asks", "label": "Named specific things", "description": "Asked for one or two concrete items rather than opening a general negotiation." },
      { "key": "chose_well", "label": "Asked for what was gettable", "description": "Prioritised requests that cost the employer little in the current year." },
      { "key": "in_writing", "label": "Got it written down", "description": "Asked for anything agreed to appear in the offer letter, without implying distrust." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A follow-up call the day after an offer, where the base has already been confirmed as non-negotiable.",
    "partner": {
      "name": "Femi Adebayo",
      "role": "a hiring manager whose salary bands are set centrally and genuinely cannot move",
      "personality": "Straightforward and a bit apologetic about the constraint. Has real latitude over start date, working pattern and review timing, and will use it if asked specifically.",
      "mood": "Slightly frustrated on the candidate's behalf. He would pay more if he could.",
      "openness": 4
    },
    "opening_beat": "\"I did ask, and I am afraid the answer is no — the bands are set centrally and there is nothing I can do about the base. I hope that does not change things.\"",
    "success_looks_like": "The user accepts the constraint gracefully, names one or two specific alternatives, and asks for anything agreed to be written into the offer.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Hold firm on the base under any pressure. It genuinely cannot move.",
      "If asked about a specific alternative — start date, working pattern, review timing — agree to it or negotiate it warmly.",
      "If asked an open question about what else is possible, answer vaguely: 'I am not sure, what did you have in mind?'",
      "Never suggest alternatives yourself unless the user asks about one first."
    ]
  }$j$::jsonb,
  $md$Ask someone what they negotiated other than salary in their last job — and what they wish they had asked for. Log the one thing you had not thought of.$md$
),
(
  (select id from public.skills where slug = 'interview-money'),
  5,
  'Yes, no, and the other offer',
  $md$How a process ends is remembered longer than how it went, because the ending is the part where people find out what you are like when you have nothing to gain.

**Saying yes.** Do it clearly and warmly, in writing, and stop negotiating. A candidate who accepts and then reopens something has spent their first political capital before day one. Then tell everyone who helped — the recruiter especially, who has been quietly arguing for you in rooms you were not in.

**Saying no.** Promptly, warmly, and without a fabricated reason. "I have accepted something else" is a complete sentence and it requires no elaboration. Do not invent a problem with their offer to make the refusal feel justified — it invites them to fix it, and now you are having a conversation you did not want. The industry is small, hiring managers move, and the person you decline this year interviews you in four years' time surprisingly often.

**The competing offer.** If you genuinely have one, saying so is legitimate and it should be stated as a fact with a deadline, not as a threat. "I have another offer and I need to answer by Thursday. You are my first choice, and I wanted to tell you rather than let the clock run out." That is honest, it is useful to them, and it gives them a reason to move quickly.

**The move:** end it in the way you would want to be told — promptly, warmly, and without invention.

Never bluff a competing offer you do not have. The failure mode is not that you are caught. It is that they say "we understand, good luck", and there is nowhere to go.

And if you are turning down an offer you nearly took, say what you liked about them. It costs a sentence, it is usually true, and it is the thing that gets remembered when your name comes up again.$md$,
  $j$[
    {
      "situation": "Accepting clearly and closing the negotiation.",
      "line": "I would like to accept — thank you. Everything we discussed is in the letter as far as I can see, so I am happy to sign today. And thank you for asking about the review date, that mattered.",
      "why": "Unambiguous, warm, and it closes the negotiation explicitly. Naming the concession they made ensures the person who argued for it knows it landed."
    },
    {
      "situation": "Declining without inventing a reason.",
      "line": "I am going to say no, and I wanted to tell you today rather than let it sit. I have accepted something else. I was genuinely torn — the conversation with your team about the reporting problem was the best hour of my search.",
      "why": "Prompt, honest, no fabricated flaw in their offer. The specific compliment at the end is what makes this memorable in a good way rather than merely polite."
    },
    {
      "situation": "Naming a real competing offer as information.",
      "line": "I should tell you I have another offer with a Thursday deadline. You are my first choice and I did not want to just disappear on you. Is there any chance of a decision before then?",
      "why": "A fact and a request, with no implied threat. 'You are my first choice' removes the adversarial reading entirely, and it is the sentence that makes companies move fast."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You are declining an offer. Should you explain why?",
      "options": [
        {
          "text": "Yes, in detail — they deserve honest feedback about their process.",
          "correct": false,
          "note": "Give it if asked. Volunteering a critique of a company you are leaving is a conversation with no upside for you."
        },
        {
          "text": "Only if the reason is true and simple, such as having accepted elsewhere.",
          "correct": true,
          "note": "One clean sentence. Anything more invites a counter-offer or a negotiation you have already decided against."
        },
        {
          "text": "No — say nothing beyond declining.",
          "correct": false,
          "note": "A bare no is colder than it needs to be, and this is a person you may meet again. One warm sentence costs nothing."
        },
        {
          "text": "Yes, and name something about the offer that could have changed your mind.",
          "correct": false,
          "note": "They will then change it, and you will be back in a negotiation you did not want. Do not open a door you intend to walk away from."
        }
      ],
      "explain": "Prompt, warm, true, and short. Elaboration is what turns a decision into a discussion."
    },
    {
      "prompt": "Is it worth mentioning a competing offer you do not actually have?",
      "options": [
        {
          "text": "No, because the risk is that they simply say good luck.",
          "correct": true,
          "note": "That is the real failure mode, not being caught. A bluff that is politely accepted leaves you with no move and no offer."
        },
        {
          "text": "No, because they will check with the other company.",
          "correct": false,
          "note": "They will not, and imagining they might is the wrong reason to avoid it."
        },
        {
          "text": "Yes, if it accelerates a slow process.",
          "correct": false,
          "note": "It sometimes does, and the downside is that the acceleration can be towards a no."
        }
      ],
      "explain": "Leverage you do not have cannot be spent. A stated deadline you cannot back up ends the conversation on their terms."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "prompt", "label": "Answered promptly", "description": "Gave a clear decision quickly rather than letting it drift." },
      { "key": "warm", "label": "Ended warmly", "description": "Left the relationship in good condition, including when declining." },
      { "key": "no_invention", "label": "Nothing invented", "description": "No fabricated reasons, and no leverage claimed that did not exist." },
      { "key": "closed_cleanly", "label": "Closed it", "description": "Did not reopen a negotiation that had already been settled." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A call to decline an offer from a company the candidate liked, having accepted elsewhere.",
    "partner": {
      "name": "Rachel Oyelaran",
      "role": "a hiring manager who has been waiting for this answer",
      "personality": "Gracious, and disappointed. Will ask once whether anything could change the decision, and will accept a clear no without pushing further.",
      "mood": "Hopeful at the start of the call, then quickly professional.",
      "openness": 4
    },
    "opening_beat": "\"Hi — thanks for calling. I have to say I am hoping this is good news, the team have been asking me all week.\"",
    "success_looks_like": "The user declines clearly and early in the call, gives one true and simple reason, says something genuine about what they liked, and does not reopen the negotiation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask once whether anything could change their mind. Accept a clear no without pressing again.",
      "If the user hints at a fixable problem with the offer, immediately offer to fix it.",
      "If the user is vague about their decision, ask them directly whether it is a no.",
      "Stay gracious throughout, and never tell the user how they handled it."
    ]
  }$j$::jsonb,
  $md$Turn something down today — an invitation, a request, a meeting — promptly, warmly, and without inventing a reason. Log how it felt to give a short answer instead of a justified one.$md$
);

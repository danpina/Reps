-- Work, written for where the reader is standing.
--
-- Five lessons where one general version is genuinely two pieces of advice.
-- Not most of them: how to get into a meeting is how to get into a meeting,
-- and a lesson that varies for the sake of varying is worse than one that
-- does not. These five invert.
--
-- The axis is not age, it is standing in the room, and age is a decent free
-- proxy for it — decent, not exact, which is why every variant is an addition
-- to a lesson that still has to work on its own. A forty-five-year-old who
-- changed careers last year is junior, and they will get the general version,
-- which was written to be correct for everybody.
--
-- The bands are deliberately not exhaustive. 35-44 sits between the two spans
-- and gets the lesson as written, because that is who the general version was
-- written for. A reader who has not given a band gets it too — guessing
-- somebody's career stage in order to show them advice about their career
-- stage is the one failure worth designing against.

-- ---------------------------------------------------------------------------
-- Your manager / 3 — Disagree once, in private
--
-- The clearest inversion in the topic. At twenty-five the risk is being read
-- as presumptuous; at fifty-five, with a manager of thirty-two, it is being
-- read as the old guard. Same move, opposite failure.
-- ---------------------------------------------------------------------------

update public.lessons set variants_json = $j$[
  {
    "when": { "age_groups": ["18-24", "25-34"] },
    "label": "Disagreeing with somebody more experienced than you",
    "note_md": "Your manager probably has more context than you do, and the honest version of this move accounts for that without abandoning it.\n\nAsk before you object. **What am I missing?** is not a climbdown — it is the question that either gives you the missing piece or confirms there was not one, and it takes fifteen seconds. Half of what feels like a wrong decision at this stage is a decision made with information you have not been given, and finding that out privately is much cheaper than discovering it mid-argument.\n\nIf the answer does not satisfy you, disagree exactly as the lesson says. Being new is not a reason to stay quiet, and the specific value you have is that you are close to the work — you can see the thing at the level of what actually happens on Tuesday, which is precisely what somebody two steps away cannot.\n\nSo argue from what you can see rather than from judgement. **The rollback takes four hours and we have a two-hour window** is unanswerable and yours to know. **I do not think this is the right strategy** is a judgement you have not yet earned the standing to have taken seriously, and offering it is what gets a young person filed as difficult rather than as sharp."
  },
  {
    "when": { "age_groups": ["45-54", "55-64", "65+"] },
    "label": "Disagreeing with somebody less experienced than you",
    "note_md": "If your manager is younger than you, the risk runs the other way, and it is worth naming because almost nobody will say it to you.\n\nThe failure mode is not presumption. It is being heard as the person who resists things — and the sentence that does it is **we tried this in 2011**. It may be entirely true and it is close to useless, because nobody can act on it: it invites a defence of why now is different, and it makes the subject your history rather than their decision.\n\nSay the mechanism instead. **This tends to fall over when the third team joins, because nobody owns the interface** is the same knowledge with the year taken out, and it is checkable. Experience is most persuasive when it arrives as a specific prediction rather than as a precedent.\n\nThe commitment half matters more for you, not less. A younger manager overruling somebody senior is doing something socially expensive, and knowing in advance that you will back it publicly is what makes it possible for them to hear you at all. Say it first, and mean it.\n\nAnd disagree less often than you could. You will be right about more things than you have room to raise, and spending that room on the two that matter is worth more than being right on ten."
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'your-manager')
  and sort_order = 3;

-- ---------------------------------------------------------------------------
-- Being seen / 1 — Work does not speak
--
-- Early the problem is that nobody knows your name. Later it is that they
-- think they already know what you do, which is a description that stopped
-- updating some years ago.
-- ---------------------------------------------------------------------------

update public.lessons set variants_json = $j$[
  {
    "when": { "age_groups": ["18-24", "25-34"] },
    "label": "When nobody knows your name yet",
    "note_md": "At this stage the absence is total, and that is easier than it sounds — there is nothing to correct, only something to build.\n\nThe specific trap is assuming your manager is passing it on. Sometimes they are. Frequently they are describing the team's work, because that is what they are asked about, and your name is not in the sentence at all. That is not disloyalty; it is what happens when somebody summarises.\n\nSo the person to become visible to is the one who has never met you. A skip-level who has heard your name twice will recognise it in a staffing conversation, and two mentions is the entire bar. It sounds cynical written down and it is simply how memory works.\n\nOne warning worth having early: being the most helpful person on the team is not visibility. Helping is invisible by design — it happens inside other people's work and it gets attributed there. It is worth doing, and it will not turn into anything on its own, which is a genuinely useful thing to know at twenty-six rather than at thirty-four."
  },
  {
    "when": { "age_groups": ["45-54", "55-64", "65+"] },
    "label": "When they think they already know what you do",
    "note_md": "Your version of invisibility is the opposite shape, and it is harder to spot because it looks like being established.\n\nPeople have a description of you and it is several years old. It was accurate when it formed, it has not been updated since, and it is now doing you damage in a specific way: reliable is a compliment that quietly means finished. Somebody who is a known quantity does not get considered for things, because considering happens to people whose ceiling is still an open question.\n\nWhich means your visibility problem is not exposure — everybody knows who you are — it is *currency*. What is missing is anything recent. So name the new thing rather than the ongoing thing: not the area you have run for six years, but the problem you solved in March that nobody would expect from you.\n\nThe hardest part is that this feels unnecessary. You have been here longer than most of the room and it is reasonable to expect the record to speak. It does not — long tenure produces a stronger impression, not a more current one, and a strong old impression is exactly the thing that is hardest to move."
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'being-seen')
  and sort_order = 1;

-- ---------------------------------------------------------------------------
-- Saying what you want / 4 — Before the vacancy
-- ---------------------------------------------------------------------------

update public.lessons set variants_json = $j$[
  {
    "when": { "age_groups": ["18-24", "25-34"] },
    "label": "When it feels far too early to say it",
    "note_md": "The objection at this stage is that you have not been here long enough to be heading anywhere, and it is worth answering directly: eighteen months is long enough to have a direction, and the people who get moved early are not the ones who waited until it felt appropriate.\n\nSaying it early costs you nothing precisely because nobody expects it to be actionable. **Eventually I would like to be doing what Priya does** is not a demand at two years in — it is a piece of information that will sit in somebody's head, cost-free, until the moment a name is needed.\n\nThe real risk for you is the opposite one, and it is quiet: being extremely good at your current job for four years and then discovering that this is what everybody now assumes you want. Competence at one thing is sticky, and the longer it goes unqualified, the more it looks like a preference.\n\nAsk what the route actually is, too. **What does somebody usually do before they get that job?** is an ordinary question, it gets an honest answer, and the answer is frequently one specific piece of experience rather than a number of years — which turns a vague ambition into something you can go and get."
  },
  {
    "when": { "age_groups": ["45-54", "55-64", "65+"] },
    "label": "When people have stopped asking where you are going",
    "note_md": "Somewhere along the way people stop asking senior colleagues about their ambitions, and the silence gets mistaken for contentment by everybody including, eventually, you.\n\nSo the version of this you need is more explicit rather than less. Nobody is going to open the subject on your behalf, and a direction left unstated at this stage does not read as modesty — it reads as settled. **I am not done, and here is what I would want next** is a sentence that surprises people, which is a signal about how rarely it gets said rather than about whether you should say it.\n\nSideways counts, and it may well be the honest answer. A different area, a harder problem, a piece of scope nobody wants — those are real directions, and naming one is far more credible than a title you may not want the rest of.\n\nAnd the assumption that you have peaked is a real one that goes unstated, which means it does not get argued with, only acted on. The only reliable answer is a current, specific direction said out loud to somebody who staffs things. It does not confront the assumption; it just makes it awkward to hold."
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'saying-what-you-want')
  and sort_order = 4;

-- ---------------------------------------------------------------------------
-- Asking for money / 1 — Ask for a number, not a conversation
--
-- The flagship. At twenty-three there is no data and no leverage; at fifty
-- there is a band ceiling and a suspicion of being expensive. The move is the
-- same and almost nothing else about it is.
-- ---------------------------------------------------------------------------

update public.lessons set variants_json = $j$[
  {
    "when": { "age_groups": ["18-24", "25-34"] },
    "label": "Your first few of these",
    "note_md": "The hard part for you is not saying the number. It is not knowing what number to say, and being uncomfortable enough about that to skip the conversation entirely.\n\nGet the data before you get brave. Job adverts for the role you are doing, not the one you have — advertised ranges are public and roughly honest. Recruiter messages, which are worth answering once purely for the number. And anybody a year or two ahead of you who will tell you, which is more people than you think: asking peers directly is normal now and the worst outcome is a polite decline.\n\nThen expect to feel like you are asking too much and ask it anyway. The number that feels safe at this stage is almost always below market, because it is anchored on what you were offered when you had less experience and no idea what to ask for.\n\nThe specific trap of being early is the compounding one. The gap between what you are paid and what the work is worth does not close by itself, it widens — internal raises are percentages of a number that started low, and the only reliable corrections are asking or leaving. People who never ask in their twenties spend a decade being quietly repriced by nobody."
  },
  {
    "when": { "age_groups": ["45-54", "55-64", "65+"] },
    "label": "When the band is the obstacle",
    "note_md": "You are more likely to be at a ceiling than in a negotiation, and the useful move is to find out which one you are in before spending the conversation.\n\nAsk it plainly: **where am I in the band, and what is the top of it?** Most managers will answer, and the answer changes everything. Mid-band is an ordinary conversation and the lesson applies unchanged. At or near the top means no amount of case-making moves it, and continuing to argue looks like not understanding how pay works — which is expensive in a way the money never was.\n\nAt a ceiling there are exactly three things that move: a different level, a different role, or a different employer. So the conversation converts. Ask what the next level is assessed on and whether anybody thinks you are close to it, which is a question about work rather than about money and gets a much more honest answer.\n\nAnd there is an unspoken dynamic worth naming, because it will not be said to you. A long-tenured senior person is priced against what a replacement would cost, and if you have been here a long time you may be at the top of a band built for a job that has grown underneath you. The counter is not tenure — never tenure. It is making the current scope legible enough that the band looks like the wrong container, which is an argument your manager can actually take upward."
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'asking-for-money')
  and sort_order = 1;

-- ---------------------------------------------------------------------------
-- Asking for money / 4 — Three things you did
-- ---------------------------------------------------------------------------

update public.lessons set variants_json = $j$[
  {
    "when": { "age_groups": ["18-24", "25-34"] },
    "label": "When your three feel small",
    "note_md": "You will look at your three and find them unimpressive next to what senior people did, and that comparison is the wrong one — it is not the test and nobody applies it.\n\nWhat a case has to show is a change in what you can be trusted with, and that is visible at any scale. **I was reviewing other people's work by June**, **I ran the Tuesday release on my own from March**, **the client emails me directly now**. None of those is large and every one of them is a difference between the person who was hired and the person standing there, which is the only thing a pay decision is actually about.\n\nRecency beats scale. Something from the last six months that you could not have done a year ago is worth more than the biggest thing you have ever touched, because it establishes a direction rather than a high point.\n\nAnd resist the specific early temptation to argue from effort, which will be genuinely true for you — the long hours, the weekend, the thing you taught yourself. It is real and it cannot be repeated in a room you are not in, which is the same problem everybody else has and no different for being deserved."
  },
  {
    "when": { "age_groups": ["45-54", "55-64", "65+"] },
    "label": "When your three are old",
    "note_md": "The risk for you is not having nothing to say. It is that your three best examples are from years ago and the room has heard them.\n\nDate them out loud and keep them recent. Anything older than about eighteen months has stopped being evidence and started being biography, however good it was — and a case built on the thing you are known for confirms the description of you that already exists rather than updating it, which is precisely what you were trying to change.\n\nWatch for tenure in disguise. **I have kept this running for six years** sounds like an achievement and is a description of a steady state; nothing in it has changed, so there is nothing to reprice. **I took this over when it was breaking monthly and it has not broken since** is the same six years with the change put back in.\n\nThe strongest thing you have is almost certainly leverage rather than output — the people you made better, the disaster that did not happen, the decision that got made properly because you were in the room. It is harder to state and it is the actual case, so state it concretely: **two of the four people on that team are here because I hired them, and both are running things now.**"
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'asking-for-money')
  and sort_order = 4;

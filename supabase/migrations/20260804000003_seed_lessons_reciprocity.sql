-- Track 4: Reciprocity & self-disclosure. Match their depth, then go one step
-- further.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'reciprocity'),
  1,
  'Asking only questions is its own failure',
  $md$There is a kind of conversationalist who asks excellent questions, listens attentively, never interrupts, and leaves the other person feeling faintly uneasy.

The reason is that questions without disclosure are asymmetric. One person has handed over their history, their opinions and their weekend plans. The other has handed over nothing. However warm the questions were, the person answering walks away having been read without reading, and the sensation is closer to being interviewed than being met.

**The move:** track how much you have given, not just how much you have asked.

If you cannot name one non-trivial thing the other person now knows about you, you have not been having a conversation. You have been conducting one.

This is the most common failure in people who have deliberately worked on their small talk, because questions are the part everybody teaches.$md$,
  $j$[
    {
      "situation": "You have asked several good questions and realise you have said nothing about yourself.",
      "line": "I should say, the reason I am asking is I am thinking about doing the same thing.",
      "why": "Explains the interest and reveals a plan of your own. It converts a run of questions retroactively into a conversation."
    },
    {
      "situation": "They have just answered something at length and there is a natural gap.",
      "line": "That is not far off my own experience of it, actually.",
      "why": "Signals you are not neutral. Even a small claim of similarity changes the shape from interview to exchange."
    },
    {
      "situation": "You notice they have started giving shorter answers.",
      "line": "I have been firing questions at you. Ask me something, it is only fair.",
      "why": "Names the imbalance lightly and hands them the floor. Most people find the honesty disarming rather than awkward."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Twenty minutes into a conversation you realise you know a lot about them and they know almost nothing about you. What does that most likely feel like from their side?",
    "options": [
      {
        "text": "Flattering, since you were clearly interested.",
        "correct": false,
        "note": "It can feel that way for a few minutes. Over twenty it usually tips into feeling examined rather than admired."
      },
      {
        "text": "Slightly exposed, and unsure what you are actually like.",
        "correct": true,
        "note": "This is the usual result. They have been generous and got nothing back, so the warmth has a one-way quality they may not be able to name."
      },
      {
        "text": "Neutral, because most people prefer talking about themselves.",
        "correct": false,
        "note": "People do enjoy talking about themselves, but not indefinitely and not into a vacuum. The preference has limits."
      },
      {
        "text": "Impressed by how good a listener you are.",
        "correct": false,
        "note": "Possible, but listening well and disclosing nothing reads as guarded, and guarded is not the impression you were going for."
      }
    ],
    "explain": "Sustained one-way questioning reads as evasive, however warm it is. Balance is part of the skill, not a garnish on it."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_something", "label": "Put something in", "description": "Disclosed something non-trivial rather than only asking." },
      { "key": "tracked_balance", "label": "Noticed the asymmetry", "description": "Was aware of how lopsided the exchange had become." },
      { "key": "not_a_hijack", "label": "Disclosed without taking over", "description": "Gave something without turning the conversation into their own monologue." },
      { "key": "timed_it", "label": "Offered it at a natural point", "description": "Put it in at a gap rather than interrupting the partner's answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A long queue for coat check at the end of an event. Fifteen minutes of standing still with someone you met inside.",
    "partner": {
      "name": "Ade",
      "role": "someone you were introduced to briefly during the evening",
      "personality": "Generous and forthcoming, answers everything fully, and gradually becomes wary if nothing comes back the other way.",
      "mood": "Relaxed and talkative, ready to go home.",
      "openness": 4
    },
    "opening_beat": "Ade answers your question about the event at length and then waits, quite obviously leaving space for you.",
    "success_looks_like": "The user notices the space and puts something real of their own in, after which Ade becomes warmer and the conversation balances out.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Answer questions generously for the first two exchanges, then leave an obvious pause after each answer.",
      "If the user asks a third question without disclosing anything, give a noticeably shorter answer and let the energy drop.",
      "When the user discloses something about themselves, warm up immediately and ask them a question back."
    ]
  }$j$::jsonb,
  $md$In one conversation today, make sure the other person leaves knowing one real thing about you. Log what you told them and when you chose to say it.$md$
),
(
  (select id from public.skills where slug = 'reciprocity'),
  2,
  'Match the depth they offered',
  $md$Disclosure has a depth, and the rule is to meet the level you were given before you go past it.

If someone mentions they had a busy weekend, replying with the state of your marriage is not generous, it is a collision. If someone tells you something genuinely difficult and you reply with a comment about the weather, you have declined an offer without meaning to.

**The move:** notice the depth of what they handed you, and put something down beside it at roughly the same level.

Depth is easier to read than it sounds. Facts about their week are shallow. Opinions are a step down. Things they got wrong, worried about, or have not decided yet are deeper still. You are aiming to land on the same shelf, not to win.

Mismatching upwards is the more common error, and it is the one that makes people take a small step back.$md$,
  $j$[
    {
      "situation": "They mention their commute has been miserable this week.",
      "line": "Mine too. I have started leaving twenty minutes earlier just to get a seat, which feels like losing.",
      "why": "Same shelf. A small complaint met with a small complaint, plus one specific detail so it is not just agreement."
    },
    {
      "situation": "They say they nearly quit their job in February and did not.",
      "line": "I did quit mine, about two years ago, and spent six months wondering if it had been a mistake.",
      "why": "They offered something with real doubt in it, so this meets it with real doubt rather than with an anecdote."
    },
    {
      "situation": "They mention offhand that they have been having a hard year.",
      "line": "That is a lot to be carrying around while making small talk at a party.",
      "why": "Meeting depth does not always mean matching it with your own story. Acknowledging the weight is sometimes the right-sized response."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone says: honestly, I have been finding this year quite lonely since the move. Which reply matches the depth?",
    "options": [
      {
        "text": "Moving is stressful. Did you get a good place in the end?",
        "correct": false,
        "note": "Takes a genuine disclosure and answers the logistics. They offered something real and got a practical question back."
      },
      {
        "text": "I felt exactly the same for about a year after I moved. It took much longer than I expected.",
        "correct": true,
        "note": "Same shelf, and specific enough to be a real disclosure rather than a polite noise. They now know they are not being strange."
      },
      {
        "text": "That must be really hard.",
        "correct": false,
        "note": "Sympathetic but empty-handed. It acknowledges without offering, which leaves them alone in the disclosure they just made."
      },
      {
        "text": "My whole family relocated when I was nine and I have never really felt settled anywhere since.",
        "correct": false,
        "note": "Overshoots. Their admission was about this year; this replies with a life thesis and quietly moves the subject to you."
      }
    ],
    "explain": "Land on the same shelf. Answering depth with logistics declines the offer, and answering it with more depth takes the conversation over."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_the_depth", "label": "Read the level offered", "description": "Judged how much the partner had actually put on the table." },
      { "key": "matched_it", "label": "Landed on the same shelf", "description": "Offered something of comparable weight rather than much lighter or much heavier." },
      { "key": "was_specific", "label": "Was specific", "description": "Gave a real detail rather than a general agreement." },
      { "key": "did_not_take_over", "label": "Did not take the subject", "description": "Matched the disclosure and handed the conversation back." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The last twenty minutes of a long coach journey. You have been talking on and off since the service station.",
    "partner": {
      "name": "Frances",
      "role": "the person in the next seat",
      "personality": "Warms up in stages and tests each stage. Offers something slightly more personal each time it is met properly, and retreats a level if it is not.",
      "mood": "Tired, unhurried, in a talking mood.",
      "openness": 4
    },
    "opening_beat": "Frances mentions she is travelling back from seeing family, and that these visits are always a bit more complicated than she expects.",
    "success_looks_like": "The user meets each disclosure at its own level, and Frances steadily goes deeper across the conversation.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Start with mild disclosures. Go one level deeper each time the user matches you properly.",
      "If the user replies with logistics or empty sympathy, retreat to a shallower level and stay there for a turn.",
      "If the user overshoots with something much heavier than you offered, become briefly formal and change the subject."
    ]
  }$j$::jsonb,
  $md$Today, notice the depth of one thing someone tells you, and answer at the same level. Log what they offered and what you put beside it.$md$
),
(
  (select id from public.skills where slug = 'reciprocity'),
  3,
  'Then go one step further',
  $md$Matching keeps a conversation level. Going one step past what you were given is what makes it deepen.

After you have met their disclosure, add slightly more than they gave. Not a leap — one step. They mention a job they did not enjoy; you mention a job you did not enjoy and why you stayed too long anyway. That extra clause is the whole technique.

**The move:** meet them, then add one thing you did not have to say.

This is how conversations escalate in intimacy without either person deciding to. Each round, someone goes one step past, and the other person is now free to do the same. Nobody has to be brave, because nobody is ever more than one step out.

The risk is going two steps instead of one, which turns a conversation into a confession and puts the other person in the position of having to respond kindly rather than honestly.$md$,
  $j$[
    {
      "situation": "They mentioned finding their new team hard to read.",
      "line": "Same when I started. I spent about three months assuming everyone quietly disliked me, which turned out to be entirely invented.",
      "why": "Matches the disclosure, then adds an admission that was not required. The extra clause is the step."
    },
    {
      "situation": "They said they nearly did not come out tonight.",
      "line": "Nor did I. I have got quite good at talking myself out of things and I am trying to stop.",
      "why": "Meets the small confession and adds a slightly larger one about a pattern rather than an evening."
    },
    {
      "situation": "They mention they are not really in touch with anyone from school.",
      "line": "Nor me. I used to think that meant something was wrong with me, and now I think it is just what happens.",
      "why": "Adds the interpretation rather than more facts. Saying what you thought it meant about you is usually the step."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "They say: I took a year out between jobs, which sounds better than it was. What is the strongest reply?",
    "options": [
      {
        "text": "I did the same. Best decision I ever made, honestly.",
        "correct": false,
        "note": "Matches the fact and contradicts the feeling. They said it was worse than it sounds and you have cheerfully overruled them."
      },
      {
        "text": "What made it not as good as it sounds?",
        "correct": false,
        "note": "A decent question, and it keeps you empty-handed. They disclosed; a question back leaves them still exposed."
      },
      {
        "text": "I had six months between jobs and told everyone it was intentional. It was not.",
        "correct": true,
        "note": "Matches the disclosure and adds the admission underneath it. The second sentence is the step past."
      },
      {
        "text": "Time off is underrated. People do not take enough of it.",
        "correct": false,
        "note": "A general opinion instead of a personal disclosure. It sounds agreeable while giving nothing away."
      }
    ],
    "explain": "Meet what they gave, then add one clause you did not have to. That extra clause is what lets the conversation deepen."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "met_then_added", "label": "Met them, then went further", "description": "Matched the disclosure and added something extra rather than only matching." },
      { "key": "one_step_only", "label": "Went one step, not three", "description": "Escalated by a single notch rather than turning it into a confession." },
      { "key": "said_the_unflattering", "label": "Gave something real", "description": "The extra part cost something, rather than being a flattering detail." },
      { "key": "handed_it_back", "label": "Left room for them", "description": "Finished in a way that let the partner take the next step." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A kitchen at the end of a dinner party. Everyone else has moved to the other room and you are both stacking plates.",
    "partner": {
      "name": "Joel",
      "role": "a friend of the hosts you have met twice before",
      "personality": "Reciprocates precisely. Goes exactly as far as the other person goes and no further, so the conversation only deepens if the user escalates first.",
      "mood": "Comfortable, slightly reflective, in no hurry.",
      "openness": 4
    },
    "opening_beat": "Joel says he has been thinking about leaving the city, and that he has been thinking about it for about three years now.",
    "success_looks_like": "The user matches Joel's disclosure and adds one step past it, and Joel does the same in return, so the conversation deepens by degrees.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Mirror the user's depth exactly. If they disclose one step further, do the same on your next turn.",
      "If the user only asks questions, stay at the same shallow level indefinitely and do not volunteer more.",
      "If the user jumps several steps at once, become slightly formal and pull back a level."
    ]
  }$j$::jsonb,
  $md$Today, match one disclosure and then add a clause you did not have to say. Log what they gave you, what you matched, and what you added.$md$
),
(
  (select id from public.skills where slug = 'reciprocity'),
  4,
  'What counts as non-trivial',
  $md$People asked to disclose something about themselves reliably produce facts, and facts are not disclosure.

*I have two brothers. I studied history. I live in the north of the city.* All true, all unrevealing. Anyone could learn these from a form. Nothing in them tells you what the person is like, which is what disclosure is for.

**The move:** say something that could be disagreed with, or that you would slightly rather they did not know.

Three reliable categories. Opinions you actually hold, including mildly unpopular ones. Things you found harder than you expected. Things you want but have not got. Any of those three tells someone more than an hour of biography.

The test is simple: if the sentence could appear on a passport or a CV, it is not disclosure. If saying it makes you feel very slightly exposed, it is.$md$,
  $j$[
    {
      "situation": "The conversation is on where you both grew up.",
      "line": "I liked it, which I gather is the wrong answer. Most people I meet seem to have escaped somewhere.",
      "why": "A fact would be the place name. This is an opinion that is mildly against the grain, so it invites a real response rather than a nod."
    },
    {
      "situation": "They ask what you do and you have just answered.",
      "line": "I am reasonably good at it and not at all sure I want to still be doing it in five years.",
      "why": "Adds doubt to the job title. Uncertainty about the future is the most available non-trivial thing most people are carrying."
    },
    {
      "situation": "They mention they have been learning something new.",
      "line": "I have wanted to do that for years and keep not starting. I think I am waiting to be less bad at it before I begin, which does not work.",
      "why": "A want you have not acted on, plus the reason. Both categories at once, and it is warm rather than heavy."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which of these is actual self-disclosure rather than biography?",
    "options": [
      {
        "text": "I have lived here about six years.",
        "correct": false,
        "note": "A fact with no view attached. It could be printed on a form."
      },
      {
        "text": "I work in logistics, mostly on the software side.",
        "correct": false,
        "note": "A more precise fact. Precision is not the same as revealing anything about what you are like."
      },
      {
        "text": "I moved here for a job I ended up hating, and stayed because I liked the city more than I expected.",
        "correct": true,
        "note": "Contains a mistake, a feeling and a change of mind. All three are things you would slightly rather not volunteer, which is what makes them disclosure."
      },
      {
        "text": "I studied engineering but never really used it.",
        "correct": false,
        "note": "Closest of the wrong answers, since never really used it hints at something. But it stops just before saying how you feel about that."
      }
    ],
    "explain": "If it could go on a CV, it is biography. If saying it costs you something small, it is disclosure."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_biography", "label": "Went past biography", "description": "Offered an opinion, a difficulty or a want rather than a fact about themselves." },
      { "key": "slightly_exposing", "label": "Cost something small", "description": "The disclosure carried a little risk rather than being entirely safe." },
      { "key": "kept_it_light", "label": "Stayed easy to receive", "description": "Revealed something real without making it heavy to respond to." },
      { "key": "invited_response", "label": "Left them somewhere to go", "description": "The disclosure gave the partner something to agree with, disagree with or match." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A work away-day, the awkward hour before dinner. You have been put on the same table as someone from another office.",
    "partner": {
      "name": "Rhian",
      "role": "a colleague from a different office you have never met",
      "personality": "Exchanges biography fluently and will trade facts all evening quite happily. Becomes a completely different and much better conversationalist the moment someone says something with a view in it.",
      "mood": "Professionally pleasant, privately bored.",
      "openness": 3
    },
    "opening_beat": "Rhian tells you which office she is from, how long she has been there, and what her team does. All three are facts.",
    "success_looks_like": "The user breaks the biography exchange with an opinion or an admission, and Rhian drops the professional register and becomes a real person.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Trade facts for as long as the user does, matching their register exactly.",
      "When the user offers an opinion, a difficulty or something they want, respond in kind and become noticeably more relaxed and specific.",
      "Never be the first to move past biography."
    ]
  }$j$::jsonb,
  $md$Today, tell someone one thing about yourself that could not go on a CV. An opinion, something you found hard, or something you want. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'reciprocity'),
  5,
  'When you have said too much',
  $md$Occasionally you will go too far. A disclosure lands heavier than you intended, the register drops, and there is a small silence with a different texture to the others.

The instinct is to apologise or to explain, and both make it worse. Apologising asks the other person to reassure you, which turns your overshare into their job. Explaining extends the thing you already wish you had said less about.

**The move:** name it lightly, put a floor under it, and hand the conversation back.

*Anyway, that was more than you asked for.* Said with a bit of humour and without embarrassment, that repairs the moment almost completely, because it shows you noticed. What people find awkward is not the overshare itself. It is the sense that the other person did not realise.

And sometimes it is not an overshare at all. Sometimes it landed fine and you have simply spooked yourself, which is worth learning to tell apart.$md$,
  $j$[
    {
      "situation": "You have just said considerably more about a difficult period than the moment warranted.",
      "line": "Anyway. That is a lot for a Tuesday. What were you saying about the trip?",
      "why": "Names it, does not apologise, and hands them back the thread they were on. The whole repair takes four seconds."
    },
    {
      "situation": "You notice them go quiet after something you said.",
      "line": "I have made that sound bleaker than it is, honestly.",
      "why": "Puts a floor under it without retracting it. This gives them permission to stop being careful with you."
    },
    {
      "situation": "You said something quite personal and they responded warmly.",
      "line": "(nothing — carry on as normal)",
      "why": "It landed fine. Retroactively apologising for a disclosure that was well received is how you make it awkward after the fact."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have just overshared slightly and there is an odd pause. What is the best repair?",
    "options": [
      {
        "text": "Sorry, that was too much, I do not know why I said that.",
        "correct": false,
        "note": "Now they have to reassure you. Your discomfort has become their responsibility, which is a bigger imposition than the overshare was."
      },
      {
        "text": "Note it lightly and hand the conversation back to them.",
        "correct": true,
        "note": "Shows you noticed, refuses to make it a crisis, and returns the floor. This repairs almost any overshare."
      },
      {
        "text": "Explain the background so it makes more sense.",
        "correct": false,
        "note": "More detail about the thing you already said too much about. The pause gets longer, not shorter."
      },
      {
        "text": "Say nothing and hope it passes.",
        "correct": false,
        "note": "Sometimes fine, but if the pause was real, silence lets it set. The awkwardness comes from seeming not to have noticed."
      }
    ],
    "explain": "People forgive an overshare easily. What they find uncomfortable is the sense that you did not notice it happening."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_the_shift", "label": "Noticed the register change", "description": "Registered that the disclosure had landed heavier than intended." },
      { "key": "did_not_apologise", "label": "Repaired without apologising", "description": "Named it lightly rather than asking the partner for reassurance." },
      { "key": "handed_back", "label": "Returned the floor", "description": "Gave the conversation back to the partner rather than continuing to explain." },
      { "key": "did_not_overcorrect", "label": "Did not overcorrect", "description": "Where the disclosure had actually landed fine, carried on rather than retroactively apologising." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A quiet corner at a colleague's leaving drinks. You have been talking to someone you like but do not know well.",
    "partner": {
      "name": "Kit",
      "role": "someone from your wider team",
      "personality": "Kind and slightly awkward. Goes quiet when a conversation gets heavier than expected, and recovers instantly if the other person handles it lightly.",
      "mood": "Sociable but a bit drained by the week.",
      "openness": 3
    },
    "opening_beat": "Kit asks, entirely casually, how your year has been going.",
    "success_looks_like": "The user says more than the question invited, notices the shift, and repairs it lightly without apologising, after which the conversation recovers.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user discloses something heavy, go quiet for a beat and respond carefully rather than warmly.",
      "If the user then repairs it lightly and hands the conversation back, relax immediately and pick the thread back up.",
      "If the user apologises at length or keeps explaining, become more careful and formal."
    ]
  }$j$::jsonb,
  $md$Today, notice one moment where you said more than the question invited. Repair it lightly rather than apologising, or leave it if it landed fine. Log which it was.$md$
);

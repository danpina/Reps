-- Dating apps, track 1: The first message. Five lessons.
--
-- The scenarios put the profile in the setting rather than in a partner's
-- mouth, because on an app you are answering a page rather than a person. The
-- partner still exists — they reply eventually, and the alternates are inline.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'first-message'),
  1,
  'Hey is not a message',
  $md$It is not rude and it is not lazy. It simply does not contain anything.

A message has to be answerable. *Hey* asks the other person to invent a conversation from nothing, decide what you might be interested in, and carry the first three exchanges on their own. They have eleven other people asking them to do that this week, and the ones who get answered are the ones who made it easy.

**The move:** put one specific thing in it that they can answer in a sentence.

Specific is the word doing the work, not clever. A question about the actual thing in their third photo is better than anything you could compose, because it proves you looked and because it has an obvious answer. Nobody has ever failed to reply because a message was not witty enough.

The other reason it works is what it says about you. A message that could have been sent to anybody tells them it probably was, and every profile has met a dozen of those already this month.$md$,
  $j$[
  {
    "situation": "Their profile mentions a month spent cycling in Peru.",
    "line": "Was Peru the sort of trip you would do again, or the sort you are glad you did once?",
    "why": "One thing off the profile, one question, and either answer is easy. It also happens to be a question most people enjoy answering."
  },
  {
    "situation": "Three photos, one of which is them holding an enormous fish.",
    "line": "I have questions about the fish.",
    "why": "Not technically a question and entirely answerable. It is specific, it is warm, and it hands them an obvious next line."
  },
  {
    "situation": "You have typed hey and are about to send it.",
    "line": "(open the profile again and find one thing)",
    "why": "The fix takes fifteen seconds. Almost every profile has one concrete oddity in it, and that oddity is the whole message."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why does hey get so few replies?",
    "options": [
      {
        "text": "It contains nothing to answer, so replying is work.",
        "correct": true,
        "note": "Structural rather than rude. The reader has to invent the conversation, decide what you might want, and carry it — from a message that gave them none of that."
      },
      {
        "text": "It looks lazy.",
        "correct": false,
        "note": "It does, and plenty of lazy-looking messages get replies when they are answerable. Effort is not what is being measured."
      },
      {
        "text": "Everybody sends it.",
        "correct": false,
        "note": "True and secondary. It would still be hard to answer if you were the only person who ever sent it."
      },
      {
        "text": "It is too short.",
        "correct": false,
        "note": "Short is good. Three words about their actual photo outperforms three sentences about nothing."
      }
    ],
    "explain": "A message has to be answerable. Everything else about it matters less."
  },
  {
    "prompt": "Their profile says almost nothing and the photos are unremarkable. Now what?",
    "options": [
      {
        "text": "Send something general and hope.",
        "correct": false,
        "note": "Which is where you started. An unremarkable profile is a reason to look harder, not a reason to give up on looking."
      },
      {
        "text": "Ask about the most concrete thing in any of them, however small.",
        "correct": true,
        "note": "There is always one. A jacket, a place, a dog, a background — the smallness is fine, because the specificity is what is doing the work rather than the subject."
      },
      {
        "text": "Ask what they are looking for on here.",
        "correct": false,
        "note": "Answerable, and it is the question everybody asks, and it makes them do the work of describing themselves to a stranger."
      },
      {
        "text": "Skip the match.",
        "correct": false,
        "note": "A reasonable filter for some people and not a lesson about messaging. Sparse profiles reply as often as full ones."
      }
    ],
    "explain": "Every profile has one concrete thing in it. Find it and the message writes itself."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "specific",
      "label": "Used something only their profile could give",
      "description": "Referred to a concrete detail rather than anything that could have been sent to anybody."
    },
    {
      "key": "answerable",
      "label": "Was answerable in a sentence",
      "description": "Left an obvious reply rather than asking them to invent one."
    },
    {
      "key": "short",
      "label": "Kept it short",
      "description": "Wrote a message rather than a paragraph."
    },
    {
      "key": "not_clever",
      "label": "Chose specific over clever",
      "description": "Did not spend the message trying to be impressive."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A new match. Their profile: four photos — one on a bike loaded with panniers, one in a kitchen holding a very flat loaf of sourdough, two with a border collie. The text says only: cycled to Peru, badly. Ask me about the bread.",
  "partner": {
    "name": "Sena",
    "role": "somebody you have just matched with",
    "personality": "Dry and quick to reply to anything specific. Ignores anything that could have been sent to anybody.",
    "mood": "On the app in the evenings, not desperately.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Senan",
      "role": "somebody you have just matched with",
      "personality": "Dry and quick to reply to anything specific. Ignores anything that could have been sent to anybody.",
      "mood": "On the app in the evenings, not desperately.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The match notification comes up. The message box is empty and it is your turn.",
  "success_looks_like": "The user sends something specific and answerable rather than something general.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Reply warmly and quickly to anything specific, and briefly to anything generic.",
    "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
    "Never send the first message."
  ]
}$j$::jsonb,
  $md$Open your app and rewrite one message you were about to send as hey. One specific thing, one question, under thirty words. Log what you changed it to.$md$
),
(
  (select id from public.skills where slug = 'first-message'),
  2,
  'Read for the oddity, not the summary',
  $md$People read a profile the way they read a CV, and it is the wrong document.

The summary is what somebody wants you to know: the job, the height, the tidy list of interests. It is also what they wrote for everybody, so a message about it is a message about the version of them that is public.

**The move:** find the oddest concrete thing on the page and ask about that.

The flat loaf. The fish. The dog wearing something. The one sentence that does not fit the others. Oddities are good targets for three separate reasons: they were chosen deliberately, so there is a story attached; almost nobody asks about them, so you are not the fourth person today; and they are easy to answer without having to be impressive back.

The opposite move — asking about the most impressive thing — is the one that fails. Somebody whose profile mentions a marathon has been asked about the marathon by everybody, and the honest version of their answer got boring for them in about March.$md$,
  $j$[
  {
    "situation": "Their profile lists a marathon, a promotion, and a photo of a very bad haircut in 2009.",
    "line": "2009 was a difficult year for a lot of us.",
    "why": "The haircut is the deliberate one — nobody keeps that photo by accident. The marathon has been asked about forty times."
  },
  {
    "situation": "Six normal photos and one of them holding a trophy for something unreadable.",
    "line": "What is the trophy for? I have decided it is for something extremely niche.",
    "why": "A concrete oddity, an easy answer, and a small joke that does not need tone to land because it is attached to a real object."
  },
  {
    "situation": "You are drafting a message about the impressive thing.",
    "line": "(find the second most interesting thing instead)",
    "why": "The impressive thing is the one everybody picks. Being the person who noticed something else is most of the advantage available in a first message."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why is the most impressive thing on a profile a weak target?",
    "options": [
      {
        "text": "It might sound like flattery.",
        "correct": false,
        "note": "A minor risk. The real problem is that the reply is rehearsed rather than that the question is fawning."
      },
      {
        "text": "You might not understand it.",
        "correct": false,
        "note": "Not understanding is fine and often a good opening. This is not why the impressive thing fails."
      },
      {
        "text": "Everybody asks about it, and answering it is now a chore.",
        "correct": true,
        "note": "They have given that answer many times and stopped enjoying it. You arrive as the fourth person this week asking the same thing."
      },
      {
        "text": "It is usually exaggerated.",
        "correct": false,
        "note": "Sometimes, and irrelevant. The question would still be tired if every word of it were true."
      }
    ],
    "explain": "The impressive thing is the crowded one. The odd thing is the one nobody else picked."
  },
  {
    "prompt": "What makes an oddity a good target?",
    "options": [
      {
        "text": "It is funny.",
        "correct": false,
        "note": "Often, and that is a side effect. Plenty of good targets are simply strange rather than amusing."
      },
      {
        "text": "It shows you read carefully.",
        "correct": false,
        "note": "It does, and that is the smaller half. Effort is worth less than the fact that they wanted to talk about it."
      },
      {
        "text": "It is easier to write about.",
        "correct": false,
        "note": "Usually true and not the reason it works. It works because of what it does for them."
      },
      {
        "text": "It was chosen deliberately, so there is a story behind it.",
        "correct": true,
        "note": "Nobody keeps an odd photo by accident. It is on the page because they wanted somebody to ask, which makes you the person who did."
      }
    ],
    "explain": "An oddity is on the page on purpose. Asking about it is accepting an invitation."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "found_oddity",
      "label": "Found the odd thing",
      "description": "Picked a deliberate, concrete detail rather than the headline."
    },
    {
      "key": "avoided_crowd",
      "label": "Avoided the crowded target",
      "description": "Did not ask about the thing everybody asks about."
    },
    {
      "key": "easy_answer",
      "label": "Left an easy answer",
      "description": "Asked something they could reply to without performing."
    },
    {
      "key": "read_it",
      "label": "Proved they read it",
      "description": "Referred to something that could only have come from this profile."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A profile: half marathon finisher, works in insurance, likes travel and good food. Five polished photos, and a sixth of a chipped garden gnome on a windowsill with no explanation.",
  "partner": {
    "name": "Marguerite",
    "role": "somebody you have just matched with",
    "personality": "Polite and a bit tired of the app. Comes alive the moment somebody asks about the gnome.",
    "mood": "Half-scrolling, low expectations.",
    "openness": 3,
    "sex": "female",
    "alt": {
      "name": "Marek",
      "role": "somebody you have just matched with",
      "personality": "Polite and a bit tired of the app. Comes alive the moment somebody asks about the gnome.",
      "mood": "Half-scrolling, low expectations.",
      "openness": 3,
      "sex": "male"
    }
  },
  "opening_beat": "You have matched. The profile is open in front of you and the box is empty.",
  "success_looks_like": "The user asks about the gnome rather than the half marathon.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Answer a question about the half marathon politely and briefly, with no energy at all.",
    "Answer a question about the gnome at length and with obvious delight.",
    "Write the way people write on apps: short, informal, no paragraphs."
  ]
}$j$::jsonb,
  $md$Open three profiles you have matched with and find the oddest concrete thing on each. Do not send anything yet. Log the three oddities and whether you would have spotted them before.$md$
),
(
  (select id from public.skills where slug = 'first-message'),
  3,
  'One question, not three',
  $md$A message carrying three questions gets one answered, and it is never the one you cared about.

It happens for a good reason: you are trying to give them options, so that if one lands flat there is something else to reach for. What actually arrives at their end is a form. They pick whichever is quickest, the other two evaporate, and the reply is shorter than it would have been if you had asked nothing at all.

**The move:** ask one thing, and let the rest of the message be short.

Under thirty words is a good ceiling and most good first messages are well under it. Length is also a signal you do not control: a paragraph tells them this conversation will be effortful before it has started, and matching the length they write at is worth more than anything you could add to it.

The other reason to hold at one question is that it forces you to decide what you are actually curious about. Three questions is usually somebody who has not decided, and that comes through.$md$,
  $j$[
  {
    "situation": "You have drafted: how was Peru? Do you still cycle? What do you do for work?",
    "line": "Was Peru the sort of trip you would do again?",
    "why": "One question, the most interesting of the three, and now the reply has room to be long. The other two are still available later, which is what a conversation is for."
  },
  {
    "situation": "You want to ask about the bread and the dog.",
    "line": "The bread first, obviously.",
    "why": "Naming the choice is warmer than making it silently, and it hands them the second subject without spending a question on it."
  },
  {
    "situation": "Your message has run to four lines and you have not asked anything yet.",
    "line": "(cut everything before the question)",
    "why": "The preamble is almost always the part you wrote while deciding. It rarely survives being read and never survives being cut."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "You ask three questions. What comes back?",
    "options": [
      {
        "text": "An answer to the easiest one, and the other two are gone.",
        "correct": true,
        "note": "People answer the cheapest question in a message and move on. You have not tripled your chances, you have chosen the least interesting one on their behalf."
      },
      {
        "text": "Three short answers.",
        "correct": false,
        "note": "Occasionally, and short is the problem. Three sentences that each answer a third of a form is a worse reply than one real one."
      },
      {
        "text": "A longer reply, since there is more to respond to.",
        "correct": false,
        "note": "The opposite. More questions reliably produce shorter replies, because a message that feels like a form gets answered like one."
      },
      {
        "text": "Nothing, usually.",
        "correct": false,
        "note": "Too pessimistic. Three questions is a weaker message rather than a fatal one."
      }
    ],
    "explain": "One question gets a real answer. Three gets the cheapest one."
  },
  {
    "prompt": "What should the rest of the message be?",
    "options": [
      {
        "text": "Something about you, so it is not one-sided.",
        "correct": false,
        "note": "That belongs in the third or fourth message. In the first it is a paragraph about a stranger, unasked for."
      },
      {
        "text": "Short — ideally nothing much at all.",
        "correct": true,
        "note": "Almost every good first message is the question plus very little. The preamble is the part written while deciding, and it does not survive being read."
      },
      {
        "text": "A compliment, to soften the question.",
        "correct": false,
        "note": "The question does not need softening, and a compliment in a first message is the most common thing in their inbox."
      },
      {
        "text": "Context for why you are asking.",
        "correct": false,
        "note": "The question carries its own context. Explaining it doubles the length and adds nothing to answer."
      }
    ],
    "explain": "The question is the message. Everything else is what you wrote while working out the question."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "one_question",
      "label": "Asked one thing",
      "description": "Held to a single question rather than offering a menu."
    },
    {
      "key": "chose_well",
      "label": "Chose the interesting one",
      "description": "Kept the question worth answering rather than the safest."
    },
    {
      "key": "short",
      "label": "Cut the preamble",
      "description": "Did not spend the message getting to the question."
    },
    {
      "key": "left_room",
      "label": "Left room for a real answer",
      "description": "Asked something that could be answered at length if they wanted to."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A match with plenty on the profile: a half-finished van conversion, a photo from a food market in Palermo, and a line about having recently taken up the cello badly.",
  "partner": {
    "name": "Iona",
    "role": "somebody you have just matched with",
    "personality": "Chatty when asked one thing, terse when handed a list. Replies at the length she is written to.",
    "mood": "Happy to be messaging, in no hurry.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Ioan",
      "role": "somebody you have just matched with",
      "personality": "Chatty when asked one thing, terse when handed a list. Replies at the length he is written to.",
      "mood": "Happy to be messaging, in no hurry.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "Three obvious things to ask about and one empty box.",
  "success_looks_like": "The user picks one and lets the message be short.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "If asked more than one question, answer only the shortest, briefly.",
    "If asked one question, answer it properly and add something unprompted.",
    "Write the way people write on apps."
  ]
}$j$::jsonb,
  $md$Take a message you have drafted with more than one question in it and cut it to one. Send that. Log which question you kept and how long the reply was.$md$
),
(
  (select id from public.skills where slug = 'first-message'),
  4,
  'When the profile says nothing',
  $md$Three photos, no text, and a match. This is the case people say is impossible, and it is the one with the least competition.

An empty profile gets fewer messages, and the ones it gets are worse — because everybody who opens it concludes there is nothing to work with and sends hey. The bar is on the floor.

**The move:** ask about what they chose to be in the photo, not about the photo.

Somebody picked those three images out of a thousand. The background is a place they went, the jacket is one they own, the dog is theirs or somebody's they like enough to be photographed with. Any of those is a question, and each one carries the same proof of attention that a text-based profile would have given you for free.

The one thing to avoid is commenting on how they look. It is the entire content of their inbox, it is unanswerable except with thank you, and on an empty profile it confirms the only thing they can currently assume about you.$md$,
  $j$[
  {
    "situation": "Three photos, no text. One is clearly taken on a ferry.",
    "line": "That looks like a ferry with real weather. Where were you going?",
    "why": "A concrete detail from the image and an easy answer. It also proves you did more than swipe, which on an empty profile is unusual enough to be the whole message."
  },
  {
    "situation": "All three photos are indoors and give away almost nothing.",
    "line": "Your kitchen has more plants than mine has room. How many are still alive?",
    "why": "A background detail is still a detail. The smallness is the point — nobody else looked that hard."
  },
  {
    "situation": "You are about to say they look nice.",
    "line": "(find something in the photo instead)",
    "why": "It is the one message an empty profile definitely already has, and the only available reply is thank you."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why is an empty profile easier than it looks?",
    "options": [
      {
        "text": "They are more likely to reply out of boredom.",
        "correct": false,
        "note": "No evidence for it, and it is not the mechanism. The advantage is what everybody else sent."
      },
      {
        "text": "There is less to get wrong.",
        "correct": false,
        "note": "There is less to work with, which is a different thing. The advantage is comparative rather than absolute."
      },
      {
        "text": "Everybody else gave up and sent hey.",
        "correct": true,
        "note": "The competition is worse here than anywhere. One question about something actually in a photo puts you ahead of the entire inbox."
      },
      {
        "text": "It means they are new to the app.",
        "correct": false,
        "note": "Sometimes, and it changes nothing about what to write."
      }
    ],
    "explain": "An empty profile has a worse inbox than a full one. That is the opportunity."
  },
  {
    "prompt": "Why not open with a compliment on how they look?",
    "options": [
      {
        "text": "It is inappropriate.",
        "correct": false,
        "note": "It is usually not, on an app built for exactly this. The problem is mechanical rather than moral."
      },
      {
        "text": "They will assume you did not read the profile.",
        "correct": false,
        "note": "There is no profile to read. That is the premise."
      },
      {
        "text": "It sets the wrong tone for later.",
        "correct": false,
        "note": "A small effect, and it is downstream of the real problem, which is that nothing can be said back."
      },
      {
        "text": "It is unanswerable — the only reply is thank you.",
        "correct": true,
        "note": "And it is the majority of what is already there. A message with no available reply is the same failure as hey, wearing something nicer."
      }
    ],
    "explain": "Anything whose only reply is thank you is not a message."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "used_a_photo",
      "label": "Used something in a photo",
      "description": "Found a concrete detail rather than concluding there was nothing."
    },
    {
      "key": "about_the_choice",
      "label": "Asked about the choice, not the picture",
      "description": "Asked about a place, an object or a decision rather than describing the image."
    },
    {
      "key": "no_looks",
      "label": "Did not comment on how they look",
      "description": "Avoided the message with no available reply."
    },
    {
      "key": "answerable",
      "label": "Left an easy answer",
      "description": "Asked something answerable in a sentence."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A match with no text at all. Three photos: one on the deck of a ferry in bad weather, one at a table with an enormous plate of something fried, one in a doorway with a bicycle that has clearly been repainted by hand.",
  "partner": {
    "name": "Robyn",
    "role": "somebody you have just matched with",
    "personality": "Guarded at first, having received a great many messages about how she looks. Opens up immediately to anything about the photos themselves.",
    "mood": "Sceptical, still on the app.",
    "openness": 3,
    "sex": "female",
    "alt": {
      "name": "Ruaridh",
      "role": "somebody you have just matched with",
      "personality": "Guarded at first, having received a great many messages about how he looks. Opens up immediately to anything about the photos themselves.",
      "mood": "Sceptical, still on the app.",
      "openness": 3,
      "sex": "male"
    }
  },
  "opening_beat": "No bio, three photos, and your turn.",
  "success_looks_like": "The user finds something concrete in a photo and asks about the choice behind it.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Reply flatly and briefly to anything about appearance.",
    "Reply warmly and at length to anything about the ferry, the food or the bicycle.",
    "Write the way people write on apps."
  ]
}$j$::jsonb,
  $md$Find a match with an empty profile and send one question about something in a photo. Not about how they look. Log the detail you used.$md$
),
(
  (select id from public.skills where slug = 'first-message'),
  5,
  'Funny without tone',
  $md$Text has no tone, and almost everything people find funny in person depends on it.

Irony is the main casualty. Said out loud, a dry remark is obviously a joke, because your face and your voice do half the work. Typed, it is a sentence that means what it says, and the reader has to decide whether you are joking with no evidence either way. Most people decide you are not, and reply politely to a thing you did not mean.

**The move:** be specific rather than ironic, because specificity survives having no tone.

*I have decided the trophy is for something extremely niche* is funny and cannot be misread — the joke is the invention, and the invention is anchored to a real object on their page. That is the shape that works: a small, obviously untrue idea attached to a specific thing they can see.

What almost never works is a joke about them, in a first message, from a stranger. In person that needs licence you have not got, and in text you also have no tone to soften it with. Aim at the situation, at the object, or at yourself.$md$,
  $j$[
  {
    "situation": "Their profile mentions they run a very serious spreadsheet of every film they watch.",
    "line": "I need to know whether the spreadsheet has conditional formatting.",
    "why": "A small invention anchored to a real thing. It cannot be read as sincere and cannot be read as a criticism, which is exactly what a joke has to manage without tone."
  },
  {
    "situation": "Their photo shows a cake that has visibly collapsed.",
    "line": "Structurally I have questions, but I would still eat it.",
    "why": "Aimed at the object rather than the person. It is warm, it is obviously playful, and the reply writes itself."
  },
  {
    "situation": "You have written something dry that could be read as a criticism.",
    "line": "(rewrite it as an invention rather than an observation)",
    "why": "Observations need tone to be safe. Inventions carry their own signal, because nobody says something obviously untrue by accident."
  }
]$j$::jsonb,
  $j$[
  {
    "prompt": "Why does irony fail in a first message?",
    "options": [
      {
        "text": "There is no tone, so the sentence just means what it says.",
        "correct": true,
        "note": "Your face and voice normally do half the work. In text the reader has no evidence you are joking, and with a stranger the safe assumption is that you are not."
      },
      {
        "text": "People on apps have no sense of humour.",
        "correct": false,
        "note": "The conclusion that stops you improving. The same person would laugh at the same line said out loud."
      },
      {
        "text": "It is too risky with somebody you do not know.",
        "correct": false,
        "note": "Close, and it describes teasing rather than irony. Irony fails on legibility rather than on permission."
      },
      {
        "text": "It takes too many words.",
        "correct": false,
        "note": "Irony is usually shorter than the alternative. Length is not the problem."
      }
    ],
    "explain": "Without tone, an ironic line is just a sincere line you did not mean."
  },
  {
    "prompt": "Which joke is safest in a first message?",
    "options": [
      {
        "text": "A gentle tease about something they said.",
        "correct": false,
        "note": "That needs licence, and a first message has none. It also has no tone to soften it with, which is the second problem."
      },
      {
        "text": "An obviously untrue idea attached to something on their profile.",
        "correct": true,
        "note": "It cannot be read as sincere, because nobody says something obviously untrue by accident, and it is anchored to a real thing so it proves you looked."
      },
      {
        "text": "Self-deprecation.",
        "correct": false,
        "note": "Safe for them and it puts you below the conversation before it starts. Fine in small doses later."
      },
      {
        "text": "A joke about the app itself.",
        "correct": false,
        "note": "Answerable and extremely common. It is the small talk of dating apps and it says nothing about either of you."
      }
    ],
    "explain": "Invention beats observation, and anything anchored to their page beats anything general."
  }
]$j$::jsonb,
  $j${
  "scale": {
    "min": 1,
    "max": 5
  },
  "criteria": [
    {
      "key": "legible",
      "label": "Could not be misread",
      "description": "Wrote something whose playfulness survives having no tone."
    },
    {
      "key": "anchored",
      "label": "Anchored to their page",
      "description": "Attached the joke to a real detail rather than making a general one."
    },
    {
      "key": "not_at_them",
      "label": "Did not aim it at them",
      "description": "Aimed at the object, the situation or themselves rather than at a stranger."
    },
    {
      "key": "still_answerable",
      "label": "Still left a reply",
      "description": "Kept something for them to say back rather than closing with a punchline."
    }
  ]
}$j$::jsonb,
  $j${
  "setting": "A match whose profile includes a photograph of a wildly ambitious and structurally unsound-looking three-tier cake, captioned only: it held.",
  "partner": {
    "name": "Vesna",
    "role": "somebody you have just matched with",
    "personality": "Playful and quick, and reads anything ironic completely straight the first time. Delighted by an obvious invention.",
    "mood": "In a good mood, on the app while watching something.",
    "openness": 4,
    "sex": "female",
    "alt": {
      "name": "Vasil",
      "role": "somebody you have just matched with",
      "personality": "Playful and quick, and reads anything ironic completely straight the first time. Delighted by an obvious invention.",
      "mood": "In a good mood, on the app while watching something.",
      "openness": 4,
      "sex": "male"
    }
  },
  "opening_beat": "The cake photo, the two-word caption, and an empty box.",
  "success_looks_like": "The user writes something playful that cannot be misread as sincere or as a criticism.",
  "constraints": [
    "Stay in character at all times. Never coach, evaluate or break the scene.",
    "Take anything ironic completely literally the first time, politely.",
    "Respond with obvious delight to an invention or an exaggeration about the cake.",
    "Write the way people write on apps."
  ]
}$j$::jsonb,
  $md$Send one message today that is playful and could not be read as sincere — an obvious invention about something on their profile. Log what you wrote and how it was taken.$md$
);

-- ---------------------------------------------------------------------------
-- Modes. Every lesson in the track is a drill, and every one runs free. This is
-- the topic where the format is most honest: writing a message in a box is
-- exactly the thing the lesson is about, in the same medium, with the same
-- amount of time to think.
-- ---------------------------------------------------------------------------

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('first-message', 1, 'line', $j${
  "says": "(their profile: cycled to Peru, badly. Ask me about the bread. Photos — a loaded bike, a very flat sourdough, two of a border collie.)",
  "model": {
    "line": "Was Peru the sort of trip you would do again, or the sort you are glad you did once?",
    "why": "One thing off the profile, one question, and both answers are easy. Nothing in it could have been sent to anybody else, which is the whole test."
  },
  "checks": [
    {
      "kind": "contains_any",
      "requirement": "Use something only their profile could have given you",
      "words": [
        "peru",
        "bread",
        "sourdough",
        "bike",
        "cycl",
        "dog",
        "collie",
        "loaf"
      ]
    },
    {
      "kind": "requires_question",
      "requirement": "Give them something to answer"
    },
    {
      "kind": "max_words",
      "requirement": "Under thirty words. It is a message, not a letter.",
      "n": 30
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-message', 2, 'choice', $j${
  "beats": [
    {
      "situation": "The profile: half marathon finisher, works in insurance, likes travel and good food. Five polished photos, and a sixth of a chipped garden gnome on a windowsill with no explanation.",
      "prompt": "What do you ask about?",
      "options": [
        {
          "text": "The half marathon.",
          "correct": false,
          "note": "The crowded target. They have answered it many times and the honest version stopped being interesting to them months ago."
        },
        {
          "text": "Travel, since it is the easiest to talk about.",
          "correct": false,
          "note": "It is on every profile on the app, which makes it the least revealing thing on this one."
        },
        {
          "text": "The gnome.",
          "correct": true,
          "note": "Deliberate, concrete, and almost certainly unasked. Nobody keeps a photo of a chipped gnome by accident — it is on the page because they want somebody to ask."
        },
        {
          "text": "Insurance, because nobody else will.",
          "correct": false,
          "note": "True, and it is not an oddity, it is a job. There is a difference between unusual and unasked-about-for-a-reason."
        }
      ]
    },
    {
      "situation": "You asked about the gnome and got three paragraphs back.",
      "prompt": "What did that tell you?",
      "options": [
        {
          "text": "They are very chatty.",
          "correct": false,
          "note": "Possibly, and the same person sent one line to everybody who asked about the half marathon."
        },
        {
          "text": "They are keen.",
          "correct": false,
          "note": "Reading interest into it too early. The length is about the subject rather than about you."
        },
        {
          "text": "Nothing much — some people write a lot.",
          "correct": false,
          "note": "Under-reading the strongest feedback you get in this whole topic."
        },
        {
          "text": "You picked the thing they were waiting to be asked about.",
          "correct": true,
          "note": "A reply longer than your message is the clearest signal available on an app. It is also repeatable — every profile has one of these on it."
        }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-message', 3, 'line', $j${
  "says": "(their profile: a half-finished van conversion, a food market in Palermo, and a line about having recently taken up the cello badly)",
  "model": {
    "line": "How badly are we talking, with the cello?",
    "why": "One question, eight words, and no preamble at all. The van and Palermo are still there for the third message, which is what a conversation is for."
  },
  "checks": [
    {
      "kind": "max_questions",
      "requirement": "One question. Three gets you the cheapest answer.",
      "n": 1
    },
    {
      "kind": "requires_question",
      "requirement": "Ask something"
    },
    {
      "kind": "max_words",
      "requirement": "Under twenty-five words — cut the preamble",
      "n": 25
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-message', 4, 'line', $j${
  "says": "(no bio at all. Three photos: a ferry deck in bad weather, an enormous plate of something fried, a hand-repainted bicycle in a doorway.)",
  "model": {
    "line": "That ferry looks like it was properly rough. Where were you going?",
    "why": "A concrete thing they chose to include, and an answer they can give in a sentence. On a profile with no text, this puts you ahead of the entire inbox."
  },
  "checks": [
    {
      "kind": "contains_any",
      "requirement": "Use something in one of the photos",
      "words": [
        "ferry",
        "boat",
        "sea",
        "weather",
        "food",
        "fried",
        "plate",
        "bike",
        "bicycle",
        "paint",
        "doorway"
      ]
    },
    {
      "kind": "forbids_any",
      "requirement": "Nothing about how they look",
      "words": [
        "gorgeous",
        "beautiful",
        "pretty",
        "handsome",
        "cute",
        "stunning",
        "you look",
        "fit",
        "attractive"
      ]
    },
    {
      "kind": "max_words",
      "requirement": "Under twenty-five words",
      "n": 25
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('first-message', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Their profile has a photo of a wildly ambitious three-tier cake, captioned only: it held.",
      "prompt": "Which message lands?",
      "options": [
        {
          "text": "Structurally I have questions, but I would still eat it.",
          "correct": true,
          "note": "Aimed at the cake, obviously playful, and impossible to read as either sincere or unkind. The reply writes itself."
        },
        {
          "text": "Nice cake.",
          "correct": false,
          "note": "Sincere, unanswerable, and it wastes the funniest thing on the page."
        },
        {
          "text": "I see we are a baker then.",
          "correct": false,
          "note": "Dry, and dry needs tone. Without it this is a flat statement that might be a criticism, and they will read it as one."
        },
        {
          "text": "Did you make that yourself?",
          "correct": false,
          "note": "Perfectly fine and the caption already answered it, which tells them you skimmed."
        }
      ]
    },
    {
      "situation": "You sent something ironic and got a polite, literal reply.",
      "prompt": "What happened?",
      "options": [
        {
          "text": "They have no sense of humour.",
          "correct": false,
          "note": "The conclusion that ends the learning. The same person would have laughed at it out loud."
        },
        {
          "text": "They had no way to tell it was a joke.",
          "correct": true,
          "note": "Text carries no tone, so an ironic line is just a sincere line you did not mean. With a stranger the safe reading is always the literal one."
        },
        {
          "text": "The joke was not good enough.",
          "correct": false,
          "note": "Quality is not the variable. A better ironic line has exactly the same problem."
        },
        {
          "text": "You should not joke in a first message.",
          "correct": false,
          "note": "Overcorrecting. Invention works fine in a first message — it is irony specifically that cannot survive."
        }
      ]
    }
  ]
}$j$::jsonb);

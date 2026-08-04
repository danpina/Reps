-- Track 3: Listening & labeling. Say their word back, then stop.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'listening-and-labeling'),
  1,
  'Say their word back to them',
  $md$A label is the cheapest tool in conversation and the one people believe the most.

You take a word they used — their word, not your paraphrase — and you say it back as a statement. *So it was relentless.* That is the whole move. No question mark, no advice, no story of your own.

It works because being understood is rarer than being agreed with. When someone hears their own word returned, they get proof you were actually listening rather than waiting, and the almost automatic response is to explain further.

**The move:** pick their most loaded word, say it back flat, and let them expand.

Use their word exactly. Swapping *relentless* for *stressful* is a downgrade — you have replaced their experience with your summary of it, and they will feel the difference even if they cannot name it.$md$,
  $j$[
    {
      "situation": "They say: it has been a weird few months, honestly.",
      "line": "Weird.",
      "why": "One word, said flat, with nothing after it. Weird is doing a lot of work in their sentence and this hands it straight back for them to unpack."
    },
    {
      "situation": "They say: I finally got out of that job but it took me way too long.",
      "line": "Too long.",
      "why": "Ignores the obvious topic, the job, and picks the part with judgement in it. That is where the real story is."
    },
    {
      "situation": "They say: my family is great, just a lot.",
      "line": "A lot.",
      "why": "Repeats the qualifier rather than the compliment. People bury the true thing in the second half of that kind of sentence."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone says: the move went fine in the end, it was just a nightmare getting there. What is the best label?",
    "options": [
      {
        "text": "That sounds really stressful.",
        "correct": false,
        "note": "It is a label, but you have swapped their word for yours. Nightmare is theirs; stressful is your downgrade of it."
      },
      {
        "text": "Moving is the worst. When I moved last year the van turned up empty.",
        "correct": false,
        "note": "Sympathy plus your own story. Understandable, but you have taken the conversation off them at the exact moment they were opening."
      },
      {
        "text": "A nightmare getting there.",
        "correct": true,
        "note": "Their exact words, returned flat. Almost everyone answers this by explaining what the nightmare actually was."
      },
      {
        "text": "Why was it a nightmare?",
        "correct": false,
        "note": "Close, and it will often work, but a question puts them on the spot where a statement invites them in. Statements get longer answers."
      }
    ],
    "explain": "Use their exact word and drop the question mark. A label is an offer to continue, not a request to explain."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_word", "label": "Used their exact word", "description": "Repeated the partner's own language rather than a paraphrase or upgrade." },
      { "key": "picked_the_loaded_one", "label": "Picked the loaded word", "description": "Chose the word carrying judgement or feeling rather than the obvious topic." },
      { "key": "no_question_mark", "label": "Said it as a statement", "description": "Delivered the label flat rather than turning it into a question." },
      { "key": "no_hijack", "label": "Did not take the conversation back", "description": "Resisted following the label with their own story or with advice." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A pub table on a Wednesday, two drinks in, with someone you know a little through work.",
    "partner": {
      "name": "Nic",
      "role": "a colleague from another department you get on with but do not know well",
      "personality": "Talks readily but stays on the surface unless someone shows they are actually listening. Has a genuinely difficult few months behind the small talk.",
      "mood": "Tired and slightly unguarded.",
      "openness": 4
    },
    "opening_beat": "Nic says the last quarter was fine, just a bit brutal, and looks at their drink.",
    "success_looks_like": "The user labels one of Nic's own loaded words and stops talking, and Nic fills the space with something real.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Always leave exactly one loaded word in each reply for the user to pick up.",
      "When the user says one of your words back as a statement, expand generously and go a level deeper.",
      "If the user gives advice or tells their own story instead, retreat to the surface and become more general."
    ]
  }$j$::jsonb,
  $md$Use one label today. Take someone's own word, say it back as a statement, and say nothing else. Log the word you used and what came out.$md$
),
(
  (select id from public.skills where slug = 'listening-and-labeling'),
  2,
  'Then stop talking',
  $md$The label is the easy half. The hard half is the two seconds afterwards.

Silence in conversation feels much longer to the person who caused it. Two seconds feels like ten, and the reflex is to rescue it — add a follow-up, soften it into a question, laugh. Every one of those takes the pressure off the other person, and the pressure was the point.

People fill silence. It is close to automatic. If you say their word back and then wait, they will almost always keep going, and the thing they say next is usually more honest than the thing before it, because it was not planned.

**The move:** after the label, count two slow beats before you allow yourself to speak.

You are not being cold. You are giving them the floor and then actually leaving it empty long enough for them to walk onto it.$md$,
  $j$[
    {
      "situation": "You said their word back and they have gone quiet for a second.",
      "line": "(nothing — hold eye contact, stay relaxed)",
      "why": "The pause is the technique. A relaxed face turns silence from an accusation into an invitation."
    },
    {
      "situation": "You labelled, they said one short sentence, and stopped again.",
      "line": "(still nothing — small nod)",
      "why": "A nod is not talking. It keeps the floor with them while proving you have not checked out."
    },
    {
      "situation": "You have waited a genuine three seconds and they have not continued.",
      "line": "Sorry, that was a lot to land on you.",
      "why": "If the silence really is not going to be filled, take the awkwardness onto yourself rather than leaving it sitting on them."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You label someone's word and they pause. What should you do?",
    "options": [
      {
        "text": "Wait, keeping your face relaxed.",
        "correct": true,
        "note": "The pause is the tool. Almost everyone fills it within a couple of seconds, and what they say is usually the honest version."
      },
      {
        "text": "Add a follow-up question to help them along.",
        "correct": false,
        "note": "This is the most common way the technique gets ruined. Your question takes the pressure off and replaces their answer with yours."
      },
      {
        "text": "Fill it with something about yourself.",
        "correct": false,
        "note": "It rescues your own discomfort at the cost of theirs. The floor was theirs and you have taken it back."
      },
      {
        "text": "Rephrase the label in case they did not understand.",
        "correct": false,
        "note": "They understood. Rephrasing signals that you found the silence unbearable, which makes the next one harder to hold."
      }
    ],
    "explain": "Silence after a label is not a failure of the label. It is the label working."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "held_the_pause", "label": "Held the silence", "description": "Waited after the label instead of rescuing the pause." },
      { "key": "stayed_relaxed", "label": "Kept it warm while waiting", "description": "The silence read as an invitation rather than a demand." },
      { "key": "did_not_add", "label": "Did not stack a question on top", "description": "Resisted softening the label into a question or adding a follow-up." },
      { "key": "recovered_well", "label": "Handled a silence that did not fill", "description": "When the pause genuinely was not taken up, took the awkwardness on themselves." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A bench outside a hospital cafe. You are waiting for the same appointment slot as someone you have just met.",
    "partner": {
      "name": "Margo",
      "role": "someone waiting for the same clinic",
      "personality": "Guarded at first, with plenty to say if given room. Responds strongly to being given space and shuts down if the other person talks over the gaps.",
      "mood": "Anxious, keeping it together, glad of a distraction.",
      "openness": 3
    },
    "opening_beat": "Margo mentions she has been coming here every few weeks since spring, and it has become a strange sort of routine.",
    "success_looks_like": "The user labels and then genuinely waits, and Margo fills the silence with something she would not have said if asked directly.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "When the user labels one of your words and then says nothing further, continue speaking and go deeper than you had planned.",
      "If the user follows a label with a question or their own story, give a short, flat, surface answer instead.",
      "Never mention the technique or the silence."
    ]
  }$j$::jsonb,
  $md$Today, after one label, count two slow beats before you speak. Notice what they do with the gap. Log whether you managed to hold it.$md$
),
(
  (select id from public.skills where slug = 'listening-and-labeling'),
  3,
  'Label the feeling under the fact',
  $md$Repeating a word is the beginner's version. The advanced one is naming the feeling the words are carrying but not saying.

People rarely announce emotions. They describe circumstances and leave the feeling implied, partly out of habit and partly to see whether you will notice. *I ended up doing most of it myself* is a sentence about workload with resentment folded inside it.

**The move:** name the feeling tentatively, as a guess they are free to correct.

*Sounds like that was frustrating. Seems like you were pretty proud of that.* The tentative framing is essential. A confident diagnosis of someone's inner life is unpleasant even when accurate. A guess offered lightly is a gift, because it says you were paying enough attention to try.

And being wrong works nearly as well as being right, which is the next lesson.$md$,
  $j$[
    {
      "situation": "They say: I organised the whole thing and then someone else presented it.",
      "line": "That sounds like it stung a bit.",
      "why": "Names the unspoken feeling rather than repeating the facts. Sounds like keeps it a guess rather than a verdict."
    },
    {
      "situation": "They say: I have not really told anyone this yet.",
      "line": "Seems like you are still working out what you think about it.",
      "why": "Labels the state rather than the content, which lets them talk without having to have concluded anything first."
    },
    {
      "situation": "They describe finishing a long project in a flat, tired voice.",
      "line": "You do not sound as pleased as I would have expected.",
      "why": "Names the gap between what they said and how they said it. Done gently, this is the label people find most striking."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone says: I took the promotion, obviously. It was more money and everyone said I would be mad not to. What is the best label?",
    "options": [
      {
        "text": "More money is more money.",
        "correct": false,
        "note": "Agrees with the surface and closes the door on everything underneath it."
      },
      {
        "text": "Congratulations, that is great news.",
        "correct": false,
        "note": "Kind, and it takes their framing entirely at face value. Obviously and everyone said were both doing work they are now unlikely to explain."
      },
      {
        "text": "It sounds like it was more everyone else's decision than yours.",
        "correct": true,
        "note": "Names what the sentence is carrying. Obviously and everyone said are the tell, and offering it as a guess makes it safe to agree with."
      },
      {
        "text": "Do you regret it?",
        "correct": false,
        "note": "The right target, but blunt. A question this direct usually gets denied, where a tentative label gets accepted."
      }
    ],
    "explain": "Name the feeling the sentence carries, and frame it as a guess. Sounds like and seems like do most of the work."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_feeling", "label": "Named what was under it", "description": "Labelled the implied feeling rather than repeating the circumstances." },
      { "key": "stayed_tentative", "label": "Offered it as a guess", "description": "Used sounds like, seems like or similar rather than diagnosing confidently." },
      { "key": "read_the_tell", "label": "Spotted the giveaway", "description": "Picked up on a qualifier, a tone or a gap between content and delivery." },
      { "key": "left_room_to_deny", "label": "Made it easy to correct", "description": "Framed the label so the partner could disagree without friction." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A late train home. Two seats facing each other, and you have been talking on and off for twenty minutes.",
    "partner": {
      "name": "Iris",
      "role": "someone travelling back from the same event",
      "personality": "Composed and articulate, describes situations rather than feelings, and is visibly relieved when someone names what she has been circling.",
      "mood": "Reflective, a bit worn out.",
      "openness": 4
    },
    "opening_beat": "Iris says she has just wrapped up a project she led for eighteen months, and describes the ending in oddly flat, practical terms.",
    "success_looks_like": "The user names the feeling under the flatness as a guess, and Iris confirms it and opens up considerably.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Describe circumstances, never emotions, unless the user names one first.",
      "When the user offers a tentative label of your feeling, confirm or gently correct it and then say much more.",
      "If the user only repeats factual words back, stay on the surface and keep describing logistics."
    ]
  }$j$::jsonb,
  $md$Today, name the feeling under what someone says, offered as a guess. Sounds like, or seems like. Log what you guessed and whether you were right.$md$
),
(
  (select id from public.skills where slug = 'listening-and-labeling'),
  4,
  'Being wrong works too',
  $md$The thing that stops people labeling feelings is the fear of guessing wrong. That fear is misplaced, because a wrong label is almost as useful as a right one.

When you say *sounds like that was frustrating* and it was not, the response is not offence. It is correction: *no, not frustrating, more just disappointing.* They have now told you the precise word, which is better than what you had, and they had to think about it to produce it.

**The move:** guess anyway, hold it loosely, and treat the correction as the prize.

This only holds if the guess was offered as a guess. A confident wrong verdict does cause offence, because now they have to argue rather than correct. The tentative framing is what converts being wrong from a mistake into a method.

The one exception: do not guess wrong about the same thing twice. Once is attentive. Twice is not listening.$md$,
  $j$[
    {
      "situation": "You said it sounded frustrating and they said not really.",
      "line": "What was it then, closer to boring?",
      "why": "Takes the correction and immediately offers another guess. You are now searching together rather than you interrogating them."
    },
    {
      "situation": "You guessed they were nervous and they say they were actually excited.",
      "line": "Excited. That is a much better place to be starting from.",
      "why": "Accepts the correction by using their new word straight away. It proves the guess was genuinely held loosely."
    },
    {
      "situation": "They correct your label at some length.",
      "line": "(let them finish, then stay quiet)",
      "why": "The correction is often the most detailed thing they will say. Interrupting it to apologise for guessing wrong wastes it."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You say it sounds like that was disappointing, and they reply: no, not disappointing exactly. What now?",
    "options": [
      {
        "text": "Sorry, I did not mean to put words in your mouth.",
        "correct": false,
        "note": "Apologising makes the guess into a transgression. It also stops them completing the correction, which was the useful part."
      },
      {
        "text": "Not disappointing. What is closer?",
        "correct": true,
        "note": "Uses their correction and asks for the better word. This usually produces the most precise and revealing thing they say."
      },
      {
        "text": "Fair enough. So what happened after that?",
        "correct": false,
        "note": "Moves on and throws away the moment. They were about to tell you the accurate version."
      },
      {
        "text": "Really? It sounded disappointing from here.",
        "correct": false,
        "note": "Defending the guess turns it into an argument about their own feelings, which you cannot win and should not want to."
      }
    ],
    "explain": "The correction is the prize. Take their new word and use it rather than apologising for not having it already."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "guessed_anyway", "label": "Risked a guess", "description": "Offered a label rather than staying safely on the facts." },
      { "key": "held_it_loosely", "label": "Held it loosely", "description": "Framed the guess so a correction was easy and not embarrassing for either side." },
      { "key": "took_the_correction", "label": "Used the correction", "description": "Picked up the partner's better word and used it rather than apologising or defending." },
      { "key": "did_not_repeat", "label": "Did not miss twice", "description": "Adjusted after being corrected rather than guessing wrong in the same direction again." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The kitchen of a shared flat, late evening. Your flatmate's friend is waiting for them to get home.",
    "partner": {
      "name": "Tobi",
      "role": "a friend of your flatmate, waiting around",
      "personality": "Precise about language and enjoys being asked to find the exact word. Corrects a wrong label at length rather than taking offence, as long as it was offered gently.",
      "mood": "Unhurried, a bit chatty.",
      "openness": 4
    },
    "opening_beat": "Tobi mentions he pulled out of something big at the last minute a few weeks ago, and does not say how he feels about it.",
    "success_looks_like": "The user guesses at the feeling, gets corrected, takes the correction and goes further with Tobi's own better word.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "The first label the user offers is always slightly wrong. Correct it warmly and supply a more precise word.",
      "If the user picks up your corrected word and stays with it, open up considerably.",
      "If the user apologises for guessing or defends the wrong guess, become more guarded and less specific."
    ]
  }$j$::jsonb,
  $md$Today, deliberately guess at a feeling you are not sure about. Let them correct you and use their word. Log what you guessed and what they replaced it with.$md$
),
(
  (select id from public.skills where slug = 'listening-and-labeling'),
  5,
  'Listen for what they say twice',
  $md$People tell you what matters to them by repeating it, and almost nobody notices.

Across ten minutes someone will circle back to the same subject two or three times, often in different clothes. The house, then the neighbourhood, then the commute — three topics, one preoccupation. The thing they return to is the thing that is live for them, whether or not they have decided to talk about it directly.

**The move:** track what recurs, and name the pattern rather than the instance.

*You keep coming back to the move.* That sentence tends to land harder than any individual label, because it shows you were listening across the whole conversation rather than to the sentence in front of you. It is also slightly disarming, in a way people usually enjoy.

Save it. Once in a conversation is striking. Twice is surveillance.$md$,
  $j$[
    {
      "situation": "They have mentioned their brother three times in unrelated stories.",
      "line": "Your brother has come up a few times now.",
      "why": "Names the pattern without interpreting it. They will supply the interpretation, and it is usually the most interesting thing in the conversation."
    },
    {
      "situation": "Work has crept back into a conversation that was supposed to be about a holiday.",
      "line": "We keep ending up back at work. Is it that kind of month?",
      "why": "Includes yourself with we, which softens it from an observation about them into something you both noticed."
    },
    {
      "situation": "They have twice mentioned being tired, both times as an aside.",
      "line": "That is the second time you have said you are tired.",
      "why": "Plain and specific. Asides are where people put the things they half want you to pick up on."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Over fifteen minutes someone has mentioned their old flat, their old commute and an old colleague, all fondly. What is the strongest move?",
    "options": [
      {
        "text": "Ask a question about the old colleague.",
        "correct": false,
        "note": "Reasonable, but it treats the third instance as a topic rather than as evidence of a pattern."
      },
      {
        "text": "Ask whether they preferred living there.",
        "correct": false,
        "note": "Closer, since it senses the theme, but it narrows a broad nostalgia down to one practical question."
      },
      {
        "text": "Say something about your own old flat.",
        "correct": false,
        "note": "Reciprocity is valuable and this is a fine move in general, but here it steps over something they are clearly circling."
      },
      {
        "text": "Point out that the old life keeps coming up.",
        "correct": true,
        "note": "Names the pattern rather than any single instance. They have been circling something for fifteen minutes, and this gives them the opening to say it."
      }
    ],
    "explain": "Track what recurs across a whole conversation. Naming the pattern lands harder than responding to any one instance of it."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "tracked_across", "label": "Listened across the conversation", "description": "Noticed a subject recurring rather than only responding to the latest sentence." },
      { "key": "named_the_pattern", "label": "Named the pattern", "description": "Pointed at the recurrence itself rather than asking another question about one instance." },
      { "key": "no_interpretation", "label": "Did not over-interpret", "description": "Named what recurred without telling the partner what it meant about them." },
      { "key": "used_it_once", "label": "Used it sparingly", "description": "Deployed the move once rather than repeatedly narrating the partner to themselves." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend's housewarming. You have been talking to the same person on and off for a while, drifting between subjects.",
    "partner": {
      "name": "Sol",
      "role": "someone you were introduced to earlier in the evening",
      "personality": "Chatty and wide-ranging, and circles one subject repeatedly without noticing. Slightly startled and then pleased when someone names it.",
      "mood": "Sociable, a couple of drinks in.",
      "openness": 4
    },
    "opening_beat": "Sol is telling you about a weekend away, and mentions in passing that their sister organised the whole thing, which is typical.",
    "success_looks_like": "The user notices the sister recurring across several unrelated stories and names the pattern, and Sol says the thing they have been circling.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Bring your sister into at least three different stories, each time incidentally and without dwelling on it.",
      "If the user names the recurrence, be briefly surprised and then talk about it honestly.",
      "If the user only asks about individual stories, keep moving to new topics and keep the sister incidental."
    ]
  }$j$::jsonb,
  $md$Today, in one longer conversation, track what the other person returns to. Name the pattern once. Log what recurred and how they reacted.$md$
);

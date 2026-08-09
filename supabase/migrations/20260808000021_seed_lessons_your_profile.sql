-- Dating apps, track 1: Your profile. Four lessons, because it is a smaller
-- skill than the two either side of it and padding it would have shown.
--
-- This is the part of dating apps that suits a quiet person best and almost
-- nobody uses it that way: unlimited time, unlimited drafts, and the ability to
-- decide in advance what strangers will talk to you about.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'your-profile'),
  1,
  'Messageable beats impressive',
  $md$Everybody writes their profile as an advertisement, and an advertisement is the wrong document.

The question it has to answer is not *am I impressive*. It is *what would somebody say to me* — and those two questions produce completely different pages.

Impressive produces adjectives. Adventurous. Laid-back. Love to laugh. Sarcastic. Up for anything. Every one of them is unanswerable: there is no reply to *laid-back*, so a stranger reading it has been given nothing to hold and has to invent an opening from nothing. They will not. They have eleven other profiles open.

**The move:** write things that can be replied to.

Objects, places, opinions. Not *I love travelling* but *I have been to Lisbon four times and still have not been anywhere else in Portugal*. Not *foodie* but *I will drive an hour for a decent bakery*. Same information, except the second version of each has a handle on it, and the handle is the entire point.

Test any line by asking what a stranger could send you about it. If the answer is nothing, the line is decoration. Three or four hooks is plenty — a profile does not have to be complete, it has to be openable.

And notice what this does for a quiet person. You cannot control who approaches you in a bar. Here you can decide, in advance and with as many drafts as you like, what people will talk to you about.$md$,
  $j$[
    {
      "situation": "Your profile says: adventurous, laid-back, love to laugh.",
      "line": "(what could anybody send you about that?)",
      "why": "Nothing. Adjectives are unanswerable, which means the profile has asked the stranger to invent an opening from nothing, and they will not bother."
    },
    {
      "situation": "You want to say you like travelling.",
      "line": "I have been to Lisbon four times and never anywhere else in Portugal.",
      "why": "Same information with a handle on it. There are three obvious replies to that sentence and none to I love travelling."
    },
    {
      "situation": "You are wondering whether the profile is finished.",
      "line": "(count the hooks — three or four is plenty)",
      "why": "A profile does not have to be complete, it has to be openable. Completeness is what makes it read like a form."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do adjectives fail on a profile?",
      "options": [
        { "text": "They are usually not true.", "correct": false, "note": "Often perfectly true. Truth is not what is missing — a handle is." },
        { "text": "There is no reply to laid-back.", "correct": true, "note": "An unanswerable line asks the stranger to invent an opening from nothing, and they have eleven other profiles open." },
        { "text": "Everybody uses them.", "correct": false, "note": "They do, and being unoriginal is the smaller problem. Being unanswerable is the one that costs you messages." },
        { "text": "They are boring.", "correct": false, "note": "A judgement rather than a mechanism. A dull but specific line still gets replies." }
      ],
      "explain": "Every line should be something somebody could send you a message about."
    },
    {
      "prompt": "So what is a profile actually for?",
      "options": [
        { "text": "Being impressive enough to get swiped.", "correct": false, "note": "This is the advertisement version, and it produces a page nobody can open." },
        { "text": "Describing you accurately.", "correct": false, "note": "Accurate and unopenable is a very common profile. Completeness is not the goal." },
        { "text": "Being liked by as many people as possible.", "correct": false, "note": "Widely acceptable is the same as unmemorable, which the third lesson in this track is about." },
        { "text": "Giving somebody something to say to you.", "correct": true, "note": "That is the whole job. A profile does not have to be complete, it has to be openable." }
      ],
      "explain": "Messageable, not impressive. Judge every line by what could be sent back."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "hooks", "label": "Left hooks", "description": "Wrote lines a stranger could reply to." },
      { "key": "concrete", "label": "Objects, not adjectives", "description": "Named places, things and opinions rather than qualities." },
      { "key": "not_selling", "label": "Did not advertise", "description": "Resisted writing the impressive version." },
      { "key": "enough", "label": "Knew when to stop", "description": "Three or four hooks rather than a complete account." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend who is unreasonably good at this has your profile open on their phone and has offered to be honest about it.",
    "partner": {
      "name": "Robin",
      "role": "a friend going through your profile with you",
      "personality": "Blunt and constructive. Asks what a stranger could possibly reply to each line, and will not accept an adjective as an answer.",
      "mood": "Amused, entirely on your side.",
      "openness": 5
    },
    "opening_beat": "\"Right. First line: adventurous, laid-back, love to laugh. What am I supposed to send you about that?\"",
    "success_looks_like": "The user turns an adjective into something concrete a stranger could open with.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what a stranger could reply to, line by line.",
      "Accept concrete objects, places and opinions; push back on qualities and adjectives.",
      "Keep replies short and warm."
    ]
  }$j$::jsonb,
  $md$Today, take one line of your profile and rewrite it as something a stranger could reply to. Log the before and the after.$md$
),
(
  (select id from public.skills where slug = 'your-profile'),
  2,
  'Photos have jobs',
  $md$Most people submit six photos doing one job, and the job is *I look all right in this one*.

Somebody scrolling is not judging your face. They are trying to work out whether they can picture an hour sitting opposite you, and they are doing it in about two seconds. Everything below follows from that.

**The move:** give each photo a different job.

**A clear face, on its own, first.** No sunglasses, no crowd, no distance. If your first photo is a group shot they have to solve a puzzle before they can be interested, and they will not.

**A whole person.** Not vanity — legibility. A profile with no full-length photo reads as a profile hiding something, whether or not it is.

**One doing the thing you actually do.** At the wall, on the bike, in the kitchen, at the desk with the terrible plant. This is the photo that generates messages, because it is the only one with anything in it to ask about.

**One with other people.** Two or three, not a wedding party. It shows you have a life without asking anybody to identify you in a line-up.

Then cut. Sunglasses in every shot, group shots where you cannot be found, anything from four years and one haircut ago, and the mirror selfie in the gym — which is the only photo that reliably says something you did not mean.

Here is the part that matters if you are quiet: you do not have to look extroverted. There is no photo of you on a table with a microphone that is worth one of you doing something you genuinely do. Legible beats lively, every time.$md$,
  $j$[
    {
      "situation": "Your first photo is you and four friends at a wedding.",
      "line": "(move it — first photo is a clear face, alone)",
      "why": "A group shot first asks them to solve a puzzle before they can be interested, in a two-second decision. They will not do the work."
    },
    {
      "situation": "You have six photos and they are all from the shoulders up.",
      "line": "(add a full-length one)",
      "why": "Not vanity, legibility. A profile with nothing full-length reads as hiding something whether or not it is, and that reading is free to avoid."
    },
    {
      "situation": "You are choosing between you at a party and you at the climbing wall.",
      "line": "(the wall — it is the one with something to ask about)",
      "why": "The doing-something photo generates the messages. And you do not need to look extroverted; you need to look like somebody an hour could be spent with."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the first photo's job?",
      "options": [
        { "text": "A clear face, on its own.", "correct": true, "note": "The decision takes about two seconds. Anything that has to be decoded first — a crowd, sunglasses, distance — spends that time and gets nothing back." },
        { "text": "The most flattering one you have.", "correct": false, "note": "Flattering and unreadable is the standard mistake. Clear beats flattering in the first slot." },
        { "text": "One that shows your personality.", "correct": false, "note": "That is the third photo's job, and it works much better once they know what you look like." },
        { "text": "A group shot, so you look like you have friends.", "correct": false, "note": "Worst possible opener. It makes identifying you the price of entry." }
      ],
      "explain": "Face, alone, clear, first. Everything else has a later slot."
    },
    {
      "prompt": "Six photos. What is the commonest mistake?",
      "options": [
        { "text": "Having too few.", "correct": false, "note": "Four good ones beat six of anything. Quantity is not the failure here." },
        { "text": "They look too posed.", "correct": false, "note": "Posed is fine and often clearer. The problem is not the posing." },
        { "text": "Six versions of one job.", "correct": true, "note": "Six photos that all say I look all right in this one. Each slot should be doing something different — face, whole person, the thing you do, people." },
        { "text": "No photos with other people.", "correct": false, "note": "One of the four jobs, and only one. Missing it is a gap rather than the pattern." }
      ],
      "explain": "Four jobs: a face, a whole person, the thing you actually do, and evidence of a life."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "face_first", "label": "Led with a clear face", "description": "Put a readable solo photo in the first slot." },
      { "key": "jobs", "label": "Gave each photo a job", "description": "Covered face, whole person, doing something, and people." },
      { "key": "cut", "label": "Cut the dead ones", "description": "Removed sunglasses-only, unfindable group shots and anything years old." },
      { "key": "true", "label": "Stayed legible rather than lively", "description": "Chose photos of what they actually do over performed sociability." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The same friend, still on your profile, now swiping through the photos.",
    "partner": {
      "name": "Robin",
      "role": "a friend going through your photos with you",
      "personality": "Blunt and practical. Names what each photo is doing and points out when two of them are doing the same thing.",
      "mood": "Enjoying this more than you are.",
      "openness": 5
    },
    "opening_beat": "\"Okay, photo one is you and four other people at a wedding. Which one are you?\"",
    "success_looks_like": "The user gives each slot a distinct job and leads with a clear solo face.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what each photo is for, and point out repeats.",
      "Approve a photo of the user actually doing something over a performed social one.",
      "Keep replies short."
    ]
  }$j$::jsonb,
  $md$Today, open your photos and name the job of each one out loud. Log which slot has no job and what you would put there.$md$
),
(
  (select id from public.skills where slug = 'your-profile'),
  3,
  'Filter on purpose',
  $md$A profile everybody likes is a profile nobody messages, and the two facts are the same fact.

Universally acceptable is built by removing anything anybody could object to, and what gets removed is precisely the material worth reacting to. What survives is smooth, agreeable and completely inert — a page that offends nobody and interests nobody, which reads to a stranger as somebody with no edges rather than somebody being careful.

**The move:** put in one thing that will lose you some people.

A real opinion. A hobby that is slightly embarrassing. A preference you would defend. The bar is low: not a manifesto, not a list of dealbreakers, just one line where you are visibly a specific person rather than a pleasant absence.

It costs you matches, and this is the part worth sitting with rather than nodding at. The matches it costs are the ones that would have faded politely somewhere around message four, because there was nothing between you. The ones it keeps are the ones who read the line and thought *oh, that person*.

This is uncomfortable for anybody who has spent years being agreeable, and it is worth naming that the discomfort is not evidence of a mistake. Being liked by everybody is a strategy for not being rejected, and it works — it also has a side effect, which is not being chosen.

Dealbreakers are the exception. A list of what you do not want reads as somebody who has been disappointed and is bracing for it, and it filters out the wrong half of the room. Filter with what you *are*, not with what you will not tolerate.$md$,
  $j$[
    {
      "situation": "Your profile is pleasant and nothing in it could annoy anybody.",
      "line": "(add one line somebody could disagree with)",
      "why": "Smooth is built by deleting everything reactable. What is left interests nobody, and it reads as no edges rather than as careful."
    },
    {
      "situation": "You worry an opinion will cost you matches.",
      "line": "(it will — the ones that fade at message four)",
      "why": "Those are the matches with nothing between you. The line does not cost you the people who would have liked you; it identifies them."
    },
    {
      "situation": "You are about to write a list of things you do not want.",
      "line": "(filter with what you are instead)",
      "why": "Dealbreakers read as somebody bracing for disappointment, and they filter out the wrong half of the room."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a profile everybody likes get no messages?",
      "options": [
        { "text": "People assume somebody that good is taken.", "correct": false, "note": "A comforting story. The page is not too good, it is too smooth." },
        { "text": "It reads as fake.", "correct": false, "note": "Usually it reads as fine, which is worse. Fine produces no reaction at all." },
        { "text": "It is too short.", "correct": false, "note": "Length is not the variable. A short profile with one real opinion outperforms a long agreeable one." },
        { "text": "There is nothing in it to react to.", "correct": true, "note": "Universally acceptable is built by removing everything anybody could object to, and that is exactly the material worth replying to." }
      ],
      "explain": "Smooth and inert are the same page. Put in something a stranger could have a view about."
    },
    {
      "prompt": "You add an opinion some people will bounce off. What did that cost you?",
      "options": [
        { "text": "Matches you would have enjoyed.", "correct": false, "note": "The fear, and not what happens. Somebody who would have enjoyed you is not repelled by knowing what you think." },
        { "text": "The matches that would have faded around message four.", "correct": true, "note": "It costs something real — just not anything you wanted. Those conversations end politely because there was never anything between you." },
        { "text": "Nothing at all.", "correct": false, "note": "Too easy, and it dodges the thing worth sitting with. It does cost matches; the question is which ones." },
        { "text": "Anybody who disagrees with you.", "correct": false, "note": "People disagree with things they find interesting all the time. Disagreement is a reply, which is more than smooth ever gets." }
      ],
      "explain": "Being liked by everybody protects you from rejection. It also protects you from being chosen."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "an_opinion", "label": "Put in something reactable", "description": "Wrote at least one line somebody could disagree with." },
      { "key": "specific", "label": "Was specific about it", "description": "Named an actual view rather than gesturing at having views." },
      { "key": "no_dealbreakers", "label": "Filtered by what they are", "description": "Avoided a list of what they will not tolerate." },
      { "key": "light", "label": "Kept it light", "description": "One line, not a manifesto." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The prompt box is open and the prompt on the screen is: a hill I will die on.",
    "partner": {
      "name": "Robin",
      "role": "a friend watching you fill in the prompt",
      "personality": "Refuses to accept anything safe. Asks who exactly would disagree with each answer, and points out when the answer is nobody.",
      "mood": "Determined that you will write something real.",
      "openness": 5
    },
    "opening_beat": "\"A hill I will die on. And before you write pineapple on pizza — who would actually argue with you about that?\"",
    "success_looks_like": "The user writes a real opinion that some people would bounce off.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reject safe or joke answers by asking who would genuinely disagree.",
      "Accept and enjoy an answer that would actually divide people.",
      "Keep replies to a sentence or two."
    ]
  }$j$::jsonb,
  $md$Today, write one line for your profile that some people would disagree with. You do not have to publish it. Log what you wrote and who it would lose.$md$
),
(
  (select id from public.skills where slug = 'your-profile'),
  4,
  'Promise the person who turns up',
  $md$There is a version of profile advice that tells you to sell yourself, and taken literally it produces the single most expensive mistake on these apps.

Overclaiming works. *Always up for an adventure, never say no to a night out* will get you matches, and the bill arrives in a coffee shop three weeks later, opposite somebody who came to meet a person you are not. Then you spend two hours performing them, which is exhausting, and it goes nowhere, which is worse — because the failure gets filed as *I am bad at dates* when what actually happened is that the wrong date was booked.

**The move:** promise the person who will actually turn up.

That means writing the true version and making it specific rather than making it big. *I will cycle a stupid distance for a good bakery, and I am in bed by eleven* is a real person with a real evening in it. It is not impressive and it is not trying to be. Somebody reading it either wants that evening or does not, and both of those outcomes are useful to you.

Include the unimpressive half deliberately. It is the fastest way to be believed, and being believed is worth more than being admired — an admired profile gets swipes, a believed one gets somebody who is pleased when you arrive.

For a quiet person the whole calculation runs the same direction. Every match won by claiming to be louder than you are is a date you will have to be loud at. You do not want more matches. You want the ones who read the true version and chose it.$md$,
  $j$[
    {
      "situation": "Your profile says always up for an adventure, never say no to a night out.",
      "line": "I will cycle a stupid distance for a good bakery, and I am in bed by eleven.",
      "why": "A real person with a real evening in it. Somebody either wants that or does not, and both answers are useful — unlike a match won by a claim you have to keep performing."
    },
    {
      "situation": "You are tempted to leave in the impressive version.",
      "line": "(the bill arrives on the first date)",
      "why": "You spend two hours being somebody else, it goes nowhere, and the failure gets filed as being bad at dates rather than as having booked the wrong one."
    },
    {
      "situation": "You are wondering whether to admit the boring half.",
      "line": "(put it in — it is what makes the rest believable)",
      "why": "Being believed is worth more than being admired. Admired gets swipes; believed gets somebody who is pleased when you actually arrive."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What should a profile promise?",
      "options": [
        { "text": "The person who will actually turn up.", "correct": true, "note": "Every match won by claiming to be louder than you are is a date you then have to be loud at. You do not want more matches; you want the ones who chose the true version." },
        { "text": "The best version of you.", "correct": false, "note": "The best version is still you and it is not who arrives on a Tuesday. Aspiration is what makes the first date a performance." },
        { "text": "Whatever gets the most matches.", "correct": false, "note": "Matches are not the outcome. Optimising for them is exactly how people end up with a diary full of wrong dates." },
        { "text": "As little as possible, so there is no expectation.", "correct": false, "note": "Overcorrecting into a blank page. Specific and true, not vague and safe." }
      ],
      "explain": "Write the version that will still be true in a coffee shop three weeks from now."
    },
    {
      "prompt": "Why is overclaiming expensive rather than just dishonest?",
      "options": [
        { "text": "People can tell straight away.", "correct": false, "note": "Frequently they cannot, which is the problem. If it never worked it would not be tempting." },
        { "text": "It is unfair on the other person.", "correct": false, "note": "True, and it is not the argument that will actually change your behaviour here." },
        { "text": "It buys matches with the bill due on the first date.", "correct": true, "note": "You spend two hours performing somebody else, it goes nowhere, and you file it as being bad at dates rather than as having booked the wrong one." },
        { "text": "You will run out of things to say.", "correct": false, "note": "A symptom rather than the mechanism, and usually the opposite — performing is talkative and exhausting." }
      ],
      "explain": "The cost is not moral. It is a diary full of dates with people who came for somebody else."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "true", "label": "Wrote the true version", "description": "Described the person who will actually arrive." },
      { "key": "specific", "label": "Made it specific, not big", "description": "Reached for detail rather than for scale." },
      { "key": "unimpressive_half", "label": "Included the unimpressive half", "description": "Kept the part that makes the rest believable." },
      { "key": "no_performance", "label": "Did not claim a personality", "description": "Avoided promising energy they would have to perform." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The profile is nearly done. One line is left over from an earlier draft: always up for an adventure, never say no to a night out, ask me anything.",
    "partner": {
      "name": "Robin",
      "role": "a friend reading the last line back to you",
      "personality": "Knows you well enough to be funny about it. Asks what happens on the first date if the line is true, and waits.",
      "mood": "Very entertained.",
      "openness": 5
    },
    "opening_beat": "\"Never say no to a night out. You cancelled on me twice last month because you were tired.\"",
    "success_looks_like": "The user rewrites the line as something true and specific, unimpressive half included.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Push back cheerfully on anything the user could not sustain on a real date.",
      "Warm up immediately at anything specific and true, including the dull parts.",
      "Keep replies to a sentence or two."
    ]
  }$j$::jsonb,
  $md$Today, rewrite one profile line as the version that will still be true on a Tuesday. Log the claim you removed.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('your-profile', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Your profile opens with: adventurous, laid-back, love to laugh.",
      "prompt": "A stranger reads that. What can they send you?",
      "options": [
        { "text": "Something about being adventurous, probably.", "correct": false, "note": "Try writing it. Everything you can think of is a question they would have to invent from nothing, which is why nobody sends it." },
        { "text": "Nothing — there is no handle on any of it.", "correct": true, "note": "Adjectives are unanswerable. The profile has asked the stranger to do all the work, and they have eleven other profiles open." },
        { "text": "A joke, if they are quick.", "correct": false, "note": "It puts the whole burden on their wit. Specificity is the thing that lets an ordinary person open a conversation." },
        { "text": "Hey.", "correct": false, "note": "Correct in practice, and it is worth seeing that hey is the message your own profile asked for." }
      ]
    },
    {
      "situation": "You want the profile to say that you like travelling.",
      "prompt": "Which line does the job?",
      "options": [
        { "text": "Always planning the next trip.", "correct": false, "note": "Still an adjective wearing a verb. Nothing in it can be picked up." },
        { "text": "I love travelling — tell me where I should go next.", "correct": false, "note": "It contains a question, which feels like a hook, and it is a question about them doing your work for you." },
        { "text": "I have been to Lisbon four times and never anywhere else in Portugal.", "correct": true, "note": "Three obvious replies, all of them easy. Same information as I love travelling, with a handle on it." },
        { "text": "Twenty-three countries and counting.", "correct": false, "note": "Impressive and closed. A number is a claim, not something a stranger can open." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-profile', 2, 'choice', $j${
  "beats": [
    {
      "situation": "Your six photos: a wedding group shot, two selfies in sunglasses, one at a distance on a beach, one from four years ago, and one at the climbing wall.",
      "prompt": "Which goes first?",
      "options": [
        { "text": "The climbing wall — it says something about you.", "correct": true, "note": "Not the textbook first slot, and it is the only photo here that is both clearly you and has something in it to ask about. Everything else needs decoding." },
        { "text": "The wedding group shot — you look happy in it.", "correct": false, "note": "The worst possible opener. It makes finding you the price of entry, in a two-second decision." },
        { "text": "A selfie in sunglasses.", "correct": false, "note": "Half a face. The first slot exists to answer what you look like, and this one declines to." },
        { "text": "The one from four years ago, if it is the best photo.", "correct": false, "note": "Every good thing it does gets undone in the first thirty seconds of meeting you." }
      ]
    },
    {
      "situation": "You are down to four photos and they are all clear, recent shots of your face.",
      "prompt": "What is missing?",
      "options": [
        { "text": "Nothing — clear photos are the whole point.", "correct": false, "note": "Clear was the first slot's job. Four photos doing one job is the standard mistake." },
        { "text": "Something more flattering.", "correct": false, "note": "Flattering is not a job. It is the instinct that produced six versions of the same photo in the first place." },
        { "text": "A whole person, something you actually do, and some evidence of a life.", "correct": true, "note": "Four slots, four jobs. The doing-something one is where the messages come from; the full-length one removes a reading you do not want." },
        { "text": "More of them — six beats four.", "correct": false, "note": "Four good ones beat six of anything. Quantity was never the variable." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-profile', 3, 'line', $j${
  "says": "A hill I will die on:",
  "model": {
    "line": "Every film would be better twenty minutes shorter, including the ones you love.",
    "why": "A real view, cheerfully held, that a good number of people would argue with — and arguing is a reply, which is more than a smooth profile ever gets. It is one line, not a manifesto."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "A view, not a hedge",
      "words": ["i guess", "maybe", "kind of", "sort of", "probably", "each to their own", "no judgement", "just my opinion", "everyone"] },
    { "kind": "min_words", "requirement": "Enough of a claim to disagree with", "n": 5 },
    { "kind": "max_words", "requirement": "One line, not a manifesto", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('your-profile', 4, 'line', $j${
  "says": "The line still sitting in your profile: always up for an adventure, never say no to a night out, ask me anything.",
  "model": {
    "line": "I will cycle a stupid distance for a good bakery, and I am in bed by eleven.",
    "why": "A real person with a real evening in it, unimpressive half included — which is what makes the rest of it believable. Somebody either wants that evening or does not, and both answers are useful."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Drop the claims you would have to perform",
      "words": ["adventure", "always", "never say no", "anything", "up for anything", "spontaneous", "love to laugh", "laid-back", "outgoing"] },
    { "kind": "min_words", "requirement": "Specific enough to picture", "n": 8 },
    { "kind": "max_words", "requirement": "Under twenty-five words", "n": 25 }
  ]
}$j$::jsonb);

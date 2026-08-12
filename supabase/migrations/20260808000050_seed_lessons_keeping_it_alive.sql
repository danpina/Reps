-- Making friends, track 5: Keeping it alive.
--
-- The maintenance track, and the one that pays off over decades rather than
-- weeks. Friendships almost never end — they lapse, protected by the very
-- awkwardness the lapse created, and almost nobody sends the one line that
-- reverses it.
--
-- All free. Nothing here is a conversation you have to hold; it is a set of
-- messages, and a message is exactly what a line drill is for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'keeping-it-alive'),
  1,
  'Send things with no ask in them',
  $md$Most people's contact with their friends consists almost entirely of admin: arranging things, confirming things, replying about things. It is functional, it is what keeps a diary working, and it is not what a friendship is made of.

**The move:** send things with nothing attached.

A link. A photo of something ridiculous. A sentence about a thing they mentioned four months ago. *Saw this and thought of you* is the entire genre and it is far more powerful than its reputation, because it says the only thing that actually matters between people who do not see each other often: you exist in my head when you are not in the room.

It takes fifteen seconds, it requires no reply, and it asks for nothing. That last part is the whole design. Contact with a request in it makes somebody do something. Contact with nothing in it is a gift, and it is the difference between a friendship that is warm between meetings and one that has to be restarted every time.

There is a specific version worth building a habit around: following up on something they told you. *Did that interview go all right?* *How was the thing with your mum?* It costs nothing, it proves the last conversation was actually heard, and it is remembered out of all proportion to the effort — most people are not asked twice about anything.

And it is asymmetrical in the right direction for a quiet person. This is friendship maintenance with no social performance in it at all: no room, no timing, no wit required. If there is one habit in this app that pays off over a decade, it is this one.

If you keep one thing: fifteen seconds, no ask. That is what the warmth between meetings is actually made of.$md$,
  $j$[
    {
      "situation": "You see something a friend would find funny.",
      "line": "Saw this and thought of you.",
      "why": "Fifteen seconds, no reply required, nothing asked for. It says the only thing that matters between people who do not see each other often."
    },
    {
      "situation": "They mentioned an interview last week.",
      "line": "Did that interview go all right?",
      "why": "It proves the last conversation was heard, and it is remembered out of all proportion — most people are not asked twice about anything."
    },
    {
      "situation": "Every message you have sent this year has been about arranging something.",
      "line": "(that is admin, not friendship)",
      "why": "It keeps a diary working. Contact with nothing in it is what keeps a friendship warm between the times you meet."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What makes a no-ask message worth sending?",
      "options": [
        { "text": "It keeps you in their mind.", "correct": false, "note": "A strategic framing of something that works because it is not strategic." },
        { "text": "It says you exist in my head when you are not in the room.", "correct": true, "note": "The only thing that actually matters between people who do not see each other often — and a request in the message would say something else entirely." },
        { "text": "It is easier than arranging something.", "correct": false, "note": "It is, and easiness is why it is sustainable rather than why it works." },
        { "text": "It gives them a reason to reply.", "correct": false, "note": "It deliberately does not need one. Requiring a reply would make it admin again." }
      ],
      "explain": "Fifteen seconds, nothing attached. That is the whole design."
    },
    {
      "prompt": "Which version is remembered most?",
      "options": [
        { "text": "A long message catching up properly.", "correct": false, "note": "Appreciated and rare, and it asks for a long reply — which is why it often gets none." },
        { "text": "Something funny they would like.", "correct": false, "note": "Excellent and the everyday version of this. There is one that lands harder." },
        { "text": "Following up on something they told you.", "correct": true, "note": "Did that interview go all right. It proves the last conversation was heard, and most people are not asked twice about anything." },
        { "text": "A message on their birthday.", "correct": false, "note": "Expected, and expected things are pleasant rather than memorable." }
      ],
      "explain": "Being asked a second time about something is rarer than people think."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ask", "label": "Asked for nothing", "description": "Sent something with no request attached." },
      { "key": "quick", "label": "Kept it to fifteen seconds", "description": "Did not turn it into a project." },
      { "key": "followed_up", "label": "Followed something up", "description": "Referred to a thing they had mentioned." },
      { "key": "habit", "label": "Made it a habit", "description": "Treated it as recurring rather than a one-off." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A Tuesday evening. A friend you have not spoken to in five weeks mentioned last time that they had a job interview coming up.",
    "partner": {
      "name": "Priya",
      "role": "a friend you have not spoken to in a few weeks",
      "personality": "Replies warmly and at length to anything with no ask in it, and briskly to anything that is arranging something.",
      "mood": "At home, phone nearby.",
      "openness": 5
    },
    "opening_beat": "The message box is empty and it is nine in the evening.",
    "success_looks_like": "The user sends something with no request in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply warmly and at length to anything with no ask attached.",
      "Reply briefly and practically to anything about arranging something.",
      "Never message first."
    ]
  }$j$::jsonb,
  $md$Today, send one message with nothing asked for in it. Fifteen seconds. Log who and what.$md$
),
(
  (select id from public.skills where slug = 'keeping-it-alive'),
  2,
  'The one line that fixes a lapse',
  $md$Friendships almost never end. They lapse, which is a completely different thing, and the difference matters because a lapse is reversible and almost nobody reverses one.

The mechanism is ordinary and nobody is at fault. Somebody was busy. The gap got long enough to feel like it needed acknowledging. Acknowledging it began to feel like more effort than either person had — and from then on the gap is protected by the awkwardness it created, which is why two years can pass between people who genuinely like each other.

**The move:** send the ordinary thing you would have sent anyway, as though you spoke last week.

*This is the most you thing I have seen all year.* That is it. No apology, no accounting for the time, no *I am so sorry, I am terrible at this.* All of that makes the gap the subject and asks them to reassure you about it before anything else can happen — and reassuring somebody is work, which is exactly what you were trying not to ask for.

The reason it works is that they are on the other side of the same silence, feeling the same thing, and equally unable to be the one who breaks it. Almost nobody is annoyed about a lapse. Almost everybody is relieved when somebody else goes first, and grateful in a way that is out of proportion to a single message.

It also works after much longer than people believe. Two years is nothing. Five is fine. Old friendships have an enormous amount of stored context and they restart from where they were rather than from nothing, which is why an hour with somebody you have not seen since 2019 is frequently better than an hour with somebody you see monthly.

If it lands badly, it lands badly at the cost of one message. That is the entire downside, and it is worth putting next to the upside, which is a friendship you had already written off.

If you keep one thing: no apology, no explanation, just the ordinary thing. The gap is not the subject unless you make it one.$md$,
  $j$[
    {
      "situation": "Two years since you last spoke and you see something they would love.",
      "line": "This is the most you thing I have seen all year.",
      "why": "The ordinary message, sent as though you spoke last week. The gap is not the subject unless you make it one."
    },
    {
      "situation": "You are about to open with sorry, I am terrible at keeping in touch.",
      "line": "(that makes the gap the subject)",
      "why": "It asks them to reassure you before anything else can happen, and reassuring somebody is work — which is what you were trying not to ask for."
    },
    {
      "situation": "You think too much time has passed to get in touch.",
      "line": "(two years is nothing, five is fine)",
      "why": "Old friendships restart from stored context rather than from nothing, which is why an hour with somebody you have not seen since 2019 is often better than an hour with somebody you see monthly."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do lapses last so long?",
      "options": [
        { "text": "People drift apart naturally.", "correct": false, "note": "A description of the outcome rather than the mechanism, and it makes something reversible sound inevitable." },
        { "text": "The gap is protected by the awkwardness it created.", "correct": true, "note": "It got long enough to feel like it needed acknowledging, and acknowledging it started to feel like more effort than either person had." },
        { "text": "Somebody was hurt and did not say.", "correct": false, "note": "Occasionally, and it is the story people invent to explain an ordinary silence." },
        { "text": "Life gets busier.", "correct": false, "note": "It does, and busy accounts for a three-week gap rather than a three-year one." }
      ],
      "explain": "Nobody is at fault, and both people are on the same side of the same silence."
    },
    {
      "prompt": "Why leave the apology out?",
      "options": [
        { "text": "It sounds insincere.", "correct": false, "note": "It usually sounds entirely sincere, which is not the problem." },
        { "text": "It makes you look bad.", "correct": false, "note": "Nobody thinks worse of somebody for apologising. The cost falls on them rather than on you." },
        { "text": "It asks them to reassure you first.", "correct": true, "note": "Which is work, and it is exactly what you were trying not to ask for. The gap becomes the subject before anything else can happen." },
        { "text": "It draws attention to how long it has been.", "correct": false, "note": "They already know how long it has been. Attention is not the cost — the reassurance is." }
      ],
      "explain": "Send the ordinary thing, as though you spoke last week."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "sent", "label": "Sent it", "description": "Broke the silence rather than waiting." },
      { "key": "no_apology", "label": "No apology", "description": "Did not open by accounting for the gap." },
      { "key": "ordinary", "label": "Kept it ordinary", "description": "Sent the thing they would have sent anyway." },
      { "key": "no_explaining", "label": "Did not explain the time", "description": "Left the two years unremarked." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two years since you last spoke to somebody you were once close to. You have just seen something they would find very funny.",
    "partner": {
      "name": "Priya",
      "role": "a friend you have not spoken to in two years",
      "personality": "Delighted and immediately back to normal at an ordinary message. Becomes slightly formal and apologetic in return if the gap is made the subject.",
      "mood": "Quiet evening, phone nearby.",
      "openness": 5
    },
    "opening_beat": "Two years of nothing, and the message box is open.",
    "success_looks_like": "The user sends an ordinary message with no apology in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply as though you spoke last week if the message is ordinary.",
      "Reply with your own apology and some awkwardness if the gap is made the subject.",
      "Never message first."
    ]
  }$j$::jsonb,
  $md$Today, message one person you have not spoken to in over a year, with no apology in it. Log who and what you sent.$md$
),
(
  (select id from public.skills where slug = 'keeping-it-alive'),
  3,
  'Different rhythms are not failing',
  $md$People apply one standard to every friendship they have, and it is usually the standard of whichever friendship is the most frequent. Everything else then looks like it is going wrong.

**The move:** work out each friendship's actual rhythm, and stop measuring it against a different one.

Some run weekly. Some run on a coffee every couple of months. Some are two dinners a year and are among the closest relationships in your life. Those are not degraded versions of each other — they are different shapes, and the twice-a-year one is frequently the one you would call at three in the morning.

Confusing them causes two specific problems. It produces guilt about friendships that are working perfectly well, because they do not look like the weekly ones. And it produces a low-level sense of failing at friendship generally, which is one of the more common and least accurate feelings people carry around.

What actually indicates health is not frequency. It is whether the thing restarts easily. A friendship you can pick up after four months with no ceremony is in excellent condition, whatever the calendar says. One that needs a run-up, an apology and half an hour of reacquainting is worth attention regardless of how often you meet.

The practical version is to name the rhythm and then relax into it. *We are twice-a-year people* is a real and useful thought — it removes the guilt, and it also stops you accidentally letting a twice-a-year friendship become a never friendship because you were waiting to have time for the weekly version.

And beware the opposite error: assuming somebody wants a lower-frequency thing than they do. Some lapses are not rhythms at all, they are two people who would both like more and are both being polite. If you are not sure, propose something — the answer is one message away.

If you keep one thing: judge by how easily it restarts, not by how often it happens.$md$,
  $j$[
    {
      "situation": "You feel guilty about a friend you see twice a year.",
      "line": "(that may be the rhythm, not a failure)",
      "why": "Some of the closest relationships in your life run at two dinners a year. Measuring them against a weekly one produces guilt about something working perfectly well."
    },
    {
      "situation": "You are wondering whether a friendship is in good shape.",
      "line": "(how easily does it restart?)",
      "why": "That is the real indicator. Four months with no ceremony is excellent condition, whatever the calendar says."
    },
    {
      "situation": "You have decided you and somebody are just twice-a-year people.",
      "line": "(check — propose something)",
      "why": "Some lapses are not rhythms, they are two people who would both like more and are both being polite. The answer is one message away."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually indicates a healthy friendship?",
      "options": [
        { "text": "How often you see each other.", "correct": false, "note": "The standard people apply and the least informative. Some of the closest relationships run twice a year." },
        { "text": "How easily it restarts.", "correct": true, "note": "Four months with no ceremony is excellent condition. One that needs a run-up and half an hour of reacquainting deserves attention however often you meet." },
        { "text": "How much you tell each other.", "correct": false, "note": "That is depth, which is a different axis and mostly the previous track's business." },
        { "text": "Whether you would call them in a crisis.", "correct": false, "note": "A good measure of closeness and not of whether the friendship is currently working." }
      ],
      "explain": "Different shapes, not degraded versions of the same shape."
    },
    {
      "prompt": "What is the opposite error?",
      "options": [
        { "text": "Seeing people too often.", "correct": false, "note": "Rarely a problem anybody reading this has." },
        { "text": "Assuming a lapse is a rhythm when both of you want more.", "correct": true, "note": "Two people being polite at each other can look exactly like a settled twice-a-year arrangement. If you are unsure, propose something." },
        { "text": "Trying to make every friendship weekly.", "correct": false, "note": "The first error stated differently, and it is the one already covered." },
        { "text": "Keeping too many friendships going.", "correct": false, "note": "A real constraint on capacity and not an error of judgement about rhythm." }
      ],
      "explain": "Name the rhythm, relax into it — and check, if you are guessing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_rhythm", "label": "Named the rhythm", "description": "Worked out what this friendship actually runs at." },
      { "key": "no_guilt", "label": "Dropped the guilt", "description": "Stopped measuring it against a different friendship." },
      { "key": "restart_test", "label": "Used the restart test", "description": "Judged by how easily it picks up." },
      { "key": "checked", "label": "Checked when unsure", "description": "Proposed something rather than assuming a rhythm." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are going through your friendships and feeling vaguely guilty about most of them.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Asks how easily each one picks up rather than how often you see them, and points out when the guilt is about a comparison.",
      "mood": "Calm.",
      "openness": 5
    },
    "opening_beat": "\"You have listed four people you feel bad about. How does it go when you actually see them?\"",
    "success_looks_like": "The user judges by ease of restart rather than by frequency.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask how easily each friendship restarts whenever frequency is mentioned.",
      "Push gently on any guilt that turns out to be a comparison with a different friendship.",
      "Never tell the user which friendships are fine."
    ]
  }$j$::jsonb,
  $md$Today, name the actual rhythm of one friendship you feel guilty about. Log the rhythm and whether it restarts easily.$md$
),
(
  (select id from public.skills where slug = 'keeping-it-alive'),
  4,
  'Be the one who remembers',
  $md$Almost nobody follows up on anything, which means a very small amount of remembering makes you unusual.

**The move:** write things down, and ask about them later.

The hospital appointment. The interview. The difficult conversation they were dreading with their brother. The thing they were excited about that is happening in March. People mention these constantly and are then almost never asked again — everybody means to and the detail is gone by Thursday.

Writing it down is the unglamorous half and it is what makes the rest possible. A note in your phone after seeing somebody, thirty seconds, three lines: what is going on with them, what is coming up, what they said they would do. It feels clinical written like that and it is the opposite in effect, because the alternative is a warm intention that reliably evaporates.

Then ask, later, specifically. *How did the thing with your brother go?* is worth more than an hour of general catching up, because it proves the previous conversation was real to you. This is the callback from the first date track, moved onto a timescale of months, and it works for the same reason: it cannot be faked, and it requires no wit.

There is a second-order effect worth knowing about. People tell you more when they know you will remember. Somebody who has been asked twice about something starts telling you things earlier and in more detail, because there is now a point in telling you — and that is most of what people mean when they describe somebody as easy to talk to.

It also survives distance better than anything else. Two people who see each other twice a year but ask about the right things are closer than two who see each other monthly and ask about nothing.

If you keep one thing: three lines in your phone after you see somebody. It is the least romantic advice in this app and it does more than almost anything else in it.$md$,
  $j$[
    {
      "situation": "They mentioned a hospital appointment on the fourteenth.",
      "line": "(three lines in your phone, tonight)",
      "why": "The intention is warm and it evaporates by Thursday. Writing it down is the unglamorous half that makes the rest possible."
    },
    {
      "situation": "Three weeks later, you are messaging them.",
      "line": "How did the thing with your brother go?",
      "why": "Worth more than an hour of general catching up, because it proves the previous conversation was real to you. It also cannot be faked."
    },
    {
      "situation": "Somebody keeps telling you things in unusual detail.",
      "line": "(that is because you asked twice)",
      "why": "People tell you more when there is a point in telling you, and that is most of what is meant by somebody being easy to talk to."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why write it down rather than just remember?",
      "options": [
        { "text": "Because you have a bad memory.", "correct": false, "note": "Everybody's memory does this. It is not a personal failing and it does not improve with effort." },
        { "text": "Because a warm intention reliably evaporates.", "correct": true, "note": "Everybody means to ask, and the detail is gone by Thursday. Thirty seconds of writing is what converts intention into the thing itself." },
        { "text": "Because it shows you care.", "correct": false, "note": "Nobody sees the note. What they see is the question three weeks later." },
        { "text": "Because you see a lot of people.", "correct": false, "note": "It applies just as much with four friends as with forty." }
      ],
      "explain": "Three lines after you see somebody. The least romantic advice in the app."
    },
    {
      "prompt": "What is the second-order effect?",
      "options": [
        { "text": "You become known as thoughtful.", "correct": false, "note": "Reputation, and it is the smaller half of what happens." },
        { "text": "You have more to talk about next time.", "correct": false, "note": "True and mechanical. Something more interesting happens on their side." },
        { "text": "People start telling you things earlier and in more detail.", "correct": true, "note": "Because there is now a point in telling you — and that is most of what people mean when they call somebody easy to talk to." },
        { "text": "They start asking about your life too.", "correct": false, "note": "Often, eventually, and it is not reliable enough to be the reason." }
      ],
      "explain": "It is the first date's callback, moved onto a timescale of months."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wrote_it_down", "label": "Wrote it down", "description": "Made a note rather than intending to remember." },
      { "key": "asked_later", "label": "Asked later", "description": "Followed up weeks afterwards." },
      { "key": "specific", "label": "Was specific", "description": "Named the actual thing rather than asking generally." },
      { "key": "habit", "label": "Made it routine", "description": "Did it after seeing somebody rather than once." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Three weeks ago a friend mentioned, in passing, that they were dreading a conversation with their brother about their mother's house.",
    "partner": {
      "name": "Priya",
      "role": "a friend you saw three weeks ago",
      "personality": "Visibly moved to be asked about something specific weeks later, and opens up considerably further than she did the first time.",
      "mood": "Ordinary Tuesday.",
      "openness": 5
    },
    "opening_beat": "The message box is open. It has been three weeks.",
    "success_looks_like": "The user asks about the specific thing rather than catching up generally.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond at length and warmly to a specific follow-up.",
      "Respond briefly and pleasantly to a general how are you.",
      "Never raise the subject of your brother yourself."
    ]
  }$j$::jsonb,
  $md$Today, write three lines about somebody after you see or speak to them. Log what you noted down.$md$
),
(
  (select id from public.skills where slug = 'keeping-it-alive'),
  5,
  'What to let go',
  $md$Maintenance has a budget. Nobody can keep twenty friendships warm, and pretending otherwise produces a thin layer of contact spread over too many people, which is how somebody ends up with a full contacts list and nobody to call.

**The move:** decide where the effort goes, and let the rest be what it is.

This is not about cutting anybody off. Almost nothing needs to be ended, and the ending of friendships is very rarely necessary or kind. It is about noticing that you have a limited amount of the fifteen-second messages and the three-line notes and the standing arrangements, and that spending them deliberately produces a completely different life from spreading them evenly.

Two things deserve less than they are getting. Friendships that consist entirely of obligation — where the meeting is dreaded, the conversation is an update, and the only thing keeping it going is that it always has. And the ones that only ever take: somebody who is warm when they need something and unreachable otherwise, which is a real category and is worth naming honestly rather than absorbing for another decade.

Let those find their own level. No conversation, no announcement, no dramatic pruning — just stop being the one who props it up, and see what it does. Some of them will surprise you and come good. Most will settle into something occasional and perfectly pleasant, which is where they always were.

And put what you saved somewhere. This only works as a redirection: two or three people who get the standing arrangement, the follow-up questions, and the message with nothing in it. Depth in a small number beats warmth spread across many, and it is the shape almost every genuinely well-connected person you know actually has.

The permission worth taking from this: you are allowed to choose. Friendship is not a duty roster, and quietly investing in the people you actually want is not a betrayal of anybody.

If you keep one thing: pick two or three and be excellent to them. The rest can be lovely and occasional.$md$,
  $j$[
    {
      "situation": "You are trying to keep twenty friendships warm.",
      "line": "(that produces a thin layer over too many people)",
      "why": "It is how somebody ends up with a full contacts list and nobody to call. Maintenance has a budget."
    },
    {
      "situation": "One of them is entirely obligation and you dread it.",
      "line": "(stop propping it up and see what it does)",
      "why": "No announcement and no pruning. Most settle into something occasional and pleasant, which is where they always were."
    },
    {
      "situation": "You have freed up some attention.",
      "line": "(spend it on two or three people)",
      "why": "This only works as a redirection. Depth in a small number is the shape almost every well-connected person actually has."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does spreading maintenance evenly produce?",
      "options": [
        { "text": "A wide and healthy social circle.", "correct": false, "note": "It looks like one from outside, which is exactly why the problem goes unnoticed for years." },
        { "text": "A full contacts list and nobody to call.", "correct": true, "note": "A thin layer of contact over too many people. Nobody can keep twenty friendships warm, and pretending otherwise costs the two or three that could have been deep." },
        { "text": "Exhaustion.", "correct": false, "note": "A symptom, and the more damaging outcome is what it does to the friendships rather than to you." },
        { "text": "Resentment.", "correct": false, "note": "Sometimes, and it is not the structural result. Plenty of people do this cheerfully and still end up alone on a Sunday." }
      ],
      "explain": "Pick two or three and be excellent to them. The rest can be lovely and occasional."
    },
    {
      "prompt": "How do you let one go?",
      "options": [
        { "text": "Have an honest conversation about it.", "correct": false, "note": "Almost never necessary and frequently unkind. There is nothing to resolve and nobody has done anything wrong." },
        { "text": "Stop replying.", "correct": false, "note": "That is ending it, which is a different and much harsher act than letting it find its level." },
        { "text": "Stop propping it up and let it find its level.", "correct": true, "note": "No announcement, no pruning. Some come good and surprise you; most settle into something occasional, which is where they already were." },
        { "text": "Be honest that you have less time now.", "correct": false, "note": "It makes an unremarkable change into an event, and invites a conversation neither of you needs to have." }
      ],
      "explain": "Nothing needs ending. The effort simply goes somewhere else."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose", "label": "Chose where it goes", "description": "Picked a small number to invest in." },
      { "key": "no_ending", "label": "Ended nothing", "description": "Let things find their level rather than cutting anybody off." },
      { "key": "redirected", "label": "Redirected rather than reduced", "description": "Spent what was freed rather than just doing less." },
      { "key": "no_guilt", "label": "Took the permission", "description": "Accepted that choosing is allowed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are tired, you have a lot of people you owe messages to, and you have not properly seen either of your two closest friends in months.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Asks who actually matters and where the effort is currently going, and does not accept everybody as an answer.",
      "mood": "Direct and kind.",
      "openness": 5
    },
    "opening_beat": "\"You are knackered and you owe about nine people a message. Who actually matters here?\"",
    "success_looks_like": "The user picks a small number rather than trying to service everybody.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Refuse everybody as an answer and ask for names.",
      "Push back on any plan that involves ending or confronting anybody.",
      "Be pleased by a decision to invest in two or three people."
    ]
  }$j$::jsonb,
  $md$Today, decide who you want to be excellent to this year. Two or three names, no more. Log them.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('keeping-it-alive', 1, 'line', $j${
  "says": "Nine in the evening. A friend you have not spoken to in five weeks mentioned last time that they had a job interview coming up.",
  "model": {
    "line": "How did that interview go in the end?",
    "why": "Fifteen seconds, nothing asked for, and it proves the last conversation was actually heard. Most people are never asked twice about anything."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Follow up on the thing they told you",
      "words": ["interview", "job"] },
    { "kind": "forbids_any", "requirement": "No ask, and no apology for the gap",
      "words": ["sorry", "ages", "terrible at", "been meaning to", "are you free", "shall we", "fancy a", "let us sort"] },
    { "kind": "max_words", "requirement": "Fifteen seconds, not a catch-up", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('keeping-it-alive', 2, 'line', $j${
  "says": "Two years since you last spoke to somebody you were once close to. You have just seen something they would find very funny.",
  "model": {
    "line": "This is the most you thing I have seen all year.",
    "why": "The ordinary message, sent as though you spoke last week. An apology would make the gap the subject and ask them to reassure you before anything else could happen."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not make the gap the subject",
      "words": ["sorry", "so long", "ages", "terrible at keeping", "been meaning", "i know it has been", "out of the blue", "random", "no idea if you"] },
    { "kind": "max_words", "requirement": "Ordinary, and short", "n": 25 },
    { "kind": "max_questions", "requirement": "It does not need to ask anything", "n": 1 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('keeping-it-alive', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You see one friend weekly, one every couple of months, and one twice a year. You feel guilty about two of them.",
      "prompt": "What is the guilt actually about?",
      "options": [
        { "text": "Not making enough time for people.", "correct": false, "note": "The feeling as reported. Look at what it is being measured against." },
        { "text": "A comparison with the weekly one.", "correct": true, "note": "People apply the standard of their most frequent friendship to all the others, and everything else then looks like it is going wrong." },
        { "text": "Knowing those friendships are fading.", "correct": false, "note": "Frequency is not fading. The test is whether they restart easily, and twice a year can restart instantly." },
        { "text": "Being a bad friend generally.", "correct": false, "note": "The conclusion the comparison produces, and one of the least accurate feelings people carry around." }
      ]
    },
    {
      "situation": "You have decided you and somebody are simply twice-a-year people.",
      "prompt": "How confident should you be?",
      "options": [
        { "text": "Confident — it has been that way for years.", "correct": false, "note": "Years of politeness looks identical to years of settled rhythm from the inside." },
        { "text": "Not very — propose something and find out.", "correct": true, "note": "Some lapses are not rhythms at all, they are two people who would both like more and are both being polite. The answer is one message away." },
        { "text": "Confident, if neither of you has suggested more.", "correct": false, "note": "Neither suggesting anything is precisely what the polite version looks like." },
        { "text": "It does not matter — the rhythm is fine either way.", "correct": false, "note": "It is fine if it is chosen. It is a loss if both of you wanted more and neither said." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('keeping-it-alive', 4, 'line', $j${
  "says": "Three weeks ago a friend mentioned, in passing, that they were dreading a conversation with their brother about their mother's house.",
  "model": {
    "line": "How did it go with your brother in the end?",
    "why": "Specific, three weeks later, and worth more than an hour of general catching up — because it proves the previous conversation was real to you and it cannot be faked."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Name the actual thing they told you",
      "words": ["brother", "house", "mother"] },
    { "kind": "forbids_any", "requirement": "Specific, not a general catch-up",
      "words": ["how are you", "how are things", "how is everything", "long time", "what have you been up to", "hope you are well"] },
    { "kind": "max_words", "requirement": "One question", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('keeping-it-alive', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You owe about nine people a message and have not properly seen either of your two closest friends in months.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Work through the nine — they have been waiting.", "correct": false, "note": "A thin layer of contact spread over too many people, which is how somebody ends up with a full contacts list and nobody to call." },
        { "text": "Pick two or three and be excellent to them.", "correct": true, "note": "Depth in a small number beats warmth spread across many, and it is the shape almost every genuinely well-connected person actually has." },
        { "text": "Send everybody a short one so nobody is neglected.", "correct": false, "note": "Fair, and it spends the whole budget on being fair rather than on anybody." },
        { "text": "Cut the list down properly and tell people.", "correct": false, "note": "Nothing needs ending, and announcing it makes an unremarkable change into an event." }
      ]
    },
    {
      "situation": "One friendship is entirely obligation. You dread the meetings and neither of you enjoys them.",
      "prompt": "How does it end?",
      "options": [
        { "text": "Have an honest conversation about where it stands.", "correct": false, "note": "Almost never necessary and frequently unkind. There is nothing to resolve and nobody has done anything wrong." },
        { "text": "Keep going — you have known them twenty years.", "correct": false, "note": "The only thing keeping it going is that it always has, which is the definition of the category this lesson is about." },
        { "text": "Stop being the one who props it up.", "correct": true, "note": "No announcement and no pruning. Some come good and surprise you; most settle into something occasional and pleasant, which is where they already were." },
        { "text": "Stop replying and let them work it out.", "correct": false, "note": "That is ending it, and harshly. Letting something find its level is not the same as withdrawing from it." }
      ]
    }
  ]
}$j$::jsonb);

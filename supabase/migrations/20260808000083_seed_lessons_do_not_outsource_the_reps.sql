-- Talking to AI, track 6: Do not outsource the reps.
--
-- The last track of the last topic, so lesson five is effectively the app's
-- closing argument. It says plainly that nobody has ever become less shy by
-- sending better messages, which is against the interest of a product built on
-- this technology and is the reason the topic is credible at all.
--
-- Lesson two draws the line the second track deferred: preparation is not
-- pretending, but where the effort is the message, outsourcing it is a real
-- problem rather than a scruple.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'do-not-outsource-the-reps'),
  1,
  'Never in the moment',
  $md$Everything useful in this topic happens before a conversation or after it. Nothing useful happens during one.

**The move:** prepare before, review after, nothing live.

The practical objection first, because it settles most cases on its own: it does not work. Reading a screen mid-conversation costs you the thing the conversation was made of. You stop listening, your timing goes, and you answer the sentence from ten seconds ago. People can see it happening, and what they see is somebody who has left.

Then the one that matters more. A conversation you got through with help teaches you nothing about the next one, and the next one will not have any. The discomfort you routed around was where the improvement was — that is not a moralistic claim, it is how any skill works. A rep you did not do is a rep you did not do.

This is also where the whole app's promise is at stake. Reps exists to make you better at this, and better means the thing happens in you rather than in a device. Live assistance produces a person who performs well with a phone and no better without one, which is a worse outcome than never having used it, because it feels like progress.

The line is not always obvious, so a few cases.

**Looking something up mid-conversation that you would have looked up anyway** — a date, a spelling, the name of the place — is fine and always was. That is a fact, not a line.

**Drafting a reply in a chat while messaging somebody** is live assistance, whatever it feels like. Messaging's rules apply and the tool is not one of them.

**Stepping out of a meeting to think** is legitimate and is not this. Thinking is allowed.

**A written conversation happening in real time** is the genuinely hard case. If you would not use it in a room, do not use it here.

If you keep one thing: before and after, never during. A rep you did not do is a rep you did not do.$md$,
  $j$[
    {
      "situation": "You want help while the conversation is happening.",
      "line": "(before or after — not now)",
      "why": "You stop listening and answer the sentence from ten seconds ago. What people see is somebody who has left."
    },
    {
      "situation": "You need a date or a spelling mid-conversation.",
      "line": "(that is fine — it is a fact)",
      "why": "Looking up something you would have looked up anyway was never the problem."
    },
    {
      "situation": "It is a written conversation happening in real time.",
      "line": "(if you would not do it in a room, do not do it here)",
      "why": "The hard case, and the test is the same one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the stronger objection to live help?",
      "options": [
        { "text": "It is dishonest.", "correct": false, "note": "Arguable and not the load-bearing reason. Preparation is not dishonest either." },
        { "text": "You get caught looking at your phone.", "correct": false, "note": "The practical one, and being unseen would not make it work." },
        { "text": "It is slow.", "correct": false, "note": "It is, and speed is a symptom of the real cost." },
        { "text": "You learn nothing, and the next one has no help.", "correct": true, "note": "The discomfort you routed around was where the improvement was. A rep you did not do is a rep you did not do." }
      ],
      "explain": "Before and after. Nothing live."
    },
    {
      "prompt": "Which of these is not live assistance?",
      "options": [
        { "text": "Drafting a reply while messaging somebody.", "correct": false, "note": "Live, whatever it feels like. Messaging's rules apply and this is not one of them." },
        { "text": "Stepping out of a meeting to think.", "correct": true, "note": "Thinking is allowed, and it always was. This is not the thing being ruled out." },
        { "text": "Checking what to say next mid-call.", "correct": false, "note": "The central case." },
        { "text": "Having it listen and suggest lines.", "correct": false, "note": "The most live version there is." }
      ],
      "explain": "Looking up a fact you would have looked up anyway is also fine."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_during", "label": "Nothing live", "description": "No help mid-conversation." },
      { "key": "prepared", "label": "Prepared before", "description": "Did the work in advance instead." },
      { "key": "reviewed", "label": "Reviewed after", "description": "Took the learning afterwards." },
      { "key": "present", "label": "Stayed in the room", "description": "Listened rather than managed a screen." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are in a conversation that has become difficult and your hand has gone to your phone.",
    "partner": {
      "name": "Marcus",
      "role": "a friend mid-conversation with you",
      "personality": "Notices the pause and waits, without filling the silence.",
      "mood": "Patient.",
      "openness": 5
    },
    "opening_beat": "\"...you have gone somewhere else.\"",
    "success_looks_like": "The user stays in the conversation and answers badly rather than well.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Wait through the pause without helping.",
      "Accept a clumsy answer warmly.",
      "Never mention the phone directly."
    ]
  }$j$::jsonb,
  $md$Today, get through one difficult moment without checking anything. Log what you said instead.$md$
),
(
  (select id from public.skills where slug = 'do-not-outsource-the-reps'),
  2,
  'When the effort is the message',
  $md$The second track argued that preparation is not pretending, and it is not. There is a real line, though, and this is it.

For a particular set of messages, the content is almost beside the point. Condolence. Apology. Thanks that is actually meant. Congratulations to somebody who will remember who said something. What those messages communicate is not their sentences. It is that somebody stopped, thought about you, and did it.

**The move:** when the effort is the message, write it yourself, badly.

Outsourced, a better sentence is worth less than nothing. If it is ever noticed — and the fourth lesson of the previous track is a list of how it is noticed — the damage is not that the writing was assisted. It is the retrospective discovery that the thought was not there, which is precisely the thing the message existed to convey. A clumsy note is warm. A polished note that turns out to have been generated is colder than silence.

*I did not know what to say when I heard* is a complete condolence message. It is also true, which is why it works. Nothing that could be written for you will improve on it, and every improvement makes it worse in the same direction: it will sound like it was easy to write, and it was not supposed to be easy to write.

The same holds for an apology, with an extra edge. An apology is a demonstration that you have thought about what you did. A generated one is a demonstration that you have not, whatever its words say.

The test is one question: **is the effort part of what this communicates?** If yes, it is yours. Almost everything else — the request, the arrangement, the update, the reply to a landlord, the covering note — is not, and there the tool is fine and this whole objection does not apply.

One softer case worth allowing. If you cannot start at all, and the alternative is that the message does not get sent for three weeks, then two bad sentences of your own beat silence and the third track already tells you how to produce them. What you must not do is hand over the sentiment.

If you keep one thing: if the effort is the message, your worse sentence is the better one.$md$,
  $j$[
    {
      "situation": "Somebody has had bad news.",
      "line": "I did not know what to say when I heard.",
      "why": "A complete message, and it is true. Every improvement makes it sound like it was easy to write."
    },
    {
      "situation": "You owe somebody an apology.",
      "line": "(this one is yours)",
      "why": "An apology demonstrates that you thought about what you did. A generated one demonstrates the opposite, whatever its words say."
    },
    {
      "situation": "You cannot start at all.",
      "line": "(two bad sentences of your own beat three weeks of silence)",
      "why": "Getting it sent matters. What you must not hand over is the sentiment."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the test?",
      "options": [
        { "text": "Whether the message is personal.", "correct": false, "note": "Close, and plenty of personal messages are pure logistics." },
        { "text": "Whether it would upset them to know.", "correct": false, "note": "A consequence of the answer rather than the test itself." },
        { "text": "Is the effort part of what this communicates?", "correct": true, "note": "If yes, it is yours. Almost everything else is not, and there the objection does not apply at all." },
        { "text": "Whether it is about feelings.", "correct": false, "note": "Overlaps, and a warm update about a project is not in this category." }
      ],
      "explain": "Your worse sentence is the better one."
    },
    {
      "prompt": "Why is a polished condolence worse than a clumsy one?",
      "options": [
        { "text": "Clumsy writing is more moving.", "correct": false, "note": "Not in general — this is about one specific kind of message." },
        { "text": "Polished writing sounds insincere.", "correct": false, "note": "Not inherently. Plenty of sincere people write well." },
        { "text": "It is longer, and length is wrong here.", "correct": false, "note": "Often true and not the mechanism." },
        { "text": "It sounds like it was easy to write.", "correct": true, "note": "And it was not supposed to be easy. The effort was the content." }
      ],
      "explain": "Colder than silence, if it is ever noticed."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "own_words", "label": "Wrote it yourself", "description": "No help with the sentiment." },
      { "key": "test", "label": "Applied the test", "description": "Asked whether effort was the content." },
      { "key": "sent_it", "label": "Sent it", "description": "Did not let the rule become silence." },
      { "key": "tool_elsewhere", "label": "Still used it elsewhere", "description": "Logistics and requests unaffected." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has had bad news and you have been staring at the message box for a day and a half.",
    "partner": {
      "name": "Robin",
      "role": "a friend sitting with you",
      "personality": "Asks what you would say if they were in the room, and treats the answer as sufficient.",
      "mood": "Gentle.",
      "openness": 5
    },
    "opening_beat": "\"If they were here, what would you say?\"",
    "success_looks_like": "The user writes something plain and true in their own words.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what they would say out loud.",
      "Treat a short, awkward answer as complete.",
      "Never suggest any wording."
    ]
  }$j$::jsonb,
  $md$Today, write one message where the effort is the point, in your own words. Log what you sent.$md$
),
(
  (select id from public.skills where slug = 'do-not-outsource-the-reps'),
  3,
  'Send the sixth one cold',
  $md$Used well, this is a tool that teaches. Used every time, it is a tool that replaces — and the two look identical from the inside, because both produce good messages.

**The move:** run five past it, then send the sixth without.

The distinction that matters is where the skill ends up living. If the habits are transferring, you will notice yourself writing the ask in the first line before anybody suggests it, deleting *just* as you type it, cutting the apology before it is finished. If they are not, you will keep producing the same first draft you always did, corrected each time by something else, indefinitely.

There is only one way to find out which is happening, and it is to send something without checking.

Do it deliberately rather than by accident. Pick a message that matters slightly — not the difficult one and not a one-word reply — write it, apply what you know, and send it. Then, afterwards, run it past and see what it would have changed. That order is the whole exercise: the answer arrives after the message has gone, so it is information rather than a safety net.

Most people find that the sixth one is fine, and that it is fine in the specific ways they have been practising: shorter, ask first, no crouch at the front. The corrections that come back are smaller than expected, and often they are stylistic rather than structural.

Some people find the opposite, and that is more useful than a fine message. It tells you which habits have not transferred, and you now know which two things to watch for by hand.

Keep the ratio moving. Five and one becomes three and one becomes the occasional check on something that matters. The end state is not never using it — it is using it for the things in the third track's list, on a draft that did not need much doing to it.

If you keep one thing: send something unchecked on purpose. It is the only way to find out where the skill is living.$md$,
  $j$[
    {
      "situation": "Everything you send has been checked for a month.",
      "line": "(send the next one cold)",
      "why": "It is the only way to find out whether the habits are in you or in the tool."
    },
    {
      "situation": "You want to learn from it anyway.",
      "line": "(run it past after sending)",
      "why": "The answer arrives after the message has gone, which makes it information rather than a safety net."
    },
    {
      "situation": "The cold one came back needing real changes.",
      "line": "(now you know which two to watch)",
      "why": "More useful than a message that was fine, because it names the habits that have not transferred."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why send it before checking rather than after?",
      "options": [
        { "text": "It saves time.", "correct": false, "note": "The same work either way, in a different order." },
        { "text": "Checking afterwards makes it information, not a net.", "correct": true, "note": "The message has gone, so the answer teaches instead of rescuing. That order is the whole exercise." },
        { "text": "You will be more honest about it.", "correct": false, "note": "Possibly, and honesty is not what the ordering is protecting." },
        { "text": "The message will be better.", "correct": false, "note": "It will very likely be slightly worse. That is the price of finding out." }
      ],
      "explain": "Five past it, then the sixth cold."
    },
    {
      "prompt": "What does a cold message needing real changes tell you?",
      "options": [
        { "text": "You should keep checking everything.", "correct": false, "note": "The opposite conclusion. It means the transfer has not happened yet, so it needs to start." },
        { "text": "The habits were never going to transfer.", "correct": false, "note": "Too fatalistic. They transfer with practice, which is what this is." },
        { "text": "You picked too hard a message.", "correct": false, "note": "Possible, and the fix is to keep going rather than to retreat to easier ones." },
        { "text": "Which two habits to watch by hand.", "correct": true, "note": "More useful than a message that was fine, because it names what has not landed yet." }
      ],
      "explain": "Then keep the ratio moving: five and one, three and one, occasional."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "cold", "label": "Sent one unchecked", "description": "Deliberately, not by accident." },
      { "key": "after", "label": "Checked afterwards", "description": "Learned without being rescued." },
      { "key": "named", "label": "Named what had not transferred", "description": "Knows which habits to watch." },
      { "key": "ratio", "label": "Moved the ratio", "description": "Checking less than last month." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have not sent an unchecked message in about a month and you are aware of it.",
    "partner": {
      "name": "Robin",
      "role": "a friend sitting with you",
      "personality": "Asks when you last sent something without running it past anything.",
      "mood": "Interested.",
      "openness": 5
    },
    "opening_beat": "\"When did you last just send one?\"",
    "success_looks_like": "The user commits to sending the next one cold.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what would happen if it went unchecked.",
      "Be satisfied by a commitment to one message.",
      "Never comment on the writing itself."
    ]
  }$j$::jsonb,
  $md$Today, send one message without checking it, then look at it afterwards. Log the difference.$md$
),
(
  (select id from public.skills where slug = 'do-not-outsource-the-reps'),
  4,
  'Polishing is avoidance',
  $md$Forty minutes on a two-line message is not care. It is the same avoidance as not sending it, wearing the costume of work.

**The move:** notice the third version, and send it.

The tell is that it feels productive. Genuine avoidance — closing the laptop, going for a walk, deciding to do it tomorrow — announces itself, and you know what you are doing while you do it. Polishing does not. You are working on the message. You have been working on it for an hour. Every pass makes some small improvement, and the message has not been sent, which was the only thing that was ever going to matter.

The tool makes this much easier to do, because it will always produce another version. There is no natural stopping point, no friction, and no moment at which anything says *that is enough now*. A person editing on their own eventually gets bored. This does not.

Three signs, in the order they usually appear.

**You have started reversing earlier changes.** Putting back a sentence you cut two versions ago is the clearest possible signal that you have stopped improving and started circling.

**The changes are getting smaller.** Word choice rather than structure. Structure was worth several passes and word choice is worth none.

**You are checking how it sounds rather than what it says.** That is the previous track's territory, and it is unanswerable, which is exactly why it can absorb an hour.

The rule that ends it: **two passes.** One for structure, one for cuts. Then send. If a third pass is genuinely needed, the message is more difficult than it looked and probably belongs to Messaging's last track, where the answer is a call.

And notice what the hour is protecting you from. It is not a bad message. It is the moment after sending, when it is out of your hands. That moment is coming regardless, and every version delays it by exactly the length of the version.

If you keep one thing: two passes, then send. If you are putting back what you cut, you finished a while ago.$md$,
  $j$[
    {
      "situation": "You are putting back a sentence you cut two versions ago.",
      "line": "(you finished a while ago)",
      "why": "The clearest possible signal that you have stopped improving and started circling."
    },
    {
      "situation": "The changes have become word choice.",
      "line": "(structure was worth passes — this is not)",
      "why": "Two passes: one for structure, one for cuts. Then send."
    },
    {
      "situation": "You are asking how it will sound.",
      "line": "(unanswerable, which is why it takes an hour)",
      "why": "It is the previous track's territory, and there is no version of it that resolves."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What makes polishing harder to spot than ordinary avoidance?",
      "options": [
        { "text": "It produces a better message.", "correct": false, "note": "Marginally, for the first two passes, then not at all." },
        { "text": "It is quicker.", "correct": false, "note": "It is much slower, which is part of the cost." },
        { "text": "It feels productive.", "correct": true, "note": "Closing the laptop announces itself. Working on the message does not, and every pass makes some small improvement." },
        { "text": "Other people encourage it.", "correct": false, "note": "Nobody knows you are doing it." }
      ],
      "explain": "Two passes, then send."
    },
    {
      "prompt": "What is the hour actually protecting you from?",
      "options": [
        { "text": "Sending something badly written.", "correct": false, "note": "That risk ended after the second pass." },
        { "text": "Being misunderstood.", "correct": false, "note": "A real worry and not what the extra versions address." },
        { "text": "Having to decide what you want.", "correct": false, "note": "Sometimes true and it belongs earlier, before the drafting starts." },
        { "text": "The moment after sending.", "correct": true, "note": "When it is out of your hands. That moment is coming regardless, delayed by exactly the length of each version." }
      ],
      "explain": "And the tool will always produce another one. It never gets bored."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "two_passes", "label": "Two passes", "description": "Structure, cuts, send." },
      { "key": "noticed", "label": "Noticed the circling", "description": "Caught a reversed change." },
      { "key": "sent", "label": "Sent it", "description": "Did not produce a fourth version." },
      { "key": "escalated", "label": "Escalated if it needed three", "description": "Recognised when it wanted a call." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are on the fifth version of a two-line message and have just restored a sentence you cut earlier.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Asks how long this has taken and what the message actually says.",
      "mood": "Dry.",
      "openness": 5
    },
    "opening_beat": "\"How long have you been on that?\"",
    "success_looks_like": "The user sends the version they have.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what has changed since version two.",
      "Be unimpressed by improvements to word choice.",
      "Never read or judge the message itself."
    ]
  }$j$::jsonb,
  $md$Today, send a message after two passes instead of five. Log how long it took.$md$
),
(
  (select id from public.skills where slug = 'do-not-outsource-the-reps'),
  5,
  'The reps are with people',
  $md$This is the last lesson of the last topic, so it is worth saying the honest thing plainly.

Nobody has ever become less shy by sending better messages.

Everything in this topic is real. Preparing properly works. Asking the question you were embarrassed to ask closes gaps that had been closed for years. Rehearsing out loud against a difficult version genuinely changes how Tuesday goes. Cutting the apology out of a draft makes you easier to answer, and being easy to answer changes how people treat you. None of that is a consolation prize.

But every one of those is a way of arriving better prepared at a moment that still has to happen. The moment itself — the turning up, the saying it, the first thirty seconds where nobody has helped you, the pause where you do not know what they are thinking — is the part that changes you, and it has no version that can be done at a desk.

**The move:** convert every preparation into an actual conversation, this week.

That is the whole discipline. Preparation that does not turn into a conversation is not preparation, it is a hobby. A rehearsed opening that never gets said is a paragraph. A closed knowledge gap that never gets mentioned is trivia. The tool produces potential, which is worth exactly nothing until it is spent.

There is a failure mode that this app should name because it is the one most likely to catch its own readers: getting very good at the preparation. Reading the lessons, doing the drills, running the rehearsals, and finding that the week contained no conversations. It feels like progress. It reports like progress. It is the same avoidance as the fourth lesson, at the scale of a life instead of an afternoon.

The measure was never how well you can prepare. It was whether you said the thing.

If you keep one thing: it can help you get ready. It cannot go instead of you, and the going is the part that counts.$md$,
  $j$[
    {
      "situation": "You have prepared thoroughly and had no conversations.",
      "line": "(that is a hobby, not preparation)",
      "why": "Preparation produces potential, which is worth nothing until it is spent."
    },
    {
      "situation": "A rehearsed opening is still unsaid on Friday.",
      "line": "(it is a paragraph until you say it)",
      "why": "The moment itself is the part that changes you, and it has no version that can be done at a desk."
    },
    {
      "situation": "The week felt productive.",
      "line": "(count the conversations)",
      "why": "It reports like progress. The measure was never how well you can prepare."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the failure mode this lesson names?",
      "options": [
        { "text": "Relying on it to write for you.", "correct": false, "note": "The third track's problem, and it is about the message rather than about you." },
        { "text": "Getting very good at preparing.", "correct": true, "note": "It feels like progress and reports like progress. It is the fourth lesson's avoidance at the scale of a life." },
        { "text": "Trusting it about people.", "correct": false, "note": "The previous track, and it is a calibration problem rather than this one." },
        { "text": "Using it during conversations.", "correct": false, "note": "The first lesson of this track." }
      ],
      "explain": "Preparation that does not become a conversation is a hobby."
    },
    {
      "prompt": "What can only happen in the conversation itself?",
      "options": [
        { "text": "Finding the right words.", "correct": false, "note": "Very often found beforehand, and that is what the fourth track is for." },
        { "text": "Learning what they think.", "correct": false, "note": "It happens there, and it is information rather than the thing that changes you." },
        { "text": "Discovering your case is weak.", "correct": false, "note": "A good rehearsal finds that on Sunday, which is the point of asking it not to concede." },
        { "text": "The part with no help in it.", "correct": true, "note": "The turning up, the first thirty seconds, the pause where you do not know what they are thinking. That is the part that changes you." }
      ],
      "explain": "It can help you get ready. It cannot go instead of you."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "converted", "label": "Turned preparation into a conversation", "description": "Said the thing this week." },
      { "key": "counted", "label": "Counted conversations, not sessions", "description": "Measured the right thing." },
      { "key": "unprepared", "label": "Had one you did not prepare", "description": "Turned up without a plan." },
      { "key": "no_hobby", "label": "No preparation left unspent", "description": "Nothing rehearsed and unsaid." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has asked how the last month of getting better at this has gone.",
    "partner": {
      "name": "Sam",
      "role": "a friend who knows what you have been working on",
      "personality": "Asks how many actual conversations there were, and is not interested in the preparation.",
      "mood": "Warm and direct.",
      "openness": 5
    },
    "opening_beat": "\"How many real conversations, though?\"",
    "success_looks_like": "The user answers with conversations rather than preparation, and names the next one.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask for a number of conversations.",
      "Show no interest in how thorough the preparation was.",
      "Never tell the user what to do next."
    ]
  }$j$::jsonb,
  $md$Today, turn one thing you prepared into an actual conversation. Log what you said.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('do-not-outsource-the-reps', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A conversation has become difficult and your hand has gone to your phone.",
      "prompt": "What is the strongest reason not to?",
      "options": [
        { "text": "They will see you doing it.", "correct": false, "note": "They will, and being unseen would not make it work." },
        { "text": "It is too slow to be useful.", "correct": false, "note": "It is, and slowness is a symptom of the real cost rather than the cost." },
        { "text": "A rep you did not do is a rep you did not do.", "correct": true, "note": "The discomfort you routed around was where the improvement was, and the next conversation will not have any help either." },
        { "text": "It would be dishonest.", "correct": false, "note": "Arguable, and preparation is not dishonest, so honesty is not what separates the two." }
      ]
    },
    {
      "situation": "You need a date you cannot remember, in the middle of the conversation.",
      "prompt": "Is that the same thing?",
      "options": [
        { "text": "No — it is a fact, and you would have looked it up anyway.", "correct": true, "note": "Looking something up was never the problem. The line is about what to say, not about what is true." },
        { "text": "Yes, any phone use breaks the rule.", "correct": false, "note": "Too broad, and it would make the rule useless in practice." },
        { "text": "Only if you do it openly.", "correct": false, "note": "Openness is courtesy rather than the distinction." },
        { "text": "Yes, because it interrupts the conversation.", "correct": false, "note": "Briefly, and the interruption is not what the rule protects." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-not-outsource-the-reps', 2, 'line', $j${
  "says": "If they were here, what would you say?",
  "model": {
    "line": "I would just say I did not know what to say when I heard, and that I am around if they want company.",
    "why": "A complete message, and it is true. Every improvement makes it sound like it was easy to write, and it was not supposed to be."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not reach for a written register",
      "words": ["deepest condolences", "thoughts and prayers", "during this difficult time", "so sorry for your loss", "if there is anything i can do"] },
    { "kind": "min_words", "requirement": "Say the plain true thing", "n": 8 },
    { "kind": "max_words", "requirement": "Short is correct here", "n": 32 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-not-outsource-the-reps', 3, 'line', $j${
  "says": "When did you last just send one?",
  "model": {
    "line": "Not for about a month. The next one goes cold, and I will look at it afterwards to see what I missed.",
    "why": "Sending first makes the answer information rather than a safety net, and it is the only way to find out where the skill is living."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Commit to sending one unchecked", "words": ["cold", "without", "unchecked", "just send", "straight", "next one"] },
    { "kind": "forbids_any", "requirement": "Do not keep the safety net",
      "words": ["check it first", "run it past", "just to be safe", "have a quick look", "if it is important i will"] },
    { "kind": "max_words", "requirement": "A commitment, not a plan", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-not-outsource-the-reps', 4, 'line', $j${
  "says": "How long have you been on that? It is two lines.",
  "model": {
    "line": "An hour. I have just put back a sentence I cut earlier, which means I finished a while ago. Sending it.",
    "why": "Restoring a cut is the clearest signal that you stopped improving and started circling. Two passes, then send."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not defend another pass",
      "words": ["one more", "nearly there", "just the last bit", "want to get it right", "almost done", "another version"] },
    { "kind": "contains_any", "requirement": "Say you are sending it", "words": ["send", "sending", "gone", "sent", "going now"] },
    { "kind": "max_words", "requirement": "Stop, do not narrate", "n": 32 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-not-outsource-the-reps', 5, 'choice', $j${
  "beats": [
    {
      "situation": "A month of preparing thoroughly, and a friend asks how it has gone.",
      "prompt": "What is the honest measure?",
      "options": [
        { "text": "How much you have learned.", "correct": false, "note": "Real, and it reports like progress while nothing has happened yet." },
        { "text": "How much better your messages are.", "correct": false, "note": "A genuine gain and still not the thing the app was ever for." },
        { "text": "How prepared you feel.", "correct": false, "note": "The least reliable of all of them, and the easiest to increase without moving." },
        { "text": "How many conversations you actually had.", "correct": true, "note": "The measure was never how well you can prepare. Preparation that does not become a conversation is a hobby." }
      ]
    },
    {
      "situation": "You have a rehearsed opening that has been ready since Sunday. It is Friday.",
      "prompt": "What is it worth?",
      "options": [
        { "text": "Nothing yet — it is a paragraph.", "correct": true, "note": "The tool produces potential, and potential is worth exactly nothing until it is spent." },
        { "text": "Most of the value, since the hard part is knowing what to say.", "correct": false, "note": "Knowing what to say is the easy half. The going is the part that counts." },
        { "text": "It will keep until you feel ready.", "correct": false, "note": "Ready does not arrive by waiting, and this is the avoidance at the scale of a life." },
        { "text": "Half — you have done the preparation properly.", "correct": false, "note": "Properly done and unspent. There is no partial credit for a conversation that did not happen." }
      ]
    }
  ]
}$j$::jsonb);

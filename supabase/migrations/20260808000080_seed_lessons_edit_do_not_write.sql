-- Talking to AI, track 3: Edit, do not write.
--
-- Messaging owns what a good message looks like. This track only settles who
-- should be holding the pen, and the answer is you, with the machine doing
-- subtraction afterwards.
--
-- Lesson five is deliberately the constructive close rather than the warning.
-- The list of things it does better than you is real and worth having, and a
-- track that ended on the tells would leave a reader with nothing to use.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'edit-do-not-write'),
  1,
  'Write it badly first',
  $md$Ask it to write your message and you get something competent: warm, well organised, slightly too long, three compliments in it, every sentence about the same length as the one before.

The problem is not quality. It is that the message is not yours, and people who know you feel it without being able to say why.

**The move:** write the bad version yourself, then hand that over.

The bad draft is not a rough starting point to be replaced. It is the only part of the process that contains you — your ordering, your priorities, the thing you thought was worth saying first, the blunt sentence you would not have chosen if you had been trying to sound nice. Everything after it is subtraction, and subtraction cannot turn your message into somebody else's.

Write it fast and badly on purpose. Do not stop to fix anything. Spelling does not matter, the order does not matter, and the sentence that is too direct is exactly the one to leave in — you can decide later whether to soften it, and you cannot recover it if it was never written.

What this also does, quietly, is stop the blank-box problem. A lot of people reach for help at the point where they do not know how to start, and that is the worst possible moment to hand it over, because there is nothing of yours for it to work from. Two bad sentences change the whole exchange from *write me something* to *fix this*.

And it protects the thing you are actually worried about. If the draft is yours, the worst outcome of the edit is a slightly tidier version of you. If the draft is not, the best outcome is a well-written message from nobody.

If you keep one thing: write two bad sentences first. They are what make everything afterwards yours.$md$,
  $j$[
    {
      "situation": "The box is blank and you do not know how to start.",
      "line": "(write two bad sentences anyway)",
      "why": "Handing over an empty box asks it to write. Handing over two bad sentences asks it to fix."
    },
    {
      "situation": "A sentence comes out too direct.",
      "line": "(leave it in)",
      "why": "You can soften it later. You cannot recover it if it was never written down."
    },
    {
      "situation": "You want to tidy the draft before sending it over.",
      "line": "(do not — send it messy)",
      "why": "Tidying is where your ordering and your bluntness get removed, which were the parts worth keeping."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the bad draft matter so much?",
      "options": [
        { "text": "It saves time overall.", "correct": false, "note": "Often it does not, and speed was never the argument." },
        { "text": "It shows you tried.", "correct": false, "note": "Nobody sees the draft. This is not about effort being visible." },
        { "text": "It is the only part containing you.", "correct": true, "note": "Your ordering, your priorities, your blunt sentence. Everything after it is subtraction, and subtraction cannot make it somebody else's." },
        { "text": "It gives it more context.", "correct": false, "note": "Partly true and it would be equally true of a description, which does not work." }
      ],
      "explain": "Write two bad sentences before you hand anything over."
    },
    {
      "prompt": "When is handing it over worst?",
      "options": [
        { "text": "When you are in a hurry.", "correct": false, "note": "Hurry is a reason to use it, not a reason it fails." },
        { "text": "When the message is important.", "correct": false, "note": "Important messages are exactly where a good edit helps most." },
        { "text": "When you already have a version.", "correct": false, "note": "That is the best moment, not the worst." },
        { "text": "When the box is still blank.", "correct": true, "note": "There is nothing of yours to work from, so write me something is the only request available." }
      ],
      "explain": "The worst outcome of editing your draft is a tidier you."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "drafted", "label": "Wrote it first", "description": "Produced a version before asking." },
      { "key": "fast", "label": "Wrote it badly", "description": "Did not stop to fix things." },
      { "key": "kept_blunt", "label": "Left the blunt sentence in", "description": "Did not pre-soften." },
      { "key": "not_blank", "label": "Never handed over a blank box", "description": "Asked for a fix, not a message." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have been staring at an empty message box for ten minutes and have just opened a chat instead.",
    "partner": {
      "name": "Robin",
      "role": "a friend sitting with you",
      "personality": "Asks what you would say if you had to send something in the next thirty seconds.",
      "mood": "Unhurried.",
      "openness": 5
    },
    "opening_beat": "\"If you had to send it right now, what would it say?\"",
    "success_looks_like": "The user produces a rough version of their own instead of asking for one.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask for the thirty-second version.",
      "Accept something clumsy as a complete answer.",
      "Never offer wording of your own."
    ]
  }$j$::jsonb,
  $md$Today, write the bad version yourself before asking for any help with it. Log both.$md$
),
(
  (select id from public.skills where slug = 'edit-do-not-write'),
  2,
  'Cut, do not improve',
  $md$*Improve this* is the request almost everybody makes, and it is the wrong verb.

Improvement, to a machine trained on a great deal of professional correspondence, means addition. You get a warmer opening. A sentence acknowledging how busy they are. A softer close. A line about looking forward to hearing from them. Every one of those is a plausible improvement, and together they produce the thing Messaging spends five lessons removing.

**The move:** ask for cuts with a number attached.

*Cut this by half without losing the ask.* The number is what makes it work — an instruction to shorten produces a light trim, and an instruction to halve forces a decision about what the message is actually for. That decision is the valuable part, and you can always put something back.

Other requests in the same family, all of them subtractive.

*Delete anything that is not the ask or the context for it.* This is a test rather than an edit, and it is the same one Storytelling applies to a story.

*Take out every hedge.* Just, quite, maybe, possibly, I think, a bit. Then read it and put back the two that were doing real work, because a small number of them are genuine.

*Which sentence could be removed without anybody noticing?* Usually there is one, and usually it is the second.

The check afterwards is quick. Compare the two versions and ask what was lost. If the answer is *nothing*, the cut was right. If something real went — a piece of context, the warmth at the end, the one detail that made it specific — put that back by hand rather than asking for a rewrite, because a rewrite will bring the rest of the furniture with it.

If you keep one thing: improve adds and cut removes. Almost every message you write needs the second one.$md$,
  $j$[
    {
      "situation": "Your draft is too long.",
      "line": "Cut this by half without losing the ask.",
      "why": "A number forces a decision about what the message is for. Shorten produces a light trim."
    },
    {
      "situation": "It is full of hedges.",
      "line": "Take out every hedge, then I will put back the ones doing work.",
      "why": "Most of them are the crouch Messaging is about, and a small number are genuine."
    },
    {
      "situation": "Something real was lost in the cut.",
      "line": "(put it back by hand)",
      "why": "Asking for a rewrite brings the warm opening and the soft close back with it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does improve this actually mean to it?",
      "options": [
        { "text": "Make it more formal.", "correct": false, "note": "Sometimes, and formality is not the direction that does the damage." },
        { "text": "Add — an opening, an acknowledgement, a soft close.", "correct": true, "note": "Every one is a plausible improvement, and together they rebuild the thing Messaging spends five lessons removing." },
        { "text": "Fix the grammar.", "correct": false, "note": "It will, and that was rarely what was wrong." },
        { "text": "Reorganise it.", "correct": false, "note": "Often part of it, and reorganising alone would be harmless." }
      ],
      "explain": "Ask for cuts, with a number attached."
    },
    {
      "prompt": "Why attach a number to the cut?",
      "options": [
        { "text": "Halving forces a decision about the purpose.", "correct": true, "note": "Shorten gets a light trim. Halve makes something choose what the message is for, and that decision is the valuable part." },
        { "text": "It makes the result predictable.", "correct": false, "note": "A convenience rather than the reason." },
        { "text": "Short messages get answered faster.", "correct": false, "note": "True, from Messaging, and it is an argument for cutting rather than for the number." },
        { "text": "It stops it arguing with you.", "correct": false, "note": "It does not argue much either way." }
      ],
      "explain": "Then compare the two and ask what was lost."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "subtractive", "label": "Asked for cuts", "description": "Used a removing verb, not improve." },
      { "key": "number", "label": "Attached a number", "description": "Half, sixty words, two sentences." },
      { "key": "compared", "label": "Checked what was lost", "description": "Read the two versions against each other." },
      { "key": "by_hand", "label": "Restored by hand", "description": "Did not ask for a rewrite." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your message has come back longer and warmer than it went in, and you are quite pleased with it.",
    "partner": {
      "name": "Robin",
      "role": "a friend reading it over your shoulder",
      "personality": "Asks what the message is for and reads out the sentences that are not doing that.",
      "mood": "Blunt but friendly.",
      "openness": 5
    },
    "opening_beat": "\"What is this message for? In one sentence.\"",
    "success_looks_like": "The user asks for a cut with a number rather than another improvement.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Read out a sentence that is not the ask or its context.",
      "Ask what would be lost if it went.",
      "Never rewrite anything yourself."
    ]
  }$j$::jsonb,
  $md$Today, ask for one draft to be halved rather than improved. Log what you lost and what you put back.$md$
),
(
  (select id from public.skills where slug = 'edit-do-not-write'),
  3,
  'Keep your own awkward sentence',
  $md$Somewhere in the edited version there will be a line of yours that has been smoothed, and you will look at the smooth one and think it is better. Often it is not.

**The move:** keep the sentence that is yours and slightly clumsy.

A clumsy sentence from a real person reads as sincere. A well-turned one reads as written. This is most obvious in exactly the messages that matter most — *I did not know what to say when I heard* is better than anything that could replace it, and every replacement is worse in the same specific way: it sounds like it was easy to write.

The test is quick. Read the two versions and ask which one you could say out loud to the person's face without feeling odd. Yours, usually. The smooth one has a small formality in it that would be strange in a room, and a message is closer to a room than to a document.

Where this matters most:

**Your first line and your last.** These carry the most voice and are the two that get replaced most readily, because openings and closings are where the conventional phrasings live.

**Anything with feeling in it.** Warmth, apology, gratitude, worry. The edited version is more articulate and less believable, and believable is the entire job.

**Your actual vocabulary.** If a word has appeared that you would not say, take it out even if it is a better word. Someone who knows you will register it, not as a suspicion about where it came from, but as a small sense that the message is oddly stiff.

The corollary is worth stating, so this does not become an argument for keeping everything. Mechanical faults — the ask buried in paragraph three, four hedges in one line, a sentence that could be read two ways — are not voice. Those are what the previous lesson removes. Voice is the phrasing you would use out loud, and clumsiness in that register is a feature.

If you keep one thing: read both aloud and keep the one you could say to their face.$md$,
  $j$[
    {
      "situation": "Your line is clumsy and the edited one is smooth.",
      "line": "(read both out loud)",
      "why": "Keep the one you could say to their face. The smooth one usually has a formality that would be strange in a room."
    },
    {
      "situation": "It is a message about something difficult.",
      "line": "I did not know what to say when I heard.",
      "why": "Every replacement is worse in the same way — it sounds like it was easy to write."
    },
    {
      "situation": "A word has appeared that you would never say.",
      "line": "(take it out, even if it is better)",
      "why": "Somebody who knows you registers it as stiffness, which is the opposite of what the message was for."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a clumsy sentence often win?",
      "options": [
        { "text": "It is shorter.", "correct": false, "note": "Not reliably. Clumsy sentences are frequently the longer ones." },
        { "text": "It shows more effort.", "correct": false, "note": "Nearly the opposite — it usually took less. What it shows is that a person wrote it." },
        { "text": "It reads as sincere; the smooth one reads as written.", "correct": true, "note": "Believable is the whole job in any message with feeling in it, and articulate is not the same thing." },
        { "text": "People distrust good writing.", "correct": false, "note": "Too broad. They do not distrust it — they simply do not hear you in it." }
      ],
      "explain": "Read both aloud and keep the one you could say to their face."
    },
    {
      "prompt": "Which of these is not voice, and should still be cut?",
      "options": [
        { "text": "A sentence that trails off oddly.", "correct": false, "note": "That is how people talk, and it survives being read out loud." },
        { "text": "A word you would use but that is imprecise.", "correct": false, "note": "Yours, and imprecision in the register you speak in is normal." },
        { "text": "An opening that is blunter than convention.", "correct": false, "note": "Almost always worth keeping, and it is the first thing an edit removes." },
        { "text": "The ask buried in the third paragraph.", "correct": true, "note": "A mechanical fault, not a voice. That is what the previous lesson is for." }
      ],
      "explain": "Voice is what you would say out loud. Structure is not voice."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept", "label": "Kept a line of your own", "description": "Rejected a smoother replacement." },
      { "key": "aloud", "label": "Read both aloud", "description": "Used the say-it-to-their-face test." },
      { "key": "vocabulary", "label": "Removed words you would not say", "description": "Even the better ones." },
      { "key": "still_cut", "label": "Still cut the mechanical faults", "description": "Did not defend structure as voice." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are choosing between your own version of a difficult sentence and a much smoother one.",
    "partner": {
      "name": "Robin",
      "role": "a friend who knows you well",
      "personality": "Asks you to read both out loud and says which one sounds like you.",
      "mood": "Attentive.",
      "openness": 5
    },
    "opening_beat": "\"Read me both. Out loud.\"",
    "success_looks_like": "The user keeps their own line.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask which one they could say to the person's face.",
      "Say plainly when a version does not sound like them.",
      "Never propose a third version."
    ]
  }$j$::jsonb,
  $md$Today, keep one clumsy sentence of your own over a smoother replacement. Log both versions.$md$
),
(
  (select id from public.skills where slug = 'edit-do-not-write'),
  4,
  'The tells',
  $md$It is worth knowing what the generated version looks like, for two reasons: so you can find it in your own drafts, and because more people can see it than used to.

**The move:** learn the tells, then defeat all of them with one specific detail.

The tells, roughly in order of how reliably they give it away.

**Nothing specific in it.** The strongest one by far. It cannot know that it was the Tuesday meeting, that they had already moved the date once, or that you were both standing in the corridor. Generated text is fluent about the general and silent about the particular, and one concrete detail does more to make a message yours than any amount of style.

**Even sentences.** Similar lengths, similar rhythm, each paragraph about the same size. Real writing is lumpy — a long sentence, then four words.

**Three of everything.** Three adjectives, three-part lists, three reasons. It is a genuinely satisfying shape and it turns up far more often than chance.

**Symmetrical hedging.** Both sides given equal weight, every claim balanced by its qualification. People writing to somebody they know are lopsided, because they have a view.

**Warmth with no cause.** An opening that hopes you are well, an acknowledgement of how busy they are, a closing that looks forward to hearing from you — none of it prompted by anything that happened.

The second reason to know these is not about detection. It is that reading a message and wondering whether a person wrote it is itself corrosive to the message, whatever the answer turns out to be. That doubt is the actual risk of leaning on it — not being caught, but writing things that invite the question.

Which points at the fix, and it is not stylistic. Put one specific thing in that only you could know. It defeats every tell on the list at once, and it is the same thing Storytelling asks for: one detail that does work.

If you keep one thing: the giveaway is that nothing in it is specific. One real detail fixes more than any amount of editing.$md$,
  $j$[
    {
      "situation": "The message is fluent and says nothing particular.",
      "line": "(that is the strongest tell)",
      "why": "It cannot know it was the Tuesday meeting, or that they had already moved the date once."
    },
    {
      "situation": "Every sentence is about the same length.",
      "line": "(real writing is lumpy)",
      "why": "A long sentence, then four words. Even rhythm is a machine rhythm."
    },
    {
      "situation": "You want to fix all of it at once.",
      "line": "(add one thing only you could know)",
      "why": "It defeats every tell on the list, and it is the same detail Storytelling asks for."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the strongest tell?",
      "options": [
        { "text": "Nothing specific in it.", "correct": true, "note": "It cannot know the particulars. Generated text is fluent about the general and silent about the concrete." },
        { "text": "Warmth with no cause.", "correct": false, "note": "A good tell, and plenty of people write hopeful openings unprompted." },
        { "text": "Three-part lists.", "correct": false, "note": "A satisfying shape that human writers use constantly too." },
        { "text": "Long words.", "correct": false, "note": "Not reliable in either direction — it often writes quite plainly." }
      ],
      "explain": "One real detail fixes more than any amount of editing."
    },
    {
      "prompt": "What is the actual risk of leaning on it?",
      "options": [
        { "text": "Writing things that invite the question.", "correct": true, "note": "Wondering whether a person wrote it is corrosive whatever the answer, and the doubt costs more than any tell." },
        { "text": "Losing the ability to write.", "correct": false, "note": "Real, and it belongs to the last track rather than to this lesson." },
        { "text": "Sounding less intelligent.", "correct": false, "note": "It usually makes you sound more polished, which is part of the problem." },
        { "text": "Being caught out.", "correct": false, "note": "Rarely happens explicitly, and it is not where the damage is." }
      ],
      "explain": "So the fix is specificity, not style."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Added something specific", "description": "One thing only you could know." },
      { "key": "lumpy", "label": "Broke the even rhythm", "description": "Varied sentence length." },
      { "key": "unbalanced", "label": "Took a side", "description": "Removed symmetrical hedging." },
      { "key": "no_filler_warmth", "label": "Cut uncaused warmth", "description": "No hoping-you-are-well." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend is reading a message you sent last week and has asked an awkward question about it.",
    "partner": {
      "name": "Marcus",
      "role": "a friend who writes for a living",
      "personality": "Points at what is missing rather than what is wrong, and asks what actually happened.",
      "mood": "Curious, not accusing.",
      "openness": 5
    },
    "opening_beat": "\"There is nothing in here that could only be about us.\"",
    "success_looks_like": "The user adds one concrete detail that only they could know.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what actually happened that week.",
      "Be satisfied by one real detail.",
      "Never accuse the user of anything directly."
    ]
  }$j$::jsonb,
  $md$Today, put one detail only you could know into a message. Log the message and the detail.$md$
),
(
  (select id from public.skills where slug = 'edit-do-not-write'),
  5,
  'What it is actually good at',
  $md$Having spent four lessons on restraint, the constructive half. There is a specific list of things it does better than you do, and refusing to use it for those is not integrity.

All of them share a property: they are facts about text rather than judgements about people. That is the line, and track five holds the other side of it.

**The move:** hand it everything mechanical about the message, and stop where a person begins.

**Moving the ask to the front.** *Put the request in the first line and the context underneath.* Instant, and it is the single most valuable edit in Messaging.

**Removing hedges.** It finds every *just*, *quite*, *maybe* and *I think* in one pass, including the ones you have read past four times because you wrote them.

**Cutting the apology.** *Delete anything apologising for asking.* This is the whole of Stop apologising, done mechanically, on a draft you would otherwise have sent.

**Finding what could be misread.** *Which sentence here could be read a second way?* It is genuinely reliable at this, because ambiguity is a property of the sentence and needs no knowledge of the reader.

**Checking the ask is findable.** *If somebody read only the first line, what would they think I want?* A fast test for the thing that gets messages answered on Thursday.

**Making a wall into a list.** Three requests buried in a paragraph become a numbered list, which is the version people actually work through.

Two more that are less obvious. Reading a long document you have been given and telling you what is being asked of you — that is comprehension of text, which it is good at, as opposed to what somebody meant by it, which it is not. And splitting one message into two when it is carrying two subjects.

Notice what is not on this list: whether to send it, what they will think, what the tone will feel like on arrival, whether they are annoyed. Those are the next track.

If you keep one thing: use it for everything mechanical about a message, and nothing about the person receiving it.$md$,
  $j$[
    {
      "situation": "The ask is buried in paragraph three.",
      "line": "Put the request in the first line and the context underneath.",
      "why": "Instant, and it is the single most valuable edit in Messaging."
    },
    {
      "situation": "You cannot see your own hedges any more.",
      "line": "Delete every just, quite, maybe and I think.",
      "why": "It finds the ones you have read past four times because you wrote them."
    },
    {
      "situation": "You are not sure how a sentence lands.",
      "line": "Which sentence here could be read a second way?",
      "why": "Ambiguity is a property of the sentence, so it needs no knowledge of the reader."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What do the reliable jobs have in common?",
      "options": [
        { "text": "They are quick.", "correct": false, "note": "They are, and so are plenty of the things it gets wrong." },
        { "text": "They are about text, not about people.", "correct": true, "note": "Facts about the sentence need no knowledge of the reader. That is the line, and the next track holds the other side of it." },
        { "text": "They are objective.", "correct": false, "note": "Close, and objectivity is not quite it — what could be misread is a judgement, just one about language." },
        { "text": "They are things you could do yourself.", "correct": false, "note": "You could, and you demonstrably do not, especially with your own hedges." }
      ],
      "explain": "Everything mechanical about the message, nothing about the person receiving it."
    },
    {
      "prompt": "Which of these is not on the list?",
      "options": [
        { "text": "Turning three buried requests into a list.", "correct": false, "note": "On it. A numbered list is the version people actually work through." },
        { "text": "Telling you what a long document asks of you.", "correct": false, "note": "On it. Comprehension of text, as opposed to what somebody meant by it." },
        { "text": "Splitting a message carrying two subjects.", "correct": false, "note": "On it, and it is one ask per message from Messaging." },
        { "text": "Telling you how the tone will land.", "correct": true, "note": "That is about the reader rather than the text, and it is the whole of the next track." }
      ],
      "explain": "Refusing to use it for the mechanical work is not integrity."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "mechanical", "label": "Used it mechanically", "description": "Ask first, hedges out, apology cut." },
      { "key": "ambiguity", "label": "Checked for misreading", "description": "Asked what could be read twice." },
      { "key": "first_line", "label": "Tested the first line", "description": "Checked the ask is findable." },
      { "key": "stopped_there", "label": "Stopped at the text", "description": "Did not ask about the person." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A message you have written is fine but is not getting answered, and you are about to ask what is wrong with your tone.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Reads the first line only and says what she thinks is being asked of her.",
      "mood": "Matter-of-fact.",
      "openness": 5
    },
    "opening_beat": "\"I have read the first line. What do you want me to do?\"",
    "success_looks_like": "The user works on the text rather than speculating about the reader.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer only from the first line.",
      "Refuse to speculate about how anybody feels about the message.",
      "Never rewrite the message."
    ]
  }$j$::jsonb,
  $md$Today, run one message through the mechanical list before sending it. Log what changed.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('edit-do-not-write', 1, 'line', $j${
  "says": "If you had to send it right now, what would it say?",
  "model": {
    "line": "Something like: I cannot do Wednesday, Friday works, sorry for the mess. That is bad but it is the thing.",
    "why": "Two bad sentences change the request from write me something to fix this, and they carry your ordering and your bluntness."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not ask for it to be written for you",
      "words": ["i do not know how to start", "can it write", "i need something", "no idea what to say", "i will get it to"] },
    { "kind": "min_words", "requirement": "Produce an actual rough version", "n": 10 },
    { "kind": "max_words", "requirement": "Rough, not polished", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('edit-do-not-write', 2, 'line', $j${
  "says": "What is this message for? In one sentence.",
  "model": {
    "line": "To get a yes or no on Friday. I am going to have it cut by half without losing that.",
    "why": "A number forces a decision about what the message is for. Improve adds an opening, an acknowledgement and a soft close."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Ask for a cut with a size", "words": ["half", "cut", "words", "shorter by", "two sentences", "delete"] },
    { "kind": "forbids_any", "requirement": "Do not ask for improvement",
      "words": ["improve", "make it better", "polish", "tidy it up", "make it nicer", "smooth"] },
    { "kind": "max_words", "requirement": "One sentence on purpose, one on the cut", "n": 32 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('edit-do-not-write', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Your line is I did not know what to say when I heard. The edited one is I was so sorry to learn your news and wanted to reach out.",
      "prompt": "Which goes in?",
      "options": [
        { "text": "The edited one — it is better written.", "correct": false, "note": "It is, and better written is not the job. It sounds like it was easy to write, which is the one thing this message must not be." },
        { "text": "Yours.", "correct": true, "note": "A clumsy sentence from a real person reads as sincere. Read both aloud and keep the one you could say to their face." },
        { "text": "A blend of the two.", "correct": false, "note": "Blending imports the formality you were trying to avoid, in smaller quantities." },
        { "text": "Neither — write a third.", "correct": false, "note": "Drafting again is how the awkward true sentence gets lost." }
      ]
    },
    {
      "situation": "The edit has also moved your ask from the third paragraph to the first line.",
      "prompt": "Do you keep that change?",
      "options": [
        { "text": "No — the original order was yours.", "correct": false, "note": "Order is structure rather than voice, and this is the single most valuable edit available." },
        { "text": "Only if the message is short.", "correct": false, "note": "It matters more as the message gets longer, not less." },
        { "text": "No, it makes it blunt.", "correct": false, "note": "It makes it findable. Warmth goes back in deliberately, underneath." },
        { "text": "Yes — that is a mechanical fault, not a voice.", "correct": true, "note": "Structure is not voice. Keeping your clumsy sentence is not an argument for keeping your buried ask." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('edit-do-not-write', 4, 'line', $j${
  "says": "There is nothing in here that could only be about us.",
  "model": {
    "line": "You are right — I will put in the bit about us both standing in the corridor after the Tuesday meeting.",
    "why": "One specific detail defeats every tell at once, because it is the thing generated text cannot supply."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not fix it with style",
      "words": ["reword", "make it warmer", "less formal", "change the tone", "different phrasing", "rewrite it"] },
    { "kind": "min_words", "requirement": "Name an actual detail", "n": 10 },
    { "kind": "max_words", "requirement": "One detail, not a paragraph", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('edit-do-not-write', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Your message is not getting answered and you have started wondering what your tone is doing.",
      "prompt": "What is worth asking it?",
      "options": [
        { "text": "Does this sound cold?", "correct": false, "note": "About how a reader will feel, which is the thing it is least able to know and most willing to answer." },
        { "text": "Are they annoyed with me?", "correct": false, "note": "It has never met them. It will produce a theory anyway, which is the next track's opening lesson." },
        { "text": "If somebody read only the first line, what would they think I want?", "correct": true, "note": "A fact about the text, and a fast test for the thing that gets messages answered on Thursday." },
        { "text": "Should I send this at all?", "correct": false, "note": "It will help you send it. That question is yours." }
      ]
    },
    {
      "situation": "You have three separate requests buried in one paragraph.",
      "prompt": "What is the right job for it?",
      "options": [
        { "text": "Turn it into a numbered list, or split it.", "correct": true, "note": "Mechanical and reliable — and a numbered list is the version people actually work through." },
        { "text": "Guess which one they will say yes to.", "correct": false, "note": "About the person, not the text. It cannot know and will answer confidently." },
        { "text": "Soften the two smaller ones.", "correct": false, "note": "Softening is addition, which is the previous lesson's whole warning." },
        { "text": "Choose which request matters most.", "correct": false, "note": "That is a judgement about your situation, and you are better placed than it is." }
      ]
    }
  ]
}$j$::jsonb);

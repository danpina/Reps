-- Storytelling & speaking, track 3: Telling it.
--
-- Shape decided, so this is delivery — and every habit in it is copyable
-- rather than innate, which is the point. Nothing here asks anybody to be
-- funnier or more confident.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'telling-it'),
  1,
  'Present tense',
  $md$Two people tell the same story with the same shape and one of them is in the room while the other is filing a report. Frequently the whole difference is a tense.

*So I was standing in the doorway and he turned round and said he had no idea who I was.*
*So I am standing in the doorway, and he turns round, and he has no idea who I am.*

**The move:** switch to present tense at the moment the story starts happening.

It sounds like a trick written down and it is close to invisible when spoken — people do not notice the tense, they notice that they are following something happening rather than being told about something that happened. That is the entire effect, and it costs nothing.

You do not need it for the whole thing. The natural pattern is past tense for the framing and the setup — *so I went round to my sister's last week* — and present for the part that matters, which is exactly where the attention should be. Most good storytellers do this without knowing they do.

It also does something to your own delivery, which is the underrated half. Telling something in present tense makes it much harder to summarise, because summary is a past-tense operation. You end up naturally supplying the moment rather than the account, and the pace picks up without any decision to speed it up.

Two things to avoid. Do not switch back and forth repeatedly — one change, at the point things start, and stay there. And do not use it for something you are reporting rather than telling: news about somebody else's life in present tense reads as dramatised, which is the one context where it is noticeable and wrong.

If you keep one thing: switch at the moment it starts happening, and stay in it until the end.$md$,
  $j$[
    {
      "situation": "You are describing the moment it went wrong.",
      "line": "So I am standing in the doorway, and he turns round.",
      "why": "People do not notice the tense — they notice that they are following something happening rather than being told about something that happened."
    },
    {
      "situation": "You are still setting up where you were.",
      "line": "(past tense is right here)",
      "why": "The natural pattern is past for the framing and present for the part that matters, which puts the change exactly where the attention should be."
    },
    {
      "situation": "You are passing on news about somebody else.",
      "line": "(not present tense)",
      "why": "Reporting in present tense reads as dramatised, and it is the one context where the device is noticeable and wrong."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does present tense actually do?",
      "options": [
        { "text": "Makes you sound more animated.", "correct": false, "note": "It can, and animation is a by-product rather than the mechanism." },
        { "text": "Puts the listener in the room rather than in a report.", "correct": true, "note": "Nobody notices the tense. They notice that they are following something happening instead of being told about something that happened." },
        { "text": "Makes the story shorter.", "correct": false, "note": "It tends to, as a side effect of making summary harder — which is the second-order benefit rather than the first." },
        { "text": "Signals that the good bit is coming.", "correct": false, "note": "The switch does mark a change of gear, and that is not what it is doing to the listener's experience." }
      ],
      "explain": "Switch once, at the moment it starts happening, and stay there."
    },
    {
      "prompt": "What is the underrated effect on you?",
      "options": [
        { "text": "It slows you down.", "correct": false, "note": "It usually speeds things up, because supplying moments is faster than assembling an account." },
        { "text": "It helps you remember the order.", "correct": false, "note": "No particular effect on recall. The effect is on what kind of sentence you produce." },
        { "text": "It makes summarising harder.", "correct": true, "note": "Summary is a past-tense operation. In present tense you naturally supply the moment rather than the account, and the pace picks up without deciding to." },
        { "text": "It makes you more confident.", "correct": false, "note": "Possibly, downstream, and confidence is not what the device is for." }
      ],
      "explain": "And do not switch back and forth — one change, then stay in it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "switched", "label": "Switched to present", "description": "At the moment things started happening." },
      { "key": "once", "label": "Switched once", "description": "Did not move back and forth." },
      { "key": "setup_past", "label": "Kept the setup in past", "description": "Framing in past tense, action in present." },
      { "key": "not_reporting", "label": "Did not dramatise news", "description": "Kept reported events in past tense." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling the story of arriving at the wrong house. The moment it starts happening is when the door opens.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Follows a present-tense telling closely and asks what happened next; receives a past-tense account politely and without much reaction.",
      "mood": "Interested.",
      "openness": 4
    },
    "opening_beat": "\"Wrong house? How did that even happen?\"",
    "success_looks_like": "The user switches to present tense when the action starts.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React and ask what happens next during a present-tense telling.",
      "Respond politely and without follow-up questions to a past-tense summary.",
      "Never comment on how it is being told."
    ]
  }$j$::jsonb,
  $md$Today, tell one story switching to present tense when the action starts. Log where you switched.$md$
),
(
  (select id from public.skills where slug = 'telling-it'),
  2,
  'Actual words',
  $md$This is the largest single upgrade available to most people, and it requires no wit whatsoever, because you are quoting rather than inventing.

*He said he was not interested.*
*He says, without looking up: not interested.*

The first is information about a conversation. The second is a conversation. Same content, and the second one has a person in it.

**The move:** quote people instead of summarising them.

Dialogue does three things at once. It makes somebody a character rather than a fact — the way a person says a thing is most of what makes them vivid. It supplies rhythm, because speech has a shape that reported speech flattens. And it hands you the ending for free, since the strongest last lines in conversational stories are almost always something somebody said.

You do not need accuracy. Nobody has ever been caught out on the exact wording of a remark, and *he says something like* is available if it matters to you. Get the shape and the register right and it is true in the way stories are true.

Two mechanical things. Do not label the tone — *he said, really sarcastically* is you explaining a performance you could simply give, and giving it takes less time. And keep the attributions short: *he says*, *she goes*, or nothing at all where it is obvious. Long attributions kill the rhythm dialogue was supplying.

Your own lines count too, and people underuse them. *And I say, I have absolutely no idea* is better than *and I did not know what to say* — the second summarises the exact moment the listener wanted to be in.

If you keep one thing: quote, do not summarise. It costs nothing to make up and it is where most of the life in a story comes from.$md$,
  $j$[
    {
      "situation": "You are about to say he told you he was not interested.",
      "line": "He says, without looking up: not interested.",
      "why": "Same content, and the second version has a person in it. The way somebody says a thing is most of what makes them vivid."
    },
    {
      "situation": "You want to convey that he was sarcastic.",
      "line": "(give the line rather than the label)",
      "why": "He said, really sarcastically is you explaining a performance you could simply do, and doing it takes less time."
    },
    {
      "situation": "You are about to say you did not know what to say.",
      "line": "And I say: I have absolutely no idea.",
      "why": "The summary skips the exact moment the listener wanted to be in, and your own lines are the ones people underuse most."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is dialogue the biggest upgrade for most people?",
      "options": [
        { "text": "It is more entertaining.", "correct": false, "note": "True and unhelpfully general — say what it is doing that a summary is not." },
        { "text": "It requires no wit, because you are quoting.", "correct": true, "note": "Nothing has to be invented. It makes somebody a character rather than a fact, supplies rhythm, and hands you an ending — all from material you already have." },
        { "text": "It fills time.", "correct": false, "note": "It is usually shorter than the summary, which tends to explain what the line would have shown." },
        { "text": "People like being quoted.", "correct": false, "note": "They are not usually present, and it would not matter if they were." }
      ],
      "explain": "Quote, do not summarise. The life in a story mostly comes from this."
    },
    {
      "prompt": "What should you not do with dialogue?",
      "options": [
        { "text": "Invent the wording.", "correct": false, "note": "Nobody has ever been caught out on the exact words. Get the shape and register right and it is true in the way stories are true." },
        { "text": "Quote yourself.", "correct": false, "note": "Your own lines are the ones people underuse most, and they are where the listener most wants to be." },
        { "text": "Use it for more than two people.", "correct": false, "note": "Cast size is a real constraint and a different lesson. Two people talking is the normal case." },
        { "text": "Label the tone.", "correct": true, "note": "He said, really sarcastically explains a performance you could simply give — and giving it takes less time and lands better." }
      ],
      "explain": "Keep attributions short too. He says, she goes, or nothing where it is obvious."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "quoted", "label": "Quoted rather than summarised", "description": "Gave actual lines." },
      { "key": "own_lines", "label": "Quoted themselves too", "description": "Included their own words at the key moment." },
      { "key": "no_labels", "label": "Did not label the tone", "description": "Performed it rather than describing it." },
      { "key": "short_attributions", "label": "Kept attributions short", "description": "He says, she goes, or nothing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling a story whose best moment is an exchange between you and a man at a counter.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Laughs at quoted lines and nods politely at summarised ones. Never asks what somebody said.",
      "mood": "Enjoying it.",
      "openness": 4
    },
    "opening_beat": "\"And what did he say?\"",
    "success_looks_like": "The user quotes the exchange rather than describing it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React clearly to quoted dialogue.",
      "Respond with a small nod and nothing more to a summary of what was said.",
      "Never ask for the exact words a second time."
    ]
  }$j$::jsonb,
  $md$Today, quote two lines of dialogue in one story instead of summarising them. Log both.$md$
),
(
  (select id from public.skills where slug = 'telling-it'),
  3,
  'One detail that does work',
  $md$Detail is where careful people over-invest, and it is worth knowing exactly how much of it a story can carry.

The answer is roughly one per story. One specific thing that makes it real and could not plausibly have been invented: the fact that he was holding a sandwich the entire time, the hold music, the enormous dog asleep across the doorway.

**The move:** pick the one detail that does work, and cut the rest of the description.

What a good detail does is not decoration. It certifies the story — a listener hearing something oddly specific concludes, without deciding to, that this happened. That effect comes from one detail and does not increase with more; the second and third produce nothing, and by the fourth you are describing a room while the story waits.

The choosing is the skill. A working detail is specific, slightly odd, and connected to the moment that matters. *A man in his forties* is not a detail, it is a category. *The sandwich* is a detail, because it is strange, because it is precise, and because him holding it while all of this happened is the thing you actually remember.

There is a related trap in physical description. Describing what somebody looked like almost never earns its place unless the appearance is load-bearing — how they behaved is what makes them a character, and *he never once put the sandwich down* does more than a paragraph about his face.

And notice that the good ones are usually already in your memory. You do not construct these; you are remembering something oddly vivid, and the odd vividness is precisely the signal that it is the right one.

If you keep one thing: one detail, chosen for strangeness, and nothing else described. The listener does the rest.$md$,
  $j$[
    {
      "situation": "You want the scene to feel real.",
      "line": "He was holding a sandwich the entire time.",
      "why": "Specific, slightly odd, and connected to the moment that matters. A listener hearing something oddly specific concludes without deciding to that this happened."
    },
    {
      "situation": "You have three or four good details.",
      "line": "(the second one produces nothing)",
      "why": "Certification comes from one detail and does not increase with more. By the fourth you are describing a room while the story waits."
    },
    {
      "situation": "You are about to describe what he looked like.",
      "line": "(how he behaved makes him a character)",
      "why": "Appearance rarely earns its place. He never once put the sandwich down does more than a paragraph about his face."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does a good detail actually do?",
      "options": [
        { "text": "Helps people picture it.", "correct": false, "note": "Partly, and picturing is not what changes how a story is received." },
        { "text": "Makes it more entertaining.", "correct": false, "note": "Vague. The effect is specific and slightly strange." },
        { "text": "Certifies that it happened.", "correct": true, "note": "A listener hearing something oddly specific concludes, without deciding to, that this is real — and that effect comes from one detail and does not increase with more." },
        { "text": "Slows the pace where you want it slow.", "correct": false, "note": "Detail does slow things, which is a cost to manage rather than the point." }
      ],
      "explain": "One per story. The second and third produce nothing."
    },
    {
      "prompt": "Which of these is a detail?",
      "options": [
        { "text": "A man in his forties.", "correct": false, "note": "A category rather than a detail. It could be almost anybody and it certifies nothing." },
        { "text": "He was quite well dressed.", "correct": false, "note": "An impression, and impressions are what descriptions are made of. It cannot be pictured precisely." },
        { "text": "He seemed annoyed.", "correct": false, "note": "An interpretation, and one the listener would rather reach themselves from something he did." },
        { "text": "He was holding a sandwich the whole time.", "correct": true, "note": "Specific, odd, and connected to the moment that matters — which is the whole specification." }
      ],
      "explain": "The good ones are usually already in your memory, and the odd vividness is the signal."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one", "label": "Used one detail", "description": "Did not stack several." },
      { "key": "odd", "label": "Chose an odd one", "description": "Specific and slightly strange rather than a category." },
      { "key": "connected", "label": "Connected to the moment", "description": "Attached to the part that mattered." },
      { "key": "no_description", "label": "Cut the description", "description": "No paragraph about how anybody looked." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling a story about a long argument at a counter. The man was holding a sandwich throughout, there was terrible hold music, and it was raining.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reacts to one strange specific and glazes over during accumulated description.",
      "mood": "Listening.",
      "openness": 4
    },
    "opening_beat": "\"What was he like?\"",
    "success_looks_like": "The user gives one odd specific rather than a description.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React with interest to a single strange detail.",
      "Glaze over visibly during two or more pieces of description.",
      "Never ask what somebody looked like again."
    ]
  }$j$::jsonb,
  $md$Today, tell one story with exactly one detail in it. Log the detail you kept and one you cut.$md$
),
(
  (select id from public.skills where slug = 'telling-it'),
  4,
  'Know your last line',
  $md$This is the single thing that separates people who land stories from people who trail off, and it is decided before you open your mouth.

**The move:** know the final sentence before you begin, and steer towards it.

If you know where you are going, three things follow automatically. You can cut on the way, because you can see what is not on the route. You can pace it, because you know how far away the end is. And you can stop cleanly, because arriving somewhere you intended feels completely different from running out.

If you do not, you will get near the end, feel the material thinning, and produce *so, yeah — anyway*, which is the sound of a story being abandoned rather than finished. Everybody recognises it, including the person saying it, and it retroactively makes a decent story feel like a mistake.

The last line is nearly always something somebody said, which is a useful shortcut when you are choosing one. The best line in a conversational story is usually a piece of dialogue — theirs or yours — and it is very often the first thing you would tell somebody if you had a single sentence.

There is a small discipline attached: once you know it, do not say it early. People frequently give away their best line in the setup, use it as the frame, and then have nothing to end on. If it is the ending, it is not the opening.

And where a story has no obvious last line, that is worth knowing before you commit to telling it. It usually means the turn is missing rather than the ending, which is the previous track's problem arriving in a different disguise.

If you keep one thing: decide the last line first. Everything about telling it is steering towards a point you already know.$md$,
  $j$[
    {
      "situation": "You are about to start and you do not know how it ends.",
      "line": "(decide the last line first)",
      "why": "Knowing where you are going lets you cut on the way, pace it, and stop cleanly rather than running out."
    },
    {
      "situation": "You have arrived near the end with nothing left.",
      "line": "(so, yeah — anyway)",
      "why": "The sound of a story being abandoned rather than finished, and everybody recognises it, including you."
    },
    {
      "situation": "The best line is the one you were going to open with.",
      "line": "(then it is not the opening)",
      "why": "People give away their best line in the setup and then have nothing to end on. If it is the ending, it stays at the end."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What follows from knowing the last line?",
      "options": [
        { "text": "You can cut, pace, and stop cleanly.", "correct": true, "note": "All three come automatically from knowing where you are going — you can see what is off the route, how far away the end is, and where to stop." },
        { "text": "You sound more confident.", "correct": false, "note": "You do, and that is downstream of not being lost rather than a separate benefit." },
        { "text": "It stops you rambling.", "correct": false, "note": "One of the three, stated alone. Cutting is the part it names." },
        { "text": "You can rehearse it.", "correct": false, "note": "Rehearsal is not what this buys, and a memorised story tends to sound recited." }
      ],
      "explain": "Arriving somewhere you intended feels completely different from running out."
    },
    {
      "prompt": "The story has no obvious last line. What does that mean?",
      "options": [
        { "text": "You need a better ending.", "correct": false, "note": "Endings cannot be added to something with nothing to end. The problem is upstream." },
        { "text": "It needs more detail to build to.", "correct": false, "note": "Detail cannot supply a resolution, and adding it produces a longer story with the same absence." },
        { "text": "It is not worth telling.", "correct": false, "note": "Too quick — it may be a good story with an unfound turn rather than a bad one." },
        { "text": "The turn is probably missing.", "correct": true, "note": "It is the previous track's problem in a different disguise: a story with nothing that flips has nothing to land." }
      ],
      "explain": "The last line is nearly always something somebody said."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "knew_it", "label": "Knew the last line", "description": "Decided it before starting." },
      { "key": "steered", "label": "Steered towards it", "description": "Cut what was off the route." },
      { "key": "stopped_there", "label": "Stopped on it", "description": "Ended where they intended." },
      { "key": "saved_it", "label": "Did not use it early", "description": "Kept the best line for the end." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are about to tell a story whose best moment is something the other person said at the very end.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reacts strongly to a clean landing and does not react at all to a story that peters out.",
      "mood": "Ready.",
      "openness": 4
    },
    "opening_beat": "\"Go on then.\"",
    "success_looks_like": "The user ends on a line they were clearly steering towards.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React fully to a story that ends on a clear line.",
      "Say nothing much after a story that trails off, and change the subject.",
      "Never rescue an ending with a question."
    ]
  }$j$::jsonb,
  $md$Today, decide the last line of one story before you tell it. Log the line and whether you landed on it.$md$
),
(
  (select id from public.skills where slug = 'telling-it'),
  5,
  'Slow down and stop moving',
  $md$Everything else in this track is words. This is the small amount of delivery that genuinely matters, and there is much less of it than people fear.

**The move:** slow down before the turn, and let one silence sit.

Slowing before the turn is worth more than any wording. It signals, without announcing anything, that something is coming — and the listener adjusts. Then say the turn at normal speed and stop. The commonest thing people do to their own best moment is rush it, because they are nervous about holding the floor and the turn is the point of maximum exposure.

Letting a silence sit after the turn is the other half, and it is the same instruction as ending on the line: a beat is where the reaction happens.

That is genuinely most of it, which is worth saying plainly because delivery advice is usually a list of twenty things about posture and gesture that nobody can hold in their head while also telling a story. You do not need to perform. Your face is already doing more than you think, and the story is carrying most of the load.

Two things worth removing rather than adding. Speeding up when you sense you are losing somebody — it reads as anxiety and makes the story harder to follow, and the fix for losing people is getting to the end rather than getting there faster. And the apologetic laugh in the middle, which tells everybody you have doubts about the material.

Volume matters more than anything else on the list, and it is the least discussed. A good story told slightly too quietly is a story half the table is straining at, and straining is indistinguishable from disengagement. If you are quiet by nature, this is the one physical thing worth practising.

If you keep one thing: slow before the turn, then stop. That is the whole of the delivery, and everything else is the shape doing its job.$md$,
  $j$[
    {
      "situation": "You are two sentences from the turn.",
      "line": "(slow down)",
      "why": "It signals something is coming without announcing it, and the listener adjusts. Then say the turn at normal speed."
    },
    {
      "situation": "You sense you are losing somebody.",
      "line": "(get to the end, do not speed up)",
      "why": "Speeding up reads as anxiety and makes it harder to follow. The fix for losing people is arriving sooner rather than talking faster."
    },
    {
      "situation": "You are quiet by nature.",
      "line": "(volume is the one physical thing worth practising)",
      "why": "Half a table straining to hear is indistinguishable from a table that has disengaged."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is worth more than any wording?",
      "options": [
        { "text": "Eye contact around the table.", "correct": false, "note": "Useful and it is on the long list of delivery advice nobody can hold while telling a story." },
        { "text": "Slowing down before the turn.", "correct": true, "note": "It signals something is coming without announcing it, and the listener adjusts. Then the turn at normal speed, and stop." },
        { "text": "Varying your tone.", "correct": false, "note": "Happens naturally when you are actually telling something, and consciously managing it is what produces a performance." },
        { "text": "Using your hands.", "correct": false, "note": "Entirely optional, and worrying about it takes attention from the story." }
      ],
      "explain": "There is much less delivery to get right than people fear."
    },
    {
      "prompt": "Which physical thing is most underrated?",
      "options": [
        { "text": "Posture.", "correct": false, "note": "Almost irrelevant at a table, and it is the first thing most advice mentions." },
        { "text": "Facial expression.", "correct": false, "note": "Already doing more than you think, without management." },
        { "text": "Gesture.", "correct": false, "note": "Optional, and self-conscious gesture is worse than none." },
        { "text": "Volume.", "correct": true, "note": "A good story told slightly too quietly has half the table straining, and straining is indistinguishable from disengagement." }
      ],
      "explain": "Slow before the turn, then stop. The shape does the rest."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "slowed", "label": "Slowed before the turn", "description": "Gave it a beat of approach." },
      { "key": "stopped", "label": "Let a silence sit", "description": "Did not talk through the reaction." },
      { "key": "no_rushing", "label": "Did not speed up", "description": "Got to the end rather than going faster." },
      { "key": "audible", "label": "Was audible", "description": "Loud enough that nobody was straining." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are three sentences from the best moment of the story and the table is with you.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Responds to pace — leans in when the teller slows, and disengages slightly when they speed up or drop in volume.",
      "mood": "With you.",
      "openness": 4
    },
    "opening_beat": "\"So what did he do?\"",
    "success_looks_like": "The user slows into the turn and lets the beat after it sit.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Lean in and go quiet when the teller slows before something.",
      "Disengage slightly if the teller speeds up or becomes quieter.",
      "Never comment on pace."
    ]
  }$j$::jsonb,
  $md$Today, slow down for the two sentences before the best bit of one story. Log what you noticed in the room.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('telling-it', 1, 'line', $j${
  "says": "Wrong house? How did that even happen?",
  "model": {
    "line": "So I knock, and the door opens, and there is a man in a dressing gown who very obviously has no idea who I am.",
    "why": "Present tense from the moment the action starts. Nobody notices the tense — they notice that they are following something happening rather than being told about something that happened."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Present tense once the action starts",
      "words": ["i knocked", "the door opened", "he was standing", "he said", "i went", "i had arrived", "it turned out", "he asked me"] },
    { "kind": "min_words", "requirement": "Get to the moment it starts happening", "n": 12 },
    { "kind": "max_words", "requirement": "One or two sentences", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('telling-it', 2, 'line', $j${
  "says": "And what did he say?",
  "model": {
    "line": "He looks at me for about four seconds and goes: and who told you that?",
    "why": "Quoted rather than summarised, with a short attribution and no label on the tone. Nothing had to be invented — the line already existed."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Quote it, do not summarise or label the tone",
      "words": ["he said that", "he told me that", "he basically", "he was really", "sarcastically", "angrily", "he made it clear", "the gist was"] },
    { "kind": "min_words", "requirement": "Give the actual line", "n": 8 },
    { "kind": "max_words", "requirement": "Short attribution, then the words", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('telling-it', 3, 'choice', $j${
  "beats": [
    {
      "situation": "\"What was he like?\" He was in his forties, well dressed, clearly annoyed, and holding a sandwich throughout the entire argument.",
      "prompt": "What do you say?",
      "options": [
        { "text": "All of it — it builds the picture.", "correct": false, "note": "By the third piece you are describing a room while the story waits. Certification comes from one detail and does not increase with more." },
        { "text": "He was in his forties and quite well dressed.", "correct": false, "note": "A category and an impression. Neither could only be true of this man, so neither certifies anything." },
        { "text": "He was holding a sandwich the entire time.", "correct": true, "note": "Specific, odd, and attached to the moment that matters. A listener hearing something that strange concludes without deciding to that it happened." },
        { "text": "He was clearly annoyed.", "correct": false, "note": "An interpretation, and one the listener would rather reach themselves from something he did." }
      ]
    },
    {
      "situation": "You want the man to feel like a person rather than a fact.",
      "prompt": "What does that?",
      "options": [
        { "text": "Describing how he looked.", "correct": false, "note": "Appearance rarely earns its place. Almost nobody becomes a character through description." },
        { "text": "Something he did that you could not have invented.", "correct": true, "note": "He never once put the sandwich down does more than a paragraph about his face — behaviour makes somebody a character." },
        { "text": "Saying what kind of person he seemed to be.", "correct": false, "note": "That hands over your conclusion and skips the evidence, which is the part that would have been vivid." },
        { "text": "Giving him a name.", "correct": false, "note": "Names help you track people and do nothing to make them real." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('telling-it', 4, 'line', $j${
  "says": "Go on then. (The best moment of this story is the thing the other person said right at the end.)",
  "model": {
    "line": "(the last line, decided before starting — and not used as the opener)",
    "why": "Knowing where you are going lets you cut on the way, pace it, and stop cleanly. Without it you arrive near the end, feel the material thinning, and produce so, yeah — anyway."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not trail off",
      "words": ["so yeah", "anyway", "or whatever", "i do not know", "you had to be there", "it was funnier", "that was it really", "and that was that"] },
    { "kind": "min_words", "requirement": "Land on an actual line", "n": 6 },
    { "kind": "max_words", "requirement": "Stop on it", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('telling-it', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Three sentences from the best moment, and the table is with you.",
      "prompt": "What do you do with the pace?",
      "options": [
        { "text": "Speed up — the good bit is coming.", "correct": false, "note": "Rushing your own best moment is the commonest thing people do to it, usually because the turn is the point of maximum exposure." },
        { "text": "Announce it — you are going to love this.", "correct": false, "note": "It sets a standard the line then has to beat, and it is a disclaimer wearing a confident coat." },
        { "text": "Slow down slightly, then say the turn at normal speed.", "correct": true, "note": "Slowing signals that something is coming without announcing it, and the listener adjusts. Worth more than any wording." },
        { "text": "Nothing — pace looks after itself.", "correct": false, "note": "It does not under mild nerves, which reliably produce acceleration at exactly this point." }
      ]
    },
    {
      "situation": "You sense somebody at the far end of the table has stopped following.",
      "prompt": "What now?",
      "options": [
        { "text": "Speed up to get there before you lose them.", "correct": false, "note": "It reads as anxiety and makes the story harder to follow, which loses them faster." },
        { "text": "Add a detail to bring it back to life.", "correct": false, "note": "More material is the opposite of what a fading story needs." },
        { "text": "Check whether they are following.", "correct": false, "note": "It makes the room's attention the subject and puts somebody on the spot for having drifted." },
        { "text": "Get to the end — and check you are audible.", "correct": true, "note": "The fix is arriving sooner rather than talking faster. And half a table straining to hear is indistinguishable from a table that has disengaged." }
      ]
    }
  ]
}$j$::jsonb);

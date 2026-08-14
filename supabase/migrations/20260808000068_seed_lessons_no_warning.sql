-- Storytelling & speaking, track 5: Standing up with no warning.
--
-- The second half of the topic's promise, and the most frightening version of
-- speaking with the simplest structure — which is a fortunate combination and
-- the reason this track is short on theory and long on one repeated shape.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'no-warning'),
  1,
  'One thing, one example, one close',
  $md$Somebody says *say a few words*. Thirty faces turn round. You have about four seconds and no preparation, and this is the most frightening version of speaking there is.

It also has the simplest structure in the whole app.

**The move:** one thing, one example, one close. Three sentences is a speech.

**One thing.** A single point, chosen in the three seconds while you are standing up. *Sarah has held this team together for four years.* Whatever else is true, this is the sentence you are here to say — and the discipline is not adding a second one, because two points in an unprepared speech is where people get lost and start looping.

**One example.** The specific that makes it real. *When the whole thing fell over in March, she was the one still here at nine o'clock.* This is the part people remember and it is why thirty seconds about one real thing beats four minutes about somebody's qualities. It is also the easiest part to find, because you are remembering rather than composing.

**One close.** A sentence that lands and stops. *We would all have left without her.* Short, definite, and — this matters — decided before you say the example, so that you know where you are going.

That is the whole structure and it survives nerves, which is its real advantage. Under adrenaline you will not execute anything complicated, and three slots is few enough to hold while your heart is going.

If you can only manage two of the three, drop the close and stop after the example. A speech that ends slightly abruptly on something concrete is much better than one that keeps going while somebody looks for an ending.

If you keep one thing: one thing, one example, one close. Then stop, and sit down.$md$,
  $j$[
    {
      "situation": "\"Say a few words.\" Thirty faces.",
      "line": "(one thing, one example, one close)",
      "why": "Three slots is few enough to hold under adrenaline, which is the only structure worth having in a moment like this."
    },
    {
      "situation": "You have two good points and no time to choose.",
      "line": "(one — two is where people loop)",
      "why": "Two points in an unprepared speech is where people get lost, and the second is almost never as good as the first."
    },
    {
      "situation": "You have said the thing and the example and you cannot find a close.",
      "line": "(then stop there)",
      "why": "Ending slightly abruptly on something concrete is much better than continuing while you look for an ending."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why one point rather than two?",
      "options": [
        { "text": "Two takes too long.", "correct": false, "note": "Length is a symptom. Two points can be short and still cause the problem." },
        { "text": "Two is where people get lost and start looping.", "correct": true, "note": "In an unprepared speech, the second point is where the structure gives way — and it is almost never as good as the first anyway." },
        { "text": "One sounds more decisive.", "correct": false, "note": "How it sounds rather than what happens to you while delivering it." },
        { "text": "People only remember one thing anyway.", "correct": false, "note": "True and it is about them. The bigger reason is what two does to you in the moment." }
      ],
      "explain": "Three slots is few enough to hold while your heart is going."
    },
    {
      "prompt": "Which part do people remember?",
      "options": [
        { "text": "The point.", "correct": false, "note": "The point orients them and is rarely the thing repeated afterwards." },
        { "text": "The close.", "correct": false, "note": "The close makes it land and is usually the least specific sentence in it." },
        { "text": "The example.", "correct": true, "note": "The specific that makes it real, which is why thirty seconds about one real thing beats four minutes about somebody's qualities." },
        { "text": "How nervous you looked.", "correct": false, "note": "Considerably less visible than it feels, and forgotten immediately either way." }
      ],
      "explain": "And the example is the easiest part, because you are remembering rather than composing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_thing", "label": "One point", "description": "Did not add a second." },
      { "key": "example", "label": "One specific example", "description": "Something real rather than a quality." },
      { "key": "close", "label": "A close that stops", "description": "Short and definite." },
      { "key": "stopped", "label": "Sat down", "description": "Did not keep going after the ending." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A leaving do. Somebody has just handed you the floor with no warning, for Sarah, who has been here four years.",
    "partner": {
      "name": "Rob",
      "role": "the colleague who has just handed you the floor",
      "personality": "Reports the room plainly — attention, warmth, the moment people start looking at their glasses.",
      "mood": "Cheerful, slightly drunk.",
      "openness": 4
    },
    "opening_beat": "\"— and I think somebody else wanted to say something. Go on then.\"",
    "success_looks_like": "The user says one thing, one example and a close, then stops.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Describe the room's attention plainly as it changes.",
      "Report warmth and applause for anything short and specific.",
      "Report attention drifting after about forty-five seconds."
    ]
  }$j$::jsonb,
  $md$Today, plan the three slots for somebody you might have to speak about. Log all three.$md$
),
(
  (select id from public.skills where slug = 'no-warning'),
  2,
  'The toast',
  $md$The toast is the easiest form of impromptu speaking there is, and it is worth knowing why: the ending is a physical action, so you cannot fail to land it.

**The move:** name the person, one specific thing, one line about what it means, and raise the glass.

*To Michael. Who drove four hours to help me move a sofa he had never seen, for a flat he had never been to. There is nobody else I would have called. To Michael.*

Four parts, about fifteen seconds, and the glass does the ending. That last property is doing more work than it appears — the hardest part of a short speech is stopping cleanly, and here the room ends it for you by drinking.

**Name them at the start.** It tells everybody what this is and gets the room's attention pointed in one direction before you say anything that matters.

**One specific thing.** The same rule as the previous lesson, and the same reason. *Michael is incredibly generous* is a claim about somebody; the sofa is evidence, and evidence is what people remember and repeat.

**One line about what it means.** Short, and this is the only place in the structure where a general statement earns its place — the specific has just bought you the right to it.

**Then the glass.** Repeat the name so people know to join in.

Two things to avoid. Do not list — three things about somebody is a speech, and a toast that becomes a speech has lost the thing that made it easy. And do not go long: the difference between a toast people enjoy and one they endure is almost entirely whether it stayed under about twenty seconds.

If you are dreading a wedding or a leaving do, this is the shape to have ready. It works for anybody, it can be assembled in the time it takes to stand up, and it never fails to end.

If you keep one thing: name, specific, meaning, glass. The glass is why this is the easy one.$md$,
  $j$[
    {
      "situation": "You have been asked to say something about Michael.",
      "line": "To Michael. Who drove four hours to help me move a sofa he had never seen. There is nobody else I would have called. To Michael.",
      "why": "Name, specific, meaning, glass. Fifteen seconds, and the room ends it for you by drinking."
    },
    {
      "situation": "You have three good things you could say.",
      "line": "(one — three is a speech)",
      "why": "A toast that becomes a speech has lost the property that made it easy, which is the guaranteed ending."
    },
    {
      "situation": "You want to say he is incredibly generous.",
      "line": "(the sofa is the evidence)",
      "why": "A claim about somebody is a claim. Evidence is what people remember, and it buys you the right to the general line afterwards."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the toast the easiest form?",
      "options": [
        { "text": "Everybody is drinking, so standards are low.", "correct": false, "note": "Standards are not the variable, and a bad toast is noticed at any hour." },
        { "text": "It is short.", "correct": false, "note": "Short helps and does not solve the hardest part, which is stopping." },
        { "text": "The glass ends it for you.", "correct": true, "note": "The hardest part of a short speech is stopping cleanly, and here the room does it by drinking. You cannot fail to land it." },
        { "text": "It is a familiar format.", "correct": false, "note": "Familiar to hear and not to give, which is why most people dread being asked." }
      ],
      "explain": "Name, specific, meaning, glass — about fifteen seconds."
    },
    {
      "prompt": "What is the general line allowed to do here?",
      "options": [
        { "text": "Nothing — keep it entirely concrete.", "correct": false, "note": "Too strict. This is the one place a general statement earns its place." },
        { "text": "Arrive after the specific has bought the right to it.", "correct": true, "note": "The sofa is the evidence, and there is nobody else I would have called is what it entitles you to say." },
        { "text": "Open the toast, so people know the tone.", "correct": false, "note": "Opening with a general claim spends the attention before the evidence arrives." },
        { "text": "Replace the specific if you cannot think of one.", "correct": false, "note": "Then it is a claim about somebody with nothing behind it, which is the version people politely forget." }
      ],
      "explain": "And do not list. Three things about somebody is a speech."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Named them first", "description": "Pointed the room before saying anything that mattered." },
      { "key": "specific", "label": "One specific thing", "description": "Evidence rather than a claim." },
      { "key": "one_line", "label": "One line of meaning", "description": "Short, and after the specific." },
      { "key": "glass", "label": "Raised the glass", "description": "Let the action end it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A birthday dinner for Michael. Somebody has tapped a glass and looked at you.",
    "partner": {
      "name": "Rob",
      "role": "somebody else at the dinner",
      "personality": "Reports the table plainly and joins the toast warmly when a glass is raised.",
      "mood": "Warm, expectant.",
      "openness": 4
    },
    "opening_beat": "\"Go on — you have known him longest.\"",
    "success_looks_like": "The user gives a short toast with one specific in it and raises the glass.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Join in warmly the moment a glass is raised.",
      "Report the table's attention drifting if a toast passes about thirty seconds.",
      "Never propose the toast yourself."
    ]
  }$j$::jsonb,
  $md$Today, write a fifteen-second toast for somebody you know. Name, specific, meaning, glass. Log it.$md$
),
(
  (select id from public.skills where slug = 'no-warning'),
  3,
  'Shorter is always better',
  $md$Nobody in the history of leaving dos has complained that a speech was too short. Everybody has sat through one that was too long, and the difference between those two experiences is almost entirely whether somebody knew when to stop.

**The move:** aim at half the length you think is expected.

The pressure runs the other way, which is why this needs saying. Standing up, a short speech feels like an under-delivery — you were given a moment and you used thirty seconds of it, and it seems as though more is owed. That instinct is wrong in every room, and it is worth simply overriding rather than negotiating with.

What actually happens when a speech goes long is worth understanding, because it is not that people get bored. It is that the ending stops being believed. A speech that has almost finished three times has taught the room not to relax at the sound of a closing sentence — and once that happens, the actual ending gets relief rather than warmth, which is a sad outcome for something well meant.

Two mechanisms make speeches long and neither is having too much to say. **Looping**, where you restate the point in a slightly different way because you cannot find the exit. And **the second thought**, where you have finished and then remember something else — the *oh, and I should also say* that adds ninety seconds after everybody has already reached for their glass.

The fix for both is deciding the close in advance. If you know your last sentence, you have an exit visible at all times, and you can take it as soon as the material runs out.

And when in doubt, stop early. A speech that ends slightly before people expected is charming and reads as confidence. There is no equivalent charm available at the other end.

If you keep one thing: thirty good seconds beats four minutes, and nobody has ever wished a speech longer.$md$,
  $j$[
    {
      "situation": "You have said your thing and it feels too short.",
      "line": "(that instinct is wrong in every room)",
      "why": "Standing up, thirty seconds feels like an under-delivery. Nobody has ever complained a speech was too short."
    },
    {
      "situation": "You are restating the point in slightly different words.",
      "line": "(that is looping — you have lost the exit)",
      "why": "Looping happens because you cannot find the ending, which is why deciding the close in advance fixes it."
    },
    {
      "situation": "You have finished and remembered something else.",
      "line": "(do not add it)",
      "why": "The oh, and I should also say arrives after everybody has reached for their glass, and it teaches the room not to believe your endings."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually goes wrong when a speech runs long?",
      "options": [
        { "text": "People get bored.", "correct": false, "note": "Some do, and boredom is recoverable. Something worse happens to the structure." },
        { "text": "The ending stops being believed.", "correct": true, "note": "A speech that has almost finished three times teaches the room not to relax at a closing sentence — so the real ending gets relief rather than warmth." },
        { "text": "You lose your thread.", "correct": false, "note": "A cause of length rather than its consequence." },
        { "text": "It becomes about you.", "correct": false, "note": "Sometimes true of long speeches and not the mechanism this is describing." }
      ],
      "explain": "Aim at half the length you think is expected."
    },
    {
      "prompt": "What makes speeches long?",
      "options": [
        { "text": "Having too much to say.", "correct": false, "note": "Almost never. People with a great deal to say give short speeches all the time." },
        { "text": "Nerves.", "correct": false, "note": "Nerves contribute to looping specifically, and they are not the mechanism on their own." },
        { "text": "Not knowing the audience.", "correct": false, "note": "Affects content rather than duration." },
        { "text": "Looping, and the second thought.", "correct": true, "note": "Restating the point because you cannot find the exit, and the oh, and I should also say after everybody has reached for their glass." }
      ],
      "explain": "Both are fixed by deciding the close in advance — an exit visible at all times."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "short", "label": "Kept it short", "description": "Aimed under what felt expected." },
      { "key": "no_looping", "label": "Did not loop", "description": "Said the point once." },
      { "key": "no_second_thought", "label": "Added nothing after the ending", "description": "No oh, and I should also say." },
      { "key": "knew_close", "label": "Knew the close", "description": "Had an exit visible throughout." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just delivered your close at a leaving do, and you have remembered something else you could have said.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the room",
      "personality": "Reports the room accurately: warmth and applause at a clean ending, and a distinct flattening if the speech restarts.",
      "mood": "Attentive.",
      "openness": 4
    },
    "opening_beat": "(you have said your last line, and there is the small pause before applause)",
    "success_looks_like": "The user stops rather than adding the extra thing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Report warmth and applause if the speech ends cleanly.",
      "Report the room flattening and glasses being put back down if it restarts.",
      "Never prompt for more."
    ]
  }$j$::jsonb,
  $md$Today, end one thing you say publicly earlier than you planned to. Log what you left out.$md$
),
(
  (select id from public.skills where slug = 'no-warning'),
  4,
  'First line and last line by heart',
  $md$For the ones you can see coming — the wedding, the leaving do, the thank-you at the end of something — there is a preparation method that beats both full memorisation and winging it.

**The move:** learn the first sentence and the last sentence exactly, and improvise everything between them.

The first sentence matters because the opening is where nerves are worst. Standing up with the first thing already decided means you begin fluently, and beginning fluently settles you faster than anything else — most speaking nerves fall away about fifteen seconds in, and a known opening buys those fifteen seconds outright.

The last sentence matters because that is where speeches fail. Knowing exactly where you are going gives you an exit visible from anywhere, so you can stop the moment the material runs out rather than circling for a landing.

The middle is better improvised, which surprises people. Improvised speech has natural rhythm, eye contact and responsiveness to the room, and it sounds like somebody talking. A memorised middle sounds recited — audibly so — and it has a failure mode with nowhere to go: lose your place in a memorised paragraph and there is no thread to pick up, because the thread was the memory rather than the meaning.

Notes are entirely fine and nobody minds. A card with three or four words on it — the structure, not the sentences — is the best of both, and glancing at it looks like somebody being careful about something that matters. What reads badly is not consulting a card, it is reading a page.

And rehearse out loud rather than in your head. Silently, everything works. Out loud you find the sentence that will not come out right, which is exactly the one that would have collapsed on the night.

If you keep one thing: first and last by heart, middle improvised. Fluent start, guaranteed landing, and the part in the middle sounds like a person.$md$,
  $j$[
    {
      "situation": "You have a wedding speech in a fortnight.",
      "line": "(first sentence and last sentence, exactly)",
      "why": "A known opening settles you in the fifteen seconds where nerves are worst, and a known ending gives you an exit visible from anywhere."
    },
    {
      "situation": "You are tempted to memorise the whole thing.",
      "line": "(a memorised middle sounds recited, and it has nowhere to go)",
      "why": "Lose your place in a memorised paragraph and there is no thread to pick up, because the thread was the memory rather than the meaning."
    },
    {
      "situation": "You have practised it in your head and it is fine.",
      "line": "(say it out loud)",
      "why": "Silently, everything works. Out loud you find the sentence that will not come out right — which is the one that would have collapsed on the night."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why learn the first sentence?",
      "options": [
        { "text": "It sets the tone.", "correct": false, "note": "It does, and tone is not what the memorisation is buying you." },
        { "text": "Nerves are worst at the start, and a known opening buys the first fifteen seconds.", "correct": true, "note": "Most speaking nerves fall away about fifteen seconds in. Beginning fluently settles you faster than anything else available." },
        { "text": "People judge you on the opening.", "correct": false, "note": "They are far more forgiving than that, and worrying about it is what makes openings worse." },
        { "text": "It stops you rambling early.", "correct": false, "note": "Rambling is an ending problem, which is what the last sentence is for." }
      ],
      "explain": "First and last by heart. The middle sounds better improvised."
    },
    {
      "prompt": "What is wrong with memorising the middle?",
      "options": [
        { "text": "It takes too long to learn.", "correct": false, "note": "Effort is not the objection. Plenty of people would happily do the work." },
        { "text": "It sounds recited and has nowhere to go if you lose it.", "correct": true, "note": "Audibly recited, and a lost place in memorised text leaves no thread — because the thread was the memory rather than the meaning." },
        { "text": "You cannot adapt to the room.", "correct": false, "note": "True, and one of several consequences rather than the core failure." },
        { "text": "It makes you sound over-prepared.", "correct": false, "note": "Over-preparation is not a real social cost. Sounding recited is a different and more specific problem." }
      ],
      "explain": "And rehearse out loud — silently, everything works."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "first", "label": "Learned the first sentence", "description": "Knew exactly how it starts." },
      { "key": "last", "label": "Learned the last sentence", "description": "Knew exactly where it ends." },
      { "key": "improvised_middle", "label": "Improvised the middle", "description": "Did not memorise the body." },
      { "key": "out_loud", "label": "Rehearsed out loud", "description": "Said it rather than thinking it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ten days before a wedding speech. You have written the whole thing out and are learning it word for word.",
    "partner": {
      "name": "Sam",
      "role": "a friend helping you prepare",
      "personality": "Asks what happens if you lose your place, and asks whether you have said any of it out loud yet.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"Have you actually said any of this out loud yet?\"",
    "success_looks_like": "The user learns the first and last lines and leaves the middle improvised.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what happens if they lose their place in the middle.",
      "Ask them to say the opening out loud, now.",
      "Never suggest the first-and-last method yourself."
    ]
  }$j$::jsonb,
  $md$Today, take something you might have to say and decide its first and last sentence exactly. Say both out loud. Log them.$md$
),
(
  (select id from public.skills where slug = 'no-warning'),
  5,
  'Nobody can see it',
  $md$The single most useful fact about speaking to a room is that almost none of what you are experiencing is visible.

Your heart rate is invisible. The dry mouth is invisible. The shaking hands are visible to you at close range and to nobody at four feet, and the wobble in your voice that sounds enormous from inside is, to the room, a very slight variation that most people do not register at all.

**The move:** stop managing something nobody can see, and put the attention on what you are saying.

The gap between the inside and the outside of this is larger than for almost any other social difficulty, and it is worth taking seriously as a fact rather than as reassurance. People who film themselves speaking are routinely astonished — the recording shows somebody slightly stiff, and they remember an ordeal.

The practical consequence is not *be more confident*, which is not available on request. It is that a substantial part of what makes speaking hard is the effort of concealment, and concealment is unnecessary, so that effort can be spent on the speech instead.

Two things that genuinely help and are physical rather than mental. Slow down — nerves compress speech and the correction is not to speak slowly but to stop properly at full stops. And breathe out before you start; the first sentence goes wrong most often because somebody began it on an empty chest.

The room is also on your side by default, which people find hard to believe and which is straightforwardly true. Everybody there is relieved it is not them, everybody wants it to go well, and nobody is hoping to watch somebody struggle. An audience is the most sympathetic group you will stand in front of all week.

And if something does go wrong, the room takes its cue from you. Pause, carry on, and it is a pause. Apologise for it, and it is an incident.

If you keep one thing: nobody can see it. Whatever is happening in your chest is not on your face, and the effort of hiding it is the part you can put down.$md$,
  $j$[
    {
      "situation": "Your heart is going and your hands are shaking.",
      "line": "(none of that reaches the fourth row)",
      "why": "People who film themselves are routinely astonished — the recording shows somebody slightly stiff and they remember an ordeal."
    },
    {
      "situation": "You are working hard to hide the nerves.",
      "line": "(that effort is the part you can put down)",
      "why": "Concealment is unnecessary, and a substantial part of what makes speaking hard is the effort of it."
    },
    {
      "situation": "You lose your place for two seconds.",
      "line": "(pause, carry on)",
      "why": "The room takes its cue from you. Paused and continued is a pause; apologised for is an incident."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the practical consequence of nobody seeing it?",
      "options": [
        { "text": "You can relax.", "correct": false, "note": "Relaxing is not available on request, and instructing somebody to is why most advice here fails." },
        { "text": "The effort of concealment can be put down.", "correct": true, "note": "A substantial part of what makes speaking hard is hiding it. If there is nothing to hide, that effort goes into the speech instead." },
        { "text": "Mistakes do not matter.", "correct": false, "note": "They matter slightly, and how you handle them matters more — which is the last part of this lesson." },
        { "text": "You are better at this than you think.", "correct": false, "note": "Encouraging and unfalsifiable. The useful version is about where your attention goes." }
      ],
      "explain": "Slow down, breathe out before you start, and stop at full stops."
    },
    {
      "prompt": "Something goes wrong mid-speech. What decides how it lands?",
      "options": [
        { "text": "How big the mistake was.", "correct": false, "note": "Almost irrelevant. Rooms absorb substantial stumbles without noticing." },
        { "text": "Whether the audience is friendly.", "correct": false, "note": "They are, by default — everybody there is relieved it is not them." },
        { "text": "How quickly you recover.", "correct": false, "note": "Close, and speed is not it. A long pause handled calmly is fine." },
        { "text": "Whether you apologise for it.", "correct": true, "note": "The room takes its cue from you. Paused and continued is a pause; apologised for is an incident." }
      ],
      "explain": "An audience is the most sympathetic group you will stand in front of all week."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped_hiding", "label": "Stopped concealing", "description": "Put the effort into the speech rather than the disguise." },
      { "key": "slowed", "label": "Slowed down", "description": "Stopped properly at full stops." },
      { "key": "breathed", "label": "Breathed out first", "description": "Did not start the first sentence on an empty chest." },
      { "key": "no_apology", "label": "Did not apologise for a stumble", "description": "Paused and carried on." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are about to stand up. Your heart is going, your mouth is dry, and you are certain everybody will be able to tell.",
    "partner": {
      "name": "Rob",
      "role": "somebody sitting next to you",
      "personality": "Has no idea anything is happening. Reports what the room looks like from where they are sitting, which is a normal room waiting pleasantly.",
      "mood": "Relaxed.",
      "openness": 4
    },
    "opening_beat": "\"You are up next, I think.\"",
    "success_looks_like": "The user stops managing the nerves and gets on with it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Notice nothing about the user's state unless they announce it.",
      "Describe the room as ordinary and well disposed if asked.",
      "Never reassure the user about their nerves."
    ]
  }$j$::jsonb,
  $md$Today, speak in front of somebody without managing how the nerves look. Log what you noticed afterwards.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('no-warning', 1, 'line', $j${
  "says": "— and I think somebody else wanted to say something. Go on then. (A leaving do, for Sarah, who has been here four years.)",
  "model": {
    "line": "Sarah has held this team together for four years. When the whole thing fell over in March, she was the one still here at nine o'clock. We would all have left without her.",
    "why": "One thing, one example, one close — three slots, which is few enough to hold under adrenaline. The example is the part people will repeat."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No preamble and no apology",
      "words": ["i am not good at", "i had not prepared", "sorry", "unaccustomed", "put me on the spot", "i will keep this short", "where do i start", "i do not know what to say"] },
    { "kind": "min_words", "requirement": "One thing, one example, one close", "n": 18 },
    { "kind": "max_words", "requirement": "Three sentences is a speech", "n": 60 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('no-warning', 2, 'line', $j${
  "says": "Go on — you have known him longest. (A birthday dinner for Michael. Somebody has tapped a glass.)",
  "model": {
    "line": "To Michael. Who drove four hours to help me move a sofa he had never seen, to a flat he had never been to. There is nobody else I would have called. To Michael.",
    "why": "Name, specific, meaning, glass. About fifteen seconds, and the room ends it for you by drinking — which is why the toast is the easiest form of impromptu speaking there is."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Name him at the start",
      "words": ["michael"] },
    { "kind": "forbids_any", "requirement": "One specific, not a list of qualities",
      "words": ["kind, funny", "generous, loyal", "one of the best", "everything to me", "words cannot", "where do i begin", "so many things"] },
    { "kind": "min_words", "requirement": "Include the specific thing", "n": 18 },
    { "kind": "max_words", "requirement": "Fifteen seconds, then the glass", "n": 55 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('no-warning', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You have delivered your close. There is the small pause before applause — and you have just remembered something else good.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Add it — it is genuinely the best thing you had.", "correct": false, "note": "The oh, and I should also say arrives after everybody has reached for their glass, and it teaches the room not to believe your endings." },
        { "text": "Say it quickly so it does not disrupt the flow.", "correct": false, "note": "Speed does not help. The problem is that the speech had ended and has now restarted." },
        { "text": "Nothing. It is over.", "correct": true, "note": "A speech that has almost finished twice gets relief rather than warmth at the actual ending, which is a sad outcome for something well meant." },
        { "text": "Work it into a second close.", "correct": false, "note": "Two closes is the looping mechanism with better manners, and the room can hear it either way." }
      ]
    },
    {
      "situation": "You are thirty seconds in, you have said your thing, and it feels much too short for the occasion.",
      "prompt": "Is it?",
      "options": [
        { "text": "Yes — thirty seconds under-delivers on a moment like this.", "correct": false, "note": "That instinct arrives in every room and is wrong in all of them. Nobody has ever complained a speech was too short." },
        { "text": "Yes, unless it was exceptionally good.", "correct": false, "note": "Quality does not change the length calculation — a short good speech and a short ordinary one are both better than the long versions." },
        { "text": "No. Ending early reads as confidence.", "correct": true, "note": "A speech that ends slightly before people expected is charming, and there is no equivalent charm available at the other end." },
        { "text": "No, but add one more example to be safe.", "correct": false, "note": "One more example is how thirty seconds becomes two minutes, and the second is never as good as the first." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('no-warning', 4, 'line', $j${
  "says": "Have you actually said any of this out loud yet?",
  "model": {
    "line": "No — I have been learning it word for word. I should probably just fix the first line and the last line and say the rest.",
    "why": "A known opening buys the fifteen seconds where nerves are worst and a known close gives you an exit visible from anywhere. The middle sounds like a person only if it is not recited."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "First and last, not the whole thing",
      "words": ["first line", "last line", "first sentence", "last sentence", "opening", "ending", "start and", "beginning and"] },
    { "kind": "forbids_any", "requirement": "Do not memorise the middle",
      "words": ["word for word the whole", "learn it all", "memorise it all", "read it out", "off a script", "every word"] },
    { "kind": "min_words", "requirement": "Say what you are going to do", "n": 12 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('no-warning', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You are about to stand up. Heart going, mouth dry, hands not entirely steady.",
      "prompt": "How much of that reaches the room?",
      "options": [
        { "text": "Most of it — people can always tell.", "correct": false, "note": "People who film themselves speaking are routinely astonished: the recording shows somebody slightly stiff and they remember an ordeal." },
        { "text": "The voice, mainly.", "correct": false, "note": "The wobble that sounds enormous from inside is a very slight variation from four feet, and most people do not register it." },
        { "text": "Almost none of it.", "correct": true, "note": "Heart rate and dry mouth are invisible, hands are visible only at close range — and the practical consequence is that the effort of concealment can be put down." },
        { "text": "Depends how close the front row is.", "correct": false, "note": "Four feet is enough. Distance is not doing the work here." }
      ]
    },
    {
      "situation": "Halfway through, you lose your place for about three seconds.",
      "prompt": "What decides how that lands?",
      "options": [
        { "text": "How quickly you find it again.", "correct": false, "note": "A long pause handled calmly is completely fine. Speed is not the variable." },
        { "text": "Whether anybody noticed.", "correct": false, "note": "Some will have. It still lands as nothing unless something makes it into something." },
        { "text": "How well the rest has gone.", "correct": false, "note": "Rooms do not keep a running total. This moment is judged on its own." },
        { "text": "Whether you apologise for it.", "correct": true, "note": "The room takes its cue from you. Paused and carried on is a pause; apologised for is an incident." }
      ]
    }
  ]
}$j$::jsonb);

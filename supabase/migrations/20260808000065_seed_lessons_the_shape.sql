-- Storytelling & speaking, track 2: The shape.
--
-- Track one is the diagnosis and it already owns the frame and the front —
-- naming why you are telling it, and starting late. This one takes the four
-- structural decisions it did not: the turn, the ending, the accuracy, and the
-- discipline of telling one story rather than three.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'the-shape'),
  1,
  'Something has to turn',
  $md$This is the engine, and it is what separates a story from an account of a day.

A story is not a sequence of events. It is a change: something was expected and something else happened, or a plan met reality, or a thing that was one way became another. The turn is the moment that flips, and everything before it exists to set it up while everything after it exists to land it.

**The move:** find the turn, and build the telling around it.

Most flat stories have one and have not located it. Ask what the surprising bit was — the moment you would tell somebody about if you only had one sentence — and that is the turn. Then check that everything you are planning to say is either setting it up or paying it off, and cut whatever is doing neither. That single test removes most of what makes stories long.

The turn also tells you how to pace it. Slow down slightly as you approach — a beat before it is worth more than any wording — and do not rush the sentence itself, which is the commonest thing people do to their own best moment.

Two failure shapes worth recognising. A story with no turn at all, which is a description of an afternoon, and is better told as one sentence: *the whole thing was chaos from start to finish.* And a story with the turn in the wrong place, usually far too early, so the remaining two minutes are anticlimax — if the surprising thing happens in sentence two, the story ended there and you are still talking.

If you keep one thing: name the turn before you start, and check that every sentence is either setting it up or paying it off.$md$,
  $j$[
    {
      "situation": "You are about to tell a long story and are not sure why it drags.",
      "line": "(what is the moment that flips?)",
      "why": "That is the turn. Then cut anything that is neither setting it up nor paying it off, which removes most of what makes stories long."
    },
    {
      "situation": "The surprising bit happens in your second sentence.",
      "line": "(then the story ended there)",
      "why": "The remaining two minutes are anticlimax. The turn in the wrong place is as bad as no turn at all."
    },
    {
      "situation": "There genuinely is no turn.",
      "line": "The whole thing was chaos from start to finish.",
      "why": "One sentence is the honest form of a description of an afternoon. Telling it as a story promises a change that never arrives."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is a story, structurally?",
      "options": [
        { "text": "A change — something expected, and something else happening.", "correct": true, "note": "The turn is the moment it flips. Everything before sets it up, everything after lands it, and anything doing neither can go." },
        { "text": "A sequence of events with a good ending.", "correct": false, "note": "A sequence with an ending is still a sequence, and endings cannot rescue a middle nobody followed." },
        { "text": "Something interesting that happened to you.", "correct": false, "note": "Interest is not structural. Plenty of interesting events have no turn in them and cannot be told as stories." },
        { "text": "A problem and a resolution.", "correct": false, "note": "Close, and narrower than the real thing — plenty of good stories resolve nothing at all." }
      ],
      "explain": "Name the turn before you start. It is also the test for what to cut."
    },
    {
      "prompt": "The surprising bit arrives in sentence two. What is wrong?",
      "options": [
        { "text": "You gave away the ending.", "correct": false, "note": "Different problem. The issue is not that they know it, it is that nothing is left." },
        { "text": "Nothing — front-loading is fine.", "correct": false, "note": "The frame goes at the front. The turn is a different object and it cannot also live there." },
        { "text": "The story ended there and you are still talking.", "correct": true, "note": "Everything after a turn exists to land it, and two minutes of landing is anticlimax." },
        { "text": "It needed more setup first.", "correct": false, "note": "More setup is the front problem from the previous track. The fix is placement rather than padding." }
      ],
      "explain": "Slow down before the turn, and do not rush the sentence itself."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "found_turn", "label": "Found the turn", "description": "Named the moment something flipped." },
      { "key": "built_round_it", "label": "Built around it", "description": "Everything set it up or paid it off." },
      { "key": "placed", "label": "Placed it well", "description": "Not in sentence two, not missing." },
      { "key": "paced", "label": "Paced it", "description": "Slowed before it rather than rushing through." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are about to tell a story about a job interview that went strangely. The moment it turns is when the interviewer asks a question about your school.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reacts strongly at a turn that is given room, and politely at one that arrives buried in the middle of a sentence.",
      "mood": "Attentive.",
      "openness": 4
    },
    "opening_beat": "\"You said something odd happened in the interview?\"",
    "success_looks_like": "The user builds towards the turn and gives it room.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React properly to a turn that is set up and paced.",
      "Respond mildly if the surprising moment is buried or arrives immediately.",
      "Never ask what the point was."
    ]
  }$j$::jsonb,
  $md$Today, take one story and name its turn in a sentence. Log the turn and one thing you would cut for not serving it.$md$
),
(
  (select id from public.skills where slug = 'the-shape'),
  2,
  'End on the line',
  $md$Most stories are told well enough and then talked past the end, and the last twenty seconds undo a surprising amount of the first ninety.

**The move:** stop at the strongest moment, which is nearly always earlier than instinct says.

What people add after the last good line is always one of three things.

**The explanation.** *So basically he had thought I was somebody else the whole time.* If the story worked, they got that. Saying it converts a thing they enjoyed working out into a thing they were told.

**The evaluation.** *It was so funny at the time.* This is the worst of the three, because it asks the table for a verdict you have just told them to reach, and it reads as somebody checking whether it landed.

**The coda.** *Anyway, so that is why I was late.* A tidy return to where the story started, which feels like craft and is deflation — the energy is at the turn, and every sentence after it is downhill.

The mechanism underneath all three is the same: the silence after a story feels like a judgement, so people fill it. It is not. It is a beat, and the beat is where a story lands — a room needs a second to react, and talking through that second takes the reaction away.

Practically, this is the same instruction as the last lesson of the previous track's neighbour: know the last line before you start. If you know where you are going, you can stop there. If you do not, you will pass it, feel yourself pass it, and start adding.

If somebody wants more they will ask, and being asked a question is a much better ending than any sentence you could have added.

If you keep one thing: the strongest line is the last line. Say it and let the silence be a beat rather than a problem.$md$,
  $j$[
    {
      "situation": "You have delivered the best line and there is a beat.",
      "line": "(that beat is the landing)",
      "why": "A room needs a second to react, and talking through that second takes the reaction away."
    },
    {
      "situation": "You are about to explain what had actually been happening.",
      "line": "(if it worked, they got it)",
      "why": "It converts something they enjoyed working out into something they were told."
    },
    {
      "situation": "You want to say it was funnier at the time.",
      "line": "(that asks for a verdict)",
      "why": "It reads as somebody checking whether it landed, and it is the version that makes a good ending feel uncertain."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do people talk past the ending?",
      "options": [
        { "text": "They do not know the story is over.", "correct": false, "note": "They usually feel themselves pass it, which is what makes the additions so noticeable to the teller afterwards." },
        { "text": "They want to be understood completely.", "correct": false, "note": "That produces the explanation specifically, which is one of the three rather than the cause of all of them." },
        { "text": "They have more to say.", "correct": false, "note": "Almost never — it is the same story restated, evaluated, or tidied." },
        { "text": "The silence feels like a judgement.", "correct": true, "note": "So they fill it. It is a beat rather than a verdict, and the beat is where a story lands." }
      ],
      "explain": "Know the last line before you start, and you can stop there."
    },
    {
      "prompt": "Which addition costs the most?",
      "options": [
        { "text": "The explanation.", "correct": false, "note": "Costly, and it mostly makes a good story slightly flatter rather than uncertain." },
        { "text": "The coda that returns to the start.", "correct": false, "note": "Deflating, and it feels like craft, which is why it survives — but it does not undo the landing." },
        { "text": "The evaluation.", "correct": true, "note": "It was so funny at the time asks the table for a verdict you just told them to reach, and reads as checking whether it worked." },
        { "text": "Any of them equally.", "correct": false, "note": "They are not equal. One of them changes how the whole story is received." }
      ],
      "explain": "And if somebody wants more, being asked is a better ending than anything you could add."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped", "label": "Stopped at the line", "description": "Ended on the strongest moment." },
      { "key": "no_explanation", "label": "Did not explain it", "description": "Left them to have got it." },
      { "key": "no_evaluation", "label": "Did not evaluate it", "description": "No it was funnier at the time." },
      { "key": "let_it_land", "label": "Let the beat sit", "description": "Did not talk through the second afterwards." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just delivered the best line of the story. Nobody has said anything yet — it has been about a second and a half.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Reacts a beat after a good line if given the beat, and does not react at all if the teller talks through it.",
      "mood": "Enjoying it.",
      "openness": 4
    },
    "opening_beat": "(a beat — nobody has spoken yet)",
    "success_looks_like": "The user says nothing and lets the ending land.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React warmly a beat after a line if the silence is left alone.",
      "Give a small, flat response if the teller explains, evaluates or adds a coda.",
      "Never fill the silence immediately yourself."
    ]
  }$j$::jsonb,
  $md$Today, end one story on its strongest line and say nothing after it. Log what you did not add.$md$
),
(
  (select id from public.skills where slug = 'the-shape'),
  3,
  'Cut the accuracy',
  $md$*It was Tuesday — no, hang on, Wednesday, because I had the dentist on the Tuesday.*

Nobody at the table cares which day it was, nobody is checking, and you have just spent four seconds and all of your momentum on a fact that does no work.

**The move:** be approximately right at speed rather than exactly right slowly.

This is the hardest instruction in the topic for a certain kind of careful, honest person, and it deserves a proper answer rather than an instruction to relax. The impulse is not pedantry, it is integrity — you do not want to say something untrue. But precision has a cost paid by the listener, and the two are genuinely in tension, so it is worth knowing which details are load-bearing.

A detail is load-bearing if the story changes when it changes. If it was his brother rather than his friend and that is why it mattered, say brother. If the timing is the joke, the timing is exact. Everything else — days, exact ages, the road you were on, whether it was four or five — can be approximate, and approximating it is not a lie, it is a story being told at conversational speed.

The self-correction is the specific habit to lose. It costs a pause, breaks the rhythm, draws attention to something irrelevant, and signals that you are unsure of the material. Say Tuesday, be wrong, carry on. If somebody who was there corrects you, that is a pleasant interruption rather than an embarrassment.

The same applies to hedging: *I think*, *about*, *sort of*, *maybe around*. One or two are natural speech. A story dense with them reads as unconfident and, worse, as unsure of its own events — and a listener who suspects the teller does not quite believe it stops investing in it.

If you keep one thing: only the load-bearing details need to be exact. Everything else is allowed to be approximately true at speed.$md$,
  $j$[
    {
      "situation": "You cannot remember whether it was Tuesday or Wednesday.",
      "line": "(say Tuesday and carry on)",
      "why": "Nobody is checking, and the correction costs a pause, the rhythm, and the impression that you are sure of your own story."
    },
    {
      "situation": "The detail is the reason it mattered.",
      "line": "(then be exact)",
      "why": "A detail is load-bearing if the story changes when it changes. Those ones are worth the precision."
    },
    {
      "situation": "Your story has six I thinks and four abouts in it.",
      "line": "(that reads as not believing it yourself)",
      "why": "A listener who suspects the teller is unsure of the events stops investing in them."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What makes a detail worth being exact about?",
      "options": [
        { "text": "Whether you can remember it clearly.", "correct": false, "note": "Your confidence about a fact is unrelated to whether the story needs it." },
        { "text": "Whether the story changes when it changes.", "correct": true, "note": "If brother rather than friend is why it mattered, say brother. If the timing is the joke, the timing is exact. Everything else can be approximate." },
        { "text": "Whether anybody present might know.", "correct": false, "note": "Being corrected by somebody who was there is a pleasant interruption, not a hazard to design around." },
        { "text": "Whether it is a fact about a person.", "correct": false, "note": "Plenty of facts about people are irrelevant, and plenty of load-bearing details are about objects or timing." }
      ],
      "explain": "Approximately right at speed beats exactly right slowly."
    },
    {
      "prompt": "What does the self-correction actually cost?",
      "options": [
        { "text": "Very little — it is one second.", "correct": false, "note": "It costs the pause, the rhythm, the table's attention, and the impression that you are sure of your material." },
        { "text": "It makes you seem honest.", "correct": false, "note": "Honesty was never in question, and nobody has ever suspected a story of being false because a day was wrong." },
        { "text": "It signals you are unsure of the material.", "correct": true, "note": "And it draws attention to an irrelevant fact at exactly the moment attention was doing something useful elsewhere." },
        { "text": "It confuses people.", "correct": false, "note": "It rarely confuses anybody. The damage is to pace rather than to comprehension." }
      ],
      "explain": "This is hardest for careful, honest people, and the tension is real — hence load-bearing as the test."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "approximate", "label": "Was approximately right", "description": "Did not stop for irrelevant precision." },
      { "key": "load_bearing", "label": "Was exact where it mattered", "description": "Kept the details the story depends on." },
      { "key": "no_correcting", "label": "Did not correct themselves", "description": "Let a small error stand." },
      { "key": "few_hedges", "label": "Few hedges", "description": "Not dense with I think and about." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling a story and you genuinely cannot remember whether it was Tuesday or Wednesday, or whether the man was in his fifties or sixties.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Entirely uninterested in dates and ages, and visibly loses the thread whenever the teller stops to correct one.",
      "mood": "Enjoying the story.",
      "openness": 4
    },
    "opening_beat": "\"And this was at the weekend?\"",
    "success_looks_like": "The user answers approximately and keeps going.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept any approximate answer without comment and stay in the story.",
      "Lose the thread visibly if the teller stops to correct a date or an age.",
      "Never ask for a precise detail."
    ]
  }$j$::jsonb,
  $md$Today, tell one story without correcting a single detail. Log the correction you did not make.$md$
),
(
  (select id from public.skills where slug = 'the-shape'),
  4,
  'One story, not three',
  $md$You start telling a story. Halfway through, it reminds you of another one, which you begin explaining because it makes this one funnier. That one requires some background about a person the table has not met. Four minutes later, nobody including you could say what the original story was about.

**The move:** one story at a time, and no nesting.

The branching is not a discipline problem. It happens because everything really is connected in your memory: the second story genuinely is relevant, and the person genuinely does need introducing for the joke to work. What is missing is that the listener has none of those connections and is holding an unresolved story while you build a second one on top of it.

Two rules cover almost all of it.

**No nesting.** If a story requires another story to make sense, tell the other one first, separately, or cut the part that needs it. Anything that begins *and this is the thing about Michael* is a second story arriving before the first has ended.

**No new characters mid-flight.** Every person introduced costs the listener something. Two is comfortable, three is work, and a fourth arriving in minute two is where people stop tracking who is who — at which point they are not following a story, they are managing a cast list.

When you notice you have branched, do not reverse out with an apology. *Anyway* is a complete repair — say it, and go back to the main thread. Nobody minds a digression that ends; what people mind is a digression that quietly becomes the story while the first one is left open.

And the version worth catching before you start: if it needs three characters and a piece of history to work, it is a good story for people who already know them and not for this table. Choosing not to tell it there is not a failure, it is casting.

If you keep one thing: finish the story you started. A second one arriving mid-flight is where both of them are lost.$md$,
  $j$[
    {
      "situation": "Halfway through, it reminds you of a better story.",
      "line": "(finish this one first)",
      "why": "They are holding an unresolved story while you build a second on top of it. Both get lost."
    },
    {
      "situation": "You are about to say and this is the thing about Michael.",
      "line": "(that is a second story arriving early)",
      "why": "Anything requiring another story to make sense should be told first, separately, or cut."
    },
    {
      "situation": "You have branched and noticed.",
      "line": "Anyway.",
      "why": "A complete repair. Nobody minds a digression that ends — they mind one that quietly becomes the story."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does branching happen to careful people?",
      "options": [
        { "text": "Everything really is connected in their memory.", "correct": true, "note": "The second story genuinely is relevant and the person genuinely does need introducing. The listener has none of those connections and is holding an open story meanwhile." },
        { "text": "They lose their thread.", "correct": false, "note": "Usually they are holding it perfectly. The problem is on the listener's side rather than the teller's." },
        { "text": "They are trying to make it funnier.", "correct": false, "note": "Often the intention, and the reason it feels necessary is the memory rather than the ambition." },
        { "text": "They talk too much.", "correct": false, "note": "It happens just as often to people who say very little, in their one story of the evening." }
      ],
      "explain": "One story at a time, and no nesting."
    },
    {
      "prompt": "How many people can a conversational story carry?",
      "options": [
        { "text": "As many as it needs, if you describe them well.", "correct": false, "note": "Describing them costs more than introducing them, and description is the front problem in another form." },
        { "text": "One — anything else is a different story.", "correct": false, "note": "Too strict. Most good stories have at least two people in them." },
        { "text": "It depends whether they know them.", "correct": false, "note": "It helps, and even with familiar people a fourth name mid-flight costs tracking." },
        { "text": "Two comfortably; three is work.", "correct": true, "note": "A fourth arriving in minute two is where people stop tracking who is who, and start managing a cast list instead of following a story." }
      ],
      "explain": "If it needs three characters and a history, it is a story for people who already know them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_story", "label": "Told one story", "description": "Did not start a second inside it." },
      { "key": "few_people", "label": "Kept the cast small", "description": "Two or three people at most." },
      { "key": "repaired", "label": "Repaired cleanly", "description": "Said anyway and returned to the thread." },
      { "key": "cast_it", "label": "Chose the right story for the room", "description": "Did not tell one that needed history they lacked." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling a story about a delivery. It genuinely connects to a much better story about your neighbour, which requires knowing about the neighbour's brother.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table who does not know any of these people",
      "personality": "Follows one thread easily and visibly loses track the moment a second person or story is introduced mid-flight.",
      "mood": "Willing.",
      "openness": 4
    },
    "opening_beat": "\"What happened with the delivery?\"",
    "success_looks_like": "The user finishes the delivery story without nesting the neighbour one inside it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Follow easily while there is one thread and two people.",
      "Get visibly lost and ask who somebody is when a second story or a third name arrives.",
      "Never ask about the neighbour."
    ]
  }$j$::jsonb,
  $md$Today, tell one story without letting a second one in. Log the one you did not tell.$md$
),
(
  (select id from public.skills where slug = 'the-shape'),
  5,
  'Four decisions before you speak',
  $md$Everything in these two tracks reduces to four decisions, all of which are made before you open your mouth and all of which take about ten seconds together.

**The move:** frame, start, turn, end. Decide those, then tell it.

**The frame.** One line saying why this is worth hearing. *The most ridiculous thing happened at the garage.*

**Where to start.** The moment things begin to go wrong, not the beginning of the day.

**The turn.** The thing that flips — and the check that every sentence is either setting it up or paying it off.

**The last line.** Know it before you begin, so you can steer towards it and stop there.

Ten seconds is genuinely all it takes once the four are familiar, and they are the difference between a story that works and the same events getting *oh, right*. It is worth noticing that none of the four is about performance. There is nothing in there about being funny, being confident, or having a good voice — which is why this is learnable by exactly the person who assumes it is not.

Two things that follow from having done it. The story gets much shorter, because the setup is gone and the digressions have nowhere to attach. And it gets easier to tell, because you are steering towards a known point rather than improvising towards an unknown one — most of the anxiety in telling a story is not knowing where it ends.

Run it on the stories you already tell. Everybody has four or five they return to, and they are the ones worth shaping, because the improvement is permanent and you will use it dozens of times. Take one, do the four decisions on it deliberately, and it will be a different story for the rest of your life.

If you keep one thing: frame, start, turn, end. Ten seconds of deciding, and none of it is performance.$md$,
  $j$[
    {
      "situation": "You are about to tell one of your usual stories.",
      "line": "(frame, start, turn, end — ten seconds)",
      "why": "Four decisions, all made before you speak, and none of them about being funny or confident."
    },
    {
      "situation": "You have four stories you tell regularly.",
      "line": "(shape those — the improvement is permanent)",
      "why": "You will use it dozens of times. One deliberate pass makes it a different story for the rest of your life."
    },
    {
      "situation": "You feel anxious about telling one.",
      "line": "(most of that is not knowing where it ends)",
      "why": "Steering towards a known last line is considerably easier than improvising towards an unknown one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is notable about the four decisions?",
      "options": [
        { "text": "They are quick.", "correct": false, "note": "True, and speed is not the interesting property." },
        { "text": "None of them is performance.", "correct": true, "note": "Nothing about being funny, confident, or having a good voice — which is why it is learnable by exactly the person who assumes it is not." },
        { "text": "They work for any story.", "correct": false, "note": "Broadly true, and not what makes them worth learning." },
        { "text": "They are what good storytellers do naturally.", "correct": false, "note": "Many do, and describing them as natural is what makes people think it cannot be acquired." }
      ],
      "explain": "Frame, start, turn, end. Ten seconds of deciding."
    },
    {
      "prompt": "Which stories are worth shaping deliberately?",
      "options": [
        { "text": "The four or five you already tell regularly.", "correct": true, "note": "The improvement is permanent and you will use it dozens of times, which makes one deliberate pass unusually good value." },
        { "text": "New ones, as they happen.", "correct": false, "note": "Useful, and each one gets told once or twice. The return is much smaller." },
        { "text": "The most impressive ones.", "correct": false, "note": "Impressiveness is not the variable, and the best-shaped stories are frequently about very small events." },
        { "text": "The ones that have gone badly.", "correct": false, "note": "Worth diagnosing and it is a smaller set than the ones you repeat." }
      ],
      "explain": "It also makes them shorter and easier to tell, because you are steering towards a known point."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "framed", "label": "Decided the frame", "description": "Knew the first line." },
      { "key": "start", "label": "Decided where to start", "description": "Picked the moment it goes wrong." },
      { "key": "turn", "label": "Named the turn", "description": "Knew what flips." },
      { "key": "last_line", "label": "Knew the last line", "description": "Decided where it ends before beginning." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "One of your regular stories, about to be told again — this time with the four decisions made first.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Responds noticeably better to a shaped telling and is honest about where attention went in an unshaped one.",
      "mood": "Attentive.",
      "openness": 4
    },
    "opening_beat": "\"Tell them the one about the garage.\"",
    "success_looks_like": "The user frames it, starts late, builds to the turn and stops on the line.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React fully to a story that is framed, starts late, and ends on its line.",
      "Respond mildly where any of the four decisions is missing.",
      "Never name the four decisions yourself."
    ]
  }$j$::jsonb,
  $md$Today, take one story you tell regularly and make the four decisions on it. Log all four.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('the-shape', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A two-minute story about a job interview. The odd moment — the interviewer asking about your school — arrives about fifteen seconds in.",
      "prompt": "What is wrong with that?",
      "options": [
        { "text": "Nothing — get to the good bit quickly.", "correct": false, "note": "The frame goes at the front. The turn is a different object, and putting it there leaves a minute and a half of anticlimax." },
        { "text": "The story ended at fifteen seconds and you are still talking.", "correct": true, "note": "Everything after a turn exists to land it. Ninety seconds of landing is a story that finished and kept going." },
        { "text": "You needed more setup before it.", "correct": false, "note": "More setup is the front problem from the previous track. This is about placement rather than padding." },
        { "text": "It gives away the ending.", "correct": false, "note": "A different failure. The issue here is what is left to listen for, not what they know." }
      ]
    },
    {
      "situation": "You are trying to work out what to cut from a story that drags.",
      "prompt": "What is the test?",
      "options": [
        { "text": "Cut anything you can say faster.", "correct": false, "note": "Compression, not structure. A dragging story compressed is a shorter dragging story." },
        { "text": "Cut anything the listener could infer.", "correct": false, "note": "Reasonable and it is a rule about detail rather than a rule about shape." },
        { "text": "Cut anything that is neither setting up the turn nor paying it off.", "correct": true, "note": "That single test removes most of what makes stories long, and it can be applied before you speak." },
        { "text": "Cut anything about other people.", "correct": false, "note": "Cast size matters and is a separate lesson. Plenty of essential material is about other people." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-shape', 2, 'line', $j${
  "says": "(you have just delivered the best line of the story — a beat, and nobody has spoken yet)",
  "model": {
    "line": "(nothing)",
    "why": "The beat is where a story lands. A room needs a second to react, and every sentence added into that second — the explanation, the evaluation, the tidy return to the start — takes the reaction away."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No explaining, evaluating or tidying up",
      "words": ["so basically", "it was so funny", "you had to be there", "anyway so", "that is why", "what had happened was", "i suppose", "does that make sense"] },
    { "kind": "max_words", "requirement": "Say nothing, or nearly nothing", "n": 6 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-shape', 3, 'line', $j${
  "says": "And this was at the weekend?",
  "model": {
    "line": "Saturday, I think — anyway, so he opens the door and he is already holding the box.",
    "why": "Approximately right at speed. The day is not load-bearing, nobody is checking, and stopping to establish it would cost the pause, the rhythm and the impression that you are sure of your own story."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not stop to get it exactly right",
      "words": ["no wait", "hang on", "actually it was", "or was it", "let me think", "no sorry", "i tell a lie", "come to think of it"] },
    { "kind": "min_words", "requirement": "Answer and keep going", "n": 10 },
    { "kind": "max_words", "requirement": "Do not stop for it", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-shape', 4, 'choice', $j${
  "beats": [
    {
      "situation": "Halfway through the delivery story, it reminds you of a much better one about your neighbour — which needs you to explain the neighbour's brother first.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Tell the neighbour one — it is better.", "correct": false, "note": "They are holding an unresolved story while you build a second on top of it, and by the end nobody could say what the first one was." },
        { "text": "Quickly explain the brother, then carry on.", "correct": false, "note": "A third name arriving mid-flight is where people stop tracking who is who and start managing a cast list." },
        { "text": "Finish the delivery story.", "correct": true, "note": "One story at a time. If the other one needs telling, it can be told next, on its own, with its own frame." },
        { "text": "Mention it briefly so they know there is more.", "correct": false, "note": "A trailer for a second story is still a second story, and it opens a loop the first one now has to close." }
      ]
    },
    {
      "situation": "You have already branched and you are two sentences into the neighbour.",
      "prompt": "How do you repair it?",
      "options": [
        { "text": "Sorry — I have gone off on one, ignore all that.", "correct": false, "note": "An apology makes the digression an event. Nobody minded until it was announced." },
        { "text": "Anyway. So he opens the door —", "correct": true, "note": "A complete repair in one word. People do not mind a digression that ends; they mind one that quietly becomes the story." },
        { "text": "Finish the neighbour story, then go back.", "correct": false, "note": "Now there are two open stories and a promise to return, which is more tracking than a table will do." },
        { "text": "Ask if they want to hear about the neighbour instead.", "correct": false, "note": "It hands the table a decision they have no basis for, and abandons the story they were already following." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-shape', 5, 'line', $j${
  "says": "Tell them the one about the garage.",
  "model": {
    "line": "Right — the most ridiculous thing happened at the garage. So the mechanic comes out, looks at the car for four seconds, and says: whose is this?",
    "why": "Frame, then straight in at the moment something happens. Two of the four decisions visible in one breath, and no setup, no disclaimer and no day of the week."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No disclaimer, no setup, no orientation",
      "words": ["not that interesting", "you had to be there", "sorry", "so basically", "it was tuesday", "i had gone to", "let me think", "where do i start"] },
    { "kind": "min_words", "requirement": "Frame it and start it", "n": 15 },
    { "kind": "max_words", "requirement": "Two sentences in and something has happened", "n": 45 }
  ]
}$j$::jsonb);

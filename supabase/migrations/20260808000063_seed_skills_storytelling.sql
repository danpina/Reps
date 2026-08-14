-- Storytelling & speaking: the five tracks.
--
-- The topic's own description is the diagnosis: you finish the story, there is
-- a small pause, and somebody says "oh, right". The material was fine. That is
-- what makes this teachable — almost nobody has a story problem, they have a
-- structure problem, and structure is the most learnable thing in this whole
-- app.
--
-- The boundary with Work is already drawn from the other side. Work's
-- Presenting is the room you are in anyway: your deck, your colleagues, your
-- boss in the third row, the question you cannot answer. This is craft, and it
-- is the audience you do not work with — a table of six, a wedding, a room
-- that has just turned round and asked you to say something.
--
-- Track four is the one a shorter version would cut, and it is the one this
-- app's readers need. Every other book on this subject assumes somebody who
-- wants the floor and needs to be better on it. The reader here is somebody
-- who believes taking ninety seconds of a table's attention is an imposition,
-- and no amount of craft reaches them until that is addressed.
--
-- No lessons yet. Do not apply this before the first track is written.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'storytelling'),
  'why-stories-die',
  'Why your stories die',
  $$You finish, there is a small pause, and somebody says "oh, right". The material was fine. Something else went wrong.$$,
  $$Almost nobody has a story problem. They have three structural ones — no reason for telling it, too much front, and nothing at stake.$$,
  $md$The most useful thing to know about this is that the material is almost never the problem.

People conclude the opposite. A story lands badly, and the lesson taken is *I do not have interesting things happen to me* — which is both untrue and unfixable, and it is why so many people simply stop telling them. The same events, in somebody else's mouth, would have worked.

**The move:** stop looking for better stories and look at three specific failures.

**No reason for telling it.** You know why this is worth saying. The listener does not, and they will not work it out on the way. A story that arrives without a reason attached is a series of events happening to somebody they know, and the natural response to that is *oh, right* — which is not rudeness, it is the honest reaction to being told something for no stated purpose.

**Too much front.** The single most common failure. Stories die in the setup, where the teller establishes the day of the week, who else was there, why they were there, what the weather was doing, and a small correction about whether it was Tuesday. By the time anything happens, the table has quietly gone.

**Nothing at stake.** Something has to be at risk, or capable of going wrong, or unresolved. Without it there is no reason to keep listening rather than to wait politely for the end — and people can feel the difference between following a story and waiting out one.

It is worth being encouraged rather than discouraged by all three, because they are structural and structure is learnable. Being funnier is not available on request. Cutting the first forty seconds is.

If you keep one thing: the events were fine. It went wrong in the telling, and the telling is a set of decisions you can make differently.$md$,
  1
),
(
  (select id from public.topics where slug = 'storytelling'),
  'the-shape',
  'The shape',
  $$Where to start, what to cut, and how to stop — which is the whole of what separates a story from a series of events.$$,
  $$Frame it in one line, start late, make sure something turns, and end on the line rather than on the explanation.$$,
  $md$A story has a shape, and the shape is four decisions rather than a talent.

**Frame it in one line.** Before anything happens, say what kind of thing this is. *I nearly got arrested in a Tesco.* *This is the worst thing I have ever agreed to.* That sentence does an enormous amount: it tells people why they are listening, it sets the register, and it buys you the thirty seconds of patience that the middle needs. It is also the part almost nobody does.

**Start late.** Cut everything before the moment things begin to go wrong. Not the drive there, not who suggested it, not the context. You will feel that the story does not make sense without the setup — it almost always does, and anything genuinely required can be dropped in on the way past in four words.

**Something has to turn.** A story is not a sequence, it is a change: an expectation set up and then broken, a plan meeting reality, a thing that was one way and became another. If nothing turns, what you have is an account of a day, and no amount of delivery will save it.

**End on the line.** Stop at the strongest moment, which is nearly always earlier than instinct says. What kills endings is the explanation afterwards — the bit where you say what it meant, or how you felt about it, or that it was really funny at the time. Everything after the last good line is subtraction.

And cut the accuracy. Whether it was Tuesday or Wednesday is not load-bearing, and pausing to correct yourself costs you more than the error would have. Precision about irrelevant detail is the most common way a well-shaped story still dies.

If you keep one thing: frame, start late, turn, stop. Four decisions, all of them made before you open your mouth.$md$,
  2
),
(
  (select id from public.topics where slug = 'storytelling'),
  'telling-it',
  'Telling it',
  $$Present tense, actual words, one detail that does work — and knowing your last line before you begin.$$,
  $$Put people in the moment rather than reporting it afterwards. And decide where it ends before you start.$$,
  $md$Same story, same shape, and two people tell it completely differently. What varies is not charisma; it is four habits, and each of them is copyable.

**Present tense for the live part.** *So I am standing in the doorway and he turns round* puts somebody in the room. *So I was standing in the doorway and he turned round* is a report filed afterwards. It sounds like a trick written down and it is close to invisible when spoken, and it changes how present the whole thing feels.

**Actual words, not summaries.** *He said he was not interested* is information. *He says, without looking up: not interested* is a scene. Dialogue is the single biggest upgrade available to most people, and it needs no wit — you are quoting, not inventing.

**One detail that does work.** Not a description. One specific thing that makes it real and could not have been made up: the fact that he was holding a sandwich the whole time, the hold music, the enormous dog. One is plenty. Three is a description, and a description is where pace goes to die.

**Know your last line before you start.** This is the one that separates people who land stories from people who trail off. If you know what the final sentence is, you can steer towards it and stop cleanly. If you do not, you will arrive somewhere near the end, run out, and say *so, yeah — anyway*, which is the sound of a story being abandoned rather than finished.

Your face and voice do more than the words, and you do not have to perform. Slowing down before the turn, and letting a small silence sit before the last line, are both free and both do most of what people mean by good delivery.

If you keep one thing: decide the last line first. Everything else in the telling is steering towards it.$md$,
  3
),
(
  (select id from public.topics where slug = 'storytelling'),
  'holding-the-floor',
  'Holding the floor',
  $$The belief that ninety seconds of a table's attention is an imposition, and what to do with it.$$,
  $$A well-told story is a gift and a badly-told one is a tax. Know how long you have, and know how to land one that is dying.$$,
  $md$Every other book on this subject is written for somebody who wants the floor and needs to be better on it. If you are reading this app, the problem is more likely to be the opposite: a conviction that taking up ninety seconds of a table's attention is an imposition on everybody at it.

That belief needs answering before any of the craft is any use, and it is answerable.

**The move:** notice that the imposition is not length, it is quality.

A well-told ninety-second story is a gift. It is the thing people go out for. Nobody has ever left an evening resenting somebody who told a good story, and the fear that you are taking something from the room has the direction wrong — a room with nobody willing to tell one is not a relaxed room, it is a flat one, and everybody there can feel it.

What is a tax is a badly-told six-minute story, and the difference is not confidence. It is the previous two tracks.

Then the practical half. Know roughly how long you have: sixty to ninety seconds in a group, longer one to one, and much shorter if people are standing up or the food is arriving. Watch for the moment somebody starts waiting rather than listening — it is visible, and it is the cue to get to the end rather than to speed up.

Landing one that is dying is a real skill and it is not humiliating. Skip to the turn, deliver the last line, and stop. Do not apologise, do not explain that it was funnier at the time, and do not add more detail in the hope of rescuing it. A short story that ended is a completely ordinary event; an apology afterwards is what makes it a moment.

And do not compete. If somebody has just told a good one, yours does not have to beat it — following a story with a related one is how conversations work, and treating it as a contest is what makes a table exhausting.

If you keep one thing: nobody resents a good story. The thing you are worried about imposing is the thing people came for.$md$,
  4
),
(
  (select id from public.topics where slug = 'storytelling'),
  'no-warning',
  'Standing up with no warning',
  $$"Say a few words." Thirty faces turn round, and you have about four seconds.$$,
  $$Three sentences is a speech: one thing you want to say, one specific example, and a close. Shorter is always better.$$,
  $md$Somebody says *say a few words*, thirty faces turn round, and there is no preparation available. This is the most frightening version of speaking and it has the simplest structure, which is a genuinely fortunate combination.

**The move:** one thing, one example, one close. Three sentences is a speech.

**One thing.** Pick a single point and do not add a second. *Sarah has held this team together for four years.* Whatever else is true, this is the sentence you are here to say, and choosing it takes about three seconds while you are standing up.

**One example.** The specific that makes it real. *When the whole thing fell over in March, she was the one still here at nine o'clock.* This is the part people remember, and it is why a short speech about one real thing beats a long one about somebody's qualities.

**One close.** A sentence that lands and stops. *We would all have left without her.* Or, at a table, raise the glass — the physical action does the ending for you, which is why toasts are the easiest form of impromptu speaking there is.

Shorter is always better and this cannot be overstated. Nobody in the history of leaving dos has complained that a speech was too short. Everybody has sat through one that was too long, and the difference between thirty seconds and four minutes is almost entirely whether somebody knew when to stop.

For the ones you know are coming — the toast, the wedding, the thank-you — learn the first sentence and the last sentence by heart and improvise the middle. That gives you a confident start, which is where nerves are worst, and a clean landing, which is where speeches usually fail. A fully memorised speech fails differently and worse: lose your place in one of those and there is nowhere to go.

And the nerves: everybody assumes you are fine. Whatever is happening in your chest is close to invisible from four feet away, and the room is on your side by default, because everybody there is relieved it is not them.

If you keep one thing: one thing, one example, one close — then stop. Thirty good seconds beats four minutes every single time.$md$,
  5
);

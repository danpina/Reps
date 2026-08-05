-- What to take with you from each track.
--
-- The recap of what a track covered is assembled from the lessons themselves,
-- so it stays accurate as content changes. This column holds the part that
-- cannot be assembled: the distillation, written once per skill.

alter table public.skills add column takeaway_md text;

update public.skills set takeaway_md = $md$You never needed a good line. You needed a true one.

Environment openers work because they are always available and cost nothing: name the thing you are both already in, say it plainly, and stop. The stop is the technique. A remark with no pause is a comment; a remark followed by silence is an invitation.

The rest is timing and form. Check someone is available before you spend an opener on them. Lead with a statement rather than a question, so the first thing you offer is a small piece of yourself instead of a small demand. And remember that FORD is a map of where you can go, not a script.

If you keep one thing: the conversation rarely dies at your first line. It dies at your second, when you reach for a new question instead of picking up what they just handed you.$md$
  where slug = 'openers';

update public.skills set takeaway_md = $md$Facts are the floor, and most conversations never leave it.

The whole ladder is three rungs — what happened, what it was like, what it means or what comes next — and the climb is almost never clever. Take a fact they have already offered and ask what it was like. That single move does most of the work in this track.

Two refinements worth keeping. Offering someone a choice of two feelings is far easier to answer than asking them to describe their emotions from scratch. And a run of three factual questions turns you into an interviewer, which is a role people quietly resent.

If you keep one thing: knowing when not to climb is part of the skill. A warm thirty-second exchange that stays on the first rung is a success, not a missed opportunity.$md$
  where slug = 'going-deeper';

update public.skills set takeaway_md = $md$Being understood is rarer than being agreed with, and much cheaper to provide.

A label is their own word, said back as a statement, followed by nothing. Use their word exactly — swapping it for your paraphrase replaces their experience with your summary of it, and they will feel the difference without being able to name it.

The hard half is the silence afterwards. Two seconds feels like ten to the person who caused it, and the reflex to rescue it is what ruins the technique. People fill silence; the thing they say next is usually more honest than the thing before, because it was not planned.

If you keep one thing: guess at the feeling anyway. A wrong label offered gently gets corrected, and the correction is more precise than anything you would have got by asking.$md$
  where slug = 'listening-and-labeling';

update public.skills set takeaway_md = $md$Asking only questions is its own failure mode. It reads as evasive, however warm the questions were.

The test is simple: if you cannot name one non-trivial thing the other person now knows about you, you were conducting a conversation rather than having one. And non-trivial means an opinion, something you found harder than expected, or something you want and have not got. Anything that could go on a CV is biography, not disclosure.

The rhythm is match, then add. Meet what they put down at roughly its own weight, then add one clause you did not have to say. That extra clause is how conversations deepen without either person having to be brave.

If you keep one thing: when you overshare, name it lightly and hand the conversation back. People forgive an overshare easily. What they find uncomfortable is the sense that you did not notice.$md$
  where slug = 'reciprocity';

update public.skills set takeaway_md = $md$Banter is a claim about closeness, which is why it fails when it arrives too early.

Aim at the situation before you aim at the person. A joke about the queue, the venue, the agenda — nobody has to defend those, so nobody can be wounded, and you both get the pleasure of being on the same side of something. Teasing the person comes after that licence is established, never instead of it.

Two forms carry most of the weight. Describing something at obviously the wrong scale, so it cannot be mistaken for a real judgement. And treating something entirely trivial as a crisis, which is disagreement with the risk removed.

If you keep one thing: a callback costs nothing but attention and is worth more than any joke. Keep one funny thing they said in your pocket and bring it back as you leave. And when a joke dies, three words and move on — a failed joke lasts exactly as long as you keep it alive.$md$
  where slug = 'banter';

update public.skills set takeaway_md = $md$Warmth is a dial, not a switch, and that is what makes this survivable.

Move one notch, then stop and read what comes back. Met means you can stay here. Exceeded means they are ahead of you. Answered on the content while the warmth goes unremarked is a no, delivered in the gentlest available form — and reading that correctly is the whole skill.

Watch attention rather than words. Politeness produces warm sentences for free; it does not make someone stay when a friend waves from across the room. What people do with a chance to leave is the honest signal.

If you keep one thing: once it is plainly mutual, say the plain thing. Continuing to hint at that point is not subtlety, it is making them do the interpreting. Say it simply and phrase it so a no costs them nothing.$md$
  where slug = 'flirting-calibration';

update public.skills set takeaway_md = $md$This is a skill, not a disclaimer, and it is the one that makes the rest safe to practise.

Count signals rather than reading everything into one. Short closed answers, no reciprocal questions, a body angled at the exit. One means nothing; people are tired. Three at once is an answer, and noticing it early is what lets you leave gracefully instead of being endured.

Curiosity is the most reliable tell. Someone interested in you eventually asks you something. Sustained absence of any question back is the hardest signal to explain away.

If you keep one thing: when you genuinely cannot tell, treat it as a no and stay friendly. The two mistakes do not cost the same, and the expensive one is not the one you feel. And keep your warmth exactly where it was on the way out — a drop in warmth after a no reveals the earlier warmth as payment for something.$md$
  where slug = 'reading-disinterest';

update public.skills set takeaway_md = $md$Joining a group is mostly a physical problem, and people try to solve it verbally.

Step into the circle and say nothing. Groups open up almost automatically, you have asked nobody for anything, and thirty seconds of listening buys you something relevant to say. Then wait for a laugh: attention is unallocated, everyone is relaxed, and a contribution there reads as joining in rather than taking over.

The price of admission is two contributions to their subject before you set one. Redirecting on arrival is the fastest way to be read as someone who does not listen.

If you keep one thing: bring in the person who has gone quiet, with a specific question they can definitely answer. It costs you nothing, it earns real loyalty, and an open question like "what do you think" is a spotlight rather than an invitation.$md$
  where slug = 'groups';

update public.skills set takeaway_md = $md$Almost everyone leaves too late, and it is the most fixable habit in this whole curriculum.

Conversations do not have natural endings. They have a peak and then a long decline, and whichever you leave on is what both of you remember. Go at the first comfortable lull after a good stretch, not when you have run out of things to say.

The shape is three parts and takes four seconds: a reason that has nothing to do with them, one specific warm thing about the conversation you actually had, and then actually leaving. Most people underinvest in the middle one — "nice to meet you" is furniture, not warmth.

If you keep one thing: when a conversation is not working, raise your warmth as you go rather than lowering it. It leaves the reason ambiguous, which is the kindest thing you can offer someone you are walking away from.$md$
  where slug = 'exits';

alter table public.skills alter column takeaway_md set not null;

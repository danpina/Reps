-- Hard conversations: the five tracks.
--
-- The boundary with Work was drawn from the other side already. Work's Your
-- manager stops at routine disagreement and declining work; its Raising a
-- problem stops at the first escalation. Everything past those lines is here,
-- and here it is not only about work — the conversation somebody has been
-- rehearsing for a month is at least as likely to be with a friend, a partner
-- or a brother.
--
-- Track one exists because the single most common state in this topic is not
-- having had the conversation. A month of rehearsing in the shower feels like
-- preparation and is avoidance with a productive feeling attached, and no
-- amount of technique reaches somebody who is still getting ready.
--
-- Track five is the mirror, and it is the one that would be cut from a shorter
-- version. A topic that only teaches somebody to deliver difficult things and
-- never to receive them produces a person who is worse to be close to, which
-- is the opposite of what this app is for.
--
-- No lessons yet. Do not apply this before the first track is written, or five
-- skills render as "Not written yet" and the topic has no free sample.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'hard-conversations'),
  'worth-having',
  'Whether to have it at all',
  $$A month of rehearsing it in the shower, and no conversation. What that month actually is, and how to decide.$$,
  $$Rehearsal is not preparation. Have it if there is a change you want or you will otherwise carry it — and if neither, let it go properly.$$,
  $md$Almost nobody arrives at this topic mid-conversation. They arrive four weeks into rehearsing one, which feels like getting ready and is not.

That is worth naming first, because it is the state most of this is spent in. Running it in the shower, in the car, at three in the morning — each version slightly sharper, slightly more devastating — has the texture of preparation. It is avoidance with a productive feeling attached. You are not becoming readier; you are becoming more invested in a script the other person has never read, and more certain of what they will say back, which is a guess.

**The move:** decide whether it is worth having, then have it this week or drop it properly.

Two questions decide it, and neither is about how angry you are.

**Is there a specific change you want?** Something the other person could actually do differently. If you cannot name it, what you have is a feeling that wants expressing, which is a real thing and a different job — and delivering it as a conversation about them will go badly.

**Will you carry it otherwise?** This is the one people underweight. Things that get swallowed do not stay neutral, they convert — into distance, into a slightly colder version of you, into a friendship that thins for reasons the other person never learns. Silence is not free; it is paid in instalments.

If the answer to both is no, let it go and mean it. Half-letting-go is what produces the stockpile, and a stockpile eventually arrives all at once, which is worse than any single conversation would have been.

And if you have been rehearsing for a month, that is your answer to the second question. Nobody rehearses something they have let go of.

If you keep one thing: rehearsal is not preparation. A month of it means you have already decided it matters — so the only question left is when.$md$,
  1
),
(
  (select id from public.topics where slug = 'hard-conversations'),
  'opening-it',
  'Opening it',
  $$The first thirty seconds, and the two ways people wreck them before anybody has said anything.$$,
  $$Ask for the time and name the subject in the same sentence. Then say the thing in the first thirty seconds, not after ten minutes of warm-up.$$,
  $md$Two things go wrong before the conversation has started, and both are done by people trying to be kind.

The first is the ambush. Raising something serious in passing, at the door, in the last five minutes of a call, or over text, because that felt easier than asking for time. It is easier — for you. For them it arrives with no warning and no room, and the reaction you get is to being ambushed rather than to what you said.

The second is the dread-summons: *can we talk later?* with no subject attached. It sounds considerate and it hands somebody four hours of fear, during which they will invent something worse than whatever you actually have. By the time you speak they are braced for a catastrophe, and anything short of one still lands like an accusation because they have been preparing for one.

**The move:** ask for the time and name the subject in the same sentence.

*Can we talk this evening? It is about the money thing, and it is not a big drama.* That gives them the two facts they need — that there is a conversation, and roughly what it is about — and removes the four hours. If it genuinely is serious, say that too rather than pretending otherwise; false reassurance is worse than none once the conversation starts.

Then, in the room, say it in the first thirty seconds. The warm-up is for you. Ten minutes of pleasantries before a difficult subject is not gentler, it is a trapdoor — and everybody has been on the receiving end of a conversation that started well and turned, and knows how that feels afterwards.

Say what you want from it, too. *I want to sort this out, not have a row* is one sentence and it changes what the next twenty minutes are for.

If you keep one thing: name the subject when you ask for the time. Everything after that is easier for both of you.$md$,
  2
),
(
  (select id from public.topics where slug = 'hard-conversations'),
  'saying-the-thing',
  'Saying the thing',
  $$What you actually say, and the four habits that turn a solvable problem into an argument about your character or theirs.$$,
  $$What happened, what it did, what you want. Say it once, own the feeling rather than asserting their intent, and leave always and never out of it.$$,
  $md$The content of a hard conversation is smaller than people expect. Three parts, and everything else is decoration or damage.

**What happened.** A fact, not a summary of a pattern. *The last three times we have made plans you have cancelled the day before.* Checkable, agreeable, and impossible to argue with as a matter of fact.

**What it did.** The consequence, including the one inside you. *I have stopped making plans that I actually want to do, because I assume they will not happen.* This is the part people leave out, and without it you have described something you did not like and the honest answer is *and?*

**What you want.** One specific change. Not a redesign of somebody's personality — a thing they could do differently on Thursday.

Then four habits, all of which convert a solvable problem into a trial.

**Always and never.** *You always cancel* invites a counter-example, gets one, and now you are arguing about whether it is always rather than about the thing.

**The character claim.** *You are selfish* cannot be acted on and cannot be agreed to, so it will be defended — usually at length, and usually for the rest of the conversation.

**Asserting their intent.** *You did it to make a point* is a claim about somebody's inner life that you cannot know and they will not concede. Say the effect instead: *it landed as though you were making a point* is unarguable, because it is a report on you.

**The apology sandwich.** Compliment, criticism, compliment. Everybody has been taught it and it produces one of two outcomes: only the compliments are heard, or the compliments are heard as manipulation and nothing is trusted.

And say it once. The urge to explain it four different ways comes from the silence afterwards, and each restatement makes the point weaker and the conversation longer.

If you keep one thing: what happened, what it did, what you want. Say it once and stop.$md$,
  3
),
(
  (select id from public.topics where slug = 'hard-conversations'),
  'staying-in-the-room',
  'Staying in the room',
  $$They get defensive, upset, or turn it round on you — and you have thirty seconds to decide what kind of person you are going to be.$$,
  $$Their reaction is not a verdict on whether you were right. Do not fill the silence, do not withdraw the point, and do not escalate to match them.$$,
  $md$You said it. Now something happens, and what you do in the next thirty seconds decides whether the conversation was worth having.

The reactions are predictable and there are only about five of them. Defensiveness. A counter-attack about something you did in 2019. Tears. Flat silence. And *you are overreacting*, which is the one that lands hardest because it goes for the legitimacy of the whole thing rather than the content.

None of them is information about whether you were right. That is the thing to hold on to, because all of them feel like information — a strong reaction reads as evidence you have been unfair, and the reflex it produces in a quiet person is immediate retreat.

**The move:** let the reaction happen without filling it, matching it, or taking the point back.

**Do not fill it.** A silence after something difficult is somebody processing. Filling it is where the retraction happens — *anyway, it is not a big deal, forget I said anything* — and that sentence undoes twenty minutes of courage in four seconds.

**Do not take it back.** If they get upset, the honest response is *I know this is hard to hear, and I still think it* — which is warm and unmoved at the same time. Comforting somebody out of your own discomfort looks like kindness and functions as a withdrawal.

**Do not escalate.** If they counter-attack, the thing to refuse is the trade. *We can talk about that, and I would like to finish this first* is not a dodge; it is the only way both things get heard rather than neither.

And accept that you may not get agreement today. People rarely concede in the room. What frequently happens is that they defend themselves for twenty minutes and then change the behaviour anyway, having thought about it for a week — which means the conversation worked and you will never be told so.

If you keep one thing: their reaction is a reaction, not a verdict. Stay warm, stay put, and do not take the point back.$md$,
  4
),
(
  (select id from public.topics where slug = 'hard-conversations'),
  'hearing-it',
  'Hearing it about yourself',
  $$Somebody has just told you something true and unwelcome, and your face has already decided what to do about it.$$,
  $$Say nothing for three seconds, ask for the specific, and take the right to think about it. Then apologise without the word but.$$,
  $md$The other half of this topic, and the one that decides whether people can be honest with you twice.

The defensive reflex fires before you have finished hearing the sentence. It is not a decision and it is not a character flaw — it is fast, physical, and it produces the explanation, the counter-example, or the context you feel is missing, all of which are attempts to make the criticism untrue rather than to understand it.

What it costs is not the argument. It is that people learn. Somebody who has been defended at once does not raise the next thing, and the version of you that is hard to tell things to ends up being told nothing — which feels, from inside, like having no problems.

**The move:** three seconds of nothing, then ask for the specific.

The three seconds are the entire technique. They are enough for the reflex to pass, and they are visible to the other person as somebody taking it seriously, which is worth more than any answer you could give in that window.

Then *can you give me an example?* — asked to understand rather than to litigate. Most difficult feedback arrives generalised because it took somebody three weeks to say anything at all, and one example converts it into something you can actually do something about.

Then take the time. *Thank you — I want to think about it properly* is a complete and honest response, and almost nobody uses it. You are not required to have a position in the room on something you have just learned.

And look for the true part rather than the fair part. Most criticism is badly framed, and being badly framed is not the same as being wrong — if it is ten per cent right, the ninety per cent that is not is a distraction from the only bit that matters.

When it turns out you were wrong: name the thing, say what changes, and leave *but* out entirely. Everything after *but* deletes everything before it, and an apology with an explanation attached is a defence with an apology on the front.

If you keep one thing: three seconds, then a question. What you do in those seconds decides whether anybody tells you anything next year.$md$,
  5
);

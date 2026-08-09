-- Work, as revised after the first version had already been applied.
--
-- The previous migration seeded six tracks and was applied before the topic
-- gained two more: Raising a problem, and Saying what you want. Editing an
-- applied migration would have left this database and a fresh one disagreeing
-- for ever, so the earlier file keeps the eight it now describes — correct for
-- anybody building from scratch — and this one carries the delta.
--
-- Which means it has to be a no-op on a database that already has all eight,
-- and the fix on one that has six. Everything below is written twice-safe:
-- the rename matches nothing once it has run, the inserts defer on a slug that
-- exists, and the numbering is assigned rather than adjusted, so running it
-- again lands on exactly the same road.
--
-- Managing up became Your manager on the way. The old name is consultant
-- vocabulary and somebody two years into their first job does not know it
-- describes them; the half hour they have never asked for is a thing they can
-- see. The slug moves with it, which is safe only because the track has no
-- lessons, no progress rows and no cheat sheet pointing at it yet.

-- Out of the way first. sort_order is unique per topic and not deferrable, so
-- nothing can be renumbered in place.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'work';

update public.skills set
  slug = 'your-manager',
  name = 'Your manager'
where slug = 'managing-up';

-- Parked well clear of the shifted block, because the two worlds this has to
-- work in have different amounts of it occupied.
insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'work'),
  'raising-a-problem',
  'Raising a problem',
  $$Complaining about a situation, or about a person — to them, or to your manager, without becoming the difficult one.$$,
  $$Say the behaviour and what it cost, not the character. Ask for one specific change. And say it the week it happens, not in a list six months later.$$,
  $md$Almost nobody is taught how to complain at work, so most people do one of two things: absorb it, or eventually detonate. Quiet people overwhelmingly do the first, for months, and then leave a job over something that could have been a two-minute conversation in week three.

What sits underneath is a fear of being *the difficult one*. It is a real risk and it is much narrower than it feels. People are not marked as difficult for raising problems — they are marked as difficult for raising them about a person's character, without an ask, repeatedly, and long after the fact. Avoid those four and you can raise almost anything.

**The move:** the behaviour, the cost, and one specific change.

*Twice this week the file came at six, and I stayed late to turn it round* is unanswerable, because every word of it is a fact. *He is completely disorganised* is a character claim, which invites a defence of the character and settles nothing. The first is a problem somebody can fix; the second is an opinion somebody has to agree with, and they will not.

Then the ask. A complaint with nothing attached is a mood, and moods are what get filed as attitude. *Could we agree it lands by three?* is what converts a grievance into a piece of work — and it is also the thing that makes it stop.

Go to the person first, and go small and early. One sentence, the week it happens, said as an ordinary logistics point rather than as a confrontation. This is the step people skip, and skipping it is what makes the next one look like an escalation instead of a next step. Your manager's first question will be whether you have raised it directly, and the honest answer had better be yes — or, if there is a reason it could not be, say what the reason was.

Do not stockpile. Twelve things delivered at once is a campaign, however true each one is, and it puts the other person on trial. One thing, at the time, is a normal working conversation.

If you keep one thing: be boring about it. Facts, a cost, and one specific change — that combination is very hard to argue with and very hard to file as attitude.$md$,
  201
),
(
  (select id from public.topics where slug = 'work'),
  'saying-what-you-want',
  'Saying what you want',
  $$More responsibility, the project you keep watching other people get, and the job you would like next.$$,
  $$Being good at your job is not a bid for anything. Say the thing you want, to the person who decides, before there is a vacancy.$$,
  $md$There is a quiet assumption underneath a great many stalled careers: that doing the work well is a way of asking for more of it.

It is not. It is a way of being reliable at exactly what you currently do, and the most common reward for that is more of exactly what you currently do. Nobody is withholding anything — your manager has a list of things that need doing and a set of people whose ambitions they can only know if those people said them out loud. Being good is not a bid. It is not even a hint.

So say it, and say it as a direction rather than as a request for permission. *I would like to be running something like this by next year* is not presumptuous, it is information your manager cannot get any other way, and it converts you from somebody who is doing fine into somebody with a trajectory they are now partly responsible for. That last part is the mechanism: managers who know what you want start routing things towards it, often without mentioning it.

Ask before the vacancy. By the time a role is open there is usually somebody in mind, and the way people end up in that position is by having said, six months earlier, that it was where they were heading. A shy person tends to wait for the posting, which is the one moment when saying it first is no longer available.

Scope is the version of this you can ask for at any time. A project, an area, the thing nobody owns. It is easier to say yes to than a title, it is reversible, and it is what promotion cases are actually built out of — a title usually follows work you were already visibly doing.

Two things to give up, both of which feel like modesty and function as self-elimination: waiting to be ready, and hoping to be noticed. Nobody feels ready, the people who get the work are not more ready than you, and being noticed is not a plan.

If you keep one thing: say where you want to go, to the person who decides, before there is anything to apply for.$md$,
  202
)
on conflict (slug) do nothing;

-- The copy Your manager gained along with its name, applied by slug so a
-- database that already has the new version simply rewrites it with itself.
update public.skills set
  description = $$The half hour you have never asked for, the one-to-one you spend on status, and the decision you disagreed with silently.$$,
  core_idea = $$Ask for the time, bring one thing you actually want, disagree once and in private, and say no with a trade rather than an apology.$$,
  takeaway_md = $md$Your manager is the single highest-leverage relationship you have at work, and most people run it entirely on their manager's terms.

It starts with not having the meeting at all. A great many people have no standing one-to-one and have never asked for one, because asking looks like it needs a reason and nothing has gone wrong. It does not need a reason — *could we do a regular half hour?* is a request managers say yes to almost without exception, and it is the single highest-return sentence in this topic. If a chat is a one-off rather than a rhythm, ask for it the same way: name the subject, keep it to half an hour, and do not build a case for being allowed to talk.

The next symptom is the one-to-one spent on status. Status is what writing is for — it can be read in ninety seconds at a time that suits them — and spending a scheduled half hour reciting it burns the only slot in the week where you have somebody's whole attention. Arrive with one thing you actually want from them: a decision, an introduction, a view, cover for something. One, not four.

Disagreement is where quiet people lose the most, because the choice feels like objecting in the meeting or saying nothing. There is a third option and it is the one senior people actually use: disagree once, in private, plainly — and then commit in public whichever way it goes. That is not timidity. Somebody who argues privately and supports publicly gets asked their opinion more, not less.

Saying no is a trade rather than a refusal. *If this comes in, what comes out?* is not a difficult sentence and it changes the conversation from your willingness to their priorities, which is where it belonged. Almost every unreasonable workload survives because nobody made the trade visible.

And bad news travels upward badly. It arrives late, softened, and usually after the point where anybody could have helped — which is the version that damages you. Early and plain is uncomfortable for a day. Late is what gets remembered.

If you keep one thing: bring one thing you want. A one-to-one you did not shape is a one-to-one you sat through.$md$
where slug = 'your-manager';

-- The road, in four pairs: the room, the relationship, the ambition, the
-- outside. Assigned rather than nudged, so this lands identically whichever
-- state it started from.
update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('speaking-in-meetings', 1),
    ('your-manager', 2),
    ('raising-a-problem', 3),
    ('being-seen', 4),
    ('saying-what-you-want', 5),
    ('asking-for-money', 6),
    ('presenting', 7),
    ('the-corridor', 8)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'work' and s.slug = m.skill_slug;

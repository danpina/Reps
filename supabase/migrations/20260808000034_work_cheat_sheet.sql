-- The printable page for Work.
--
-- Eight tracks and a twenty-concept ceiling, so two each. That is tighter than
-- the other topics manage and it is the right constraint here: a topic this
-- wide is exactly the one that would turn back into a syllabus if every track
-- were allowed five.

update public.topics set cheatsheet_json = $j${
  "idea": "Almost everything difficult at work is one sentence somebody did not say. The meeting where you had the answer, the half hour you never asked for, the thing you absorbed for eleven months, the work nobody knows you did, the job you wanted and never mentioned, the number you did not name. None of it needs charisma and none of it needs a personality you do not have — each one is a specific sentence, said at a specific moment, and every sentence on this page is short enough to say while frightened.",
  "groups": [
    {
      "skill": "speaking-in-meetings",
      "concepts": [
        {
          "name": "Say it unfinished",
          "body": "You are holding yourself to a standard nobody else in the room is applying. Flag it — half-formed thought — and being wrong costs nothing."
        },
        {
          "name": "A name, then a two-word runway",
          "body": "Gaps do not arrive in good meetings. Enter at a comma, say somebody's name, and take the sorry off the front."
        }
      ]
    },
    {
      "skill": "your-manager",
      "concepts": [
        {
          "name": "Ask for a rhythm, not a favour",
          "body": "Could we do a regular half hour? A one-off has to be justified every time; a standing slot is justified once and then simply exists."
        },
        {
          "name": "Disagree once, in private, and commit",
          "body": "Say the objection and the commitment in one breath. The second half is what lets you say the first half plainly."
        }
      ]
    },
    {
      "skill": "raising-a-problem",
      "concepts": [
        {
          "name": "Behaviour, cost, one change",
          "body": "The file came at six and I stayed late — could we agree three? A fact can be fixed; a character judgement gets defended."
        },
        {
          "name": "Never stockpile",
          "body": "One thing at the time is a working conversation. Twelve at once is a case, and nobody can fix twelve things, so they manage you instead."
        }
      ]
    },
    {
      "skill": "being-seen",
      "concepts": [
        {
          "name": "There is no ledger",
          "body": "The default is not neutral — it is a project that went well with no name attached. Work does not speak; people do."
        },
        {
          "name": "Name the work, not yourself",
          "body": "The migration went out Thursday, no downtime. If it could be disputed it is an opinion about you; if it could not, it is visibility."
        }
      ]
    },
    {
      "skill": "saying-what-you-want",
      "concepts": [
        {
          "name": "Being good is not a bid",
          "body": "Somebody who wants more and somebody who is content look identical. Say the direction: I would like to be running something like this by next year."
        },
        {
          "name": "Scope now, title later",
          "body": "Ask to own something unowned — a Tuesday decision, reversible, free. The title is built from work you were already visibly doing."
        }
      ]
    },
    {
      "skill": "asking-for-money",
      "concepts": [
        {
          "name": "A number, then silence",
          "body": "A topic gets absorbed; a figure gets answered. The pause is two seconds, and the first to speak after it is negotiating against themselves."
        },
        {
          "name": "Three things you did, and a date",
          "body": "Effort and loyalty cannot be repeated in a room you are not in. And never leave a no without asking what would have to be true, and when to come back."
        }
      ]
    },
    {
      "skill": "presenting",
      "concepts": [
        {
          "name": "Point on the slide, sentences in your mouth",
          "body": "You cannot read out a slide with nothing to read. Say the conclusion first — presentations get cut short, and an answer-first one has landed."
        },
        {
          "name": "One sentence, one person",
          "body": "Scanning reads as nerves. And I do not know, I will come back today is a complete answer — improvising is the only version that damages you."
        }
      ]
    },
    {
      "skill": "the-corridor",
      "concepts": [
        {
          "name": "Recognisable, not impressive",
          "body": "The target is that the second conversation starts warm. Say what you work on, not your title — something a stranger could ask about."
        },
        {
          "name": "Plant the exit, then send two lines",
          "body": "In a room with no clock, mention your shape in the first minute. Afterwards: same day, one real detail, no ask."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'work';

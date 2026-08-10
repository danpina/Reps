-- The printable page for The first date. Four tracks, four concepts each.

update public.topics set cheatsheet_json = $j${
  "idea": "Almost everything that makes a first date hard is decided before either of you arrives, or in the last twenty minutes. The middle — two hours of talking — is the part people dread and the part that mostly looks after itself once the rest is right. And the question you are there to answer is not whether they liked you. It is whether you liked them, which is the only one of the two you can actually answer, and the one nobody thinks to ask.",
  "groups": [
    {
      "skill": "before-you-go",
      "concepts": [
        {
          "name": "Somewhere you can leave",
          "body": "A drink, some background noise, an hour or two. Dinner commits you to three courses opposite each other on the kitchen's schedule."
        },
        {
          "name": "Say the finish time on arrival",
          "body": "Said in the first two minutes it is logistics; said at the end it is an escape. It also frees them — without it they cannot leave early without it being a verdict."
        },
        {
          "name": "Decide nothing in the four hours before",
          "body": "Dread peaks about ninety minutes out and drops ten minutes after arriving. The case for cancelling arrives with three sensible reasons attached."
        },
        {
          "name": "Go to find out, not to be liked",
          "body": "One is unanswerable and puts you in a monitoring posture for two hours. The other you can answer at any moment."
        }
      ]
    },
    {
      "skill": "the-conversation",
      "concepts": [
        {
          "name": "The first ten minutes are not the date",
          "body": "Awkward is structural — two strangers, high stakes, nothing to do together. Chemistry at minute twenty is the normal case, not the exception."
        },
        {
          "name": "React, do not report",
          "body": "Facts are what you offer when you are afraid of being disliked. Answer, then say what you actually think about your own answer."
        },
        {
          "name": "Volunteer one real thing early",
          "body": "Asking all the questions is not generosity, it is the most acceptable way to hide — and it is what makes the dam go at drink two."
        },
        {
          "name": "Bring something back",
          "body": "A detail from an hour ago cannot be faked, needs no wit, and beats any compliment. Save one — it becomes the next date."
        }
      ]
    },
    {
      "skill": "do-you-like-them",
      "concepts": [
        {
          "name": "The exhaustion is the monitoring",
          "body": "Two hours of talking is not tiring. Two hours of being marked is, and it produces second dates with people you did not enjoy."
        },
        {
          "name": "Am I enjoying this?",
          "body": "Not is it going well, which is a guess at somebody's inner state made while nervous. Ask the answerable one, deliberately, twenty minutes in."
        },
        {
          "name": "Relieved or disappointed?",
          "body": "If they had to leave in ten minutes. The first reaction arrives before you can arrange it and is very rarely wrong."
        },
        {
          "name": "You do not need a fault",
          "body": "Not wanting to is a complete reason. Hunting for something wrong with them is how people talk themselves into a second date."
        }
      ]
    },
    {
      "skill": "what-happens-next",
      "concepts": [
        {
          "name": "End it before it flattens",
          "body": "Two good hours leaves you both wanting the next. Five does not. A bad one ends the same way — deliberately, with no reason attached."
        },
        {
          "name": "Say the plain thing",
          "body": "I would like to do this again. Deniability was for strangers whose interest was unknown; by now it reads as indifference."
        },
        {
          "name": "Turn again sometime into a day",
          "body": "Specific, small, two days, built from something they said. We should sort something out asks them to invent the plan."
        },
        {
          "name": "A time back is yes, a reason back is no",
          "body": "And send something the same day either way. Silence is not kind — it costs you nothing and them a week."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'first-date';

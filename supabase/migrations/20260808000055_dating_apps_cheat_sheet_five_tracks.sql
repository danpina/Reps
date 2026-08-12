-- The printable page for Dating apps, restated for five tracks.
--
-- The old sheet was three groups of five, written when the topic was three
-- tracks. Appending two more groups of five would have taken it to
-- twenty-five, past the point where a sheet stops being something you can
-- hold — so it goes to five groups of three instead, and every track gets a
-- place on it.

update public.topics set cheatsheet_json = $j${
  "idea": "An app is three separate problems wearing one interface: get matched by the right people, survive the first three exchanges, and get off it into a room. Almost everybody works only on the middle one, and almost everybody fixes the profile because it is the only part you can edit from the sofa. Two things are worth holding on to before any of the technique. The numbers are a base rate rather than a verdict — everybody's look like this. And when it is not working, find the join that is broken before changing anything, because the part you can reach is rarely the part that is failing.",
  "groups": [
    {
      "skill": "your-profile",
      "concepts": [
        {
          "name": "Messageable beats impressive",
          "body": "There is no reply to laid-back. Write objects, places and opinions — things a stranger can pick up and open with."
        },
        {
          "name": "Photos have four jobs",
          "body": "A clear face alone first, a whole person, one doing the thing you actually do, one with a couple of people. Most profiles are six versions of one job."
        },
        {
          "name": "Promise the person who turns up",
          "body": "Overclaiming works, and the bill arrives on the first date. Include the unimpressive half — being believed is worth more than being admired."
        }
      ]
    },
    {
      "skill": "first-message",
      "concepts": [
        {
          "name": "Hey asks them to do all the work",
          "body": "One specific thing off their profile, one question, under thirty words. A message that could have been sent to anybody tells them it probably was."
        },
        {
          "name": "Read for the oddity, not the summary",
          "body": "The summary is what they wrote for everybody. The strange detail is what only you noticed, and it is the one they want to talk about."
        },
        {
          "name": "One question, not three",
          "body": "Three gets the easiest one answered and the rest are gone. Match their length while you are at it — theirs tells you the register."
        }
      ]
    },
    {
      "skill": "match-to-date",
      "concepts": [
        {
          "name": "Answer, then hand something back",
          "body": "Never leave the ball on their side twice running. A statement with an obvious gap works as well as a question and costs less formality."
        },
        {
          "name": "Get out of the interview",
          "body": "Facts are not information about a person. Answer the question, then say what you actually think about your own answer."
        },
        {
          "name": "Specific, small, and a time in it",
          "body": "Sometime is a wish. A drink is an hour. Two days offered is a choice; one is a summons — and propose while it is still going well."
        }
      ]
    },
    {
      "skill": "running-the-app",
      "concepts": [
        {
          "name": "Volume is not a verdict",
          "body": "Low single-digit match rates are ordinary. A non-match is a thumb moving while somebody half-watches television — nothing about it was considered."
        },
        {
          "name": "Ghosting is a habit, not a message",
          "body": "No explanation is coming. The mistake is not being upset, it is going looking for a reason — the invented one is always about you."
        },
        {
          "name": "Give it a start and a stop",
          "body": "Twenty deliberate minutes beats two hours of grazing and produces more, not less. And never open it when you already feel bad."
        }
      ]
    },
    {
      "skill": "where-it-is-breaking",
      "concepts": [
        {
          "name": "Count before you conclude",
          "body": "Five numbers, four weeks: swipes, matches, real conversations, dates arranged, dates had. One week is noise in both directions."
        },
        {
          "name": "Four joins, four different fixes",
          "body": "No matches is the first photo. Matches without talk is the opener. Fading is that you never named a day — which is the commonest break of all."
        },
        {
          "name": "Dates but no second dates is not this topic",
          "body": "Three working joins means the fault is in the two hours. Rewriting a profile that has produced dates is how people waste a year."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'dating-apps';

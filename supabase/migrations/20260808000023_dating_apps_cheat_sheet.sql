-- The printable page for Dating apps. Fifteen concepts across the three
-- tracks, which brings the topic level with the ones that were finished first.

update public.topics set cheatsheet_json = $j${
  "idea": "An app is three separate problems wearing one interface: get matched by the right people, survive the first three exchanges, and get off it into a room. Almost everybody works only on the middle one. The profile decides who ever writes to you and what they have to say; the proposal decides whether any of it turns into an hour opposite an actual person. And the medium suits a quiet person better than any room does — unlimited time, unlimited drafts, and no need to be quick.",
  "groups": [
    {
      "skill": "your-profile",
      "concepts": [
        {
          "name": "Messageable beats impressive",
          "body": "There is no reply to laid-back. Write objects, places and opinions — things a stranger can pick up and open with."
        },
        {
          "name": "Test every line for a reply",
          "body": "Ask what somebody could send you about it. If the answer is nothing, the line is decoration. Three or four hooks is a finished profile."
        },
        {
          "name": "Photos have four jobs",
          "body": "A clear face alone first, a whole person, one doing the thing you actually do, one with a couple of people. Most profiles are six versions of one job."
        },
        {
          "name": "A profile everybody likes gets no messages",
          "body": "Smooth is built by deleting everything reactable. Put in one thing some people will bounce off — it costs you the matches that would have faded at message four."
        },
        {
          "name": "Promise the person who turns up",
          "body": "Overclaiming works, and the bill arrives on the first date. Include the unimpressive half; being believed is worth more than being admired."
        }
      ]
    },
    {
      "skill": "first-message",
      "concepts": [
        {
          "name": "Hey asks them to do all the work",
          "body": "Nothing to answer, no evidence you read anything. One specific thing off their profile, one question, under thirty words."
        },
        {
          "name": "Read for the oddity, not the summary",
          "body": "The summary is what they wrote for everybody. The strange detail is what only you noticed, and it is the one they want to talk about."
        },
        {
          "name": "One question, not three",
          "body": "Three questions gets the easiest one answered and the rest are gone. It also reads as somebody who has not decided what they are interested in."
        },
        {
          "name": "Specific is the humour that survives text",
          "body": "Irony needs tone and there is none. A wry line about the actual thing in their photo lands where a joke does not."
        },
        {
          "name": "Match their length",
          "body": "Their message tells you the register they write at. Matching it is worth more than anything you could add to yours."
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
          "name": "The match arrives with fixed curiosity",
          "body": "Every message spends a little of it and none replace it. Propose after a few good days, not a fortnight — sixteen days of chat is pen pals."
        },
        {
          "name": "Specific, small, and a time in it",
          "body": "Sometime is a wish. A drink is an hour and dinner is an evening. Two days offered is a choice; one is a summons."
        },
        {
          "name": "One nudge, and read the counter-offer",
          "body": "Never mention the silence, and never send a second. A time back is a yes; a reason back with no alternative is a no, however warm."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'dating-apps';

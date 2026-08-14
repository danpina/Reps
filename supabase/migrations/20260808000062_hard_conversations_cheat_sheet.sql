-- The printable page for Hard conversations. Five tracks, three concepts each.

update public.topics set cheatsheet_json = $j${
  "idea": "The state most people are actually in is not mid-conversation — it is four weeks into rehearsing one, which feels like preparation and is avoidance with a productive feeling attached. Everything here is smaller than it looks from inside that month. The content is three parts. The opening is one sentence. The hardest thirty seconds are the ones after you have said it, and the whole skill there is to be warm and unmoved at the same time. And half of it is the other direction: what you do in the three seconds after somebody says something unwelcome about you decides whether anybody tells you anything next year.",
  "groups": [
    {
      "skill": "worth-having",
      "concepts": [
        {
          "name": "Rehearsal is not preparation",
          "body": "Four minutes on what you want to say and what you want to happen. And then what do they say has no end, and its function is to postpone."
        },
        {
          "name": "Silence is paid in instalments",
          "body": "The comparison people run is a bad half hour against nothing. The real one is against a year of converting, leaking, and them never getting the chance to fix it."
        },
        {
          "name": "A day, or a decision not to",
          "body": "Soon is the one answer that is not an answer, because every individual day is a bad day for it. And dropped means you would be at zero next time."
        }
      ]
    },
    {
      "skill": "opening-it",
      "concepts": [
        {
          "name": "Name the subject when you ask for the time",
          "body": "Can we talk later gives somebody four hours to invent something worse than what you have. Two facts: there is a conversation, and roughly what about."
        },
        {
          "name": "Time, privacy, no third thing",
          "body": "Not at the door, not in the car, not five minutes before somebody arrives. Side by side beats face to face for the difficult ones."
        },
        {
          "name": "Thirty seconds, and say what it is for",
          "body": "A warm-up is a trapdoor and it is for you. I want to sort this out rather than have a row tells them what shape they are in."
        }
      ]
    },
    {
      "skill": "saying-the-thing",
      "concepts": [
        {
          "name": "What happened, what it did, what you want",
          "body": "A checkable fact leaves nothing to dispute. Without the effect it is a preference, and the honest reply is: and?"
        },
        {
          "name": "Count, and describe the effect",
          "body": "Always hands them the exit — three of the last four does not. And you know what it did to you; you do not know why they did it."
        },
        {
          "name": "Say it once",
          "body": "No sandwich, and no second version. Almost nobody restates a difficult thing more firmly, so each pass talks you down to something unactionable."
        }
      ]
    },
    {
      "skill": "staying-in-the-room",
      "concepts": [
        {
          "name": "Upset is not the same as wronged",
          "body": "Somebody can be entirely in the wrong and entirely distressed about being told. The test for real information is whether it addresses the substance or your right to raise it."
        },
        {
          "name": "Warm and unmoved",
          "body": "I know this is hard to hear, and I still think it. Comfort is free; retraction teaches somebody that upset makes difficult things go away."
        },
        {
          "name": "That is fair, and can we finish this one",
          "body": "Concede what is true, refuse the trade, come back to theirs later. And end when it has been said and heard, not when you have won."
        }
      ]
    },
    {
      "skill": "hearing-it",
      "concepts": [
        {
          "name": "Three seconds",
          "body": "The reflex is physical, so decide in advance rather than resisting in the moment. People who are defended at once stop raising things."
        },
        {
          "name": "One example, and a day",
          "body": "Asked to understand, not to test — a second example is litigation. Thank you, I want to think about it properly is a complete answer, if you come back."
        },
        {
          "name": "The true ten per cent, and no but",
          "body": "Badly framed is not wrong, and winning the framing keeps the behaviour. Then name the actual thing, say what changes, and stop."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'hard-conversations';

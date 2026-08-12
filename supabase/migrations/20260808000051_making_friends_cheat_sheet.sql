-- The printable page for Making friends. Five tracks, three concepts each.

update public.topics set cheatsheet_json = $j${
  "idea": "Almost everybody who struggles with this has concluded it is a defect in them, and the evidence looks strong: it used to be easy and it is not now. Something did change, and it was not you. Friendship is made by repeated, unplanned, low-stakes contact with the same people — which school and university supplied in industrial quantities and adult life stopped supplying without announcing it. That makes this an infrastructure problem rather than a personality one, which is fortunate, because infrastructure can be built on purpose and a personality mostly cannot.",
  "groups": [
    {
      "skill": "why-it-got-hard",
      "concepts": [
        {
          "name": "The building was doing it",
          "body": "Nobody at school was good at making friends. The same people, daily, for years, with nothing at stake — and it stopped without anybody mentioning it."
        },
        {
          "name": "Frequency beats quality",
          "body": "One brilliant conversation with a stranger produces nothing. Six unremarkable ones with the same person produce a friend. You are not after a good conversation, you are after a sixth."
        },
        {
          "name": "Pick a room that repeats",
          "body": "Same people, on a schedule, small enough to be recognised, with time around the edges. The activity is nearly irrelevant — and the edges are what people forget."
        }
      ]
    },
    {
      "skill": "first-invitation",
      "concepts": [
        {
          "name": "We should do something is the experiment",
          "body": "Two years of it is the result, not the run-up. Willingness was never missing — a Thursday was."
        },
        {
          "name": "Name the odd thing, then ask",
          "body": "There is no adult phrase for would you like to be my friend, which is why nobody says anything. Saying it is slightly strange is what makes the rest ordinary."
        },
        {
          "name": "An hour, a place, a day",
          "body": "Small, specific, ends by itself. The fear is being stuck rather than being turned down, and a coffee finishes on its own."
        }
      ]
    },
    {
      "skill": "the-second-time",
      "concepts": [
        {
          "name": "Somebody has to go twice",
          "body": "Both of you enjoyed it and both are waiting for evidence you are wanted. Whose turn it is, is not information."
        },
        {
          "name": "The keen one does not exist",
          "body": "Try naming somebody you thought less of for organising things. What people dislike is pressure, not enthusiasm — and pressure is easy not to apply."
        },
        {
          "name": "Make it a standing thing",
          "body": "Ask once and arrange nothing for a year. A missed one is then just a missed one, because the next already exists."
        }
      ]
    },
    {
      "skill": "getting-past-pleasant",
      "concepts": [
        {
          "name": "Four years and nowhere",
          "body": "You have had the time and the liking. Nobody has moved from talking about things to talking about themselves, and the pleasant register has no natural exit."
        },
        {
          "name": "Offer, do not ask",
          "body": "How are you really puts them on the spot and gets a deflection. One small true thing about you lowers the level without asking permission."
        },
        {
          "name": "Say the warm thing and let it sit",
          "body": "These Tuesdays are the best thing in my month. Almost nobody hears this, and the undercut is the only way to get it wrong."
        }
      ]
    },
    {
      "skill": "keeping-it-alive",
      "concepts": [
        {
          "name": "Send things with no ask in them",
          "body": "Fifteen seconds, no reply needed. Contact with a request in it is admin; contact with nothing in it is the friendship."
        },
        {
          "name": "No apology after a lapse",
          "body": "Send the ordinary thing as though you spoke last week. An apology makes the gap the subject and asks them to reassure you first."
        },
        {
          "name": "Write three lines down",
          "body": "The interview, the brother, the thing in March. Asking three weeks later cannot be faked, and people tell you more once they know you remember."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'making-friends';

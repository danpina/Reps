-- The printable page for Meeting someone, restated rather than appended to.
--
-- The old sheet was fifteen concepts across three tracks. The topic now has
-- six, and appending three more groups would have put it at thirty — which is
-- the syllabus again, not something you can hold. So each track gets three,
-- and the three are the ones you would actually want in your pocket.

update public.topics set cheatsheet_json = $j${
  "idea": "The whole thing is one road, not a talent: read what the room allows, hold the first two minutes, offer warmth in notches, read what comes back, and ask while it is still going well. The one correction worth making in advance is that you are almost certainly under-reading rather than over-reading — most people who decide it was nothing never find out, because deciding it was nothing means doing nothing.",
  "groups": [
    {
      "skill": "walking-up",
      "concepts": [
        {
          "name": "Licence, time, exit cost",
          "body": "The only three things a room ever changes. Read them before you decide anything else about how to approach."
        },
        {
          "name": "A clock is a free attempt",
          "body": "In a queue the situation ends it for you, so there is no afterwards to dread. It is the easiest room there is and the one people leave having said nothing."
        },
        {
          "name": "Address the group, not the person",
          "body": "The friend arrived with them and will leave with them. Speak past the friend and the friend will end it, reasonably."
        }
      ]
    },
    {
      "skill": "first-two-minutes",
      "concepts": [
        {
          "name": "Do not apologise for being there",
          "body": "Not in words — in the half-step back and the rushed delivery. Treat the approach as an imposition and they will agree with you."
        },
        {
          "name": "Swap names inside two minutes",
          "body": "A tiny mechanical act that changes the category. Before it you are a stranger talking at somebody; after it the two of you are having a conversation."
        },
        {
          "name": "Pleasant beats interesting",
          "body": "Two minutes of ordinary and warm beats forty seconds of impressive. Interesting is effortful and legible; pleasant is what decides whether there is a third minute."
        }
      ]
    },
    {
      "skill": "flirting-moves",
      "concepts": [
        {
          "name": "Specific, and still deniable",
          "body": "Warmth anybody could receive is friendliness. Warmth that could only be aimed at them is not — and deniability is what lets them answer without declaring anything."
        },
        {
          "name": "Compliment the choice, not the face",
          "body": "If the only available reply is thank you, you complimented something they were given. A decision has a story behind it and they will tell it."
        },
        {
          "name": "Touch is a ladder, no answer is a no",
          "body": "One rung at a time, brief and public. Being touched back is the clearest yes there is; anything else means carry on exactly as before."
        }
      ]
    },
    {
      "skill": "flirting-calibration",
      "concepts": [
        {
          "name": "Warmth is a dial",
          "body": "Notches, not declarations. Each one is deniable, reversible, and produces information about whether to move again."
        },
        {
          "name": "Signal, then read",
          "body": "After any step up, stop and watch what comes back. The reading is the half people skip."
        },
        {
          "name": "Do slightly less",
          "body": "Leave a pause you would normally fill and see whether they pick it up. Doing all the work hides whether anybody else wants to."
        }
      ]
    },
    {
      "skill": "reading-disinterest",
      "concepts": [
        {
          "name": "Count signals, do not interpret one",
          "body": "Politeness is the default setting, not evidence. The strongest single signal is whether they ever ask you anything back."
        },
        {
          "name": "Leave first, and warmly",
          "body": "End it yourself before it becomes uncomfortable, with a reason that has nothing to do with them. And keep your warmth exactly where it was."
        },
        {
          "name": "When you cannot tell, treat it as a no",
          "body": "It costs you nothing and it is the only reading that is comfortable for both of you if you are wrong."
        }
      ]
    },
    {
      "skill": "asking-for-the-number",
      "concepts": [
        {
          "name": "Ask before it peaks",
          "body": "There is no perfect moment, only a climb and then a decline. At the door the ask arrives with nothing behind it and has to justify itself from scratch."
        },
        {
          "name": "Say what you want to do",
          "body": "A number on its own asks for access. A specific small thing from this conversation asks for a plan, which is far easier to answer either way."
        },
        {
          "name": "Make declining free, then text",
          "body": "Half a clause at the end — if you are up for it — and then stop talking. Take the first no as final, and if it was a yes, text the same day."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'meeting-someone';

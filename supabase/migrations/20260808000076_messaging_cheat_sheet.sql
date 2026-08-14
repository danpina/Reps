-- The printable page for Messaging. Five tracks, three each.

update public.topics set cheatsheet_json = $j${
  "idea": "Writing is where a quiet person's habits are most visible — the apology in front of the ask, the hedge, the word just — and it is also where they are most fixable, because you can see them before you press send. Two things carry the topic. Put the ask in the first line and delete what was in front of it. Then make yourself easy to reply to: one ask, context after, and the cheapest question that gets you what you need. The rest is knowing what the channel cannot do. It takes ten degrees off everything, so the warmth goes in on purpose. It carries facts and arrangements well and nuance badly, so past three messages it becomes a call. And a gap contains nothing at all — whatever you have found in it, you put there.",
  "groups": [
    {
      "skill": "stop-apologising",
      "concepts": [
        {
          "name": "Delete everything before the ask",
          "body": "Sorry to bother you asserts that this is a bother, and probably a stupid question asserts that it is stupid. You supplied both, unprompted, about something nobody had complained about."
        },
        {
          "name": "The word just",
          "body": "Just checking, just wondering, just a quick one. Delete every one and read it back — nothing is lost except the flinch, and the sentence gets shorter."
        },
        {
          "name": "Warmth yes, crouch no",
          "body": "Please and thank you are politeness. Sorry and probably stupid are apology, and they are different words. Following up is the same request again, with no reference to the gap."
        }
      ]
    },
    {
      "skill": "easy-to-reply-to",
      "concepts": [
        {
          "name": "One ask per message",
          "body": "Three questions in a paragraph gets you an answer to one of them, usually the last. Three asks is three messages, or a numbered list."
        },
        {
          "name": "Ask first, context after",
          "body": "The reader should know what is wanted by the end of line one. Background before the ask is read as a preamble, and preambles get left for later."
        },
        {
          "name": "Make the reply cheap, name the day",
          "body": "Ask the cheapest question that gets you what you need — a yes, a pick, a time. And no rush means never: say when you actually need it."
        }
      ]
    },
    {
      "skill": "tone-with-no-tone",
      "concepts": [
        {
          "name": "Everything reads colder",
          "body": "The channel takes ten off whatever you meant. Not a fault in your writing and not a mood in theirs — a known property to correct for in both directions."
        },
        {
          "name": "Put the warmth in on purpose",
          "body": "Acknowledge them, then answer. And punctuation is now tone: a full stop closes a door it did not use to, and ok reads shorter than okay."
        },
        {
          "name": "Stop decoding",
          "body": "A short reply is a person on a train, not a verdict. Attribute it to the situation before the relationship, and when you genuinely cannot tell, ask."
        }
      ]
    },
    {
      "skill": "group-chats",
      "concepts": [
        {
          "name": "Late is fine, apologising for it is not",
          "body": "Post it anyway, hours after the moment, with nothing in front of it. Sorry, only just saw this makes the lateness the subject; without it, nobody notices."
        },
        {
          "name": "React more than you post",
          "body": "Reacting is full participation and needs nothing to say. And a joke that dies costs nothing — do not explain it, do not follow it with a self-deprecating line, keep posting."
        },
        {
          "name": "Come back without announcing it",
          "body": "After months, post an ordinary thing. The re-entry speech is the only version anybody would find awkward. And if it concerns one person, send it to that person."
        }
      ]
    },
    {
      "skill": "not-everything-is-a-message",
      "concepts": [
        {
          "name": "Three messages means phone",
          "body": "The failure is bandwidth, not wording, so a better fourth message does not exist. Anything difficult is the same call: write to arrange it, talk to have it."
        },
        {
          "name": "A silence is not a message",
          "body": "A gap is a fact about their day. The tell that you are constructing rather than waiting is that the story gets worse over time — real information does not do that."
        },
        {
          "name": "Write it at eleven, send it at nine",
          "body": "Late at night a small thing looks large and the sentence you would cut looks necessary. The third you delete in daylight is the part the hour wrote."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'online-chatting';

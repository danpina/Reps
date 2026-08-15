-- The printable page for Talking to AI. Six tracks, three each.
--
-- Eighteen concepts, which is inside the twenty-concept ceiling and the only
-- sheet in the app with six groups, because the topic has six tracks.

update public.topics set cheatsheet_json = $j${
  "idea": "This is not a topic about prompting. It is about using the tool to get better at the other ten, without it quietly making you worse at them. Two habits carry the useful half: paste the actual material rather than describing it, and write the bad draft yourself before you hand anything over. The most valuable thing here is the free question — the one you have been too embarrassed to ask for six months now has an answer nobody will ever know you needed. The most important is the line: it can read your message, and it has never met the person who sent it. Everything about text is reliable, everything about people is invention delivered confidently. And the ceiling, stated plainly because an app built on this owes you that: nobody has ever become less shy by sending better messages.",
  "groups": [
    {
      "skill": "an-answer-worth-having",
      "concepts": [
        {
          "name": "Paste the actual thing",
          "body": "A description is a summary you wrote, and what you edited out is what the answer needed. Say who reads it, what they should do, and how long."
        },
        {
          "name": "Argue, do not start over",
          "body": "Shorter, drop the second point, keep the last line. Treating the first answer as final is the same reflex that keeps you quiet in rooms — this is the free place to practise contradicting."
        },
        {
          "name": "Never ask if it is good",
          "body": "It will say yes. Ask what is weakest, or what would stop somebody replying — questions that have a wrong answer. Skip the opening compliment."
        }
      ]
    },
    {
      "skill": "the-free-question",
      "concepts": [
        {
          "name": "Ask the thing you have nodded at",
          "body": "The word from week one that is now unaskable. No preamble, no explaining why you do not know. The whole list is usually an evening."
        },
        {
          "name": "I still do not understand",
          "body": "The third explanation is the one that lands, and with a person the third attempt does not exist. Say which bit lost you, then say it back in your own words."
        },
        {
          "name": "Say it in the room",
          "body": "I read up on this — is it right that…? Shows preparation, cannot be wrong, and often gets you a not exactly. Within two days, and never name the source."
        }
      ]
    },
    {
      "skill": "edit-do-not-write",
      "concepts": [
        {
          "name": "Write it badly first",
          "body": "Two bad sentences turn write me something into fix this, and they carry your ordering and your bluntness. Everything after is subtraction."
        },
        {
          "name": "Cut, do not improve",
          "body": "Improve adds an opening, an acknowledgement and a soft close. Cut this by half without losing the ask forces a decision about what the message is for."
        },
        {
          "name": "Keep your own awkward sentence",
          "body": "Read both aloud and keep the one you could say to their face. Structure is not voice, though — a buried ask is still a fault."
        }
      ]
    },
    {
      "skill": "rehearse-it-first",
      "concepts": [
        {
          "name": "Describe the person, not the role",
          "body": "How they push back, what they said last time, the part where you handled it badly. A role gets you advice about a role."
        },
        {
          "name": "Do not concede unless I answered",
          "body": "Left alone it plays somebody reasonable, and reasonable people were never the problem. A rehearsal you sail through has taught you nothing."
        },
        {
          "name": "What am I not saying?",
          "body": "The number, the consequence, the thing they did, or the word no. A plan that circles something has a hole with edges. Then say the opening out loud, three times."
        }
      ]
    },
    {
      "skill": "it-does-not-know-the-room",
      "concepts": [
        {
          "name": "Never ask what a message means",
          "body": "There is nothing in three words. What comes back is your own theory with structure added, and structure feels like evidence."
        },
        {
          "name": "Write it from their side",
          "body": "It will never question your account. If the advice flips, you had your framing handed back. Ignoring my messages and has not replied yet are the same three days."
        },
        {
          "name": "It answers how, never whether",
          "body": "Ask if you should send it and you get help sending it. Ask for the strongest case against, then decide yourself. If the question has a name in it, it is yours."
        }
      ]
    },
    {
      "skill": "do-not-outsource-the-reps",
      "concepts": [
        {
          "name": "Before and after, never during",
          "body": "Live help costs you the listening and teaches you nothing, and the next conversation will not have any. A rep you did not do is a rep you did not do."
        },
        {
          "name": "When the effort is the message",
          "body": "Condolence, apology, real thanks. I did not know what to say when I heard is complete, and every improvement makes it sound like it was easy to write."
        },
        {
          "name": "Send the sixth one cold",
          "body": "Check it afterwards, so the answer is information rather than a net. And two passes then send — if you are restoring what you cut, you finished a while ago."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'ai-prompting';

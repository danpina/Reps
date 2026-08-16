-- Talking to AI: fix the promise, and make the description a scene.
--
-- Migration 77 restated the description and left the promise alone, which was
-- an oversight rather than a decision. The promise is the line somebody reads
-- before deciding to pay, and it still said "ask once and get something
-- usable" — a claim about prompting technique, which is exactly the topic
-- this one deliberately is not. A reader arriving from that line would find
-- six tracks about something else.
--
-- The description also wanted redoing. Every other topic opens on a concrete
-- moment — the meeting where you said nothing, the "we should do something"
-- neither of you acted on — and mine was a summary of the contents. Only
-- visible once the page was rendered next to the other ten.

update public.topics set
  promise = $$Prepare for the conversation you are dreading, ask the question you have been too embarrassed to ask for six months, and know exactly where it stops knowing anything about people.$$,
  description = $$You already have it open in another tab. This is the topic about what it is genuinely good for, and the point where it starts making things up about people.$$
  where slug = 'ai-prompting';

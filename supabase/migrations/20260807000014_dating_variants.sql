-- Dating, written for who is actually reading it.
--
-- These are the ten lessons where a single general version was doing real
-- damage. "Escalate a notch and check whether it is matched" is sound advice
-- and it means three different things depending on who is escalating towards
-- whom: a man approaching women is managing the risk of being read as a
-- threat; a woman approaching men is managing the opposite problem, that
-- ordinary friendliness is routinely read as an offer; two people of the same
-- sex are usually stuck one step earlier, on whether the other person is
-- available at all.
--
-- Each variant is an addition, not a replacement. The lesson still says what
-- it said; this is the paragraph a good coach would add once they knew who
-- they were talking to.

update public.lessons set variants_json = $j$[
  {
    "when": { "sex": "male", "dating_interest": "women" },
    "label": "If you are a man reading interest in women",
    "note_md": "One asymmetry is worth naming plainly, because it changes what the signals mean.\n\nA woman in a public place has usually spent years being approached by men, some of whom did not take an answer. So politeness from her is not evidence of interest — it is frequently a strategy, and a well-practised one. Smiling, answering pleasantly, laughing at something unfunny: all of that can be someone managing a situation rather than enjoying it.\n\nThis is not a reason to be discouraged. It is a reason to weight the signals differently. Discount everything that could be politeness, and count only what costs her something: asking you a question back, offering information you did not request, turning her body towards you, staying when she had an easy exit.\n\nAnd give her the exit. Standing slightly out of her path, leaving a gap she could walk through, ending the exchange yourself at a natural point — these read as confidence to her and they cost you nothing. The man who is comfortable being turned down is a much better prospect than the one who has to be told twice.",
    "partner_sex": "female"
  },
  {
    "when": { "sex": "female", "dating_interest": "men" },
    "label": "If you are a woman reading interest in men",
    "note_md": "Your problem is usually the mirror image of the one this lesson assumes.\n\nOrdinary friendliness from a woman is over-read remarkably often, so the signals in this lesson will fire when you did not intend to send anything. That has two consequences worth planning for.\n\nThe first is that sustained attention from him is weak evidence. A man being interested in a conversation with a woman he finds attractive is not information — it is close to a constant. Look instead for whether he asks about you specifically, whether he remembers something from earlier, and whether he would still be doing this if you were not attractive to him.\n\nThe second is that backing off is a skill you will need more often, and earlier, than the general version of this lesson implies. Warmth withdrawn a notch is usually enough and it is worth learning to do smoothly, because the alternative is either an uncomfortable escalation or being unfriendly by default — and the second one costs you every conversation, not just the ones you wanted to end.",
    "partner_sex": "male"
  },
  {
    "when": { "sex": "male", "dating_interest": "men" },
    "label": "If you are a man reading interest in men",
    "note_md": "The general version of this lesson assumes you already know the other person could be interested in principle. Frequently you do not, and that uncertainty sits underneath every other signal.\n\nSo the ladder has an extra rung at the bottom, and it is worth being deliberate about it. Before you read interest, you are reading availability — and the signals for that are different: eye contact held a beat past the ordinary, a returned look, the second glance. The second glance is close to the whole thing; almost nobody looks twice by accident.\n\nUntil that rung is climbed, keep everything ambiguous enough to be nothing. Not out of shame — out of accuracy, because a line that could be read as friendly costs nothing when you have misjudged, and the whole point of calibration is that you only spend what you can afford to lose.\n\nOnce it is climbed, the rest of the lesson applies unchanged and the pace is usually faster.",
    "partner_sex": "male"
  },
  {
    "when": { "sex": "female", "dating_interest": "women" },
    "label": "If you are a woman reading interest in women",
    "note_md": "The hard part here is rarely the escalation. It is that the ordinary warmth between women looks almost exactly like early interest, so the signals this lesson relies on are noisier for you than for anyone else.\n\nCompliments, touch on the arm, close talking, sustained eye contact — all of it is standard between friends, which means none of it is evidence on its own. What still counts is the same thing that always counts: a change from her baseline. How is she with the other people in the room, and is she different with you? That comparison is the signal, and it is available to you in a way it is not to most people, because you can watch it happen.\n\nThe availability question sits underneath this one too, and the ordinary route through it is to make your own interest legible slightly earlier than feels comfortable — a specific compliment rather than a general one, an invitation with only you in it. Ambiguity that lasts too long is usually read as friendliness and filed there permanently.",
    "partner_sex": "female"
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'reading-disinterest')
  and sort_order = 1;

update public.lessons set variants_json = $j$[
  {
    "when": { "sex": "male", "dating_interest": "women" },
    "label": "If you are a man, on backing off",
    "note_md": "How you leave is the part that gets talked about afterwards, and it is the part most men handle worst.\n\nThe failure is almost never anger. It is the small negotiation — one more line, a joke to reset the mood, a question that requires an answer. Each of those asks her to turn you down again, and being turned down twice is a thing she has to manage rather than a thing you have to feel.\n\nSo make the exit cost her nothing. Take the first no as the answer, say something warm and unresentful, and go before it is awkward. If you were in a group or a place you will both remain in, be exactly as friendly afterwards as you were before — that, more than anything you said while trying, is what she will remember and repeat.\n\nThe upside is not only ethical. Backing off well is the single most attractive thing in this entire topic, and a non-trivial number of second chances come from having done it.",
    "partner_sex": "female"
  },
  {
    "when": { "sex": "female", "dating_interest": "men" },
    "label": "If you are a woman, on backing off",
    "note_md": "Your version of this problem is usually that the signal was never sent, and he is proceeding anyway.\n\nDropping a register works, and it works less often than the general lesson implies, because a lot of men are not reading the register at all. So the escalation is worth having ready: warm becomes neutral, neutral becomes brief, brief becomes a plain sentence. \"I am going to go and find my friends\" is not rude, and it does not require a reason attached to it — the reason is the most common thing women add here and it is what turns a decision into a negotiation.\n\nAnd know the point at which this stops being a calibration exercise. If someone is not taking a clear answer, the skill being practised is no longer conversation, and nothing in this app is worth staying in a situation for. Leave badly if leaving well is not available.",
    "partner_sex": "male"
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'reading-disinterest')
  and sort_order = 2;

update public.lessons set variants_json = $j$[
  {
    "when": { "sex": "male", "dating_interest": "women" },
    "label": "If you are a man, on offering warmth",
    "note_md": "Escalate on the safest axis first, and for you that is almost always words rather than proximity.\n\nA notch of warmth delivered verbally — a specific compliment, a slightly more personal question, a tease that assumes familiarity — can be declined silently and at no cost to either of you. A notch delivered physically cannot. Standing closer, a hand on the arm: those require her to either accept them or visibly reject them, and putting someone in that position is the thing that makes an otherwise good conversation memorable for the wrong reason.\n\nSo run the whole ladder verbally, and let physical proximity follow her rather than lead. If she closes the distance, the distance is closed. If she does not, you have lost nothing and she has not had to do anything about it.\n\nThe general rule holds: signal, read, adjust. This is only about which currency you signal in.",
    "partner_sex": "female"
  },
  {
    "when": { "sex": "female", "dating_interest": "men" },
    "label": "If you are a woman, on offering warmth",
    "note_md": "The calibration problem runs the other way for you: a notch of warmth is frequently received as three.\n\nThat is worth knowing rather than worrying about, and it has one practical consequence. Make the escalation specific rather than general, because specific warmth is harder to over-read. \"You are easy to talk to\" is ambiguous and will be taken as far more than it is. \"I liked what you said about your sister\" is warmer, more genuine, and it says exactly what it says.\n\nThe other consequence is that your signals are more legible than you think they are, so you rarely need the biggest one available. A step up from where you were is enough; the whole ladder at once removes your own room to adjust.",
    "partner_sex": "male"
  },
  {
    "when": { "dating_interest": "both" },
    "label": "If you date more than one sex",
    "note_md": "The ladder does not change, but which rung you start on does — and the honest complication is that you may be reading two quite different sets of signals in the same evening.\n\nThe useful discipline is to decide, before you say anything, which read you are working from. Interest expressed towards you tends to arrive in different currencies from different people, and defaulting to whichever you are most practised at is how a signal gets missed entirely. Ask yourself what a notch up would even look like here, and then send that one rather than the one you are used to sending."
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'flirting-calibration')
  and sort_order = 1;

update public.lessons set variants_json = $j$[
  {
    "when": { "sex": "male", "dating_interest": "women" },
    "label": "If you are a man, on the check",
    "note_md": "The check has to be readable from her side as an offer she can decline, not a question she has to answer.\n\nThe reliable form is a statement with a gap after it, in a place where she has somewhere else to be. \"I would like to keep talking to you, but I think your friends are waiting.\" That gives her both answers for free: she can take the exit or she can stay, and staying is the strongest signal available.\n\nWhat does not work is asking her directly whether she is interested. It sounds honest and it is actually the opposite of a check — it removes her ability to decline gently, which is the ability the entire technique exists to protect.",
    "partner_sex": "female"
  },
  {
    "when": { "sex": "female", "dating_interest": "men" },
    "label": "If you are a woman, on the check",
    "note_md": "Your check is usually not asking whether he is interested. That answer is rarely in doubt and it is rarely useful.\n\nThe more informative check is whether he is interested in you specifically, and the way to run it is to offer something that only matters if he has been paying attention — a reference back to something you said twenty minutes ago, an opinion he would have to disagree with. Someone who is simply enjoying being talked to by you will agree with all of it and remember none of it.\n\nThat is worth knowing early, because the cost of finding out late is measured in evenings.",
    "partner_sex": "male"
  }
]$j$::jsonb
where skill_id = (select id from public.skills where slug = 'flirting-calibration')
  and sort_order = 2;

-- Hard conversations, track 4: Staying in the room.
--
-- The topic's own promise, and the only track here with a scene in it. What
-- happens after you have said the thing depends entirely on what comes back,
-- and no authored beat can rehearse holding a position through somebody else's
-- reaction — the reaction has to be live.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'staying-in-the-room'),
  1,
  'Their reaction is not a verdict',
  $md$You said it. Something happens. And whatever happens will feel like evidence about whether you were right to say it.

It is not, and holding that distinction is most of this track.

There are about five reactions and you will recognise all of them. Defensiveness. A counter-attack about something you did in 2019. Tears. Flat silence. And *you are overreacting*, which lands hardest because it goes at the legitimacy of the whole conversation rather than at its content.

**The move:** treat the reaction as a reaction, and keep your assessment of whether you were right entirely separate from it.

The reason this needs saying is that the equation is almost automatic, and it runs in a particular direction for anybody quiet: strong reaction, therefore I have been unfair, therefore I should take it back. That inference has no basis. A person can be entirely in the wrong and extremely upset about being told, and those two facts have nothing to do with each other.

It is worth knowing what the reactions actually indicate, which is mostly that something landed. Defensiveness is what people do when they think they are about to lose something. Counter-attacks are what people reach for when they have nothing available on the actual subject. Neither is a comment on your accuracy.

There is a version worth taking seriously, and separating it out is what stops this from being a licence. If they say something specific that you had not considered — a fact you did not have, a context that changes the picture — that is information rather than a reaction, and the honest response is to take it. The test is whether it addresses the substance or the legitimacy of raising it.

If you keep one thing: upset is not the same as wronged. Somebody can be both entirely upset and entirely in the wrong, and you are allowed to hold both.$md$,
  $j$[
    {
      "situation": "They are visibly upset and you feel terrible.",
      "line": "(upset is not the same as wronged)",
      "why": "A person can be entirely in the wrong and extremely upset about being told. The two facts have nothing to do with each other."
    },
    {
      "situation": "They have brought up something you did two years ago.",
      "line": "(that is what people reach for with nothing on the subject)",
      "why": "A counter-attack is not a comment on your accuracy. It is what happens when the actual subject has no defence available."
    },
    {
      "situation": "They have told you a fact you did not have.",
      "line": "(that is information, and you should take it)",
      "why": "The test is whether it addresses the substance or the legitimacy of raising it. Substance is worth hearing."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does a strong reaction tell you?",
      "options": [
        { "text": "That it landed.", "correct": true, "note": "Defensiveness is what people do when they think they are about to lose something. It is a comment on the stakes rather than on your accuracy." },
        { "text": "That you were unfair.", "correct": false, "note": "The automatic inference, and it has no basis. People react strongly to being told true things." },
        { "text": "That you should have said it differently.", "correct": false, "note": "Sometimes true and it cannot be read off the reaction, because the same reaction follows a perfectly phrased version." },
        { "text": "Nothing at all.", "correct": false, "note": "Slightly too neat — it does tell you something about what it means to them, just nothing about whether you were right." }
      ],
      "explain": "Upset and wronged are different things, and only one of them is your business to assess."
    },
    {
      "prompt": "How do you tell a reaction from information?",
      "options": [
        { "text": "By how calmly it is said.", "correct": false, "note": "Real information frequently arrives angrily, and a very calm counter-attack is still a counter-attack." },
        { "text": "By whether it addresses the substance or your right to raise it.", "correct": true, "note": "A fact you did not have changes the picture and should be taken. You are overreacting goes at the legitimacy of the conversation instead." },
        { "text": "By whether you find it convincing.", "correct": false, "note": "You are the least reliable judge of that thirty seconds after saying something difficult." },
        { "text": "By whether it comes with an apology.", "correct": false, "note": "Apologies and information arrive independently of each other." }
      ],
      "explain": "Substance is worth hearing. Legitimacy is the thing to stay put on."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "separated", "label": "Kept the two separate", "description": "Did not read the reaction as a verdict." },
      { "key": "no_retreat", "label": "Did not retreat on upset", "description": "Held the point through a strong reaction." },
      { "key": "took_information", "label": "Took real information", "description": "Accepted a fact that changed the picture." },
      { "key": "steady", "label": "Stayed steady", "description": "Neither escalated nor collapsed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have said the thing. They have gone straight to something you did eighteen months ago.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have just raised something with",
      "personality": "Reaches for old material when there is nothing available on the actual subject, and returns to the subject if the trade is declined warmly.",
      "mood": "Stung.",
      "openness": 4
    },
    "opening_beat": "\"Right, well — you did exactly the same thing to me at Christmas, so.\"",
    "success_looks_like": "The user reads the counter-attack as a reaction rather than as a verdict.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Bring up old grievances if the user engages with them.",
      "Return to the actual subject if the user declines the trade without hostility.",
      "Never concede the original point unprompted."
    ]
  }$j$::jsonb,
  $md$Today, notice one moment where somebody's reaction made you doubt whether you were right. Log the reaction and what you actually think.$md$
),
(
  (select id from public.skills where slug = 'staying-in-the-room'),
  2,
  'Do not fill the silence',
  $md$The retraction almost never happens on purpose. It happens in a gap.

You say the thing. They go quiet. Four seconds pass, which feels like forty, and out of your mouth comes *anyway, it is not a big deal, forget I said anything* — and twenty minutes of preparation and a month of dread are undone in a single sentence that you did not decide to say.

**The move:** stop talking, and let the silence be theirs.

The silence is doing exactly what you wanted the conversation to do. Somebody has just been handed something difficult and is deciding whether it is true, remembering the instances, working out whether they agree, and choosing what to say. That is the entire point of having raised it, and it takes a few seconds. Interrupting it does not speed it up — it replaces it.

Three things get said into that gap and all of them cost you.

*It is not a big deal* — which is untrue, and now nothing needs to happen.
*Sorry, I know that is a lot* — which apologises for having said something you were right to say.
*I mean, obviously it is not just you* — which spreads the responsibility until nobody has any.

Each is a small act of kindness aimed at your own discomfort, and each takes back the thing you came to say.

Practically: decide in advance that you are going to be quiet, because you will not be able to decide it in the moment — the urge is physical rather than reasoned. Count if it helps. Look at something other than their face if that makes it easier.

And if the silence genuinely goes on past what anybody could sit with, ask rather than restate. *What are you thinking?* hands them the floor without weakening anything, and it is the only sentence that is safe to put in that gap.

If you keep one thing: the four seconds after you say it are the whole conversation. Do not spend them.$md$,
  $j$[
    {
      "situation": "You said it and they have gone quiet.",
      "line": "(the silence is doing what you wanted the conversation to do)",
      "why": "They are deciding whether it is true and remembering the instances. Interrupting does not speed that up, it replaces it."
    },
    {
      "situation": "Out of your mouth comes it is not a big deal.",
      "line": "(that is the retraction)",
      "why": "A month of dread and twenty minutes of preparation undone in one sentence, aimed at your discomfort rather than at anything they did."
    },
    {
      "situation": "It has genuinely gone on too long.",
      "line": "What are you thinking?",
      "why": "The only sentence that is safe in that gap. It hands them the floor without weakening anything."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the retraction happen?",
      "options": [
        { "text": "You realise you were wrong.", "correct": false, "note": "Almost never — the point does not change in four seconds. What changes is how uncomfortable you are." },
        { "text": "You want them to feel better.", "correct": false, "note": "That is the story it tells itself. It is aimed at your own discomfort and it costs them the conversation." },
        { "text": "They pressure you into it.", "correct": false, "note": "They have usually said nothing at all. The silence does it without anybody applying pressure." },
        { "text": "It comes out of the gap, before you decide anything.", "correct": true, "note": "The urge is physical rather than reasoned, which is why it has to be decided in advance rather than resisted in the moment." }
      ],
      "explain": "Decide in advance that you will be quiet. You cannot decide it at the time."
    },
    {
      "prompt": "What is safe to say into the gap?",
      "options": [
        { "text": "Nothing is — wait it out entirely.", "correct": false, "note": "Almost right, and at some point it becomes a standoff rather than a pause." },
        { "text": "A softer version of the point.", "correct": false, "note": "That is the dilution the previous track ends on. Softer is not safer." },
        { "text": "What are you thinking?", "correct": true, "note": "A question rather than a restatement. It hands them the floor and weakens nothing." },
        { "text": "An acknowledgement that it is hard to hear.", "correct": false, "note": "Reasonable in itself, and one step from apologising for having said it." }
      ],
      "explain": "The four seconds after you say it are the whole conversation. Do not spend them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "silent", "label": "Stayed quiet", "description": "Let the gap run." },
      { "key": "no_retraction", "label": "Did not retract", "description": "Nothing was taken back." },
      { "key": "no_apology", "label": "Did not apologise for saying it", "description": "No sorry into the silence." },
      { "key": "question", "label": "Asked, if anything", "description": "Used a question rather than a restatement." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just said it. They are looking at the floor and have not spoken. It has been about four seconds.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have just raised something with",
      "personality": "Takes a genuine ten or fifteen seconds to respond, and responds thoughtfully if given them. Seizes gratefully on any softening offered.",
      "mood": "Absorbing it.",
      "openness": 4
    },
    "opening_beat": "(silence)",
    "success_looks_like": "The user says nothing, or asks a question, rather than softening.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a long pause before your first substantive reply, and describe it plainly.",
      "Accept any softening immediately and treat the matter as closed.",
      "Respond seriously and honestly if the user holds the silence."
    ]
  }$j$::jsonb,
  $md$Today, say one difficult thing and then be silent until the other person speaks. Log how long it took.$md$
),
(
  (select id from public.skills where slug = 'staying-in-the-room'),
  3,
  'When they get upset',
  $md$They are crying, or close to it. This is the hardest thirty seconds in the topic and it is where most quiet people give the whole thing away.

The instinct is overwhelming and it feels like decency: comfort them, and take it back. *I am so sorry, I should not have brought it up, it does not matter.* And in that moment it is genuinely difficult to tell the difference between kindness and rescue — because they look identical from inside and only one of them is about them.

**The move:** be warm and unmoved at the same time.

*I know this is hard to hear, and I still think it.* Both halves in one sentence. The first is real compassion and costs nothing. The second is the thing you came to say, still standing.

That combination is unusual enough that people find it hard to imagine, and it is the whole skill: you can be entirely kind about somebody's distress without treating the distress as an argument. Comfort is free. Retraction is not.

What retracting actually does is worth being clear-eyed about, because it does not read as kindness afterwards. It tells them that upset works — that becoming distressed makes difficult things go away — which is a bad thing to teach anybody you care about, and it means the next attempt will be harder for both of you. And it leaves them with nothing to fix, which is not a kindness, it is a dead end with sympathy on top.

Practical things that help. Slow down rather than speeding up. Offer the pause — *do you want a minute?* — which is genuine care and does not concede anything. And do not touch it with more words: people fill this silence at three times the usual rate and every sentence in there is a retreat.

If they cannot continue, stopping is allowed. *Shall we come back to this tomorrow?* keeps the conversation alive rather than dissolving it, and it is completely different from *forget I said anything.* One is a pause and the other is a withdrawal.

If you keep one thing: warm and unmoved. Comfort them as much as you like, and do not take it back.$md$,
  $j$[
    {
      "situation": "They have started crying.",
      "line": "I know this is hard to hear, and I still think it.",
      "why": "Both halves in one sentence. Real compassion, and the thing you came to say still standing — which is the whole skill."
    },
    {
      "situation": "You want to give them a moment.",
      "line": "Do you want a minute?",
      "why": "Genuine care that concedes nothing. Slowing down is available; withdrawing the point is a different act entirely."
    },
    {
      "situation": "You are about to say you should not have brought it up.",
      "line": "(that teaches them upset works)",
      "why": "It makes the next attempt harder for both of you, and it leaves them nothing to fix — a dead end with sympathy on top."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the difference between comforting and retracting?",
      "options": [
        { "text": "There is not much — comfort tends to become retraction.", "correct": false, "note": "It tends to, which is a warning rather than an identity. They can be separated deliberately." },
        { "text": "Comfort is free; the point stays where it was.", "correct": true, "note": "I know this is hard to hear, and I still think it. You can be entirely kind about distress without treating it as an argument." },
        { "text": "Comfort is physical and retraction is verbal.", "correct": false, "note": "Both are usually verbal. The distinction is what happens to the substance." },
        { "text": "Retraction is what you do if you were wrong.", "correct": false, "note": "If you were wrong, saying so is not retraction — it is a correction, and it does not happen because somebody is upset." }
      ],
      "explain": "Warm and unmoved. The combination is unusual enough that people find it hard to picture."
    },
    {
      "prompt": "What does taking it back actually do?",
      "options": [
        { "text": "Spares them the difficulty.", "correct": false, "note": "It spares them the difficulty and leaves them the problem, which is not a trade anybody would choose." },
        { "text": "Ends the conversation kindly.", "correct": false, "note": "It ends it. Kindly is how it feels in the moment rather than what it does afterwards." },
        { "text": "Teaches them that upset makes things go away.", "correct": true, "note": "Which is a bad thing to teach somebody you care about, and it makes the next attempt harder for both of you." },
        { "text": "Nothing much — you can raise it again later.", "correct": false, "note": "You can, and it will be harder, because now there is a precedent for how this conversation ends." }
      ],
      "explain": "A pause is fine. Shall we come back to this tomorrow is not forget I said anything."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warm", "label": "Was genuinely warm", "description": "Acknowledged the distress properly." },
      { "key": "unmoved", "label": "Did not move the point", "description": "The substance survived the reaction." },
      { "key": "no_apology", "label": "Did not apologise for raising it", "description": "No I should not have said anything." },
      { "key": "paused_not_withdrew", "label": "Paused rather than withdrew", "description": "If it stopped, it stopped as a pause." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have said the thing. It has landed hard, and they are very close to tears.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have just raised something with",
      "personality": "Genuinely upset rather than performing it. Seizes on any withdrawal with visible relief and treats the matter as closed; steadies and engages honestly if comforted without the point moving.",
      "mood": "Overwhelmed.",
      "openness": 4
    },
    "opening_beat": "\"Sorry. Sorry — give me a second.\"",
    "success_looks_like": "The user is warm and does not take the point back.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Treat any it does not matter or I should not have said as the end of the subject, with relief.",
      "Steady yourself and engage honestly if comforted while the point still stands.",
      "Never return to the subject yourself once it has been withdrawn."
    ]
  }$j$::jsonb,
  $md$Today, comfort somebody without withdrawing what you said. Log the sentence you used to do both.$md$
),
(
  (select id from public.skills where slug = 'staying-in-the-room'),
  4,
  'When they turn it round',
  $md$*Well, you do exactly the same thing.* *What about the way you spoke to me in March?*

The counter-attack arrives fast, it is frequently at least partly true, and it presents you with a choice you have about a second to make.

Both obvious options are bad. Defending yourself accepts the trade, and thirty seconds later you are discussing March — which means your thing has been successfully swapped for theirs and will not be returned. Ignoring it entirely reads as arrogance and produces a genuine second grievance, because the thing they raised may well be real.

**The move:** acknowledge it, refuse the trade, and come back.

*That is fair, and I do want to talk about it. Can we finish this one first?* Three parts, about eight seconds, and it is the only response that keeps both subjects alive.

The acknowledgement has to be genuine rather than tactical, and people can tell the difference instantly. If what they have said is true, say so plainly — conceding a fair point costs you nothing and it removes the fuel from the counter-attack, because a counter-attack works by being unanswerable and you have just answered it.

Then hold the order. One conversation at a time is not a dodge, it is the only way either subject gets dealt with; two grievances discussed simultaneously produce a scoring match in which nobody concedes anything, because every concession becomes ammunition.

And come back to theirs. If you say you will talk about March, talk about March — that evening or that week. Somebody who used the trade and then never had to face their own point learns that the manoeuvre works, and next time it will arrive earlier.

The version worth watching for: when the counter-attack keeps coming, and every attempt to finish the first subject produces a new one. That is no longer a reaction, it is a strategy, and the honest response is to name it rather than to keep parrying — *we are not getting anywhere while both of us are doing this* is fair and true.

If you keep one thing: *that is fair, and can we finish this one first.* It concedes everything worth conceding and gives away nothing.$md$,
  $j$[
    {
      "situation": "\"You do exactly the same thing.\"",
      "line": "That is fair, and I do want to talk about it. Can we finish this one first?",
      "why": "Concedes what is true, refuses the swap, and keeps both subjects alive. About eight seconds."
    },
    {
      "situation": "You are about to defend yourself about March.",
      "line": "(that accepts the trade)",
      "why": "Thirty seconds later you are discussing March, and your subject has been swapped for theirs and will not be returned."
    },
    {
      "situation": "Every attempt to finish produces a new counter-attack.",
      "line": "We are not getting anywhere while both of us are doing this.",
      "why": "At that point it is a strategy rather than a reaction, and naming it is fairer than continuing to parry."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why not just ignore the counter-attack?",
      "options": [
        { "text": "It reads as arrogance and creates a real second grievance.", "correct": true, "note": "What they raised is often at least partly true, and refusing to acknowledge it gives them something new and legitimate to be aggrieved about." },
        { "text": "It is rude.", "correct": false, "note": "Manners are the smaller issue. It is also frequently unfair, because the point may be real." },
        { "text": "They will keep repeating it.", "correct": false, "note": "They might, and that is a symptom of the unacknowledged point rather than a separate reason." },
        { "text": "It escalates things.", "correct": false, "note": "General. The specific cost is that you have manufactured a second problem." }
      ],
      "explain": "Acknowledge it, refuse the trade, come back to it later — and actually come back."
    },
    {
      "prompt": "Why does the acknowledgement have to be genuine?",
      "options": [
        { "text": "Because lying is wrong.", "correct": false, "note": "True and not what makes this work or fail in the room." },
        { "text": "Because they will hold you to it.", "correct": false, "note": "They should hold you to it, and that is about coming back later rather than about sincerity now." },
        { "text": "Because it makes you look reasonable.", "correct": false, "note": "Appearance rather than mechanism, and aiming at it is what produces the tactical version." },
        { "text": "Because it removes the fuel.", "correct": true, "note": "A counter-attack works by being unanswerable, and conceding a fair point answers it — a tactical concession does not, and people spot the difference instantly." }
      ],
      "explain": "One conversation at a time is not a dodge. Two at once is a scoring match."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "acknowledged", "label": "Acknowledged it", "description": "Conceded what was fair, genuinely." },
      { "key": "refused_trade", "label": "Refused the trade", "description": "Did not start discussing the other subject." },
      { "key": "returned", "label": "Came back to the first", "description": "Finished what was being talked about." },
      { "key": "kept_promise", "label": "Meant the promise", "description": "Intended to actually have the other conversation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You raised the thing. They have immediately brought up something you did at Christmas, which is partly fair.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have just raised something with",
      "personality": "Keeps producing old material for as long as it is engaged with. Settles and returns to the subject when a point is conceded genuinely and the trade declined.",
      "mood": "Defensive, quick.",
      "openness": 4
    },
    "opening_beat": "\"Right, well — what about Christmas? You did exactly this to me.\"",
    "success_looks_like": "The user concedes what is fair and returns to the original subject.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Produce another old grievance whenever the user engages with the last one.",
      "Settle and return to the original subject when a point is conceded genuinely and the trade is declined.",
      "Never drop the counter-attack if it is ignored entirely."
    ]
  }$j$::jsonb,
  $md$Today, concede one fair point in an argument without letting it change the subject. Log what you conceded.$md$
),
(
  (select id from public.skills where slug = 'staying-in-the-room'),
  5,
  'Ending without agreement',
  $md$Most hard conversations do not end with somebody saying *you are right, I will change that.* People rarely concede in the room, and waiting for it is how a twenty-minute conversation becomes ninety.

**The move:** end it when it has been said and heard, not when you have won.

Said and heard is the actual target. They know the fact, they know the effect, and they know what you are asking for. That is everything the conversation could deliver, and it has been delivered whether or not anybody agreed with it.

What happens next is usually invisible to you. A very common pattern is somebody defending themselves for twenty minutes and then changing the behaviour anyway, a week later, having thought about it — and never mentioning that they did. If you are looking for the concession, you will read that conversation as a failure and be wrong about it.

So how to end. Say what you understand the position to be, including the disagreement. *So we see it differently, and you know where I am on it.* That closes the loop without pretending at an agreement that is not there — and pretending is the version that leaves both people knowing it is unfinished.

If there is an agreement, make it concrete before you leave: what changes, and by when. Warm feelings at the end of a hard conversation are pleasant and evaporate by Thursday.

And then genuinely stop. The urge to add one more point once the temperature has dropped is strong and it is always a mistake — it reopens something that had just closed, and it converts a finished conversation into one that has to be finished twice.

Afterwards, be normal. Not falsely bright, which reads as relief and slightly insulting, but ordinary. The most reassuring thing about a difficult conversation is discovering it did not change anything else, and that is demonstrated in the next hour rather than promised in the last sentence.

If you keep one thing: said and heard is the finish line. Agreement is a bonus, and it usually arrives later and in private.$md$,
  $j$[
    {
      "situation": "Twenty minutes in and they have not conceded anything.",
      "line": "(said and heard is the finish line)",
      "why": "They know the fact, the effect and the ask. That is everything the conversation could deliver, whether or not anybody agreed."
    },
    {
      "situation": "You are closing and you still disagree.",
      "line": "So we see it differently, and you know where I am on it.",
      "why": "Closes the loop without pretending at an agreement that is not there — and pretending leaves both people knowing it is unfinished."
    },
    {
      "situation": "The temperature has dropped and you think of one more thing.",
      "line": "(do not)",
      "why": "It reopens something that had just closed, and converts a finished conversation into one that has to be finished twice."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the target?",
      "options": [
        { "text": "Agreement.", "correct": false, "note": "People rarely concede in the room, and waiting for it turns twenty minutes into ninety." },
        { "text": "Said and heard.", "correct": true, "note": "They know the fact, the effect and the ask. That is everything the conversation itself can deliver." },
        { "text": "A plan.", "correct": false, "note": "Excellent when it exists and it is not always available, and holding out for it keeps you in the room past the point of use." },
        { "text": "Both of you feeling better.", "correct": false, "note": "Frequently neither of you does, immediately, and that is not evidence it went badly." }
      ],
      "explain": "A very common pattern is defending for twenty minutes and changing the behaviour a week later, unmentioned."
    },
    {
      "prompt": "What should the next hour look like?",
      "options": [
        { "text": "Give each other space.", "correct": false, "note": "Sometimes needed, and as a default it reads as the relationship having changed." },
        { "text": "Warm, to show there are no hard feelings.", "correct": false, "note": "Falsely bright reads as relief, which is slightly insulting after somebody has been asked to take something seriously." },
        { "text": "Ordinary.", "correct": true, "note": "The most reassuring thing about a difficult conversation is discovering it changed nothing else, and that is demonstrated rather than promised." },
        { "text": "A follow-up conversation to check they are all right.", "correct": false, "note": "It reopens it, and it asks them to reassure you about how they took it." }
      ],
      "explain": "And do not add one more point once it has closed."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ended", "label": "Ended it deliberately", "description": "Stopped when it had been said and heard." },
      { "key": "named_position", "label": "Named where you both stood", "description": "Closed the loop including the disagreement." },
      { "key": "concrete", "label": "Made any agreement concrete", "description": "What changes and by when." },
      { "key": "normal_after", "label": "Was ordinary afterwards", "description": "Neither distant nor falsely bright." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Twenty-five minutes in. It has been said, they have heard it, and they have not agreed with any of it.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have been having a difficult conversation with",
      "personality": "Will keep going indefinitely without conceding, and takes a clean close well. Thinks about it properly afterwards, which the user will not see.",
      "mood": "Tired, not hostile.",
      "openness": 4
    },
    "opening_beat": "\"I still do not think it is as big a thing as you are making it.\"",
    "success_looks_like": "The user closes the conversation without requiring agreement.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never concede the point, however long the conversation goes on.",
      "Respond well and warmly to a clean close that names the disagreement.",
      "Never end the conversation yourself."
    ]
  }$j$::jsonb,
  $md$Today, end one unresolved conversation deliberately, naming where you both stand. Log how you closed it.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('staying-in-the-room', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You said the thing. They are visibly upset and have gone very quiet.",
      "prompt": "What does that tell you about whether you were right?",
      "options": [
        { "text": "That you went too far.", "correct": false, "note": "The automatic inference, and it has no basis. People react strongly to being told true things." },
        { "text": "Nothing about that at all.", "correct": true, "note": "Upset and wronged are different. Somebody can be entirely in the wrong and entirely distressed about being told, and the two facts are unrelated." },
        { "text": "That you should have phrased it better.", "correct": false, "note": "You might have, and it cannot be read off the reaction — the same reaction follows a perfectly phrased version." },
        { "text": "That it was not worth raising.", "correct": false, "note": "A strong reaction usually means the opposite: something landed, and it mattered." }
      ]
    },
    {
      "situation": "Instead they say: \"Actually, I cancelled in March because my mother was in hospital and I did not want to get into it.\"",
      "prompt": "What is that?",
      "options": [
        { "text": "A counter-attack in softer clothes.", "correct": false, "note": "Nothing in it is aimed at you. It addresses the substance directly." },
        { "text": "An excuse for one instance.", "correct": false, "note": "It may only cover one instance, and covering one instance honestly is exactly what information does." },
        { "text": "Information, and you should take it.", "correct": true, "note": "It addresses the substance rather than your right to raise it, and it is a fact you did not have. The honest response is to take it." },
        { "text": "A reason to drop the whole thing.", "correct": false, "note": "It changes one instance rather than the pattern. Take it, adjust, and carry on with the rest." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('staying-in-the-room', 2, 'line', $j${
  "says": "(silence — they are looking at the floor and have not spoken for about ten seconds)",
  "model": {
    "line": "What are you thinking?",
    "why": "The only sentence that is safe in that gap: a question rather than a restatement, which hands them the floor and weakens nothing. Everything else offered into a silence is a retreat."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Nothing that takes it back",
      "words": ["not a big deal", "forget it", "sorry", "it does not matter", "i know that is a lot", "maybe i am", "probably overreacting", "just ignore", "not just you"] },
    { "kind": "max_words", "requirement": "Do not fill it with words", "n": 15 },
    { "kind": "max_sentences", "requirement": "One sentence at most", "n": 1 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('staying-in-the-room', 3, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('staying-in-the-room', 4, 'line', $j${
  "says": "Right, well — what about Christmas? You did exactly this to me.",
  "model": {
    "line": "That is fair, and I do want to talk about it. Can we finish this one first?",
    "why": "Concedes what is true, which removes the fuel from a counter-attack, and declines the swap without ignoring it. Three parts, about eight seconds, and both subjects stay alive."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Acknowledge what is fair in it",
      "words": ["fair", "true", "you are right", "i did", "guilty", "hands up", "yes"] },
    { "kind": "forbids_any", "requirement": "Do not defend yourself about it",
      "words": ["that was different", "not the same", "because you", "only because", "if you had not", "that is not what happened"] },
    { "kind": "requires_question", "requirement": "Ask to come back to it" },
    { "kind": "max_words", "requirement": "Eight seconds, not a negotiation", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('staying-in-the-room', 5, 'line', $j${
  "says": "I still do not think it is as big a thing as you are making it.",
  "model": {
    "line": "Alright — we see it differently, and you know where I am on it. Let us leave it there.",
    "why": "Closes the loop including the disagreement, which is honest, rather than manufacturing an agreement that would leave both of you knowing it was unfinished. Said and heard was the finish line."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not manufacture agreement and do not reopen it",
      "words": ["you are probably right", "maybe i am overreacting", "forget it", "one more thing", "and another", "does not matter", "i take it back"] },
    { "kind": "min_words", "requirement": "Name where you both stand", "n": 10 },
    { "kind": "max_words", "requirement": "Close it, do not restate it", "n": 35 }
  ]
}$j$::jsonb);

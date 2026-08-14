-- The printable page for Storytelling & speaking. Five tracks, three each.

update public.topics set cheatsheet_json = $j${
  "idea": "You finish, there is a small pause, and somebody says oh, right. The material was fine — almost nobody has a story problem, they have a structure problem, and structure is the most learnable thing in this app. Four decisions before you speak cover most of it: why you are telling it, where to start, what turns, and the last line. And the half people skip is the belief underneath: ninety seconds of a table's attention is not something you are taking from anybody. A room where nobody will tell a story is not relaxed, it is flat, and everybody in it can feel that without being able to name it.",
  "groups": [
    {
      "skill": "why-stories-die",
      "concepts": [
        {
          "name": "The material was fine",
          "body": "The same events in somebody else's mouth would have worked. Blaming your life points at a fix that does not exist; the telling is six decisions."
        },
        {
          "name": "Say why you are telling it",
          "body": "The reason is in your head and nowhere else. One line at the front — the most ridiculous thing happened at the garage — gives away nothing."
        },
        {
          "name": "Start late, and say nothing before it",
          "body": "Stories die in the setup. Cut the drive, the day, and who suggested it — and never say this is not that interesting before you begin."
        }
      ]
    },
    {
      "skill": "the-shape",
      "concepts": [
        {
          "name": "Something has to turn",
          "body": "A story is a change rather than a sequence. Cut anything that is neither setting the turn up nor paying it off — that test alone removes most of the length."
        },
        {
          "name": "End on the line",
          "body": "No explanation, no it was funnier at the time, no tidy return to the start. The silence after is a beat, and the beat is where it lands."
        },
        {
          "name": "One story, approximately true",
          "body": "No nesting and no third name mid-flight. And only load-bearing details need to be exact — say Tuesday, be wrong, carry on."
        }
      ]
    },
    {
      "skill": "telling-it",
      "concepts": [
        {
          "name": "Present tense, actual words",
          "body": "So I am standing in the doorway, and he turns round. Then quote people rather than summarising them — it needs no wit, because the line already exists."
        },
        {
          "name": "One detail that does work",
          "body": "He was holding a sandwich the entire time. Specific, odd, and connected to the moment — one certifies the story, and the second adds nothing."
        },
        {
          "name": "Know the last line",
          "body": "Decide it before you begin and steer towards it. Without it you arrive near the end, feel it thinning, and produce so, yeah — anyway."
        }
      ]
    },
    {
      "skill": "holding-the-floor",
      "concepts": [
        {
          "name": "Nobody resents a good story",
          "body": "The imposition is quality, not length. The strain you feel while telling one is almost always your own rather than the room's."
        },
        {
          "name": "Ninety seconds in a group",
          "body": "Watch for listening turning into waiting — an early nod, a glance sideways. That is about time, and the answer is to get to the end, not to speed up."
        },
        {
          "name": "Land a dying one and move on",
          "body": "Skip to the turn, say the last line, stop. Nobody knows what you cut. What people remember is the apology, not the flat ending."
        }
      ]
    },
    {
      "skill": "no-warning",
      "concepts": [
        {
          "name": "One thing, one example, one close",
          "body": "Three sentences is a speech, and three slots is few enough to hold under adrenaline. The example is the part people repeat."
        },
        {
          "name": "Name, specific, meaning, glass",
          "body": "The toast is the easy one because the glass ends it for you. Fifteen seconds, one specific, and never a list."
        },
        {
          "name": "First and last by heart",
          "body": "A known opening buys the fifteen seconds where nerves are worst; a known close is an exit visible from anywhere. And nobody can see the nerves."
        }
      ]
    }
  ]
}$j$::jsonb
where slug = 'storytelling';

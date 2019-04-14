@style (spacing 1)
@title [SEASTALKER(tm) MANUAL]
@center [MANUAL FOR SEASTALKER(tm)]
@center (Comments to Stu Galley)

@chapter (INTRODUCTION)

Welcome to the world of Infocom interactive fiction -- a world where:
@begin (itemize)
you become the hero or heroine in a story,

you can use your own thinking and
imagination to guide that story from start to finish,

you can meet other people, who may help you or not, and

you can go to new places, figure out mysteries and puzzles,
and fight against monsters or enemies.
@end (itemize)

In SEASTALKER, you become a young inventor working in your father's
business. Your newest invention is a small submarine that has only two seats
inside, for you and your pal Tip. The submarine can dive deeply into
the sea to capture plants and animals for you to study. But you will
have to use it to save your undersea scientific station from a sea monster
that is attacking it!

@heading (RULES AND STRATEGIES)

When you play SEASTALKER, the story goes on only from the time you hit
the RETURN (or ENTER) key until you see the prompt ">". You could
imagine a clock that ticks once for each sentence you type, and the
story continues only at each tick. Nothing happens in the story from the
time you see the prompt ">" until you hit the RETURN (or ENTER) key. You
can think and plan your moves as slowly and carefully as you want.

SEASTALKER keeps track of your score and gives you points when it
thinks you have done something "right." You can try to get a perfect
score if you want, but you should also try to guide the story to an
ending that you like and to have fun along the way.

One
way to move from place to place in the story is to type "GO TO [a place]"
-- that means to type the words "GO TO" and then the name of the place
where you want to go. You can find the names of places by looking at the
maps in your SEASTALKER package.

If you don't want to miss anything on the way to another place, you can
go toward it one place at a time, by typing the compass direction in
which you want to go each turn. The main compass directions are "NORTH",
"EAST", "SOUTH", and "WEST", and the ones in between are "NORTHEAST",
"SOUTHEAST", "SOUTHWEST", and "NORTHWEST." Most players like to type
these shorter words instead: "N", "E", "S", "W", "NE", "SE", "SW", and
"NW." Sometimes you can use "UP" or "DOWN" ("U" or "D" for short) or
"IN" or "OUT."

Whenever you go into a place, SEASTALKER tells you the name of the place.
It displays the name of the place, in parentheses, like "(lab center)".
As you explore the different places in SEASTALKER, you should read
carefully what the program displays and get to know the places you
visit. You don't need to walk around or turn around within a place;
anything you can see there is always within your reach, unless you are sitting
or lying down or hiding.

When you enter a place for the first time, SEASTALKER normally displays
the name of the place and all about what you can see there. When you
return to that place again, SEASTALKER normally displays only the name
of the place and the names of interesting things there.

If you want
SEASTALKER to display all about a place every time you go there, not
just the first time, type the command "VERBOSE" instead of a sentence.
If you want SEASTALKER to go back to normal, type the command "BRIEF"
instead of a sentence. If you want SEASTALKER to display only the name
of a place and not to tell you what's there, even the very first time
you go there, type the command "SUPERBRIEF" instead of a sentence.
SUPERBRIEF mode is really only for players who already know
their way around the story. (When
you are in SUPERBRIEF mode, you can still type "LOOK" or "L", and
SEASTALKER will describe the place you are in and the things there.)

@heading (CONCEPTS FOR EXPLORING)

One main idea of interactive fiction is to solve puzzles.
You should think of a locked door or an
unfriendly creature in the story not as an obstacle but as a
puzzle that you need to solve. Sometimes the best way to solve a puzzle is to
find something that appears in the story, take
it with you, and then use it in the right way. Here are some ways
that things in the story behave:

@U(Containers):  Some things are containers that can hold other
things. You can open or close some containers, like a box. Other
containers are always open, like a bowl. Other containers are
transparent, like a glass box, and you can see inside them even when
they are closed. Other things have a surface, like a table, and you can
put things on them. All containers can hold a certain amount and no
more, like a small box. Some things are big, and some are little.

Here is an example to show how a container works:

@begin (example)

>OPEN THE TINY BOX
Opening the tiny box reveals an ID amulet.

>PUT THE DIARY IN THE TINY BOX
There's no room.

>TAKE THE AMULET
You are now holding the ID amulet.

>LOOK IN THE BOX
It's empty.

@end (example)

@U(People): You can talk to the other people in SEASTALKER. (For
details, see the section later in this manual called "Typing to
SEASTALKER.") Most other people will be glad to help you by doing what
you tell them to. Some other people may be unfriendly or too busy to
help, or they may think that you are an enemy.

Here is an example of dealing with a person:

@begin (example)
Tip is standing here, chewing his gum.

>TIP, FOLLOW ME
"I'm already following you."

>SOUTH
(south tank area)
Tip follows you into the south tank area.

>ASK TIP ABOUT THE PROBLEM
Tip says, "I don't know anything about it."
@end (example)

@heading (LOADING "SEASTALKER")

Now that you know something about the world of interactive fiction, it's
time to try "booting" your diskette in order to load the program. To
load SEASTALKER, follow the instructions on the Reference Card in your
SEASTALKER package.

First the program will ask you for your first and last name, so it can
use them in the story. Then it will display the title of the story,
followed by the first bit of action and a description of the
place where the story begins. Finally, the prompt ">" will appear. When
you have finished reading this manual, you will be ready to play SEASTALKER.

When you see the prompt ">", SEASTALKER is waiting for you to type in
your instructions. When you have finished that, press the RETURN (or
ENTER) key. The program will respond, and another prompt will appear.

Here is a quick exercise to help you get used to SEASTALKER. After you
read the beginning of the story, type this sentence after the prompt
">":

@begin (example)
GO EAST
@end (example)

and then press the RETURN (or ENTER) key. SEASTALKER will respond
by describing the place that you went:

@begin (example)
(east part)
You're in the east part of your laboratory. A doorway leads out through
a corridor to the office of your lab assistant. A Microwave Security
Scanner stands against the wall. An intercom sits on the lab desk.
Tip is off to the west.
@end (example)

Now try typing:

@begin (example)
TURN ON THE SCANNER
@end (example)

After you press the RETURN (or ENTER) key, the program will respond:

@begin (example)
No beep occurs. Scanner displays: NO INTRUDER PRESENT ON GROUNDS.
@end (example)

You can explore the area around the lab, if you want; there's a map
in your SEASTALKER package to help you. But soon, events in the story may make
you want to get involved in it. You should read the rest of this manual first.
@heading (TYPING TO "SEASTALKER")

When you play interactive fiction from Infocom,
you type your sentences in plain
English each time you see the prompt ">". You can pretend that all your
sentences begin with "I want to...", but you should not actually type
those words. You can use words like "THE" if you want, and you can use
capital letters if you want; the program doesn't care either way.

When you have finished typing a sentence, press the RETURN (or ENTER)
key. Then the program will respond, telling you if what you want to do
is possible at this point in the story, and what happens next.

SEASTALKER looks only at the first six letters of each long word you
type, and it ignores any letters after that. So, the words "ELECTRic"
and "ELECTRonic" would look like the same word to SEASTALKER.

SEASTALKER understands many different kinds of sentences. Here are
some examples, using things or situations that may not actually occur in
the story:

@begin (example)
	TAKE THE MIKE
	PUT ON THE AMULET
	PICK UP THE CATALYST CAPSULE
	DROP IT
	GO OUT
	DROP THE MIKE ONTO THE WORKBENCH
	WALK NORTH
	WEST
	SW
	GET IN THE SUBMARINE
	PUSH THE JOYSTICK EAST
	EXAMINE THE DEPTH FINDER
	SHOOT THE MONSTER WITH THE DART
	LOOK AT THE SONARSCOPE
	LOOK UNDER THE WORKBENCH
	LOOK BEHIND THE COMPUTESTOR
	AIM SEARCH BEAM TO STARBOARD
	QUESTION TIP
@end (example)

You can use more than one noun for a "direct object" or
"indirect object" with some verbs, if you
separate the nouns by the word "AND" or by a comma.
For example:

@begin (example)
	DROP THE MIKE AND THE NOTEBOOK
	TAKE BLACK BOX, OXYGEN GEAR, AND UNIVERSAL TOOL
	PUT THE DIARY AND THE PHOTO IN THE LOCKER
@end (example)

You can put more than one sentence on one input line, if you separate
them by the word "THEN" or by a period. You don't need a
period at the end of an input line. For example, you
could type all these sentences on one input line, before pressing the
RETURN (or ENTER) key:

@begin (example)
	READ THE SIGN. OPEN THE HATCH. GO THROUGH IT.
@end (example)

You will meet other people as you play
SEASTALKER. You can "talk" to these people by typing their name,
then a comma, then whatever you want them to do. For example:

@begin (example)
	TIP, FOLLOW ME
	ZOE, KILL THE MONSTER
	MICK, GO TO THE AIRLOCK THEN FIX THE SUBMARINE
	AMY, WAIT HERE
@end (example)

If you forget to type the person's name first, SEASTALKER will sometimes
assume that you meant to talk to the same person again, or to the only
other person in the same place with you. When it does this, it will tell
you. For example:

@begin (example)
>ASK ABOUT THE MONSTER
(said to Tip)
"You know as much about it as I do."
@end (example)

SEASTALKER tries to guess what you really mean if you don't give
enough information. For example, if you type that you want to do
something, but not what to do it with, SEASTALKER may
decide that there was only one possible thing you could have meant.
When it does this, it will tell you. For example:

@begin (example)

>UNLOCK THE DOOR
(with the key)
The door is now unlocked.

>GET OUT
(out of the Ultramarine Bioceptor)

@end (example)

If you try to use something that you need to be holding, but you forgot
to pick it up first, SEASTALKER will pick it up for you. For example:

@begin (example)
>LOOK
You are in the library. There is a book here.

>READ THE BOOK
(taken)
The book is far too long to read it all now.

>INVENTORY
You are carrying:
   a book
@end (example)

If SEASTALKER thinks that your sentence could have more than one
meaning, it will ask what you really meant.
You can answer it by typing just the missing
information; you don't have to type the whole sentence again. For example:

@begin (example)
>PUT THE RELAY
What do you want to put the relay in?
>THE EMPTY SPACE
It fits!

>OPEN THE HATCH
Which hatch do you mean, the entry hatch or the access hatch?
>ENTRY
O.K.
@end (example)

SEASTALKER uses many words that it will not recognize in your
sentences. For example, you might see "Sunlight shimmers across the
dusty cobwebs." in the description of a place. However, if the program
doesn't recognize the words "SUNLIGHT" or "COBWEBS" in your sentence,
then you know that you don't need the sunlight and cobwebs to finish the
story; they are in the description only to make the story more
interesting. SEASTALKER recognizes nearly all the words that you are
likely to type, over 900 of them. If SEASTALKER doesn't know a word
that you want to use, or any word that means the same thing, you are almost
certainly trying the wrong way to solve a puzzle.

SEASTALKER will complain to you if you type a sentence that confuses
it completely. (The end of this manual has an explanation of these
complaints.) After it complains, SEASTALKER will ignore the rest of
your input line. SEASTALKER will also ignore the rest of the sentences
you typed on one line if something really important happens in the
story, since you may want to change your mind about what to do next.

@heading (TIPS FOR NEW PLAYERS)

Many things that you discover in the story are important, because they
give you clues about the puzzles you must solve. You should examine or
read everything that seems important to you. Even silly or dangerous
actions may give you clues; they can even be fun. Besides, you can
always start the story over again, or you can save your place first.
(There is a section later in this manual about starting over and saving
your place.) Here's a silly example:

@begin (example)
>GIVE THE MAGIC GERANIUM TO THE MONSTER
For a moment, the monster thinks about eating the geranium instead
of you. But then it decides not to, and it comes closer and closer to you.
@end (example)

Here you have learned something about what the monster does not
like to eat, and you have a clue that giving something else (maybe that
yellow "goo" you are carrying?) to it would work better.

There are many possible ways to get to the end of
SEASTALKER. Some puzzles that you find along the way may have more
than one solution, and you may not need to solve others at all. Sometimes
solving a puzzle one way will make it harder to solve another,
and sometimes it will make it easier.

Many people like
to play SEASTALKER with another person. One person may find a
puzzle hard while another may find it easy, so two or more players often
can have more fun than one player alone.

You can use the maps that came with your SEASTALKER package
to help you move from place to place.
Remember that there are eight compass directions, not counting "IN" and "OUT".

If you get stuck, you can order a booklet of hints from
Infocom by filling out and mailing in the "Bilk and Wheedle" flyer in your
SEASTALKER package.

If you read the sample transcript in the next section, you should get a
feeling for how to play interactive fiction.

@heading (SAMPLE STORY TRANSCRIPT)

This transcript is not from SEASTALKER, but it does show most of
the usual things that you can do while playing. It shows
several simple puzzles and their solutions, and it should give the
new player a good idea of how interactive fiction works.

@begin (example)
[to be supplied]
@end (example)

@heading (SAVING, RESTORING, RESTARTING, AND QUITTING)

If you want to stop playing, and you don't care about saving your
place for another time, type the command "QUIT." Just to be sure,
SEASTALKER will ask you if you really want to leave the story, and you
should type "YES."

If you want to start over from the beginning of the story, type the
command "RESTART." Once again, SEASTALKER will ask to make sure that
this is really what you want to do.

If you want to stop playing for now, but continue from this same place
at another time, type the command "SAVE." Since it takes many hours to
finish SEASTALKER, you will probably not finish it in one sitting. By
using the "SAVE" command, you can continue playing at a later time
without having to start over from the beginning, just as you can put a
bookmark in a book you are reading. The "SAVE" command makes a
"snapshot" of your place in the story on another diskette. If you are a
cautious or careful player, you may want to save your place before you
try something dangerous or tricky. Then you can return to the same
place, even if you have gotten "killed" or lost since then.

To save your place in the story, just type "SAVE"
after the prompt ">" and then follow the instructions on your
Reference Card. Remember that most computers need a diskette for storage
that has been initialized
("formatted") before you start the story. Remember also
that you may not be able to use that diskette for anything else.

To continue playing from any place where you used the "SAVE" command,
just type "RESTORE" after the prompt ">" and follow the instructions on
your Reference Card. Then you can continue playing from the place where
you used the "SAVE" command. You can type "LOOK" to get a description of
where you are. You can use "RESTORE" on any "snapshot" you have made
whenever you want.

@heading (IMPORTANT COMMANDS)

You can type a command to SEASTALKER instead of a sentence. Some
commands give you information and others let you start or stop the
story. Some of these commands were also explained earlier in this
manual. You can use these commands again and again, as you wish. Some
commands count as a turn, and the story will go on, while others do not.

"BRIEF" commands SEASTALKER to
display all about a place or thing only the first time you see it.
This is the way it works when the story begins.

"DIAGNOSE" commands SEASTALKER to give you a brief report about your medical
condition.

"INVENTORY" or "I" commands SEASTALKER to display a list of all the
things that you are carrying.

"LOOK" or "L" commands SEASTALKER to describe the place you are in.

"QUIT" or "Q" allows you to quit playing. If you want to quit for now,
but continue from this same place at another time, use the "SAVE" command.

"RESTART" stops the story and starts over from the beginning.

"RESTORE" lets you continue playing from any place where you used the
"SAVE" command.

"REVISION" tells you the Revision number and the Serial number of
your copy of SEASTALKER.

"SAVE" lets you stop playing for now, but continue from this same place
at another time, by making a "snapshot" on your storage diskette.

"SCORE" tells your current score and a rank based on it.

"SCRIPT" commands your printer to start making a transcript of the story
as you play. Your Reference Card tells if you can use this feature.

"SUPERBRIEF" commands SEASTALKER to
display only the name of a place, even the first time you see it.

"UNSCRIPT" commands your printer to stop making a transcript.

"VERBOSE" commands SEASTALKER to
display all about a place or thing every time you see it.

"WAIT" or "Z" causes time in the story to pass. Normally, between your
input lines, nothing happens in the story. You could leave the computer,
travel around the world underwater for a year, and return to the story
to find that nothing has changed. You can use the "WAIT" command to make
time pass in the story without doing anything, if you are waiting for a
person to arrive, waiting for something to happen, and so on.

@heading (USEFUL VERBS)

Here is a list of some of the verbs that SEASTALKER
understands. Remember that you can use prepositions with these verbs;
for example, "LOOK" can become "LOOK INSIDE", "LOOK
BEHIND", "LOOK UNDER", "LOOK THROUGH", "LOOK AT", and so on.

@begin (example)

ASK	ATTACK	BOARD	BURN
CLIMB	CLOSE	COUNT	CROSS
CUT	DESTROY	DIG	DISEMBARK
DRINK	DROP	EAT	ENTER
EXAMINE	EXIT	EXTINGUISH	FILL
FIND	FLY	FOLLOW	GIVE
HELLO	JUMP	KICK	KILL
KISS	KNOCK	LAUNCH	LIE
LIGHT	LISTEN	LOCK	LOOK
LOWER	MOVE	OPEN	POINT
POUR	PULL	PUSH	PUT
RAISE	REACH	READ	SEARCH
SHAKE	SHOOT	SHOW	SLEEP
SLIDE	SMELL	SPRAY	STAND
SWIM	TAKE	TELL	THROW
TIE	TOUCH	TURN	UNLOCK
UNTIE	WAKE	WALK	WAVE

@end (example)

@heading ("SEASTALKER" COMPLAINTS)

SEASTALKER will complain to you if you type a sentence that confuses
it completely. Here is a list of some of these complaints:

I DON'T KNOW THE WORD "[your word]".@*
The word you typed is not in the
program's list of words. Sometimes you can use another word that means
the same thing. If not, SEASTALKER probably can't understand what
you're trying to do.

YOU CAN'T USE THE WORD "[your word]" IN THAT WAY.@*
The program knows the word you
typed, but it couldn't understand the word in the way that you used it,
usually because the program knows the word as a different part of
speech. For example, if you typed "PRESS THE LOWER BUTTON", you used
"LOWER" as an adjective, but the program might recognize it only as a
verb, as in "LOWER THE BOOM."

I COULDN'T FIND A VERB IN THAT SENTENCE!@*
Unless you are answering a
question, each sentence must have a verb (or a command) in it somewhere.

I COULDN'T FIND ENOUGH NOUNS IN THAT SENTENCE!@*
SEASTALKER expected
a noun and couldn't find one. This usually means that your sentence was
not complete, such as "PUT THE LAMP IN THE."

I FOUND TOO MANY NOUNS IN THAT SENTENCE!@*
A valid SEASTALKER sentence
has no more than two "objects." They are called the "direct object" and
the "indirect object."
For example, there are too many objects in
"PUT THE SOUP IN THE BOWL WITH THE SPOON."

BE SPECIFIC: WHAT THING DO YOU WANT TO [your verb]?@*
You used the word "HIM" or "HER" or "IT", but SEASTALKER didn't know
what you meant. You should answer by typing the name of the person or
thing you meant.

I BEG YOUR PARDON?@*
SEASTALKER thinks that you didn't type anything
after the prompt ">" and before hitting the RETURN (or ENTER) key.

YOU CAN'T SEE ANY [thing] HERE!@*
The thing in your sentence was not
visible. It might be somewhere else, inside a container, and so on.

THE OTHER THING(S) THAT YOU MENTIONED ISN'T (AREN'T) HERE.@*
You
used two or more nouns in the same sentence, and at least one of them
wasn't visible.

YOU CAN'T GO THAT WAY.@*
There was no way to go in the direction you tried.

YOU CAN'T USE MULTIPLE (IN)DIRECT OBJECTS WITH "[your verb]".@*
You can
use more than one "object" only with certain verbs, like "TAKE", "DROP",
and "PUT". (This means nouns or noun phrases separated by the word "AND"
or a comma.)  You can't use more than one object with most verbs, like
"ATTACK", so you can't "ATTACK THE MONSTER AND THE ENEMY."

I ASSUME YOU MEAN THE [thing].@*
You typed a word that the program knows as an adjective, like "BLUE,"
without a noun, but it knew what you meant anyway. It's just telling you what noun it
thinks you meant.

USE FIGURES FOR NUMBERS, FOR EXAMPLE "10."@*
The program found a number word in your sentence, like "TEN," but it
understands only figures, like "10."

PLEASE USE UNITS WITH NUMBERS.@*
The program found a number in your sentence without any units to tell
what the number means. Use a word after the number like "METERS" or "TURNS".

SORRY, BUT I DON'T UNDERSTAND. PLEASE REWORD THAT OR TRY
SOMETHING ELSE.@*
The program thought your sentence was
nonsense, such as "GIVE HIM WITH TOOL." Or it didn't understand the
syntax of your sentence, such as "SMELL UNDER THE ROCK." Try typing the
sentence in a different way.

@heading (SENTENCE SYNTAX)

A valid SEASTALKER sentence should start with a verb or a command (such
as "SCORE").

If you use multiple nouns for one "object", you must separate them by
the word "AND" or by a comma.

If you type several sentences on one input line, you must separate them
by a period or by the word "THEN". You don't need a period at the end of
an input line.

The short way to type compass directions is "N", "E", "S", "W", "NE", "SE", "SW", and "NW."
The short way to type "UP" and "DOWN" is "U" and "D."

Other short words include "L" for "LOOK", "I" for "INVENTORY",
and "Z" for "WAIT."

@heading (COMMAND SUMMARY)

You can type these commands when the prompt ">" has appeared
on the screen. For an explanation of these commands, see the section
called "Important Commands" earlier in this manual.

@begin (example)
	BRIEF
	DIAGNOSE
	INVENTORY (or I)
	LOOK (or L)
	QUIT (or Q)
	RELEASE
	RESTART
	RESTORE
	SAVE
	SCORE
	SCRIPT
	SUPERBRIEF
	UNSCRIPT
	VERBOSE
	WAIT
@end (example)

@heading (WE'RE NEVER SATISFIED)

Here at the Cambridge chapter of the Young Adventure Story Writers
Club, we take great pride in the quality of our work. Even after
our stories are in your hands, we still want to make them better.

Your comments are important. No matter how much testing we do, it seems that
there are "bugs" that never crawl into view until thousands of you
begin typing all those millions of sentences into the program. If you find a
"bug", or if you think the program should recognize your favorite word
or sentence, or if you found a certain puzzle too hard or too
easy, or if you'd just like to tell us what you thought of the story, then
write to us! We love an excuse to stop working and fool around for a
while, and a letter from you would be just such an excuse! Write to:

@begin (example)

Infocom, Inc.
Department J
55 Wheeler street
Cambridge, Mass. 02138

@end (example)

You can call the Infocom Technical Support Team to report "bugs" and
technical problems at (617) 576-3190. If your diskette fails within 90
days after purchase, we will replace it free of charge. Otherwise, we
will replace it for a fee of $5.00. Please mail us your registration
card if you'd like to be on our mailing list and receive our newsletter.

@heading (OPERATING CONTROLS)

If the Ultramarine Bioceptor (UB) operated like a real submarine, you
would need a long training period just to learn how to operate it before
you could enjoy playing this story!

Instead of travelling in a straight line in any direction you want, the
UB moves from square to square like a chess queen. The UB's squares are
rather large, 500 meters on a side.
And since the UB is a submarine that can go down and up under water
("DIVE" and "SURFACE"), it uses a grid of squares for each depth. To keep
it simple, the UB goes up or down only in steps of 5 meters,
and it goes only one step up or down for each square that it
moves side-to-side.

You can pilot the UB using its four controls:
@begin (itemize)

The THROTTLE controls how fast the UB travels. You can set it to one of
several different speeds, corresponding to moving a certain number of
squares per turn: (0) standing still, (1) slow, (2) cruise,
or (3) high speed.

The FORWARD/REVERSE LEVER controls whether the UB moves forward or
backward. You can switch from one to the other only when the UB is
standing still. If you enter the Aquadome going forward, you have to
back out, and vice versa.

The JOYSTICK
turns the UB to face one of the compass directions:
north, northeast, east, southeast, south, southwest, west, or northwest.
(If you have a joystick on your computer, and if it's the right kind of
computer, then you can use your joystick instead of the UB's!)

The DEPTH CONTROL directs the UB's automatic guidance system to keep
a certain depth below the surface of the water. You can set it to any
multiple of 5 meters within the sub's operating range. When you set
it to a new target depth, the UB automatically adjusts its buoyancy and
diving planes so it will approach the target depth. It will change depth
by 5 meters each time it moves one square horizontally. If the
throttle is set to "standing still," so that the UB isn't moving
horizontally, then it will go straight up or straight down, 5
meters per turn.
When it
reaches target depth, it will automatically level out and stay at that
depth, assuming that it doesn't run into anything.

The AUTO PILOT can handle all these controls automatically, except
the throttle.
@end (itemize)

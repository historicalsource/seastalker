

	.FUNCT	THORPE-SHOOT?,X,Y
	ZERO?	SNARK-TRANKED /?ELS5
	CALL	FORWARD-OF-THORPE?,X,Y
	RSTACK	
?ELS5:	CALL	STARBOARD-OF-THORPE?,X,Y
	ZERO?	STACK /FALSE
	CALL	FORWARD-OF-THORPE?,X,Y
	RSTACK	


	.FUNCT	STARBOARD-OF-THORPE?,X,Y,?TMP1
	SUB	X,THORPE-LON
	MUL	THORPE-HLAT,STACK >?TMP1
	SUB	Y,THORPE-LAT
	MUL	THORPE-HLON,STACK
	SUB	?TMP1,STACK
	GRTR?	0,STACK /FALSE
	RTRUE	


	.FUNCT	FORWARD-OF-THORPE?,X,Y,?TMP1
	SUB	X,THORPE-LON
	MUL	THORPE-HLON,STACK >?TMP1
	SUB	THORPE-LAT,Y
	MUL	THORPE-HLAT,STACK
	SUB	?TMP1,STACK
	GRTR?	0,STACK /FALSE
	RTRUE	


	.FUNCT	THORPE-POS?,LON,LAT
	EQUAL?	SUB-DEPTH,AIRLOCK-DEPTH \FALSE
	SUB	THORPE-LAT,THORPE-HLAT
	EQUAL?	LAT,STACK \?ELS7
	SUB	THORPE-LON,THORPE-HLON
	EQUAL?	LON,STACK /TRUE
?ELS7:	EQUAL?	LAT,THORPE-LAT \FALSE
	EQUAL?	LON,THORPE-LON /TRUE
	RFALSE


	.FUNCT	SNARK-POS?,LON,LAT,?ORTMP
	CALL	SNARK-HEAD-POS?,LON,LAT
	POP	'?ORTMP
	ZERO?	?ORTMP /?ORP4
	RETURN	?ORTMP
?ORP4:	CALL	SNARK-TAIL-POS?,LON,LAT
	RSTACK	


	.FUNCT	SNARK-HEAD-POS?,LON,LAT
	EQUAL?	SUB-DEPTH,AIRLOCK-DEPTH \FALSE
	EQUAL?	LAT,SNARK-LAT \FALSE
	EQUAL?	LON,SNARK-LON /TRUE
	RFALSE


	.FUNCT	SNARK-TAIL-POS?,LON,LAT,X,Y,HLON,HLAT
	EQUAL?	SUB-DEPTH,AIRLOCK-DEPTH \FALSE
	ZERO?	SNARK-TRANKED /?ELS5
	SET	'HLON,SNARK-HLON
	SET	'HLAT,SNARK-HLAT
	JUMP	?CND1
?ELS5:	SET	'HLON,THORPE-HLON
	SET	'HLAT,THORPE-HLAT
?CND1:	SUB	SNARK-LON,HLON >X
	SUB	SNARK-LAT,HLAT >Y
	EQUAL?	LAT,Y \?CND9
	EQUAL?	LON,X /TRUE
?CND9:	SUB	X,HLON >X
	SUB	Y,HLAT >Y
	EQUAL?	LAT,Y \?CND14
	EQUAL?	LON,X /TRUE
?CND14:	SUB	Y,HLAT
	EQUAL?	LAT,STACK \FALSE
	SUB	X,HLON
	EQUAL?	LON,STACK /TRUE
	RFALSE


	.FUNCT	THORPE-SUB-F
	EQUAL?	PRSA,V?FIND \?ELS5
	PRINTR	"It's not far away!"
?ELS5:	EQUAL?	PRSA,V?PUSH,V?MOVE \?ELS9
	PRINTR	"It's too big!"
?ELS9:	EQUAL?	PRSA,V?ATTACK,V?KILL,V?SHOOT \?ELS13
	PRINTI	"You have to shoot"
	CALL	THE-PRSO-PRINT
	PRINTR	" with a weapon."
?ELS13:	EQUAL?	PRSA,V?WALK-TO \FALSE
	PRINTR	"You're the pilot!"


	.FUNCT	I-UPDATE-THORPE,DLAT,DLON,Z
	ZERO?	SUB-IN-BATTLE /?CND1
	MUL	THORPE-HLON,THORPE-HLAT >Z
	CALL	THORPE-SHOOT?,SUB-LON,SUB-LAT
	ZERO?	STACK \?ELS7
	ZERO?	THORPE-DLON \?ELS10
	ZERO?	THORPE-DLAT \?ELS10
	ZERO?	THORPE-TURNING? \?PRD13
	PUSH	1
	JUMP	?PRD14
?PRD13:	PUSH	0
?PRD14:	SET	'THORPE-TURNING?,STACK
	ZERO?	THORPE-TURNING? /?ELS17
	JUMP	?CND1
?ELS17:	CALL	STARBOARD-OF-THORPE?,SUB-LON,SUB-LAT
	ZERO?	STACK /?ELS20
	ZERO?	THORPE-HLON \?ELS23
	SET	'THORPE-HLON,THORPE-HLAT
	JUMP	?CND5
?ELS23:	EQUAL?	-1,Z \?ELS25
	SET	'THORPE-HLON,0
	JUMP	?CND5
?ELS25:	EQUAL?	1,Z \?ELS27
	SET	'THORPE-HLAT,0
	JUMP	?CND5
?ELS27:	SUB	0,THORPE-HLON >THORPE-HLAT
	JUMP	?CND5
?ELS20:	ZERO?	THORPE-HLON \?ELS34
	SUB	0,THORPE-HLAT >THORPE-HLON
	JUMP	?CND5
?ELS34:	EQUAL?	-1,Z \?ELS36
	SET	'THORPE-HLAT,0
	JUMP	?CND5
?ELS36:	EQUAL?	1,Z \?ELS38
	SET	'THORPE-HLON,0
	JUMP	?CND5
?ELS38:	SET	'THORPE-HLAT,THORPE-HLON
	JUMP	?CND5
?ELS10:	SET	'THORPE-DLON,0
	SET	'THORPE-DLAT,0
	JUMP	?CND5
?ELS7:	PRINTI	"Thorpe zeroed in on you and fired his rocket! It streaks through the water toward the "
	PRINTD	SUB
	PRINTI	"! In an instant your sub will be just twisted metal, trapping you and Tip forever in Davy Jones's locker!"
	CALL	FINISH
?CND5:	
?CND1:	ADD	THORPE-LON,THORPE-DLON >THORPE-LON
	ADD	THORPE-LAT,THORPE-DLAT >THORPE-LAT
	MUL	THORPE-HLON,THORPE-HLAT >Z
	ZERO?	Z \?ELS49
	ZERO?	THORPE-HLAT \?ELS52
	ADD	THORPE-LAT,THORPE-HLON >SNARK-LAT
	ADD	THORPE-LON,THORPE-HLON >SNARK-LON
	RFALSE	
?ELS52:	ADD	THORPE-LAT,THORPE-HLAT >SNARK-LAT
	SUB	THORPE-LON,THORPE-HLAT >SNARK-LON
	RFALSE	
?ELS49:	EQUAL?	-1,Z \?ELS56
	ADD	THORPE-LON,THORPE-HLON >SNARK-LON
	SET	'SNARK-LAT,THORPE-LAT
	RFALSE	
?ELS56:	EQUAL?	1,Z \FALSE
	ADD	THORPE-LAT,THORPE-HLAT >SNARK-LAT
	SET	'SNARK-LON,THORPE-LON
	RFALSE	


	.FUNCT	DART-F
	CALL	WEAPON-F,DART
	RSTACK	


	.FUNCT	MOUNTING-VERB?,OBJ
	ZERO?	SUB-IN-DOME /FALSE
	EQUAL?	PRSO,OBJ \FALSE
	EQUAL?	PRSA,V?USE /TRUE
	EQUAL?	PRSA,V?SHOW \?ELS13
	EQUAL?	PRSO,BLY \?ELS13
	EQUAL?	PRSI,BAZOOKA /TRUE
?ELS13:	EQUAL?	PRSA,V?PUT-UNDER \?ELS15
	EQUAL?	PRSO,ESCAPE-POD-UNIT \?ELS15
	EQUAL?	PRSI,PILOT-SEAT,CHAIR /TRUE
?ELS15:	EQUAL?	PRSA,V?TIE-TO,V?PUT \FALSE
	EQUAL?	PRSI,CLAW,LOCAL-SUB,GLOBAL-SUB /TRUE
	RFALSE


	.FUNCT	NO-GOOD-MUNGED
	PRINTD	HORVAK
	PRINTR	" has to fix it first."


	.FUNCT	WEAPON-F,OBJ,WHICH=0,O,NOT-ON-SUB=0,SOMEONE=0
	CALL	BAD-AIR?
	ZERO?	STACK \TRUE
	EQUAL?	PRSA,V?TAKE,V?SEARCH-FOR,V?FIND \?ELS5
	JUMP	?CND1
?ELS5:	CALL	MOUNTING-VERB?,OBJ
	ZERO?	STACK /?ELS7
	JUMP	?CND1
?ELS7:	CALL	REMOTE-VERB?
	ZERO?	STACK \FALSE
?CND1:	EQUAL?	OBJ,DART \?CND10
	SET	'WHICH,1
?CND10:	GET	ON-SUB,WHICH
	EQUAL?	OBJ,STACK /?CND13
	SET	'NOT-ON-SUB,TRUE-VALUE
?CND13:	ZERO?	SUB-IN-DOME \?CND16
	ZERO?	NOT-ON-SUB /?CND16
	PRINTI	"You can't use"
	CALL	PRINTT,OBJ
	PRINTR	" now!"
?CND16:	ZERO?	NOT-ON-SUB /?ELS27
	EQUAL?	PRSA,V?SEARCH-FOR,V?FIND \?ELS33
	LOC	OBJ
	EQUAL?	HERE,STACK \FALSE
	FSET?	OBJ,TOUCHBIT /FALSE
	FCLEAR	OBJ,NDESCBIT
	CALL	HE-SHE-IT,WINNER,TRUE-VALUE,STR?55
	PRINTR	" it among lots of equipment and supplies."
?ELS33:	EQUAL?	PRSA,V?TAKE \?ELS44
	EQUAL?	WHICH,1 \FALSE
	FCLEAR	DART,NDESCBIT
	FSET?	DART,MUNGBIT \FALSE
	CALL	NO-GOOD-MUNGED
	RSTACK	
?ELS44:	CALL	MOUNTING-VERB?,OBJ
	ZERO?	STACK /FALSE
	EQUAL?	WINNER,PLAYER /?ELS59
	SET	'SOMEONE,WINNER
	JUMP	?CND57
?ELS59:	CALL	FIND-FLAG,HERE,PERSON,PLAYER >SOMEONE
	ZERO?	SOMEONE /?CND57
?CND57:	ZERO?	SOMEONE \?CND62
	CALL	META-LOC,OBJ
	EQUAL?	HERE,STACK /?ELS67
	CALL	NOT-HERE,OBJ
	RTRUE	
?ELS67:	EQUAL?	HERE,AIRLOCK /?CND62
	CALL	NOT-HERE,CLAW
	RTRUE	
?CND62:	ZERO?	WHICH \?ELS74
	ZERO?	SOMEONE /?ELS79
	EQUAL?	HERE,AIRLOCK /?ELS79
	PRINTI	"""Good idea! That should stop the "
	PRINTD	SNARK
	PRINTI	"! It could disable an enemy sub, too! Shall I "
	EQUAL?	PRSA,V?PUT \?ELS86
	PRINTI	"do it"
	JUMP	?CND84
?ELS86:	PRINTI	"have it mounted"
	EQUAL?	PRSI,CLAW /?CND84
	PRINTI	" on an "
	PRINTD	CLAW
	PRINTI	" of the "
	PRINTD	SUB
?CND84:	PRINTI	"?"""
	CALL	YES?
	ZERO?	STACK /TRUE
	CALL	MOUNT-WEAPON,BAZOOKA
	CALL	FINE-SEQUENCE
	RTRUE	
?ELS79:	CALL	MOUNT-WEAPON,BAZOOKA
	CALL	OKAY,BAZOOKA,STR?56
	CALL	FINE-SEQUENCE
	RTRUE	
?ELS74:	FSET?	DART,MUNGBIT \?ELS106
	CALL	NO-GOOD-MUNGED
	RSTACK	
?ELS106:	CALL	MOUNT-WEAPON,DART
	ZERO?	SOMEONE /?ELS111
	EQUAL?	HERE,AIRLOCK /?ELS111
	PRINTD	SOMEONE
	PRINTI	" promptly mounts the "
	PRINTD	DART
	PRINTI	" on an "
	PRINTD	CLAW
	PRINTI	"."
	CRLF	
	JUMP	?CND109
?ELS111:	CALL	OKAY,DART,STR?56
?CND109:	GET	ON-SUB,0
	EQUAL?	BAZOOKA,STACK \TRUE
	CALL	FINE-SEQUENCE
	RTRUE	
?ELS27:	EQUAL?	PRSA,V?EXAMINE,V?FIND \?ELS127
	PRINTI	"It's mounted on one of the "
	PRINTD	SUB
	PRINTI	"'s "
	PRINTD	CLAW
	PRINTR	"s."
?ELS127:	EQUAL?	PRSA,V?TAKE /?THN132
	CALL	MOUNTING-VERB?,OBJ
	ZERO?	STACK /?ELS131
?THN132:	PRINTI	"You'd better leave it mounted on the "
	PRINTD	CLAW
	PRINTR	"."
?ELS131:	CALL	REMOTE-VERB?
	ZERO?	STACK \FALSE
	EQUAL?	PRSA,V?MOVE-DIR,V?MOVE \?ELS139
	PRINTR	"You should type where you want to aim it."
?ELS139:	EQUAL?	PRSA,V?AIM \?ELS143
	FSET?	CLAW,MUNGBIT \?ELS146
	PRINTI	"Nothing happens. Either the "
	PRINTD	CLAW
	PRINTI	" or the "
	PRINTD	OBJ
	PRINTI	" was damaged when you rammed the "
	PRINTD	SNARK
	PRINTR	"!"
?ELS146:	EQUAL?	PRSI,GLOBAL-THORPE,THORPE-SUB \?ELS150
	CALL	STARBOARD-OF-THORPE?,SUB-LON,SUB-LAT
	ZERO?	STACK \?ELS153
	CALL	YOU-CANT,STR?57,GLOBAL-SNARK,STR?58
	RTRUE	
?ELS153:	ZERO?	SUB-IN-BATTLE /?CND156
	CALL	SCORE-OBJ,THORPE-SUB
?CND156:	PUT	OBJ-AIMED-AT,WHICH,THORPE-SUB
	PUT	LON-AIMED-AT,WHICH,THORPE-LON
	PUT	LAT-AIMED-AT,WHICH,THORPE-LAT
	JUMP	?CND144
?ELS150:	EQUAL?	PRSI,GLOBAL-SNARK,SNARK \FALSE
	PUT	OBJ-AIMED-AT,WHICH,SNARK
	PUT	LON-AIMED-AT,WHICH,SNARK-LON
	PUT	LAT-AIMED-AT,WHICH,SNARK-LAT
?CND144:	PRINTR	"Aimed."
?ELS143:	EQUAL?	PRSA,V?ATTACK,V?KILL,V?SHOOT \FALSE
	GET	OBJ-AIMED-AT,WHICH >O
	GET	ALREADY-SHOT,WHICH
	ZERO?	STACK /?ELS170
	PRINTI	"You already shot"
	CALL	THE-PRSI-PRINT
	PRINTR	"!"
?ELS170:	ZERO?	O \?CND168
	PRINTR	"You have to aim it first!"
?CND168:	EQUAL?	THORPE-SUB,O \?ELS183
	EQUAL?	PRSO,GLOBAL-THORPE,THORPE-SUB \?THN180
?ELS183:	EQUAL?	SNARK,O \?CND177
	EQUAL?	PRSO,GLOBAL-SNARK,SNARK /?CND177
?THN180:	PRINTI	"You didn't aim it at"
	CALL	THE-PRSO-PRINT
	PRINTR	"."
?CND177:	EQUAL?	PRSO,GLOBAL-THORPE,THORPE-SUB \?ELS192
	GET	LON-AIMED-AT,WHICH
	EQUAL?	STACK,THORPE-LON \?ELS197
	GET	LAT-AIMED-AT,WHICH
	EQUAL?	STACK,THORPE-LAT \?ELS197
	PUT	ALREADY-SHOT,WHICH,TRUE-VALUE
	ZERO?	WHICH \?ELS204
	CALL	MUNG-TARGET
	RSTACK	
?ELS204:	PRINTI	"Fudge! Your tranquilizer dart hit the "
	PRINTD	THORPE-SUB
	PRINTI	", and its metal hull can't be put to sleep! Tough luck, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTR	"."
?ELS197:	CALL	TOO-BAD-BUT,PRSO
	PRINTR	" moved since you aimed."
?ELS192:	EQUAL?	PRSO,GLOBAL-SNARK,SNARK \FALSE
	GET	LON-AIMED-AT,WHICH
	EQUAL?	STACK,SNARK-LON \?ELS219
	GET	LAT-AIMED-AT,WHICH
	EQUAL?	STACK,SNARK-LAT \?ELS219
	PUT	ALREADY-SHOT,WHICH,TRUE-VALUE
	SET	'SNARK-TRANKED,TRUE-VALUE
	SET	'SNARK-HLON,THORPE-HLON
	SET	'SNARK-HLAT,THORPE-HLAT
	ZERO?	WHICH \?ELS226
	PRINTI	"KA-VOOOM! The "
	PRINTD	SNARK
	PRINTI	" shudders and stops moving! You scored a clean hit with your "
	PRINTD	BAZOOKA
	PRINTI	"!
"
	CALL	TIP-SAYS
	PRINTI	"Rats! There goes our safety shield!"" And he's right. Even though you've saved the "
	PRINTD	AQUADOME
	PRINTI	" from further danger of monster attack, the "
	PRINTD	SUB
	PRINTI	" is now exposed to the "
	PRINTD	THORPE-SUB
	PRINTR	"'s rocket weapon!"
?ELS226:	PRINTI	"Right on! The dart hits the "
	PRINTD	SNARK
	PRINTI	" and sticks out of its side. The tranquilizer spreads through the "
	PRINTD	SNARK
	PRINTI	", sending it to Slumberland.
But this may have been a bad move. With the "
	PRINTD	SNARK
	PRINTI	" fast asleep, its huge body can't hide you from the "
	PRINTD	THORPE-SUB
	PRINTR	"'s rocket attack!"
?ELS219:	CALL	TOO-BAD-BUT,PRSO
	PRINTR	" moved since you aimed."


	.FUNCT	MUNG-TARGET
	CALL	SCORE-UPD,5
	FSET	PRSO,MUNGBIT
	PRINTI	"Great! You and Tip can see"
	CALL	THE-PRSI-PRINT
	PRINTI	" slam into the "
	PRINTD	THORPE-SUB
	PRINTI	"'s power pod!
""Hooray! That crippled the "
	PRINTD	THORPE-SUB
	PRINTI	" for keeps!"" Tip cheers.
You hear a voice come over the "
	PRINTD	SONARPHONE
	PRINTI	": "
?PRG3:	PRINTI	""""
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	", this is Sharon! Do you read me?"""
	CALL	YES?
	ZERO?	STACK /?PRG3
	PRINTI	"""Something hit us, and Thorpe's out cold! He cracked his skull on the bulkhead! I was waking up when I saw it all happen. I'll tie him up so he can't cause any trouble.
The "
	PRINTD	THORPE-SUB
	PRINTI	"'s regular engine is kaput, but he installed a backup engine for emergencies. And the sonar control's still working. If you like, I'll guide the monster to its cavern.""
"
	GETP	GREENUP,P?VALUE
	ZERO?	STACK /?CND12
	CALL	TIP-SAYS
	PRINTI	"It's too bad we didn't find the "
	PRINTD	TRAITOR
	PRINTI	" at the "
	PRINTD	AQUADOME
	PRINTI	".""
"
?CND12:	PRINTI	"
CONGRATULATIONS, "
	CALL	PRINT-NAME,FIRST-NAME,TRUE-VALUE
	PRINTI	"! YOU'VE COMPLETED YOUR MISSION!!"
	CALL	FINISH
	RSTACK	


	.FUNCT	MOUNT,WHICH,WEAPON,OBJ
	GET	ON-SUB,WHICH >OBJ
	ZERO?	OBJ /?CND1
	MOVE	OBJ,AIRLOCK
?CND1:	PUT	ON-SUB,WHICH,WEAPON
	RTRUE	


	.FUNCT	MOUNT-WEAPON,OBJ
	EQUAL?	OBJ,BAZOOKA \?ELS3
	CALL	SCORE-OBJ,BLY
	PUTP	BAZOOKA,P?LDESC,STR?59
	GETP	BAZOOKA,P?VALUE
	ZERO?	STACK /?CND4
	PRINTI	"""Of course I'll have to get it first."""
	CRLF	
	CALL	SCORE-OBJ,BAZOOKA
?CND4:	CALL	MOUNT,0,BAZOOKA
	JUMP	?CND1
?ELS3:	EQUAL?	OBJ,DART \?ELS10
	PUTP	DART,P?LDESC,STR?60
	CALL	SCORE-OBJ,HORVAK
	CALL	MOUNT,1,DART
	JUMP	?CND1
?ELS10:	GET	ON-SUB,0
	ZERO?	STACK /?ELS12
	GET	ON-SUB,1
	ZERO?	STACK /?ELS15
	PRINTI	"The claws are holding all they can."
	CRLF	
	RFALSE	
?ELS15:	PUT	ON-SUB,1,OBJ
	JUMP	?CND1
?ELS12:	PUT	ON-SUB,0,OBJ
?CND1:	EQUAL?	HERE,SUB,CRAWL-SPACE \?ELS24
	MOVE	OBJ,SUB
	JUMP	?CND22
?ELS24:	ZERO?	SUB-IN-DOME /?ELS26
	MOVE	OBJ,AIRLOCK
	JUMP	?CND22
?ELS26:	MOVE	OBJ,NORTH-TANK-AREA
?CND22:	FSET	OBJ,NDESCBIT
	FCLEAR	OBJ,TAKEBIT
	FSET	OBJ,TRYTAKEBIT
	RTRUE	


	.FUNCT	FINE-SEQUENCE
	ZERO?	TIP-FOLLOWS-YOU? /FALSE
	CALL	READY-FOR-SNARK?
	ZERO?	STACK \FALSE
	CALL	MOVE-HERE-NOT-SUB,BLY
	PRINTI	"""Are you ready to take off now, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"?"" Zoe Bly "
	IN?	BLY,HERE \?ELS12
	PUSH	STR?61
	JUMP	?CND8
?ELS12:	PUSH	STR?62
?CND8:	PRINT	STACK
	PRINTI	"s anxiously."
	CALL	YES?
	ZERO?	STACK /FALSE
	PRINTI	"""Wait!"" Tip cuts in. "
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK-ABOUT,TIP,FINE-GRID
	RSTACK	


	.FUNCT	BAZOOKA-F
	CALL	WEAPON-F,BAZOOKA
	RSTACK	


	.FUNCT	I-THORPE-APPEARS
	GRTR?	17,SUB-LON /?THN6
	LESS?	-17,SUB-LAT /?THN6
	EQUAL?	SUB-DEPTH,AIRLOCK-DEPTH /?ELS5
?THN6:	SUB	MOVES,LEFT-DOME
	LESS?	40,STACK \FALSE
	SET	'LEFT-DOME,MOVES
	PRINTI	"Suddenly "
	CALL	TIP-SAYS
	CALL	PRINT-NAME,FIRST-NAME
	EQUAL?	SUB-DEPTH,AIRLOCK-DEPTH \?ELS21
	PRINTI	", what "
	PRINTD	INTDIR
	PRINTI	" do you think the "
	PRINTD	SNARK
	PRINTR	" went, anyway?"""
?ELS21:	PRINTR	", I wonder if we're at the right depth?"""
?ELS5:	CALL	QUEUE,I-SNARK-ATTACKS,0
	CALL	QUEUE,I-THORPE-APPEARS,0
	CALL	QUEUE,I-THORPE-AWAKES,9
	PUT	STACK,0,1
	FSET	SEARCH-BEAM,ONBIT
	PRINTI	"""Holy halibut!"" cries Tip. ""There's a big cloud of silt ahead in the "
	PRINTD	SEARCH-BEAM
	PRINTI	". It's out of sonar range. This could be the "
	PRINTD	SNARK
	PRINTI	"! Want to hold course till we find out?"""
	CALL	YES?
	PRINTI	"However you steer, the cloud holds steady. You may be on a collision course with the behemoth that almost wrecked the "
	PRINTD	AQUADOME
	PRINTI	"!
"
	PRINTI	"Your "
	PRINTD	SEARCH-BEAM
	PRINTI	" reveals TWO objects dead ahead!
One is the "
	PRINTD	SNARK
	PRINTI	". To the left of the tentacled creature -- YOUR left -- you can make out a vehicle crawling along the ocean floor.
"
	CALL	TIP-SAYS
	PRINTI	"That's one of your Sea Cats!""
A voice crackles over the "
	PRINTD	SONARPHONE
	PRINTI	": ""This is "
	PRINTD	GLOBAL-THORPE
	PRINTI	", "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"! Do you read me?"""
	CALL	YES?
	PRINTI	"Your answer brings a rasping laugh. ""Of course you read me, or you wouldn't be answering! Your "
	PRINTD	LAB-ASSISTANT
	PRINTI	", "
	PRINTD	SHARON
	PRINTI	", is seated behind me. She'll enjoy what's about to happen as much as I will. Would you like to hear what's in store for you?"""
	CALL	YES?
	ZERO?	STACK \?ELS42
	PRINTI	"""You'll soon find out -- like it or not! "
	JUMP	?CND40
?ELS42:	PRINTI	""""
?CND40:	PRINTI	"I'll blast your sub with a rocket! Then I'll guide my synthetic monster to the "
	PRINTD	AQUADOME
	PRINTI	" to destroy it! Can you guess what sealed your doom, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"?"""
	CALL	YES?
	ZERO?	STACK \?ELS53
	PRINTI	""""
	JUMP	?CND51
?ELS53:	PRINTI	"""I'll tell you anyhow. "
?CND51:	PRINTI	"I want to own the "
	PRINTD	ORE-NODULES
	PRINTI	" near the "
	PRINTD	AQUADOME
	PRINTI	"! Sharon and I consider it a wedding present from you and your dad ...""
Thorpe breaks off with a sudden gulp, followed by some noise and then a soft female voice:
"
?PRG62:	PRINTI	"""This is "
	PRINTD	SHARON
	PRINTI	", "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"! Do you read me?"""
	CALL	YES?
	ZERO?	STACK /?PRG62
	CALL	PHONE-ON,GLOBAL-SHARON,THORPE-SUB,SONARPHONE
	CALL	QUEUE,I-UPDATE-THORPE,-1
	PUT	STACK,0,1
	FCLEAR	SNARK,INVISIBLE
	FCLEAR	THORPE-SUB,INVISIBLE
	ADD	SUB-LON,SONAR-RANGE
	ADD	2,STACK >THORPE-LON
	SUB	SUB-LAT,SONAR-RANGE >THORPE-LAT
	ADD	THORPE-LON,THORPE-HLON >SNARK-LON
	SET	'SNARK-LAT,THORPE-LAT
	FSET	THORPE,MUNGBIT
	PRINTI	"""Thank goodness! I conked Thorpe with a wrench! He fell onto the microphone, and he's too heavy for me to move!"""
	CRLF	
	CALL	SCORE-OBJ,SNARK
	RETURN	2


	.FUNCT	SHARON-EXPLAINS
	EQUAL?	PRSA,V?SAY /?CND1
	PRINTI	"""Wait a second, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	", till I catch my breath!"" Sharon cuts in. "
?CND1:	CALL	SHARON-ABOUT-THORPE
	PRINTI	"""Can I interrupt, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"?"" asks Tip."
	CALL	YES?
	ZERO?	STACK \?CND8
	CALL	TIP-SAYS
	PRINTI	"Sorry, but I have to. This is important.""
"
?CND8:	PRINTI	"""Sharon, how does Thorpe control the monster?""
""By sonar pulse signals,"" she replies. "
	CALL	SHARON-ABOUT-MONSTER
	PRINTI	"""Is the transducer sending out signals now?"" Tip asks her.
""Yes, it operates all the time. Can you make out our position on your "
	PRINTD	SONARSCOPE
	PRINTI	"?""
""Thanks to the "
	PRINTD	FINE-GRID
	PRINTI	"!"" says Tip."
	ZERO?	THROTTLE-SETTING /?CND17
	SET	'THROTTLE-SETTING,0
	PRINTI	" ""Maybe we'd better stop the "
	PRINTD	SUB
	PRINTI	" before we collide with you!""
Tip uses his dual-control throttle to stop your sub. Then he adds apologetically: ""This isn't mutiny, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"! I just figured we should stop now."""
?CND17:	CRLF	
	CALL	SHARON-ABOUT-CAT
	PRINTI	"""Was it out of control when it attacked the "
	PRINTD	AQUADOME
	PRINTI	"?"" asks Tip.
""Oh no!"" Sharon replies. "
?PRG24:	PRINTI	"""Thorpe has a helper at the "
	PRINTD	AQUADOME
	PRINTI	" who put a "
	PRINTD	BLACK-BOX
	PRINTI	" on the "
	PRINTD	SONAR-EQUIPMENT
	PRINTI	", which made it emit signals to ATTRACT the monster and make it attack. Do you follow me so far, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"?"""
	CALL	YES?
	ZERO?	STACK /?PRG24
	PRINTI	"""Good. Before that first attack, Thorpe got the monster close enough for the "
	PRINTD	BLACK-BOX
	PRINTI	" to take over. Then he surfaced near "
	PRINTD	BAY
	PRINTI	" to get me. By the time we went back to the ocean floor, something had gone wrong: the "
	PRINTD	AQUADOME
	PRINTI	" was okay, and the monster had wandered off to its cavern. That reminds me, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	". "
?PRG33:	PRINTI	"Do you want to take the monster to its cavern peacefully? (With no more sonar pulse input, it'll stay there until you're ready to study it scientifically.)"""
	CALL	YES?
	ZERO?	STACK /?CND37
	JUMP	?REP34
?CND37:	PRINTI	"(Better listen, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	". Sharon's trying to show you how to deal with this threat to the "
	PRINTD	AQUADOME
	PRINTI	".)
"""
	JUMP	?PRG33
?REP34:	PRINTI	"""First tell me, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	": do you have any tranquilizer or weapon to use against it?"""
	CALL	YES?
	ZERO?	STACK /TRUE
	PRINTI	"""Do you want to capture it for scientific study?"""
	CALL	YES?
	ZERO?	STACK /?ELS51
	PRINTR	"""Then try the following:
Position your sub on the other side of the monster -- on the monster's LEFT side -- just 5 meters from it. If anything goes wrong and it gets out of control, you can tranquilize it immediately."""
?ELS51:	PRINTI	"""That's odd! I thought you would."""
	CRLF	
	RTRUE	


	.FUNCT	SHARON-ABOUT-THORPE
	PRINTI	"""I'm not in on Thorpe's plot, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	". I'm playing along, trying to wreck his plans. I know it was risky for me to leave that "
	PRINTD	CATALYST-CAPSULE
	PRINTI	" out of the "
	PRINTD	SUB
	ZERO?	SHARON-BROKE-CIRCUIT /?CND3
	PRINTI	", and to open that "
	PRINTD	CIRCUIT-BREAKER
?CND3:	PRINTI	", but it was part of my plan, and you got to the "
	PRINTD	AQUADOME
	PRINTR	" anyway."""


	.FUNCT	SHARON-ABOUT-MONSTER
	PRINTI	"""It's sensitive to the signals on its RIGHT side. Thorpe has installed a sonar transducer on the LEFT or PORT side of this sub. He has to stay on the same side of the monster all the time."""
	RTRUE	


	.FUNCT	SHARON-ABOUT-CAT
	PRINTI	"Sharon says, ""Notice how we keep 5 meters to the monster's right and 5 meters behind its nose. The Sea Cat is programmed that way, so the signals reach the monster with enough strength to keep it in control."""
	RTRUE	


	.FUNCT	I-THORPE-AWAKES
	FCLEAR	THORPE,MUNGBIT
	SET	'SUB-IN-BATTLE,TRUE-VALUE
	CALL	PHONE-OFF
	CALL	PHONE-ON,GLOBAL-THORPE,THORPE-SUB,SONARPHONE
	PRINTI	"
Suddenly the sonarphone gets louder.
"
	CALL	TIP-SAYS
	PRINTI	"That could mean Thorpe is awake and has moved away from the microphone!""
You hear a sharp cry of pain from Sharon, then Thorpe yelling: ""That'll take care of you, my little double-crosser!""
Thorpe speaks into the microphone: ""Now then, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	" "
	CALL	PRINT-NAME,LAST-NAME
	PRINTI	", I'm stopping my "
	PRINTD	THORPE-SUB
	PRINTI	" so I can blow you into Kingdom Come as soon as you're in my sights!""
"
	CALL	STARBOARD-OF-THORPE?,SUB-LON,SUB-LAT
	ZERO?	STACK \?CND5
	CALL	TIP-SAYS
	PRINTI	"He'll have to go around the "
	PRINTD	SNARK
	PRINTI	" to fire at us, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"! And we'll have to go around its tail to shoot at HIM!""
"
?CND5:	CALL	TELL-HINT,42,THORPE-SUB,FALSE-VALUE
	RETURN	2

	.ENDI

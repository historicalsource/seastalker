"DOME for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<GLOBAL URS "Undersea Research Station">

<OBJECT AQUADOME
	(IN GLOBAL-OBJECTS)
	(DESC "Aquadome")
	(ADJECTIVE UNDERSEA UNDERWATER RESEARCH AQUA PLASTIC TRANSPARENT)
	(SYNONYM AQUADOME DOME STATION)
	(ACTION AQUADOME-F)
	(FLAGS VOWELBIT)
	(VALUE 5)>

<ROUTINE AQUADOME-F ()
 <COND (<OR <VERB? FIND WHAT>
	    <AND <VERB? ASK-ABOUT> <FSET? ,PRSO ,PERSON>>>
	<COND (<AND <==? ,NOW-TERRAIN ,SEA-TERRAIN> <==? ,HERE ,SUB>>
	       <PERFORM ,V?FIND ,PLAYER>
	       <RTRUE>)
	      (,SUB-IN-OPEN-SEA
	       %<XTELL
"Its location is stored in the " D ,AUTO-PILOT "'s computer memory." CR>)
	      (<AND <NOT ,SUB-IN-DOME>
		    <NOT <==? ,NOW-TERRAIN ,SEA-TERRAIN>>>
	       %<XTELL
"\"The " D ,AQUADOME " encloses the " ,URS " of " D
,IU-GLOBAL ", on the ocean floor off the Atlantic coast. Most " LN "
subs can reach it by " D ,AUTO-PILOT ".\"" CR>)>)
       (<AND <VERB? EXAMINE> <NOT <L? ,DISTANCE-FROM-BAY ,AQUADOME-VISIBLE>>>
	<SETG P-WON <>>
	%<XTELL <GETP ,LOCAL-SUB ,P?TEXT> CR>)
       (<VERB? LOOK-INSIDE LOOK-OUTSIDE>
	<PERFORM ,PRSA ,WINDOW>
	<RTRUE>)
       (<VERB? THROUGH>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <TELL "Wait until you're close enough." CR>)>)
       (<VERB? WALK-AROUND>
	<COND (<AND <GO-NEXT ,IN-DOME-AROUND> <NOT <==? ,WINNER ,PLAYER>>>
	       <OKAY>)>
	<RTRUE>)
       (<VERB? WALK-TO>
	<COND ;(<==? ,NOW-TERRAIN ,SEA-TERRAIN>
	       <TELL "Use this information: ">
	       <PERFORM ,V?FIND ,PLAYER>
	       <RTRUE>)
	      (,SUB-IN-DOME
	       %<XTELL "You're in it!" CR>)
	      (,SUB-IN-OPEN-SEA	;<FSET? ,AUTO-PILOT ,ONBIT>
	       %<XTELL "Let the " D ,AUTO-PILOT " handle that." CR>)
	      (T %<XTELL "First you must reach the open sea." CR>)>)>>

<ROUTINE IN-DOME? (RM)
	<OR <AND ,SUB-IN-DOME <EQUAL? .RM ,SUB ,CRAWL-SPACE>>
	    <ZMEMQ .RM ,IN-DOME-AROUND>>>

<ROUTINE AIR-ROOM? (RM)
	<OR <EQUAL? .RM ,FOOT-OF-RAMP ,AIRLOCK ,AIRLOCK-WALL>
	    <EQUAL? .RM ,CENTER-OF-DOME ,OUTSIDE-ADMIN-BLDG>
	    <EQUAL? .RM ,BLY-OFFICE ,SUB>>>

<ROUTINE THROUGH-ROOF? (RM "OPTIONAL" (HR <>))
	<COND (<NOT .HR> <SET HR ,HERE>)>
	<COND (<EQUAL? .HR ,SUB ,CRAWL-SPACE ,AIRLOCK>
	       <NOT <EQUAL? .RM ,SUB ,CRAWL-SPACE ,AIRLOCK>>)
	      (T <EQUAL? .RM ,SUB ,CRAWL-SPACE ,AIRLOCK>)>>

<OBJECT WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(FLAGS NDESCBIT WINDOWBIT LOCKED)
	(ACTION WINDOW-F)>

<ROUTINE WINDOW-F ("AUX" ;(RM <WINDOW-ROOM ,HERE ,PRSO>) POP)
	 <COND (<VERB? BRUSH>
		%<XTELL
"The window is clean enough without your interference." CR>)
	       (<VERB? EXAMINE>
		%<XTELL
"The window is a simple plastic sheet, giving a view of the dome outside."
CR>)
	       (<VERB? LOOK-INSIDE LOOK-OUTSIDE>
		<COND (<0? ,SNARK-ATTACK-COUNT>
		       %<XTELL "You can see the dome outside." CR>)
		      (T
		       ;<MOVE-HERE-NOT-SUB ,BLY>
		       <MOVE ,BLY ,HERE>
		       %<XTELL	;" to the southeast"
"The " D ,AQUADOME "'s search lights probe the ocean, but
the " D ,GLOBAL-WATER " is too murky for the beams to penetrate.|
\"Tip's right!\" " D ,BLY " says. \"That must be the " D ,SNARK " out there.
Its tentacles churned up silt from the seabed that way during its first
attack, "FN"!\"" CR>)>)
	       (<VERB? MUNG>
		%<XTELL
"Vandalism is for vandals, not famous inventors!" CR>)
	       (<VERB? OPEN CLOSE LOCK UNLOCK>
		%<XTELL "The window can't be opened." CR>)>>

<OBJECT EXERCISE-TRACK
	(IN GLOBAL-OBJECTS)
	(DESC "exercise track")
	(ADJECTIVE RUNNING JOGGING EXERCISE)
	(SYNONYM TRACK)
	(FLAGS VOWELBIT)
	(ACTION EXERCISE-TRACK-F)>

<ROUTINE EXERCISE-TRACK-F ()
 <COND (<VERB? FIND THROUGH WALK-TO>
	<COND (,SUB-IN-DOME ;<IN-DOME? ,HERE>
	       <TELL "You don't need exercise!" CR>)>)>>
[
<GLOBAL AIRLOCK-FULL T>
<ROOM AIRLOCK
	(IN ROOMS)
	(ADJECTIVE DOCKING)
	(SYNONYM TANK AREA ROOM ;AIRLOCK DOCK)
	(DESC ;"airlock" "docking tank")
	(FLAGS RLANDBIT ONBIT)
	(NORTH	TO AIRLOCK-WALL IF AIRLOCK-ROOF IS OPEN)
	(UP	TO AIRLOCK-WALL IF AIRLOCK-ROOF IS OPEN)
	(OUT	TO AIRLOCK-WALL	IF AIRLOCK-ROOF IS OPEN)
	(DOWN	TO SUB IF SUB-DOOR IS OPEN)
	(IN	TO SUB IF SUB-DOOR IS OPEN)
	(SOUTH	TO SUB IF SUB-DOOR IS OPEN)
	(GLOBAL LOCAL-SUB SUB-DOOR AIRLOCK-RAMP AIR-SUPPLY-SYSTEM-GLOBAL)
	(VALUE 1)
	(ACTION AIRLOCK-F)>

<ROUTINE AIRLOCK-F ("OPTIONAL" (RARG <>))
 <COND (<EQUAL? .RARG ,M-ENTER>
	<COND (<OR ,GREENUP-ESCAPE ,GREENUP-TRAPPED>
	       <MOVE ,LOWELL ,HERE>
	       <MOVE ,ANTRIM ,HERE>
	       %<XTELL "Two of the crew are with you." CR>)>)
       (<==? .RARG ,M-LOOK>
	<TELL "You're now in the " D ,AIRLOCK", at the foot of the ramp." CR>)
       (.RARG <RFALSE>)
       (<AND <NOT ,SUB-IN-DOME> <NOT <SUB-OUTSIDE-AIRLOCK?>>>
	<NOT-HERE ,AIRLOCK>)
       (<VERB? EMPTY>
	<COND (<NOT ,AIRLOCK-FULL>
	       <ALREADY ,AIRLOCK "empty">)
	      (<FSET? ,AIRLOCK-HATCH ,OPENBIT>
	       <YOU-CANT <> ,AIRLOCK-HATCH "open">)
	      (<OR <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
		   <EQUAL? ,HERE ,BLY-OFFICE ,FOOT-OF-RAMP>>
	       <ENABLE <QUEUE I-AIRLOCK-EMPTY 2>>
	       %<XTELL "This will take 1 turn." CR>
	       ;<COND (,GREENUP-ESCAPE
		      <COND (<G? 4 ,GREENUP-ESCAPE>
			     <TELL
"Meanwhile, Greenup can't get into the " D ,SUB " and escape. ">
			     <GREENUP-CUFF>)
			    (<G? 5 ,GREENUP-ESCAPE>
			     <QUEUE I-GREENUP-ESCAPE 0>
			     <SETG GREENUP-ESCAPE 0>
			     <SETG GREENUP-TRAPPED T>
			     <FCLEAR ,SUB-DOOR ,OPENBIT>
			     <TELL
"Meanwhile, the " D ,STATION-MONITOR
" reveals the " D ,SUB " resting in the cradle.
The " D ,SUB-DOOR " is closed.|
\"Looks as if Greenup is holed up inside the " D ,SUB ",\" says " D ,BLY ".
\"Shall I have the crew bring tools to force open the hatch?\"">
			     <COND (<YES?>
				    <TELL
"\"I have the tools, skipper,\" one of the crew reports moments later."
CR>)>)>)>
	       <RTRUE>)>)
       (<VERB? FILL>
	<COND (,AIRLOCK-FULL
	       <ALREADY ,AIRLOCK "full">
	       <RTRUE>)
	      (<NOT <FSET? ,AIRLOCK-ELECTRICITY ,ONBIT>>
	       <YOU-CANT <> ,AIRLOCK-ELECTRICITY "off">
	       <RTRUE>)
	      (<AIRLOCK-POP?>
	       <YOU-CANT <> ,AIRLOCK "full of people">
	       ;<TELL
"You can't open the " D ,AIRLOCK-HATCH " with people in the " D ,AIRLOCK "!"
CR>
	       <RTRUE>)>
	<COND (<NOT ,GREENUP-ESCAPE>
	       <COND (<FSET? ,SUB-DOOR ,OPENBIT>
		      <YOU-CANT <> ,SUB-DOOR "open">
		      ;<TELL
"You can't open the " D ,AIRLOCK-HATCH " while the " D ,SUB-DOOR " is open."
CR>
		      <RTRUE>)>
	       <COND (<FSET? ,AIRLOCK-ROOF ,OPENBIT>
		      ;<ENABLE <QUEUE I-DOME-FLOODED 2>>
		      <THIS-IS-IT ,AIRLOCK-ROOF>
		      %<XTELL
"A safety mechanism prevents it. The " D ,AIRLOCK-ROOF " is open!" CR>
		      <RTRUE>)>)>
	<COND (<AND ,GREENUP-ESCAPE <G? 4 ,GREENUP-ESCAPE>>
	       %<XTELL
"Greenup is frantically scrambling back up the ladder to avoid being
swept off and drowned! ">
	       <GREENUP-CUFF>
	       <TELL
"Tip immediately empties the " D ,AIRLOCK " again." CR>)
	      (<OR <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
		   <EQUAL? ,HERE ,BLY-OFFICE ,FOOT-OF-RAMP>>
	       <ENABLE <QUEUE I-AIRLOCK-EMPTY 2>>
	       %<XTELL "This will take 1 turn." CR>
	       <RTRUE>)>)
       (<VERB? OPEN CLOSE>
	;<COND (<VERB? FILL>
	       <TELL ,I-ASSUME " open the " D ,AIRLOCK-HATCH ".)" CR>)> 
	<PERFORM ,PRSA ,AIRLOCK-HATCH>
	<RTRUE>)
       (<VERB? THROUGH WALK-TO>
	<COND (<AND <NOT ,SUB-IN-DOME> <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>>
	       <TOO-BAD-BUT ,PRSO "too far away">
	       ;<TELL "It's too far away." CR>
	       <RTRUE>)>
	<SETG PRSO ,AIRLOCK>
	<CHEERS?>
	;<DO-WALK ,P?SOUTH>
	<RFALSE>)>>

<ROUTINE CHEERS? ()
 <COND (<AND <==? ,WINNER ,PLAYER>
	     <ZMEMQ ,HERE ,IN-DOME-AROUND>
	     <NOT <EQUAL? ,HERE ,AIRLOCK ,AIRLOCK-WALL>>>
	<COND (<READY-FOR-SNARK?>
	       %<XTELL
"Cheers follow as you start up the ladder into the " D ,AIRLOCK "." CR>)>)>>

<ROUTINE I-AIRLOCK-EMPTY ()
 <COND (,AIRLOCK-FULL
	<COND (<FSET? ,AIRLOCK-HATCH ,OPENBIT> <RFALSE>)>
	<SETG AIRLOCK-FULL <>>
	%<XTELL CR
"The " D ,AIRLOCK " is now clear of " D ,GLOBAL-WATER " and filled with
air at sea-level pressure.">
	<COND (<FSET? ,ENGINE ,ONBIT>
	       <FCLEAR ,ENGINE ,ONBIT>
	       <TELL " The engine shuts off.">)>
	<COND (T ;<EQUAL? ,HERE ,SUB>
	       <FSET ,AIRLOCK-ROOF ,OPENBIT>
	       <THIS-IS-IT ,SUB-DOOR>
	       %<XTELL CR
"The roof of the " D ,AIRLOCK " is sliding open, and the " D ,SUB
" is in dry dock.|
A ramp swings down from the top of the " D ,AIRLOCK "'s north wall to your "
D ,SUB-DOOR "." CR>
	       <RFATAL>)>)
       (T
	<SETG AIRLOCK-FULL T>
	%<XTELL CR
"The " D ,AIRLOCK " is now filled with " D ,GLOBAL-WATER "." CR>
	<COND (,SUB-IN-DOME
	       <TELL
"The adjustable cradle then releases the " D ,SUB "'s keel from its
grip." CR>)>)>>

<OBJECT GREENUP-LADDER
	(IN AIRLOCK)
	(DESC "emergency ladder")
	(ADJECTIVE EMERGE)
	(SYNONYM LADDER)
	(FLAGS VOWELBIT NDESCBIT)
	(ACTION GREENUP-LADDER-F)>

<ROUTINE GREENUP-LADDER-F ()
 <COND (<VERB? BOARD ;ENTER CLIMB-DOWN CLIMB-ON CLIMB-UP THROUGH>
	%<XTELL "The " D ,GREENUP-LADDER " is only for emergencies." CR>)>>
]
<OBJECT AIRLOCK-RAMP
	(IN LOCAL-GLOBALS)
	(DESC ;"airlock" "docking tank ramp")
	(ADJECTIVE DOCKING TANK AIRLOCK)
	(SYNONYM RAMP)
	(ACTION AIRLOCK-RAMP-F)>

<ROUTINE AIRLOCK-RAMP-F ()
 <COND (<AND <VERB? BOARD CLIMB-DOWN CLIMB-ON> <EQUAL? ,HERE ,AIRLOCK-WALL>>
	<DO-WALK ,P?SOUTH>
	<RTRUE>)
       (<AND <VERB? BOARD CLIMB-UP CLIMB-ON> <EQUAL? ,HERE ,AIRLOCK>>
	<DO-WALK ,P?NORTH>
	<RTRUE>)>>

<ROOM AIRLOCK-WALL
	(IN ROOMS)
	(DESC ;"airlock" "docking tank entrance")
	(ADJECTIVE DOCKING TANK AIRLOCK)
	(SYNONYM ENTRANCE)
	(FLAGS RLANDBIT ONBIT)
	(DOWN "You can go down to the north or south.")
	(SOUTH	TO AIRLOCK IF AIRLOCK-ROOF IS OPEN)
	(OUT	TO AIRLOCK IF AIRLOCK-ROOF IS OPEN)
	(IN	TO FOOT-OF-RAMP)
	(NORTH	TO FOOT-OF-RAMP)
	(GLOBAL LOCAL-SUB ;SUB-DOOR AIRLOCK-RAMP AIRLOCK-LADDER
		AIR-SUPPLY-SYSTEM-GLOBAL)
	(ACTION AIRLOCK-WALL-F)
	;(LINE 2)
	;(STATION FOOT-OF-RAMP)
	(CORRIDOR *1000*)>

<ROUTINE AIRLOCK-WALL-F ("OPTIONAL" (ARG <>))
	<COND (<==? .ARG ,M-LOOK>
	       %<XTELL
"You're now atop the north wall of the " D ,AQUADOME "'s " D ,AIRLOCK "."
CR>
	       %<XTELL
"This gives you a bird's-eye view of the whole " ,URS " of "
D ,IU-GLOBAL ".|
|
The dome is a transparent hemisphere made of plastic of great strength,
developed by you for this specific purpose. The dome encloses the four
attached buildings of the " ,URS ": the workshop/lab and dormitory in
the western half of the dome, and the administration and communication
buildings in the eastern half.|
">
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		      <TELL
"In the very center is the " D ,AIR-SUPPLY-SYSTEM ". This is in a cylinder that
runs from the floor to the top of the dome. It extracts oxygen from "
D ,GLOBAL-WATER "
and emits it through small holes around its base to keep the air fresh at all
times.|
">)>
	       <TELL
"A ladder goes from here down to the floor of the " D ,AQUADOME ",
outside the " D ,AIRLOCK "'s north wall.|
">
	       <COND (<AND <CREW-5-TOGETHER?>
			   <IN? ,CREW ,FOOT-OF-RAMP>
			   <NOT <FSET? ,BLY ,MUNGBIT>>>
		      %<XTELL D ,BLY " and her five " D ,CREW " are">
		      <COND (<NOT <FSET? ,FOOT-OF-RAMP ,TOUCHBIT>>
			     <TELL " waiting to greet you">)>
		      %<XTELL " at the foot of this ladder." CR>)>)>>

<OBJECT AIRLOCK-LADDER
	(IN LOCAL-GLOBALS)
	(DESC ;"airlock" "docking tank ladder")
	(ADJECTIVE DOCKING TANK AIRLOCK)
	(SYNONYM LADDER)
	;(FLAGS VOWELBIT)
	(ACTION AIRLOCK-LADDER-F)>

<ROUTINE AIRLOCK-LADDER-F ()
 <COND (<AND <VERB? BOARD CLIMB-DOWN CLIMB-ON> <EQUAL? ,HERE ,AIRLOCK-WALL>>
	<DO-WALK ,P?NORTH>
	<RTRUE>)
       (<AND <VERB? BOARD CLIMB-UP CLIMB-ON> <EQUAL? ,HERE ,FOOT-OF-RAMP>>
	<DO-WALK ,P?SOUTH>
	<RTRUE>)>>

<OBJECT CREW
	(IN FOOT-OF-RAMP)
	(DESC "Aquadome crew")
	(ADJECTIVE AQUADOME ENTIRE)
	(SYNONYM CREW DIVERS)
	(FLAGS VOWELBIT NDESCBIT)
	(ACTION CREW-F)>

<ROUTINE CREW-F ()
 <COND (<AND <OR <NOT ,DOME-AIR-BAD?>
		 <NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>>
	     <OR <AND <VERB? ASK-ABOUT>
		      <FSET? ,PRSO ,PERSON>
		      <IOBJ? CREW CREW-GLOBAL>>
		 <AND <VERB? WHAT> <DOBJ? CREW CREW-GLOBAL>>
		 <AND <VERB? TELL-ABOUT> <DOBJ? PLAYER>>>>
	%<XTELL
"\"The crew consists of:|
Doctor Walt Horvak, marine biologist and first-aid medic;|
" D ,ANTRIM ", laser expert and frogman;|
" D ,SIEGEL ", electronics expert in charge of communications; and|
" D ,GREENUP " and " D ,LOWELL ", diver-technicians.\"" CR>)
       (<AND <VERB? ASK ASK-ABOUT ASK-FOR TELL TELL-ABOUT>
	     <DOBJ? CREW>>
	<TELL "You'd better talk to one crew member at a time." CR>
	<RFATAL>)
       (<AND <VERB? GOODBYE HELLO>
	     <DOBJ? CREW>>
	<TELL D ,PRSO " nods at you." CR>)
       (<VERB? DIAGNOSE EXAMINE>
	<COND (,DOME-AIR-BAD?
	       %<XTELL
D ,BLY " and the two divers, Greenup and Lowell, are without
oxygen." CR>)
	      (T %<XTELL "All the crew members are okay now." CR>)>)>>

<OBJECT CREW-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "Aquadome crew")
	(ADJECTIVE AQUADOME ENTIRE)
	(SYNONYM CREW DIVERS)
	(FLAGS VOWELBIT)
	(ACTION CREW-GLOBAL-F)>

<ROUTINE CREW-GLOBAL-F ("AUX" L)
 <COND (<AND <SPEAKING-VERB?>
	     <DOBJ? CREW-GLOBAL>>
	<TELL "The " D ,CREW-GLOBAL>
	<NOT-HERE-PERSON ,CREW>
	<SETG P-CONT <>>
	<RTRUE>)
       (<VERB? WALK-TO>
	<PERFORM ,PRSA ,CREW>
	<RTRUE>)
       (T <CREW-F>)>>

<OBJECT BADGE-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "badge")
	(ADJECTIVE THIS THESE ;BILL BILL\'S GREENUP ;AMY AMY\'S LOWELL)
	(SYNONYM BADGE BADGES)
	(GENERIC GENERIC-BADGE-F)
	(ACTION BADGE-GLOBAL-F)>

<OBJECT BADGE-GLOBAL-2
	(IN GLOBAL-OBJECTS)
	(DESC "badge")
	(ADJECTIVE COMMANDER ;ZOE ZOE\'S BLY\'S ;MICK MICK\'S ANTRIM)
	(SYNONYM BADGE BADGES)
	(GENERIC GENERIC-BADGE-F)
	(ACTION BADGE-GLOBAL-F)>

<OBJECT BADGE-GLOBAL-3
	(IN GLOBAL-OBJECTS)
	(DESC "badge")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK ;MARV MARV\'S SIEGEL)
	(SYNONYM BADGE BADGES)
	(GENERIC GENERIC-BADGE-F)
	(ACTION BADGE-GLOBAL-F)>

<ROUTINE GENERIC-BADGE-F (OBJ) ,BADGE-GLOBAL>

<ROUTINE BADGE-GLOBAL-F ()
 <COND (<OR <NOT ,SUB-IN-DOME ;<IN-DOME? ,HERE>>
	    <NOT <FIND-FLAG ,HERE ,PERSON ,WINNER>>>
	<NOT-HERE ,BADGE-GLOBAL-3>)
       (<VERB? ANALYZE EXAMINE READ>
	<EXAMINE-BADGE>
	<CRLF>)>>

<ROUTINE EXAMINE-BADGE ()
	<COND (,DOME-AIR-BAD?
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		      %<XTELL
"The badge is turning red! The air is becoming unbreathable!">)
		     (T %<XTELL
"The badge is less red now. The air is improving.">)>)
	      (T %<XTELL
"When a badge turns red, the air is no longer breathable.
It's not red now.">)>>

<GLOBAL DOME-AIR-BAD? <>>
<CONSTANT DOME-AIR-ONSET 11>
<CONSTANT INITIAL-DOME-AIR-BAD 1>
<CONSTANT EXCLAM-DOME-AIR-BAD 3>
<CONSTANT DOME-AIR-FIX-RATE 5>

<GLOBAL DOME-AIR-CRIME <>>
<GLOBAL HORVAK-FIXED-AIR <>>

<ROUTINE BAD-AIR? ()
 <COND (<NOT ,DOME-AIR-BAD?> <RFALSE>)
       (<NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>> <RFALSE>)
       (<AIR-SUPPLY-VERB?> <RFALSE>)
       (T
	%<XTELL "Shouldn't you fix the " D ,AIR-SUPPLY-SYSTEM " first?" CR>)>>

<ROUTINE TROUBLE-BREATHING? ()
	<COND (<VERB? WAIT-FOR WAIT-UNTIL>
	       <RFALSE>)
	      (<OR <NOT <IN? ,OXYGEN-GEAR ,PLAYER>>
		   <NOT <FSET? ,OXYGEN-GEAR ,ONBIT>>>
	       <TELL "You are having">
	       <COND (<NOT <G? 13 ,DOME-AIR-BAD?>>
		      <TELL " real">)>
	       <TELL " trouble breathing." CR>)>>

<ROUTINE TIP-REPORTS? ()
 <COND (<AND <NOT <==? ,HERE ,CENTER-OF-DOME>>
	     <NOT <CORRIDOR-LOOK ,AIR-SUPPLY-SYSTEM>>>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE ,AIRLOCK>
	       <MOVE ,TIP ,AIRLOCK-WALL>)>
	<TELL "Tip, who is standing near the exit, reports that ">)>>

<ROUTINE I-DOME-AIR ("OPTIONAL" (CALLED? <>) "AUX" X)
 <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
	<COND (<NOT ,DOME-AIR-BAD?>
	       <SETG DOME-AIR-BAD? ,INITIAL-DOME-AIR-BAD>
	       <SETG DOME-AIR-CRIME T>
	       ;<COND (,DEBUG <TELL "[Air=" N ,DOME-AIR-BAD? "]" CR>)>
	       <ENABLE <QUEUE I-DOME-AIR -1>>
	       <SET X <VISIBLE? ,BLY>>
	       <FSET ,BLY ,MUNGBIT>
	       <FSET ,GREENUP ,MUNGBIT>
	       <FSET ,LOWELL ,MUNGBIT>
	       <COND (<NOT <TIP-REPORTS?>>
		      <TELL "Suddenly you realize that ">)>
	       <TELL
"Zoe is literally gasping for breath. Her face is turning reddish-purple!
She clutches her throat...|
Everyone">
	       <COND (.CALLED? T)
		     (<AND <IN? ,OXYGEN-GEAR ,PLAYER>
			   <FSET? ,OXYGEN-GEAR ,ONBIT>>
		      <TELL ", except you,">)
		     (T <TELL ", including yourself,">)>
	       <TELL " is having trouble breathing!" CR>
	       <RTRUE>)>
	<TROUBLE-BREATHING?>
	<SETG DOME-AIR-BAD? <+ 1 ,DOME-AIR-BAD?>>
	;<COND (,DEBUG <TELL "[Air=" N ,DOME-AIR-BAD? "]" CR>)>
	<COND (<==? 7 ,DOME-AIR-BAD?>
	       %<XTELL CR
"In 10 turns Bly, Greenup and Lowell, who were not carrying "
D ,OXYGEN-GEAR ", will suffocate from
lack of oxygen. In 20 turns, ">
	       <COND (<IN? ,OXYGEN-GEAR ,PLAYER> <TELL "you and the others">)
		     (T <TELL "those">)>
	       %<XTELL
" who do have " D ,OXYGEN-GEAR " will have exhausted their supply of
oxygen. Need we say more?" CR>)
	      (<==? 13 ,DOME-AIR-BAD?>
	       %<XTELL CR
"Zoe Bly and the two crew members without " D ,OXYGEN-GEAR " now
have only 4 TURNS left to live! Their lives depend on you, " FN "!" CR>
	       <COND (<AND <NOT <FSET? ,ACCESS-PLATE ,OPENBIT>>
			   <NOT <FSET? ,UNIVERSAL-TOOL ,TOUCHBIT>>>
		      <FSET ,UNIVERSAL-TOOL ,TOUCHBIT>
		      <FCLEAR ,UNIVERSAL-TOOL ,NDESCBIT>
		      <MOVE ,UNIVERSAL-TOOL ,PLAYER>
		      <TELL "Tip">
		      <COND (<NOT <IN? ,TIP ,HERE>>
			     <MOVE ,TIP ,HERE>
			     <TELL " runs up and">)>
		      %<XTELL
" gives you a " D ,UNIVERSAL-TOOL " and says, \"Here, " FN>
		      <COND (<FSET? ,CENTER-OF-DOME ,TOUCHBIT>
			     %<XTELL
", open the cylinder with this! It'll fit anything!\"" CR>)
			    (T %<XTELL
", maybe you can use this somehow.\"" CR>)>)>
	       <RTRUE>)
	      (<==? 17 ,DOME-AIR-BAD?>
	       <SET X <EQUAL? <LOC ,SPECIAL-TOOL> ,BLY-OFFICE ,HORVAK>>
	       <MOVE ,HORVAK ,CENTER-OF-DOME>
	       <TELL "|
At this desperate moment, ">
	       <TIP-REPORTS?>
	       <TELL D ,HORVAK " runs from the " D ,BLY-OFFICE>
	       <COND (<AND .X
			   <EQUAL? <LOC ,ELECTROLYTE-RELAY>
				  ,AIR-SUPPLY-SYSTEM ,CENTER-OF-DOME ,HORVAK>>
		      <ENABLE <QUEUE I-BLY-PRIVATELY 3>>
		      <MOVE ,SPECIAL-TOOL ,HORVAK>
		      <FCLEAR ,SPECIAL-TOOL ,INVISIBLE>
		      <FSET ,SPECIAL-TOOL ,TOUCHBIT>
		      <REMOVE ,SPECIAL-TOOL-GLOBAL>
		      <FIX-AIR-SUPPLY>
		      <SETG HORVAK-FIXED-AIR T>
		      %<XTELL
". He's clutching an oddly-shaped gadget.|
">
		      <TIP-SAYS>
		      <TELL
"Hey, that's the " D ,SPECIAL-TOOL "!\"|
">
		      <COND (<NOT <FSET? ,ACCESS-PLATE ,OPENBIT>>
			     <FSET ,ACCESS-PLATE ,OPENBIT>
			     <FSET ,AIR-SUPPLY-SYSTEM ,OPENBIT>
			     <TELL
"Using the " D ,SPECIAL-TOOL ", " D ,HORVAK " quickly opens the "
D ,ACCESS-PLATE ". ">)>
		      <TELL
"Inside the cylinder, the " D ,ELECTROLYTE-RELAY " has come unscrewed and
fallen out of its socket. Horvak">
		      <COND (<NOT <IN? ,ELECTROLYTE-RELAY ,HORVAK>>
			     <TELL " takes it and">)>
		      %<XTELL
" screws it back in place; and within seconds, a fresh supply of oxygen
is flowing out into the " D ,AQUADOME "." CR>)
		     (T
		      <TELL ". He "
			    <COND (<==? ,HERE <LOC ,HORVAK>> "say")
				  (T "shout")>
"s, \"I never wanted it to go this far! I sabotaged the " D ,AIR-SUPPLY-SYSTEM
" to embarrass " D ,BLY ", but now I can't find the ">
		      <COND (.X <TELL D ,ELECTROLYTE-RELAY>)
			    (T <TELL D ,SPECIAL-TOOL>)>
		      <TELL
" to fix it!\"|
As Doc breaks down in tears and Bly suffocates, you realize there's no
point in continuing your mission.">
		      <FINISH>)>)>)
       (T
	<SETG DOME-AIR-BAD? <- ,DOME-AIR-BAD? ,DOME-AIR-FIX-RATE>>
	;<COND (,DEBUG <TELL "[Air=" N ,DOME-AIR-BAD? "]" CR>)>
	<COND (<NOT <L? 0 ,DOME-AIR-BAD?>>
	       <DISABLE <INT I-DOME-AIR>>
	       <ENABLE <QUEUE I-ANTRIM-TO-SUB 10>>
	       <SETG DOME-AIR-BAD? <>>
	       ;<COND (,DEBUG <TELL "[Air=" N ,DOME-AIR-BAD? "]" CR>)>
	       <COND (<FSET? ,BLY ,MUNGBIT>
		      <FCLEAR ,BLY ,MUNGBIT>
		      <FCLEAR ,GREENUP ,MUNGBIT>
		      <FCLEAR ,LOWELL ,MUNGBIT>
		      <COND (<AND <VISIBLE? ,BLY>
				  <VISIBLE? ,GREENUP>
				  <VISIBLE? ,LOWELL>>
			     <COND (<NOT ,HORVAK-FIXED-AIR>
				    <TELL CR
D ,HORVAK " has just returned from the " D ,BLY-OFFICE ", where he went
to get Bly's " D ,OXYGEN-GEAR ", but it's no longer needed." CR>)>
			     %<XTELL CR
D ,BLY " is sitting up and her normal color has returned. Ditto
for Greenup and Lowell, who collapsed. All are recovering from their
temporary lack of air." CR>
			     <TELL-HINT 41 ;11 ,ELECTROLYTE-RELAY>
			     <RTRUE>)>)>)>)>>

<ROOM FOOT-OF-RAMP
	(IN ROOMS)
	(DESC "reception area")
	(ADJECTIVE RECEPTION)
	(SYNONYM AREA ROOM)
	(FLAGS RLANDBIT ONBIT)
	(NORTH	TO CENTER-OF-DOME)
	(SOUTH	TO AIRLOCK-WALL)
	(UP	TO AIRLOCK-WALL)
	(WEST	TO OUTSIDE-DORM)
	(EAST	TO OUTSIDE-ADMIN-BLDG)
	(ACTION FOOT-OF-RAMP-F)
	(GLOBAL AIRLOCK-LADDER AIR-SUPPLY-SYSTEM-GLOBAL)
	;(LINE 2)
	;(STATION FOOT-OF-RAMP)
	(CORRIDOR *3000*)>

<ROUTINE FOOT-OF-RAMP-F ("OPTIONAL" (ARG <>))
	<COND (<==? .ARG ,M-BEG>
	       <COND (<VERB? WALK>
		      <COND (<DOBJ? P?SOUTH P?UP>
			     <CHEERS?>
			     <RFALSE>)>)>)
	      (<==? .ARG ,M-ENTER>
	       <COND (<OR <READY-FOR-SNARK?>
			  ,GREENUP-ESCAPE
			  ,GREENUP-TRAPPED>
		      <MOVE ,BLY ,HERE>
		      <MOVE ,ANTRIM ,HERE>
		      <MOVE ,HORVAK ,HERE>
		      <MOVE ,SIEGEL ,HERE>
		      <MOVE ,LOWELL ,HERE>
		      <COND (<OR ,GREENUP-ESCAPE ,GREENUP-TRAPPED>
			     %<XTELL
"The rest of the " D ,CREW " are with you." CR>)
			    (T %<XTELL
D ,BLY " and the others gather to shake your hand and wish you
luck on your perilous mission." CR>)>)
		     (<NOT ,BLY-WELCOMED>
		      <SETG BLY-WELCOMED T>
		      <TELL D ,BLY " says, \"">
		      <BLY-WELCOME>
		      <TELL "\"" CR>)>)
	      (<==? .ARG ,M-LOOK>
	       <COND (<AND <CREW-5-TOGETHER?>
			   <IN? ,CREW ,FOOT-OF-RAMP>
			   <NOT <FSET? ,BLY ,MUNGBIT>>>
		      <COND (<NOT <FSET? ,CREW ,TOUCHBIT>>
			     <FSET ,CREW ,TOUCHBIT>
			     <ENABLE <QUEUE I-BLY-PRIVATELY 15>>
			     %<XTELL
"You're now face-to-face with Zoe Bly and the " D ,CREW ". They are wearing
badges which show the air quality in the " D ,AQUADOME "." CR>)
			    (T
			     %<XTELL "You're at the foot of the ladder. ">
			     <COND (<IN? ,BLY ,FOOT-OF-RAMP>
				    <TELL "Zoe Bly and t">)
				   (T <TELL "T">)>
			     %<XTELL "he " D ,CREW " are still here." CR>)>)
		     (T %<XTELL
"You're now at the foot of the ladder." CR>)>)
	      (<AND <==? .ARG ,M-END>
		    <==? ,EXCLAM-DOME-AIR-BAD ,DOME-AIR-BAD?>
		    <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	       <CRLF>
	       <BADGES-RED T>
	       <RTRUE>)>>

<GLOBAL BADGES-RED-SAID? <>>
<ROUTINE BADGES-RED ("OPTIONAL" (SHOUT? <>))
	<COND (<NOT ,BADGES-RED-SAID?>
	       <SETG BADGES-RED-SAID? T>
	       <COND (.SHOUT? <TELL "Someone shouts, ">)>
	       %<XTELL
"\"Our badges are turning red! The air's bad! Everyone use your "
D ,OXYGEN-GEAR "!\"" CR>)>>

<ROOM OUTSIDE-DORM
	(IN ROOMS)
	(DESC ;"dorm" "southwest deck")
	(ADJECTIVE SW FEMALE MALE DORM DORMITORY)
	(SYNONYM DECK PORCH ENTRANCE)
	(FLAGS RLANDBIT ONBIT)
	(NORTH	TO OUTSIDE-WORKSHOP)
	(EAST	TO FOOT-OF-RAMP)
	(NE	TO CENTER-OF-DOME)
	(WEST	TO WOMENS-QUARTERS IF WOMENS-QUARTERS-DOOR IS OPEN)
	(SOUTH	TO MENS-QUARTERS IF MENS-QUARTERS-DOOR IS OPEN)
	(GLOBAL AIR-SUPPLY-SYSTEM-GLOBAL
		WOMENS-QUARTERS-DOOR MENS-QUARTERS-DOOR)
	;(LINE 2)
	;(STATION OUTSIDE-DORM)
	(CORRIDOR *6400*)
	(ACTION OUTSIDE-DORM-F)>

<ROUTINE OUTSIDE-DORM-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<FROM-HERE ,P?WEST ,P?SOUTH ;"dorm">)>>

<ROUTINE FROM-HERE (DIR1 DIR2 ;PLACE)
	<TELL "From here, you can go ">
	<DIR-PRINT .DIR1 <>>
	<TELL " or ">
	<DIR-PRINT .DIR2 <>>
	<TELL " into the building." CR>>

<OBJECT WOMENS-QUARTERS-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE RED)
	(SYNONYM DOOR)
	(DESC "red door")
	(FLAGS DOORBIT)>

<ROOM WOMENS-QUARTERS
	(IN ROOMS)
	(DESC "female dorm" ;" living quarters")
	(ADJECTIVE FEMALE ;LIVING)
	(SYNONYM DORM DORMITORY ;QUARTERS AREA ROOM)
	(FLAGS RLANDBIT ONBIT)
	(EAST	TO OUTSIDE-DORM IF WOMENS-QUARTERS-DOOR IS OPEN)
	(OUT	TO OUTSIDE-DORM IF WOMENS-QUARTERS-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR WOMENS-QUARTERS-DOOR)
	;(LINE 2)
	;(STATION DORM)
	(ACTION WOMENS-QUARTERS-F)>

<ROUTINE WOMENS-QUARTERS-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<QUARTERS-F ,WOMENS-QUARTERS "On each side">)>>

<OBJECT WOMENS-FURNITURE
	(IN WOMENS-QUARTERS)
	(DESC "furniture")
	(ADJECTIVE COMMANDER ZOE\'S BLY\'S AMY\'S LOWELL)
	(SYNONYM TABLE BUNK BED LOCKER)
	(FLAGS SURFACEBIT NDESCBIT)
	(CAPACITY 13)
	(GENERIC GENERIC-FURNITURE-F)
	(ACTION RANDOM-PSEUDO)>

<ROUTINE GENERIC-FURNITURE-F (OBJ)
 <COND (,SUB-IN-TANK ,WORKBENCH) (T ,HORVAK-LOCKER)>>

<OBJECT MENS-QUARTERS-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE BLUE)
	(SYNONYM DOOR)
	(DESC "blue door")
	(FLAGS DOORBIT)>
[
<ROOM MENS-QUARTERS
	(IN ROOMS)
	(DESC "male dorm" ;" living quarters")
	(ADJECTIVE MALE ;LIVING)
	(SYNONYM DORM DORMITORY ;QUARTERS AREA ROOM)
	(FLAGS RLANDBIT ONBIT)
	(OUT	TO OUTSIDE-DORM IF MENS-QUARTERS-DOOR IS OPEN)
	(NORTH	TO OUTSIDE-DORM IF MENS-QUARTERS-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR MENS-QUARTERS-DOOR)
	;(LINE 2)
	;(STATION DORM)
	(ACTION MENS-QUARTERS-F)>

<ROUTINE MENS-QUARTERS-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<QUARTERS-F ,MENS-QUARTERS "In each corner">)>>

<ROUTINE QUARTERS-F (RM STR)
	<TELL
"You're in the " D .RM ". " .STR " of the room is a
bunk and locker. In the center of the room are a table and chairs." CR>>

<OBJECT MENS-FURNITURE
	(IN MENS-QUARTERS)
	(DESC "furniture")
	(ADJECTIVE DOC\'S ;WALT\'S HORVAK MARV\'S SIEGEL
		   MICK\'S ANTRIM BILL\'S GREENUP)
	(SYNONYM TABLE BUNK BED FURNITURE ;LOCKER)
	(FLAGS SURFACEBIT NDESCBIT)
	(CAPACITY 13)
	(GENERIC GENERIC-FURNITURE-F)
	(ACTION RANDOM-PSEUDO)>

<OBJECT MENS-LOCKER
	(IN MENS-QUARTERS)
	(DESC "other locker")
	(ADJECTIVE OTHER MARV\'S SIEGEL
		   MICK\'S ANTRIM BILL\'S GREENUP)
	(SYNONYM LOCKER)
	(FLAGS VOWELBIT NDESCBIT)
	(GENERIC GENERIC-FURNITURE-F)
	(ACTION RANDOM-PSEUDO)>

<OBJECT HORVAK-LOCKER
	(IN MENS-QUARTERS)
	(DESC "Horvak's locker")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK DORM DORMITORY)
	(SYNONYM LOCKER)
	(FLAGS CONTBIT SEARCHBIT LOCKED NDESCBIT NARTICLEBIT)
	(CAPACITY 13)
	(GENERIC GENERIC-FURNITURE-F)
	(ACTION HORVAK-LOCKER-F)>

<ROUTINE HORVAK-LOCKER-F ()
 <COND (<AND <VERB? LOOK-INSIDE> <FSET? ,HORVAK-LOCKER ,OPENBIT>>
	%<XTELL
"The locker contains mostly clothing, toilet articles and books.">
	<COND (<IN? ,DIARY ,HORVAK-LOCKER>
	       <TELL " One of the books is labeled DIARY.">
	       <COND (<IN? ,PHOTO ,DIARY>
		      <FCLEAR ,PHOTO ,INVISIBLE>
		      <TELL
" Something has been inserted between its pages.">)>)>
	<CRLF>)
       (<AND <VERB? OPEN OPEN-WITH UNLOCK> <DOBJ? HORVAK-LOCKER>>
	<COND (<FSET? ,HORVAK-LOCKER ,OPENBIT> <RFALSE>)
	      (<AND <FSET? ,HORVAK-LOCKER ,LOCKED>
		    <NOT <IOBJ? UNIVERSAL-TOOL>>>
	       <THIS-IS-IT ,HORVAK-KEY>
	       %<XTELL
"It's locked. The normal way to open its lock (which you yourself designed, " FN ") is with a key." CR>
	       <RTRUE>)>
	<FCLEAR ,HORVAK-LOCKER ,LOCKED>
	<FSET ,HORVAK-LOCKER ,OPENBIT>
	<FSET ,DIARY ,TAKEBIT>
	<PERFORM ,V?LOOK-INSIDE ,HORVAK-LOCKER>
	<RTRUE>)>>

<OBJECT HORVAK-KEY
	(IN GLOBAL-OBJECTS ;HORVAK)
	(DESC "Horvak's key")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK LOCKER)
	(SYNONYM KEY)
	(FLAGS TOOLBIT NDESCBIT NARTICLEBIT)
	(ACTION HORVAK-KEY-F)>

<ROUTINE HORVAK-KEY-F ()
 <COND (<OR <AND <IOBJ? HORVAK> <VERB? TAKE>>
	    <AND <DOBJ? HORVAK> <VERB? ASK-FOR SEARCH-FOR>>>
	<COND (<==? ,WINNER ,PLAYER>
	       %<XTELL
"Be warned, " FN ", that he will never willingly surrender it.
You have no right to demand it without a search warrant.
The " D ,AQUADOME " is neither a military establishment
nor a ship at sea, so you could get in legal trouble." CR>)
	      (T
	       <HE-SHE-IT ,WINNER T "refuse">
	       %<XTELL
", " FN ". Do not pursue this any further, or you will lose the
respect and cooperation of the " D ,CREW ", and thereby abort your rescue
mission. If you attempt to use force, they may even mutiny and place you
under arrest." CR>)>)>>

<OBJECT DIARY
	(IN HORVAK-LOCKER)
	(DESC "diary")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK)
	(SYNONYM DIARY)
	(FLAGS ;TAKEBIT CONTBIT SEARCHBIT READBIT)
	(CAPACITY 5)
	(ACTION DIARY-F)>

<ROUTINE DIARY-F ()
 <COND (<AND <VERB? OPEN> <NOT <FSET? ,DIARY ,OPENBIT>> <IN? ,PHOTO ,DIARY>>
	;<ENABLE <QUEUE I-TIP-SONAR-PLAN -1>>
	<FSET ,DIARY ,OPENBIT>
	<MOVE ,PHOTO ,HERE>
	%<XTELL
"As you do so, a picture falls out. Oh, oh! It's a snapshot of Zoe Bly!" CR>)
       (<VERB? READ LOOK-INSIDE>
	<COND (<NOT <FSET? ,DIARY ,OPENBIT>>
	       %<XTELL "You must open it first." CR>)
	      (T %<XTELL
"You quickly discover references to Zoe Bly. It seems clear that "
D ,HORVAK " has fallen for Zoe. But her unsentimental manner is a
large obstacle.|
The last entry reads:|
\"If only I could find some way to break down that icy reserve of Zoe's,
and make her realize she's not just a scientific thinking machine or a
commanding officer...!|
There must be some way! She doesn't do everything by the rule book.
She even breaks regulations at times. If I can prove this and embarrass her,
maybe she'll realize she's just a human being like the rest of us -- and not
only a human being, but a warm, desirable woman...!\"|
">
	       <COND (<FSET? ,SPECIAL-TOOL ,TOUCHBIT>	;,DOME-AIR-CRIME
		      <TELL "|
Well! Sounds as if " D ,HORVAK " found the answer to his problem
by sabotaging the " D ,AIR-SUPPLY-SYSTEM " -- at a time when " D ,BLY
" was breaking regulations by not wearing her " D ,OXYGEN-GEAR
"!" CR>)>
	       <RTRUE>)>)>>

<OBJECT PHOTO
	(IN DIARY)
	(DESC "photograph")
	(ADJECTIVE ;ZOE ZOE\'S BLY\'S ;DOC DOC\'S ;WALT WALT\'S HORVAK)
	(SYNONYM PHOTO PHOTOGRAPH PICTURE SNAPSHOT)
	(FLAGS TAKEBIT ;INVISIBLE)
	(SIZE 1)
	(ACTION PHOTO-F)>

<ROUTINE PHOTO-F ()
 <COND (<VERB? ANALYZE EXAMINE ;READ TELL-ABOUT>
	<TELL "It's a " D ,PHOTO " of " D ,BLY "." CR>)>>
]
<ROOM OUTSIDE-WORKSHOP
	(IN ROOMS)
	(DESC "northwest deck")
	(ADJECTIVE NW WORKSHOP LAB LABORATORY)
	(SYNONYM DECK PORCH ENTRANCE)
	(FLAGS RLANDBIT ONBIT)
	(EAST	TO OUTSIDE-COMM-BLDG)
	(SOUTH	TO OUTSIDE-DORM)
	(SE	TO CENTER-OF-DOME)
	(NORTH	TO DOME-LAB IF DOME-LAB-DOOR IS OPEN)
	(WEST	TO WORKSHOP IF WORKSHOP-DOOR IS OPEN)
	(GLOBAL AIR-SUPPLY-SYSTEM-GLOBAL WORKSHOP-DOOR DOME-LAB-DOOR)
	;(LINE 3)
	;(STATION OUTSIDE-WORKSHOP)
	(CORRIDOR *14200*)
	(ACTION OUTSIDE-WORKSHOP-F)>

<ROUTINE OUTSIDE-WORKSHOP-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<FROM-HERE ,P?WEST ,P?NORTH ;"building">)>>

<OBJECT WORKSHOP-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE WORKSHOP)
	(SYNONYM DOOR)
	(DESC "workshop door")
	(FLAGS DOORBIT OPENBIT)>

<ROOM WORKSHOP
	(IN ROOMS)
	(DESC "workshop")
	(ADJECTIVE WORK)
	(SYNONYM WORKSHOP SHOP AREA ROOM)
	(FLAGS RLANDBIT ONBIT)
	(OUT	TO OUTSIDE-WORKSHOP IF WORKSHOP-DOOR IS OPEN)
	(EAST	TO OUTSIDE-WORKSHOP IF WORKSHOP-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR WORKSHOP-DOOR)
	;(LINE 3)
	;(STATION WORKSHOP)
	(ACTION WORKSHOP-F)>

<ROUTINE WORKSHOP-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"The " D ,WORKSHOP " is equipped for mechanical repair work.
It contains assorted hand tools, machine tools, and spare parts." CR>)>>

<OBJECT WORKSHOP-STUFF
	(IN WORKSHOP)
	(ADJECTIVE ASSORTED HAND MACHIN SPARE WORKSHOP)
	(SYNONYM TOOL ;TOOLS ;PART PARTS MATERIAL)
	(DESC "workshop material")
	(FLAGS NDESCBIT)
	(GENERIC GENERIC-TOOL-F)
	(ACTION WORKSHOP-STUFF-F)>

<ROUTINE WORKSHOP-STUFF-F ()
 <COND (<VERB? MAKE>
	%<XTELL
"That's too difficult, even for a famous young inventor." CR>)>>

<OBJECT DOME-LAB-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE LABORATORY)
	(SYNONYM DOOR)
	(DESC "laboratory door")
	(FLAGS DOORBIT OPENBIT)>

<ROOM DOME-LAB
	(IN ROOMS)
	(DESC "Aquadome laboratory")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK AQUADOME DOME)
	(SYNONYM LAB LABORATORY)
	(GENERIC GENERIC-LABORATORY-F)
	(FLAGS RLANDBIT ONBIT ;NARTICLEBIT VOWELBIT)
	(OUT	TO OUTSIDE-WORKSHOP IF DOME-LAB-DOOR IS OPEN)
	(SOUTH	TO OUTSIDE-WORKSHOP IF DOME-LAB-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR DOME-LAB-DOOR)
	(PSEUDO "EQUIPM" RANDOM-PSEUDO "SUPPLIES" RANDOM-PSEUDO)
	(ACTION DOME-LAB-F)
	;(LINE 3)
	;(STATION WORKSHOP)>

<GLOBAL HORVAK-TOLD-AH <>>
<ROUTINE DOME-LAB-F ("OPTIONAL" (RARG <>) MAGLOC)
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"The " D ,DOME-LAB " is equipped for all sorts of marine biochemical
research. ">
	<ROOM-IS-CROWDED>)
       (<AND <EQUAL? .RARG ,M-ENTER>
	     <NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>>
	<COND (<NOT <IN? ,BLY ,DOME-LAB>>
	       <MOVE ,BLY ,DOME-LAB>
	       <TELL D ,BLY " comes too." CR>)>
	<COND (<AND <NOT <FSET? ,HORVAK ,BUSYBIT>>
		    <NOT <IN? ,HORVAK ,DOME-LAB>>>
	       <MOVE ,HORVAK ,DOME-LAB>
	       <TELL D ,HORVAK " comes too." CR>)>
	<COND (<OR ,HORVAK-TOLD-AH
		   <NOT <FSET? ,DART ,MUNGBIT>>
		   <FSET? ,HORVAK ,BUSYBIT>>
	       <RTRUE>)>
	<SETG HORVAK-TOLD-AH T>
	%<XTELL CR
D ,HORVAK " says:|
\"" FN ", right after the Snark ceased
its attack, I detected a high concentration of AH molecules in the
" D ,GLOBAL-WATER " around the " D ,AQUADOME ". Have you ever heard of such a
phenomenon before?\"">
	<COND (<NOT <YES?>>
	       %<XTELL
"\"I can make up an intense tranquilizer to subdue the " D ,SNARK ",\" "
D ,HORVAK " continues. \"You could use one of our aquatic dart
guns to inject it into the creature. You could mount the gun
on one of the " D ,SUB "'s " D ,CLAW "s.|
But without knowing the creature's biochemistry, there's no guarantee the
'trank' will work. Shall I go ahead and make some up, anyhow?\"">
	       <YES?>)>
	<SET MAGLOC <META-LOC ,MAGAZINE>>
	<COND (<NOT <IN-DOME? .MAGLOC>> <RTRUE>)>
	<TIP-SAYS>
	%<XTELL
"Wait a minute! Wasn't there something about AH
molecules in that " D ,MAGAZINE "? Shall ">
	<COND (<EQUAL? .MAGLOC ,HERE>
	       <TELL "we">)
	      (T
	       <TELL "I get it and">)>
	<TELL " see?\"">
	<THIS-IS-IT ,MAGAZINE>
	<COND (<YES?>
	       <COND (<NOT <IN? ,MAGAZINE ,PLAYER>>
		      <MOVE ,MAGAZINE ,PLAYER>
		      <TELL "Tip ">
		      <COND (<NOT <EQUAL? .MAGLOC ,HERE>>
			     %<XTELL "returns quickly and ">)>
		      <TELL "hands you the magazine. ">)>
	       <THIS-IS-IT ,HORVAK>
	       <TELL
D ,HORVAK " looks interested. \"I'd like to see that.\"" CR>)>
	<RTRUE>)>>

<ROOM OUTSIDE-COMM-BLDG
	(IN ROOMS)
	(DESC ;"comm bldg" "northeast deck")
	(ADJECTIVE NE COMM COMMUN BLDG BUILDI GALLEY)
	(SYNONYM DECK PORCH ENTRANCE)
	(FLAGS RLANDBIT ONBIT)
	(WEST	TO OUTSIDE-WORKSHOP)
	(SOUTH	TO OUTSIDE-ADMIN-BLDG)
	(SW	TO CENTER-OF-DOME)
	(NORTH	TO COMM-BLDG IF COMM-BLDG-DOOR IS OPEN)
	(EAST	TO GALLEY IF GALLEY-DOOR IS OPEN)
	(GLOBAL AIR-SUPPLY-SYSTEM-GLOBAL COMM-BLDG-DOOR GALLEY-DOOR)
	;(LINE 3)
	;(STATION OUTSIDE-COMM-BLDG)
	(CORRIDOR *30400*)
	(ACTION OUTSIDE-COMM-BLDG-F)>

<ROUTINE OUTSIDE-COMM-BLDG-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<FROM-HERE ,P?EAST ,P?NORTH ;"building">)>>

<OBJECT COMM-BLDG-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE COMM COMMUN CENTER CENTRE)
	(SYNONYM DOOR)
	(DESC "comm center door")
	(FLAGS DOORBIT OPENBIT)>

<ROOM COMM-BLDG
	(IN ROOMS)
	(DESC "comm center")
	(ADJECTIVE COMM COMMUN SONAR)
	(SYNONYM CENTER CENTRE ;"BLDG BUILDI" AREA ROOM)
	(FLAGS RLANDBIT ONBIT)
	(OUT	TO OUTSIDE-COMM-BLDG IF COMM-BLDG-DOOR IS OPEN)
	(SOUTH	TO OUTSIDE-COMM-BLDG IF COMM-BLDG-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR COMM-BLDG-DOOR
		TEST-BUTTON CONTROLS VIDEOPHONE VIDEOPHONE-2 ALARM)
	(GENERIC GENERIC-CENTER-F)
	;(LINE 3)
	;(STATION COMM-BLDG)
	(ACTION COMM-BLDG-F)>

<ROUTINE COMM-BLDG-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"The " D ,COMM-BLDG " has both a " D ,VIDEOPHONE " for
communicating with other places and the " D ,SONAR-EQUIPMENT " for
detecting objects in the " D ,GLOBAL-WATER " around the dome." CR>)>>

<OBJECT SONAR-EQUIPMENT
	(IN COMM-BLDG)
	(DESC "Aquadome sonar equipment")
	(ADJECTIVE AQUADOME SONAR)
	(SYNONYM SONAR SYSTEM EQUIPM SCREEN ;TRANSDUCER)
	(FLAGS SURFACEBIT ;CONTBIT OPENBIT ONBIT ;ON?BIT VOWELBIT NDESCBIT NARTICLEBIT)
	(CAPACITY 19)
	(ACTION SONAR-EQUIPMENT-F)>

<ROUTINE SONAR-EQUIPMENT-F ()
 <COND ;(<VERB? LAMP-ON> <ALREADY ,SONAR-EQUIPMENT "on">)
       (<VERB? LAMP-OFF> <TELL "It should stay on all the time." CR>)
       (<VERB? ANALYZE EXAMINE READ LOOK-INSIDE LOOK-ON TELL-ABOUT>
	<TELL
"The " D ,SONAR-EQUIPMENT " detects objects in the " D ,GLOBAL-WATER "
near the " D ,AQUADOME "." CR>)
       (<AND <VERB? TIE-TO> <IOBJ? SONAR-EQUIPMENT>>
	<PERFORM ,V?PUT ,PRSO ,PRSI>
	<RTRUE>)>>

<OBJECT MICROPHONE-DOME
	(IN SONAR-EQUIPMENT)
	(ADJECTIVE ;VIDEO ;YOUR HAND)
	(SYNONYM MIKE ;VIDEOPHONE ;PHONE MICROPHONE)
	(DESC "microphone" ;"hand mike")
	(FLAGS TAKEBIT ON?BIT NDESCBIT)
	(GENERIC GENERIC-MICROPHONE-F)
	(ACTION MICROPHONE-DOME-F)>

<ROUTINE MICROPHONE-DOME-F () <MICROPHONE-F T>>

<OBJECT GALLEY-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE GALLEY)
	(SYNONYM DOOR)
	(DESC "galley door")
	(FLAGS DOORBIT OPENBIT)>

<ROOM GALLEY
	(IN ROOMS)
	(DESC "galley")
	(SYNONYM GALLEY MESS)
	(FLAGS RLANDBIT ONBIT)
	(OUT	TO OUTSIDE-COMM-BLDG IF GALLEY-DOOR IS OPEN)
	(WEST	TO OUTSIDE-COMM-BLDG IF GALLEY-DOOR IS OPEN)
	(GLOBAL WINDOW CHAIR GALLEY-DOOR)
	;(LINE 3)
	;(STATION COMM-BLDG)
	(ACTION GALLEY-F)>

<ROUTINE GALLEY-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"This room serves as both galley and mess;
the crew can both prepare food and eat it here." CR>)>>

<ROOM OUTSIDE-ADMIN-BLDG
	(IN ROOMS)
	(DESC ;"admin bldg" "southeast deck")
	(ADJECTIVE SE ADMIN ADMINI BLDG BUILDI OFFICE STORAGE)
	(SYNONYM DECK PORCH ENTRANCE)
	(FLAGS RLANDBIT ONBIT)
	(WEST	TO FOOT-OF-RAMP)
	(NORTH	TO OUTSIDE-COMM-BLDG)
	(NW	TO CENTER-OF-DOME)
	(EAST	TO BLY-OFFICE IF BLY-DOOR IS OPEN)
	(SOUTH	TO DOME-STORAGE IF DOME-STORAGE-DOOR IS OPEN)
	(GLOBAL BLY-DOOR DOME-STORAGE-DOOR AIR-SUPPLY-SYSTEM-GLOBAL)
	;(LINE 2)
	;(STATION OUTSIDE-ADMIN-BLDG)
	(CORRIDOR *22200*)
	(ACTION OUTSIDE-ADMIN-BLDG-F)>

<ROUTINE OUTSIDE-ADMIN-BLDG-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<FROM-HERE ,P?EAST ,P?SOUTH ;"building">)>>

<OBJECT BLY-DOOR
	(IN LOCAL-GLOBALS)
	(ADJECTIVE ;ZOE ZOE\'S BLY\'S AQUADOME DOME OFFICE)
	(SYNONYM DOOR)
	(DESC "office door")
	(FLAGS DOORBIT VOWELBIT)>
[
<ROOM BLY-OFFICE
	(IN ROOMS)
	(DESC "Aquadome office")
	(ADJECTIVE ;ZOE ZOE\'S BLY\'S AQUADOME DOME ;YOUR)
	(SYNONYM OFFICE)
	(FLAGS RLANDBIT ONBIT ;NARTICLEBIT VOWELBIT)
	(WEST	TO OUTSIDE-ADMIN-BLDG IF BLY-DOOR IS OPEN)
	(OUT	TO OUTSIDE-ADMIN-BLDG IF BLY-DOOR IS OPEN)
	;(LINE 2)
	;(STATION ADMIN-BLDG)
	(GLOBAL BLY-DOOR AIR-SUPPLY-SYSTEM-GLOBAL WINDOW CHAIR
		OPEN-GATE-BUTTON FILL-TANK-BUTTON)
	(GENERIC GENERIC-OFFICE-F)
	(ACTION BLY-OFFICE-F)>

<GLOBAL ZOE-MENTIONED-EVIDENCE <>>
<ROUTINE BLY-OFFICE-F ("OPTIONAL" (ARG <>))
 <COND (<==? .ARG ,M-LOOK>
	<TELL
"The " D ,BLY-OFFICE " is small but tidy, with a single door leading out
and a good view of the ocean through the " D ,WINDOW "." CR>)
       (<AND <==? .ARG ,M-ENTER>
	     <NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>>
	<COND (<AND <IN? ,BLY ,BLY-OFFICE>
		    <NOT ,GREENUP-ESCAPE>
		    <NOT ,GREENUP-TRAPPED>
		    <NOT ,GREENUP-CUFFED>
		    <NOT ,ZOE-MENTIONED-EVIDENCE>>
	       <FCLEAR ,BLY ,NDESCBIT>
	       %<XTELL "As you enter the office, ">
	       <ZOE-MENTIONS-EVIDENCE>)
	      (<AND ,GREENUP-ESCAPE <NOT <IN? ,BLY ,BLY-OFFICE>>>
	       <MOVE ,BLY ,BLY-OFFICE>
	       %<XTELL "Zoe comes with you." CR>)>)
       (<AND <==? .ARG ,M-BEG> <EXIT-VERB?>>
	<COND (,GREENUP-ESCAPE
	       <HE-SHE-IT ,WINNER T>
	       %<XTELL "'d better stay here and trap Greenup." CR>)
	      (<AND <FSET? ,SPECIAL-TOOL ,INVISIBLE> <==? ,WINNER ,PLAYER>>
	       <TELL "As you start to leave, you notice">
	       <SPECIAL-TOOL-VISIBLE>)>)
       (<AND <VERB? SEARCH SEARCH-FOR> <FSET? ,SPECIAL-TOOL ,INVISIBLE>>
	<TELL "You find">
	<SPECIAL-TOOL-VISIBLE>)>>

<ROUTINE SPECIAL-TOOL-VISIBLE ()
	<FCLEAR ,SPECIAL-TOOL ,INVISIBLE>
	<FSET ,SPECIAL-TOOL ,TOUCHBIT>
	<REMOVE ,SPECIAL-TOOL-GLOBAL>
	<THIS-IS-IT ,SPECIAL-TOOL>
	%<XTELL
" an oddly shaped metallic object lying under Zoe's desk. It must
be the " D ,SPECIAL-TOOL "!" CR>>

<ROUTINE ZOE-MENTIONS-EVIDENCE ()
	<SETG ZOE-MENTIONED-EVIDENCE T>
	<MOVE ,TRAITOR ,GLOBAL-OBJECTS>
	;<FCLEAR ,EVIDENCE ,INVISIBLE>
	<THIS-IS-IT ,EVIDENCE>
	<ENABLE <QUEUE I-BLY-SAYS 6>>
	<SAID-TO ,BLY>
	<TELL "Zoe">
	<COND (<FSET? ,BLY-DOOR ,OPENBIT>
	       <FCLEAR ,BLY-DOOR ,OPENBIT>
	       <TELL " closes the door and">)>
	%<XTELL " says:|
\"There's a " D ,TRAITOR " here at the " D ,AQUADOME ", " FN "!">
	<COND (,DOME-AIR-CRIME
	       %<XTELL
" I'm not saying that just because the " D ,AIR-SUPPLY-SYSTEM
" had been sabotaged.">)>
	<TELL " I discovered "
	      <COND (,DOME-AIR-CRIME "other ") (T "the ")>
	      D ,EVIDENCE " after we talked on the " D ,VIDEOPHONE
	      "!\"" CR>>

<OBJECT BLY-DESK
	(IN BLY-OFFICE)
	(ADJECTIVE ;ZOE ZOE\'S BLY\'S DESK)
	(SYNONYM DESK DRAWER)
	(DESC "Bly's desk")
	(FLAGS NDESCBIT CONTBIT SEARCHBIT NARTICLEBIT)
	(CAPACITY 99)
	(GENERIC GENERIC-DESK-F)
	(ACTION BLY-DESK-F)>

<ROUTINE BLY-DESK-F ()
 <COND (<VERB? LOOK-UNDER>
	<COND (<NOT <FSET? ,SPECIAL-TOOL ,TOUCHBIT>>
	       <TELL "There's">
	       <SPECIAL-TOOL-VISIBLE>
	       ;<RFALSE>)>)>>

<OBJECT BLACK-BOX
	;(IN BLY-DESK)
	(DESC "black box")
	(ADJECTIVE	SMALL ELECTR BLACK BOX)
	(SYNONYM	COVER BOX DEVICE)
	(FLAGS TAKEBIT CONTBIT SEARCHBIT)
	(CAPACITY 3)
	(SIZE 5)
	(ACTION BLACK-BOX-F)>

<GLOBAL BLACK-BOX-EXAMINED <>>
<ROUTINE BLACK-BOX-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE>
	<COND (<FSET? ,BLACK-BOX ,OPENBIT>
	       <SETG BLACK-BOX-EXAMINED T>
	       %<XTELL
"After a brief study of the " D ,BLACK-CIRCUITRY
", you deduce its purpose: it was
designed to change the sonar output so the ultrasonic pulses make a more
complex pattern (for example BURPETY-BURP-B'DURP) instead of just a simple,
clear-cut BURP. This would also make fuzzier blips." CR>)
	      (T %<XTELL
"You'll need a suitable tool to open its cover." CR>)>)
       (<VERB? OPEN OPEN-WITH>
	<COND (<FSET? ,BLACK-BOX ,OPENBIT>
	       <ALREADY ,BLACK-BOX "open">)
	      (<IOBJ? UNIVERSAL-TOOL>
	       <OKAY ,BLACK-BOX "open">)
	      (T
	       <TELL "You can't open it with">
	       <COND (,PRSI <TELL THE-PRSI>) (T <TELL " your bare hands">)>
	       <TELL "!" CR>)>)>>

<OBJECT BLACK-CIRCUITRY
	(IN BLACK-BOX)
	(DESC "circuit")
	(SYNONYM CIRCUIT)
	(ACTION BLACK-CIRCUITRY-F)>

<ROUTINE BLACK-CIRCUITRY-F ()
 <COND (<DIVESTMENT? ,BLACK-CIRCUITRY>
	<PERFORM ,PRSA ,BLACK-BOX ,PRSI>
	<RTRUE>)>>

<OBJECT STATION-MONITOR
	(DESC "station monitor")
	(IN BLY-OFFICE)
	(ADJECTIVE	STATION)
	(SYNONYM	MONITOR)
	(FLAGS NDESCBIT ONBIT)
	(ACTION STATION-MONITOR-F)>

<ROUTINE STATION-MONITOR-F ()
 <COND (<VERB? ANALYZE EXAMINE READ>
	<COND (,GREENUP-ESCAPE
	       <ENABLE <QUEUE I-GREENUP-ESCAPE -1>>
	       <COND (<EQUAL? ,GREENUP-ESCAPE 1>
		      %<XTELL
"The monitor screen shows Greenup's head just coming into view
above the top of the " D ,AIRLOCK
"'s west wall, as he climbs the outside ladder.|
">
		      <COND (<NOT <FSET? ,AIRLOCK-ROOF ,OPENBIT>>
			     %<XTELL
"But since the " D ,AIRLOCK-ROOF " is closed,
Greenup can't get into the " D ,SUB " to escape. ">
			     <GREENUP-CUFF>
			     <RTRUE>)
			    (T <TELL
"Once he reaches the top of this wall, he will come down the inside
ladder to the " D ,SUB "." CR>)>)
		     (T <RTRUE>	;"output from I-GREENUP-ESCAPE")>)
	      (T %<XTELL
D ,BLY " uses this monitor to check on activities in the " D ,AQUADOME "."
CR>)>)>>

<OBJECT AIRLOCK-ELECTRICITY
	(DESC ;"airlock" "docking tank electricity")
	(IN BLY-OFFICE)
	(ADJECTIVE	DOCKING TANK AIRLOCK)
	(SYNONYM	ELECTR SUPPLY POWER)
	(FLAGS ;VOWELBIT NDESCBIT ON?BIT ONBIT)
	(ACTION AIRLOCK-ELECTRICITY-F)>

<ROUTINE AIRLOCK-ELECTRICITY-F ()
 <COND (<VERB? CUT>
	<PERFORM ,V?LAMP-OFF ,PRSO>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	<COND (<AND ,GREENUP-ESCAPE ;<G? 5 ,GREENUP-ESCAPE>>
	       <FCLEAR ,AIRLOCK-ELECTRICITY ,ONBIT>
	       %<XTELL
"Very good, " FN "! With the " D ,AIRLOCK-ELECTRICITY " off, the " D
,AIRLOCK-HATCH " won't respond to command signals from the " D ,SUB "
and will remain closed.|
">
	       <GREENUP-CUFF>
	       <RTRUE>)>)>>

<OBJECT CONTROLS-OFFICE
	(IN BLY-OFFICE)
	(DESC "docking tank control panel")
	(ADJECTIVE DOCKING TANK CONTROL)
	(SYNONYM CONTROL PANEL KNOB KNOBS)
	(FLAGS NDESCBIT)
	(ACTION CONTROLS-OFFICE-F)>

<ROUTINE CONTROLS-OFFICE-F ()
 <COND (<VERB? CUT LAMP-OFF>
	<PERFORM ,V?LAMP-OFF ,AIRLOCK-ELECTRICITY>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE READ>
	%<XTELL
"MAIN OPERATING CONTROLS:|
">
	<FIXED-FONT-ON>
	<TELL D ,AIRLOCK-ROOF ": "
	<COND (<FSET? ,AIRLOCK-ROOF ,OPENBIT> "open") (T "closed")> CR
	D ,FILL-TANK-BUTTON "     : " <TANK-STATUS> CR
	D ,OPEN-GATE-BUTTON "     : " <GATE-STATUS> CR>
	<FIXED-FONT-OFF>
	<RTRUE>)>>
]

<OBJECT DOME-STORAGE-DOOR 
	(IN LOCAL-GLOBALS)
	(ADJECTIVE STORAGE)
	(SYNONYM DOOR)
	(DESC "storage door")
	(FLAGS DOORBIT OPENBIT)>

<ROOM DOME-STORAGE
	(IN ROOMS)
	(DESC "storage room")
	(ADJECTIVE STORAGE SUPPLY)
	(SYNONYM ROOM AREA)
	(FLAGS RLANDBIT ONBIT)
	(NORTH	TO OUTSIDE-ADMIN-BLDG IF DOME-STORAGE-DOOR IS OPEN)
	(OUT	TO OUTSIDE-ADMIN-BLDG IF DOME-STORAGE-DOOR IS OPEN)
	;(LINE 2)
	;(STATION ADMIN-BLDG)
	(GLOBAL DOME-STORAGE-DOOR WINDOW AIR-SUPPLY-SYSTEM-GLOBAL)
	(PSEUDO "EQUIPM" RANDOM-PSEUDO "SUPPLIES" RANDOM-PSEUDO)
	(GENERIC GENERIC-STORAGE-ROOM-F)
	(ACTION DOME-STORAGE-F)>

<ROUTINE DOME-STORAGE-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<ROOM-IS-CROWDED>)>>

<ROUTINE ROOM-IS-CROWDED ()
	<TELL
"The room is crowded with supplies and equipment. If you
want to find something, you'll have to search for it." CR>>

<OBJECT ESCAPE-POD-UNIT
	(DESC "Emergency Survival Unit")	;"Escape Pod Ejector Unit"
	(IN DOME-STORAGE ;GLOBAL-OBJECTS)
	(ADJECTIVE	EMERGE SURVIVAL)
	(SYNONYM	UNIT ;KIT)
	(FLAGS CONTBIT SEARCHBIT ;OPENBIT VOWELBIT NDESCBIT TAKEBIT)
	(CAPACITY 1)
	;(FDESC
"The newly-installed Emergency Survival Unit is under the seats.")
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(VALUE 5)
	(ACTION ESCAPE-POD-UNIT-F)>

<ROUTINE I-CHECK-POD ()
 <COND (<AND <IN? ,SYRINGE ,ESCAPE-POD-UNIT> <FSET? ,SYRINGE ,MUNGBIT>>
	<COND (,SUB-IN-DOME <TELL-HINT 51 ;12 ,ESCAPE-POD-UNIT>)>
	<ENABLE <QUEUE I-CHECK-POD 7>>
	<RFALSE>)>>

<ROUTINE ESCAPE-POD-UNIT-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)
       ;(<NOT <IN? ,ESCAPE-POD-UNIT ,HERE>>
	<NOT-HERE ,ESCAPE-POD-UNIT>)
       (<IN? ,ESCAPE-POD-UNIT ,SUB>
	<COND (<VERB? ANALYZE EXAMINE>
	       %<XTELL
"A brief inspection under your seat leads to a horrifying discovery! A
body-heat sensor was substituted for the electronic monitor, and a wire
leads from the sensor to ">
		<COND (<IN? ,SYRINGE ,ESCAPE-POD-UNIT>
		       <TELL "the " D ,SYRINGE>)
		      (T <TELL "where the " D ,SYRINGE " was">)>
		<TELL ".|
Tip reports that the part under his seat appears to be okay.">
		<COND (<AND <FSET? ,SYRINGE ,MUNGBIT>
			    <IN? ,SYRINGE ,ESCAPE-POD-UNIT>>
		       <TELL
" \"But I sure don't like the looks of that " D ,SYRINGE " in YOUR part, "
FN "!\" he adds. \"Let's take it to " D ,HORVAK " to analyze it.\"">)>
		<CRLF>)
	      (<VERB? FIX>
	       <TELL "Maybe " D ,HORVAK " can do that." CR>)>)>>

<OBJECT SYRINGE
	(IN ESCAPE-POD-UNIT)
	(DESC "hypodermic syringe")
	(ADJECTIVE HYPO HYPODERMIC THIS)
	(SYNONYM SYRINGE CONTENTS NEEDLE)
	(FLAGS TAKEBIT WEAPONBIT)
	(SIZE 1)
	;(TEXT "It's hard to tell anything by just looking at it.")
	(ACTION SYRINGE-F)>

<ROUTINE SYRINGE-F ()
 <COND (<DOBJ? SYRINGE>
	<COND (<VERB? ANALYZE EXAMINE FIX>
	       <TELL "Maybe " D ,HORVAK " can do that." CR>)
	      (<VERB? TAKE>
	       <FSET ,ESCAPE-POD-UNIT ,NDESCBIT>
	       <SETG TEST-BUTTON-READOUT ,TEST-BUTTON-NORMAL>
	       <RFALSE>)
	      (<AND <VERB? PUT> <IOBJ? ESCAPE-POD-UNIT>>
	       <FCLEAR ,ESCAPE-POD-UNIT ,NDESCBIT>
	       <SETG TEST-BUTTON-READOUT ,TEST-BUTTON-POD>
	       <RFALSE>)>)>>

<OBJECT FINE-GRID
	(IN DOME-STORAGE ;GLOBAL-OBJECTS)
	(DESC "fine grid")
	(ADJECTIVE FINE)
	(SYNONYM GRID GRIDS)
	(FLAGS NDESCBIT TAKEBIT)
	(ACTION FINE-GRID-F)>

<ROUTINE FINE-GRID-F ()
 <COND ;(<MOUNTING-VERB? ,FINE-GRID>
	<SHOULD-ASK ,TIP>
	<RTRUE>)
       (<VERB? FIND>
	<COND (,FINE-SONAR <TELL "It's installed in the " D ,SUB "." CR>)>)>>

<ROOM CENTER-OF-DOME
	(IN ROOMS)
	(DESC "dome center")
	(ADJECTIVE DOME)
	(SYNONYM CENTER CENTRE)
	(FLAGS RLANDBIT ONBIT)
	(NW	TO OUTSIDE-WORKSHOP)
	(NE	TO OUTSIDE-COMM-BLDG)
	(SW	TO OUTSIDE-DORM)
	(SE	TO OUTSIDE-ADMIN-BLDG)
	(SOUTH	TO FOOT-OF-RAMP)
	(GLOBAL AIR-SUPPLY-SYSTEM-GLOBAL)
	(GENERIC GENERIC-CENTER-F)
	(ACTION CENTER-OF-DOME-F)
	;(LINE 3)
	;(STATION CENTER-OF-DOME)
	(CORRIDOR *1600*)>

<ROUTINE CENTER-OF-DOME-F ("OPTIONAL" (ARG <>))
 <COND (<==? .ARG ,M-LOOK>
	<TELL
"You're in the very center of the " D ,AQUADOME ", where the " D
,AIR-SUPPLY-SYSTEM " rises like a tower, almost to the top of the dome
itself." CR>)
       ;(<==? .ARG ,M-BEG>
	<COND (<AND <VERB? RUB> <DOBJ? AIR>>
	       <TELL
"You can feel a definite outflow of air near the base of the cylinder.|
Oxygen and/or some other gas or gases is being generated, and
the blower is forcing this into the dome's atmosphere.|
But is this output good, breathable oxygen?" CR>)>)>>

<OBJECT AIR-SUPPLY-SYSTEM-GLOBAL
	(IN LOCAL-GLOBALS)
	(DESC "Air Supply System")
	(ADJECTIVE	AIR OXYGEN SUPPLY)
	(SYNONYM	SUPPLY SYSTEM CYLINDER HOUSING)
	(FLAGS VOWELBIT)
	(ACTION AIR-SUPPLY-SYSTEM-F)>

<OBJECT AIR-SUPPLY-SYSTEM
	(IN CENTER-OF-DOME)
	(DESC "Air Supply System")
	(ADJECTIVE	AIR OXYGEN SUPPLY)
	(SYNONYM	SUPPLY SYSTEM CYLINDER SIGN ;HOUSING)
	(FLAGS NDESCBIT VOWELBIT CONTBIT ;SEARCHBIT MUNGBIT READBIT)
	(CAPACITY 9)
	(VALUE 5)
	(ACTION AIR-SUPPLY-SYSTEM-F)>

<ROUTINE AIR-SUPPLY-SYSTEM-F ()
 <COND (<VERB? ANALYZE>
	<TELL "How do you propose to do that?" CR>)
       (<VERB? EXAMINE LOOK-INSIDE READ>
	<COND (<EQUAL? ,HERE ,CENTER-OF-DOME>
	       <COND (<FSET? ,ACCESS-PLATE ,OPENBIT>
		      <COND (<FSET? ,ELECTROLYTE-RELAY ,MUNGBIT>
			     <TELL
"You notice an " D ,EMPTY-SPACE " in the complicated assembly facing you.
Something has been unscrewed from this space!" CR>
			     <COND(<IN? ,ELECTROLYTE-RELAY ,AIR-SUPPLY-SYSTEM>
				   <THIS-IS-IT ,ELECTROLYTE-RELAY>
				   %<XTELL
"Something is lying at the base of the cylinder, just inside the
housing." CR>)>)
			    (T <TELL
"There's a lot of complicated machinery inside." CR>)>)
		     (T <TELL
"The first thing you notice is a stenciled sign saying: \"To repair "
D ,AIR-SUPPLY-SYSTEM ", first open " D ,ACCESS-PLATE " with "
D ,SPECIAL-TOOL " hanging on hook at right.\" An arrow points to this
hook." CR>)>)
	      (T <TOO-FAR-AWAY ,AIR-SUPPLY-SYSTEM>)>)
       (<VERB? FIND WALK-TO>
	<COND (<DOBJ? AIR-SUPPLY-SYSTEM-GLOBAL>
	       <PERFORM ,PRSA ,AIR-SUPPLY-SYSTEM ,PRSI>
	       <RTRUE>)>)
       (<VERB? FIX>
	<TELL
"How do you propose doing that, when you don't know what's wrong with it?"
CR>)
       (<VERB? OPEN OPEN-WITH CLOSE>
	<PERFORM ,PRSA ,ACCESS-PLATE ,PRSI>
	<RTRUE>)
       ;(<AND <VERB? TELL-ABOUT> <DOBJ? PLAYER>>
	<TELL
"May we suggest that the best way to find out about the system is to
examine it." CR>)>>

<ROUTINE AIR-SUPPLY-VERB? ()
 <COND (<VERB? GIVE FIND TAKE YELL-FOR>
	<COND (<DOBJ? UNIVERSAL-TOOL SPECIAL-TOOL SPECIAL-TOOL-GLOBAL
		      AIR-SUPPLY-SYSTEM AIR-SUPPLY-SYSTEM-GLOBAL>
	       <RTRUE>)>)
       (<VERB? SGIVE ASK-ABOUT ASK-FOR TELL-ABOUT>
	<COND (<IOBJ? UNIVERSAL-TOOL SPECIAL-TOOL SPECIAL-TOOL-GLOBAL
		      AIR-SUPPLY-SYSTEM AIR-SUPPLY-SYSTEM-GLOBAL>
	       <RTRUE>)>)>>

<OBJECT ACCESS-PLATE
	(IN CENTER-OF-DOME)
	(DESC "access door")
	(ADJECTIVE	ACCESS)
	(SYNONYM	DOOR PLATE PANEL)
	(FLAGS VOWELBIT NDESCBIT)
	(VALUE 5)
	(ACTION ACCESS-PLATE-F)>

<ROUTINE ACCESS-PLATE-F ()
 <COND (<VERB? EXAMINE>
	<COND (<FSET? ,ACCESS-PLATE ,OPENBIT> <TELL "It's open." CR>)
	      (T
	       <TELL
"It's held in place on the cylinder by curiously-shaped fram bolts, which
no ordinary wrench will fit.">
	       <COND (<NOT <FSET ,AIR-SUPPLY-SYSTEM ,TOUCHBIT>>
		      <TELL
" To open it, you need a " D ,SPECIAL-TOOL ", or something like it." CR>)>
	       <RTRUE>)>)
       (<VERB? LOOK-INSIDE>
	<PERFORM ,PRSA ,AIR-SUPPLY-SYSTEM ,PRSI>
	<RTRUE>)
       (<AND <VERB? CLOSE>>
	<COND (<FSET? ,ACCESS-PLATE ,OPENBIT>
	       <FCLEAR ,ACCESS-PLATE ,OPENBIT>
	       <OKAY ,AIR-SUPPLY-SYSTEM "closed">)
	      (T <ALREADY ,AIR-SUPPLY-SYSTEM "closed">)>)
       (<AND <VERB? OPEN OPEN-WITH TAKE-WITH>
	     <IOBJ? UNIVERSAL-TOOL SPECIAL-TOOL>>
	<COND (<FSET? ,ACCESS-PLATE ,OPENBIT>
	       <ALREADY ,ACCESS-PLATE "open">)
	      (T
	       <OKAY ,ACCESS-PLATE "open">
	       <FSET ,AIR-SUPPLY-SYSTEM ,OPENBIT>
	       <FSET ,AIR-SUPPLY-SYSTEM ,TOUCHBIT>
	       <PERFORM ,V?LOOK-INSIDE ,AIR-SUPPLY-SYSTEM>
	       <SCORE-OBJ ,AIR-SUPPLY-SYSTEM>
	       <RTRUE>)>)
       (<VERB? OPEN TAKE TAKE-WITH>
	<COND (<FSET? ,ACCESS-PLATE ,OPENBIT>
	       <ALREADY ,ACCESS-PLATE "open">)
	      (<IOBJ? SPECIAL-TOOL-GLOBAL> <NOT-HERE ,PRSI> <RTRUE>)
	      (T %<XTELL
"You can't remove" THE-PRSO " with your bare hands!" CR>)>)>>

<OBJECT HOOK
	(IN CENTER-OF-DOME)
	(DESC "special hook")
	(ADJECTIVE SPECIAL)
	(SYNONYM HOOK)
	(FLAGS SURFACEBIT NDESCBIT)
	(ACTION HOOK-F)>

<ROUTINE HOOK-F ()
 <COND (<NOT <FIRST? ,HOOK>>
	<COND (<VERB? EXAMINE LOOK-ON>
	       %<XTELL "There's nothing hanging on the " D ,HOOK "." CR>)
	      (<VERB? PUT>
	       <COND (<DOBJ? SPECIAL-TOOL ;UNIVERSAL-TOOL>
		      <MOVE ,PRSO ,HOOK>
		      <TELL "Okay." CR>)
		     (T <TELL "It won't fit on the " D ,HOOK "." CR>)>)>)
       (<VERB? EXAMINE LOOK-ON>
	%<XTELL "There's " A ,SPECIAL-TOOL " hanging on the " D ,HOOK"."CR>)>>

<OBJECT ARROW
	(IN CENTER-OF-DOME)
	(DESC "arrow")
	(SYNONYM ARROW)
	(FLAGS VOWELBIT NDESCBIT)
	(ACTION ARROW-F)>

<ROUTINE ARROW-F ()
 <COND (<VERB? FOLLOW> <TELL "It points to the hook." CR>)>>

<OBJECT SPECIAL-TOOL-GLOBAL
	(DESC "special Fram Bolt Wrench")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE SPECIAL FRAM BOLT)
	(SYNONYM ;TOOL WRENCH)>

<OBJECT SPECIAL-TOOL
	(DESC "special Fram Bolt Wrench")
	(IN BLY-OFFICE)
	(ADJECTIVE SPECIAL FRAM BOLT ODD ODDLY SHAPED METALLIC)
	(SYNONYM ;TOOL WRENCH OBJECT)
	(FLAGS TAKEBIT TOOLBIT INVISIBLE)
	(TEXT "It's stamped: \"AIR SUPPLY SYSTEM / Fram Bolt Wrench.\"")>

<OBJECT ELECTROLYTE-RELAY
	(IN AIR-SUPPLY-SYSTEM)
	(DESC "electrolyte relay")
	(ADJECTIVE	ELECTR MISSING SOME)
	(SYNONYM	RELAY OBJECT SOMETHING THING)
	(FLAGS TAKEBIT VOWELBIT MUNGBIT)
	(TEXT "It has screw threads.")
	(ACTION ELECTROLYTE-RELAY-F)>

<ROUTINE ELECTROLYTE-RELAY-F ()
 <COND (<VERB? TAKE>
	<COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       %<XTELL
"What!? You don't want to spoil the " D ,AIR-SUPPLY-SYSTEM " again!" CR>)>)
       (<REMOTE-VERB?> <RFALSE>)
       (<NOT-HOLDING? ,ELECTROLYTE-RELAY>
	<RTRUE>)
       (<AND <VERB? COMPARE>
	     <OR <AND <IOBJ? ELECTROLYTE-RELAY> <DOBJ? EMPTY-SPACE>>
		 <AND <DOBJ? ELECTROLYTE-RELAY> <IOBJ? EMPTY-SPACE>>>>
	<TELL
"It looks as if the " D ,ELECTROLYTE-RELAY " fits perfectly into the "
D ,EMPTY-SPACE "." CR>)
       (<VERB? EXAMINE>
	%<XTELL
"It has screw threads and, judging by its size and shape, it should
screw very neatly into that " D ,EMPTY-SPACE " in the "
D ,AIR-SUPPLY-SYSTEM " assembly." CR>)
       (<OR <AND <VERB? PUT SCREW> <IOBJ? AIR-SUPPLY-SYSTEM EMPTY-SPACE>>
	    <AND <VERB? SCREW-IN> <EQUAL? ,HERE ,CENTER-OF-DOME>>>
	<COND (<NOT <FSET? ,ACCESS-PLATE ,OPENBIT>>
	       <TOO-BAD-BUT ,ACCESS-PLATE "closed">
	       <RTRUE>)>
	<FIX-AIR-SUPPLY>
	%<XTELL
"It fits!" ;" (And, by the way, congratulations, ' FN '!)" CR>
	<SCORE-OBJ ,ACCESS-PLATE>
	<RTRUE>)>>

<ROUTINE FIX-AIR-SUPPLY ()
	<FCLEAR ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
	<REMOVE ,EMPTY-SPACE>
	<MOVE ,ELECTROLYTE-RELAY ,AIR-SUPPLY-SYSTEM>
	<FCLEAR ,ELECTROLYTE-RELAY ,TAKEBIT>
	<FSET ,ELECTROLYTE-RELAY ,NDESCBIT>
	<FCLEAR ,ELECTROLYTE-RELAY ,MUNGBIT>
	<PUTP ,ELECTROLYTE-RELAY ,P?TEXT "It's sitting neatly in place.">>

<OBJECT EMPTY-SPACE
	(IN AIR-SUPPLY-SYSTEM)
	(DESC "empty space")
	(ADJECTIVE	EMPTY)
	(SYNONYM	SPACE HOLE)
	(FLAGS VOWELBIT)
	(TEXT "It has screw threads.")
	(ACTION EMPTY-SPACE-F)>

<ROUTINE EMPTY-SPACE-F ()
 <COND (<AND <VERB? PUT> <IOBJ? EMPTY-SPACE>>
	<TELL
"Sorry, but" THE-PRSO " won't stay unless you screw it in." CR>)>>

<GLOBAL IN-DOME-AROUND
 <LTABLE FOOT-OF-RAMP OUTSIDE-ADMIN-BLDG OUTSIDE-COMM-BLDG OUTSIDE-WORKSHOP
	 OUTSIDE-DORM FOOT-OF-RAMP	;"preceding for WALK AROUND DOME"
	AIRLOCK AIRLOCK-WALL CENTER-OF-DOME BLY-OFFICE DOME-STORAGE
	COMM-BLDG GALLEY WORKSHOP DOME-LAB WOMENS-QUARTERS MENS-QUARTERS>>

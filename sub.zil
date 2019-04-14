"SUB for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<ROOM SUB
	(IN ROOMS)
	(DESC "SCIMITAR" ;"Ultramarine Bioceptor")
	(TEXT
"This is your revolutionary new Ultramarine Bioceptor, named the SCIMITAR.")
	(FLAGS RLANDBIT ONBIT ;VOWELBIT ;VEHBIT)
	(OUT	PER SUB-EXIT-F)
	;(UP	PER SUB-EXIT-F)
	(IN	TO CRAWL-SPACE IF ENGINE-ACCESS-HATCH IS OPEN)
	;(DOWN	TO CRAWL-SPACE IF ENGINE-ACCESS-HATCH IS OPEN)
	(GLOBAL LOCAL-SUB SUB-DOOR ENGINE-ACCESS-HATCH
		REACTOR-SWITCH FILL-TANK-BUTTON OPEN-GATE-BUTTON
		TEST-BUTTON ENGINE-BUTTON)
	(VALUE 1)
	(ACTION SUB-F)>

<ROUTINE SUB-EXIT-F ("AUX" X)
 <COND (<NOT <FSET? ,SUB-DOOR ,OPENBIT>>
	<THIS-IS-IT ,SUB-DOOR>
	<TELL "The " D ,SUB-DOOR " is closed." CR>
	<RFALSE>)
       (,SUB-IN-TANK
	<COND (<SET X <GET ,ON-SUB 0>> <MOVE .X ,NORTH-TANK-AREA>)>
	<COND (<SET X <GET ,ON-SUB 1>> <MOVE .X ,NORTH-TANK-AREA>)>
	,NORTH-TANK-AREA)
       (,SUB-IN-DOME
	<COND (,AIRLOCK-FULL
	       ;<YOU-CANT "leave" ,AIRLOCK "full of water">
	       <TELL
"You can't go out while the " D ,AIRLOCK " is full of water!" CR>
	       <RFALSE>)
	      (T
	       <COND (<AND <NOT ,DOME-AIR-BAD?>
			   <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
		      <ENABLE <QUEUE I-DOME-AIR ,DOME-AIR-ONSET>>
		      <COND (<NOT <IN? ,OXYGEN-GEAR ,PLAYER>>
			     <TELL-HINT 53 ;10 ,OXYGEN-GEAR <>>
			     <CRLF>)>)
		     ;"(T <ENABLE <QUEUE I-ANTRIM-REPORTS 29>>)">
	       <COND (<SET X <GET ,ON-SUB 0>> <MOVE .X ,AIRLOCK>)>
	       <COND (<SET X <GET ,ON-SUB 1>> <MOVE .X ,AIRLOCK>)>
	       <COND (<IN? ,MAGAZINE ,TIP>
		      ;<FCLEAR ,MAGAZINE ,NDESCBIT>
		      <MOVE ,MAGAZINE ,SUB>)>
	       <QUEUE I-POISON-JAB 0>
	       ,AIRLOCK)>)
       (T
	;<YOU-CANT "leave" ,SUB "here">
	<TELL "You can't go out of the " D ,SUB " here!" CR>
	<RFALSE>)>>

<ROUTINE DOCKING-VERB? ()
 <COND (<NOT <EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN ,SEA-TERRAIN>>
	<RFALSE>)
       (<VERB? DOCK> <RTRUE>)
       (<AND <VERB? WALK> <DOBJ? P?IN>> <RTRUE>)
       (<VERB? THROUGH WALK-TO>
	<COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
	       <COND (<DOBJ? TEST-TANK TANK-GATE YOUR-LABORATORY> <RTRUE>)
		     (T <RFALSE>)>)
	      (<DOBJ? DOCKING-TANK AIRLOCK AQUADOME AIRLOCK-HATCH> <RTRUE>)>)
       ;(T <RFALSE>)>>

<ROUTINE SOMEONE-WORKING? ()
	<COND (<NOT <0? <POPULATION ,CRAWL-SPACE ,PLAYER>>> <RTRUE>)
	      (<NOT <0? <POPULATION ,SUB ,TIP ,PLAYER>>> <RTRUE>)
	      ;(<AND <SET P <FIND-FLAG ,SUB ,PERSON ,WINNER>>
		    <NOT <EQUAL? .P ,TIP>>
		    ;<NOT <EQUAL? ,OLD-HERE ,CRAWL-SPACE>>>
	       <RTRUE>)>>

<ROUTINE CANT-GO-TO-THRU-CLOSED-HATCH? ("AUX" X)
	<SET X ,PRSO>
	<COND (<FSET? ,PRSO ,PERSON>
	       <SET X <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>)>
	<AND <NOT <GLOBAL-IN? ,PRSO ,SUB>>
	     <NOT <GLOBAL-IN? ,PRSO ,CRAWL-SPACE>>
	     <OR <EQUAL? .X ,DOCKING-TANK ,TEST-TANK>
		 <NOT <EQUAL? <META-LOC .X>
			      ,SUB ,CRAWL-SPACE ,GLOBAL-OBJECTS>>>
	     <NOT <SUB-EXIT-F>>>>

<ROUTINE SUB-F ("OPTIONAL" (RARG <>) "AUX" RM X)
 <COND (<EQUAL? .RARG ,M-BEG>
	<COND (<AND <OR ,SUB-IN-TANK ,SUB-IN-DOME>
		    <OR <VERB? LAUNCH>
			<AND <VERB? ;DROP LEAVE> <DOBJ? AIRLOCK TEST-TANK>>>>
	       <PERFORM ,V?LAMP-ON ,LOCAL-SUB>
	       <RTRUE>)
	      (<VERB? STAND> <TELL "There's no room in here!" CR>)
	      (<VERB? $CALL>
	       <COND (<DOBJ? SLOW MEDIUM FAST>
		      <PERFORM ,V?SET ,THROTTLE ,PRSO>
		      <RTRUE>)>)
	      (<AND <VERB? DISEMBARK LEAVE>
		    <OR <NOT ,PRSO> <DOBJ? LOCAL-SUB>>>
	       <COND (<SET RM <SUB-EXIT-F>>
		      <COND (<AND <GOTO .RM> <NOT <==? ,WINNER ,PLAYER>>>
			     <OKAY>)>)>
	       <RTRUE>)
	      (<DOCKING-VERB?>
	       <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
		      <TELL
"You can't go back to the " D ,TEST-TANK " now!" CR>)
		     (<NOT <SUB-OUTSIDE-AIRLOCK?>>
		      <TOO-BAD-BUT ,AIRLOCK "too far away">
		      ;<TELL "You're too far from the " D ,AIRLOCK "." CR>)
		     (<NOT <FSET? ,AIRLOCK-HATCH ,OPENBIT>>
		      <TOO-BAD-BUT ,AIRLOCK-HATCH "closed">
		      ;<TELL "The " D ,AIRLOCK-HATCH " is closed." CR>)
		     (T
		      <SETG THROTTLE-SETTING 1>
		      ;<COND (,DEBUG
			     <TELL "[Throttle=" N ,THROTTLE-SETTING "]" CR>)>
		      <SETG JOYSTICK-DIR ,P?NORTH>
		      ;<SETG SUB-IN-REVERSE? T>
		      <SETG SUB-DLON 0>
		      <SETG SUB-DLAT 1>
		      <RTRUE ;RFALSE>)>)
	      (<AND <NOT ,SUB-IN-DOME>
		    <VERB? FIND WALK-TO>
		    <DOBJ? LOCAL-SUB AQUADOME DOCKING-TANK>>
	       <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN ,SEA-TERRAIN>
		      <PERFORM ,V?FIND ,PLAYER>
		      <RTRUE>)>)
	      (<VERB? CLIMB-DOWN CLIMB-UP LEVEL>
	       <COND (<OR ,SUB-IN-TANK ,SUB-IN-DOME>
		      <TELL
"You can't do that while the " D ,SUB " is here." CR>
		      <RTRUE>)
		     (<VERB? LEVEL>
		      <SETG TARGET-DEPTH ,SUB-DEPTH>
		      <RTRUE>)	;"I-UPDATE-SUB should give output"
		     (<FSET? ,PRSO ,UNITBIT>
		      <COND (<VERB? CLIMB-DOWN>
			     <SETG P-NUMBER <+ <* 5 ,SUB-DEPTH> ,P-NUMBER>>)
			    (<VERB? CLIMB-UP>
			     <SETG P-NUMBER <- <* 5 ,SUB-DEPTH> ,P-NUMBER>>
			     <COND (<G? 0 ,P-NUMBER>
				    <TELL "You're not deep enough!" CR>
				    <RTRUE>)>)>
		      <PERFORM ,V?DIVE ,PRSO>
		      <RTRUE>)>)
	      (<VERB? WALK>
	       <COND (<DOBJ? UNDERWATER> <SETG PRSO ,P?DOWN>)>
	       <COND (<L? ,PRSO ,LOW-DIRECTION>
		      <V-WALK-AROUND>
		      <RTRUE>)>
	       <COND (<DOBJ? P?IN P?OUT>
		      <RFALSE>)>
	       <COND (<DOBJ? P?DOWN P?UP>
		      <SETG P-NUMBER 5>
		      <COND (<DOBJ? P?UP> <PERFORM ,V?CLIMB-UP ,METER>)
			    (T <PERFORM ,V?CLIMB-DOWN ,METER>)>
		      <RTRUE>)>
	       <COND (<DOBJ? SLOW MEDIUM FAST>
		      ;"never used if these are verbs"
		      <PERFORM ,V?SET ,THROTTLE ,PRSO>
		      <RTRUE>)>
	       <COND (<EQUAL? ,PRSO ,P?EAST ,P?SE ,P?NE>
		      <SETG SUB-DLON +1>)
		     (<EQUAL? ,PRSO ,P?WEST ,P?SW ,P?NW>
		      <SETG SUB-DLON -1>)
		     (T <SETG SUB-DLON 0>)>
	       <COND (<EQUAL? ,PRSO ,P?NORTH ,P?NW ,P?NE>
		      <SETG SUB-DLAT +1>)
		     (<EQUAL? ,PRSO ,P?SOUTH ,P?SW ,P?SE>
		      <SETG SUB-DLAT -1>)
		     (T <SETG SUB-DLAT 0>)>
	       ;<COND (,SUB-IN-REVERSE?
		      <SETG SUB-DLON <- ,SUB-DLON>>
		      <SETG SUB-DLAT <- ,SUB-DLAT>>)>
	       <COND (<FSET? ,AUTO-PILOT ,ONBIT>
		      <TELL "Let the " D ,AUTO-PILOT " handle that." CR>)
		     (,SUB-IN-TANK
		      <TRY-TO-EMERGE ,P?EAST ,TANK-GATE ,TEST-TANK-FULL>)
		     (,SUB-IN-DOME
		      <TRY-TO-EMERGE ,P?SOUTH ,AIRLOCK-HATCH ,AIRLOCK-FULL>)
		     (<AND <READY-FOR-SNARK?>
			   ,TOLD-SNARK-WENT
			   <FSET? ,SNARK ,INVISIBLE>
			   <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>
			   <DOBJ? P?SE>
			   <NOT <==? ,JOYSTICK-DIR ,PRSO>>>
		      <TELL
"Pulses racing and hearts thumping, you and Tip at last set out to
capture the monstrous Snark!" CR>)
		     (T
		      <SUB-NOW-HEADING>)>
	       <SETG JOYSTICK-DIR ,PRSO>
	       <RTRUE>)
	      (<AND <VERB? WALK-UNDER> <DOBJ? GLOBAL-WATER BAY SEA>>
	       <COND (<0? ,SUB-DEPTH>
		      <DO-WALK ,P?DOWN>
		      <RTRUE>)
		     (T <TELL "You're already " D ,UNDERWATER "." CR>)>)
	      (<EXIT-VERB?>
	       <COND (<CANT-GO-TO-THRU-CLOSED-HATCH?>
		      <RTRUE>)>)
	      (<AND <VERB? EXAMINE LOOK-INSIDE>
		    <DOBJ? TEST-TANK DOCKING-TANK>>
	       <TELL ,I-ASSUME " look through the " D ,SUB-WINDOW ".)" CR>
	       <PERFORM ,V?LOOK-INSIDE ,SUB-WINDOW>
	       <RTRUE>)
	      (<AND <VERB? EXAMINE>
		    <DOBJ? THORPE-SUB GLOBAL-THORPE GLOBAL-SHARON
			   SNARK GLOBAL-SNARK>>
	       <COND (<NOT <FSET? ,SNARK ,INVISIBLE>>	;,SUB-IN-BATTLE
		      <TELL
"The " D ,GLOBAL-WATER " is too cloudy to see anything." CR>)
		     (T
		      <TOO-BAD-BUT ,PRSO "too far away">
		      ;<HE-SHE-IT ,PRSO T>
		      ;<TELL "'s too far away.">)>)
	      (<AND <VERB? DROP>
		    <EQUAL? ,PRSO <GET ,ON-SUB 0> <GET ,ON-SUB 1>>>
	       <COND (<EQUAL? ,PRSO <GET ,ON-SUB 0>> <PUT ,ON-SUB 0 <>>)
		     (<EQUAL? ,PRSO <GET ,ON-SUB 1>> <PUT ,ON-SUB 1 <>>)>
	       <COND (,SUB-IN-TANK <MOVE ,PRSO ,NORTH-TANK-AREA>)
		     (,SUB-IN-DOME <MOVE ,PRSO ,AIRLOCK>)
		     (T <REMOVE ,PRSO>)>
	       <FCLEAR ,PRSO ,NDESCBIT>
	       <FSET ,PRSO ,TAKEBIT>
	       <FCLEAR ,PRSO ,TRYTAKEBIT>
	       <TELL "Dropped." CR>)
	      (<AND <VERB? TAKE-WITH> <IOBJ? CLAW>>
	       <COND (<NOT <EQUAL? <LOC ,PRSO> ,AIRLOCK ,NORTH-TANK-AREA>>
		      <TOO-BAD-BUT ,PRSO "not close enough to the claw">)
		     (<NOT <FSET? ,PRSO ,TAKEBIT>> <YOU-CANT "take">)
		     (<MOUNT-WEAPON ,PRSO> <TELL "Taken." CR> <RTRUE>)
		     (T <RTRUE>)>)
	      ;(T <RFALSE>)>)
       (<EQUAL? .RARG ,M-ENTER>
	<COND (<NOT <0? <POPULATION ,SUB ,TIP ,PLAYER>>>
	       <TOO-CROWDED>
	       <COND (,SUB-IN-DOME <GOTO ,AIRLOCK>)
		     (,SUB-IN-TANK <GOTO ,NORTH-TANK-AREA>)>
	       <RTRUE>)>
	<ENABLE <QUEUE I-POISON-JAB 9>>
	<COND (<SET X <GET ,ON-SUB 0>> <MOVE .X ,SUB>)>
	<COND (<SET X <GET ,ON-SUB 1>> <MOVE .X ,SUB>)>
	<COND (<AND <IN? ,ESCAPE-POD-UNIT ,SUB>
		    <FSET? ,SYRINGE ,MUNGBIT>
		    <NOT <FSET? ,SYRINGE ;,ESCAPE-POD-UNIT ,TOUCHBIT>>>
	       <ENABLE <QUEUE I-CHECK-POD 1>>)>
	<COND (<AND ,SUB-IN-DOME
		    <READY-FOR-SNARK?>
		    <NOT <SOMEONE-WORKING?>>>
	       <FCLEAR ,SUB-DOOR ,OPENBIT>
	       <MOVE ,TIP ,HERE>
	       <TELL
"As you and Tip take your places in your seats, ">
	       <COND (<AND <FSET? ,AIRLOCK-ROOF ,OPENBIT>
			   <NOT <AIRLOCK-POP?>>>
		      <FCLEAR ,AIRLOCK-ROOF ,OPENBIT>
		      <TELL
"and close the hatch, the " D ,AIRLOCK-ROOF ;"watertight roof of the airlock"
" is also sliding shut." CR>)
		     (T <TELL "Tip closes the hatch." CR>)>)>
	<SCORE-OBJ ,SUB>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"You're in the pilot's seat of the " D ,SUB ", its operating "
D ,CONTROLS-SUB " before you.">
	<COND (<FSET? ,ENGINE-ACCESS-HATCH ,OPENBIT>
	       <TELL " The " D ,ENGINE-ACCESS-HATCH " is open.">)>
	<TELL "|
A wraparound " D ,SUB-WINDOW ", both fore and aft, provides
a view ahead and astern.">
	<COND (<AND <0? ,SUB-DEPTH> <NOT ,SUB-IN-TANK>>
	       <TELL " Sunlight pours in through the " D ,SUB-WINDOW ".">)>
	<TELL
" You can also observe your surroundings with a " D ,SONARSCOPE " and a
" D ,HYDROPHONE " listening device. There's a " D ,SONARPHONE " for
communication. You'll discover other features when you need them." CR>)>>
	"| A reactor pokes through the deck.
	radio. There's also a , video screen,
	<DDESC ' The hatch leading out is ' ,SUB-DOOR '.'>"

<ROUTINE TOO-CROWDED ()
	<TELL
"It's too crowded in here! You'll have to wait outside."
;"Oops! Someone's working inside. You'd better wait for them to finish." CR>>

<ROUTINE TRY-TO-EMERGE (DIR GATE FULL?)
	<COND (<NOT .FULL?>
	       <TELL "You can't turn the sub around while the ">
	       <COND (<==? .DIR ,P?EAST> <TELL D ,TEST-TANK>)
		     (T <TELL D ,AIRLOCK>)>
	       <TELL " is empty." CR>)
	      (<EQUAL? ,PRSO .DIR>
	       <COND (<NOT <0? ,THROTTLE-SETTING>>
		      <COND (<NOT <FSET? ,ENGINE ,ONBIT>>
			     <TELL
"Nothing happens when you push the " D ,JOYSTICK ". The engine is off.">
			     <COND (,GATE-CRASHED
				    <TELL
" It was stopped by Automatic Shutoff when you crashed into the
sea gate.">)>
			     <CRLF>)
			    (<HATCH-GATE-NOT-READY? .GATE> <RTRUE>)
			    (<==? .DIR ,P?SOUTH> <SUB-LEAVES <> ,P?SOUTH>)
			    (T <SUB-LEAVES T ,P?EAST>)>)
		     (T
		      <SUB-NOW-HEADING>)>)
	      (T
	       ;<OKAY ,JOYSTICK>
	       <TELL "Okay, the " D ,JOYSTICK " is now pointing to ">
	       <DIR-PRINT ,PRSO>
	       <TELL ". But the only way the sub can leave the tank is to ">
	       <DIR-PRINT .DIR>
	       <TELL "." CR>)>>

<ROUTINE HATCH-GATE-NOT-READY? (GATE)
 <COND (<FSET? ,SUB-DOOR ,OPENBIT>
	<THIS-IS-IT ,SUB-DOOR>
	<TELL
"You shouldn't leave the tank with the hatch open!" CR>)
       (<NOT <FSET? .GATE ,OPENBIT>>
	<GATE-CRASH "push" ,JOYSTICK .GATE>
	<RTRUE>)>>

<GLOBAL LEFT-DOME 0>

<ROUTINE READY-FOR-SNARK? ()
	<AND <OR <==? ,BAZOOKA <GET ,ON-SUB 0>>
		 <==? ,DART <GET ,ON-SUB 1>>>
	     ,FINE-SONAR>>

<ROUTINE SUB-LEAVES (FROM-LAB? DIR)
	<COND (.FROM-LAB?
	       <SETG GATE-CRASHED <>>
	       <SETG SUB-IN-TANK <>>
	       <REMOVE ,SHARON>
	       <ROB ,SHARON ,GLOBAL-SHARON>
	       <SETG ALARM-RINGING <>>
	       <PUT <GETPT ,VIDEOPHONE-2 ,P?SYNONYM> 0 ,W?ZZZZLG>
	       <ENABLE <QUEUE I-UPDATE-SUB-POSITION -1>>
	       <SETG MONSTER-GONE T>
	       <SETG NOW-TERRAIN ,BAY-TERRAIN>)
	      (T
	       <SETG SUB-IN-DOME <>>
	       <SETG NOW-TERRAIN ,SEA-TERRAIN>
	       <SETG SUB-LON 0 ;6>
	       <SETG SUB-LAT -1 ;5>
	       <SETG SUB-DEPTH ,AIRLOCK-DEPTH>
	       <SETG TARGET-DEPTH ,AIRLOCK-DEPTH>)>
	<COND (<AND ,AUTOMATIC-SONAR <SPLIT-SCREEN?>>
	       <SETG SCREEN-NOW-SPLIT T>
	       <START-SONAR?>)>
	<TELL
"The " D ,SUB " glides smoothly out of the tank ">
	<COND (.FROM-LAB? <TELL "onto the surface of " D ,BAY>)
	      (T <TELL "into the ocean">)>
	<TELL ". You're heading ">
	<DIR-PRINT .DIR <>>
	<TELL " at " N ,THROTTLE-SETTING " " D ,GRID-UNIT>
	<COND (<NOT <==? 1 ,THROTTLE-SETTING>> <TELL "s">)>
	<TELL " per turn." CR>
	<COND (.FROM-LAB? <SCORE-OBJ ,BAY>)
	      (T
	       <COND (<FSET? ,TIP ,BUSYBIT>
		      <I-TIP-REPORTS>)>
	       <COND (<READY-FOR-SNARK?>
		      <SCORE-OBJ ,AIRLOCK>
		      <SETG LEFT-DOME ,MOVES>
		      <ENABLE <QUEUE I-THORPE-APPEARS -1>>)
		     (T
		      <TIP-SAYS>
		      <TELL
"I've got a bad feeling about this. I don't think
we should go out there without a ">
		      <COND (,FINE-SONAR <TELL "weapon of some kind.\"" CR>)
			    (T <TELL D ,FINE-GRID ".\"" CR>)>)>)>
	<SAVE-HINT>
	<RTRUE>>

<ROUTINE HEADING-FOR-SEAWALL? ("AUX" Y-X)
	<COND (<NOT <EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>> <RFALSE>)
	      (<OBSTACLE-AHEAD? ,SUB-DEPTH ,SUB-LON ,SUB-LAT> <RFALSE>)
	      (<DOBJ? P?NORTH>
	       <COND (<AND <G? ,SUB-LON 29> <L? ,SUB-LON 35>> <RTRUE>)>)
	      (<DOBJ? P?EAST>
	       <COND (<AND <G? ,SUB-LAT 35> <L? ,SUB-LAT 41>> <RTRUE>)>)
	      (<DOBJ? P?NE>
	       <SET Y-X <- ,SUB-LAT ,SUB-LON>>
	       <COND (<AND <G? .Y-X 0> <L? .Y-X 12>> <RTRUE>)>)>>

<GLOBAL SUB-STILL-HEADING 0>
<ROUTINE SUB-NOW-HEADING ()
	;<OKAY ,SUB>
	<TELL "Okay, the " D ,SUB " is ">
	<COND (<==? ,JOYSTICK-DIR ,PRSO>
	       <COND (<NOT ,SUB-IN-BATTLE> <INC SUB-STILL-HEADING>)>
	       <TELL "still ">)
	      (T <TELL "now ">)>
	<COND (<0? ,THROTTLE-SETTING> <TELL "facing" ;"heading">)
	      (T <TELL "moving">)>
	<TELL " toward ">
	<DIR-PRINT ,PRSO>
	<COND (<HEADING-FOR-SEAWALL?>
	       <TELL ", straight toward the opening in the " D ,SEA-WALL>)>
	<COND (<0? ,THROTTLE-SETTING>
	       <THIS-IS-IT ,THROTTLE>
	       <TELL
". But it won't go that way unless you open the " D ,THROTTLE>)>
	<TELL "." CR>
	<COND (<==? ,SUB-STILL-HEADING 9>
	       <SETG SUB-STILL-HEADING 0>
	       <TELL
"(You didn't change the " D ,SUB "'s heading. Remember, you don't have to type
a " D ,INTDIR " every turn if you want to WAIT or do something
else.)" CR>)>>

<OBJECT SUB-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "entry hatch")
	(ADJECTIVE ENTRY BIOCEPTOR SUB SUBMARINE SCIMITAR)
	(SYNONYM DOOR HATCH TOP ENTRANCE)
	(FLAGS DOORBIT OPENBIT)
	(ACTION SUB-DOOR-F)>

<ROUTINE SUB-DOOR-F ()
 <COND (<VERB? CLOSE>
	<COND (<AND ,SUB-IN-DOME <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	       <TELL "It's too soon for that!" CR>)
	      (<SOMEONE-WORKING?>
	       <TELL "There are too many people inside." CR>)
	      (<NOT <EQUAL? ,HERE ,SUB>>
	       <TELL "You should board the " D ,SUB " first." CR>)
	      (<NOT <EQUAL? <LOC ,TIP> ,SUB ,CRAWL-SPACE>>
	       <COND (<FSET? ,TIP ,BUSYBIT> <I-TIP-REPORTS>)
		     (T
		      <MOVE ,TIP ,SUB>
		      <TELL
"Tip rushes in just before you close it. \"Wait for me, "FN"!\"" CR>)>
	       <RFALSE>)>)
       (<VERB? OPEN>
	<COND (<AND <G? ,SUB-DEPTH 0>
		    <OR <NOT ,SUB-IN-DOME> ,AIRLOCK-FULL>>
	       <YOU-CANT "open" ,SUB "under water">
	       ;<TELL "You can't open the hatch under water!" CR>)
	      (,SUB-IN-OPEN-SEA
	       <TELL "This is no time for a swim!" CR>)
	      (<NOT <EQUAL? ,HERE ,SUB ,NORTH-TANK-AREA ,AIRLOCK>>
	       <TELL "You can't reach" THE-PRSO " from here." CR>)
	      (<OR ,GREENUP-ESCAPE ,GREENUP-TRAPPED>
	       <FSET ,SUB-DOOR ,OPENBIT>
	       <TELL
;"[more?]" "Before the crew can carry out your order, the hatch opens.
Greenup rises into view from the pilot's seat and gives himself up. ">
	       <GREENUP-CUFF>
	       <RTRUE>)>)>>

<OBJECT SUB-WINDOW
	(IN SUB)
	(DESC "viewport")
	;(ADJECTIVE VIEW)
	(SYNONYM ;PORT VIEWPORT DIVING ;"WINDOW - gone so FIND WINDOW works")
	(FLAGS NDESCBIT WINDOWBIT LOCKED)
	;(GENERIC GENERIC-WINDOW-F ;LOCKED-F)
	(ACTION SUB-WINDOW-F)>

<ROUTINE SUB-WINDOW-F ("AUX" ;(RM <WINDOW-ROOM ,HERE ,PRSO>) POP)
	 <COND (<VERB? BRUSH>
		<ALREADY ,SUB-WINDOW "clean enough">)
	       (<VERB? LOOK-INSIDE LOOK-OUTSIDE>
		<COND (T ;<EQUAL? ,HERE ,SUB>
		       <COND (,SUB-IN-TANK
			      <TELL"You can see the test tank outside."CR>)
			     (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			      <COND (<0? ,SUB-DEPTH>
				     <TELL
"Frobton is a busy seaport full of constantly moving pleasure boats,
fishing craft and commercial shipping. The biggest ships move in the shipping
lanes, but you can dive to 15 meters and go under them. Observe all
\"Rules of the Road\", unless you want to submerge. When you're
" D ,UNDERWATER ", you should avoid shallow areas called shoals."
;"(You'll find that information in your SEASTALKER package.)" CR>)
				    (T <PLENTY-WATER>)>)
			     (,SUB-IN-OPEN-SEA
			      <COND (<NOT <L? ,DISTANCE-FROM-BAY
					      ,AQUADOME-VISIBLE>>
				     <TELL
"You can see the " D ,AQUADOME "." CR>)
				    (<NOT <FSET? ,WHALE ,INVISIBLE>>
				     <TELL
"The whale is still following you." CR>)
				    (<FSET? ,SEARCH-BEAM ,ONBIT>
				     <TELL
"Your sub's " D ,SEARCH-BEAM " lights up the " D ,GLOBAL-WATER " outside."CR>)
				    (T <PLENTY-WATER>)>)
			     (<AND <EQUAL? ,NOW-TERRAIN ,SEA-TERRAIN>
				   <EQUAL? ,SUB-DEPTH ,AIRLOCK-DEPTH>
				   <G? 4 <+ <* ,SUB-LON ,SUB-LON>
					    <* ,SUB-LAT ,SUB-LAT>>>>
			      <TELL "You can see the " D ,AQUADOME "." CR>)
			     (,SUB-IN-DOME
			      <ROOM-PEEK ,AIRLOCK>
			      <RTRUE>)
			     (<NOT <FSET? ,SNARK ,INVISIBLE>>
			      <COND (,SUB-IN-BATTLE
				     <TOO-CLOUDY>)
				    (T <TELL
"You can see the " D ,SNARK " and the " D ,THORPE-SUB " in the "
D ,SEARCH-BEAM " beam." CR>)>)
			     (T <PLENTY-WATER>)>)>
		<RTRUE>)
	       (<VERB? MUNG>
		<TELL
"Vandalism is for vandals, not famous inventors!" CR>)
	       (<VERB? OPEN CLOSE LOCK UNLOCK>
		;<COND (<FSET? ,PRSO ,MUNGBIT>
		       <TELL "It's really broken. ">)>
		<TELL "You can't." CR>)
	       (<VERB? STOP>	;"STOP DIVING!"
		<PERFORM ,V?LEVEL>
		<RTRUE>)>>

<ROUTINE TOO-CLOUDY ()
	<TELL "The " D ,GLOBAL-WATER " is too cloudy to see much." CR>>

<ROUTINE PLENTY-WATER ()
	<TELL "You can see plenty of " D ,GLOBAL-WATER "." CR>>

;<ROUTINE WINDOW-KNOCK (RM)
	 <COND (<INHABITED? .RM>
		<TELL "Someone looks up at you inquisitively." CR>)>>

<OBJECT ENGINE-ACCESS-HATCH
	(IN LOCAL-GLOBALS)
	(DESC "access panel")
	(ADJECTIVE ENGINE ACCESS STENCIL)
	(SYNONYM PANEL ;DOOR ;HATCH SIGN)
	(FLAGS DOORBIT VOWELBIT)
	(ACTION ENGINE-ACCESS-HATCH-F)>

<ROUTINE ENGINE-ACCESS-HATCH-F ()
 <COND ;(<AND <VERB? LOOK-INSIDE> <IN? ,WINNER ,SUB>>	;"let verb handle it"
	<TELL <GETP ,CRAWL-SPACE ,P?LDESC> CR>)
       (<VERB? TAKE>
	<COND (<NOT ,PRSI>
	       <PERFORM ,V?OPEN ,PRSO>
	       <RTRUE>)>)
       (<VERB? TAKE-WITH>
	<COND (<EQUAL? ,PRSI ,UNIVERSAL-TOOL>
	       <PERFORM ,V?OPEN-WITH ,PRSO ,PRSI>
	       <RTRUE>)>)
       (<AND <VERB? OPEN OPEN-WITH>
	     <DOBJ? ENGINE-ACCESS-HATCH>
	     <IN? ,WINNER ,SUB>
	     <NOT <IN? ,UNIVERSAL-TOOL ,WINNER>>>
	<TELL "Suggest you read the stenciled sign." CR>)
       (<AND <VERB? READ EXAMINE ANALYZE> <IN? ,WINNER ,SUB>>
	<TELL "\"THIS REQUIRES SPECIAL ULTRA WRENCH FROM SUB TOOL KIT.\""CR>
	<COND (<IN? ,UNIVERSAL-TOOL ,TIP>
	       <THIS-IS-IT ,UNIVERSAL-TOOL>
	       <TELL-HINT 61 ;7 ,TIP <>>)>
	<RTRUE>)>>

<ROOM CRAWL-SPACE
	(IN ROOMS)
	(DESC "crawl space")
	(LDESC
"The space is dimly illuminated by small work lights, but you can see
machinery everywhere.")
	(ADJECTIVE ENGINE ;COMPARE CRAWL ACCESS)
	(SYNONYM	COMPARE ;CRAWL SPACE ROOM AREA)
	(FLAGS RLANDBIT ONBIT)
	(NORTH	"The only way out is \"OUT\".")	;"? SOUTH?"
	(NE	"The only way out is \"OUT\".")
	(EAST	"The only way out is \"OUT\".")
	(SE	"The only way out is \"OUT\".")
	(SOUTH	"The only way out is \"OUT\".")
	(SW	"The only way out is \"OUT\".")
	(WEST	"The only way out is \"OUT\".")
	(NW	"The only way out is \"OUT\".")
	(OUT	TO SUB IF ENGINE-ACCESS-HATCH IS OPEN)
	(UP	TO SUB IF ENGINE-ACCESS-HATCH IS OPEN)
	(ACTION CRAWL-SPACE-F)
	(GLOBAL LOCAL-SUB ENGINE-ACCESS-HATCH ;CRAWL-SPACE-OBJ
		LIGHTS TEST-BUTTON)
	(PSEUDO "MACHIN" RANDOM-PSEUDO)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<OBJECT LIGHTS
	(IN LOCAL-GLOBALS)
	(DESC "lights")
	(SYNONYM LIGHT LIGHTS)>

<ROUTINE CRAWL-SPACE-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-BEG>
	<COND (<EXIT-VERB?> <MOVE ,ENGINE ,SUB> <RFALSE>)>
	<COND (<GAME-VERB?> <RFALSE>)>
	<COND (<==? ,P-ADVERB ,W?CAREFULLY> <RFALSE>)>
	<COND (<AND <PROB 20 ;10>
		    <FSET? ,ENGINE ,ONBIT>
		    <NOT ,SUB-IN-TANK>
		    <NOT ,SUB-IN-DOME>>
	       <TELL
"|
Suddenly the " D ,SUB " begins to shake violently! Your foot has
knocked an engine bearing out of alignment! It will be necessary to
surface at once and await rescue! Your mission must be aborted.">
	       <FINISH>)
	      (<AND <PROB 20 ;10>
		    <FSET? ,GASH ,INVISIBLE> ;<NOT >>
	       <FSET ,ARM ,MUNGBIT>
	       <FCLEAR ,GASH ,INVISIBLE>
	       <TELL
"There's a sharp pain in your right arm! A flood of wet warmth and a
spreading red stain mean you've seriously gashed your arm
on a sharp metal corner!" CR>
	       <RFALSE>)>)
       (<EQUAL? .RARG ,M-ENTER>
	<COND (<NOT <0? <POPULATION ,CRAWL-SPACE ,PLAYER>>>
	       ;<FIND-FLAG ,CRAWL-SPACE ,PERSON ,WINNER>
	       <TOO-CROWDED>
	       <GOTO ,SUB>
	       ;<RTRUE>)
	      (T <MOVE ,ENGINE ,CRAWL-SPACE> <RFALSE>)>)
       ;(<EQUAL? .RARG ,M-LOOK>
	<TELL <GETP ,CRAWL-SPACE ,P?LDESC> CR>)
       (.RARG <RFALSE>)
       (<VERB? FIND>
	<COND (<EQUAL? ,HERE ,CRAWL-SPACE> <TELL "You're in it!" CR>)
	      (T <TELL
"It's located beyond an " D ,ENGINE-ACCESS-HATCH " in the bulkhead just
below and to the right of control panel." CR>)>)
       (<VERB? OPEN LOOK-INSIDE>
	<COND (<DOBJ? CRAWL-SPACE>
	       <PERFORM ,PRSA ,ENGINE-ACCESS-HATCH ,PRSI>
	       <RTRUE>)>)
       (<VERB? ;ENTER THROUGH WALK-TO>
	<COND (<FSET? ,ENGINE-ACCESS-HATCH ,OPENBIT>
	       <COND (<GOTO ,CRAWL-SPACE>
		      <TELL
"BE CAREFUL: Too much wriggling may pose SERIOUS DANGERS!">
		      <COND (<FSET? ,ENGINE ,ONBIT>
			     <TELL
" And wouldn't it be safer to stop the engine first?">)>
		      <CRLF>)>
	       <RTRUE>)
	      (T
	       <TOO-BAD-BUT ,ENGINE-ACCESS-HATCH "closed">
	       <THIS-IS-IT ,ENGINE-ACCESS-HATCH>
	       <RFATAL>)>)>>

<OBJECT VOLTAGE-REGULATOR
	(IN CRAWL-SPACE)
	(DESC "voltage regulator")
	(ADJECTIVE VOLTAGE)
	(SYNONYM REGULATOR)
	(FLAGS NDESCBIT MUNGBIT)
	(ACTION VOLTAGE-REGULATOR-F)
	;(VALUE 4)>

<ROUTINE VOLTAGE-REGULATOR-F ()
 <COND (<VERB? WALK-TO>
	<COND (<NOT <EQUAL? ,HERE ,CRAWL-SPACE>>
	       <PERFORM ,PRSA ,CRAWL-SPACE>
	       <RTRUE>)>)
       (<VERB? FIND>
	<COND (<EQUAL? ,HERE ,CRAWL-SPACE>
	       <FCLEAR ,VOLTAGE-REGULATOR ,NDESCBIT>
	       <TELL
"You find it in the middle of some complicated machinery." CR>)>)
       (<VERB? ANALYZE EXAMINE>
	<COND (<FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>
	       <TELL "It's hard to tell anything by looking at it." CR>)>)
       (<VERB? ADJUST FIX>
	<COND (<FSET? ,ARM ,MUNGBIT>
	       <TELL "You can't do that since you gashed your arm!" CR>)
	      (<NOT <FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>>
	       <ALREADY ,VOLTAGE-REGULATOR "fixed">)
	      (T
	       <SETG TEST-BUTTON-READOUT ,TEST-BUTTON-NORMAL>
	       <TELL "Fixed." CR>
	       <COOL-BACK>
	       <FCLEAR ,VOLTAGE-REGULATOR ,MUNGBIT>
	       ;<FSET ,ENGINE-ACCESS-HATCH ,NDESCBIT>
	       ;<SCORE-OBJ ,VOLTAGE-REGULATOR>
	       <RTRUE>)>)>>

<ROUTINE COOL-BACK ("AUX" X)
 <COND (<AND <L? 20 ,CIRCUIT-TEMP>
	     <FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>>
	<SET X <- ,CIRCUIT-TEMP 15>>
	<TELL "It will take about " N .X " turn">
	<COND (<NOT <1? .X>> <TELL "s">)>
	<TELL
" for the " D ,CONTROL-CIRCUITS " to cool to a normal operating temperature."
CR>)>>

"<CONSTANT LAB-LON 1>
<CONSTANT LAB-LAT 9>"
<CONSTANT SEA-WALL-LON 32>
<CONSTANT SEA-WALL-LAT 38>
<CONSTANT SPIRE-LON 29>
<CONSTANT SPIRE-LAT 26>
<GLOBAL SUB-LON 2>
<GLOBAL SUB-LAT 9>
<GLOBAL SUB-DLON 0>
<GLOBAL SUB-DLAT 0>

<GLOBAL TBL5-MASK <PTABLE *77777* *7777* *777* *77* *7*>>
<GLOBAL TBL5-SHIFT <PTABLE *10000* *1000* *100* *10* 1>>

<ROUTINE GET5 (TBL5 NUM "AUX" (NUM1 <- .NUM 1>))
	</ <ANDB <GET ,TBL5-MASK <MOD .NUM1 5>>
		 <GET .TBL5 <+ 1 </ .NUM1 5>>>>
	   <GET ,TBL5-SHIFT <MOD .NUM1 5>>>>

<DEFINE LT5 ("ARGS" A)
	<MAPF ,PLTABLE
	      <FUNCTION ("AUX" VAL)
		<COND (<EMPTY? .A> <MAPSTOP>)>
		<SET VAL <LSH <1 .A> 12>>
		<COND (<EMPTY? <SET A <REST .A>>>
		       <MAPSTOP <CHTYPE .VAL FIX>>)>
		<SET VAL <ORB .VAL <LSH <1 .A> 9>>>
		<COND (<EMPTY? <SET A <REST .A>>>
		       <MAPSTOP <CHTYPE .VAL FIX>>)>
		<SET VAL <ORB .VAL <LSH <1 .A> 6>>>
		<COND (<EMPTY? <SET A <REST .A>>>
		       <MAPSTOP <CHTYPE .VAL FIX>>)>
		<SET VAL <ORB .VAL <LSH <1 .A> 3>>>
		<COND (<EMPTY? <SET A <REST .A>>>
		       <MAPSTOP <CHTYPE .VAL FIX>>)>
		<SET VAL <ORB .VAL <1 .A>>>
		<SET A <REST .A>>
		<CHTYPE .VAL FIX>>>>

<GLOBAL BAY-TERRAIN <PLTABLE
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 0 0 0 0 0 0 1 1 1 1 2 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 0 0 0 0 1 1 1 1 2 2 2 2 2 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 0 0 1 1 1 1 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 0 1 1 1 2 2 2 3 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 0 1 1 1 2 2 3 3 3 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0>
%<LT5
0 0 1 1 1 2 2 3 3 4 4 4 4 3 3 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0>
%<LT5
0 2 2 2 2 2 3 3 4 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0>
%<LT5
0 1 2 2 2 2 3 4 4 4 4 4 4 4 3 3 3 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0>
%<LT5
0 1 2 2 2 3 3 4 4 4 4 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0>
%<LT5
0 1 1 2 2 3 1 1 1 1 4 4 4 4 4 4 3 3 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0>
%<LT5
0 1 1 2 2 1 1 1 1 1 1 1 1 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0>
%<LT5
0 1 1 2 2 3 1 1 1 1 1 1 1 1 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0>
%<LT5
0 1 2 2 2 3 4 4 4 4 1 1 1 1 1 4 4 4 4 3 3 3 2 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0>
%<LT5
0 1 2 2 3 4 4 4 4 4 4 1 1 1 1 1 4 4 4 4 3 3 2 2 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0>
%<LT5
0 2 2 2 3 4 4 4 4 4 4 4 4 4 1 1 1 4 4 4 4 4 3 2 2 2 1 1 1 1 1 1 1 1 1 1 1 0 0>
%<LT5
0 2 2 3 4 4 4 4 4 4 4 4 4 4 4 1 1 1 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 2 2 1 1 1 1 1 1 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 4 3 3 2 2 1 1 1 1 1 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 3 3 2 2 2 1 1 1 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 3 3 3 2 2 2 1 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 3 3 3 3 2 2 1 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 3 3 2 2 1 1 0 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 3 3 2 1 1 1 0>
%<LT5
0 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 0 4 4 4 4 3 2 1 1 1 0>
%<LT5
0 0 3 3 3 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 3 2 2 1 1 0>
%<LT5
0 0 2 2 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 3 2 2 1 0 0>
%<LT5
0 0 1 2 2 3 3 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 3 2 1 0 0>
%<LT5
0 0 0 1 2 3 3 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 3 2 2 1 0>
%<LT5
0 0 0 1 2 2 3 3 4 4 4 4 4 1 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 3 0 0>
%<LT5
0 0 0 1 1 2 2 3 3 4 4 4 4 1 1 1 1 4 4 4 5 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 0 0 6>
%<LT5
0 0 0 0 1 2 2 3 3 3 4 4 4 4 1 1 1 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 4 4 4 0 0 6 6>
%<LT5
0 0 0 0 1 1 2 2 3 3 3 4 4 4 4 1 1 1 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 4 0 0 6 6 6>
%<LT5
0 0 0 0 0 1 1 2 2 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 0 6 6 6 6>
%<LT5
0 0 0 0 0 0 1 1 2 2 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 1 1 1 2 2 2 2 3 3 3 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 2 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 4 5 5 5 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 3 3 4 4 4 4 5 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 2 2 3 4 4 0 0 6 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 2 3 0 0 6 6 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 6 6 6 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 6 6 6 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 6 6 6 6 6 6 6 6 6 6 6 6 6>
%<LT5
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 6 6 6 6 6 6 6 6 6 6 6 6 6>>>

"<REMOVE!- LT5>"

<GLOBAL NOW-TERRAIN 0>
<GLOBAL SPEEDBOAT-WARNING-GIVEN? <>>
<GLOBAL WARNINGS-THIS-TURN <LTABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL WARNINGS-USED 0>
<GLOBAL WARNINGS-RTRUE <>>

<ROUTINE ADD-WARNING (MSG "OPTIONAL" (RTRUE? <>) "AUX" TBL LEN N M)
	<COND (.RTRUE? <SETG WARNINGS-RTRUE T>)>
	<SET TBL ,WARNINGS-THIS-TURN>
	<COND (<==? <GET .TBL 0> ,WARNINGS-USED> <RTRUE>)>
	<SET LEN <GET .TBL 0>>
	<SET N 0>
	<REPEAT ()
		<COND (<IGRTR? N .LEN> <RETURN>)>
		<SET M <GET .TBL .N>>
		<COND (<=? .MSG .M> <RETURN>)
		      (<AND <EQUAL? .MSG 5>	<EQUAL? .M 3 9>> <RETURN>)
		      (<AND <EQUAL? .MSG 6>	<EQUAL? .M 4 11>><RETURN>)
		      (<AND <EQUAL? .MSG 8>	<EQUAL? .M 7>>   <RETURN>)
		      (<0? <GET .TBL .N>>
		       <PUT .TBL .N .MSG>
		       <SETG WARNINGS-USED .N>
		       <RETURN>)>>>

"<GLOBAL TOLD-ABOUT-SHIP <>>"

<ROUTINE GIVE-WARNINGS ("AUX" TBL LEN N MSG (SONAR? <>))
	<SET TBL ,WARNINGS-THIS-TURN>
	<SET LEN ,WARNINGS-USED>
	<SET N 0>
	<REPEAT ()
		<COND (<IGRTR? N .LEN> <RETURN>)
		      (<0? <SET MSG <GET .TBL .N>>> <RETURN>)>
		<SETG WARNINGS-USED 0>
		<PUT .TBL .N 0>
		<COND (,SUB-IN-OPEN-SEA <AGAIN>)>
		<COND (<EQUAL? .MSG 1>
		       <TELL
"|
A speedboat came out of nowhere and almost hit you!
It's dangerous on the surface of the bay.">)
		      (<EQUAL? .MSG 2>
		       <SET SONAR? T>
		       <TELL
"|
If you don't change course or stop, you'll crash!">)
		      (<EQUAL? .MSG 3 4>
		       <THIS-IS-IT ,DEPTHFINDER-LIGHT>
		       <TELL
"Suddenly a loud " D ,ALARM-SUB " begins to ring! The " D ,DEPTHFINDER-LIGHT
" has begun to glow "
		       <COND (<EQUAL? .MSG 3> "orange") (T "red")> ".">)
		      (<EQUAL? .MSG 5 6>
		       <THIS-IS-IT ,ALARM-SUB>
		       <TELL
"The " D ,DEPTHFINDER-LIGHT " is still glowing "
		       <COND (<EQUAL? .MSG 5> "orange") (T "red")>
", and the " D ,ALARM-SUB " is still ringing.">)
		      (<EQUAL? .MSG 7 8>
		       <SET SONAR? T>
		       <TELL "The " D ,SONARSCOPE>
		       <COND (<EQUAL? .MSG 8>
			      <THIS-IS-IT ,SONARSCOPE>
			      <TELL " still">)>
		       <TELL " shows an obstacle ahead!">
		       <COND (<EQUAL? .MSG 7>
			      <THIS-IS-IT ,SUB>
			      <TELL
" Unless you change course, you will crash the " D ,SUB "!">)>)
		      (<EQUAL? .MSG 9 10 11>
		       <THIS-IS-IT ,ALARM-SUB>
		       <TELL "The " D ,DEPTHFINDER-LIGHT " "
			     <COND (<EQUAL? .MSG 9>	"changes to orange")
				   (<EQUAL? .MSG 10>	"fades to dark again")
				   (T			"turns red")>
			     ", and the " D ,ALARM-SUB " "
			     <COND (<EQUAL? .MSG 9>	"continues to sound.")
				   (<EQUAL? .MSG 10>	"ceases.")
				   (T	"rises to a shriller whine.")>>)
		      (<EQUAL? .MSG 12 13>
		       <SET SONAR? T>
		       ;<SETG TOLD-ABOUT-SHIP T>
		       <THIS-IS-IT ,FREIGHTER>
		       <TELL"The "D ,SONARSCOPE-LIGHT" is flashing yellow! A">
		       <COND (<EQUAL? .MSG 13> <TELL "nother">)>
		       <TELL " ship is approaching!">)
		      (<EQUAL? .MSG 14>
		       <SET SONAR? T>
		       <TELL
"|
The yellow " D ,SONARSCOPE-LIGHT " just turned red! A loud " D ,ALARM-SUB " is
sending chills up and down your spine! The keel of the approaching ship
is visible in your " D ,SUB-WINDOW>
		       <COND (<FSET? ,HYDROPHONE ,ONBIT>
			      <TELL
", and the noise of its screws booms over the " D ,HYDROPHONE>)>
		       <TELL "!">)>
		<CRLF>>
	<COND (<AND .SONAR?
		    <NOT ,AUTOMATIC-SONAR>
		    <0? ,LOOKED-AT-SONAR>>
	       <THIS-IS-IT ,SONARSCOPE>
	       <TIP-SAYS>
	       <TELL
"Hey, "FN", maybe you should look at the " D ,SONARSCOPE
".\"" CR>)>
	<COND (,WARNINGS-RTRUE <SETG WARNINGS-RTRUE <>> <RTRUE>)>>

<ROUTINE SAVE-HINT ()
	<TELL "(This might be a good time to use the command: SAVE.)" CR>>

<GLOBAL REGULATOR-MSG-SEEN <>>

<ROUTINE FALL-FROM-CLAW (NUM "AUX" X)
	<COND (<SET X <GET ,ON-SUB .NUM>>
	       <TELL
"You can see" THE .X " fall out of the " D ,CLAW " and sink." CR>
	       <REMOVE .X>)>>

<ROUTINE I-UPDATE-SUB-POSITION ("AUX" ;DLON ;DLAT LON LAT DEP TH (VAL <>))
	<COND (,SUB-IN-TANK <RFALSE>)>
	<COND (<L? 0 ,CIRCUIT-TEMP>
	       <SETG CIRCUIT-TEMP <- ,CIRCUIT-TEMP 1>>)>
	<COND (<FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>
	       <SETG CIRCUIT-TEMP <+ ,CIRCUIT-TEMP ,THROTTLE-SETTING>>)>
	<COND (<AND <L? 20 ,CIRCUIT-TEMP> <NOT ,CIRCUIT-TIP>>
	       <SETG CIRCUIT-TIP T>
	       <MOVE ,OVERHEATING ,GLOBAL-OBJECTS>
	       <TELL CR "Suddenly ">
	       <TIP-SAYS>
	       <TELL
FN "! Look at the way that
" D ,CONTROL-CIRCUITS " " D ,CONTROL-CIRCUITS-GAUGE " is rising!\"" CR>
	       <SET VAL T>)
	      (<AND <NOT <L? 20 ,CIRCUIT-TEMP>> ,CIRCUIT-TIP>
	       <SETG CIRCUIT-TIP <>>)
	      (<AND <NOT <L? 25 ,CIRCUIT-TEMP>> ,CIRCUIT-RED>
	       <SETG CIRCUIT-RED <>>
	       <COND (<EQUAL? ,HERE ,SUB>
		      <TELL CR
"The " D ,CONTROL-CIRCUITS-GAUGE " drops below the red danger zone." CR>)>)
	      (<AND <L? 25 ,CIRCUIT-TEMP> <NOT ,CIRCUIT-RED>>
	       <SETG CIRCUIT-RED T>
	       <TELL CR
"The " D ,CONTROL-CIRCUITS-GAUGE " has entered the red danger zone!|
The circuit tester is activated. Push " D ,TEST-BUTTON " for readout." CR>
	       <SETG TEST-BUTTON-READOUT ,REGULATOR-MSG>
	       <SET VAL T>)
	      (<L? 30 ,CIRCUIT-TEMP>
	       <TELL CR
"The " D ,CONTROL-CIRCUITS-GAUGE " has gone off the scale!|
The engine grinds to a halt. Your mission is finished.">
	       <FINISH>)>
	<COND (,SUB-IN-DOME <RETURN .VAL>)
	      (<FSET? ,AUTO-PILOT ,ONBIT>
	       <SET TH ,THROTTLE-SETTING>
	       <REPEAT ()
		<COND (<DLESS? TH 0> <RETURN>)>
		<SETG DISTANCE-FROM-BAY <+ ,DISTANCE-FROM-BAY 1>>
		<SET DEP </ ,DISTANCE-FROM-BAY 2>>
		<COND (T ;<L? ,SUB-DEPTH .DEP>
		       <SETG TARGET-DEPTH .DEP>
		       <SETG SUB-DEPTH .DEP>)>
		<COND (<==? ,DISTANCE-FROM-BAY 20>
		       <FALL-FROM-CLAW 0>
		       <FALL-FROM-CLAW 1>)
		      (<==? ,DISTANCE-FROM-BAY 30>
		       <TELL CR
"The ocean has been getting darker as you dive toward the
" D ,AQUADOME ", turning from blue-green to dark green to a dull
gray-green. It's becoming duskier and murkier with every minute." CR>)
		      (<==? ,DISTANCE-FROM-BAY 39>
		       <COND (<NOT <FSET? ,SEARCH-BEAM ,ONBIT>>
			      <FSET ,SEARCH-BEAM ,ONBIT>
			      <TELL CR
"A yellow cone of light now illumines the water ahead. The " D ,SUB "'s "
D ,SEARCH-BEAM " was " D ,AUTOMATIC"ally switched on by an electronic eye, now
that you're too deep for the sun to light the water." CR>)>
		       <TELL CR
"Colorful sea life swims through the " D ,SEARCH-BEAM " beam: a
playful dolphin, a school of herring... Oh, oh! Here comes a hammerhead
shark. And now a huge manta ray is gracefully gliding and flapping
toward you." CR>)
		      (<==? ,DISTANCE-FROM-BAY 45>
		       <MOVE ,WHALE ,SUB>
		       <COND (<FSET? ,HYDROPHONE ,ONBIT>
			      <SETG WHALE-HEARD T>
			      <TELL "|
A crooning noise comes over the " D ,HYDROPHONE " loudspeaker, punctuated by
sighs and moans and a few weird whistles." CR>)>
		       <COND (<AND <==? ,HERE ,SUB> <IN? ,TIP ,HERE>>
			      <TELL "|
\"There's a blip on the " D ,SONARSCOPE " at three o'clock!\" yells
Tip. \"Aim the " D ,SEARCH-BEAM " to starboard, " FN "!\"" CR>
			      <RTRUE>)>)
		      (<AND <==? ,DISTANCE-FROM-BAY 50>
			    <FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>>
		       <COND (<NOT ,CIRCUIT-TIP>    ;"to ensure overheating"
			      <SETG CIRCUIT-TEMP 28>)>)
		      (<==? ,DISTANCE-FROM-BAY ,AQUADOME-VISIBLE>
		       <REMOVE ,WHALE>
		       <FSET ,WHALE ,INVISIBLE>
		       <SETG BLY-CALLING T>
		       <THIS-IS-IT ,SONARPHONE>
		       <FCLEAR ,SEARCH-BEAM ,ONBIT>
		       <TELL "The amazing " D ,AQUADOME " looms ahead">
		       <COND (<FSET? ,SEARCH-BEAM ,ONBIT>
			      <FCLEAR ,SEARCH-BEAM ,ONBIT>
			      <TELL
". Your " D ,SEARCH-BEAM " switches off since the " D ,AQUADOME "'s own">)
			     (T <TELL ". Its">)>
		       <TELL
" bright lights suffuse the " D ,GLOBAL-WATER
" around it with a glowing radiance.|
The " D ,SONARPHONE " is ringing." CR>
		       <RTRUE>)
		      (<NOT <L? ,DISTANCE-FROM-BAY ,AQUADOME-DISTANCE>>
		       <SETG SUB-IN-OPEN-SEA <>>
		       <FCLEAR ,AUTO-PILOT ,ONBIT>
		       <MOVE ,HORVAK-KEY ,HORVAK>	;"from GLOBAL-OBJECTS"
		       <SETG NOW-TERRAIN ,SEA-TERRAIN>
		       <SETG SUB-LON 0 ;6>
		       <SETG SUB-LAT -1 ;5>
		       <SETG SUB-DEPTH ,AIRLOCK-DEPTH>
		       <SETG TARGET-DEPTH ,AIRLOCK-DEPTH>
		       <SETG DIVING? 0>
		       <SETG THROTTLE-SETTING 0>
		       ;<COND (,DEBUG
			      <TELL "[Throttle=" N ,THROTTLE-SETTING "]" CR>)>
		       <SETG JOYSTICK-DIR ,P?NORTH>
		       ;<SETG SUB-IN-REVERSE? T>
		       <SETG SUB-DLON 0>
		       <SETG SUB-DLAT 1>
		       <SETG DEPTH-WARNING <>>
		       <FCLEAR ,DEPTHFINDER ,ONBIT>
		       <FSET ,AIRLOCK-HATCH ,OPENBIT>
		       <TELL CR
"The " D ,SUB " slows to a gentle stop, with engine idling and the "
D ,JOYSTICK " pointing north. The " D ,AUTO-PILOT " has brought you to the "
D ,AIRLOCK " on the south side of the " D ,AQUADOME ".
It also turned off the " D ,DEPTHFINDER " for you.|
At " D ,BLY "'s order, the " D ,AIRLOCK-HATCH " slides open, but you could
have done it by remote control, just as you ">
		       <COND (,OPENED-GATE-FROM-SUB <TELL "did ">)
			     (T <TELL "could have ">)>
		       <TELL
"the " D ,TANK-GATE ".|
The " D ,AIRLOCK " is filling up with tons of " D ,GLOBAL-WATER ".|
The " D ,AIRLOCK " lies north. You can enter it by opening the " D ,THROTTLE".
The bottom of the " D ,AIRLOCK " has an adjustable plastic cradle,
which adjusts to the keel of any submarine." CR>
		       <RFATAL>)>>
	       <RETURN .VAL>)>
	<SET LON ,SUB-LON>
	<SET LAT ,SUB-LAT>
	<SET DEP ,SUB-DEPTH>
	<SET TH ,THROTTLE-SETTING>
	<REPEAT ()
		<SET DEP <CHANGE-DEPTH .DEP>>
		<COND (<NOT <0? .TH>>
		       <SET LON <+ .LON ,SUB-DLON>>
		       <SET LAT <+ .LAT ,SUB-DLAT>>)>
		;<COND (,DEBUG
		       <TELL "[Lon=" N .LON ", Lat=" N .LAT
			    ", Dep=" N .DEP "]" CR>)>
		<COND (<COLLISION? .DEP .LON .LAT>
		       <RETURN>)
		      (<EQUAL? ,NOW-TERRAIN ,SEA-TERRAIN> T)
		      (<AND <0? .DEP>
			    <PROB 20>
			    <==? ,NOW-TERRAIN ,BAY-TERRAIN>>
		       <COND (<AND ,SPEEDBOAT-WARNING-GIVEN?
				 <NOT <==? ,MOVES ,SPEEDBOAT-WARNING-GIVEN?>>>
			      <GIVE-WARNINGS>
			      <TELL CR
"A speedboat came out of nowhere, hit your rudder, and ended your mission.
Too bad you were ">
			      <COND (<NOT ,EVER-SUBMERGED?> <TELL "still ">)>
			      <TELL "on the surface.">
			      <FINISH>)
			     (T
			      <SETG SPEEDBOAT-WARNING-GIVEN? ,MOVES>
			      <ADD-WARNING 1 T>)>)
		      (<TIME-FOR-FREIGHTER? .DEP .LON .LAT>
		       <COND (<==? ,JOYSTICK-DIR ,P?NORTH>
			      <SETG FREIGHTER-LON .LON>
			      <SETG FREIGHTER-DLON 0>
			      <SETG FREIGHTER-LAT <+ .LAT ,SONAR-RANGE>>
			      <SETG FREIGHTER-DLAT -1>)
			     (<==? ,JOYSTICK-DIR ,P?EAST>
			      <SETG FREIGHTER-LON <+ .LON ,SONAR-RANGE>>
			      <SETG FREIGHTER-DLON -1>
			      <SETG FREIGHTER-LAT .LAT>
			      <SETG FREIGHTER-DLAT 0>)
			     (T
			      <SETG FREIGHTER-LON <+ .LON ,SONAR-RANGE>>
			      <SETG FREIGHTER-DLON -1>
			      <SETG FREIGHTER-LAT <+ .LAT ,SONAR-RANGE>>
			      <SETG FREIGHTER-DLAT -1>)>
		       <COND (<L? 1 <GET5 <GET ,NOW-TERRAIN ,FREIGHTER-LAT>
					  ,FREIGHTER-LON>>
			      <FREIGHTER-WARNING>)>)
		      (<AND <EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			    <OR <AND <EQUAL? .LON  7> <EQUAL? .LAT 15>>
				<AND <EQUAL? .LON 13> <EQUAL? .LAT 17>>
				<AND <EQUAL? .LON 16> <EQUAL? .LAT 31>>>>
		       <TELL
"A submerged wreck on the floor of the bay to starboard will be cleared
safely." CR>)>
		<CHECK-FOR-OBSTACLE .DEP .LON .LAT>
		<COND (<DLESS? TH 1> <RETURN>)>>
	<SETG SUB-LON .LON>
	<SETG SUB-LAT .LAT>
	<SETG SUB-DEPTH .DEP>
	<OR <GIVE-WARNINGS> .VAL>>

<ROUTINE TIME-FOR-FREIGHTER? (DEP LON LAT)
 <COND (<NOT <==? ,NOW-TERRAIN ,BAY-TERRAIN>>
	<RFALSE>)
       (<NOT <FSET? ,FREIGHTER ,INVISIBLE>>
	<RFALSE>)
       (<NOT <L? .DEP 3>>
	<RFALSE>)
       (<NOT <==? 5 <GET5 <GET ,NOW-TERRAIN .LAT> .LON>>>
	<RFALSE>)
       (<OBSTACLE-AHEAD? ,SUB-DEPTH ,SUB-LON ,SUB-LAT>
	<RFALSE>)	;"Avoid ships appearing on far side of shoal."
       (<EQUAL? ,JOYSTICK-DIR ,P?NE ,P?EAST>
	<RTRUE>)
       (<NOT <EQUAL? ,JOYSTICK-DIR ,P?NORTH>>
	<RFALSE>)
       (<NOT <==? ,SUB-LON ,SPIRE-LON>>
	<RTRUE>)>>

<GLOBAL OLD-OBSTACLE? <>>

<ROUTINE CHECK-FOR-OBSTACLE (DEP LON LAT "AUX" X)
 <COND (<SET X <OBSTACLE-AHEAD? .DEP .LON .LAT>>
	<COND (,OLD-OBSTACLE?
	       <COND (<NOT <G? .X ,THROTTLE-SETTING>>
		      <SETG SONAR-WARNING ,SONAR-RED>
		      <ADD-WARNING 2 T>)
		     (<NOT <VERB? WAIT-FOR WAIT-UNTIL>>
		      <ADD-WARNING 8>)>)
	      (T
	       <SETG OLD-OBSTACLE? T>
	       <COND (<NOT <G? .X ,THROTTLE-SETTING>>
		      <SETG SONAR-WARNING ,SONAR-RED>)
		     (T <SETG SONAR-WARNING ,SONAR-YELLOW>)>
	       <ADD-WARNING 7 T>)>)
       (T
	<SETG OLD-OBSTACLE? <>> 
	<COND (,SONAR-WARNING
	       <SETG SONAR-WARNING <>>
	       <COND (<NOT ,SHIP-WARNING>
		      <TELL
"The " D ,SONARSCOPE-LIGHT " goes out." CR>)>)>)>>

<ROUTINE OBSTACLE-AHEAD? (DEP LON LAT "AUX" XLON XLAT RANGE X)
	<COND (<NOT <EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN ,SEA-TERRAIN>>
	       <RFALSE>)>
	<SET XLON <+ .LON ,SUB-DLON>>
	<SET XLAT <+ .LAT ,SUB-DLAT>>
	<SET RANGE 1>
	<REPEAT ()
		<COND (<AND <EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			    <SET X <TOO-DEEP? .DEP .XLON .XLAT>>
			    <NOT <EQUAL? .X ,OPEN-SEA-CODE>>>
		       <RETURN>)>
		<COND (<AND <EQUAL? ,NOW-TERRAIN ,SEA-TERRAIN>
			    <DOME-ON-SONAR? .DEP .XLON .XLAT>>
		       <COND (<NOT <HEADING-INTO-DOME?
				    ,SUB-DEPTH ,SUB-LON ,SUB-LAT>>
			      <RETURN>)>)>
		<COND (<IGRTR? RANGE ,SONAR-RANGE>
		       <RFALSE>)>
		<SET XLON <+ .XLON ,SUB-DLON>>
		<SET XLAT <+ .XLAT ,SUB-DLAT>>>
	.RANGE>

<ROUTINE HEADING-INTO-DOME? (DEP LON LAT)
	<AND <==? .DEP ,AIRLOCK-DEPTH>
	     <0? .LON>
	     <L? .LAT 1>
	     <0? ,SUB-DLON>
	     <L? 0 ,SUB-DLAT>
	     <FSET? ,AIRLOCK-HATCH ,OPENBIT>>>

<ROUTINE CHANGE-DEPTH (DEP)
 <COND (<L? .DEP ,TARGET-DEPTH>
	<DIVE-DESC .DEP T>
	<SET DEP <+ .DEP 1>>
	;<COND (,DEBUG <TELL "[New depth=" N .DEP "]" CR>)>)
       (<G? .DEP ,TARGET-DEPTH>
	<DIVE-DESC .DEP <>>
	<SET DEP <- .DEP 1>>
	;<COND (,DEBUG <TELL "[New depth=" N .DEP "]" CR>)>)
       (<NOT <0? ,DIVING?>>
	<SETG DIVING? 0>
	<TELL "The " D ,SUB " quickly levels out at the ">
	<COND (<0? .DEP> <TELL "surface.">)
	      (T <TELL "desired depth of " N <* 5 .DEP> " meters.">)>
	<COND (<0? ,THROTTLE-SETTING>
	       <TELL " It's now standing still in the water.">)
	      (T
	       <TELL " It's still moving toward ">
	       <DIR-PRINT ,JOYSTICK-DIR>
	       <TELL " at a speed of " N ,THROTTLE-SETTING " " D ,GRID-UNIT>
	       <COND (<NOT <==? 1 ,THROTTLE-SETTING>> <TELL "s">)>
	       <TELL " per turn.">)>
	<CRLF>)>
 .DEP>

<ROUTINE DIVE-DESC (DEP DOWN?)
 <COND (<0? .DEP>
	<TELL
"The " D ,GLOBAL-WATER " darkens to a deeper green as you descend from
the sunlit surface.">
	<COND (<FSET? ,HYDROPHONE ,ONBIT>
	       <TELL
" Engine and propeller noises come over the " D ,HYDROPHONE "
loudspeaker.">)>
	<CRLF>)>>

<OBJECT SEA-WALL
	(IN SUB)
	(FLAGS NDESCBIT)
	(DESC "sea wall")
	(ADJECTIVE SEA)
	(SYNONYM WALL)
	(VALUE 5)
	(ACTION SEA-WALL-F)>

<ROUTINE SEA-WALL-F ()
 <COND (<VERB? EXAMINE>
	<TOO-FAR-AWAY ,SEA-WALL>)>>

<OBJECT FREIGHTER
	(IN SUB)
	(FLAGS NDESCBIT INVISIBLE)
	(DESC "ship" ;"freighter")
	(SYNONYM FREIGHTER SHIP KEEL)
	(ACTION FREIGHTER-F)>

<ROUTINE FREIGHTER-F ()
 <COND (<VERB? EXAMINE ANALYZE>
	<FREIGHTER-SIZE>)>>

<ROUTINE FREIGHTER-SIZE ()
	<TELL
"Sonar shows the object reaching from the surface of the bay downward to
a depth of 10 meters. This must be the keel of a freighter entering the
harbor. It's moving toward the waterfront at the rate of 1 " D ,GRID-UNIT
" per turn." CR>>

<GLOBAL FREIGHTER-COUNT 0>
<GLOBAL FREIGHTER-LON 0>
<GLOBAL FREIGHTER-LAT 0>
<GLOBAL FREIGHTER-DLON 0>
<GLOBAL FREIGHTER-DLAT 0>

<ROUTINE FREIGHTER-WARNING ()
	<FCLEAR ,FREIGHTER ,INVISIBLE>
	<ENABLE <QUEUE I-UPDATE-FREIGHTER -1>>
	<SETG FREIGHTER-COUNT <+ 1 ,FREIGHTER-COUNT>>
	<SETG SHIP-WARNING ,SONAR-YELLOW>
	<COND (<==? 1 ,FREIGHTER-COUNT>
	       <ADD-WARNING 12 T>)
	      (T
	       <ADD-WARNING 13 T>)>>

<ROUTINE I-UPDATE-FREIGHTER ("AUX" DLAT DLON)
	<SETG FREIGHTER-LON <+ ,FREIGHTER-LON ,FREIGHTER-DLON>>
	<SETG FREIGHTER-LAT <+ ,FREIGHTER-LAT ,FREIGHTER-DLAT>>
	<COND (<OR <NOT <==? ,NOW-TERRAIN ,BAY-TERRAIN>>
		   <L? ,SONAR-RANGE
		       <ABS <SET DLAT <- ,FREIGHTER-LAT ,SUB-LAT>>>>
		   <L? ,SONAR-RANGE
		       <ABS <SET DLON <- ,FREIGHTER-LON ,SUB-LON>>>>
		   <G? 2 <GET5 <GET ,NOW-TERRAIN ,FREIGHTER-LAT>
			       ,FREIGHTER-LON>>>
	       <QUEUE I-UPDATE-FREIGHTER 0>
	       <FSET ,FREIGHTER ,INVISIBLE>
	       ;<COND (,TOLD-ABOUT-SHIP
		      <TELL "You're out of danger from the ship." CR>)>
	       <RFALSE>)
	      (<AND <0? .DLAT> <0? .DLON> <L? ,SUB-DEPTH 3>>
	       <FREIGHTER-COLLIDED>
	       <FINISH>)
	      (<AND <L? ,SUB-DEPTH 3>		;"Give sonar warning?"
		    <OR <AND <==? ,JOYSTICK-DIR ,P?NORTH>
			     <0? .DLON>
			     <G? .DLAT 0>>
			<AND <==? ,JOYSTICK-DIR ,P?EAST>
			     <0? .DLAT>
			     <G? .DLON 0>>
			<AND <==? ,JOYSTICK-DIR ,P?NE>
			     <==? .DLON .DLAT>
			     <G? .DLAT 0>>>>
	       <COND (<OR <AND <==? ,JOYSTICK-DIR ,P?NORTH>
			       <OR <L? .DLAT ,THROTTLE-SETTING>
				   <=? .DLAT ,THROTTLE-SETTING>
				   <AND <0? ,THROTTLE-SETTING>
					<L? .DLAT 2>>>>
			  <AND <==? ,JOYSTICK-DIR ,P?EAST>
			       <OR <L? .DLON ,THROTTLE-SETTING>
				   <=? .DLON ,THROTTLE-SETTING>
				   <AND <0? ,THROTTLE-SETTING>
					<L? .DLON 2>>>>
			  <AND <==? ,JOYSTICK-DIR ,P?NE>
			       <OR <L? .DLAT ,THROTTLE-SETTING>
				   <=? .DLAT ,THROTTLE-SETTING>
				   <AND <0? ,THROTTLE-SETTING>
					<L? .DLAT 2>>>>>
		      <COND (<EQUAL? ,SHIP-WARNING ,SONAR-RED>
			     <TELL-SONAR-WARNING ,SHIP-WARNING>)
			    (T
			     <SETG SHIP-WARNING ,SONAR-RED>
			     <ADD-WARNING 14 T>)>)
		     (,SHIP-WARNING
		      <TELL-SONAR-WARNING ,SHIP-WARNING>)>)
	      (<AND ,SHIP-WARNING
		    <NOT ,SONAR-WARNING
			 ;<OBSTACLE-AHEAD? ,SUB-DEPTH ,SUB-LON ,SUB-LAT>>>
	       <TELL
"The " D ,SONARSCOPE-LIGHT " goes out and your heartbeat
gradually slows to normal">
	       <COND (<==? ,SHIP-WARNING ,SONAR-RED>
		      <TELL
", now that the noise from the " D ,ALARM-SUB " and the ship have gone">)>
	       <SETG SHIP-WARNING <>>
	       <TELL "." CR>)>>

<GLOBAL DEPTH-WARNING <>>
<CONSTANT DEPTH-ORANGE 5>
<CONSTANT DEPTH-RED 6>

<ROUTINE DOME-ON-SONAR? (DEP LON LAT "AUX" HYPOT X)
 <COND (<L? +1 .LON> <RFALSE>)
       (<L? +1 .LAT> <RFALSE>)
       (<G? -1 .LON> <RFALSE>)
       (<G? -1 .LAT> <RFALSE>)
       (<L? 2 <SET X <- ,SEA-DEPTH .DEP>>> <RFALSE>)
       (,FINE-SONAR
	<SET HYPOT <+ <* .LON .LON> <* .LAT .LAT>>>
	<COND (<G? 3 <+ .X .HYPOT>> <RTRUE>)
	      (T <RFALSE>)>)
       (<AND <0? .LON> <0? .LAT>>
	<RTRUE>)
       (T <RFALSE>)>>

<ROUTINE FREIGHTER-COLLIDED ()
	<TELL
"|
You and Tip are hurled from your seats as the " D ,SUB " and the ship
collide! The sub is up-ended and swept aside by the momentum of the ship.
Thanks to the strength of your revolutionary hull design, the " D
,SUB " is still okay, but its machinery is hopelessly damaged.|
|
Because you didn't change heading or dive under the ship, you and
Tip are now adrift and must wait to be rescued by">
	<RESEARCH-LAB>
	<TELL
". Your mission to save the " D ,AQUADOME " and
its crew from attack by the " D ,GLOBAL-SNARK " will have to be
abandoned.">>

<ROUTINE SONAR-TO-MANUAL ()
	<COND (<AND ,AUTOMATIC-SONAR <SPLIT-SCREEN?>>
	       <SETG AUTOMATIC-SONAR <>>
	       <SETG SCREEN-NOW-SPLIT <>>
	       <SPLIT 0>
	       <DISABLE <INT I-SHOW-SONAR>>
	       <TELL
"The " D ,SONARSCOPE " " D ,AUTOMATIC "ally sets itself to manual." CR>)>>

<ROUTINE COLLISION? (DEP LON LAT ;DLAT "AUX" X)
	;<COND (<NOT <FSET? ,FREIGHTER ,INVISIBLE>>
	       <UPDATE-FREIGHTER>)>
	<COND (,SUB-IN-OPEN-SEA <RFALSE>)
	      (<NOT <FSET? ,SNARK ,INVISIBLE>>
	       <COND (<THORPE-POS? .LON .LAT>
		      <TELL
"|
CRR-R-RAAASSSHHH-H-H!|
|
With a deafening clang, the " D ,THORPE-SUB " and your sub
collide! The " D ,SUB " shudders, and you and Tip are
hurled to the deck!|
You claw your way to the controls, but there's no power,
no matter how you gun the throttle! The engine's been damaged by the
collision!|
">
		      <COND (<NOT <FSET? ,THORPE ,MUNGBIT>>
			     <TELL
"Through the " D ,SUB-WINDOW " you see the " D ,THORPE-SUB ", and it
looks helpless too. Its hull is intact, but . . . UH-OH! Its rocket
weapon is swinging slowly in your direction!|
">)>
		      <TELL
"As you and Tip eye each other despairingly, one thing's for sure: THE
ADVENTURE'S OVER!">)
		     (<SNARK-POS? .LON .LAT>
		      <TELL
"There's a sudden jolt! Your " D ,SUB " stops moving for a moment,
as if you hit some huge mass. Tip looks ">
		      <COND (<FSET? ,SONARSCOPE ,ONBIT>
			     <TELL "at the " D ,SONARSCOPE>)
			    (T <TELL "out the " D ,SUB-WINDOW>)>
		      <TELL " and gulps, \"We've rammed the " D ,SNARK>
		      <COND (<FSET? ,CLAW ,MUNGBIT> <TELL " again!\"" CR>)
			    (T
			     <FSET ,CLAW ,MUNGBIT>
			     <SETG TEST-BUTTON-READOUT ,CLAW-MUNGED-MSG>
			     <TELL
"! I hope the " D ,CLAW "s aren't damaged!\"" CR>)>
		      <RFALSE>)
		     (T <RFALSE>)>
	       <FINISH>)
	      (<AND <NOT <FSET? ,FREIGHTER ,INVISIBLE>>
		    <EQUAL? ,FREIGHTER-LAT .LAT>
		    <EQUAL? ,FREIGHTER-LON .LON>
		    <L? .DEP 3>>
	       <FREIGHTER-COLLIDED>
	       <FINISH>)>
	;<SETG SUB-DLAT .DLAT>
	<COND (<SET X <TOO-DEEP? .DEP .LON .LAT>>
	       <COND (<EQUAL? .X ,HIT-BOTTOM-CODE ,HIT-SHORE-CODE>
		      <COND (,SCREEN-NOW-SPLIT
			     <SCREEN 1>
			     <SHOW-SONARSCOPE>
			     <SCREEN 0>)>
		      <TELL
"|
Suddenly you're thrown out of your seat by a thunderous crash,
and the " D ,SUB " comes to a shuddering halt!|
">
		      <TIP-SAYS>
		      <TELL "Skipper! You've plowed into the ">
		      <COND (<AND <==? .LON ,SPIRE-LON> <==? .LAT ,SPIRE-LAT>>
			     <TELL "rock spire">)
			    (<==? .X ,HIT-SHORE-CODE>
			     <TELL "shore">)
			    (T
			     <TELL "floor of the ">
			     <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
				    <TELL "bay">)
				   (T <TELL "ocean">)>)>
		      <TELL
"! Jumpin' jets, let's hope your new " D ,SUB " isn't wrecked!\"|
Unfortunately, the " D ,SUB " is now disabled. You must call">
		      <RESEARCH-LAB>
		      <TELL
" for help, and the situation forces you to abandon hope of
saving the " D ,AQUADOME " from attacks by the " D ,SNARK ".">)
		     (<==? .X ,OPEN-SEA-CODE>
		      <SETG NOW-TERRAIN <>>
		      <SETG SUB-IN-OPEN-SEA T>
		      <FCLEAR ,CATALYST-CAPSULE ,TAKEBIT>
		      <FSET ,CATALYST-CAPSULE ,TRYTAKEBIT>
		      <MOVE ,BLACK-BOX ,BLY-DESK>
		      <SETG DEPTH-WARNING <>>
		      <SETG SONAR-WARNING <>>
		      <SETG SHIP-WARNING <>>
		      <FSET ,FREIGHTER ,INVISIBLE>
		      <THIS-IS-IT ,AUTO-PILOT>
		      <TELL
"You have just passed through the opening in the " D ,SEA-WALL " across the
mouth of " D ,BAY ", and you're now in the " D ,SEA "." CR>
		      <ENABLE <QUEUE I-AUTO-PILOT 1>>
		      <SONAR-TO-MANUAL>
		      <SCORE-OBJ ,SEA-WALL>
		      <SAVE-HINT>
		      <RFATAL>)
		     (<==? .X ,HIT-DOME-CODE>
		      <TELL
"Oh, oh! The " D ,SUB " has crashed into the " D ,AQUADOME "!|
\"We've cracked the dome, "FN"!\" gulps Tip as he surveys the damage.|
You're speechless. The " D ,AQUADOME " is flooding fast, and soon it
will break apart under zillions of tons of " D ,GLOBAL-WATER "!|
You try to shut out the scattered screams for help coming over the
sonarphone.|
|
There's nothing left but to report that the " D ,AQUADOME " was accidentally
destroyed, and your mission has failed.">)
		     (<==? .X ,IN-DOME-CODE>
		      <SETG NOW-TERRAIN <>>
		      <SETG SUB-IN-DOME T>
		      <SETG BLY-CALLING <>>
		      <PHONE-OFF>
		      <SONAR-TO-MANUAL>
		      ;<QUEUE I-UPDATE-SUB-POSITION 0>
		      <SETG THROTTLE-SETTING 0>
		      <SETG SHIP-WARNING <>>
		      <SETG SONAR-WARNING <>>
		      <SETG DEPTH-WARNING <>>
		      ;<COND (,DEBUG
			     <TELL "[Throttle=" N ,THROTTLE-SETTING "]" CR>)>
		      ;<SETG JOYSTICK-DIR ,P?SOUTH>
		      ;<SETG SUB-IN-REVERSE? <>>
		      <TELL "|
The " D ,SUB " is now resting in the cradle in the rectangular " D ,AIRLOCK ".
The " D ,AIRLOCK-HATCH " closes, and so does the " D ,THROTTLE ".|
Through the " D ,SUB-WINDOW " you can see the water level going down
inside the " D ,AIRLOCK ". The docking crew is pumping out
the " D ,GLOBAL-WATER ". This will take 1 turn." CR>
		      <FCLEAR ,AIRLOCK-HATCH ,OPENBIT>
		      <QUEUE I-THORPE-APPEARS 0>
		      <ENABLE <QUEUE I-AIRLOCK-EMPTY 1>>
		      <SCORE-OBJ ,AQUADOME>
		      <RTRUE>)>
	       <FINISH>)
	      (<NOT <FSET? ,DEPTHFINDER ,ONBIT>>
	       <RFALSE>)
	      (<CHECK-DEPTH .DEP .LON .LAT> <RFALSE>)
	      (,DEPTH-WARNING
	       <SETG DEPTH-WARNING <>>
	       <ADD-WARNING 10>
	       <RFALSE>)>>

<CONSTANT HIT-DOME-CODE 5>
<CONSTANT OPEN-SEA-CODE 4>
<CONSTANT IN-DOME-CODE 3>
<CONSTANT HIT-SHORE-CODE 2>
<CONSTANT HIT-BOTTOM-CODE 1>

<ROUTINE TOO-DEEP? (DEP LON LAT "AUX" X)
 <COND (<EQUAL? ,NOW-TERRAIN ,SEA-TERRAIN>
	<COND (<AND <HEADING-INTO-DOME? .DEP .LON .LAT>
		    <OR <AND ,FINE-SONAR <G? .LAT -2>>
			<0? .LAT>>>
	       ,IN-DOME-CODE)
	      (<DOME-ON-SONAR? .DEP .LON .LAT> ,HIT-DOME-CODE)
	      (<==? .DEP ,SEA-DEPTH> ,HIT-BOTTOM-CODE)>)
       (T
	<SET X <GET5 <GET ,NOW-TERRAIN .LAT> .LON>>
	<COND (<==? .X 6> ,OPEN-SEA-CODE)
	      (<L? .DEP .X> <RFALSE>)
	      (<0? .X> ,HIT-SHORE-CODE)
	      (T ,HIT-BOTTOM-CODE)>)>>

<GLOBAL SUB-IN-TANK T>
<GLOBAL GATE-CRASHED <>>
<GLOBAL SUB-IN-OPEN-SEA <>>
<GLOBAL SUB-IN-DOME <>>
"<GLOBAL SUB-IN-DOME-FACING-SOUTH 0>"

<ROUTINE GATE-CRASH (STR OBJ GATE)
 <COND (<EQUAL? .GATE ,AIRLOCK-HATCH>
	;<THIS-IS-IT ,AIRLOCK-HATCH>
	;<YOU-CANT "leave" ,AIRLOCK-HATCH "closed">
	<TELL
"You can't leave the " D ,AIRLOCK " with the " D  ,AIRLOCK-HATCH" closed!"CR>)
       (T
	<SETG GATE-CRASHED T>
	<FCLEAR ,ENGINE ,ONBIT>
	<SETG TEST-BUTTON-READOUT ,GATE-CRASHED-MSG>
	<TELL
"As you " .STR THE .OBJ ", you hear a loud boom! The " D ,SUB
" shivers. You have crashed into the Repelatron
Safety Bumper on the " D ,TANK-GATE ". The turbine stops " D ,AUTOMATIC "ally.
Too bad the gate was closed!" CR>)>>

<OBJECT CAPSULE-LEVER
	(IN SUB)
	(DESC "reactor lever")	;"capsule-insertion lever"
	(ADJECTIVE CAPSULE INSERT REACTOR)
	(SYNONYM LEVER HANDLE)
	(FLAGS NDESCBIT)
	;(VALUE 5)
	(ACTION CAPSULE-LEVER-F)>

<ROUTINE CAPSULE-LEVER-F ()
 <COND (<VERB? ;"OPEN CLOSE" EXAMINE>
	<PERFORM ,PRSA ,REACTOR>
	<RTRUE>)
       (<VERB? MOVE PUSH USE>
	<COND (<FSET? ,REACTOR ,ONBIT>
	       <TELL ,I-ASSUME " turn off the " D ,REACTOR ".)" CR>
	       <PERFORM ,V?LAMP-OFF ,REACTOR>
	       <RTRUE>)
	      (T
	       <TELL ,I-ASSUME " turn on the " D ,REACTOR ".)" CR>
	       <PERFORM ,V?LAMP-ON ,REACTOR>
	       <RTRUE>)>)>>

<OBJECT DEPTHFINDER
	(IN SUB)
	(DESC "depth finder")
	(ADJECTIVE	DEPTH)
	(SYNONYM	FINDER METER GAUGE DEPTHFINDER)
	(FLAGS NDESCBIT ONBIT ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION DEPTHFINDER-F)>

<CONSTANT SEA-DEPTH 30>
<CONSTANT AIRLOCK-DEPTH 29>

<ROUTINE DEPTHFINDER-F ("AUX" N)
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<AND ,SUB-IN-TANK <WHY-NEED ,DEPTHFINDER ,TEST-TANK>>
	<RTRUE>)
       (<AND ,SUB-IN-DOME <WHY-NEED ,DEPTHFINDER ,AIRLOCK>>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	<SETG DEPTH-WARNING <>>
	<RFALSE>)
       (<VERB? LAMP-ON>
	<CHECK-DEPTH ,SUB-DEPTH ,SUB-LON ,SUB-LAT>
	<RFALSE>)
       (<VERB? ANALYZE EXAMINE WHAT READ>
	<COND (<NOT <FSET? ,DEPTHFINDER ,ONBIT>>
	       <TELL "It's not on!" CR>
	       <RTRUE>)>
	<TELL "You're now ">
	<COND (<0? ,SUB-DEPTH> <TELL "on the surface">)
	      (T <TELL "at a depth of " N <* 5 ,SUB-DEPTH> " meters">)>
	<COND (<NOT ,NOW-TERRAIN> <TELL "." CR> <RTRUE>)>
	<SET N <- <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			 <GET5 <GET ,NOW-TERRAIN ,SUB-LAT> ,SUB-LON>)
			(T ,SEA-DEPTH)>
		  ,SUB-DEPTH>>
	<TELL ", " N <* 5 .N> " meters above the ">
	<COND (<==? ,NOW-TERRAIN ,BAY-TERRAIN>
	       <TELL "floor of the bay." CR>)
	      (T <TELL "bottom of the sea." CR>)>
	;<COND (,DEPTH-WARNING <TELL ,DEPTH-WARNING CR>)>
	<RTRUE>)>>

<ROUTINE CHECK-DEPTH (DEP LON LAT)
 <COND (<AND <NOT <0? .DEP>>
	     <TOO-DEEP? <+ 1 .DEP> .LON .LAT>>
	<COND (<==? ,DEPTH-WARNING ,DEPTH-ORANGE>
	       <ADD-WARNING 11 T>)
	      (<==? ,DEPTH-WARNING ,DEPTH-RED>
	       <COND (<VERB? WAIT-FOR WAIT-UNTIL> T)
		     (T <ADD-WARNING ,DEPTH-RED>)>)
	      (T <ADD-WARNING 4 T>)>
	<SETG DEPTH-WARNING ,DEPTH-RED>
	<RTRUE>)
       (<AND <NOT <0? .DEP>>
	     <TOO-DEEP? <+ 2 .DEP> .LON .LAT>>
	<COND (<==? ,DEPTH-WARNING ,DEPTH-ORANGE>
	       <COND (<VERB? WAIT-FOR WAIT-UNTIL> T)
		     (T <ADD-WARNING ,DEPTH-ORANGE>)>)
	      (<==? ,DEPTH-WARNING ,DEPTH-RED>
	       <ADD-WARNING 9>)
	      (T <ADD-WARNING 3 T>)>
	<SETG DEPTH-WARNING ,DEPTH-ORANGE>
	<RTRUE>)>>

<OBJECT DEPTHFINDER-LIGHT
	(IN SUB)
	(DESC "depth finder warning light")
	(ADJECTIVE DEPTHFINDER DEPTH FINDER WARNING ORANGE RED)
	(SYNONYM WARNING LIGHT ;LIGHTS)
	(FLAGS NDESCBIT)
	(GENERIC GENERIC-LIGHT-F)
	(ACTION DEPTHFINDER-LIGHT-F)>

<ROUTINE DEPTHFINDER-LIGHT-F ()
 <COND (<VERB? ANALYZE EXAMINE READ REPLY>
	<COND (<NOT ,DEPTH-WARNING>
	       <TELL "The " D ,DEPTHFINDER-LIGHT " is off." CR>)>
	<TELL
"During a dive, the " D ,DEPTHFINDER-LIGHT " turns orange and a "
D ,ALARM-SUB " sounds if the " D ,SUB " comes within 10 meters of the bottom.|
The light turns red and the " D ,ALARM-SUB " becomes louder if the
" D ,SUB " comes within 5 meters of the bottom." CR>)>>

<GLOBAL SHIP-WARNING <>>
<GLOBAL SONAR-WARNING <>>
<CONSTANT SONAR-YELLOW 1>
<CONSTANT SONAR-RED 2>

<ROUTINE TELL-SONAR-WARNING ("OPTIONAL" (W <>))
	<TELL "The " D ,SONARSCOPE-LIGHT " continues to glow ">
	<COND (<NOT .W> <SET W ,SONAR-WARNING>)>
	<COND (<1? .W> <TELL "yellow." CR>)
	      (T <TELL
"red, and the " D ,ALARM-SUB " also continues to sound." CR>)>>

<GLOBAL LOOKED-AT-SONAR 0>
<GLOBAL AUTOMATIC-SONAR <>>
<GLOBAL SCREEN-NOW-SPLIT <>>
<GLOBAL FINE-SONAR <>>

<OBJECT AUTOMATIC
	(IN SUB ;GLOBAL-OBJECTS)
	(SYNONYM AUTO AUTOMATIC)
	(DESC "automatic")
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION AUTOMATIC-F)>

<ROUTINE AUTOMATIC-F ()
 <COND (<VERB? LAMP-ON LAMP-OFF>
	<PERFORM ,PRSA ,AUTO-PILOT>
	<RTRUE>)>>

<OBJECT MANUAL
	(IN SUB ;GLOBAL-OBJECTS)
	(SYNONYM MANUAL)
	(DESC "manual")
	(FLAGS NDESCBIT)
	(ACTION MANUAL-F)>

<ROUTINE MANUAL-F ()
 <COND (<VERB? LAMP-ON>
	<PERFORM ,V?LAMP-OFF ,AUTO-PILOT>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	<PERFORM ,V?LAMP-ON ,AUTO-PILOT>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE READ TAKE OPEN TURN>
	<TELL "It's not that kind of manual." CR>)>>

<OBJECT SONARSCOPE
	(IN SUB)
	(DESC "sonarscope")
	(ADJECTIVE SONAR)
	(SYNONYM SONARSCOPE ;SONAR SCOPE SCREEN BLIP ;BLIPS ;MAP)
	(FLAGS NDESCBIT ONBIT ON?BIT READBIT)
	(ACTION SONARSCOPE-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<CONSTANT SONAR-RANGE 5>

<ROUTINE NOT-AVAILABLE ()
	<TELL
"Sorry, " FN ", but that feature isn't available." CR>>

<ROUTINE SONARSCOPE-F ("AUX" DEP N)
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<VERB? LAMP-ON>
	<COND (<SPLIT-SCREEN?>
	       <COND (T ;<NOT <FSET? ,SONARSCOPE ,ONBIT>>
		      <FSET ,SONARSCOPE ,ONBIT>)>
	       ;<TELL
,I-ASSUME " set the " D ,SONARSCOPE " to " D ,AUTOMATIC ".)" CR>
	       <PERFORM ,V?SET ,SONARSCOPE ,AUTOMATIC>
	       <RTRUE>)>)
       (<NOT <FSET? ,SONARSCOPE ,ONBIT>>
	<THIS-IS-IT ,SONARSCOPE>
	<TELL "It's not turned on!" CR>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	<COND (,AUTOMATIC-SONAR
	       ;<TELL
,I-ASSUME " set the " D ,SONARSCOPE " to " D ,MANUAL ".)" CR>
	       ;"Following expr un-semicoloned by MARC 4/16/84"
	       <PERFORM ,V?SET ,SONARSCOPE ,MANUAL>
	       ;<COND (<FSET? ,SONARSCOPE ,ONBIT>
		      <FCLEAR ,SONARSCOPE ,ONBIT>)>
	       <SETG AUTOMATIC-SONAR <>>
	       ;"Rfalse changed to RTRUE by MARC 4/16/84"
	       <RTRUE> ;<RFALSE>)>)
       (<AND ,SUB-IN-TANK <WHY-NEED ,SONARSCOPE ,TEST-TANK>>
	<RTRUE>)
       (<AND ,SUB-IN-OPEN-SEA <WHY-NEED ,SONARSCOPE ,SEA>>
	<RTRUE>)
       (<AND ,SUB-IN-DOME <WHY-NEED ,SONARSCOPE ,AIRLOCK>>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE READ LOOK-INSIDE LOOK-ON>
	;<COND (,DEBUG
	       <TELL "[Sub depth=" N ,SUB-DEPTH ", bottom=" N
		     <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			    <GET5 <GET ,NOW-TERRAIN ,SUB-LAT> ,SUB-LON>)
			   (T ,SEA-DEPTH)>
		     ", long=" N ,SUB-LON ", lat=" N ,SUB-LAT ".]" CR>)>
	;<COND (<OR ,SUB-IN-TANK ,SUB-IN-OPEN-SEA ,SUB-IN-DOME>
	       <TELL <GETP ,SONARSCOPE ,P?TEXT> CR>
	       <RTRUE>)>
	<SETG P-WON <>>
	<INC LOOKED-AT-SONAR>
	<COND (<AND <SPLIT-SCREEN?> <0? <MOD ,LOOKED-AT-SONAR 4>>>
	       <TIP-SAYS>
	       <TELL
"You wouldn't have to keep looking at the " D ,SONARSCOPE " if
you set it to " D ,AUTOMATIC ".\"" CR>)>
	<SET DEP ,SUB-DEPTH>
	<COND (,SONAR-WARNING <TELL-SONAR-WARNING>)>
	<COND (,SHIP-WARNING  <TELL-SONAR-WARNING ,SHIP-WARNING>)>
	<COND (<AND <L? .DEP 3> <NOT <FSET? ,FREIGHTER ,INVISIBLE>>>
	       <FREIGHTER-SIZE>
	       <CRLF>)>
	<FIXED-FONT-ON>
	<TELL "(+=you, .=open water, *=obstacle)" CR>
	<SET N <* 2 ,SONAR-RANGE>>
	<REPEAT ()
		<TELL "--">
		<COND (<DLESS? N 0> <CRLF> <RETURN>)>>
	<COND (,SCREEN-NOW-SPLIT
	       <FIXED-FONT-OFF>
	       <ALREADY ,PLAYER "looking at it">)
	      (T <SHOW-SONARSCOPE>)>
	<RTRUE>)
       ;(<AND <VERB? PUT> <DOBJ? SONARSCOPE>>
	<PERFORM ,V?SET ,PRSO ,PRSI>
	<RTRUE>)
       (<AND <VERB? SET PUT MOVE-DIR> <DOBJ? SONARSCOPE>>
	<COND (<IOBJ? AUTOMATIC>
	       <COND (,AUTOMATIC-SONAR
		      <ALREADY ,SONARSCOPE "set to automatic">)
		     (<SPLIT-SCREEN?>
		      <SETG AUTOMATIC-SONAR T>
		      <SETG SCREEN-NOW-SPLIT T>
		      <START-SONAR?>
		      <OKAY ,SONARSCOPE "set to automatic">)
		     (T <NOT-AVAILABLE>)>)
	      (<IOBJ? MANUAL>
	       <COND (<NOT ,AUTOMATIC-SONAR>
		      <ALREADY ,SONARSCOPE "set to manual">)
		     (<SPLIT-SCREEN?>
		      <SETG AUTOMATIC-SONAR <>>
		      <SETG SCREEN-NOW-SPLIT <>>
		      <SPLIT 0>
		      <DISABLE <INT I-SHOW-SONAR>>
		      <OKAY ,SONARSCOPE "set to manual">)
		     (T <NOT-AVAILABLE>)>)
	      ;(T <RFALSE>)>)>>

<ROUTINE SHOW-SONARSCOPE
	("AUX" DEP N RANGE LAT MINLAT LON MAXLON X Y LATP2 LATP1 LATM1)
	<SET DEP ,SUB-DEPTH>
	<FIXED-FONT-ON>
	<COND (<NOT <FSET? ,SNARK ,INVISIBLE>>
	       <TELL "@@=SEACAT Oooo=MONSTER">
	       <COND (,SUB-IN-BATTLE
		      <TELL   " #=DANGER">)
		     (T <TELL "         ">)>)	;"31 chars on line"
	      (T
	       <COND (<OR <EQUAL? ,SHIP-WARNING ,SONAR-RED>
			  <EQUAL? ,SONAR-WARNING ,SONAR-RED>>
		      <TELL "SONAR:*RED*">)
		     (<OR <EQUAL? ,SHIP-WARNING ,SONAR-YELLOW>
			  <EQUAL? ,SONAR-WARNING ,SONAR-YELLOW>>
		      <TELL "SONAR:YELLO">)
		     (T
		      <TELL "           ">)>
	       <TELL " ">
	       <COND (<==? ,DEPTH-WARNING ,DEPTH-ORANGE>
		      <TELL "DEPTH:ORANGE">)
		     (<EQUAL? ,DEPTH-WARNING ,DEPTH-RED>
		      <TELL "DEPTH:*RED* ">)
		     (T
		      <TELL "            ">)>
	       <TELL " ">
	       <COND (<AND <L? .DEP 3> <NOT <FSET? ,FREIGHTER ,INVISIBLE>>>
		      <TELL   "@=SHIP">)
		     (T <TELL "      ">)>)>
	<CRLF>
	<SET RANGE ,SONAR-RANGE>
	<SET    LAT <+ ,SUB-LAT .RANGE>>
	<SET MINLAT <- ,SUB-LAT .RANGE>>
	<SET MAXLON <+ ,SUB-LON .RANGE>>
	<SET X 39 ;<* 5 <GET <GET ,NOW-TERRAIN 1> 0>>>
	<SET Y <GET ,NOW-TERRAIN 0>>	;"coord's of NE corner"
	<SET LATP2 <+ ,SUB-LAT 2>>
	<SET LATP1 <+ ,SUB-LAT 1>>
	<SET LATM1 <- ,SUB-LAT 1>>
	<REPEAT ()
	 <SET LON <- ,SUB-LON .RANGE>>
	 <REPEAT ()
		<COND (<AND <==? .LAT ,SUB-LAT> <==? .LON ,SUB-LON>>
		       <TELL " +">)
		      (<NOT <FSET? ,SNARK ,INVISIBLE>>
		       <COND (<THORPE-POS? .LON .LAT>
			      <TELL " @">)
			     (<SNARK-HEAD-POS? .LON .LAT>
			      <TELL " O">)
			     (<SNARK-TAIL-POS? .LON .LAT>
			      <TELL " o">)
			     (<AND ,SUB-IN-BATTLE
				   <THORPE-SHOOT? .LON .LAT>>
			      <TELL " #">)
			     (T <TELL " .">)>)
		      (<EQUAL? ,NOW-TERRAIN ,SEA-TERRAIN>
		       <COND (<DOME-ON-SONAR? .DEP .LON .LAT> <TELL " *">)
			     (T <TELL " .">)>)
		      (<AND <NOT <FSET? ,FREIGHTER ,INVISIBLE>>
			    <L? .DEP 3>
			    <==? .LAT ,FREIGHTER-LAT>
			    <==? .LON ,FREIGHTER-LON>>
		       <TELL " @">)
		      (<OR <AND <G? .LAT .Y>
				<==? 6 <GET5 <GET ,NOW-TERRAIN .Y> .LON>>>
			   <AND <G? .LON .X>
				<==? 6 <GET5 <GET ,NOW-TERRAIN .LAT> .X>>>>
		       <TELL " .">)
		      (<OR <L? .LAT 1>
			   <L? .LON 1>
			   <G? .LAT .Y>
			   <G? .LON .X>>
		       <TELL " *">)
		      (<L? .DEP <GET5 <GET ,NOW-TERRAIN .LAT> .LON>>
		       <TELL " .">)
		      (T
		       <TELL " *">)>
		<COND (<IGRTR? LON .MAXLON>
		       <COND (<==? .LAT .LATP2>
			      <TELL " HDG:">
			      <COND (<==? ,SUB-DLAT +1> <TELL "N">)
				    (<==? ,SUB-DLAT -1> <TELL "S">)>
			      <COND (<==? ,SUB-DLON +1> <TELL "E">)
				    (<==? ,SUB-DLON -1> <TELL "W">)>
			      <TELL " ">)
			     (<==? .LAT .LATP1>
			      <COND (<==? ,JOYSTICK-DIR ,P?NW>
				     <TELL "  \\  ">)
				    (<==? ,JOYSTICK-DIR ,P?NORTH>
				     <TELL "   ! ">)
				    (<==? ,JOYSTICK-DIR ,P?NE>
				     <TELL "    /">)
				    (T
				     <TELL "     ">)>)
			     (<==? .LAT ,SUB-LAT>
			      <TELL " ">
			      <COND (<==? ,JOYSTICK-DIR ,P?WEST> <TELL "--">)
				    (T <TELL "  ">)>
			      <TELL "+">
			      <COND (<==? ,JOYSTICK-DIR ,P?EAST> <TELL "--">)
				    (T <TELL "  ">)>)
			     (<==? .LAT .LATM1>
			      <COND (<==? ,JOYSTICK-DIR ,P?SW>
				     <TELL "  /  ">)
				    (<==? ,JOYSTICK-DIR ,P?SOUTH>
				     <TELL "   ! ">)
				    (<==? ,JOYSTICK-DIR ,P?SE>
				     <TELL "    \\">)
				    (T
				     <TELL "     ">)>)>
		       <CRLF>
		       <RETURN>)>>
	 <COND (<DLESS? LAT .MINLAT> <RETURN>)>>
	<SET N <* 2 .RANGE>>
	<REPEAT ()
		<TELL "--">
		<COND (<DLESS? N 0> <CRLF> <RETURN>)>>
	<FIXED-FONT-OFF>
	<RTRUE>>

<ROUTINE START-SONAR? ()
	 <COND (,SCREEN-NOW-SPLIT
		<SPLIT <+ 3 <* 2 ,SONAR-RANGE>>>
		<SETG SONAR-DIR 0>	;"to ensure update"
		;"Un-SEMI'd next expr - MARC 4/17/84"
		<I-SHOW-SONAR>		;"only for IBM-PC bug?"
		<ENABLE <QUEUE I-SHOW-SONAR -1>>)>>

<OBJECT SONARSCOPE-LIGHT
	(IN SUB)
	(DESC "sonarscope warning light")
	(ADJECTIVE SONARSCOPE WARNING YELLOW RED)
	(SYNONYM WARNING LIGHT ;LIGHTS)
	(FLAGS NDESCBIT)
	(GENERIC GENERIC-LIGHT-F)
	(ACTION SONARSCOPE-LIGHT-F)>

<ROUTINE SONARSCOPE-LIGHT-F ()
 <COND (<VERB? ANALYZE EXAMINE READ REPLY>
	<COND (<AND <NOT ,SONAR-WARNING> <NOT ,SHIP-WARNING>>
	       <TELL "The " D ,SONARSCOPE-LIGHT " is off."CR>)>
	<TELL
"A yellow " D ,SONARSCOPE-LIGHT " shows that the bearing of a blip is
NOT CHANGING, even if you and/or the object causing the blip are moving.
This means you're on a COLLISION COURSE!|
The light will turn red and a loud " D ,ALARM-SUB " will sound if you
and the approaching object are within ONE TURN of a collision!">)>>

<OBJECT ALARM-SUB
	(IN SUB)
	(DESC "warning buzzer")
	(ADJECTIVE DEPTHFINDER DEPTH FINDER SONARSCOPE ALARM WARNING)
	(SYNONYM ALARM BUZZER)
	(FLAGS NDESCBIT)
	(ACTION ALARM-SUB-F)>

<ROUTINE ALARM-SUB-F ()
	<COND (<VERB? LAMP-OFF LISTEN REPLY STOP>
	       <TELL "Why not avoid the obstacle?" CR>)>>

<OBJECT SONARPHONE
	(IN SUB)
	(DESC "sonarphone")
	(ADJECTIVE SONAR)
	(SYNONYM SONARPHONE PHONE)
	(FLAGS NDESCBIT)
	(ACTION SONARPHONE-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL BLY-CALLING <>>
<GLOBAL BLY-WELCOMED <>>

<ROUTINE BLY-WELCOME ()
	<TELL
"Welcome to the " D ,AQUADOME ", " FN "! You're a sight for sore eyes!
We've been anxiously awaiting your arrival!">
	;<COND (<IN? ,OVERHEATING ,GLOBAL-OBJECTS>
	       <CRLF>
	       <TIP-SAYS T>
	       <TELL
"By the way, " D ,BLY ", we had an " D ,OVERHEATING " problem on
the way here.\"">)>>

<ROUTINE SONARPHONE-F ()
 <COND (<VERB? LAMP-OFF>
	<COND (<NOT <FSET? ,PRSO ,ONBIT>> <TELL "It's not on!" CR> <RTRUE>)>
	<FCLEAR ,PRSO ,ONBIT>
	<COND (,REMOTE-PERSON <PERFORM ,V?GOODBYE> <RTRUE>)
	      (T <OKAY ,SONARPHONE "off">)>)
       (<AND <VERB? LISTEN> ,BLY-CALLING> <TELL "It's ringing." CR>)
       (<VERB? LAMP-ON REPLY SAY-INTO TAKE>
	<COND (<NOT ,BLY-CALLING>
	       <TELL "The sonarphone isn't ringing!" CR>)
	      (T
	       <SETG BLY-CALLING <>>
	       <PHONE-ON ,GLOBAL-BLY ,AQUADOME ,SONARPHONE>
	       <FSET ,SONARPHONE ,ONBIT>
	       ;<FCLEAR ,GLOBAL-SNARK ,INVISIBLE>
	       <MOVE ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
	       <INC BLY-PRIVATELY-COUNT>
	       <SETG BLY-WELCOMED T>
	       <TELL "\"This is Zoe Bly speaking. ">
	       <BLY-WELCOME>
	       <DISCUSS-PRIVATE>)>)>>

<ROUTINE DISCUSS-PRIVATE ()
	<THIS-IS-IT ,PRIVATE-MATTER>
	<TELL
" I'd like to discuss a " D ,PRIVATE-MATTER " with you, as soon as
possible!\"" CR>>

<OBJECT HYDROPHONE
	(IN SUB)
	(DESC "hydrophone")
	(ADJECTIVE	HYDROPHONE LISTEN)
	(SYNONYM	HYDROPHONE DEVICE ;GAUGE)
	(FLAGS NDESCBIT ONBIT ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION HYDROPHONE-F)>

<ROUTINE HYDROPHONE-F ()
 <COND (<AND <VERB? LISTEN> <FSET? ,HYDROPHONE ,ONBIT>>
	<TELL "You can hear ">
	<COND (<==? ,NOW-TERRAIN ,BAY-TERRAIN>
	       <TELL "various engine noises." CR>)
	      (<NOT <FSET? ,WHALE ,INVISIBLE>>
	       <TELL "the whale." CR>)
	      (T <TELL "nothing interesting." CR>)>)>>

<OBJECT REACTOR
	(IN SUB)
	(DESC "reactor")
	(ADJECTIVE POWER SUB SUBMARINE ENGINE)
	(SYNONYM REACTOR GENERATOR HOLE)
	(FLAGS CONTBIT SEARCHBIT OPENBIT ;NDESCBIT)
	(CAPACITY 11 ;44)
	(VALUE 5)
	(DESCFCN REACTOR-F)
	(ACTION REACTOR-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<ROUTINE REACTOR-F ("OPTIONAL" (ARG <>))
 <COND (<OR .ARG <VERB? EXAMINE ANALYZE>>
	<COND (<AND <==? ,P-ADVERB ,W?CAREFULLY> <NOT .ARG>>
	       <TELL <GETP ,LOCAL-SUB ,P?TEXT> CR>)
	      (<AND .ARG
		    <FSET? ,REACTOR ,ONBIT>
		    <NOT <FSET? ,REACTOR ,OPENBIT>>>
	       <RTRUE>)
	      (T <TELL "The power reactor is o"
		       <COND (<FSET? ,REACTOR ,ONBIT> "n") (T "ff")>
		       " and "
		       <COND (<FSET? ,REACTOR ,OPENBIT> "open") (T "closed")>
		       "." CR>)>)
       (<VERB? LAMP-ON>
	<COND (<FSET? ,REACTOR ,ONBIT>
	       <ALREADY ,REACTOR "on">)
	      (<NOT <IN? ,CATALYST-CAPSULE ,REACTOR>>
	       <FCLEAR ,CATALYST-CAPSULE ,NDESCBIT>
	       <TELL-HINT 33 ;8 ,CATALYST-CAPSULE <>>)
	      (<FSET? ,REACTOR ,OPENBIT>
	       <YOU-CANT "start" <> "open">
	       ;<TELL "You can't turn it on while it's open." CR>)
	      (T
	       <FSET ,REACTOR ,ONBIT>
	       <TELL "Electrical systems now activated." CR>
	       <SCORE-OBJ ,REACTOR>
	       <RTRUE>)>)
       (<VERB? LAMP-OFF>
	<COND (<NOT <FSET? ,REACTOR ,ONBIT>>
	       <ALREADY ,REACTOR "off">)
	      (<FSET? ,ENGINE ,ONBIT>	;"[YOU-CANT?]"
	       <TELL "You can't turn it off while the engine is on." CR>)
	      (T
	       <FCLEAR ,REACTOR ,ONBIT>
	       <TELL "Electrical systems now de-activated." CR>)>)
       (<AND <VERB? OPEN> <FSET? ,REACTOR ,ONBIT>>
	<YOU-CANT "open" <> "turned on">
	;<TELL "You can't open it while it's turned on." CR>)>>

<OBJECT REACTOR-SWITCH
	(IN LOCAL-GLOBALS ;SUB)
	(DESC "reactor starter")
	(ADJECTIVE REACTOR)
	(SYNONYM STARTER BUTTON)
	(FLAGS NDESCBIT)
	(ACTION REACTOR-SWITCH-F)>

<ROUTINE REACTOR-SWITCH-F ()
 <COND (<VERB? LAMP-ON LAMP-OFF EXAMINE>
	<PERFORM ,PRSA ,REACTOR>
	<RTRUE>)
       (<VERB? MOVE PUSH TURN>
	<TELL ,I-ASSUME " turn on the " D ,REACTOR ".)" CR>
	<PERFORM ,V?LAMP-ON ,REACTOR>
	<RTRUE>)>>

<OBJECT ENGINE
	(IN SUB)
	(DESC "hydrojet")
	(ADJECTIVE PROPULSION HYDROJET)
	(SYNONYM HYDROJET ENGINE SYSTEM TURBINE)
	(FLAGS NDESCBIT ON?BIT)
	(VALUE 5)
	;(GENERIC GENERIC-ENGINE-F)
	(ACTION ENGINE-F)>

;"<OBJECT ENGINE-CS
	(IN CRAWL-SPACE)
	(DESC 'hydrojet')
	(ADJECTIVE PROPULSION HYDROJET)
	(SYNONYM HYDROJET ENGINE SYSTEM TURBINE)
	(FLAGS NDESCBIT ON?BIT)
	(GENERIC GENERIC-ENGINE-F)
	(ACTION ENGINE-F)>

;<ROUTINE GENERIC-ENGINE-F (OBJ) ,ENGINE>"

<ROUTINE ENGINE-F ()
 <COND (<VERB? LAMP-OFF STOP>
	<COND (<NOT <0? ,THROTTLE-SETTING>>
	       <YOU-CANT "stop" ,THROTTLE "open">
	       ;<TELL
"You can't turn off the engine while the throttle's open." CR>)
	      ;(T
	       <OKAY ,ENGINE "off">)>)
       (<VERB? LAMP-ON>
	<COND (<OR <AND ,SUB-IN-TANK <NOT ,TEST-TANK-FULL>>
		   <AND ,SUB-IN-DOME <NOT ,AIRLOCK-FULL>>>
	       <TELL
"The " D ,SUB " can't go when it's out of the water.
You should fill the ">
	       <COND (,SUB-IN-TANK
		      <THIS-IS-IT ,TEST-TANK>
		      <TELL D ,TEST-TANK>)
		     (T
		      <THIS-IS-IT ,AIRLOCK>
		      <TELL D ,AIRLOCK>)>
	       <TELL " first." CR>)
	      (<NOT <FSET? ,REACTOR ,ONBIT>>
	       <YOU-CANT "start" ,REACTOR "off">
	       ;<TELL
"You can't turn it on while the reactor's off."
;"You should start the reactor to generate the electrical power for your
propulsion system." CR>)
	      (<FSET? ,ENGINE ,ONBIT>
	       <ALREADY ,ENGINE "on">)
	      (T
	       <SETG GATE-CRASHED <>>
	       <FSET ,ENGINE ,ONBIT>
	       <FSET ,ENGINE ,TOUCHBIT>
	       <COND (<READY-FOR-SNARK?>
		      <TELL
"Your revolutionary craft thrums with power, matching your own excited
heartbeat!" CR>)
		     (T <TELL
"You can immediately hear the powerful thrum of the hydrojet
turbine." CR>)>
	       <SCORE-OBJ ,ENGINE>
	       <RTRUE>)>)>>

<OBJECT ENGINE-BUTTON
	(IN LOCAL-GLOBALS ;SUB)
	(DESC "engine starter")
	(ADJECTIVE ENGINE STARTER)
	(SYNONYM STARTER BUTTON)
	(FLAGS NDESCBIT VOWELBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION ENGINE-BUTTON-F)>

<ROUTINE ENGINE-BUTTON-F ()
 <COND (<VERB? LAMP-ON LAMP-OFF EXAMINE>
	<PERFORM ,PRSA ,ENGINE>
	<RTRUE>)
       (<VERB? MOVE PUSH TURN>
	<TELL ,I-ASSUME " turn on the " D ,ENGINE ".)" CR>
	<PERFORM ,V?LAMP-ON ,ENGINE>
	<RTRUE>)>>

<GLOBAL JOYSTICK-DIR 25>
<OBJECT JOYSTICK
	(IN SUB)
	(DESC "joystick")
	(ADJECTIVE JOY)
	(SYNONYM STICK JOYSTICK)
	(FLAGS NDESCBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION JOYSTICK-F)>

<ROUTINE JOYSTICK-F ()
 <COND (<VERB? ANALYZE EXAMINE READ>
	<TELL
"The " D ,JOYSTICK " is like the kind used with personal computers, only
bigger. It's now ">
	<COND (<0? ,JOYSTICK-DIR> <TELL "sitting at dead center." CR>)
	      (T
	       <TELL "pointing to ">
	       <DIR-PRINT ,JOYSTICK-DIR>
	       <TELL "." CR>)>)
       (<VERB? MOVE PUSH TURN>
	<V-WALK-AROUND>
	<RTRUE>)
       (<VERB? MOVE-DIR>
	<COND (<EQUAL? ,P-DIRECTION ,P?IN>
	       <V-WALK-AROUND>
	       <RTRUE>)>
	<COND (<EQUAL? ,P-DIRECTION ,P?OUT>
	       <COND (,SUB-IN-TANK <SETG P-DIRECTION ,P?EAST>)
		     (,SUB-IN-DOME <SETG P-DIRECTION ,P?SOUTH>)
		     (T
		      <V-WALK-AROUND>
		      <RTRUE>)>)>
	<DO-WALK ,P-DIRECTION>
	<RTRUE>)>>

<CONSTANT THROTTLE-MAX 3>
<GLOBAL THROTTLE-SETTING 0>
<GLOBAL THROTTLE-DESCS <PTABLE "closed" ;"off" "slow" "medium" "fast">>

<OBJECT THROTTLE
	(IN SUB)
	(DESC "throttle")
	(SYNONYM THROTTLE SPEED)
	(FLAGS NDESCBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION THROTTLE-F)>

<OBJECT FAST
	(IN SUB)
	(DESC "fast")
	;(ADJECTIVE FAST FULL HIGH THIRD TOP)
	(SYNONYM FAST FASTER HIGH MAXIMUM ;FULL ;SPEED)
	(FLAGS NDESCBIT)>

<OBJECT MEDIUM
	(IN SUB)
	(DESC "medium")
	;(ADJECTIVE MEDIUM HALF CRUISING CRUISE SECOND)
	(SYNONYM MEDIUM HALF CRUISE ;SPEED)
	(FLAGS NDESCBIT)>

<OBJECT SLOW
	(IN SUB)
	(DESC "slow")
	;(ADJECTIVE SLOW FIRST)
	(SYNONYM SLOW SLOWER MINIMUM LOW ;SPEED)
	(FLAGS NDESCBIT)>

<OBJECT OFF
	(IN SUB)
	(DESC "off")
	(ADJECTIVE STANDING)
	(SYNONYM OFF STILL STOP)
	(FLAGS NDESCBIT VOWELBIT)>

<ROUTINE THROTTLE-F ("AUX" TH)
 <COND (<VERB? OPEN PUSH LAMP-ON>
	<SETG P-NUMBER <+ 1 ,THROTTLE-SETTING>>
	<COND (<G? ,P-NUMBER ,THROTTLE-MAX>
	       <TELL "You're going as fast as you can!" CR>)
	      (T
	       <PERFORM ,V?SET ,THROTTLE ;,INTNUM>
	       <RTRUE>)>)
       (<VERB? CLOSE LAMP-OFF>
	<COND (<0? ,THROTTLE-SETTING>
	       <ALREADY ,THROTTLE "closed">
	       <RTRUE>)>
	<SETG THROTTLE-SETTING 0>
	;<COND (,DEBUG <TELL "[Throttle=" N ,THROTTLE-SETTING "]" CR>)>
	<COND (<OR ,SUB-IN-TANK ,SUB-IN-DOME>
	       <TELL
"The throttle is now closed. You must open it to make the " D ,SUB " go
anywhere." CR>)
	      (T
	       <TELL "The " D ,SUB " slows to a halt." CR>
	       <COOL-BACK>)>
	<RTRUE>)
       (<VERB? MOVE TURN>
	<TELL
"Set it to the speed you want: fast, medium, slow, or off." CR>)
       (<VERB? ANALYZE EXAMINE READ>
	<TELL "The throttle is set to "
		<GET ,THROTTLE-DESCS ,THROTTLE-SETTING>
		"." CR>)
       (<AND <VERB? SET PUT MOVE-DIR> <DOBJ? THROTTLE>>
	<COND (<IOBJ? OFF SLOW MEDIUM FAST>
	       <COND (<IOBJ? OFF>	<SET TH 0>)
		     (<IOBJ? SLOW>	<SET TH 1>)
		     (<IOBJ? MEDIUM>	<SET TH 2>)
		     (<IOBJ? FAST>	<SET TH 3>)>)
	      (<AND <EQUAL? ,PRSI <> ,GRID-UNIT>
		    <G? ,P-NUMBER -1>
		    <NOT <G? ,P-NUMBER ,THROTTLE-MAX>>>
	       <SET TH ,P-NUMBER>)
	      (T
	       <TELL "Set it off, slow, medium, or fast." CR>
	       <RTRUE>)>
	<COND (<0? .TH>
	       <TELL ,I-ASSUME " close the " D ,THROTTLE ".)" CR>
	       <PERFORM ,V?CLOSE ,THROTTLE>
	       <RTRUE>)>
	;<COND (,DEBUG <TELL "[Throttle=" N .TH "]" CR>)>
	<COND (<NOT <FSET? ,ENGINE ,ONBIT>>
	       <TELL "Nothing happens when you open the throttle. ">
	       <COND (,GATE-CRASHED
		      <TELL
"The turbine was stopped by Automatic Shutoff when you crashed into the
sea gate.">)
		     (T <TELL "The engine is off.">)>
	       <THIS-IS-IT ,ENGINE>
	       <CRLF>)
	      (,SUB-IN-TANK
	       <COND (<HATCH-GATE-NOT-READY? ,TANK-GATE>
		      <RTRUE>)>
	       <COND (<EQUAL? ,JOYSTICK-DIR ,P?EAST>
		      <COND (<NOT <FSET? ,TANK-GATE ,OPENBIT>>
			     <GATE-CRASH "open" ,THROTTLE ,TANK-GATE>)
			    (T
			     <SETG THROTTLE-SETTING .TH>
			     <SUB-LEAVES T ,P?EAST>)>)
		     (T
		      <SETG THROTTLE-SETTING .TH>
		      <OKAY-THROTTLE ,P?EAST>)>)
	      (,SUB-IN-DOME
	       <COND (<HATCH-GATE-NOT-READY? ,AIRLOCK-HATCH>
		      <RTRUE>)>
	       <SETG THROTTLE-SETTING .TH>
	       <COND (<EQUAL? ,JOYSTICK-DIR ,P?SOUTH>
		      <SUB-LEAVES <> ,P?SOUTH>)
		     (T <OKAY-THROTTLE ,P?SOUTH>)>)
	      (T
	       <COND (<==? ,THROTTLE-SETTING .TH>
		      <TELL "Okay, you're still ">)
		     (T
		      <COND (<L? ,THROTTLE-SETTING .TH>
			     <TELL "You feel the seat press ">
			     <COND (<NOT <0? ,THROTTLE-SETTING>>
				    <TELL "harder ">)>
			     <TELL
"against you, and the " D ,ENGINE " gets loud">)
			    (T <TELL "The " D ,ENGINE " gets quiet">)>
		      <TELL "er. You're now ">)>
	       <TELL "travelling at a speed of " N .TH " " D ,GRID-UNIT>
	       <COND (<NOT <==? 1 .TH>> <TELL "s">)>
	       <SETG THROTTLE-SETTING .TH>
	       <TELL " per turn." CR>)>
	<RTRUE>)>>

<ROUTINE OKAY-THROTTLE (DIR)
	<TELL
"Okay, now that the throttle is set, try pushing the " D ,JOYSTICK " to ">
	<DIR-PRINT .DIR>
	<TELL "." CR>>

<GLOBAL SONAR-LON 0>
<GLOBAL SONAR-LAT 0>
<GLOBAL SONAR-DEP 0>
<GLOBAL SONAR-DIR 0>

<ROUTINE I-SHOW-SONAR ()
 <COND (<AND <FSET? ,SNARK ,INVISIBLE>
	     <FSET? ,FREIGHTER ,INVISIBLE>
	     <==? ,SONAR-LON ,SUB-LON>
	     <==? ,SONAR-LAT ,SUB-LAT>
	     <==? ,SONAR-DEP ,SUB-DEPTH>
	     <==? ,SONAR-DIR ,JOYSTICK-DIR>>
	<COND (,DEBUG <TELL "[no sonar update]" CR>)>
	<RFALSE>)
       (T
	<SCREEN 1>
	<SHOW-SONARSCOPE>
	<SCREEN 0>
	<SETG SONAR-LON ,SUB-LON>
	<SETG SONAR-LAT ,SUB-LAT>
	<SETG SONAR-DEP ,SUB-DEPTH>
	<SETG SONAR-DIR ,JOYSTICK-DIR>
	<RFALSE>)>>

<GLOBAL SUB-DEPTH 0>
<GLOBAL TARGET-DEPTH 0>
<GLOBAL EVER-SUBMERGED? <>>

<OBJECT DEPTH
	(IN SUB)
	(DESC "present depth")
	(ADJECTIVE PRESENT CURRENT SUB\'S SUBMARINE)
	(SYNONYM DEPTH)
	(ACTION DEPTH-F)
	(FLAGS NDESCBIT)>

<ROUTINE DEPTH-F ()
	<DO-INSTEAD-OF ,DEPTH-CONTROL ,DEPTH>
	<RTRUE>>

<OBJECT DEPTH-CONTROL
	(IN SUB)
	(DESC "depth control" ;" lever")
	(ADJECTIVE DEPTH ;CONTROL)
	(SYNONYM CONTROL LEVER HANDLE)
	(FLAGS NDESCBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION DEPTH-CONTROL-F)>

<GLOBAL DIVING? 0>
<ROUTINE DEPTH-CONTROL-F ("AUX" DEP NEW-DIVING?)
 <COND (<REMOTE-VERB?> <RFALSE>)
       (,SUB-IN-TANK
	<YOU-CANT "submerge" ,SUB "here">
	;<TELL "You can't submerge until you leave the " D ,TEST-TANK "." CR>
	<RTRUE>)
       (<AND ,SUB-IN-DOME <WHY-NEED ,DEPTH-CONTROL ,AIRLOCK>>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE READ WHAT>
	<TELL
"It's set for a desired depth of " N <* 5 ,TARGET-DEPTH> " meters." CR>)
       (<VERB? SET>
	<SET DEP ,P-NUMBER>
	;<COND (,DEBUG <TELL "[Number=" N .DEP "]" CR>)>
	<COND (<FSET? ,AUTO-PILOT ,ONBIT>
	       <TELL "Let the " D ,AUTO-PILOT " handle that." CR>
	       <RTRUE>)
	      (<NOT <FSET? ,DEPTHFINDER ,ONBIT>>
	       <THIS-IS-IT ,DEPTHFINDER>
	       <TELL "You'd better turn on the " D ,DEPTHFINDER" first."CR>
	       <RTRUE>)
	      (<NOT <G? .DEP -1>>
	       <TELL "You must set it to at least zero!" CR>
	       <RTRUE>)
	      (<AND ,SUB-IN-BATTLE	;<NOT <FSET? ,THORPE-SUB ,INVISIBLE>>
		    <G? ,SUB-DEPTH .DEP>>
	       <TELL
"If you go above the Snark, Thorpe will shoot you!" CR>
	       <RTRUE>)
	      (<AND <G? .DEP 0> <FSET? ,SUB-DOOR ,OPENBIT>>
	       ;<THIS-IS-IT ,SUB-DOOR>
	       <YOU-CANT "submerge" ,SUB-DOOR "open">
	       ;<TELL "You can't dive with the entry hatch open!" CR>
	       <RTRUE>)
	      (<IOBJ? METER>
	       <SET DEP </ <+ 2 .DEP> 5>>
	       <COND (<NOT <==? ,P-NUMBER <* 5 .DEP>>>
		      <TELL
"(That rounds off to " N <* 5 .DEP> " meters.)" CR>)>)>
	<SETG TARGET-DEPTH .DEP>
	<COND (<NOT <0? .DEP>> <SETG EVER-SUBMERGED? T>)>
	<COND (<==? ,SUB-DEPTH .DEP>
	       <COND (<0? ,DIVING?>
		      <ALREADY ,PLAYER "at that depth">)
		     (T
		      <TELL "Your "
			    <COND (<==? +1 ,DIVING?> "de") (T "a")>
			    "scent ceases.">)>
	       <CRLF>
	       ;<COND (,DEPTH-WARNING
		      <TELL ,DEPTH-WARNING CR>)>
	       <SETG DIVING? 0>
	       <RTRUE>)
	      (T
	       <COND (<L? ,SUB-DEPTH ,TARGET-DEPTH>
		      <SET NEW-DIVING? +1>)
		     (T
		      <SET NEW-DIVING? -1>)>
	       <COND (<NOT <==? ,DIVING? .NEW-DIVING?>>
		      <TELL "The " D ,SUB " noses ">
		      <COND (<==? .NEW-DIVING? +1>
			     <TELL "down">)
			    (T <TELL "up">)>
		      <TELL "ward">
		      <COND (<0? ,SUB-DEPTH>
			     <TELL
", and " D ,GLOBAL-WATER " begins to wash over your forward " D ,SUB-WINDOW>)>
		      <TELL ". You're now ">)
		     (T <TELL "Okay, you're still ">)>
	       <SETG DIVING? .NEW-DIVING?>
	       <COND (<==? 1 ,DIVING?> <TELL "div">)
		     (T <TELL "ris">)>
	       <TELL "ing at a speed of 5 meters per ">
	       <COND (<0? ,THROTTLE-SETTING> <TELL "turn." CR>)
		     (T <TELL D ,GRID-UNIT "." CR>)>)>)>>

<OBJECT GRID-UNIT
	(IN SUB ;GLOBAL-OBJECTS)
	(ADJECTIVE SEA GRID NUMBER)
	(SYNONYM SQUARE)
	(DESC "sea square")
	(FLAGS UNITBIT NDESCBIT ;NARTICLEBIT)>

<OBJECT METER
	(IN SUB ;GLOBAL-OBJECTS)
	(ADJECTIVE NUMBER)
	(SYNONYM METER METERS METRES M)
	(DESC "meter")
	(FLAGS UNITBIT NDESCBIT ;NARTICLEBIT)
	(ACTION METER-F)>

<ROUTINE METER-F ()
 <COND (<VERB? BOARD>	;"CLIMB"
	<PERFORM ,V?CLIMB-UP ,PRSO>
	<RTRUE>)>>

<OBJECT AUTO-PILOT
	(IN SUB)
	(DESC "autopilot")
	(ADJECTIVE	AUTO AUTOMATIC)
	(SYNONYM	PILOT AUTOPILOT)
	(FLAGS NDESCBIT VOWELBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(VALUE 5 ;1)
	(ACTION AUTO-PILOT-F)>

<ROUTINE AUTO-PILOT-F ()
 <COND (<VERB? LAMP-OFF>
	<COND (<NOT <FSET? ,AUTO-PILOT ,ONBIT>>
	       <ALREADY ,AUTO-PILOT "off">)
	      (T
	       <TELL
"If you do, you'll never reach the " D ,AQUADOME "!" CR>)>)
       (<OR <VERB? LAMP-ON PUSH>
	    <AND <VERB? SET> <IOBJ? AQUADOME>>>
	<COND (<FSET? ,AUTO-PILOT ,ONBIT>
	       <ALREADY ,AUTO-PILOT "on">)
	      (<NOT ,SUB-IN-OPEN-SEA>
	       <TELL "You must be your own pilot for now." CR>)
	      (<FSET? ,SUB-DOOR ,OPENBIT>
	       <YOU-CANT "submerge" ,SUB-DOOR "open">
	       ;<THIS-IS-IT ,SUB-DOOR>
	       ;<TELL "You can't dive with the entry hatch open!" CR>
	       <RTRUE>)
	      (T
	       <FSET ,AUTO-PILOT ,ONBIT>
	       <SETG JOYSTICK-DIR ,P?EAST>
	       <SETG TIP-SAYS-1 23 ;5>
	       <SETG TIP-SAYS-2 ,MAGAZINE>
	       <ENABLE <QUEUE I-TIP-SAYS 6>>
	       <TELL "Okay, your trip to the " D ,AQUADOME " will take ">
	       <COND (<0? ,THROTTLE-SETTING> <TELL "forever">)
		     (T <TELL N </ ,AQUADOME-DISTANCE ,THROTTLE-SETTING>
			      " turns">)>
	       <TELL
" at your current speed. But you can set the throttle to a different
speed, if you want." CR>
	       <SCORE-OBJ ,AUTO-PILOT>
	       <RTRUE>)>)>>

<ROUTINE I-AUTO-PILOT ()
 <COND (<NOT <FSET? ,AUTO-PILOT ,ONBIT>>
	<QUEUE I-AUTO-PILOT 2>
	<COND (<AND <VERB? LAMP-ON> <DOBJ? AUTO-PILOT>> <RFALSE>)>
	<TIME-FOR-PILOT>)>>

<ROUTINE TIME-FOR-PILOT ()
	<TIP-SAYS>
	<TELL
"I think it's time to turn on the " D ,AUTO-PILOT ".\"" CR>>

<CONSTANT AQUADOME-VISIBLE 55>
<CONSTANT AQUADOME-DISTANCE 60>
<GLOBAL DISTANCE-FROM-BAY 0>

<OBJECT CONTROL-CIRCUITS
	(IN SUB)
	(DESC "control circuit")
	(ADJECTIVE CONTROL)
	(SYNONYM CIRCUIT)
	(FLAGS NDESCBIT)
	(ACTION CONTROL-CIRCUITS-F)>

<ROUTINE CONTROL-CIRCUITS-F ()
 <COND (<VERB? ANALYZE EXAMINE READ>
	<COND (,SUB-IN-OPEN-SEA
	       <TELL
"Sorry. There's no way to do this while the " D ,SUB " is submerged and
underway. You need ship-repair or test-tank facilities." CR>)>)>>

<OBJECT CONTROL-CIRCUITS-GAUGE
	(IN SUB)
	(DESC ;"control circuits " "temperature gauge" ;" needle")
	(ADJECTIVE CONTROL CIRCUIT TEMPERATURE GAUGE)
	(SYNONYM ;CIRCUIT TEMPERATURE GAUGE ;GAUGES NEEDLE)
	(FLAGS NDESCBIT)
	(ACTION CONTROL-CIRCUITS-GAUGE-F)>

<ROUTINE CONTROL-CIRCUITS-GAUGE-F ()
 <COND (<VERB? ANALYZE EXAMINE READ>
	<COND (T ;,SUB-IN-OPEN-SEA
	       <TELL "The " D ,CONTROL-CIRCUITS-GAUGE " needle is ">
	       <COND (<L? 20 ,CIRCUIT-TEMP>
		      <COND (<L? 25 ,CIRCUIT-TEMP>
			     <TELL "pointing to">)
			    (T <TELL "near">)>
		      <TELL " the red danger zone.">)
		     (T <TELL "in the green safety zone.">)>
	       <COND (<NOT <FSET? ,ENGINE ,TOUCHBIT>> T)
		     (<NOT <FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>> T)
		     (<L? 1 ,THROTTLE-SETTING> <TELL " And rising.">)
		     (<0? ,THROTTLE-SETTING> <TELL " And falling.">)
		     (T <TELL " And steady.">)>
	       <CRLF>)>)>>

<GLOBAL CIRCUIT-TEMP 0>
<GLOBAL CIRCUIT-TIP <>>
<GLOBAL CIRCUIT-RED <>>

<OBJECT SEARCH-BEAM
	(IN SUB)
	(DESC "brass search light")
	(ADJECTIVE BRASS SEARCH LIGHT)
	(SYNONYM BEAM LIGHT ;SEARCH)
	(FLAGS NDESCBIT ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(GENERIC GENERIC-LIGHT-F)
	(ACTION SEARCH-BEAM-F)>

<ROUTINE SEARCH-BEAM-F ()
 <COND (<VERB? TURN>
	<TELL "You didn't tell what direction to aim it." CR>)
       (<VERB? AIM>
	<COND (<NOT <FSET? ,SEARCH-BEAM ,ONBIT>>
	       <TELL "It's not on!" CR>)
	      (,SUB-IN-BATTLE
	       <TOO-CLOUDY>)
	      (<AND <IOBJ? RIGHT> <IN? ,WHALE ,SUB>>
	       <COND (<FSET? ,WHALE ,INVISIBLE>
		      <FCLEAR ,WHALE ,INVISIBLE>
		      <TELL
"An enormous whale can be seen, lolling comfortably in the deep.">
		      <COND (,WHALE-HEARD
			     <TELL
" Obviously this is what has been making those noises over the hydrophone.">)>
		      <TELL CR
"The whale swims closer as you pass, curious about this strange fish -- the "
D ,SUB ". But, thankfully, it shows no danger of accidental collision." CR>)
		     (T <TELL "The whale is still following you." CR>)>)
	      (T <TELL
"Nothing new appears in the " D ,SEARCH-BEAM " beam." CR>)>)>>

<ROUTINE GENERIC-LIGHT-F (OBJ)
 <COND (,DEPTH-WARNING ,DEPTHFINDER-LIGHT)
       (<OR ,SONAR-WARNING ,SHIP-WARNING> ,SONARSCOPE-LIGHT)
       (<VERB? LAMP-ON LAMP-OFF TURN AIM SAIM> ,SEARCH-BEAM)>>

<OBJECT WHALE
	(DESC "whale")
	(SYNONYM WHALE)
	(FLAGS INVISIBLE NDESCBIT)
	(ACTION WHALE-F)>

<ROUTINE WHALE-F ()
 <COND (<VERB? FIND THROUGH WALK-TO>
	<TELL "You shouldn't get any closer!" CR>)>>

<GLOBAL WHALE-HEARD <>>

<GLOBAL SEA-TERRAIN 1>

<OBJECT OVERHEATING
	(DESC "overheating")
	;(IN GLOBAL-OBJECTS)
	(SYNONYM OVERHEATING)>

<OBJECT BAY
	(IN SUB)
	(DESC "Frobton Bay")
	(ADJECTIVE FROBTON)
	(SYNONYM BAY SURFACE)
	(FLAGS NDESCBIT NARTICLEBIT)
	(VALUE 5)
	(ACTION BAY-F)>

<ROUTINE BAY-F ()
 <COND (<VERB? FIND THROUGH WALK-TO>
	<COND (,SUB-IN-TANK
	       <TELL "First you must launch the " D ,SUB "." CR>)
	      (<==? ,NOW-TERRAIN ,BAY-TERRAIN>
	       <TELL "You're in it!" CR>)
	      (T <TELL "This is no time to go back!" CR>)>)
       (<VERB? EXAMINE>
	<COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
	       <PERFORM ,V?LOOK-OUTSIDE ,SUB-WINDOW>
	       <RTRUE>)
	      (T
	       <NOT-HERE ,BAY>
	       ;<SETG P-WON <>>
	       ;<TELL "(You can't see any bay here!)" CR>)>)>>

<OBJECT CLAW
	(IN GLOBAL-OBJECTS)
	(DESC "extensor claw")
	(ADJECTIVE EXTENSOR EXTENDER SCIMITAR)
	(SYNONYM CLAW CLAWS ARM ARMS)
	(FLAGS VOWELBIT ;SURFACEBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION CLAW-F)>

<ROUTINE CLAW-F ()
 <COND (<VERB? ANALYZE EXAMINE> <LOCAL-SUB-F>)
       (<VERB? FIND>
	<TELL "It's part of the " D ,SUB "." CR>)
       (<VERB? AIM MOVE MOVE-DIR>
	<COND (<==? ,BAZOOKA <GET ,ON-SUB 0>>
	       <COND (<==? ,DART <GET ,ON-SUB 1>>
		      <TELL
"You should do that to one weapon or the other." CR>)
		     (T
		      <PERFORM ,PRSA ,BAZOOKA ,PRSI>
		      <RTRUE>)>)
	      (<==? ,DART <GET ,ON-SUB 1>>
	       <PERFORM ,PRSA ,DART ,PRSI>
	       <RTRUE>)
	      (T <TELL
"The claw moves just where you want it. Well done!" CR>)>)>>

<ROUTINE WHY-NEED (OBJ WHERE)
 <COND (<AND <VERB? SET> <IOBJ? MANUAL>> <RFALSE>)
       (<VERB? LAMP-OFF MUNG> <RFALSE>)
       (T
	<TELL "Why would you need the " D .OBJ
	      "? The " D ,SUB " is in the " D .WHERE "." CR>)>>

<OBJECT PILOT-SEAT
	(IN SUB)
	(DESC "seat")
	(SYNONYM SEAT CHAIR)
	(FLAGS NDESCBIT)
	(ACTION PILOT-SEAT-F)>

<ROUTINE PILOT-SEAT-F ("AUX" (VAL <>))
 <COND (<VERB? ANALYZE EXAMINE SIT>
	<TELL "You're sitting in it." CR>)
       (<VERB? LOOK-UNDER>
	<COND (<NOT <FSET? ,OXYGEN-GEAR ,TOUCHBIT>>
	       <SET VAL T>
	       <TELL "You can see " D ,OXYGEN-GEAR "." CR>)>
	<COND (<IN? ,ESCAPE-POD-UNIT ,HERE>
	       <SET VAL T>
	       <TELL "You can see the " D ,ESCAPE-POD-UNIT "." CR>)>
	.VAL)>>

<OBJECT INSTRUMENTS
	(IN SUB ;LOCAL-GLOBALS)
	(DESC "instrument cluster")
	(ADJECTIVE INSTRUMENT)
	(SYNONYM INSTRUMENT CLUSTER GAUGES)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION INSTRUMENTS-F)>

<ROUTINE INSTRUMENTS-F ()
 <COND ;(<EQUAL? ,HERE ,CENTER-OF-LAB> <VIDEOPHONE-F>)
       (<AND ;<EQUAL? ,HERE ,SUB> <VERB? ANALYZE EXAMINE READ>>
	<TELL
"Main instruments:|
" D ,DEPTHFINDER ", " D ,HYDROPHONE ", " D ,SONARSCOPE ;",  D ,VIDEO-SCREEN"
", and " D ,CONTROL-CIRCUITS-GAUGE "." CR>)>>

<OBJECT CONTROLS-SUB
	(IN SUB ;LOCAL-GLOBALS)
	(DESC "control panel")
	(ADJECTIVE OPERATOR CONTROL)
	(SYNONYM CONTROL PANEL KNOB KNOBS)
	(FLAGS NDESCBIT)
	(ACTION CONTROLS-SUB-F)>

<ROUTINE CONTROLS-SUB-F ()
 <COND (<AND ;<EQUAL? ,HERE ,SUB> <VERB? ANALYZE EXAMINE READ>>
	<TELL
"MAIN OPERATING CONTROLS:|
">
	<FIXED-FONT-ON>
	<TELL D ,REACTOR ;CAPSULE-LEVER "        : "
	<COND (<FSET? ,REACTOR ,OPENBIT> "open") (T "closed")> CR
	D ,REACTOR-SWITCH ": "
	<COND (<FSET? ,REACTOR ,ONBIT> "on") (T "off")> CR
	D ,FILL-TANK-BUTTON "   : " <TANK-STATUS> CR
	D ,OPEN-GATE-BUTTON "   : " <GATE-STATUS> CR
	D ,ENGINE-BUTTON " : "
	<COND (<FSET? ,ENGINE ,ONBIT> "on") (T "off")> CR
	D ,THROTTLE "       : "
	<GET ,THROTTLE-DESCS ,THROTTLE-SETTING> CR
	D ,JOYSTICK "       : ">
	<DIR-PRINT ,JOYSTICK-DIR <>>
	<TELL CR
	D ,DEPTH-CONTROL "  : "
	N <* 5 ,TARGET-DEPTH> " meters|
" D ,AUTO-PILOT "      : "
	<COND (<FSET? ,AUTO-PILOT ,ONBIT> "on") (T "off")> CR>
	<FIXED-FONT-OFF>
	<RTRUE>)>>

<ROUTINE FIXED-FONT-ON () <PUT 0 8 <BOR <GET 0 8> 2>>>

<ROUTINE FIXED-FONT-OFF() <PUT 0 8 <BAND <GET 0 8> -3>>>

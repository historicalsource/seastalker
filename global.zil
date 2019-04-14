"GLOBALS for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<OBJECT GLOBAL-OBJECTS
	(PSEUDO "NOTHIN" RANDOM-PSEUDO)
	(VALUE 0)
	(GENERIC NULL-F)
	(FLAGS	BUSYBIT CONTBIT DOORBIT ;DRINKBIT FEMALE ;FOODBIT ;FURNITURE
		INVISIBLE LIGHTBIT LOCKED MUNGBIT
		NARTICLEBIT NDESCBIT ONBIT ON?BIT OPENBIT
		PERSON READBIT RLANDBIT RMUNGBIT SEARCHBIT SURFACEBIT TAKEBIT
		TOOLBIT TOUCHBIT TRANSBIT TRYTAKEBIT VEHBIT VOWELBIT
		WEAPONBIT WINDOWBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZZZLG ZZZLG)	;"This synonym is necessary - God knows">

<ROUTINE DO-INSTEAD-OF (OBJ1 OBJ2)
	<COND (<EQUAL? ,PRSI .OBJ2> <PERFORM ,PRSA ,PRSO .OBJ1>)
	      (<EQUAL? ,PRSO .OBJ2> <PERFORM ,PRSA .OBJ1 ,PRSI>)
	      (<V-FOO>)>>

<OBJECT TURN
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE NUMBER FULL)
	(SYNONYM TURN TURNS MINUTE)
	(DESC "turn")
	(FLAGS UNITBIT ;NARTICLEBIT)
	(ACTION TURN-F)>

<ROUTINE TURN-F ()
 <COND (<VERB? USE>
	<PERFORM ,V?WAIT-FOR ,PRSO>
	<RTRUE>)>>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM THEY THIS)
	(DESC "it")
	(FLAGS VOWELBIT NARTICLEBIT)
	(ACTION IT-F)>

<ROUTINE IT-F ()
 <COND (<OR <AND <IOBJ? IT>
		 ;<FSET? ,PRSO ,PERSON>
		 <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR TELL-ABOUT>>
	    <AND <DOBJ? IT>
		 <VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR FIND WHAT>>>
	<TELL "\"I'm not sure what you're talking about.\"" CR>)>>

<OBJECT FLOOR
	(IN GLOBAL-OBJECTS)
	(DESC "floor")
	(SYNONYM FLOOR ;AREA DECK WALKWAY GROUND)
	(ACTION FLOOR-F)>

<ROUTINE FLOOR-F ()
	 <COND ;(<REMOTE-VERB?> <RFALSE>)
	       (<AND <VERB? PUT> <IOBJ? FLOOR>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<VERB? ;FIND THROUGH WALK-TO>
		<COND (,SUB-IN-TANK
		       <PERFORM ,PRSA ,TEST-TANK>
		       <RTRUE>)>)
	       (<VERB? EXAMINE SEARCH LOOK-ON>
		<TELL "You don't find anything new there." CR>)>>

<OBJECT IU-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "Inventions Unlimited")
	(ADJECTIVE INVENT)
	(SYNONYM UNLIMITED COMPANY BUSINESS)
	(FLAGS VOWELBIT NARTICLEBIT)
	(TEXT
"This vast enterprise was originally founded by your father, a world-famous
inventor. You have added even greater luster
to the family name with your own unique inventions.")>

<OBJECT DANGER
	(IN GLOBAL-OBJECTS)
	(DESC "danger")
	(SYNONYM DANGER THREAT)>

<OBJECT MOTIVE
	(IN GLOBAL-OBJECTS)
	(DESC "motive")
	;(ADJECTIVE YOUR)
	(SYNONYM MOTIVE)>

<OBJECT PROBLEM
	(IN GLOBAL-OBJECTS)
	(DESC "problem")
	(ADJECTIVE URGENT)
	(SYNONYM PROBLEM ;"WANT WRONG HAPPENING")>

<OBJECT GLOBAL-SNARK
	(IN GLOBAL-OBJECTS)
	(DESC "Snark")
	(ADJECTIVE SEA THIS HUGE)
	(SYNONYM SNARK MONSTER SLUG CREATURE ;BOOJUM)
	;(FLAGS INVISIBLE)
	(ACTION GLOBAL-SNARK-F)>

<ROUTINE GLOBAL-SNARK-F ()
 <COND (<AND <VERB? EXAMINE FIND> <NOT <0? ,SNARK-ATTACK-COUNT>>>
	;"I-SNARK-ATTACKS provides output."
	<RTRUE>)
       (<AND <VERB? FIND> <NOT ,MONSTER-GONE>>
	<TELL "It's attacking the " D ,AQUADOME "!" CR>
	<RTRUE>)>>

<OBJECT GLOBAL-WEAPON
	(IN GLOBAL-OBJECTS)
	(DESC "weapon")
	(ADJECTIVE ;YOUR SOME)
	(SYNONYM WEAPON)>

<OBJECT GLOBAL-EXPLOSIVE
	(IN GLOBAL-OBJECTS)
	(DESC "explosive charge")
	(ADJECTIVE ;YOUR SOME EXPLOSIVE)
	(SYNONYM EXPLOSIVE CHARGE)
	(FLAGS VOWELBIT)>

<OBJECT LOCAL-SUB
	(IN LOCAL-GLOBALS)
	(ADJECTIVE REVOLUTIONARY NEW ULTRAMARINE MY)
	(SYNONYM BIOCEPTOR SUB SUBMARINE SCIMITAR ;HULL ;BOAT)
	(DESC "SCIMITAR" ;"Ultramarine Bioceptor")
	(FLAGS VOWELBIT VEHBIT NDESCBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION LOCAL-SUB-F)>

<ROUTINE MIKE-3-F (OBJ)
	 <TELL "The " D .OBJ " is mounted on " A ,CLAW "." CR>>

<ROUTINE CANT-SEND ()
	<TELL "You can't send it. Only you can pilot it there." CR>>

<ROUTINE LOCAL-SUB-F ()
 <COND (<VERB? PUT TURN> <MORE-SPECIFIC>)
       (<VERB? SEARCH SEARCH-FOR>
	<DO-INSTEAD-OF ,SUB ,LOCAL-SUB>
	<RTRUE>)
       (<VERB? EXAMINE>
	<COND (<AND <NOT <GET ,ON-SUB 0>> <NOT <GET ,ON-SUB 1>>>
	       <TELL <GETP ,LOCAL-SUB ,P?TEXT>
;"(You'll find that information in your SEASTALKER package.)" CR>
	       <RTRUE>)>
	<COND (<GET ,ON-SUB 0>
	       <MIKE-3-F <GET ,ON-SUB 0>>)>
	<COND (<GET ,ON-SUB 1>
	       <MIKE-3-F <GET ,ON-SUB 1>>)>
	<RTRUE>)
       (<VERB? FIND>
	<DISABLE <INT I-SEND-SUB>>
	<TELL "It's right here!" CR>)
       (<OR <VERB? LOOK-BEHIND>
	    <AND <VERB? LOOK-OUTSIDE> <EQUAL? ,HERE ,SUB>>>
	<PERFORM ,V?LOOK-OUTSIDE ,SUB-WINDOW>
	<RTRUE>)
       (<VERB? LOOK-INSIDE>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <PERFORM ,V?LOOK>
	       <RTRUE>)
	      (T <TELL "You can't see much from here." CR>)>)
       (<AND <VERB? SEND SEND-OUT SEND-TO> <DOBJ? LOCAL-SUB>>
	<CANT-SEND>)
       (<VERB? THROUGH BOARD ;WALK-TO>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <ALREADY ,WINNER "in it">)
	      (<EQUAL? ,HERE ,AIRLOCK-WALL>
	       <COND (<GOTO ,AIRLOCK>
		      <COND (<AND <GOTO ,SUB> <NOT <==? ,WINNER ,PLAYER>>>
			     <OKAY>)>
		      <RTRUE>)>)
	      (<EQUAL? ,HERE ,WEST-TANK-AREA ,SOUTH-TANK-AREA>
	       <TELL <GETP ,WEST-TANK-AREA ,P?EAST>
		     ;"You have to go north to board the SCIMITAR." CR>)
	      (T
	       <DO-WALK ,P?IN>
	       <RTRUE>)>)
       (<VERB? ;EXIT DISEMBARK DROP RAISE>
	<COND (<NOT <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>>
	       <TELL "You're not in it!" CR>)
	      (<VERB? DROP>
	       <DO-WALK ,P?DOWN>
	       <RTRUE>)
	      (<VERB? RAISE>
	       <DO-WALK ,P?UP>
	       <RTRUE>)
	      (T
	       <DO-WALK ,P?OUT>
	       <RTRUE>)>)
       (<AND <VERB? OPEN CLOSE>
	     <NOT <EQUAL? ,HERE ,CRAWL-SPACE ,AIRLOCK-WALL>>>
	<PERFORM ,PRSA ,SUB-DOOR>
	<RTRUE>)
       (<AND <VERB? ANALYZE> <EQUAL? ,PRSI ,DAMAGE ,GLOBAL-SABOTAGE <>>>
	<TELL "You can do this by pushing the " D ,TEST-BUTTON>
	<COND (<NOT <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>>
	       <TELL " on the " D ,CONTROLS " inside">)>
	<TELL "." CR>)
       (<VERB? LAMP-ON>
	<COND (<NOT <EQUAL? ,HERE ,SUB ;,CRAWL-SPACE>>
	       <THIS-IS-IT ,SUB>
	       <TELL "You have to be in the " D ,SUB " to start it." CR>)
	      ;(<EQUAL? ,HERE ,CRAWL-SPACE>
	       <THIS-IS-IT ,SUB>
	       <TELL "You have to be in the pilot's seat to start it." CR>)
	      (<NOT <FSET? ,REACTOR ,ONBIT>>
	       <THIS-IS-IT ,REACTOR>
	       <TELL "The reactor is off!" CR>)
	      (<OR <AND ,SUB-IN-TANK
			<NOT ,TEST-TANK-FULL>
			<THIS-IS-IT ,TEST-TANK>>
		   <AND ,SUB-IN-DOME
			<NOT ,AIRLOCK-FULL>
			<THIS-IS-IT ,AIRLOCK>>>
	       <TELL "The tank is empty!" CR>)
	      (<OR <AND ,SUB-IN-TANK
			<NOT <FSET? ,TANK-GATE ,OPENBIT>>
			<THIS-IS-IT ,TANK-GATE>>
		   <AND ,SUB-IN-DOME
			<NOT <FSET? ,AIRLOCK-HATCH ,OPENBIT>>
			<THIS-IS-IT ,AIRLOCK-HATCH>>>
	       <TELL "The gate is closed!" CR>)
	      (<NOT <FSET? ,ENGINE ,ONBIT>>
	       <THIS-IS-IT ,ENGINE>
	       <TELL "The engine is off!" CR>)
	      (T
	       <TELL
"You can do this by setting the throttle to the speed you want (slow,
medium, or fast) and by moving the " D ,JOYSTICK
" in the " D ,INTDIR " you wish to go." CR
;"(' N ,THROTTLE-MAX ' forward settings, each one increasing the speed by
1 sea square per turn)">)>)
       (<VERB? STOP>
	<COND (<NOT <EQUAL? ,HERE ,SUB ;,CRAWL-SPACE>>
	       <THIS-IS-IT ,SUB>
	       <TELL "You have to be in the " D ,SUB " to stop it." CR>)
	      ;(<EQUAL? ,HERE ,CRAWL-SPACE>
	       <TELL "You have to be in the pilot's seat to stop it." CR>)
	      (<NOT <FSET? ,ENGINE ,ONBIT>>
	       <TELL "The engine is off!" CR>)
	      (T	;<EQUAL? ,SUB-DEPTH ,TARGET-DEPTH>
	       <SETG TARGET-DEPTH ,SUB-DEPTH>
	       <TELL ,I-ASSUME " close the " D ,THROTTLE ".)" CR>
	       <PERFORM ,V?CLOSE ,THROTTLE>
	       <RTRUE>)
	      ;(T
	       <TELL
"You can do this by closing the throttle and setting the Depth Control to
your present depth." CR>)>)>>

<OBJECT GLOBAL-SUB
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE REVOLUTIONARY NEW ULTRAMARINE MY)
	(SYNONYM BIOCEPTOR SUB SUBMARINE SCIMITAR)
	(DESC "SCIMITAR" ;"Ultramarine Bioceptor")
	;(TEXT
"This is your revolutionary new Ultramarine Bioceptor, named the SCIMITAR.")
	(ACTION GLOBAL-SUB-F)>

<OBJECT GLOBAL-SUB-2
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE REVOLUTIONARY NEW ULTRAMARINE MY)
	(SYNONYM BOAT)
	(DESC "boat")
	(ACTION GLOBAL-SUB-2-F)>

<ROUTINE GLOBAL-SUB-2-F ()
	<DO-INSTEAD-OF ,GLOBAL-SUB ,GLOBAL-SUB-2>
	<RTRUE>>

<ROUTINE GLOBAL-SUB-F ()
 <COND (<AND ,SUB-IN-TANK
	     <OR ,BLY-TOLD-PROBLEM
		 <NOT <EQUAL? ,PRSO ,GLOBAL-BLY>>>
	     <OR <VERB? FIND>
		 <AND <VERB? ASK-ABOUT> <FSET? ,PRSO ,PERSON>>>>
	<DISABLE <INT I-SEND-SUB>>
	<TELL "The only sub at">
	<RESEARCH-LAB>
	<TELL " is your new " D ,GLOBAL-SUB ".
It's located in the test tank just south of " D ,YOUR-LABORATORY "." CR>)
       (<VERB? BOARD ;ENTER THROUGH WALK-TO>
	<CHEERS?>
	<COND (<AND <GOTO ,SUB> <NOT <==? ,WINNER ,PLAYER>>>
	       <OKAY>)>
	<RTRUE>)
       (<VERB? PUT>
	<COND (<NOT <FSET? ,PRSO ,WEAPONBIT>>
	       <MORE-SPECIFIC>)>)
       (<AND <VERB? SEND SEND-OUT SEND-TO> <DOBJ? GLOBAL-SUB>>
	<CANT-SEND>)>>

<OBJECT CONTROLS
	(IN LOCAL-GLOBALS)
	(DESC "control panel")
	(ADJECTIVE OPERATOR CONTROL)
	(SYNONYM CONTROL PANEL KNOB KNOBS)
	(ACTION CONTROLS-F)>

<ROUTINE CONTROLS-F ()
 <COND (<AND <EQUAL? ,HERE ,CENTER-OF-LAB>
	     <NOT <VERB? EXAMINE LAMP-ON LAMP-OFF>>>
	<DO-INSTEAD-OF ,VIDEOPHONE ,CONTROLS>
	<RTRUE>)
       (<EQUAL? ,HERE ,WEST-TANK-AREA>
	<COND (<VERB? EXAMINE>
	       <TELL
"These are valves, gauges and control gear needed to make full use of
the tank. Two important controls are the " D ,OPEN-GATE-BUTTON " and the
" D ,FILL-TANK-BUTTON ". This gear can be operated by remote control
from all " LN " subs." CR>)>)>>

<ROUTINE PHONE-ON (PER PWHERE ON ;WHERE)
	<SETG REMOTE-PERSON .PER>
	<SETG QCONTEXT .PER>
	<THIS-IS-IT .PER>
	<SETG REMOTE-PERSON-REMLOC .PWHERE>
	<SETG REMOTE-PERSON-ON .ON>
	<SETG REMOTE-PERSON-LOC ,HERE ;.WHERE>
	<SETG QCONTEXT-ROOM ,HERE>
	<MOVE ,REMOTE-PERSON ,REMOTE-PERSON-LOC>>

<ROUTINE PHONE-OFF ()
	<COND (,REMOTE-PERSON
	       <MOVE ,REMOTE-PERSON ,GLOBAL-OBJECTS>
	       <SETG REMOTE-PERSON <>>
	       <SETG REMOTE-PERSON-LOC <>>
	       <SETG REMOTE-PERSON-ON <>>)>>

<OBJECT INTERCOM
	(IN LOCAL-GLOBALS)
	(SYNONYM INTERCOM)
	(DESC "intercom")
	(FLAGS VOWELBIT)
	(ACTION INTERCOM-F)>

<ROUTINE INTERCOM-F ("AUX" P L)
 <COND (<VERB? LAMP-ON SAY-INTO>
	<TELL "Try the command: CALL (someone) ON THE INTERCOM." CR>)
       (<VERB? PHONE>
	<COND (<FSET? ,PRSO ,PERSON>
	       <SET P <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>
	       <SET L <LOC .P>>)
	      (T
	       <HAR-HAR>
	       <RTRUE>)>
	<COND (<OR <AND <==? .L ,EAST-WALL> <==? ,HERE ,OFFICE>>
		   <AND <==? ,HERE ,EAST-WALL> <==? .L ,OFFICE>>>
	       <COND (<AND <==? .P ,SHARON> <IN? ,SHARON ,OFFICE>>
		      <FCLEAR ,SHARON ,NDESCBIT>
		      <FCLEAR ,FILE-DRAWER ,NDESCBIT>
		      <FCLEAR ,PAPERS ,NDESCBIT>)>
	       <MOVE .P ,HERE>
	       <TELL "Here ">)
	      (T
	       <TELL "There's no " D ,INTERCOM " line to where ">)>
	<HE-SHE-IT .P>
	<TELL " is." CR>)>>

<OBJECT TEST-BUTTON
	(IN LOCAL-GLOBALS)
	(ADJECTIVE TEST)
	(SYNONYM BUTTON SWITCH)
	(DESC "test button")
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION TEST-BUTTON-F)>

<GLOBAL TEST-BUTTON-READOUT 1>
<CONSTANT TEST-BUTTON-NORMAL 1>
<CONSTANT TEST-BUTTON-POD 2>
<CONSTANT REGULATOR-MSG 3>
<CONSTANT GATE-CRASHED-MSG 4>
<CONSTANT CLAW-MUNGED-MSG 5>

<ROUTINE A-O-K () <TELL "All systems A-O-K." CR>>

<ROUTINE TEST-BUTTON-F ()
 <COND (<VERB? PUSH TURN LAMP-OFF LAMP-ON>
	<COND (<EQUAL? ,HERE ,CENTER-OF-LAB>
	       <COND (<FSET? ,VIDEOPHONE ,MUNGBIT>
		      <TELL-HINT 83 ;6 ,POWER-SUPPLY <>>)
		     (<==? ,P-XADJN ,W?TEST>
		      <A-O-K>)
		     (<IN? ,MICROPHONE ,PLAYER>
		      <COND (<VERB? LAMP-OFF LAMP-ON>
			     <PERFORM ,PRSA ,MICROPHONE>)
			    (<FSET? ,MICROPHONE ,ONBIT>
			     <PERFORM ,V?LAMP-OFF ,MICROPHONE>)
			    (T
			     <PERFORM ,V?LAMP-ON ,MICROPHONE>)>)
		     (<VERB? LAMP-OFF>
		      <PERFORM ,V?LAMP-OFF ,VIDEOPHONE>)
		     (T <PERFORM ,V?LAMP-ON ,VIDEOPHONE>)>
	       <RTRUE>)
	      (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <COND (,TEST-BUTTON-READOUT
		      <TELL "Readout display says:|
">
		      <COND (<==? ,TEST-BUTTON-READOUT ,TEST-BUTTON-NORMAL>
			     <A-O-K>
			     <RTRUE>)
			    (<==? ,TEST-BUTTON-READOUT ,GATE-CRASHED-MSG>
			     <TELL "No damage. Hull still watertight.">)
			    (<==? ,TEST-BUTTON-READOUT ,REGULATOR-MSG>
			     <SETG REGULATOR-MSG-SEEN T>
			     ;<FCLEAR ,ENGINE-ACCESS-HATCH ,NDESCBIT>
			     <TELL 
"Lasers in operational computers are over-charging.|
To correct, adjust " D ,VOLTAGE-REGULATOR ".|
WARNING: " D ,VOLTAGE-REGULATOR " is reachable only from " ;"engine " D
,CRAWL-SPACE ", behind the " D ,ENGINE-ACCESS-HATCH ".
This is a hazardous operation at sea!">)	;" refer to manual for details
[Note: Manual should explain that entering the engine
compartment crawl space involves two hazards:
1-- Tight space presents risk of knocking delicate bearings out of alignment.
2-- Hot, sharp or moving parts present danger of personal injury.]"
			    (<==? ,TEST-BUTTON-READOUT ,TEST-BUTTON-POD>
			     <TELL
D ,ESCAPE-POD-UNIT " is not properly connected.">)
			    (<==? ,TEST-BUTTON-READOUT ,CLAW-MUNGED-MSG>
			     <TELL "The " D ,CLAW " is damaged.">)>
		      <CRLF>)>)
	      (<==? ,P-XADJN ,W?TEST>
	       <A-O-K>)
	      (<EQUAL? ,HERE ,EAST-WALL>
	       <COND (<VERB? LAMP-OFF>
		      <PERFORM ,V?LAMP-OFF ,MICROWAVE-SECURITY-SCANNER>)
		     (T<PERFORM ,V?LAMP-ON ,MICROWAVE-SECURITY-SCANNER>)>
	       <RTRUE>)
	      (<EQUAL? ,HERE ,NORTH-WALL>
	       <COND (<VERB? LAMP-OFF>
		      <PERFORM ,V?LAMP-OFF ,COMPUTESTOR>)
		     (T<PERFORM ,V?LAMP-ON ,COMPUTESTOR>)>
	       <RTRUE>)>)>>

<OBJECT POWER-SUPPLY
	(IN GLOBAL-OBJECTS)
	(DESC "power")
	(ADJECTIVE POWER)
	(SYNONYM SUPPLY)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<OBJECT DISTRESS-CALL
	(IN GLOBAL-OBJECTS)
	(DESC "distress call")
	(ADJECTIVE DISTRESS SOS)
	(SYNONYM CALL SOS)>

<OBJECT GLOBAL-SONAR
	(IN GLOBAL-OBJECTS)
	(DESC "sonar")
	(ADJECTIVE DETECT SONAR)
	(SYNONYM SONAR SYSTEM ;SONARSCOPE EQUIPM GEAR ;TRANSDUCER)
	(ACTION GLOBAL-SONAR-F)>

<ROUTINE GLOBAL-SONAR-F ()
 <COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	<DO-INSTEAD-OF ,SONARSCOPE ,GLOBAL-SONAR>
	<RTRUE>)
       (,SUB-IN-DOME
	<DO-INSTEAD-OF ,SONAR-EQUIPMENT ,GLOBAL-SONAR>
	<RTRUE>)
       ;(<VERB? WALK-TO> <PERFORM ,PRSA ,SONAR-EQUIPMENT> <RTRUE>)
       (<REMOTE-VERB?> <RFALSE>)
       (T <NOT-HERE ,GLOBAL-SONAR>)>>

<OBJECT GLOBAL-SURFACE
	(IN GLOBAL-OBJECTS)
	(DESC "surface")
	(SYNONYM SURFACE)>

<GLOBAL ALARM-RINGING T>
<GLOBAL WOMAN-ON-SCREEN <>>

<OBJECT ALARM
	(IN LOCAL-GLOBALS ;CENTER-OF-LAB)
	(DESC "alarm bell")
	(ADJECTIVE VIDEOPHONE ALARM WARNING)
	(SYNONYM ALARM BELL)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION ALARM-F)>

<ROUTINE ALARM-F ()
	<COND (<VERB? LAMP-OFF LISTEN REPLY STOP>
	       <COND (,ALARM-RINGING
		      <WHY-NOT-VP>)
		     ;(<OR ,DEPTH-WARNING ,SONAR-WARNING ,SHIP-WARNING>
		      <MORE-SPECIFIC>)
		     (T <TELL "It's not ringing!" CR>)>)>>

<ROUTINE WHY-NOT-VP ()
	<TELL "Why not turn on the " D ,VIDEOPHONE "?" CR>>

<OBJECT VIDEOPHONE
	(IN LOCAL-GLOBALS)
	(ADJECTIVE VIDEOPHONE VIDEO)
	(SYNONYM VIDEOPHONE ;TV SPEAKER PHONE SCREEN)
	(DESC "videophone")
	(ACTION VIDEOPHONE-F)
	(FLAGS NDESCBIT)
	(VALUE 1)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<OBJECT VIDEOPHONE-2
	(IN LOCAL-GLOBALS)
	(DESC "videophone")
	(ADJECTIVE ;VIDEO VIDEOPHONE)
	(SYNONYM PICTURE SOUND)
	(VALUE 1)
	(ACTION VIDEOPHONE-2-F)>

<ROUTINE VIDEOPHONE-2-F ()
	<TELL ,I-ASSUME " the " D ,VIDEOPHONE ".)" CR>
	<DO-INSTEAD-OF ,VIDEOPHONE ,VIDEOPHONE-2>
	<RTRUE>>

<ROUTINE VIDEOPHONE-F ("OPTIONAL" ARG "AUX" V)
 <COND (<VERB? EXAMINE ;ANALYZE READ>
	<COND (<EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE>
	       <TELL "You can see " D ,REMOTE-PERSON " on" THE-PRSO "."CR>)
	      (,WOMAN-ON-SCREEN
	       <TELL
"You can see a fuzzy picture of a woman on" THE-PRSO ". Maybe you should
turn the knob." CR>)
	      (<FSET? ,VIDEOPHONE ,ONBIT>
	       <TELL
"The " D ,VIDEOPHONE " is on, but no one's on the screen." CR>)
	      ;(,ALARM-RINGING
	       <TELL "An "D ,ALARM" on the " D ,VIDEOPHONE " is ringing." CR>)
	      (T <TELL "The screen is dark." CR>)>)
       (<VERB? LISTEN>
	<COND (<EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE>
	       <PERFORM ,PRSA ,REMOTE-PERSON>
	       <RTRUE>)
	      (,WOMAN-ON-SCREEN
	       <TELL
"You can hear fuzzy sound from" THE-PRSO ". Maybe you should
turn the knob." CR>)
	      (,ALARM-RINGING
	       <TELL
"An " D ,ALARM " on the " D ,VIDEOPHONE " is ringing." CR>)>)
       (<AND <VERB? ANALYZE> <IOBJ? GLOBAL-SABOTAGE> ,SUB-IN-TANK>
	<TELL
"If you wish
to determine at once whether any saboteur or other intruder may have
penetrated">
	<RESEARCH-LAB>
	<TELL ", activate the " D ,MICROWAVE-SECURITY-SCANNER "." CR>)
       (<AND <VERB? WALK-TO>
	     <OR ,SUB-IN-TANK ,SUB-IN-DOME>
	     <NOT <EQUAL? ,HERE ,CENTER-OF-LAB ,COMM-BLDG>>>
	<COND (,SUB-IN-TANK
	       <PERFORM ,V?WALK-TO ,CENTER-OF-LAB>)
	      (T
	       <PERFORM ,V?WALK-TO ,COMM-BLDG>)>
	<RTRUE>)
       (<REMOTE-VERB?> <RFALSE>)
       (<NOT <EQUAL? ,HERE ,CENTER-OF-LAB ,COMM-BLDG>>
	<TELL "You must be in the ">
	<COND (,SUB-IN-TANK <TELL D ,CENTER-OF-LAB>)
	      (T <TELL D ,COMM-BLDG>)>
	<TELL " to do that." CR>)
       (<VERB? ADJUST FIX TURN>
	<COND (<FSET? ,VIDEOPHONE ,MUNGBIT>
	       <TELL
"You can't fix the " D ,VIDEOPHONE " until you know what is wrong.
The simplest way to find out is to consult your "LN" " D ,COMPUTESTOR ",
which is programmed to troubleshoot many of your inventions.
Or, alternately, you may have the " D ,VIDEOPHONE " repaired by a "
D ,GLOBAL-TECHNICIAN "." CR>
	       <RTRUE>)
	      (<NOT <FSET? ,VIDEOPHONE ,ONBIT>>
	       <WHY-NOT-VP>
	       <RTRUE>)
	      (<NOT ,WOMAN-ON-SCREEN>
	       <TELL "Nothing changes." CR>
	       <RTRUE>)>
	<SETG WOMAN-ON-SCREEN <>>
	<PHONE-ON ,GLOBAL-BLY ,AQUADOME ,VIDEOPHONE>
	;<ENABLE <QUEUE I-SHARON-TO-HALLWAY 12>>
	<THIS-IS-IT ,PROBLEM>
	<TELL
"Ah, that's better! You recognize the woman as " D ,BLY ", who's in
charge of the " ,URS " of " D ,IU-GLOBAL ", called
the " D ,AQUADOME ", just off the Atlantic coast. \"" FN "! " FN "!\" she's
saying. \"This is the " D ,AQUADOME " calling">
	<RESEARCH-LAB>
	<TELL "! We have an urgent problem!\"" CR>
	<SCORE-OBJ ,VIDEOPHONE-2>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	;<DISABLE <INT I-SHARON-TO-HALLWAY>>
	<COND (<NOT <FSET? ,VIDEOPHONE ,ONBIT>>
	       <RFALSE>)>
	<SETG WOMAN-ON-SCREEN <>>
	<FCLEAR ,VIDEOPHONE ,ONBIT>
	<COND (<AND <==? ,REMOTE-PERSON-ON ,VIDEOPHONE>
		    <FSET? ,MICROPHONE ,ONBIT>>
	       <PERFORM ,V?GOODBYE ,REMOTE-PERSON>
	       <RTRUE>)
	      (T
	       <PHONE-OFF>
	       <TELL "The screen goes dark." CR>)>)
       (<AND <VERB? LAMP-ON REPLY> ,SUB-IN-TANK>
	<COND (<FSET? ,VIDEOPHONE ,ONBIT>
	       <ALREADY ,VIDEOPHONE "on">
	       <RTRUE>)
	      (<OR <FSET? ,CIRCUIT-BREAKER ,OPENBIT>
		   <FSET? ,VIDEOPHONE ,MUNGBIT>>
	       <TELL "You can't. It's conked out." CR>
	       <RTRUE>)>
	<DISABLE <INT I-LAMP-ON-SCOPE>>
	<FSET ,VIDEOPHONE ,ONBIT>
	<COND (,ALARM-RINGING
	       <SETG ALARM-RINGING <>>
	       <QUEUE I-ALARM-RINGING 0>
	       <SETG WOMAN-ON-SCREEN T>
	       <THIS-IS-IT ,GLOBAL-BLY>
	       <TELL
"As the " D ,ALARM " stops ringing, a picture of a woman holding a " D
,MICROPHONE " appears, and you can hear her voice from the speaker. But
both sound and picture are fuzzy." CR>
	       <SCORE-OBJ ,VIDEOPHONE>
	       <RTRUE>)
	      (T <TELL "A test pattern appears." CR>)>)
       (<VERB? PHONE>
	<COND (<OR ,WOMAN-ON-SCREEN
		   <EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE>>
	       <TELL "You should finish talking with ">
	       <COND (,WOMAN-ON-SCREEN <TELL "the woman">)
		     (T <TELL D ,REMOTE-PERSON>)>
	       <TELL " first." CR>
	       <RTRUE>)>
	<COND (<AND <DOBJ? YOUR-LABORATORY> ,SUB-IN-DOME>
	       <TELL "There's no answer." CR>)
	      (<AND <DOBJ? AQUADOME GLOBAL-BLY> ,SUB-IN-TANK>
	       <COND (,BLY-TOLD-PROBLEM
		      <TELL
"There's no answer. The crew must be busy with the " D ,SNARK "." CR>
		      <RTRUE>)
		     (,ALARM-RINGING
		      <PERFORM ,V?LAMP-ON ,VIDEOPHONE>
		      <RTRUE>)>)>)>>

<OBJECT VIDEOPHONE-TRANSMITTER
	(IN GLOBAL-OBJECTS)
	(SYNONYM TRANSMITTER)
	(DESC "transmitter")
	(FLAGS NDESCBIT)
	(ACTION VIDEOPHONE-TEST-F)>

<OBJECT VIDEOPHONE-CABLE
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE UNDERSEA COAXIAL)
	(SYNONYM CABLE)
	(DESC "undersea coaxial cable")
	(FLAGS NDESCBIT)
	(ACTION VIDEOPHONE-TEST-F)>

<OBJECT VIDEOPHONE-SATELLITE
	(IN GLOBAL-OBJECTS)
	(SYNONYM SATELLITE)
	(DESC "satellite")
	(FLAGS NDESCBIT)
	(ACTION VIDEOPHONE-TEST-F)>

<OBJECT DAMAGE
	(IN GLOBAL-OBJECTS)
	(DESC "damage")
	(SYNONYM DAMAGE)>

<OBJECT GLOBAL-SABOTAGE
	(IN GLOBAL-OBJECTS)
	(DESC "sabotage")
	(SYNONYM SABOTAGE)
	(ACTION GLOBAL-SABOTAGE-F)>

<ROUTINE GLOBAL-SABOTAGE-F ()
 <COND (<AND <VERB? ANALYZE> <DOBJ? VIDEOPHONE ;GLOBAL-VIDEOPHONE>>
	;<SETG TIP-SAYS 0>
	<DISABLE <INT I-TIP-SAYS>>
	<RFALSE>)>>

;<OBJECT GLOBAL-WEATHER
	(IN GLOBAL-OBJECTS)
	(DESC "weather")
	(SYNONYM WEATHER CLIMATE)>

;<OBJECT GLOBAL-CALL
	(IN GLOBAL-OBJECTS)
	(DESC "telephone call")
	(ADJECTIVE TELEPHONE PHONE)
	(SYNONYM CALL ;CONVERSATION)>

<OBJECT INTDIR
	(IN GLOBAL-OBJECTS)
	(SYNONYM DIRECT)
	(ADJECTIVE NORTH EAST SOUTH WEST NE NW SE SW)
	;(FLAGS TOOLBIT)
	(DESC "compass direction")>

<OBJECT GLOBAL-WATER
	(IN GLOBAL-OBJECTS)
	(DESC "sea water")
	(ADJECTIVE SEA)
	(SYNONYM WATER SEAWATER)
	(ACTION WATER-F)>

<ROUTINE WATER-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)
       (,SUB-IN-TANK
	<COND (<AND <IN-TANK-AREA? ,HERE> ,TEST-TANK-FULL>
	       <DO-INSTEAD-OF ,TEST-TANK ,GLOBAL-WATER>
	       <RTRUE>)>)
       (<VERB? ANALYZE EXAMINE>
	<COND (<GLOBAL-IN? ,WINDOW ,HERE>
	       <PERFORM ,V?LOOK-OUTSIDE ,WINDOW>
	       <RTRUE>)
	      (<EQUAL? ,HERE ,SUB>
	       <PERFORM ,V?LOOK-OUTSIDE ,SUB-WINDOW>
	       <RTRUE>)>)
       (<VERB? SWIM THROUGH>
	<TELL "This is no time for a swim, " FN "!" CR>)>>

<OBJECT SEA
	(IN GLOBAL-OBJECTS)
	(DESC "open sea")
	(ADJECTIVE OPEN ATLANTIC)
	(SYNONYM OCEAN SEA)
	(FLAGS VOWELBIT)
	(ACTION SEA-F)>

<ROUTINE SEA-F ()
 <COND (<VERB? EXAMINE ANALYZE>
	<COND (<OR ,SUB-IN-DOME
		   ,SUB-IN-OPEN-SEA
		   <==? ,NOW-TERRAIN ,SEA-TERRAIN>>
	       <PLENTY-WATER>)>)
       (<VERB? ;ENTER FIND THROUGH WALK-TO>
	<COND (<OR ,SUB-IN-DOME
		   ,SUB-IN-OPEN-SEA
		   <==? ,NOW-TERRAIN ,SEA-TERRAIN>>
	       <TELL "You're in it!" CR>)
	      (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <TELL
"The nautical chart in your SEASTALKER package should help." CR>)
	      (T <TELL "First you must get in the " D ,SUB "." CR>)>)>>

<OBJECT HER
	(IN GLOBAL-OBJECTS)
	(SYNONYM SHE HER WOMAN GIRL)
	(DESC "her")
	(FLAGS NARTICLEBIT)>

<OBJECT HIM
	(IN GLOBAL-OBJECTS)
	(SYNONYM HE HIM MAN BOY)
	(DESC "him")
	(FLAGS NARTICLEBIT)>

<OBJECT YOU
	(IN GLOBAL-OBJECTS)
	(SYNONYM YOU YOURSELF HIMSELF HERSELF)
	(DESC "himself or herself")
	(FLAGS ;NDESCBIT NARTICLEBIT)
	(ACTION YOU-F)>

<ROUTINE YOU-F ()
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<DO-INSTEAD-OF ,WINNER ,YOU>
	<RTRUE>)
       (<AND <VERB? ASK-ABOUT> <IOBJ? YOU>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
	<RTRUE>)>>

<OBJECT HINT
	(DESC "clue" ;"hint")
	(IN GLOBAL-OBJECTS)
	(SYNONYM CLUE HINT HELP)
	(ACTION HINT-F)>

<ROUTINE HINT-F ()
 <COND (<VERB? FIND>
	<TELL ,HELP-TEXT CR>)
       (<VERB? ASK-FOR ASK-CONTEXT-FOR TAKE>
	<COND (<EQUAL? ,TIP ,PRSO ,PRSI ,WINNER>
	       <TELL ,HELP-TEXT CR>)
	      (T <MORE-SPECIFIC>)>)>>

<OBJECT DIRNS
	(DESC "Aquadome directions")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE DOME AQUADOME)
	(SYNONYM DIRECT)
	(ACTION DIRNS-F)>

<ROUTINE DIRNS-F ()
 <COND (<AND <VERB? ASK-FOR> <DOBJ? GLOBAL-BLY>>
	<SETG WINNER ,GLOBAL-BLY>
	<PERFORM ,V?FIND ,AQUADOME>
	<RTRUE>)>>

<OBJECT GLOBAL-HERE
	(IN GLOBAL-OBJECTS)
	(DESC "here")
	(SYNONYM HERE AREA ROOM PLACE)
	(FLAGS NARTICLEBIT)
	(GENERIC GENERIC-TANK-F)
	(ACTION GLOBAL-HERE-F)>

<ROUTINE GLOBAL-HERE-F ("AUX" (FLG <>) F HR TIM VAL)
	 <COND (<VERB? KNOCK>
		<TELL "Knocking on the walls reveals nothing unusual." CR>)
	       (<VERB? PUT TIE-TO>
		<MORE-SPECIFIC>)
	       (<VERB? SEARCH EXAMINE>
		<COND ;(<OUTSIDE? ,HERE>
		       <SET TIM 10>)
		      (<NOT <0? <GETP ,HERE ,P?CORRIDOR>>>
		       <SET TIM 3>)
		      (T <SET TIM <+ 2 <GETP ,HERE ,P?SIZE>>>)>
		<COND (<==? ,P-ADVERB ,W?CAREFULLY> <SET TIM <* 2 .TIM>>)>
		<TELL
"(It's better to examine or search one thing at a time. It would take a
long time to search a whole room or area thoroughly. A ">
		<COND (<==? ,P-ADVERB ,W?CAREFULLY> <TELL "careful">)
		      (T <TELL "brief">)>
		<TELL " search would take
" N .TIM " turns, and it might not reveal much. Would you like
to do it anyway?)">
		<COND (<YES?>
		       <COND (<==? ,M-FATAL <SET VAL <INT-WAIT .TIM>>>
			      <RTRUE>)
			     (.VAL
			      <TELL "Your "
				      <COND (<==? ,P-ADVERB ,W?CAREFULLY>
					     "careful")
					    (T "brief")>
				      " search reveals nothing exciting." CR>)
			     (T
			      <TELL
"You didn't finish looking over the place." CR>)>)
		      (T <TELL "Okay." CR>)>)
	       (<VERB? WHAT ANALYZE ;ASK-ABOUT>
		<SET F <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .F> <RETURN>)
			      (<AND <FSET? .F ,CONTBIT> <INHABITED? .F>>
			       <SET FLG T>
			       <SET HR ,HERE>
			       <SETG HERE .F>
			       <GLOBAL-HERE-F>
			       <SETG HERE .HR>)
			      (<AND <FSET? .F ,PERSON> <NOT <==? .F ,PLAYER>>>
			       <SET FLG T>
			       <DESCRIBE-OBJECT .F T 0>)>
			<SET F <NEXT? .F>>>
		<COND (<NOT .FLG> <TELL "There's nobody else here." CR>)>
		<RTRUE>)>>

<OBJECT AIR
	(IN GLOBAL-OBJECTS)
	(DESC "air")
	(SYNONYM AIR WIND BREEZE OXYGEN)
	(FLAGS VOWELBIT)
	(ACTION AIR-F)>

<ROUTINE AIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "You can see through the air around you." CR>)
	       (<VERB? WALK-TO>
		<TELL "It's all around you!" CR>)
	       (<VERB? SMELL>
		<COND ;(<OUTSIDE? ,HERE>
		       <TELL "The air is clear and fresh." CR>)
		      (<FRESH-AIR? ,HERE> <RTRUE>)
		      (T <TELL "The air is rather musty." CR>)>)>>

<ROUTINE GENERIC-TANK-F (OBJ)
 <COND ;(<VERB? LEAVE>
	,GLOBAL-HERE)
       (,SUB-IN-TANK
	,TEST-TANK)
       (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	,DOCKING-TANK)>>

<OBJECT DOCKING-TANK
	(IN GLOBAL-OBJECTS)
	(DESC "docking tank")
	(ADJECTIVE DOCKING)
	(SYNONYM TANK ;AREA ;ROOM ;AIRLOCK DOCK)
	(GENERIC GENERIC-TANK-F)
	(ACTION AIRLOCK-F)>

<OBJECT TEST-TANK
	(IN GLOBAL-OBJECTS)
	(DESC "test tank")
	(ADJECTIVE TEST)
	(SYNONYM TANK ;AREA ;ROOM DOCK)
	(GENERIC GENERIC-TANK-F)
	(ACTION TEST-TANK-F)>

<GLOBAL TEST-TANK-FULL <>>

<ROUTINE TOO-FAR-AWAY (OBJ)
	<TOO-BAD-BUT .OBJ "too far away">
	;<TELL "You're too far away to do that to the " D .OBJ "." CR>>

<ROUTINE TEST-TANK-F ()
 <COND (<VERB? WALK-TO>
	<COND (<IN-TANK-AREA? ,HERE> <ALREADY ,PLAYER "in it">)
	      (,SUB-IN-TANK
	       <PERFORM ,PRSA ,NORTH-TANK-AREA>
	       <RTRUE>)>)
       (<REMOTE-VERB?> <RFALSE>)
       (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
	<TOO-FAR-AWAY ,TEST-TANK>)
       (<NOT ,SUB-IN-TANK>
	<TELL "You're nowhere near">
	<RESEARCH-LAB>
	<TELL "!" CR>)
       (<AND <OR <NOT <EQUAL? ,HERE ,SUB>> <NOT ,SUB-IN-TANK>>
	     <NOT <EQUAL? ,HERE ,NORTH-TANK-AREA ,WEST-TANK-AREA
				,SOUTH-TANK-AREA>>>
	;<SETG P-WON <>>
	<NOT-HERE ,TEST-TANK>)
       (<VERB? BOARD>
	<TELL "That won't do any good." CR>)
       (<VERB? ;DROP LEAVE>
	<TELL
"You can either walk north, or get in the " D ,SUB " and go east." CR>)
       (<VERB? ANALYZE EXAMINE LOOK-INSIDE>
	<FILL-TANK-BUTTON-F>)
       (<AND <VERB? EMPTY FILL>
	     <NOT <EQUAL? ,HERE ,WEST-TANK-AREA ,SUB>>>
	<TELL "You'll have to go west to do that." CR>
	<RTRUE>)
       (<VERB? EMPTY>
	<COND (<FSET? ,TANK-GATE ,OPENBIT>
	       <YOU-CANT "empty" ,TANK-GATE "open">)
	      (<FSET? ,ENGINE ,ONBIT>
	       <YOU-CANT "empty" ,ENGINE "on">)
	      (,TEST-TANK-FULL
	       <SETG TEST-TANK-FULL <>>
	       <TELL
"The " D ,GLOBAL-WATER " quickly drains from the tank." CR>)
	      (T <ALREADY ,TEST-TANK "empty">)>)
       (<VERB? FILL>
	<COND (,TEST-TANK-FULL
	       <ALREADY ,TEST-TANK "full">)
	      (T
	       <SETG TEST-TANK-FULL T>
	       <TELL
"The " D ,GLOBAL-WATER " quickly fills the tank, up to the level of the
walkway." CR>)>)
       (<VERB? OPEN CLOSE> <PERFORM ,PRSA ,TANK-GATE> <RTRUE>)
       (<VERB? SWIM THROUGH>
	<TELL "This is no time for a swim, " FN "!" CR>)>>

<OBJECT FILL-TANK-BUTTON
	(IN LOCAL-GLOBALS ;SUB)
	(DESC "tank control")
	(ADJECTIVE TANK)
	(SYNONYM CONTROL SWITCH)
	(FLAGS NDESCBIT)
	(ACTION FILL-TANK-BUTTON-F)>

<ROUTINE FILL-TANK-BUTTON-F ("AUX" OBJ FLAG)
 <COND (,SUB-IN-TANK
	<SET FLAG ,TEST-TANK-FULL>
	<SET OBJ ,TEST-TANK>)
       (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	<SET FLAG ,AIRLOCK-FULL>
	<SET OBJ ,AIRLOCK>)
       (T <RFALSE>)>
 <COND (<VERB? OPEN CLOSE FILL EMPTY>
	<PERFORM ,PRSA .OBJ>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE LOOK-INSIDE>
	<TELL "The " D .OBJ " is " <TANK-STATUS> "." CR>)
       (<VERB? MOVE PUSH USE>
	<COND (.FLAG
	       <TELL ,I-ASSUME " empty" THE .OBJ ".)" CR>
	       <PERFORM ,V?EMPTY .OBJ>
	       <RTRUE>)
	      (T
	       <TELL ,I-ASSUME " fill" THE .OBJ ".)" CR>
	       <PERFORM ,V?FILL .OBJ>
	       <RTRUE>)>)>>

<OBJECT TANK-GATE
	(IN GLOBAL-OBJECTS)
	(DESC ;"steel" "test tank gate")
	(ADJECTIVE STEEL TEST TANK SEA REPELATRON SAFETY FLOOD)
	(SYNONYM GATE GATES BUMPER)
	(FLAGS DOORBIT)
	(GENERIC GENERIC-GATE-F)
	(ACTION TANK-GATE-F)>

<GLOBAL OPENED-GATE-FROM-SUB <>>
<ROUTINE TANK-GATE-F ()
 <COND (<VERB? FIND>
	<TELL "It's on the east wall of the test tank." CR>)
       (<REMOTE-VERB?> <RFALSE>)
       (<AND <NOT <EQUAL? ,HERE ,SUB>>
	     <NOT <IN-TANK-AREA? ,HERE>>>
	;<SETG P-WON <>>
	<NOT-HERE ,TANK-GATE>)
       (<VERB? ANALYZE EXAMINE>
	<TELL
"This gate "
<COND (<FSET? ,TANK-GATE ,OPENBIT> "is") (T "can be")>
" raised to
permit submarines to go in or out of the tank. The gate can
be raised or lowered by wall controls or by remote control from
all " LN " subs." CR>)
       (<VERB? OPEN CLOSE RAISE DROP>
	<COND (<NOT <EQUAL? ,HERE ,WEST-TANK-AREA ,SUB>>
	       <TELL "You'll have to go west to do that." CR>
	       <RTRUE>)>
	<OPEN-CLOSE-GATE ,TANK-GATE ,TEST-TANK-FULL ,TEST-TANK>)>>

<OBJECT OPEN-GATE-BUTTON
	(IN LOCAL-GLOBALS ;SUB)
	(DESC "gate control")
	(ADJECTIVE GATE)
	(SYNONYM CONTROL SWITCH)
	(FLAGS NDESCBIT)
	(ACTION OPEN-GATE-BUTTON-F)>

<ROUTINE OPEN-GATE-BUTTON-F ("AUX" OBJ)
 <COND (,SUB-IN-TANK
	<SET OBJ ,TANK-GATE>)
       (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	<SET OBJ ,AIRLOCK-HATCH>)
       (T <RFALSE>)>
 <COND (<VERB? OPEN CLOSE RAISE DROP>
	<PERFORM ,PRSA .OBJ>
	<RTRUE>)
       (<VERB? ANALYZE EXAMINE>
	<TELL "The " D .OBJ " is " <GATE-STATUS> "." CR>)
       (<VERB? MOVE PUSH USE>
	<COND (<FSET? .OBJ ,OPENBIT>
	       <TELL ,I-ASSUME " close" THE .OBJ ".)" CR>
	       <PERFORM ,V?CLOSE .OBJ>
	       <RTRUE>)
	      (T
	       <TELL ,I-ASSUME " open" THE .OBJ ".)" CR>
	       <PERFORM ,V?OPEN .OBJ>
	       <RTRUE>)>)>>

<ROUTINE GATE-STATUS ()
	<COND (,SUB-IN-TANK
	       <COND (<FSET? ,TANK-GATE ,OPENBIT> "open") (T "closed")>)
	      (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	       <COND (<FSET? ,AIRLOCK-HATCH ,OPENBIT> "open") (T "closed")>)
	      (T "???")>>

<ROUTINE TANK-STATUS ()
	<COND (,SUB-IN-TANK
	       <COND (,TEST-TANK-FULL "full") (T "empty")>)
	      (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	       <COND (,AIRLOCK-FULL "full") (T "empty")>)
	      (T "???")>>

<OBJECT AIRLOCK-HATCH
	(IN GLOBAL-OBJECTS ;LOCAL-GLOBALS)
	(DESC ;"Aquadome airlock" "docking tank gate")
	(ADJECTIVE DOCKING TANK AQUADOME AIRLOCK)
	(SYNONYM ;HATCH GATE GATES)
	(FLAGS DOORBIT VOWELBIT)
	(GENERIC GENERIC-GATE-F)
	(ACTION AIRLOCK-HATCH-F)>

<ROUTINE AIRLOCK-HATCH-F ()
 <COND (<VERB? FIND>
	<TELL
"It's on the south wall of the " D ,AQUADOME " " D ,AIRLOCK "." CR>)
       (<REMOTE-VERB?> <RFALSE>)
       (<AND <OR <NOT ,SUB-IN-DOME>
		 <NOT <EQUAL? ,HERE ,SUB ,AIRLOCK ,BLY-OFFICE>>>
	     <NOT <SUB-OUTSIDE-AIRLOCK?>>>
	<TOO-FAR-AWAY ,AIRLOCK-HATCH>)
       (<NOT <0? ,SNARK-ATTACK-COUNT>>
	<TELL "It's too late now! The machinery is jammed!" CR>)
       (<VERB? OPEN CLOSE RAISE DROP>
	<OPEN-CLOSE-GATE ,AIRLOCK-HATCH ,AIRLOCK-FULL ,AIRLOCK>)>>

<ROUTINE OPEN-CLOSE-GATE (GATE FULL TANK)
	<COND (<VERB? OPEN RAISE>
	       <COND (<FSET? .GATE ,OPENBIT>
		      <ALREADY .GATE "open">
		      <RTRUE>)
		     (<NOT .FULL>
		      <TELL
"You'd better fill the " D .TANK " first, unless you want to go surfing!" CR>
		      <RTRUE>)
		     (T
		      <COND (<AND <==? .GATE ,TANK-GATE> <EQUAL? ,HERE ,SUB>>
			     <SETG OPENED-GATE-FROM-SUB T>)>
		      <FSET .GATE ,OPENBIT>)>)
	      (T
	       <COND (<FSET? .GATE ,OPENBIT>
		      <FCLEAR .GATE ,OPENBIT>)
		     (T
		      <ALREADY .GATE "closed">
		      <RTRUE>)>)>
	<COND (<FSET? .GATE ,OPENBIT> <TELL "Opened">)
	      (T <TELL "Closed">)>
	<COND (<EQUAL? ,HERE ,SUB>
	       <TELL " (by remote control)">)>
	<TELL "." CR>>

<ROUTINE AIRLOCK-POP? ()
 <COND (,GREENUP-ESCAPE
	<FIND-FLAG ,AIRLOCK ,PERSON ,GREENUP>)
       (T <FIND-FLAG ,AIRLOCK ,PERSON>)>>

<ROUTINE GENERIC-GATE-F (OBJ)
 <COND (,SUB-IN-TANK
	,TANK-GATE)
       (<OR ,SUB-IN-DOME <SUB-OUTSIDE-AIRLOCK?>>
	,AIRLOCK-HATCH)>>

<ROUTINE SUB-OUTSIDE-AIRLOCK? ()
 <COND (<NOT <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>>
	<RFALSE>)
       (<NOT <0? ,SUB-LON>>
	<RFALSE>)
       (,FINE-SONAR
	<COND (<==? -2 ,SUB-LAT>
	       <RTRUE>)>)
       (<==? -1 ,SUB-LAT>
	<RTRUE>)>>

<OBJECT AIRLOCK-ROOF
	(IN GLOBAL-OBJECTS ;LOCAL-GLOBALS)
	(DESC ;"Aquadome airlock" "docking tank roof")
	(ADJECTIVE DOCKING TANK AIRLOCK)
	(SYNONYM ROOF)
	(FLAGS DOORBIT VOWELBIT)
	(ACTION AIRLOCK-ROOF-F)>

<ROUTINE AIRLOCK-ROOF-F ()
 <COND (<VERB? FIND>
	<TELL "It covers the " D ,AQUADOME " " D ,AIRLOCK "." CR>)
       (<REMOTE-VERB?> <RFALSE>)
       (<OR <NOT ,SUB-IN-DOME>
	    <AND <NOT <EQUAL? ,HERE ,SUB ,AIRLOCK ,BLY-OFFICE>>
		 <NOT <EQUAL? ,HERE ,AIRLOCK-WALL>>>>
	<TOO-FAR-AWAY ,AIRLOCK-ROOF>)
       (<VERB? OPEN>
	<COND (<FSET? ,AIRLOCK-ROOF ,OPENBIT>
	       <ALREADY ,AIRLOCK-ROOF "open">
	       <RTRUE>)
	      (<FSET? ,AIRLOCK-HATCH ,OPENBIT>
	       ;<ENABLE <QUEUE I-DOME-FLOODED 2>>
	       <THIS-IS-IT ,AIRLOCK-HATCH>
	       <TELL
"A safety mechanism prevents it. The " D ,AIRLOCK-HATCH " is open!" CR>
	       <RTRUE>)>
	<FSET ,AIRLOCK-ROOF ,OPENBIT>
	<TELL "Opened">
	<COND (<EQUAL? ,HERE ,SUB>
	       <TELL " (by remote control)">)>
	<TELL "." CR>)
       (<VERB? CLOSE>
	<COND (<NOT <FSET? ,AIRLOCK-ROOF ,OPENBIT>>
	       <ALREADY ,AIRLOCK-ROOF "closed">
	       <RTRUE>)>
	<FCLEAR ,AIRLOCK-ROOF ,OPENBIT>
	<TELL "Closed">
	<COND (<EQUAL? ,HERE ,SUB>
	       <TELL " (by remote control)">)>
	<TELL "." CR>
	;<DISABLE <INT I-DOME-FLOODED>>
	<COND (<AND ,GREENUP-ESCAPE <G? 3 ,GREENUP-ESCAPE>>
	       <TELL
"Greenup can't get into the " D ,SUB " and escape any more. ">
	       <GREENUP-CUFF>)>
	<RTRUE>)>>

<OBJECT PRIVATE-MATTER
	(DESC "private matter")
	;(IN GLOBAL-OBJECTS)
	(ADJECTIVE PERSONAL ;PRIVATELY)
	(SYNONYM MATTER)>

<OBJECT EVIDENCE
	(DESC "evidence")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE ;EVEN ;MORE OTHER DEFINITE)
	(SYNONYM EVIDENCE)
	(FLAGS VOWELBIT)
	(ACTION EVIDENCE-F)>

<ROUTINE EVIDENCE-F ()
 <COND (<AND ,ZOE-MENTIONED-EVIDENCE <VERB? TAKE>>
	<PERFORM ,PRSA ,BLACK-BOX>
	<RTRUE>)>>

<OBJECT MORE
	(DESC "more")
	(IN GLOBAL-OBJECTS)
	(SYNONYM MORE)
	(FLAGS NARTICLEBIT)>

<OBJECT ORE-NODULES
	(DESC "valuable ore deposit")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE VALUABLE ORE)
	(SYNONYM DEPOSIT FIELD NODULE)
	;(FLAGS VOWELBIT)>

<OBJECT TIP-IDEA
	(DESC "Tip's idea")
	(ADJECTIVE ;YOUR HIS ;TIP TIP\'S RANDALL)
	(SYNONYM IDEA ;PLAN TRAP)
	(FLAGS NARTICLEBIT)>

<OBJECT BLY-PLAN
	(DESC "Bly's plan")
	(ADJECTIVE ;YOUR HER ;ZOE ZOE\'S BLY\'S)
	(SYNONYM PLAN ;IDEA)
	(FLAGS NARTICLEBIT)>

<OBJECT REASON
	(DESC "reason")
	(SYNONYM REASON)>

<OBJECT SONAR-MAN
	(IN GLOBAL-OBJECTS)
	(DESC "sonar operator")
	(ADJECTIVE AQUADOME SONAR)
	(SYNONYM MAN OPERATOR)>

<OBJECT LAB-ASSISTANT
	(IN GLOBAL-OBJECTS)
	(DESC "lab assistant")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK LAB)
	(SYNONYM ASSISTANT)
	(ACTION LAB-ASSISTANT-F)>

<ROUTINE LAB-ASSISTANT-F ()
 <COND (<VERB? FIND WALK-TO>
	<DO-INSTEAD-OF ,LOWELL ,LAB-ASSISTANT>)>>

"? Delete this object and put following in local-globals?"
<OBJECT DOC-LABORATORY
	(IN GLOBAL-OBJECTS)
	(DESC "Doc's laboratory")
	(ADJECTIVE ;DOC DOC\'S ;WALT WALT\'S HORVAK)
	(SYNONYM LAB LABORATORY)
	(FLAGS NARTICLEBIT)
	(GENERIC GENERIC-LABORATORY-F)
	(ACTION DOC-LABORATORY-F)>

<ROUTINE DOC-LABORATORY-F ()
 <COND ;"(<OR ,SUB-IN-DOME ;<IN-DOME? ,HERE> <VERB? FIND>>
	<DO-INSTEAD-OF ,HERE ,DOC-LABORATORY>
	<RTRUE>)"
       (<VERB? WALK-TO THROUGH>
	<PERFORM ,V?WALK-TO ,DOME-LAB>
	<RTRUE>)>>

<OBJECT YOUR-LABORATORY
	(IN GLOBAL-OBJECTS)
	(DESC "your laboratory")
	(ADJECTIVE MY ;YOUR ;PRIVATELY RESEARCH $LN FROBTON)
	(SYNONYM LAB LABORATORY)
	(FLAGS NARTICLEBIT)
	(GENERIC GENERIC-LABORATORY-F)
	(ACTION YOUR-LABORATORY-F)>

<ROUTINE YOUR-LABORATORY-F ()
 <COND (<OR <IN-LAB? ,HERE> ;",SUB-IN-TANK <VERB? FIND>">
	<DO-INSTEAD-OF ,HERE ,YOUR-LABORATORY>
	<RTRUE>)
       (<VERB? WALK-TO THROUGH>
	<PERFORM ,V?WALK-TO ,CENTER-OF-LAB>
	<RTRUE>)>>

<ROUTINE GENERIC-LABORATORY-F (OBJ)
 <COND (,SUB-IN-TANK ;<IN-LAB-AREA? ,HERE> ,YOUR-LABORATORY)
       (,SUB-IN-DOME ;<IN-DOME? ,HERE> ,DOME-LAB)>>

<OBJECT JOB
	(IN GLOBAL-OBJECTS)
	(DESC "job")
	(ADJECTIVE SOME)
	(SYNONYM JOB WORK CHORE)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<OBJECT TRAITOR
	(DESC "traitor")
	;(IN GLOBAL-OBJECTS)
	(SYNONYM TRAITOR)
	(ACTION TRAITOR-F)>

<ROUTINE TRAITOR-F ("AUX" X)
 <COND (<OR <AND <VERB? ASK-ABOUT> <FSET? ,PRSO ,PERSON>>
	    <VERB? FIND WHAT>>
	<SET X <OR ,QCONTEXT
		   <VERB? ASK-ABOUT>
		   ;<NOT <EQUAL? ,WINNER ,PLAYER>>>>
	<COND (.X <TELL "\"">)>
	<TELL "I guess you'll have to figure that out, " FN ".">
	<COND (.X <TELL "\"">)>
	<CRLF>)>>

<OBJECT CHAIR
	(IN LOCAL-GLOBALS)
	(DESC "chair")
	(SYNONYM CHAIR CHAIRS SEAT)
	(FLAGS NDESCBIT ;FURNITURE)
	(ACTION CHAIR-F)>

<ROUTINE CHAIR-F ()
 <COND (<VERB? SIT LOOK-UNDER CLIMB-ON CLIMB-DOWN>
	<TELL "That's just a waste of time." CR>)>>

<OBJECT UNDERWATER
	(IN GLOBAL-OBJECTS)
	(DESC "underwater")
	(SYNONYM UNDERWATER)
	(FLAGS NARTICLEBIT)
	(ACTION UNDERWATER-F)>

<ROUTINE UNDERWATER-F ()
 <COND (<VERB? WALK>
	<TELL "You must be in the " D ,SUB " to do that." CR>)>>

<OBJECT GAME
	(IN GLOBAL-OBJECTS)
	(DESC "SEASTALKER")
	(SYNONYM SEASTALKER GAME)
	(FLAGS NARTICLEBIT)
	(ACTION GAME-F)>

<ROUTINE GAME-F ()
 <COND (<VERB? EXAMINE PLAY READ>
	<SETG P-WON <>>
	<TELL "(You're doing it!)" CR>)>>

<OBJECT SOMETHING
	(IN GLOBAL-OBJECTS)
	(DESC "(something)")
	(SYNONYM \(SOMETHING\) )
	(ACTION SOMETHING-F)>

<ROUTINE SOMETHING-F ()
	<SETG P-WON <>>
	<TELL "(Type a real word instead of " D ,SOMETHING ".)" CR>>

"WARNING: object numbers for LEFT & RIGHT must not equal direction numbers!"

<OBJECT LEFT
	(IN GLOBAL-OBJECTS)
	(SYNONYM LEFT PORT P)
	(DESC "left")
	(ACTION LEFT-RIGHT-F)>

<OBJECT RIGHT
	(IN GLOBAL-OBJECTS)
	(SYNONYM RIGHT STARBOARD SB)
	(DESC "right")
	(ACTION LEFT-RIGHT-F)>

<ROUTINE LEFT-RIGHT-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-OUTSIDE>
	<COND (<EQUAL? ,HERE ,SUB>
	       <PERFORM ,PRSA ,SUB-WINDOW>)
	      (T <PERFORM ,PRSA ,WINDOW>)>
	<RTRUE>)
       (<VERB? TURN WALK>
	<V-WALK-AROUND>)>>

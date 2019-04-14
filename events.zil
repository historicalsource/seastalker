"EVENTS for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<ROUTINE I-ALARM-RINGING ()
 <COND (<IN-LAB? ,HERE> <TELL "The " D ,ALARM " continues to ring." CR>)>>

<ROUTINE GRAB-ATTENTION (X "OPTIONAL" (OBJ <>))
	<COND (<BAD-AIR?>	;"<FSET? ,BLY ,MUNGBIT>"
	       <RFALSE>)
	      (<FSET? .X ,BUSYBIT>
	       <TOO-BAD-BUT .X "busy">
	       <RFALSE>)
	      (<NOT <0? ,SNARK-ATTACK-COUNT>>
	       <DONT-KNOW .X .OBJ>
	       <RFALSE>)
	      (T
	       <RTRUE>)>>

<ROUTINE TELL-HINT (CARDNUM OBJ "OPTIONAL" (CR? T))
	<COND (.CR? <CRLF>)>
	<TELL
"(If you want a clue, find Infocard #" N </ .CARDNUM 10> " in your
" D ,GAME " package. Read hidden clue #" N <MOD .CARDNUM 10> " and put
\"" D .OBJ "\" in the blank space.)" CR>>

<ROUTINE I-LAMP-ON-SCOPE ()
 <COND (<GLOBAL-IN? ,VIDEOPHONE ,HERE>
	<COND (<AND ,ALARM-RINGING
		    <NOT <FSET? ,VIDEOPHONE ,ONBIT>>>
	       <ENABLE <QUEUE I-LAMP-ON-SCOPE 7>>
	       <TELL-HINT 82 ;1 ,VIDEOPHONE>)>)
       (,SUB-IN-TANK
	<ENABLE <QUEUE I-LAMP-ON-SCOPE 1>>
	<RFALSE>)>>

<ROUTINE I-SEND-SUB ()
 <COND (<AND <FSET? ,VIDEOPHONE ,ONBIT>
	     <NOT ,WOMAN-ON-SCREEN>>
	<TELL-HINT 81 ;2 ,LOCAL-SUB>)>>

<CONSTANT G-REACHED 1>

<GLOBAL TIP-FOLLOWS-YOU? T>
<GLOBAL OLD-HERE <>>

<ROUTINE TIP-FOLLOWS-YOU (RM)
 <COND (<NOT ,TIP-FOLLOWS-YOU?> <RFALSE>)
       (<AND <IN-LAB? .RM> <IN-LAB? ,OLD-HERE>>
	<RFALSE>)
       (<AND <IN-TANK-AREA? .RM> <IN-TANK-AREA? ,OLD-HERE>>
	<RFALSE>)
       (<EQUAL? .RM ,CRAWL-SPACE>
	<RFALSE>)
       (<NOT <==? ,OLD-HERE .RM>>
	<SETG OLD-HERE .RM>
	<COND (<IN? ,MICROPHONE ,TIP>
	       <MOVE ,MICROPHONE ,CENTER-OF-LAB>)
	      (<IN? ,MICROPHONE-DOME ,TIP>
	       <MOVE ,MICROPHONE-DOME ,COMM-BLDG>)>
	<COND (<NOT <EQUAL? .RM ,SUB <LOC ,TIP>>>
	       <FCLEAR ,TIP ,TOUCHBIT>)>
	<MOVE ,TIP .RM>)>>

;<ROUTINE DIR-FROM (HERE THERE "AUX" (P 0) L TBL O)
	 #DECL ((HERE THERE O) OBJECT (P L) FIX)
 <REPEAT ()
	 <COND (<0? <SET P <NEXTP .HERE .P>>>
		<RFALSE>)
	       (<EQUAL? .P ,P?IN ,P?OUT> T)
	       (<NOT <L? .P ,LOW-DIRECTION>>
		<SET TBL <GETPT .HERE .P>>
		<SET L <PTSIZE .TBL>>
		<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
			    <==? <GETB .TBL ,REXIT> .THERE>>
		       <RETURN .P>)>)>>>

<ROUTINE I-SHARON-GONE ("AUX" L)
	<COND (<OR ;<NOT ,BLY-TOLD-PROBLEM> <NOT ,MONSTER-GONE>>
	       <QUEUE I-SHARON-GONE 4>
	       <RFALSE>)>
	<SET L <META-LOC ,SHARON>>
	<REMOVE ,SHARON>
	<ROB ,SHARON ,GLOBAL-SHARON>
	<FCLEAR ,FILE-DRAWER ,NDESCBIT>
	<FCLEAR ,PAPERS ,NDESCBIT>
	<COND (<SHARON-PASSES-YOU? .L>
	       <SUDDENLY-SHARON .L>
	       <TELL "really must go now, "FN". I'll see you later.\"" CR>
	       <COND (<EQUAL? ,HERE ,OFFICE>
		      <TELL
"She leaves through the " D ,OFFICE-DOOR "." CR>)>
	       <RTRUE>)>>

<ROUTINE ROB (WHAT THIEF "AUX" N X)
	 <SET X <FIRST? .WHAT>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <MOVE .X .THIEF>
		 <FCLEAR .X ,TAKEBIT>
		 <SET X .N>>>

<ROUTINE SUDDENLY-SHARON (L)
	<TELL "|
Suddenly Sharon ">
	<COND (<NOT <EQUAL? .L ,HERE>> <TELL "passes by and says">)
	      (T <TELL "leaves, saying">)>
	<TELL ", \"I ">>

<ROUTINE I-SHARON-TO-HALLWAY ("AUX" L)
	<QUEUE I-SHARON-TO-HALLWAY 0>
	<SET L <META-LOC ,SHARON>>
	<MOVE ,SHARON ,HALLWAY>
	<COND (<SHARON-PASSES-YOU? .L>
	       <SUDDENLY-SHARON .L>
	       <TELL "must go back to my office now, "FN".\"" CR>)>
	<I-SHARON ,G-REACHED>>

<GLOBAL MONSTER-GONE <>>
<GLOBAL SHARON-BROKE-CIRCUIT <>>

<ROUTINE I-SHARON ("OPTIONAL" (GARG <>) "AUX" (L <LOC ,SHARON>))
 <COND (<==? .GARG ,G-REACHED>
	<COND (<==? .L ,HALLWAY>
	       <MOVE ,SHARON ,OFFICE>
	       <FSET ,SHARON ,NDESCBIT>
	       <FSET ,FILE-DRAWER ,NDESCBIT>
	       <FSET ,PAPERS ,NDESCBIT>
	       <COND (<FSET? ,VIDEOPHONE ,ONBIT>
		      <FCLEAR ,VIDEOPHONE ,ONBIT>
		      <FSET ,VIDEOPHONE ,MUNGBIT>
		      <PHONE-OFF>
		      ;"<FCLEAR ,CIRCUIT-BREAKER ,NDESCBIT>"
		      <SETG SHARON-BROKE-CIRCUIT T>
		      <FSET ,CIRCUIT-BREAKER ,MUNGBIT>
		      <FSET ,CIRCUIT-BREAKER ,OPENBIT>
		      ;<COND (,DEBUG<TELL"[circuit breaker just opened]" CR>)>
		      <SETG MONSTER-GONE T>
		      <COND (<IN-LAB? ,HERE>
			     <TELL CR
"Something's wrong! The picture vanished from your
" D ,VIDEOPHONE " screen, and the sound conked out!|
">
			     <TIP-SAYS>
			     <TELL
"That's strange! Maybe you should use the " D
,COMPUTESTOR ".\"" CR>)>
		      <SCORE-UPD -3>
		      <RTRUE>)>)>)>>

<ROUTINE TIP-SAYS ("OPTIONAL" (QUIET <>))
	<TELL "Tip s">
	<COND (<IN? ,TIP ,HERE> <TELL "ays">) (T <TELL "houts">)>
	<COND (.QUIET <TELL " quietly">)>
	<TELL ", \"">>

<GLOBAL BLY-PRIVATELY-COUNT 0>
<GLOBAL BLY-PRIVATELY-DELAY <>>

<ROUTINE NOT-NOW? ("OPTIONAL" (BLY? T))
 <COND (<AND .BLY? ,BLY-PRIVATELY-DELAY>
	<RTRUE>)
       (<OR <FSET? ,BLY ,MUNGBIT>
	    ,GREENUP-ESCAPE
	    <EQUAL? ,HERE ,CRAWL-SPACE ,SUB>>
	<RTRUE>)>>

<ROUTINE I-BLY-PRIVATELY ()
	<COND (<NOT <0? ,SNARK-ATTACK-COUNT>>
	       <RFALSE>)>
	<COND (<READY-FOR-SNARK?>
	       <RFALSE>)>
	<COND (,ZOE-MENTIONED-EVIDENCE
	       <RFALSE>)>
	<COND (<NOT-NOW?>
	       <SETG BLY-PRIVATELY-DELAY <>>
	       <QUEUE I-BLY-PRIVATELY 7 ;3>
	       <RFALSE>)>
	<SETG BLY-PRIVATELY-DELAY T>
	<MOVE ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
	<TELL CR "Suddenly " D ,BLY " ">
	<COND (<NOT <EQUAL? <META-LOC ,BLY> ,HERE>>
	       <MOVE ,BLY ,HERE>
	       <TELL "comes over and ">)>
	<COND (<0? ,BLY-PRIVATELY-COUNT> <TELL "say">)
	      (T <TELL "repeat">)>
	<TELL
"s, \"" FN ", can we discuss a " D ,PRIVATE-MATTER " now?\"">
	<INC BLY-PRIVATELY-COUNT>
	<COND (<NOT <YES?>> <QUEUE I-BLY-PRIVATELY 7 ;3> <RFALSE>)>
	<ASK-BLY-ABOUT-PRIVATE-MATTER>
	<RTRUE>>

<ROUTINE I-BLY-SAYS ("OPTIONAL" (ASKED? <>) "AUX" L)
 <COND (.ASKED?
	<QUEUE I-BLY-SAYS 0>)
       (<READY-FOR-SNARK?>
	<RFALSE>)
       (<NOT-NOW?>
	<SETG BLY-PRIVATELY-DELAY <>>
	<QUEUE I-BLY-SAYS 7 ;3>
	<RFALSE>)>
 <SETG BLY-PRIVATELY-DELAY T>
 <SET L <META-LOC ,BLY>>
 <COND (<OR .ASKED?
	    <AND <EQUAL? .L ,BLY-OFFICE>
		 <EQUAL? .L ,HERE>>>
	<COND (<NOT .ASKED?> <CRLF>)>
	<TELL
"\"" FN ",\" says Zoe, \"we could be in danger!
The Snark may attack again any time! Would you answer some questions?\"">
	<COND (<NOT <YES?>>
	       <COND (.ASKED? <RTRUE>)
		     (T <ENABLE <QUEUE I-BLY-SAYS 3>> <RFALSE>)>)>
	<TELL
"\"Can you use the " D ,SUB " to hunt the " D ,GLOBAL-SNARK
", instead of waiting for it to attack?\"">
	<COND (<YES?>
	       <TELL
"\"Do you wish to arm the " D ,SUB " for attacking?\"">
	       <COND (<YES?>
		      <TELL-HINT 73 ;22 ,CLAW <>>
		      <TELL-HINT 72 ;23 ,DART ;<>>
		      <COND (<NOT <==? ,HERE ,DOME-LAB>>
			     <TELL
"|
\"If you want to think it over, we should go to the " D ,DOME-LAB ". Shall we
go now?\"">
			     <COND (<YES?>
				    <TELL "\"Okay, let's go.\"|
|
">
				    <COND (<IN? ,BLACK-BOX ,BLY>
					   <MOVE ,BLACK-BOX ,HERE>)>
				    <SETG WINNER ,PLAYER>
				    <COND (<GOTO ,DOME-LAB>
					   <MOVE ,BLY ,DOME-LAB>)>)>)>)>)>
	<RFATAL>)
       (T
	<ENABLE <QUEUE I-BLY-SAYS 3>>
	<RFALSE>)>>

<GLOBAL TIP-SAYS-1 0>
<GLOBAL TIP-SAYS-2 0>

<ROUTINE I-TIP-SAYS ()
 <COND (<AND <==? ,TIP-SAYS-2 ,MAGAZINE> <FSET? ,MAGAZINE ,TOUCHBIT>>
	<RFALSE>)
       (<AND ,TIP-SAYS-1 <EQUAL? <META-LOC ,MAGAZINE> ,SUB ,CRAWL-SPACE>>
	<TELL-HINT ,TIP-SAYS-1 ,TIP-SAYS-2>)>>

<ROUTINE I-TIP-SONAR-PLAN ("AUX" P)
 <COND (<FSET? ,TIP ,BUSYBIT>
	<QUEUE I-TIP-SONAR-PLAN 3>
	<RFALSE>)
       (<OR <NOT <0? ,SNARK-ATTACK-COUNT>>
	    <READY-FOR-SNARK?>>
	<QUEUE I-TIP-SONAR-PLAN 0>
	<RFALSE>)>
 <SET P <FIND-FLAG ,HERE ,PERSON ,PLAYER>>
 <COND (<NOT .P> <TIP-COMES>)
       (<==? .P ,TIP>
	<REMOVE ,PLAYER>
	<SET P <FIND-FLAG ,HERE ,PERSON ,TIP>>
	<MOVE ,PLAYER ,HERE>
	<TIP-COMES .P>)
       (T
	<TIP-COMES T>)>>

<ROUTINE MIKE-1-F (OBJ "OPTIONAL" (FOO <>))
	 <COND (<NOT .FOO>
		<TELL "\"Is " D .OBJ " a suspect?\"">)
	       (T
		<TELL
"\"Do you think " D .OBJ " could be the " D ,TRAITOR "?\"" >)>>

<ROUTINE TIP-COMES ("OPTIONAL" (ALMOST <>))
	<COND (<OR ,SIEGEL-TESTED <FSET? ,SIEGEL ,BUSYBIT>>
	       <RFALSE>)
	      (<OR ,GREENUP-ESCAPE ,GREENUP-TRAPPED ,GREENUP-CUFFED>
	       <RFALSE>)
	      (<OR <EQUAL? ,HERE ,SUB ,CRAWL-SPACE> <FSET? ,TIP ,BUSYBIT>>
	       <QUEUE I-TIP-SONAR-PLAN 3>
	       <RFALSE>)
	      (.ALMOST
	       <MOVE ,TIP ,HERE>
	       <SET ALMOST <GET <INT I-TIP-SONAR-PLAN> 1>>
	       <COND (<OR <G? .ALMOST -1>
			  <EQUAL? <MOD <- 0 .ALMOST> 7> 2>> 
		      <TIP-SAYS T>
		      <TELL FN ", I'd like to talk with you alone.\"" CR>
		      <COND (<G? .ALMOST -1>
			     <QUEUE I-TIP-SONAR-PLAN -1>)>
		      <RTRUE>)
		     (T <RFALSE>)>)>
	<QUEUE I-TIP-SONAR-PLAN 0>
	<CRLF>
	<COND (<NOT ,BLACK-BOX-EXAMINED> <TELL-HINT 11 ;13 ,BLACK-BOX>)>
	<MOVE ,TIP ,HERE>
	<TIP-SAYS T>
	<TELL
FN ", did " D ,BLY " mention any troublemakers among the " D ,CREW "?\"">
	<COND (<YES?>
	       <TELL
"\"Do you suspect " D ,ANTRIM " or " D ,HORVAK " or " D ,SIEGEL "?\"">
	       <COND (<YES?>
		      <TELL "\"Marv maintains the "D ,SONAR-EQUIPMENT",\" ">
		      <TIP-SAYS>
		      <TELL
"and we'll
need it to warn us if the " D ,SNARK " comes back. Didn't Zoe say something is
wrong with it?\"">
		      <COND (<YES?>
			     <TELL
"\"" FN ", do you think someone tampered with it?\"">
			     <COND (<YES?>
				    <TELL
"\"Does Marv suspect you've discovered signs of tampering?\"">
				    <COND (<NOT <YES?>>
					   <THIS-IS-IT ,TIP-IDEA>
					   <TELL
"\"Then I have an idea how to trap Marv and find out if he's the " D ,TRAITOR
"!\"" CR>)>)>)>)>)>
	<RTRUE>>

<GLOBAL SIEGEL-TESTED <>>

<ROUTINE REACTION-MAY-BE (PER)
	<TELL D .PER
"'s reaction may be all you need to prove he's NOT the " D ,TRAITOR ".
But you'll have to decide for yourself." CR>>

<ROUTINE SIEGEL-BOX ()
	<TELL "It will modulate the sonar's ultrasonic pulses!\"" CR>>

<ROUTINE I-SIEGEL-REPORTS ()
	<COND (,DOME-AIR-BAD?
	       <ENABLE <QUEUE I-SIEGEL-REPORTS 3>>
	       <RFALSE>)>
	<FCLEAR ,SIEGEL ,BUSYBIT>
	<COND (<NOT <IN? ,SIEGEL ,COMM-BLDG>> <RFALSE>)>
	<MOVE-HERE-NOT-SUB ,SIEGEL>
	<COND (<NOT <IN? ,BLACK-BOX ,SONAR-EQUIPMENT>>
	       <TELL
"Suddenly " D ,SIEGEL " reports: \"The " D ,SONAR-EQUIPMENT " looks okay
to me, "FN".\"" CR>
	       <RTRUE>)>
	<COND (<EQUAL? ,HERE ,COMM-BLDG>
	       <TELL "Suddenly " D ,SIEGEL " turns to you">)
	      (T
	       <COND (<IN? ,TIP ,HERE>
		      <TIP-SAYS>
		      <TELL FN ", here comes Marv, and he looks excited!\"|
">)>
	       <TELL "Marv comes running up to you">)>
	<TELL " with the " D ,BLACK-BOX " and says: \"Look">
	<MOVE ,BLACK-BOX ,SIEGEL>
	<COND (,SIEGEL-TESTED
	       <TELL
"! I found the same " D ,BLACK-BOX" on the " D ,SONAR-EQUIPMENT " again!\""
CR>)
	      (T
	       <SETG SIEGEL-TESTED T>
	       <TELL
" what I found attached to the " D ,SONAR-EQUIPMENT ", " FN "! ">
	       <SIEGEL-BOX>
	       <COND (<IN? ,TIP ,HERE>
		      <TIP-FLASHES>
		      <REACTION-MAY-BE ,SIEGEL>
		      <TELL
"|
Tip snaps his fingers and says: \"" FN "! Didn't that article in the "
D ,MAGAZINE "
say " D ,THORPE "'s synthetic sea creatures reacted to ultrasonic pulses in
a special way?\"">
		      <ENABLE <QUEUE I-TIP-PRIVATELY 1>>
		      <COND (<YES?> <TELL "\"That's what I thought.\"" CR>)
			    (T <TELL
"\"I think you should check that.\"" CR>)>)>)>
	<RTRUE>>

<GLOBAL RECONSIDER? "\"I think you should reconsider.">

<ROUTINE I-TIP-PRIVATELY ()
	<COND (<OR <READY-FOR-SNARK?>
		   ,ANTRIM-CHECKED-SUB>
	       <QUEUE I-TIP-PRIVATELY 0>
	       <RFALSE>)
	      (<FSET? ,TIP ,BUSYBIT>
	       <ENABLE <QUEUE I-TIP-PRIVATELY 3>>
	       <RFALSE>)>
	<MOVE ,TIP ,HERE>
	<TELL
CR "Tip draws you aside. \"Could I speak to you privately, " FN "?\"">
	<COND (<NOT <YES?>> <ENABLE <QUEUE I-TIP-PRIVATELY 3>> <RFALSE>)>
	<TELL
"\"The Snark could be a synthetic monster created by " D ,THORPE "!\" he
says when you're alone. \"I read about them in that " D ,MAGAZINE ". If I'm
right, whoever attached the " D ,BLACK-BOX " to the " D ,SONAR-EQUIPMENT
" could be working for Thorpe! That way the " D ,GLOBAL-SNARK
" would be lured into attacking the " D ,AQUADOME
"! Do you agree, " FN "?\"">
	<COND (<NOT <YES?>>
	       <TELL ,RECONSIDER? "\"" CR>)>
	<MIKE-1-F ,ANTRIM T>
	<COND (<NOT <YES?>>
	       <TELL ,RECONSIDER? " In fact ">)
	      (T <TELL "\"Then ">)>
	<TELL "why not test him">
	<COND (,SIEGEL-TESTED
	       <TELL ", since you tested " D ,SIEGEL>)>
	<TELL
"?\" Tip
asks. \"Mick is a laser expert in charge of maintenance on subs at the " D
,AQUADOME ".\"" CR>
	<COND (<IN? ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
	       <TELL-HINT 12 ;19 ,OVERHEATING <>>
	       <COND (,REGULATOR-MSG-SEEN
		      <TELL-HINT 43 ;20 ,ANTRIM <>>)>)>
	<TELL-HINT 22 ;21 ,ANTRIM <>>>

<GLOBAL BLY-HEARD-ANTRIM <>>
<ROUTINE I-ANTRIM-TO-SUB ("OPTIONAL" (STR <>))
	<COND (<READY-FOR-SNARK?>
	       <RFALSE>)
	      (,ANTRIM-CHECKED-SUB <RFALSE>)
	      (.STR T)
	      (<NOT-NOW? <>>
	       <QUEUE I-ANTRIM-TO-SUB 3>
	       <RFALSE>)>
	<COND (<FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>
	       <ENABLE <QUEUE I-ANTRIM-REPORTS 9>>)
	      (T
	       <ENABLE <QUEUE I-ANTRIM-REPORTS 19>>)>
	<SETG ANTRIM-CHECKED-SUB T>
	<COND (<IN? ,BLY ,HERE> <SETG BLY-HEARD-ANTRIM T>)>
	<FSET ,ANTRIM ,BUSYBIT>
	<COND (.STR <TELL .STR>)
	      (T
	       <TELL "|
Suddenly " D ,ANTRIM>
	       <COND (<NOT <IN? ,ANTRIM ,HERE>> <TELL " appears and">)>
	       <TELL
" says, \"I'm going to check out your new " D ,SUB ", ">)>
	<TELL FN "!\" Mick turns and ">
	<MOVE ,ANTRIM ,CRAWL-SPACE>
	<FSET ,ENGINE-ACCESS-HATCH ,OPENBIT>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
	       <TELL "goes to work." CR>)
	      (<EQUAL? ,HERE ,AIRLOCK>
	       <TELL "climbs aboard the " D ,SUB "." CR>)
	      (T
	       ;"<MOVE ,ANTRIM ,AIRLOCK>"
	       <TELL "hurries toward the " D ,AIRLOCK "." CR>)>>

<GLOBAL  TIP-FLASHED <>>
<ROUTINE TIP-FLASHES ()
	<COND (<NOT <IN? ,TIP ,HERE>> <RFALSE>)>
	<COND (,TIP-FLASHED <TELL "Once again ">)>
	<SETG TIP-FLASHED T>
	<TELL "Tip flashes you a meaningful glance. ">>

<ROUTINE I-ANTRIM-REPORTS ()
	;<COND (,DEBUG <TELL "[time for Mick to report?]" CR>)>
	<COND (<OR ,DOME-AIR-BAD?
		   ;"<EQUAL? ,HERE ,SUB ,CRAWL-SPACE ,AIRLOCK>">
	       <QUEUE I-ANTRIM-REPORTS 3>
	       <RFALSE>)>
	<FCLEAR ,ANTRIM ,BUSYBIT>
	<MOVE-HERE-NOT-SUB ,ANTRIM>
	<CRLF>
	<COND (,ASKED-ANTRIM
	       <TELL D ,ANTRIM " reports back ">
	       <COND (<EQUAL? ,HERE ,SUB ,AIRLOCK> <TELL "to you">)
		     (T <TELL "from the " D ,AIRLOCK>)>
	       <COND (<FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>
		      <TELL ".|
\"I think I found your " D ,OVERHEATING " problem. The " D
,VOLTAGE-REGULATOR " was making the lasers overcharge.|
I've adjusted it, but I could replace it. Want me to?\"">
		      <COND (<YES?> <FCLEAR ,VOLTAGE-REGULATOR ,MUNGBIT>)>)
		     (T <TELL ", looking somewhat puzzled.|
\"" FN ", I ran the " D ,ENGINE " on full, but it didn't overheat.|
The " D ,VOLTAGE-REGULATOR " PROBABLY got out of adjustment and
overcharged the lasers, but it seems okay now. Just to be safe, I
installed a new " D ,VOLTAGE-REGULATOR ".|
">)>)
	      (T
	       <COND (<OR ,BLY-HEARD-ANTRIM
			  <EQUAL? ,HERE ,SUB ,BLY-OFFICE <LOC ,BLY>>>
		      <TELL "Suddenly ">)
		     (T
		      <MOVE-HERE-NOT-SUB ,BLY>
		      <TELL
D ,BLY " is approaching.|
\"" FN ", did you send " D ,ANTRIM " to work on the " D ,SUB "?\" she
asks. \"I was just ">
		      <COND (<NOT <EQUAL? ,HERE ,BLY-OFFICE>>
			     <TELL "in my office, ">)>
		      <TELL
"checking the " D ,STATION-MONITOR " to see what each of
the crew was doing, and I discovered Mick had gone to the " D ,AIRLOCK ".
When I saw him on the " D ,STATION-MONITOR ",
he had just come out of the " D ,SUB "'s hatch.|
Wait -- here he is now!\"|
">)>
	       <TELL
"Mick appears and says, \"I thought maybe you had a problem on the way
here, " FN ", so I wanted to check on it. Everything seems to be okay
now.\"" CR>)>
	<TIP-FLASHES>
	<COND (<FSET? ,VOLTAGE-REGULATOR ,MUNGBIT>
	       <SETG TEST-BUTTON-READOUT ,TEST-BUTTON-NORMAL>
	       <TELL
"It now looks as though " D ,ANTRIM " can be eliminated as the " D ,TRAITOR ",
but you'll want to confirm this by pushing the " D ,TEST-BUTTON
" before you set out again in the " D ,SUB ".|
">)
	      (T <REACTION-MAY-BE ,ANTRIM>)>
	<FCLEAR ,VOLTAGE-REGULATOR ,MUNGBIT>
	<COND (<READY-FOR-SNARK?>
	       <RTRUE>)>
	<COND (<IN? ,ESCAPE-POD-UNIT ,SUB> <RTRUE>)>
	<TELL CR D ,ANTRIM
" turns away, then stops and says:|
\"" FN ", there's no " D ,ESCAPE-POD-UNIT "
under your seats in the " D ,SUB ". I hear you're planning a new type
of unit for the Ultramarine Bioceptor. But the standard unit will fit,
and we have one in the " D ,DOME-STORAGE ".|
Would you like one installed, just in case? " D ,GREENUP " and " D ,LOWELL
" could do it in a few minutes. Shall I tell 'em to?\"">
	<COND (<YES?>
	       <MOVE ,ANTRIM <META-LOC ,LOWELL>>
	       <INSTALL-ESCAPE-POD-UNIT ,ANTRIM>
	       <RTRUE>)>
	<TELL "\"I sure hope you don't need it.\"" CR>>

<ROUTINE INSTALL-ESCAPE-POD-UNIT (PER "AUX" (X <>))
	<TELL "\"Okay">
	<COND (<EQUAL? ,HERE <LOC ,LOWELL> <LOC ,GREENUP>>
	       <TELL ", we'll install it">)>
	<TELL ".\"" CR>
	<COND (<EQUAL? <LOC ,SYRINGE> ,LOWELL ,GREENUP ,ESCAPE-POD-UNIT>
	       <SET X T>)>
	<COND (<AND .X
		    <EQUAL? <LOC ,ESCAPE-POD-UNIT>
			    ,LOWELL ,GREENUP ,DOME-STORAGE>>
	       <SCORE-OBJ ,ESCAPE-POD-UNIT>
	       <MOVE ,GREENUP ,SUB ;",AIRLOCK">
	       <MOVE ,LOWELL ,SUB ;",AIRLOCK">
	       <FSET ,GREENUP ,BUSYBIT>
	       <FSET ,LOWELL ,BUSYBIT>
	       <MOVE ,ESCAPE-POD-UNIT ,LOWELL>
	       <MOVE ,SYRINGE ,GREENUP>
	       <FSET ,SYRINGE ,MUNGBIT>
	       <ENABLE <QUEUE I-LOWELL-REPORTS 12>>)
	      (T
	       <TELL "But ">
	       <HE-SHE-IT .PER>
	       <MOVE .PER ,HERE>
	       <TELL
" returns a moment later and says, \"We can't find the ">
	       <COND (.X <TELL D ,ESCAPE-POD-UNIT>) (T <TELL D ,SYRINGE>)>
	       <TELL ".\"" CR>)>>

<ROUTINE I-LOWELL-REPORTS ()
	<COND (<NOT-NOW? <>>
	       <QUEUE I-LOWELL-REPORTS 3>
	       <RFALSE>)>
	<MOVE ,ESCAPE-POD-UNIT ,SUB>
	<FCLEAR ,ESCAPE-POD-UNIT ,TAKEBIT>
	<FSET ,ESCAPE-POD-UNIT ,OPENBIT>
	<MOVE ,SYRINGE ,ESCAPE-POD-UNIT>
	<SETG TEST-BUTTON-READOUT ,TEST-BUTTON-POD>
	<MOVE ,GREENUP ,HERE>
	<MOVE ,LOWELL ,HERE>
	<FCLEAR ,GREENUP ,BUSYBIT>
	<FCLEAR ,LOWELL ,BUSYBIT>
	<TELL "|
Suddenly " D ,GREENUP " and " D ,LOWELL " report back from the ">
	<COND (<EQUAL? ,HERE ,AIRLOCK> <TELL D ,SUB>)
	      (T <TELL D ,AIRLOCK>)>
	<SAID-TO ,LOWELL>
	<TELL
".|
\"That " D ,ESCAPE-POD-UNIT " is in place, " FN ",\" says Amy. \"Bill
installed the part under your pilot's seat, and I installed the rest.\"" CR>>

<GLOBAL GREENUP-GUILT <>>
<ROUTINE I-ANALYSIS ()
	<FCLEAR ,HORVAK ,BUSYBIT>
	<FSET ,SYRINGE ,TAKEBIT>
	<COND (<MOVE-HERE-NOT-SUB ,HORVAK>
	       <CRLF>
	       <COND (<NOT <FSET? ,SYRINGE ,MUNGBIT>>
		      <TELL
"Suddenly " D ,HORVAK " appears. \"I couldn't find anything unusual
about the " D ,SYRINGE ".\"" CR>)
		     (T
		      <SETG GREENUP-GUILT T>
		      <TELL
D ,HORVAK "'s face is grim and pale as he reports the result of his
analysis.|
">
		      <PERFORM ,V?ASK-ABOUT ,HORVAK ,SYRINGE>
		      <COND (<IN? ,TIP ,HERE>
			     <TELL "|
Tip turns to you with a gasp. \"Holy smoke, " FN "! That's exactly what
would have happened once you warmed up the pilot's seat enough to
trigger the sensor relay!\"" CR>)>)>)
	      (T
	       <QUEUE I-ANALYSIS 2>
	       <RFALSE>)>>

<ROUTINE I-SYNTHESIS ()
	<FCLEAR ,HORVAK ,BUSYBIT>
	<MOVE ,DART ,HORVAK>
	<FCLEAR ,DART ,TRYTAKEBIT>
	<FSET ,DART ,TAKEBIT>
	<FCLEAR ,DART ,NDESCBIT>
	<FCLEAR ,DART ,MUNGBIT>	;"indicates dart fixed"
	<THIS-IS-IT ,DART>
	<SAID-TO ,HORVAK>
	<TELL "Doc Horvak ">
	<MOVE-HERE-NOT-SUB ,HORVAK "is now" "now comes rushing back,">
	<TELL " holding an aquatic dart gun. ">
	<COND (<NOT <IN? ,HORVAK ,HERE>> <TELL "He shouts from outside, ">)>
	<TELL "\"Okay, "
FN ", I've made a special 'trank' to use against an A.H.-type organism!
It's loaded in the dart gun. What shall I do with it?\"" CR>
	<SCORE-OBJ ,DART>
	<RTRUE>>

<ROUTINE MOVE-HERE-NOT-SUB (PER "OPTIONAL" (HERE-STR <>) (NOT-HERE-STR <>))
	<COND (<IN? .PER ,HERE>
	       <COND (.HERE-STR <TELL .HERE-STR>)>
	       <RTRUE>)>
	<COND (<AND ;"<NOT <FSET? ,AIRLOCK-ROOF ,OPENBIT>>"
		    <THROUGH-ROOF? <LOC .PER>>>
	       <FSET ,AIRLOCK-ROOF ,OPENBIT>)>
	<COND (<EQUAL? .PER ,SHARON>
	       <FCLEAR ,SHARON ,NDESCBIT>
	       <FCLEAR ,FILE-DRAWER ,NDESCBIT>
	       <FCLEAR ,PAPERS ,NDESCBIT>)>
	<COND (.NOT-HERE-STR <TELL .NOT-HERE-STR>)>
	<COND (<EQUAL? ,HERE ,CRAWL-SPACE ,SUB>
	       <COND (,SUB-IN-TANK <MOVE .PER ,NORTH-TANK-AREA>)
		     (T <MOVE .PER ,AIRLOCK>)>
	       <RFALSE>)
	      (T <MOVE .PER ,HERE>)>>

<ROUTINE I-GREENUP-ESCAPE ()
	<ENABLE <QUEUE I-GREENUP-ESCAPE -1>>
	<SETG GREENUP-ESCAPE <+ 1 ,GREENUP-ESCAPE>>
	<COND (<EQUAL? 3 ,GREENUP-ESCAPE>
	       <MOVE ,GREENUP ,AIRLOCK>
	       <TELL CR
"Greenup has reached the top of the wall and is climbing down the ladder
into the " D ,AIRLOCK ". In a moment he'll reach the floor
and head for the " D ,SUB "." CR>)
	      (<EQUAL? 4 ,GREENUP-ESCAPE>
	       <TELL CR
"Greenup is scrambling aboard the " D ,SUB ". Tip groans.
\"There's no way to stop him now, " FN "! All he has to do is
open the " D ,AIRLOCK-HATCH " and shove off!\"" CR>
	       <TELL-HINT 52 ;14 ,AIRLOCK-ELECTRICITY <>>
	       <RTRUE>)
	      (<EQUAL? 9 ,GREENUP-ESCAPE>
	       <FCLEAR ,AIRLOCK-ROOF ,OPENBIT>
	       <FSET ,AIRLOCK-HATCH ,OPENBIT>
	       <SETG AIRLOCK-FULL T>
	       <QUEUE I-SNARK-ATTACKS 1>
	       <TELL
"|
Better not raise any false hopes. As the " D ,SUB " glides out,
a pall of gloom settles over the " D ,AQUADOME ". All
hands sense that there's little hope, that Greenup has
scuttled their last chance of fighting off another attack by the " D ,GLOBAL-SNARK ".|
A " D ,VIDEOPHONE " call to " D ,IU-GLOBAL " confirms that no other subs are
available for a rescue expedition, even if there were time. And a
general S.O.S. to any craft in the vicinity isn't answered.">
	       <FINISH>)>
	<RFALSE>>

<ROUTINE GREENUP-CUFF ()
	<SETG GREENUP-ESCAPE 0>
	<SETG GREENUP-TRAPPED <>>
	<QUEUE I-GREENUP-ESCAPE 0>
	<MOVE ,GREENUP ,GALLEY>
	<FSET ,GREENUP ,MUNGBIT>
	<SETG GREENUP-CUFFED T>
	<TELL
"Knowing he's trapped, " D ,GREENUP " gives up without a fight. " D ,BLY
" orders him handcuffed to a pipe in the " D ,GALLEY "." CR>
	<SCORE-OBJ ,GLOBAL-GREENUP>
	<RTRUE>>

<ROUTINE I-POISON-JAB ()
 <COND (<AND <EQUAL? ,HERE ,SUB>
	     <IN? ,ESCAPE-POD-UNIT ,SUB>
	     <FSET? ,SYRINGE ,MUNGBIT>
	     <IN? ,SYRINGE ,ESCAPE-POD-UNIT>>
	<TELL CR
"A sudden jab in your right buttock makes you realize that the "
D ,SYRINGE " in the " D ,ESCAPE-POD-UNIT " has been activated, even though
no alarm sounded.|
You realize that the " D ,SYRINGE " did NOT contain a stimulant.
Instead of feeling more alert, you're already feeling doomed.|
The truth is that you have been fatally poisoned, and the promising
career of a brilliant young inventor will be cut short.|
An investigation into your death would reveal that the " D ,ESCAPE-POD-UNIT
" under your seat had been tampered with.|
A body-heat sensor had been substituted for the electronic
monitor, and a wire was connected from the sensor to the "
D ,SYRINGE ". The stimulant in the "
D ,SYRINGE " had been replaced with arsenic stolen from the "
D ,CHEMICAL-SUPPLY-SHELVES " of the " D ,DOME-LAB ".|
As soon as you heated up your pilot's seat, the sensor
triggered the " D ,SYRINGE ", and it injected you with the poison.|
Most regrettable!">
	<FINISH>)>>

<ROUTINE I-TIP-REPORTS ("AUX" B D)
	<COND (<OR <FSET? ,BLY ,MUNGBIT>
		   ;"<EQUAL? ,HERE ,CRAWL-SPACE ,SUB>">
	       <QUEUE I-TIP-REPORTS 3>
	       <RFALSE>)>
	<COND (<EQUAL? ,HERE ,CRAWL-SPACE> <MOVE ,TIP ,SUB>)
	      (T <MOVE ,TIP ,HERE>)>
	<FCLEAR ,TIP ,BUSYBIT>
	<SETG TIP-FOLLOWS-YOU? T>
	<SETG FINE-SONAR T>
	<MOVE ,FINE-GRID ,SUB>
	<FCLEAR ,FINE-GRID ,TAKEBIT>
	<TIP-SAYS>
	<TELL
"All set, "FN"! The " D ,FINE-GRID
" is installed on both the " D ,SONARSCOPE " and the " D ,THROTTLE>
	<SET B <==? ,BAZOOKA <GET ,ON-SUB 0>>>
	<SET D <==? ,DART <GET ,ON-SUB 1>>>
	<COND (<OR .B .D>
	       <TELL " -- and so ">
	       <COND (<AND .B .D> <TELL "are">)
		     (T <TELL "is">)>
	       <COND (.D <TELL " the " D ,DART>)>
	       <COND (<AND .B .D> <TELL " and">)>
	       <COND (.B <TELL " the " D ,BAZOOKA>)>)>
	<TELL "! Let's shove off and find the " D ,GLOBAL-SNARK "!\"" CR>>

<GLOBAL SNARK-ATTACK-COUNT 0>

<ROUTINE USE-FEWER-TURNS ()
	<TELL "|
|
(You'll probably do better if you restart and use fewer turns next time.)">>

<ROUTINE I-SNARK-ATTACKS ()
 <COND (<0? ,SNARK-ATTACK-COUNT>
	<COND (<NOT ,SUB-IN-DOME>
	       <COND (<OR <==? ,JOYSTICK-DIR ,P?SE>
			  <AND <NOT <L? ,SONAR-RANGE <ABS ,SUB-LON>>>
			       <NOT <L? ,SONAR-RANGE <ABS ,SUB-LAT>>>>>
		      <QUEUE I-SNARK-ATTACKS 3>
		      <RFALSE>)>
	       <TELL "A call comes on the ">	;"[more?]"
	       <COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE>
		      <TELL D ,SONARPHONE>)
		     (T <TELL D ,VIDEOPHONE>)>
	       <TELL
" from the " D ,AQUADOME": the " D ,GLOBAL-SNARK
" is attacking and destroying it! You're too late!">
	       <USE-FEWER-TURNS>
	       <FINISH>)
	      (T <ENABLE <QUEUE I-SNARK-ATTACKS -1>>)>)>
 <INC SNARK-ATTACK-COUNT>
 <COND (<==? 1 ,SNARK-ATTACK-COUNT>
	<MOVE ,SIEGEL ,COMM-BLDG>
	<MOVE ,TIP ,HERE>
	<TELL
"|
Suddenly an alarm rings through the " D ,AQUADOME "! " D ,SIEGEL " yells
over the squawk box:|
\"Now hear this! Two blips have appeared on the " D ,SONAR-EQUIPMENT
"! No definite form, but they're large, and they're coming closer."
"\"|
">
	<COND (T ;"<IN? ,TIP ,HERE>"
	       <TIP-SAYS>
	       <TELL "One of them must be the " D ,GLOBAL-SNARK "!\" ">)>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE ,AIRLOCK>
	       <COND (<FSET? ,AIRLOCK-HATCH ,OPENBIT>
		      <FCLEAR ,AIRLOCK-HATCH ,OPENBIT>
		      <TELL
"The " D ,AIRLOCK-HATCH " closes in defense.">)>)
	      (T
	       <COND (<GLOBAL-IN? ,WINDOW ,HERE>
		      <TELL "\"Look out the ">)
		     (T <TELL "\"Let's find a ">)>
	       <TELL D ,WINDOW ", "FN"!\"">)>
	<CRLF>
	<RFATAL>)
       (<==? 2 ,SNARK-ATTACK-COUNT>
	<TELL
"|
Even as you try this, the undersea nightmare takes shape!|
\"Holy spaghetti! LOOK at that thing!\" cries Tip.|
A hideous creature, with bulblike eyes near its snout, rears out of the
murk, its tentacles flailing the " D ,GLOBAL-WATER "! In this moment of
terror, the " D ,GLOBAL-SNARK " seems as big as a house,
and it's just outside the " D ,AQUADOME "!" CR>
	<RFATAL>)
       (<==? 3 ,SNARK-ATTACK-COUNT>
	<TELL
"|
No more time for that! The " D ,SNARK " has flopped down on the " D
,AQUADOME "!
There's a sound like thunder as the plastic hemisphere cracks
under the impact! The crew's screams of fear are drowned by the roar of
the sea!|
The Atlantic Ocean is pouring into the " D ,AQUADOME "! And
your last thought, before a zillion tons of " D ,GLOBAL-WATER " crushes you
to jelly, is
\"Oh gosh! I wonder if I shut off the Bunsen burner in the lab?\"">
	<USE-FEWER-TURNS>
	<FINISH>)>>

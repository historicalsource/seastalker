"VERBS for SEASTALKER
Copyright (C) 1984, 1985 Infocom, Inc.  All rights reserved."

<ROUTINE TRANSCRIPT (STR)
	<TELL "Here " .STR "s a transcript of interaction with" CR>>

<ROUTINE V-SCRIPT ()
	<COND (,SCREEN-NOW-SPLIT <SPLIT 0>)>	;"in case printer off"
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<TRANSCRIPT "begin">
	<V-VERSION>
	<START-SONAR?>				;"ditto"
	<RTRUE>>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT "end">
	<V-VERSION>
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE V-$VERIFY ()
	 <TELL "Verifying disk..." CR>
	 <COND (<VERIFY> <TELL "The disk is correct." CR>)
	       (T <TELL
"Oh, oh! The disk seems to have a defect. Try verifying again. (If
you've already done that, the disk surely has a defect.)" CR>)>>

<GLOBAL DEBUG <>>
<ROUTINE V-DEBUG ()
	 <COND (<SETG DEBUG <NOT ,DEBUG>>
		<TELL "Find them bugs, boss!" CR>)
	       (T <TELL "No bugs left, eh?" CR>)>>


"ZORK game commands"

"<CONSTANT DIFFICULTY-MAX 2>
<GLOBAL DIFFICULTY 0>"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE YOU-WILL-GET (STR)
	<TELL "(Okay, you will get " .STR " descriptions.)" CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <SETG P-SPACE 1>
	 <YOU-WILL-GET "brief">>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <SETG P-SPACE 0>
	 <YOU-WILL-GET "superbrief">>

<ROUTINE V-VERBOSE ()
	<SETG VERBOSE T>
	<SETG SUPER-BRIEF <>>
	<SETG P-SPACE 1>
	<YOU-WILL-GET "verbose">
	<V-LOOK>>

<GLOBAL P-SPACE 1>

<ROUTINE V-INVENTORY ()
	 <COND (,P-WHAT-IGNORED
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
		<TELL "You're the inventor!">
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
		<CRLF>)
	       (<NOT <PRINT-CONT ,WINNER>>
	        <COND (<EQUAL? ,WINNER ,PLAYER> <TELL "You're">)
		      (T <HE-SHE-IT ,WINNER T> <TELL "'s">)>
		<TELL " not holding anything." CR>)>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T))
	 <V-SCORE>
	 <COND (<OR <AND .ASK?
			 <TELL
"(If you want to continue from this point at another time, you must
\"SAVE\" first.)|
Do you want to stop playing now?">
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE>
	 <TELL
"Do you want to start over from the beginning?">
	 <COND (<YES?>
		<RESTART>
		<TELL ,FAILED CR>)>>

<GLOBAL FAILED
"(Sorry, but it didn't work. Maybe your instruction manual or Reference
Card can tell you why.)">

<ROUTINE V-SAVE ()
	 <COND (,SCREEN-NOW-SPLIT <SPLIT 0>)>
	 <COND (<SAVE>
	        <TELL "Okay." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL ,FAILED CR>)>
	 <START-SONAR?>
	 <RTRUE>>

<ROUTINE V-RESTORE ()
	 <COND (,SCREEN-NOW-SPLIT <SPLIT 0>)>
	 <COND (<NOT <RESTORE>>
		<TELL ,FAILED CR>
		<START-SONAR?>
		<RFALSE>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17) V)
	 <SET V <BAND <GET 0 1> *3777*>>
	 <TELL "SEASTALKER: ">
	 <PRINT-NAME ,FIRST-NAME T>
	 <PRINTC 32>
	 <PRINT-NAME ,LAST-NAME T>
	 <TELL
" AND THE ULTRAMARINE BIOCEPTOR|
Infocom interactive fiction - an adventure story|
Copyright (c) 1984, 1985 by Infocom, Inc.  All rights reserved.|
">
	 ;<COND (<NOT <==? <BAND <GETB 0 1> 8> 0>>
		<TELL"Licensed to Tandy Corporation. Version 00.00."N .V CR>)>
	 <TELL
"SEASTALKER is a registered trademark of Infocom, Inc.|
Release number " N .V " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<GLOBAL YES-INBUF <ITABLE BYTE 12>>
<GLOBAL YES-LEXV  <ITABLE BYTE 10>>

<ROUTINE YES? ("AUX" WORD VAL)
	<REPEAT ()
		<PRINTI " >">
		<READ ,YES-INBUF ,YES-LEXV>
		<SET WORD  <GET  ,YES-LEXV ,P-LEXSTART>>
		<COND (<0? <GETB ,YES-LEXV ,P-LEXWORDS>> T)
		      (<NOT <0? .WORD>>
		       <SET VAL <WT? .WORD ,PS?VERB ,P1?VERB>>
		       <COND (<EQUAL? .VAL ,ACT?YES>
			      <SET VAL T>
			      <RETURN>)
			     (<OR <EQUAL? .VAL ,ACT?NO>
				  <EQUAL? .WORD ,W?N>>
			      <SET VAL <>>
			      <RETURN>)>)>
		<TELL "(Please type YES or NO.)">>
	.VAL>

<ROUTINE YOU-CANT ("OPTIONAL" (STR <>) (WHILE <>) (STR1 <>))
	<COND (<==? ,WINNER ,PLAYER> <TELL "You">)
	      (T <HE-SHE-IT ,WINNER T>)>
	<TELL " can't " ;"There's no way to ">
	<COND (.STR <TELL .STR>) (T <VERB-PRINT>)>
	<COND (<EQUAL? .STR "go"> <TELL " in that direction." CR>)
	      (.STR1
	       <TELL " it while">
	       <COND (.WHILE
		      <THIS-IS-IT .WHILE>
		      <TELL THE .WHILE>)
		     (T <TELL " it">)>
	       <TELL " is " .STR1 "." CR>)
	      (T
	       <TELL THE-PRSO>
	       <TELL " now." CR>)>>

""

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV (NO-CR <>))
	 <THIS-IS-IT .OBJ>
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)>
	 <COND (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<COND (<FSET? .OBJ ,PERSON>
		       <COND (<AND <IS-CREW? .OBJ>
				   <CREW-5-TOGETHER?>
				   <NOT <FSET? ,BLY ,MUNGBIT>>>
			      <COND (<==? .OBJ ,LOWELL>
				     <TELL
"The five " D ,CREW " members are here.">)
				    (T <SET NO-CR T>)>)
			     (T <TELL D .OBJ " is here.">)>)
		      (T
		       <TELL "There's " A .OBJ " here.">)>)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<COND (<FSET? .OBJ ,PERSON>
		       <COND (<AND <IS-CREW? .OBJ>
				   <CREW-5-TOGETHER?>
				   <NOT <FSET? ,BLY ,MUNGBIT>>>
			      <COND (<==? .OBJ ,LOWELL>
				     <TELL
"the five " D ,CREW " members">)
				    (T <SET NO-CR T>)>)
			     (T <TELL D .OBJ>)>)
		      (T
		       <TELL A .OBJ>)>
		<COND (<AND <==? .OBJ ,OXYGEN-GEAR>
			    <IN? ,OXYGEN-GEAR ,PLAYER>>
		       <TELL " (being worn)">)>)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>>
		<TELL " (outside" THE .AV ")">)>
	 <COND (<NOT .NO-CR> <CRLF>)>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
 <COND (T ;,LIT
	<COND (<FIRST? ,HERE>
	       <PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>)>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? ;(F? <>) STR L)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<SET V? T>
		;<SET F? T>)>
	 <COND (<IN? ,HERE ,ROOMS>
		<TELL "(" D ,HERE ")" CR>)>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>> ;.V?
		;<SET L ,PLAYER-HIDING>
		<COND (<FSET? <SET L <LOC ,WINNER>> ,VEHBIT>
		       <TELL "(You're ">
		       <COND (<FSET? .L ,SURFACEBIT>
			      <TELL "sitting o">)
			     (T <TELL "standing i">)>
		       <TELL "n" THE .L ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <FSET ,HERE ,TOUCHBIT>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?FDESC>>>
		       <TELL .STR CR>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<NOT <==? ,HERE .L>>
		       <APPLY <GETP .L ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<GETP ,HERE ,P?CORRIDOR> <CORRIDOR-LOOK>)>
	 <FSET ,HERE ,TOUCHBIT>
	 T>

<ROUTINE FAR-AWAY? (L)
 <COND (<EQUAL? .L ,GLOBAL-OBJECTS> <RTRUE>)
       (<IN-LAB-AREA? ,HERE> <NOT <IN-LAB-AREA? .L>>)
       (<IN-DOME? ,HERE> <NOT <IN-DOME? .L>>)
       (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE> <NOT <EQUAL? .L ,SUB ,CRAWL-SPACE>>)
       (T <TELL "[Foo! Where is HERE?]" CR>)>>

"Lengths:"
<CONSTANT UEXIT 1> "Uncondl EXIT:(dir TO rm)		 = rm"
<CONSTANT NEXIT 2> "Non EXIT:	(dir string)		 = str-ing"
<CONSTANT FEXIT 3> "Fcnl EXIT:  (dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT 4> "Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT 5> "Door EXIT: (dir TO rm IF dr IS OPEN) = rm, dr, str-ing, 0"

<CONSTANT REXIT 0>
<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>	"GETB"
<CONSTANT CEXITSTR 1>	"GET"
<CONSTANT DEXITOBJ 1>	"GETB"
<CONSTANT DEXITSTR 1>	"GET"

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,PLAYER>
		<TELL "You're holding:" CR>)
	       (<FSET? .OBJ ,PERSON>
		<TELL D .OBJ " is holding:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL "Sitting on" THE .OBJ " is:" CR>)
		      (ELSE
		       <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>> <TELL "The ">)>
		       <TELL D .OBJ " contains:" CR>)>)>>

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE HAR-HAR () <TELL <PICK-ONE ,YUKS> CR>>

<ROUTINE HE-SHE-IT (OBJ "OPTIONAL" (CAP <>) (VERB <>))
	<COND (<FSET? .OBJ ,PERSON>
	       <COND (<==? .OBJ ,PLAYER>
		      <COND (.CAP <TELL "You">) (T <TELL "you">)>)
		     (<FSET? .OBJ ,FEMALE>
		      <COND (.CAP <TELL "She">) (T <TELL "she">)>)
		     (T
		      <COND (.CAP <TELL "He">) (T <TELL "he">)>)>)
	      (T
	       <COND (.CAP <TELL "It">) (T <TELL "it">)>)>
	<COND (.VERB
	       <PRINTC 32>
	       <COND (<EQUAL? .VERB "is">
		      <COND (<NOT <==? .OBJ ,PLAYER>> <TELL "is">)
			    (T <TELL "are">)>)
		     (T
		      <TELL .VERB>
		      <COND (<NOT <==? .OBJ ,PLAYER>> <TELL "s">)>)>)>>

<ROUTINE HIM-HER-IT (OBJ "OPTIONAL" (CAP <>) (POSSESS? <>))
	<COND (<FSET? .OBJ ,PERSON>
	       <COND (<==? .OBJ ,PLAYER>
		      <COND (.CAP <TELL "You">) (T <TELL "you">)>
		      <COND (.POSSESS? <TELL "r">)>)
		     (<FSET? .OBJ ,FEMALE>
		      <COND (.CAP <TELL "Her">) (T <TELL "her">)>)
		     (T
		      <COND (.POSSESS?
			     <COND (.CAP <TELL "His">) (T <TELL "his">)>)
			    (T
			     <COND (.CAP <TELL "Him">) (T <TELL "him">)>)>)>)
	      (T
	       <COND (.CAP <TELL "It">) (T <TELL "it">)>
	       <COND (.POSSESS? <TELL "s">)>)>
	<RTRUE>>

<ROUTINE NOT-HOLDING? (OBJ)
	<COND (<AND <NOT <IN? .OBJ ,WINNER>>
		    <NOT <IN? <LOC .OBJ> ,WINNER>>>
	       <HE-SHE-IT ,WINNER T>
	       <COND (<EQUAL? ,WINNER ,PLAYER> <TELL "'re">)
		     (T <TELL "'s">)>
	       <TELL " not holding" THE .OBJ "." CR>)>>	       

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<EQUAL? <GET .TBL .CNT> .ITM>
			<COND (<EQUAL? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" L ITARM ILRM)
	<COND (<IN? ,WINNER .RM>
	       <HAR-HAR>
	       <RFALSE>)>
	<COND (<AND <AIR-ROOM? ,HERE>
		    <NOT <AIR-ROOM? .RM>>
		    <BAD-AIR?>>
	       <RFALSE>)>
	<COND (<AND <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		    <EQUAL? .RM ,DOME-LAB ,BLY-OFFICE>>
	       <TELL "You should wait for someone to invite you." CR>
	       <RFALSE>)>
	<SET L <LOC ,WINNER>>
	<COND (<AND ,SUB-IN-DOME
		    <NOT <FSET? ,AIRLOCK-ROOF ,OPENBIT>>
		    <THROUGH-ROOF? .RM .L>>
	       <THIS-IS-IT ,AIRLOCK-ROOF>
	       <TOO-BAD-BUT ,AIRLOCK-ROOF "closed">
	       <RFALSE>)>
	<COND (<EQUAL? ,WINNER ,PLAYER> <TIP-FOLLOWS-YOU .RM>)
	      (<FSET? ,WINNER ,MUNGBIT>
	       <TELL "\"I wish I could!\"" CR>
	       <RFALSE>)
	      (<OR <EQUAL? .RM ,CRAWL-SPACE>
		   <AND <EQUAL? .RM ,SUB>
			<NOT <EQUAL? ,WINNER ,TIP ,SHARON>>>>
	       <TELL "\"You belong in there, not I!\"" CR>
	       <RFALSE>)>
	<COND (<NOT ,SUB-IN-TANK> <OPEN-DOOR .L> <OPEN-DOOR .RM>)
	      (T
	       <SET ITARM <IN-TANK-AREA? .RM>>
	       <SET ILRM <IN-LAB? .RM>>
	       <COND (<IN-TANK-AREA? .L>
		      <COND (<NOT .ITARM>
			     <FSET ,SOUTH-DOORWAY ,OPENBIT>)>
		      <COND (<NOT .ILRM>
			     <FSET ,EAST-DOORWAY ,OPENBIT>)>
		      <COND (<EQUAL? .RM ,LAB-STORAGE>
			     <FSET ,STORAGE-DOOR ,OPENBIT>)>)
		     (<IN-LAB? .L>
		      <COND (.ITARM
			     <FSET ,SOUTH-DOORWAY ,OPENBIT>)
			    (T
			     <COND (<NOT .ILRM>
				    <FSET ,EAST-DOORWAY ,OPENBIT>)>
			     <COND (<EQUAL? .RM ,LAB-STORAGE>
				    <FSET ,STORAGE-DOOR ,OPENBIT>)>)>)
		     (<EQUAL? .L ,HALLWAY ,OFFICE>
		      <COND (.ITARM
			     <FSET ,EAST-DOORWAY ,OPENBIT>
			     <FSET ,SOUTH-DOORWAY ,OPENBIT>)>
		      <COND (.ILRM
			     <FSET ,EAST-DOORWAY ,OPENBIT>)>
		      <COND (<EQUAL? .RM ,LAB-STORAGE>
			     <FSET ,STORAGE-DOOR ,OPENBIT>)>)
		     (<EQUAL? .L ,LAB-STORAGE>
		      <COND (.ITARM
			     <FSET ,EAST-DOORWAY ,OPENBIT>
			     <FSET ,SOUTH-DOORWAY ,OPENBIT>)>
		      <COND (.ILRM
			     <FSET ,EAST-DOORWAY ,OPENBIT>)>
		      <COND (T
			     <FSET ,STORAGE-DOOR ,OPENBIT>)>)>)>
	<MOVE ,WINNER .RM>
	<COND (<EQUAL? ,WINNER ,SHARON>
	       <COND (<==? .RM ,OFFICE>
		      <FSET ,SHARON ,NDESCBIT>
		      <FSET ,FILE-DRAWER ,NDESCBIT>
		      <FSET ,PAPERS ,NDESCBIT>)
		     (T
		      <FCLEAR ,SHARON ,NDESCBIT>
		      <FCLEAR ,FILE-DRAWER ,NDESCBIT>
		      <FCLEAR ,PAPERS ,NDESCBIT>)>)>
	<SETG LIT T>
	<COND (<==? ,WINNER ,PLAYER>
	       <SETG HERE .RM>
	       <COND (.V? <V-FIRST-LOOK>)>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	       <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)
	      ;(T <TELL "\"Okay.\"" CR>)>
	<RTRUE>>

<ROUTINE OPEN-DOOR (RM "AUX" TBL DR)
	 <COND (<EQUAL? .RM ,OFFICE ,SUB> <RTRUE>)
	       (<==? .RM ,AIRLOCK>
		<FSET ,AIRLOCK-ROOF ,OPENBIT>)
	       (<AND <SET TBL <GETPT .RM ,P?GLOBAL>>
		     <SET DR <ZMEMQBIT ,DOORBIT .TBL <- <PTSIZE .TBL> 1>>>>
		<FSET .DR ,OPENBIT>)>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR THE-PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<PLTABLE
	 " doesn't help any."
	 " is a waste of time.">>

<ROUTINE HELD? (OBJ)
	 <REPEAT ()
		 <COND (<NOT <LOC .OBJ>> <RFALSE>)
		       (<EQUAL? <LOC .OBJ> ,ROOMS ,GLOBAL-OBJECTS> <RFALSE>)
		       (<IN? .OBJ ,WINNER> <RTRUE>)
		       (T <SET OBJ <LOC .OBJ>>)>>>

<ROUTINE IDROP ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<DOBJ? PLAYER> <TELL "You">)
		      (T <TELL D ,PRSO>)>
		<TELL " wouldn't enjoy that." CR>
		<RFALSE>)
	       (<NOT-HOLDING? ,PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TOO-BAD-BUT <LOC ,PRSO> "closed">
		<RFALSE>)
	       (T
		<MOVE ,PRSO ,HERE ;<LOC ,WINNER>>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<RTRUE>)>>

<GLOBAL INDENTS
	<PTABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL FUMBLE-NUMBER 7>
<GLOBAL FUMBLE-PROB 8>
<GLOBAL ITAKE-LOC <>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ TEMP)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB <YOU-CANT "take">)>
		;<COND (,DEBUG <TELL "[ITAKE:RFALSE]" CR>)>
		<RFALSE>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<SET OBJ <FIRST? ,WINNER>>
		;<SET OBJ <NEXT? .OBJ>>
		<TOO-BAD-BUT .OBJ>
		<TELL " slips from ">
		<HIM-HER-IT ,WINNER <> T>
		<TELL " arms while ">
		<HE-SHE-IT ,WINNER <> "is">
		<TELL " taking"
			THE-PRSO
			", and both tumble " <GROUND-DESC> "." CR>
		<MOVE .OBJ ,HERE>	;<PERFORM ,V?DROP .OBJ>
		<MOVE ,PRSO ,HERE>
		;<COND (,DEBUG <TELL "[ITAKE:RFATAL]" CR>)>
		<RFATAL>)
	       (T
		<SETG ITAKE-LOC <>>
		<SET OBJ <LOC ,PRSO>>
		<COND (<FSET? .OBJ ,PERSON>
		       <COND (.VB
			      <TELL D .OBJ " gives it to ">
			      <HIM-HER-IT ,WINNER>
			      <TELL ". ">)
			     (T <SETG ITAKE-LOC .OBJ>)>)>
		<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<COND (<==? ,WINNER ,PLAYER> <SCORE-OBJ ,PRSO>)>
		;<COND (,DEBUG <TELL "[ITAKE:RTRUE]" CR>)>
		<RTRUE>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE CHECK-DOOR (DR)
	<COND (<NOT <FSET? .DR ,NARTICLEBIT>> <TELL "The ">)>
	<TELL D .DR " is "
	      <COND (<FSET? .DR ,OPENBIT> "open") (T "closed")>
	      "." CR>>

<ROUTINE CHECK-ON-OFF ()
	<COND (<NOT <FSET? ,PRSO ,NARTICLEBIT>> <TELL "The ">)>
	<TELL D ,PRSO " is o"
	      <COND (<FSET? ,PRSO ,ONBIT> "n") (T "ff")>
	      "." CR>>

<ROUTINE NOT-HERE (OBJ)
	 <TELL "You can't see" THE .OBJ " here." CR>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV (STR <>) (PV? <>) (INV? <>) (VAL <>))
	#DECL ((OBJ) OBJECT (LEVEL) FIX)
 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RFALSE>)>
 <COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
	T)
       (ELSE <SET AV <>>)>
 <SET 1ST? T>
 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
	<SET INV? T>)
       (ELSE
	<REPEAT ()
	 <COND (<NOT .Y> <RETURN <NOT .1ST?>>)
	       (<==? .Y .AV> <SET PV? T>)
	       (<==? .Y ,WINNER>)
	       (<AND %<COND (<GASSIGNED? PREDGEN>'<NOT <FSET? .Y ,INVISIBLE>>)
			    (T '<OR <NOT <FSET? .Y ,INVISIBLE>>
				    <AND ,DEBUG <TELL "[invisible] ">>>)>
		     <NOT <FSET? .Y ,TOUCHBIT>>
		     <OR ;<APPLY <GETP .Y ,P?DESCFCN> ,M-OBJDESC>
			 <SET STR <GETP .Y ,P?FDESC>>>>
		<COND (<OR <NOT <FSET? .Y ,NDESCBIT>>
			   <AND ,DEBUG <TELL "[ndescbit] ">>>
		       <SET 1ST? <>>
		       <SET LEVEL 0>
		       <COND (.STR
			      <TELL .STR CR>
			      <SET STR <>>
			      <SET VAL T>
			      <THIS-IS-IT .Y>)>)>
		<COND (<AND <SEE-INSIDE? .Y>
			    <NOT <GETP <LOC .Y> ,P?DESCFCN>>
			    <FIRST? .Y>>
		       <COND (<PRINT-CONT .Y .V? 0> <SET VAL T>)>
		       ;<SET VAL <OR <PRINT-CONT .Y .V? 0>
				    .VAL>>)>)>
	 <SET Y <NEXT? .Y>>>)>
 <SET Y <FIRST? .OBJ>>
 <REPEAT ()
	 <COND (<NOT .Y>
		<COND (<AND .PV? .AV <FIRST? .AV>>
		       <COND (<PRINT-CONT .AV .V? .LEVEL> <SET VAL T>)>
		       ;<SET VAL <OR <PRINT-CONT .AV .V? .LEVEL>
				    .VAL>>)>
		<RETURN .VAL ;<NOT .1ST?>>)
	       (<EQUAL? .Y .AV ,PLAYER>)
	       (<AND %<COND (<GASSIGNED? PREDGEN>'<NOT <FSET? .Y ,INVISIBLE>>)
			    (T '<OR <NOT <FSET? .Y ,INVISIBLE>>
				    <AND ,DEBUG <TELL "[invisible] ">>>)>
		     <OR .INV?
			 <FSET? .Y ,TOUCHBIT>
			 <NOT <GETP .Y ,P?FDESC>>>>
		<COND (<OR <NOT <FSET? .Y ,NDESCBIT>>
			   <AND ,DEBUG <TELL "[ndescbit] ">>>
		       <COND (.1ST?
			      <COND (<FIRSTER .OBJ .LEVEL>
				     <COND (<L? .LEVEL 0> <SET LEVEL 0>)>)>
			      <SET LEVEL <+ 1 .LEVEL>>
			      <SET 1ST? <>>)>
		       <SET VAL T>
		       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
		      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
		       <COND (<PRINT-CONT .Y .V? .LEVEL> <SET VAL T>)>
		       ;<SET VAL <OR <PRINT-CONT .Y .V? .LEVEL>
				    .VAL>>)>)>
	 <SET Y <NEXT? .Y>>>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<COND (<FSET? .F ,PERSON>
			       <TELL D .F>)
			      (T
			       <TELL A .F>)>
			<THIS-IS-IT .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<GLOBAL QCONTEXT <>>
<GLOBAL QCONTEXT-ROOM <>>

<ROUTINE ROOM-CHECK ("AUX" P)
	 <SET P ,PRSO>
	 <COND (<AND <==? .P ,DOCKING-TANK> <==? ,HERE ,AIRLOCK>>
		<SET P ,HERE>)
	       ;(<AND <==? .P ,TEST-TANK> <IN-TANK-AREA? ,HERE>>
		<SET P ,HERE>)>
	 <COND (<IN? .P ,ROOMS>
		<COND (<EQUAL? .P ,HERE ;,GLOBAL-HERE>
		       <PERFORM ,PRSA ,GLOBAL-HERE ,PRSI>
		       <RTRUE>)
		      (<AND <==? .P ,AIRLOCK>
			    <GLOBAL-IN? ,FILL-TANK-BUTTON ,HERE>>
		       <RFALSE>)
		      (T
		       <TELL "You aren't in that place!" CR>
		       <RTRUE>)>)
	       (<OR <==? .P ,PSEUDO-OBJECT>
		    <EQUAL? <META-LOC .P>
			    ,HERE ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>>
		<RFALSE>)
	       (<NOT <CORRIDOR-LOOK .P>>
		<COND (<AND <FSET? .P ,PERSON> <IN? .P ,GLOBAL-OBJECTS>>
		       <SET P <GET ,CHARACTER-TABLE<GETP .P ,P?CHARACTER>>>
		       <COND (<NOT <CORRIDOR-LOOK .P>>
			      <NOT-HERE .P>)>)
		      (T <NOT-HERE .P>)>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT>
		  <FSET? .OBJ ,OPENBIT>
		  <FSET? .OBJ ,SURFACEBIT>>>>

<ROUTINE ARENT-TALKING ()
	<TELL "You aren't talking to anyone!" CR>>

<ROUTINE ALREADY (OBJ "OPTIONAL" (STR <>))
	<HE-SHE-IT .OBJ T "is">
	<TELL " already ">
	<COND (.STR <TELL .STR "!" CR>)>
	<RTRUE>>

<GLOBAL I-ASSUME "(I assume you mean:">

<ROUTINE NOT-CLEAR-WHOM ()
	<TELL "It's not clear whom you're talking to." CR>>

<ROUTINE OKAY ("OPTIONAL" (OBJ <>) (STR <>))
	<COND (<==? ,WINNER ,PLAYER>
	       <COND (<VERB? THROUGH WALK WALK-TO>
		      <RTRUE>)>)
	      (T <TELL "\"">)>
	<TELL "Okay">
	<COND (.OBJ
	       <TELL "," THE .OBJ>
	       <COND (.STR <TELL " is now " .STR>)>
	       <COND (<==? .STR "on">	<FSET .OBJ ,ONBIT>)
		     (<==? .STR "off">	<FCLEAR .OBJ ,ONBIT>)
		     (<==? .STR "open">	<FSET .OBJ ,OPENBIT>)
		     (<==? .STR "closed">	<FCLEAR .OBJ ,OPENBIT>)>)>
	<COND (<OR .STR <NOT .OBJ>>
	       <TELL ".">
	       <COND (<NOT <==? ,WINNER ,PLAYER>> <TELL "\"">)>
	       <CRLF>)>
	<RTRUE>>

<ROUTINE WONT-HELP-TO-TALK-TO (OBJ)
	<TELL "It won't help to talk to " A .OBJ "!" CR>>

<ROUTINE TOO-BAD-BUT (OBJ "OPTIONAL" (STR <>))
	<TELL "Too bad, but" THE .OBJ>
	<COND (.STR <TELL " is " .STR "." CR>)>
	<RTRUE>>

"<ROUTINE NOT-ACCESSIBLE? (OBJ)
 <COND (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS> <RFALSE>)
       (<VISIBLE? .OBJ> <RFALSE>)
       (T <RTRUE>)>>"

<ROUTINE VISIBLE? (OBJ "AUX" (L <LOC .OBJ>)) ;"can player SEE object"
	 <COND (<ACCESSIBLE? .OBJ> <RTRUE>)
	       (<CORRIDOR-LOOK .OBJ> <RTRUE>)
	       (<ZERO? .L> <RFALSE>)
	       (<VISIBLE? .L> <SEE-INSIDE? .L>)>>

<GLOBAL LAST-PSEUDO-LOC <>>

<ROUTINE ACCESSIBLE? (OBJ "AUX" (L <LOC .OBJ>)) ;"can player TOUCH object?"
	 ;"revised 5/2/84 by SEM and SWG"
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)	       
	       (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ ,HERE>>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE>
		<RTRUE>)
	       (<ACCESSIBLE? .L>
		<OR <FSET? .L ,PERSON> <FSET? .L ,OPENBIT>>)>>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<GLOBAL WHO-CARES
	<PLTABLE " doesn't appear interested"
		" doesn't care"
		" lets out a loud yawn"
		" seems to be growing impatient">>

<GLOBAL YUKS
	<PLTABLE "That's ridiculous!"
		"That's wacky!"
		"What a fruitcake!"
		"What a screwball!"
		"You're off your rocker!"
		"You're crazy in the head!"
		"You can't be serious!">>
""
"SUBTITLE REAL VERBS"

<ROUTINE V-ADJUST () <YOU-CANT ;"adjust">>

<ROUTINE PRE-SAIM ()
	<PERFORM ,V?AIM ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SAIM () <V-FOO>>

<ROUTINE PRE-AIM ()
 <COND (<IOBJ? LEFT RIGHT>
	<COND (<DOBJ? DART BAZOOKA>
	       <TELL "You can aim that only at an enemy." CR>)>)
       (<IOBJ? GLOBAL-SNARK>
	<COND (<0? ,SNARK-ATTACK-COUNT>
	       <TELL "You can't see the Snark!" CR>)>)
       (<IOBJ? THORPE-SUB GLOBAL-THORPE SNARK>
	<RFALSE>)
       (<DOBJ? JOYSTICK>
	<PERFORM ,V?MOVE-DIR ,PRSO ,PRSI>
	<RTRUE>)
       (T <TELL
"You can aim something only to the left (port) or right (starboard),
or at an enemy." CR>)>>

<ROUTINE V-AIM () <YOU-CANT ;"aim">>

<ROUTINE PRE-SANALYZE ()
	<PERFORM ,V?ANALYZE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SANALYZE () <V-FOO>>

<ROUTINE V-ANALYZE ()
 <COND (<FSET? ,PRSO ,PERSON> <TELL "How?" CR>)
       (<IN? ,COMPUTESTOR ,HERE>
	<PERFORM ,V?ASK-ABOUT ,COMPUTESTOR ,PRSO>
	<RTRUE>)
       (<FSET? ,PRSO ,ON?BIT> <CHECK-ON-OFF>)
       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
       (T <TELL "It looks normal." CR> ;<YOU-CANT "check">)>>

<ROUTINE V-ANSWER ()
	 <TELL "Nobody seems to be waiting for an answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<FSET? ,PRSO ,PERSON>
		<WAITING-FOR-YOU-TO-SPEAK>)
	       (T <YOU-CANT ;"answer">)>> 

<ROUTINE WAITING-FOR-YOU-TO-SPEAK ()
	<HE-SHE-IT ,PRSO T "seem">
	<TELL " to be waiting for you to speak." CR>>

<ROUTINE V-ARM ()
 <COND (<DOBJ? LOCAL-SUB GLOBAL-SUB>
	<TELL "How?" CR>)
       (T <YOU-CANT ;"arm">)>>

<ROUTINE PRE-ARREST ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSON>>
		    <AND ,PRSI <NOT <IOBJ? GLOBAL-SABOTAGE>>>>
		<TELL "What a detective! \"Quick! Arrest that " D ,PRSO>
		<COND (,PRSI <TELL " for " D ,PRSI>)>
		<TELL " before ">
		<HE-SHE-IT ,PRSO <> "escape">
		<TELL "!\"" CR>)
	       (<AND <NOT ,DOME-AIR-CRIME> <NOT ,GREENUP-GUILT>>
		<TELL "For what? You have no evidence of a crime yet." CR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<SETG PRSO <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>
		<RFALSE>)>>

<ROUTINE V-ARREST ()
 <COND (<DOBJ? GREENUP GLOBAL-GREENUP>
	<COND (<OR ,GREENUP-ESCAPE ,GREENUP-TRAPPED ,GREENUP-CUFFED>
	       <TELL "Once is enough!" CR>)
	      (<NOT ,GREENUP-GUILT>
	       <TELL "You don't have any evidence." CR>)
	      (<OR <NOT ,SUB-IN-DOME> ,AIRLOCK-FULL>
	       <TOO-BAD-BUT ,PRSO "too far away">
	       ;<TELL "He's too far away!" CR>)
	      (T
	       ;<FCLEAR ,STATION-MONITOR ,NDESCBIT>
	       <COND (<DOBJ? GLOBAL-GREENUP>
		      <TELL "You barely issue this order when">)
		     (T <TELL "Greenup turns and runs away. Then">)>
	       <REMOVE ,GREENUP>
	       <FSET ,GREENUP ,MUNGBIT>
	       <TELL
" a crew member reports seeing
Greenup running behind the dormitory. \"He's going to try to
escape in the " D ,SUB ", " FN "!\"|
" D ,BLY " adds: \"">
	       <COND (<NOT <EQUAL? ,HERE ,BLY-OFFICE>>
		      <TELL "Come to my office, " FN "! ">)>
	       <TELL
"We can see him on the "
D ,STATION-MONITOR "! The " D ,CONTROLS-OFFICE " is ">
	       <COND (<NOT <EQUAL? ,HERE ,BLY-OFFICE>>
		      <TELL "t">)>
	       <TELL "here, too!\"" CR>
	       <MOVE ,BLY ,BLY-OFFICE>
	       <SETG WINNER ,PLAYER>
	       <ENABLE <QUEUE I-GREENUP-ESCAPE 3>>
	       <COND (<OR <EQUAL? ,HERE ,BLY-OFFICE> <GOTO ,BLY-OFFICE>>
		      <SETG GREENUP-ESCAPE 1>
		      <SCORE-OBJ ,GREENUP>)>
	       <RTRUE>)>)
       (T <TELL
"You don't have enough evidence to arrest" THE-PRSO "." CR>)>>

<ROUTINE PRE-ASK () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK ()
 <COND (<AND ,P-CONT <FSET? ,PRSO ,PERSON>>
	<SETG WINNER ,PRSO>
	<SETG QCONTEXT ,PRSO>
	<SETG QCONTEXT-ROOM ,HERE>)
       (T <V-ASK-ABOUT>)>>

<ROUTINE PRE-ASK-ABOUT ("AUX" L)
	<SET L <META-LOC ,PRSO>>
	<COND (<AND <EQUAL? .L ,CENTER-OF-LAB>
		    <DOBJ? REMOTE-PERSON>
		    <NOT <FSET? ,MICROPHONE ,ONBIT>>>
	       <THIS-IS-IT ,MICROPHONE>
	       <TELL
"She can't hear you while your " D ,MICROPHONE " is off." CR>
	       <RTRUE>)
	      (<AND <DOBJ? COMPUTESTOR>
		    <NOT <FSET? ,COMPUTESTOR ,ONBIT>>>
	       <THIS-IS-IT ,COMPUTESTOR>
	       <TELL "The " D ,COMPUTESTOR " is off!" CR>
	       <RTRUE>)
	      (<EQUAL? .L ,HERE> <RFALSE>)
	      (<GLOBAL-IN? ,PRSO ,HERE> <RFALSE>)>
	<TELL "Sorry, but" THE-PRSO>
	<NOT-HERE-PERSON ,PRSO>
	<RTRUE>>

<ROUTINE V-ASK-ABOUT ()
	 <COND (<OR <==? ,PRSO ,PLAYER> <NOT <FSET? ,PRSO ,PERSON>>>
		<WONT-HELP-TO-TALK-TO ,PRSO>
		<RFATAL>)
	       (<VERB? ASK>
		<TELL "\"Ask me about something in particular, "FN".\"" CR>)
	       (T
		<TELL D ,PRSO " doesn't seem to know about that." CR>)>>

<ROUTINE PRE-ASK-CONTEXT-ABOUT ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<AND <IN? ,COMPUTESTOR ,HERE> <FSET? ,COMPUTESTOR ,ONBIT>>
	<PERFORM ,V?ASK-ABOUT ,COMPUTESTOR ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-ABOUT () <ARENT-TALKING>>

<ROUTINE PRE-ASK-FOR () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK-FOR ()
	 <COND (<AND <FSET? ,PRSO ,PERSON> <NOT <==? ,PRSO ,PLAYER>>>
		<TELL D ,PRSO>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL " hands you" THE-PRSI "." CR>
		       <MOVE ,PRSI ,WINNER>)
		      (T <TELL " doesn't have that." CR>)>)
	       (T <HAR-HAR>)>>

<ROUTINE PRE-ASK-CONTEXT-FOR ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-FOR ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	<PERFORM ,V?ASK-FOR .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-FOR () <ARENT-TALKING>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE PRE-BRING ()
 <COND (<NOT <EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>>
	<SETG P-WON <>>
	<TELL "(Sorry, but I don't understand.)" CR>)>>

<ROUTINE V-BRING () <V-TAKE> ;<YOU-CANT ;"bring">>

<ROUTINE PRE-SBRING ()
	<PERFORM ,V?BRING ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SBRING () <V-FOO>>

<ROUTINE V-BRUSH ()
	<TELL
"\"Cleanliness is next to Godliness,\" but here it's
next to Impossible." CR>>

"<ROUTINE V-CALL-LOSE ()
	<TELL '(I couldn't find a verb in that sentence!)' CR>>"

<ROUTINE V-$CALL ("AUX" PER ;(MOT <>))
	 <SET PER ,PRSO>
	 <COND (<==? .PER ,PLAYER>
		<WONT-HELP-TO-TALK-TO .PER>)
	       (<FSET? .PER ,PERSON>
		<COND (<NOT <==? ,PRSO ,REMOTE-PERSON>>
		       <SET PER <GET ,CHARACTER-TABLE
				     <GETP ,PRSO ,P?CHARACTER>>>)>
		;<COND (<IN-MOTION? .PER> <SET MOT T>)>
		<COND (<OR <==? <META-LOC .PER> ,HERE> <CORRIDOR-LOOK .PER>>
		       <COND (<GRAB-ATTENTION .PER>
			      ;<FSET .PER ,TOUCHBIT>
			      <TELL D .PER>
			      <TELL " is listening." CR>)
			     (T
			      <RTRUE>
			      ;<TELL " ignores you." CR>)>)
		      (T <NOT-HERE .PER>
			 ;<TELL "You don't see " D .PER " here." CR>)>)
	       (T <SETG P-WON <>> <MISSING-VERB>)>>

"<GLOBAL PERSON-ON-INTERCOM <>>
<GLOBAL PERSON-ON-PHONE <>>
<GLOBAL PERSON-ON-SONARPHONE <>>"

<ROUTINE PRE-PHONE ("AUX" P PP)
 <COND (<AND ,PRSI <IOBJ? MICROPHONE MICROPHONE-DOME>>
	<PERFORM ,PRSA ,PRSO ,VIDEOPHONE>
	<RTRUE>)
       (<AND ,PRSI <IOBJ? INTERCOM VIDEOPHONE SONARPHONE>>
	<COND (<EQUAL? ,REMOTE-PERSON-ON ,PRSI>
	       <TELL
"You're still on the line to " D ,REMOTE-PERSON "." CR>
	       <RTRUE>)
	      (<FSET? ,PRSI ,MUNGBIT>
	       <TELL "The " D ,PRSI "'s conked out!" CR>
	       <RTRUE>)
	      (<IOBJ? SONARPHONE> <RFALSE>)
	      (<NOT <GLOBAL-IN? ,PRSI ,HERE>>
	       <TELL "There's no " D ,PRSI " here." CR>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<AND ,PRSI ;<NOT <IOBJ? TELEPHONE>>>
	<COND ;(<IOBJ? GLOBAL-VIDEOPHONE>
	       <TELL "There's no " D ,VIDEOPHONE " within reach." CR>)
	      (T
	       <TOO-BAD-BUT ,PRSI "not wired for phoning">)>)
       (<AND <FSET? ,PRSO ,PERSON> <IN? ,PRSO ,HERE>>
	<BITE-YOU>)
       (<OR <DOBJ? PLAYER>
	    ;<AND <DOBJ? GLOBAL-TIP> <VISIBLE? ,TIP>>>
	<HAR-HAR>)
       (<AND <FSET? ,PRSO ,PERSON>
	     <SET P <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>
	     <NOT <FAR-AWAY? <META-LOC .P>>>>
	<COND (<OR <FSET? .P ,BUSYBIT> <FSET? .P ,MUNGBIT>>
	       <HE-SHE-IT .P T>
	       <TELL "'s busy right now." CR>
	       <RTRUE>)>
	<MOVE-HERE-NOT-SUB .P>
	<SAID-TO .P>
	<TELL "\"Right here, " FN ",\" ">
	<HE-SHE-IT .P>
	<COND (<==? ,HERE <LOC .P>>
	       <TELL " replies. \"What would you like me to do?\"" CR>)
	      (T <TELL " shouts. \"Come outside to talk!\"" CR>)>)
       (<NOT ,PRSI>
	<COND ;(<GLOBAL-IN? ,TELEPHONE ,HERE>
	       <PERFORM ,PRSA ,PRSO ,TELEPHONE>
	       <RTRUE>)
	      (<GLOBAL-IN? ,VIDEOPHONE ,HERE>
	       <PERFORM ,PRSA ,PRSO ,VIDEOPHONE>
	       <RTRUE>)
	      (<IN? ,SONARPHONE ,HERE>
	       <PERFORM ,PRSA ,PRSO ,SONARPHONE>
	       <RTRUE>)
	      (<GLOBAL-IN? ,INTERCOM ,HERE>
	       <PERFORM ,PRSA ,PRSO ,INTERCOM>
	       <RTRUE>)
	      (T <TELL "There's nothing to phone with here." CR>)>)>>

<ROUTINE V-PHONE ("AUX" PER)
 <COND (<AND <FSET? ,PRSO ,PERSON>
	     <SET PER <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>
	     <OR <==? <META-LOC .PER> ,HERE> <CORRIDOR-LOOK .PER>>>
	<PERFORM ,V?$CALL ,PRSO>
	<RTRUE>)
       (<NOT <==? -1 ,P-NUMBER>> ;<DOBJ? INTNUM>
	<TELL "There's no point in calling that number." CR>)
       ;(<DOBJ? TELEPHONE>
	<TELL "You didn't say whom to call." CR>)
       (<DOBJ? AQUADOME DOME-LAB YOUR-LABORATORY>
	<TELL "There's no answer." CR>)
       (<NOT <FSET? ,PRSO ,PERSON>>
	<TOO-BAD-BUT ,PRSO>
	<TELL " has no phone." CR>)
       (<EQUAL? <META-LOC ,PRSO> ,HERE>
	<BITE-YOU>)
       (T <TELL "There's no sense in phoning " D ,PRSO "." CR>)>>

;<ROUTINE V-CALL-FOR ()
 <COND (<NOT <GLOBAL-IN? ,TELEPHONE ,HERE> ;<PHONE-IN? ,HERE>>
	<TELL "There's no phone here." CR>)
       (<NOT ,PRSI> <YOU-CANT ;"call">)
       (T
	<TOO-BAD-BUT ,PRSO>
	<TELL " can't offer any " D ,PRSI "." CR>)>>

<ROUTINE V-BOARD ()
	<COND (<OR <IN? ,PRSO ,ROOMS> <FSET? ,PRSO ,DOORBIT>>
	       <V-THROUGH>)
	      (T <YOU-CANT "get in">)>>

<ROUTINE V-CLIMB-ON () <YOU-CANT "climb onto">>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<YOU-CANT "go">)
	       (<AND .OBJ
		     <ZMEMQ ,W?WALL
			    <SET X <GETPT ,PRSO ,P?SYNONYM>>
			    <- </ <PTSIZE .X> 2> 1>>>
		<TELL "Climbing the walls is no help." CR>)
	       (ELSE <HAR-HAR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<YOU-CANT ;"close">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND (<FSET? ,PRSO ,MUNGBIT>
			      <TELL
"It won't stay closed. The latch is broken." CR>)
			     (T
			      <OKAY ,PRSO "closed">)>)
		      (T <ALREADY ,PRSO "closed">)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <0? <GETP ,PRSO ,P?CAPACITY>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <OKAY ,PRSO "closed">)
		      (T <ALREADY ,PRSO "closed">)>)
	       (T <YOU-CANT ;"close">)>>

"<ROUTINE V-COME ('AUX' CN CHR COR PCOR L)
	 <COND (<==? ,PRSO ,PLAYER>
		<NOT-CLEAR-WHOM>)
	       (<==? ,HERE
		     <SET L <META-LOC
			     <SET CHR <GET ,CHARACTER-TABLE
				       <SET CN <GETP ,PRSO ,P?CHARACTER>>>>>>>
		<TELL 'You're in the same place as ' D ,PRSO '!' CR>)
	       (<OR <NOT .L> ;<==? .L ,LIMBO>>
		<TELL D ,PRSO ' has left the grounds.' CR>)
	       (<AND <SET COR <GETP ,HERE ,P?CORRIDOR>>
		     <SET PCOR <GETP .L ,P?CORRIDOR>>
		     <NOT <==? <BAND .COR .PCOR> 0>>>
		<SETG PRSO <COR-DIR ,HERE .L>>
		<V-WALK>)
	       (T
		<TELL 'You seem to have lost track of ' D ,PRSO '.' CR>)>>"

<ROUTINE PRE-COME-WITH ()
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

<ROUTINE V-COME-WITH () <V-FOO>>

<ROUTINE PRE-COMPARE ()
 <COND (<AND <NOT ,PRSI>
	     <==? 1 <GET ,P-PRSO 0>>>
	<TELL "Use the command: COMPARE IT TO " D ,SOMETHING "." CR>
	<RTRUE>)
       (<==? 2 <GET ,P-PRSO 0>>
	<PUT ,P-PRSO 0 1>
	<PERFORM ,PRSA <GET ,P-PRSO 1> <GET ,P-PRSO 2>>
	<RTRUE>)>>

<ROUTINE V-COMPARE ()
 <COND (<==? ,PRSO ,PRSI> <TELL "They're the same thing!" CR>)
       (T <TELL "They're not a bit alike." CR>)>>

<ROUTINE V-CONFRONT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<ARENT-TALKING>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"That ought to put a scare into" THE-PRSO "." CR>)
	       (T
		<TELL D ,PRSO <PICK-ONE ,WHO-CARES> "." CR>)>>

<ROUTINE V-CUT () <YOU-CANT ;"cut">>

<ROUTINE V-MUNG ()
	 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT ,PRSI>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL
"You'd fly through the open door if you tried." CR>)
		      (T <TELL "Why don't you just open it instead?" CR>)>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<YOU-CANT ;"destroy">)
	       (<NOT ,PRSI>
		<TELL "Trying to destroy " D ,PRSO
		      " with your bare hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "You can't destroy" THE-PRSO " with" THE-PRSI "." CR>)
	       (T <YOU-CANT ;"destroy">)>>

<ROUTINE V-DIAGNOSE ()
 <COND (,PRSO <YOU-CANT ;"diagnose">)
       ;(<AND ,DOME-AIR-BAD? <TROUBLE-BREATHING?>> <RTRUE>)
       (<FSET? ,ARM ,MUNGBIT>
	<TELL "Your arm is seriously gashed." CR>)
       (T <TELL "You're wide awake and in good health." CR>)>>

<ROUTINE PRE-DISCUSS ()
	<COND (<NOT ,PRSI> <SETG PRSI ,PLAYER>)>
	<PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-DISCUSS () <V-FOO>>

<ROUTINE V-DIVE ()
 <COND (<AND ,SUB-IN-TANK <WHY-NEED ,DEPTH-CONTROL ,TEST-TANK>>
	<RTRUE>)
       (<AND ,SUB-IN-DOME <WHY-NEED ,DEPTH-CONTROL ,AIRLOCK>>
	<RTRUE>)
       (<OR <EQUAL? ,PRSO <> ,ROOMS>
	    <DOBJ? GLOBAL-WATER BAY SEA>>
	<COND (<OR <0? ,SUB-DEPTH> <NOT ,PRSO>>
	       <DO-WALK ,P?DOWN>
	       <RTRUE>)
	      (T <TELL "You're already " D ,UNDERWATER "." CR>)>)
       (<FSET? ,PRSO ,UNITBIT>
	<PERFORM ,V?SET ,DEPTH-CONTROL ,PRSO>
	<RTRUE>)
       (T
	<TELL
"You can do this by setting the " D ,DEPTH-CONTROL " to the desired depth
of your dive." CR>)>>

"<ROUTINE V-DIVE-BY ()
 <COND (<FSET? ,PRSO ,UNITBIT>
	<SETG P-NUMBER <+ ,P-NUMBER ,SUB-DEPTH>>
	<PERFORM ,V?SET ,DEPTH-CONTROL ,PRSO>
	<RTRUE>)
       (T <V-DIVE>)>>"

<ROUTINE V-DOCK ()
	<COND (<DOBJ? ROOMS GLOBAL-SUB LOCAL-SUB>
	       <TELL "You can't dock the " D ,SUB " now." CR>)
	      (T <YOU-CANT ;"dock">)>>

<ROUTINE V-DRINK () <YOU-CANT ;"drink">>

<ROUTINE V-DROP ()
	 <COND ;(<ROOM-CHECK> <RTRUE>)
	       ;(<EQUAL? ,PRSO ,GLOBAL-HERE <META-LOC ,WINNER>>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<IDROP>
		<OKAY ,PRSO <GROUND-DESC>>)>>

<ROUTINE GROUND-DESC ()
	 <COND ;(<OUTSIDE? ,HERE> "ground.")
	       (<EQUAL? ,HERE ,SUB> "on the deck")
	       (T "on the floor")>>

<ROUTINE V-EAT () <YOU-CANT ;"eat">>

<ROUTINE V-EMPTY ()
	 <COND (<NOT ,PRSI>
		<PERFORM ,V?EMPTY ,PRSO ,GLOBAL-WATER>
		<RTRUE>)
	       (T <TELL
"You may know how to do that, but this program doesn't." CR>)>>

<ROUTINE V-ENTER ()
	<DO-WALK ,P?IN>
	<RTRUE>>

<ROUTINE PRE-THROUGH ()		;"WALK WITH => FOLLOW"
 <COND (<FSET? ,PRSO ,PERSON> <PERFORM ,V?FOLLOW ,PRSO> <RTRUE>)>>

<ROUTINE V-THROUGH ("OPTIONAL" (OBJ <>) "AUX" RM DIR)
	#DECL ((OBJ) <OR OBJECT FALSE>)
	<COND (<IN? ,PRSO ,ROOMS>
	       <PERFORM ,V?WALK-TO ,PRSO>
	       <RTRUE>)
	      (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	       <COND (<AND <SET RM <DOOR-ROOM ,HERE ,PRSO>>
			   <GOTO .RM>>
		      <OKAY>)
		     (T <TELL
"Sorry, but the \"" D ,PRSO "\" must be somewhere else." CR>)>)
	      (<AND <NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       <HE-SHE-IT ,WINNER T "bang">
	       <TELL
" into it trying to go through" THE-PRSO "." CR>)
	      (.OBJ <TELL "You can't do that!" CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "You must think you're a contortionist!" CR>)
	      (ELSE <HAR-HAR>)>>

<ROUTINE PRE-EXAMINE ("AUX" VAL)
	 <COND (<ROOM-CHECK> <RTRUE>)
	       (<==? ,P-ADVERB ,W?CAREFULLY>
		<COND (<NOT <SET VAL <INT-WAIT 3>>>
		       <TELL
"You never got to finish looking over" THE-PRSO "." CR>)
		      (<==? .VAL ,M-FATAL> <RTRUE>)>)>>

<ROUTINE V-EXAMINE ("AUX" TBL)
	 <COND (<DOBJ? INTDIR>
		<TELL "If you want to see what's there, go there!" CR>)
	       (<DOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
		<NOTHING-SPECIAL>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC ,PRSO> ,HERE ,LOCAL-GLOBALS>>
		<TOO-BAD-BUT ,PRSO "too far away">)
	       (<SET TBL <GETP ,PRSO ,P?TEXT>>
		<TELL .TBL CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    ;<FSET? ,PRSO ,DOORBIT>
		    ;<FSET? ,PRSO ,WINDOWBIT>>
		<V-LOOK-INSIDE>)
	       (<FSET? ,PRSO ,ON?BIT> <CHECK-ON-OFF>)
	       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
	       (T
		<NOTHING-SPECIAL>)>>

<ROUTINE NOTHING-SPECIAL ()
	<TELL "There's nothing special about" THE-PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TBL)
	 #DECL ((OBJ1 OBJ2) OBJECT (TBL) <OR FALSE TABLE>)
	 <COND (<SET TBL <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .TBL <- <PTSIZE .TBL> 1>>)>>

<ROUTINE PRE-FILL ()
 <COND (<AND ,PRSI <NOT <EQUAL? ,PRSI ,GLOBAL-WATER>>>
	<HAR-HAR>)>>

<ROUTINE V-FILL ()
	 <COND ;(<NOT ,PRSI>
		<PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>
		<RTRUE>)
	       (T <TELL
"You may know how to do that, but this program doesn't." CR>)>>

;<GLOBAL PRON-HIM "him">
;<GLOBAL PRON-HE "he">
;<GLOBAL PRON-HER "her">
;<GLOBAL PRON-SHE "she">

<ROUTINE PRE-FIND ("AUX" CHR)
	 <COND (<DOBJ? PLAYER> <RFALSE>)>
	 <COND (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <ALREADY ,PLAYER "here">)
		      (<FSET? ,PRSO ,TOUCHBIT>
		       <TELL "You should know - you've been there!" CR>)
		      (T
		       <TELL <GETP ,LOCAL-SUB ,P?TEXT> CR>;"Use your maps!")>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (<AND <==? ,PRSO ,REMOTE-PERSON> ,REMOTE-PERSON-REMLOC>
		       <HE-SHE-IT ,REMOTE-PERSON T>
		       <TELL "'s in the " D ,REMOTE-PERSON-REMLOC "." CR>
		       <RTRUE>)>
		<SET CHR <GETP ,PRSO ,P?CHARACTER>>
		<COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		       <SETG PRSO <GET ,CHARACTER-TABLE .CHR>>)>
		<COND (<OR <NOT <LOC ,PRSO>> <FAR-AWAY? <LOC ,PRSO>>>
		       <COND (<OR <DOBJ? BLY> <IS-CREW? ,PRSO>>
			      <HE-SHE-IT ,PRSO T>
			      <TELL "'s probably at the " D ,AQUADOME "." CR>
			      <RTRUE>)
			     (T
			      <TELL "Who knows where ">
			      <HE-SHE-IT ,PRSO>
			      <TELL " is now?" CR>
			      <RTRUE>)>)>
		<COND (<==? <META-LOC ,WINNER> <META-LOC ,PRSO>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <BITE-YOU>)
			     (T
			      <TELL "\"Ahem...\"" CR>)>
		       <RTRUE>)>
		<COND (<NOT <==? ,WINNER ,PLAYER>>
		       <TELL "\"I think ">
		       <HE-SHE-IT ,PRSO>)
		      (T <HE-SHE-IT ,PRSO T>)>
		<TELL "'s in" THE <META-LOC ,PRSO> ".">
		<COND (<NOT <==? ,WINNER ,PLAYER>> <TELL "\"">)>
		<CRLF>)>>

<ROUTINE BITE-YOU ()
	<TELL "If ">
	<HE-SHE-IT ,PRSO>
	<TELL " were any closer, ">
	<HE-SHE-IT ,PRSO>
	<TELL "'d bite you!" CR>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<NOT <==? ,PLAYER ,WINNER>> <TELL "\"">)>
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "You're right here, ">
		<COND (<FSET? .L ,SURFACEBIT> <TELL "on">)
		      (T <TELL "in">)>
		<TELL THE .L ".">)
	       (<IN? ,PRSO ,PLAYER>
		<TELL "You have it.">)
	       (<IN? ,PRSO ,WINNER>
		<TELL "\"I have it, " FN ".\"">)
	       (<OR <AND <EQUAL? .L ,LOCAL-GLOBALS> <GLOBAL-IN? ,PRSO ,HERE>>
		    <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>>
		<TELL "It's right here.">)
	       (<EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
		<TELL "It's around somewhere.">)
	       (<FAR-AWAY? <META-LOC ,PRSO>>
		<TELL "It's far away from here.">)
	       (<FSET? .L ,PERSON>
		<TELL D .L " has it.">)
	       (<FSET? .L ,SURFACEBIT>
		<TELL "It's on" THE .L ".">)
	       (<OR <FSET? .L ,CONTBIT>
		    <IN? .L ,ROOMS>>
		<TELL "It's in" THE .L ".">)
	       (ELSE
		<TELL "It's nowhere in particular.">)>
	<COND (<NOT <==? ,PLAYER ,WINNER>> <TELL "\"">)>
	<CRLF>>

<ROUTINE V-FIND-WITH () <V-FIND>>

<ROUTINE V-FIX () <MORE-SPECIFIC>>

<ROUTINE V-FOLLOW ("AUX" CN CHR COR PCOR L)
	 <COND (<==? ,PRSO ,PLAYER>
		<NOT-CLEAR-WHOM>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"How tragic to see a formerly great inventor stalking " A ,PRSO "!" CR>)
	       (<==? ,HERE
		     <SET L <META-LOC
			     <SET CHR <GET ,CHARACTER-TABLE
				       <SET CN <GETP ,PRSO ,P?CHARACTER>>>>>>>
		<TELL "You're in the same place as " D ,PRSO "!" CR>)
	       (<OR <NOT .L> ;<==? .L ,LIMBO>>
		<TELL D ,PRSO " has left the grounds." CR>)
	       (T
		<PERFORM ,V?WALK-TO .CHR>
		<RTRUE>)>>

<ROUTINE V-FOO ()
	 <TELL "[Foo!! This is a bug!!]" CR>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <NOT <HELD? ,PRSO>> <NOT <EQUAL? ,PRSI ,PLAYER>>>
		<TELL "That's easy for you to say, since ">
		<HE-SHE-IT ,WINNER>
		<TELL " do">
		<COND (<NOT <==? ,WINNER ,PLAYER>> <TELL "es">)> 
		<TELL "n't even have it." CR>)>>

<ROUTINE V-GIVE ()
	 <COND (<NOT ,PRSI> <YOU-CANT ;"give">)
	       (<NOT <FSET? ,PRSI ,PERSON>>
		<TELL "You can't give " A ,PRSO " to " A ,PRSI "!" CR>)
	       (<IOBJ? PLAYER>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<TELL D ,PRSI " accepts the offer." CR>)>>

<ROUTINE PRE-SGIVE ()
	<PERFORM ,V?GIVE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SGIVE () <V-FOO>>

<ROUTINE PRE-GOODBYE () <PRE-HELLO>>

<ROUTINE V-GOODBYE ()
 <COND (<AND ,REMOTE-PERSON
	     <EQUAL? ,PRSO <> ,REMOTE-PERSON>>
	<PHONE-OFF>
	<TELL "\"I hope to see you soon, " FN ".\"" CR>)
       (<AND <NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	     <FINE-SEQUENCE>>
	<RTRUE>)
       (T <V-HELLO <>>)>>

<ROUTINE PRE-HANGUP ()
 <COND (<DOBJ? MICROPHONE MICROPHONE-DOME>
	<PERFORM ,PRSA ,VIDEOPHONE>
	<RTRUE>)
       (<DOBJ? INTERCOM VIDEOPHONE SONARPHONE>
	<COND (<EQUAL? ,REMOTE-PERSON-ON ,PRSO>
	       <TELL
"You're still on the line to " D ,REMOTE-PERSON "." CR>)
	      (<FSET? ,PRSO ,MUNGBIT>
	       <TELL "The " D ,PRSO "'s conked out!" CR>)
	      (<DOBJ? SONARPHONE> <RFALSE>)
	      (<NOT <GLOBAL-IN? ,PRSO ,HERE>>
	       <TELL "There's no " D ,PRSO " here." CR>)
	      (T <RFALSE>)>
	<RTRUE>)
       (<EQUAL? ,HERE ,CENTER-OF-DOME>
	<PERFORM ,V?PUT ,PRSO ,HOOK>
	<RTRUE>)
       (<NOT <DOBJ? ROOMS ;TELEPHONE>>
	<TOO-BAD-BUT ,PRSO "not wired for phoning">)>>

<ROUTINE V-HANGUP ()
 <COND (,REMOTE-PERSON
	<PERFORM ,V?GOODBYE>
	<RTRUE>)
       (T <TELL "You're not talking to anyone!" CR>)>>

<ROUTINE PRE-HELLO ("AUX" P)
 <COND (,PRSO <RFALSE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,PRSA ,QCONTEXT>
	<RTRUE>)
       (<AND <EQUAL? ,WINNER ,PLAYER>
	     <SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	     <NOT <FSET? .P ,INVISIBLE>>>
	<PERFORM ,PRSA .P>
	<RTRUE>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELLO ("OPTIONAL" (HELL T))
 <COND (<FSET? ,PRSO ,PERSON>
	<COND (.HELL <TELL D ,PRSO " nods at you." CR>)
	      (<READY-FOR-SNARK?>
	       <TELL "\"Good hunting!\"" CR>)
	      (T <TELL "\"Don't tell me you're leaving already!\"" CR>)>)
       (,PRSO
	<TELL "Only nuts say \""
		<COND (.HELL "Hello") (T "Good-bye")>
		"\" to " A ,PRSO "." CR>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELP ()
 <COND (<NOT ,PRSO>
	<SETG P-WON <>>
	<TELL ,HELP-TEXT CR>)
       (<DOBJ? PLAYER> <PERFORM ,V?GIVE ,HINT ,PLAYER> <RTRUE>)
       (T <MORE-SPECIFIC>)>>

<GLOBAL HELP-TEXT
"(You'll find plenty of help in your SEASTALKER package.|
If you're really stuck, you can order an InvisiClues (TM) Hint Booklet
either with the form in your package or from your dealer.)">

;<ROUTINE V-KICK () <HACK-HACK "Kicking">>

<ROUTINE V-KILL () <IKILL "kill">>

<ROUTINE IKILL (STR)
	 <COND (<NOT ,PRSO> <TELL "There's nothing here to " .STR "." CR>)
	       (<AND <NOT ,PRSI> <FSET? ,PRSO ,WEAPONBIT>>
		<TELL "You didn't say what to " .STR " at." CR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<TELL "You can't do it from here." CR>)
	       (T
		<TELL
"You think it over. It's not worth the trouble." CR>)>>

<ROUTINE V-KISS ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<FACE-RED "kisse">)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-KNOCK ()
 <COND (<OR <FSET? ,PRSO ,DOORBIT>
	    <FSET? ,PRSO ,WINDOWBIT>>
	<COND (<INHABITED? <DOOR-ROOM ,HERE ,PRSO>>
	       <TELL "Someone shouts \"Come in!\"" CR>)
	      (T <TELL "There's no answer." CR>)>)
       (ELSE
	<TELL "Why knock on " A ,PRSO "?" CR>)>>

<ROUTINE V-LAUNCH () <YOU-CANT ;"launch">>

<ROUTINE V-STAND ("AUX" P)
	 <COND (<FSET? <LOC ,WINNER> ,SURFACEBIT>
		<MOVE ,WINNER ,HERE>
		;<SETG PLAYER-HIDING <>>
		<TELL "You're on your own feet again." CR>)
	       (T
		<ALREADY ,PLAYER "standing up">)>>

<ROUTINE V-LEAVE ()
 <COND (<AND ,PRSO <NOT <==? <LOC ,WINNER> ,PRSO>>>
	<TELL "You're not in" THE-PRSO "!" CR>
	<RFATAL>)
       (T <DO-WALK ,P?OUT> <RTRUE>)>>

<ROUTINE V-LEVEL () <YOU-CANT ;"level">>

<ROUTINE V-LISTEN ()
 <COND (<FSET? ,PRSO ,PERSON>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (T
	<TOO-BAD-BUT ,PRSO>
	<TELL " makes no sound." CR>)>>

<ROUTINE V-LOCK () <TELL "That won't help." CR>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-LOOK-BEHIND ()
 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
	<THIS-IS-IT ,PRSO>
	<TOO-BAD-BUT ,PRSO "closed">)
       (T <TELL "There's nothing behind" THE-PRSO "." CR>)>>

<ROUTINE V-LOOK-DOWN ()
 <COND (<==? ,PRSO ,ROOMS>
	<TELL "There's nothing interesting " <GROUND-DESC> "." CR>)
       (T <HAR-HAR>)>>

<ROUTINE PRE-LOOK-INSIDE () <ROOM-CHECK>>

<ROUTINE V-LOOK-INSIDE ("OPTIONAL" (DIR ,P?IN) "AUX" RM)
	 <COND (<DOBJ? GLOBAL-HERE>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (<FSET? ,PRSO ,RLANDBIT>
		<ROOM-PEEK ,PRSO>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
			      <ROOM-PEEK .RM>)
			     (T <TELL
"The " D ,PRSO " is open, but you can't tell what's beyond it." CR>)>)
		      (T
		       <THIS-IS-IT ,PRSO>
		       <TOO-BAD-BUT ,PRSO "closed">)>)
	       (<FSET? ,PRSO ,WINDOWBIT>
		<COND ;(<SET RM <WINDOW-ROOM ,HERE ,PRSO>>
		       <ROOM-PEEK .RM>)
		      (T <TELL
"You can't tell what's beyond" THE-PRSO "." CR>)>)
	       (<OR <FSET? ,PRSO ,CONTBIT> <FSET? ,PRSO ,SURFACEBIT>>
		<COND (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL
"There's nothing on" THE-PRSO "." CR>)
			     (T
			      <TOO-BAD-BUT ,PRSO "empty">)>)
		      (T
		       <TOO-BAD-BUT ,PRSO "closed">)>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL "You forgot to bring your X-ray glasses." CR>)
	       (<==? .DIR ,P?IN> <YOU-CANT "look inside">)
	       (<==? .DIR ,P?OUT> <YOU-CANT "look outside">)>>

<ROUTINE ROOM-PEEK (RM "AUX" OLD-HERE TXT)
	 <SET OLD-HERE ,HERE>
	 <COND (<SEE-INTO? .RM>
		<SETG HERE .RM>
		<TELL "You take a quick peek into" THE .RM ":" CR>
		<COND (<DESCRIBE-OBJECTS T> T)
		      (<SET TXT <GETP .RM ,P?LDESC>>
		       <TELL .TXT CR>)
		      (T
		       <TELL "You can't see anything interesting." CR>)>
		<SETG HERE .OLD-HERE>)>>

<ROUTINE SEE-INTO? (THERE "AUX" P L TBL O)
	 #DECL ((THERE O) OBJECT (P L) FIX)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP ,HERE .P>>>
			<TELL "You can't seem to find that room." CR>
			<RFALSE>)
		       (<EQUAL? .P ,P?IN ,P?OUT> <RTRUE>)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET TBL <GETPT ,HERE .P>>
			<SET L <PTSIZE .TBL>>
			<COND (<AND <==? .L ,UEXIT>
				    <==? <GETB .TBL ,REXIT> .THERE>>
			       <RTRUE>)
			      (<AND <==? .L ,DEXIT>
				    <==? <GETB .TBL ,REXIT> .THERE>>
			       <COND (<FSET? <GETB .TBL ,DEXITOBJ> ,OPENBIT>
				      <RTRUE>)
				     (T
				      <TELL
"The door to that room is closed." CR>
				      <RFALSE>)>)
			      (<AND <==? .L ,CEXIT>
				    <==? <GETB .TBL ,REXIT> .THERE>>
			       <COND (<VALUE <GETB .TBL ,CEXITFLAG>>
				      <RTRUE>)
				     (T
				      <TELL
"You can't seem to find that room." CR>
				      <RFALSE>)>)>)>>>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (T <TELL "There's no good surface on" THE-PRSO "." CR>)>>

<ROUTINE V-LOOK-OUTSIDE () <V-LOOK-INSIDE ,P?OUT>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Nope. Nothing hiding under " D ,PRSO "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ;,GLOBAL-OBJECTS>
		<TELL "There's nothing there but dust." CR>)
	       (T
		<TELL "That's not a bit useful." CR>)>>

<ROUTINE V-LOOK-UP ()
	 <COND (,PRSI
		<TELL "There's no information in"THE-PRSI" about that." CR>)
	       (<DOBJ? ROOMS>
		<COND ;(<OUTSIDE? ,HERE>
		       <TELL "The sun is shining with all its might." CR>)
		      (T
		       <TELL "You can see the ceiling." CR>)>)
	       (<IN? ,NOTEBOOK ,WINNER>
		<PERFORM ,V?LOOK-UP ,PRSO ,NOTEBOOK>
		<RTRUE>)
	       (T
		<TELL "Huh? Without the " D ,NOTEBOOK "?" CR>
		<RTRUE>)>>

<ROUTINE V-MAKE ()
	<TELL
"\"Eat, drink, and make merry, for tomorrow we shall die!\"" CR>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL
"Moving" THE-PRSO " reveals nothing." CR>)
	       (T <YOU-CANT ;"move">)>>

<ROUTINE PRE-MOVE-DIR ()
 <COND (<IOBJ? INTDIR OFF SLOW MEDIUM FAST> <RFALSE>)
       (T
	<SETG P-WON <>>
	<TELL "(Sorry, but I don't understand that sentence.)" CR>)>>

<ROUTINE V-MOVE-DIR ()
	<TELL "You can't move" THE-PRSO " in any particular direction." CR>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <FSET? ,PRSO ,WINDOWBIT>>>
		<YOU-CANT ;"open">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,WINDOWBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY ,PRSO "open">)
		      (<FSET? ,PRSO ,LOCKED>
		       <TOO-BAD-BUT ,PRSO "locked">)
		      (<FSET? ,PRSO ,MUNGBIT>
		       <TELL
"You can't open it. The latch is broken." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <FSET? ,PRSO ,DOORBIT>
				  <FSET? ,PRSO ,WINDOWBIT>
				  <NOT <FIRST? ,PRSO>>
				  <FSET? ,PRSO ,TRANSBIT>>
			      <OKAY ,PRSO "open">)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "You open" THE-PRSO "."CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "You open" THE-PRSO
				    " and see ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <YOU-CANT ;"open">)>>

<ROUTINE PRE-OPEN-WITH ()
 <COND (<NOT-HOLDING? ,PRSI> <RTRUE>)>>

<ROUTINE V-OPEN-WITH () <PERFORM ,V?OPEN ,PRSO> <RTRUE>>

<ROUTINE V-PICK () <YOU-CANT ;"pick">>

<ROUTINE V-PLAY ()
	 <SETG P-WON <>>
	 <TELL
"(Speaking of playing, you ought to try Infocom's other products.)" CR>>

<ROUTINE V-PUSH () <HACK-HACK "Pushing">>

<ROUTINE PRE-PUT ()
	 <COND (<DOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
		<YOU-CANT "pick up">)
	       (<AND <DOBJ? SONARSCOPE> <IOBJ? AUTOMATIC MANUAL>>
		<RFALSE>)
	       (<AND <DOBJ? THROTTLE> <IOBJ? OFF SLOW MEDIUM FAST>>
		<RFALSE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<IOBJ?	GLOBAL-SUB CLAW FLOOR
			GLOBAL-HERE GLOBAL-WATER TEST-TANK>
		<RFALSE>)
	       (<IOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
		<HAR-HAR>)
	       (<IN? ,PRSI ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSI>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<YOU-CANT "pick up">)>>

<ROUTINE V-PUT ()
	 <COND (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (<OPENABLE? ,PRSI>
		       <TOO-BAD-BUT ,PRSI "closed">)
		      (T <TELL "You can't open" THE-PRSI "." CR>)>
		<RTRUE>)>
	 <COND (<NOT ,PRSI> <YOU-CANT ;"put">)
	       (<NOT <FSET? ,PRSI ,OPENBIT>>
		<TOO-BAD-BUT ,PRSI "closed">)
	       (<==? ,PRSI ,PRSO>
		<HAR-HAR>)
	       (<IN? ,PRSO ,PRSI>
		<TOO-BAD-BUT ,PRSO>
		<TELL " is already "
			<COND (<FSET? ,PRSI ,SURFACEBIT> "on") (T "in")>
			THE-PRSI "." CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Okay." CR>)>>

<ROUTINE V-PUT-UNDER ()
         <TELL "There's not enough room." CR>>

<ROUTINE V-RAISE () <YOU-CANT ;"raise">>

<GLOBAL LIT <>>

<ROUTINE PRE-READ ("AUX" VAL)
	 <COND (<NOT ,LIT> <TELL "It's impossible to read in the dark." CR>)
	       (<DOBJ? BADGE-GLOBAL BADGE-GLOBAL-2 BADGE-GLOBAL-3> <RFALSE>)
	       (<DOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
		<YOU-CANT>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>
		     <==? -1 ,P-NUMBER>>	;"? INTNUM?"
		<TELL
"You must have a swell method of looking through" THE-PRSI "." CR>)
	       (<==? ,P-ADVERB ,W?CAREFULLY>
		<COND (<NOT <SET VAL <INT-WAIT 3>>>
		       <TELL
"You never got to finish reading" THE-PRSO "." CR>)
		      (<==? .VAL ,M-FATAL> <RTRUE>)>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>> <YOU-CANT ;"read">)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-RING () <TELL "\"DING-DONG!\"" CR>>

<ROUTINE V-RISE ()
 <COND (<DOBJ? BAY>
	<PERFORM ,V?SURFACE>
	<RTRUE>)
       (T
	<DO-WALK ,P?UP>
	<RTRUE>)>>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with">>

<ROUTINE PRE-RUB-OVER ()
	 <PERFORM ,V?RUB ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-RUB-OVER () <V-FOO>>

<ROUTINE V-SAY ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?TELL ,QCONTEXT>
	<RTRUE>)
       (<AND <IN? ,COMPUTESTOR ,HERE> <FSET? ,COMPUTESTOR ,ONBIT>>
	<PERFORM ,V?TELL ,COMPUTESTOR>
	<RTRUE>)
       (<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	<PERFORM ,V?TELL .P>
	<RTRUE>)
       (T
	<SETG QUOTE-FLAG <>>
	<SETG P-CONT <>>
	<TELL
"(To talk to someone, type their name, then a comma, then what you want
them to do.)" CR>)>>

<ROUTINE PRE-SAY-INTO ()
 <COND (<DOBJ? INTERCOM> <RFALSE>)
       (<NOT <FSET? ,PRSO ,ONBIT>>
	<TELL "Sorry, but" THE-PRSO " isn't on!" CR>)>>

<ROUTINE V-SAY-INTO () <YOU-CANT "talk into">>

<ROUTINE V-SCREW () <YOU-CANT ;"screw">>

<ROUTINE V-SCREW-IN () <YOU-CANT "screw in">>

<ROUTINE PRE-SEARCH () <ROOM-CHECK>>

<ROUTINE V-SEARCH ("AUX" OBJ)
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<SET OBJ <FIRST? ,PRSO>>
		       <THIS-IS-IT .OBJ>
		       <TELL "You find " A .OBJ "." CR>)
		      (T <TELL "You don't find anything interesting." CR>)>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TELL "You'll have to open it first." CR>)
		      (T
		       <PERFORM ,V?LOOK-INSIDE ,PRSO>
		       <RTRUE>)>)
	       (T <TELL "You find nothing unusual." CR>)>>

<ROUTINE PRE-SEARCH-FOR ("AUX" OBJ)
 <COND (<ROOM-CHECK> <RTRUE>)
       (<AND <IN? ,PRSI ,PLAYER>
	     ;<GETP ,PRSI ,P?GENERIC>
	     <SET OBJ <APPLY <GETP ,PRSI ,P?GENERIC> ,PRSI>>>
	<SETG PRSI .OBJ>)>
 <COND (<DOBJ? ;GLOBAL-ROOM GLOBAL-HERE>
	<SETG PRSO ,HERE>)>
 <RFALSE>>

<ROUTINE V-SEARCH-FOR ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL "Indeed, " D ,PRSO " has" THE-PRSI "." CR>)
		      (<IOBJ? OXYGEN-GEAR-OTHER
			      OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
		       <HAR-HAR>)
		      (<IN? ,PRSI ,GLOBAL-OBJECTS>
		       <TELL D ,PRSO " doesn't have " A ,PRSI "." CR>)
		      (<NOT ,PRSI> <TELL D ,PRSO " doesn't have that." CR>)
		      (T
		       <TELL D ,PRSO " doesn't have" THE-PRSI " concealed on "
			     <COND (<FSET? ,PRSO ,FEMALE> "her")
				   (T "his")>
			      " person." CR>)>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL "You'll have to open" THE-PRSO " first." CR>)
	       (<IN? ,PRSI ,PRSO>
		<TELL "How observant you are! There ">
		<HE-SHE-IT ,PRSI <> "is">
		<TELL "!" CR>)
	       (<NOT ,PRSI> <YOU-CANT ;"search">)
	       (T <TELL "You don't find" THE-PRSI " there." CR>)>>

<ROUTINE V-SEND () <YOU-CANT ;"send">>

<ROUTINE PRE-SSEND ()
	<PERFORM ,V?SEND ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SSEND () <V-FOO>>

"<ROUTINE V-SEND-FOR () <V-SEND>>"

<ROUTINE V-SEND-OUT () <V-SEND>>

<ROUTINE PRE-SEND-TO ()
 <COND (<OR <EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>
	    <EQUAL? ,PRSI ,GLOBAL-SUB ,AQUADOME>>
	<RFALSE>)
       (<FSET? ,PRSO ,PERSON>
	<PERFORM ,V?$CALL ,PRSO>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
	       <PERFORM ,V?WALK-TO ,PRSI>)>
	<RTRUE>)
       (T
	<SETG P-WON <>>
	<TELL "(Sorry, but I don't understand.)" CR>)>>

<ROUTINE V-SEND-TO () <V-SEND>>

<ROUTINE PRE-SET ()
 <COND (<OR <EQUAL? ,PRSI ,FAST ,MEDIUM ,SLOW>
	    <EQUAL? ,PRSI ,OFF ,AUTOMATIC ,MANUAL>
	    <EQUAL? ,PRSI ,AQUADOME>
	    <AND <NOT <==? -1 ,P-NUMBER>>
		 <OR <EQUAL? ,PRSI <> ,ROOMS>
		     <AND ,PRSI <FSET? ,PRSI ,UNITBIT>>>>>
	<RFALSE>)
       (<IOBJ? LEFT RIGHT>
	<PERFORM ,V?AIM ,PRSO ,PRSI>
	<RTRUE>)
       (<==? ,PRSO ,PRSI>	;"e.g. TURN VALVE ON OXYGEN GEAR"
	<PERFORM ,V?TURN ,PRSO>
	<RTRUE>)
       (T
	<TELL
"You can set something only to a number with units, or to " D ,MEDIUM ", "
D ,AUTOMATIC ", and so on." CR>)>>

<ROUTINE V-SET () <YOU-CANT ;"set">>

<ROUTINE PRE-SHOOT ()
 <COND (<AND <NOT ,PRSI> <FSET? ,PRSO ,WEAPONBIT>>
	<SETG PRSI ,PRSO>
	<SETG PRSO <GET ,OBJ-AIMED-AT <COND (<DOBJ? DART> 1) (T 0)>>>)>
 <RFALSE>>

<ROUTINE V-SHOOT ()
 <COND (<NOT <FIND-FLAG ,WINNER ,WEAPONBIT>>
	<TELL "You don't have anything to shoot with." CR>)
       (T <IKILL "shoot">)>>

<ROUTINE PRE-SSHOOT ()
	<PERFORM ,V?SHOOT ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE V-SSHOOT () <V-FOO>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSO ,PLAYER>
		<SETG WINNER ,PLAYER>
		<COND (<VISIBLE? ,PRSO> <PERFORM ,V?EXAMINE ,PRSI>)
		      (T <PERFORM ,V?FIND ,PRSI>)>
		<RTRUE>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Don't wait for" THE-PRSO " to applaud." CR>)
	       (T
		<TELL D ,PRSO <PICK-ONE ,WHO-CARES> "." CR>)>>

<ROUTINE PRE-SSHOW ()
	 <SETG P-MERGED T>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SSHOW () <RTRUE>>

<ROUTINE V-SIT () <TELL "That won't help your mission!" CR>>

<ROUTINE V-SLAP ()
 <COND (<AND ,PRSI <NOT-HOLDING? ,PRSI>>
	<RTRUE>)
       (<DOBJ? PLAYER>
	<TELL
"That sounds like a sign that you could wear on your back." CR>)
       (<FSET? ,PRSO ,PERSON>
	<COND (<FSET? ,PRSO ,MUNGBIT>
	       <TELL D ,PRSO "'s eyes are full of hate, and ">
	       <HE-SHE-IT ,PRSO>
	       <TELL " says something unprintable." CR>)
	      (T <FACE-RED "slap">)>)
       (T <TELL
"You should see Mick. He breaks boards with the edge of his hand!" CR>)>>

<ROUTINE FACE-RED (STR)
	<TELL
D ,PRSO " " .STR "s you right back. Wow, is your face red!" CR>>

<ROUTINE V-SMELL ()
	<HE-SHE-IT ,PRSO T "smell">
	<TELL " just like " A ,PRSO "!" CR>>

<ROUTINE V-SMILE ()
 <COND (<AND <FSET? ,PRSO ,PERSON> <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
	<TELL D ,PRSO " smiles back at you." CR>)
       (T <HAR-HAR>)>>

<ROUTINE V-SMOKE () <YOU-CANT ;"burn">>

<ROUTINE V-STOP ()
 <COND (<AND <DOBJ? ROOMS> <EQUAL? ,HERE ,SUB>>
	<PERFORM ,V?STOP ,LOCAL-SUB>
	<RTRUE>)
       (<AND ,PRSO <FSET? ,PRSO ,ON?BIT>>
	<PERFORM ,V?LAMP-OFF ,PRSO>
	<RTRUE>)
       (T <YOU-CANT ;"stop">)>>

<ROUTINE V-SURFACE ()
 <COND (<AND ,PRSO <NOT <DOBJ? LOCAL-SUB>>> <YOU-CANT ;"surface">)
       (T
	<SETG P-NUMBER 0>
	<PERFORM ,V?SET ,DEPTH-CONTROL ,METER>
	<RTRUE>)>>

<ROUTINE V-SWIM ()
	 <TELL "You can't swim ">
	 <COND (,PRSO
	        <TELL "in" THE-PRSO ", " FN "." CR>)
	       (T
		<TELL <GROUND-DESC> "." CR>)>>

<ROUTINE PRE-TAKE ()
	 <COND (<DOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY
		       BADGE-GLOBAL BADGE-GLOBAL-2 BADGE-GLOBAL-3>
		<YOU-CANT>)
	       (,PRSI
		<COND (<AND <DOBJ? GLOBAL-SUB LOCAL-SUB SEA-WALL GLOBAL-SNARK
				ORE-NODULES TRAITOR>
			    <IOBJ? GLOBAL-WATER BAY SEA GLOBAL-HERE UNDERWATER
				DOCKING-TANK TEST-TANK AIRLOCK AQUADOME GAME>>
		       <MORE-SPECIFIC>)
		      (<NOT <==? ,PRSI <LOC ,PRSO>>>
		       <COND (<NOT <FSET? ,PRSI ,PERSON>>
			      <HE-SHE-IT ,PRSO T>
			      <TELL "'s not "
				    <COND (<IOBJ? HOOK> "on") (T "in")>
				    " that!" CR>)
			     (T
			      <HE-SHE-IT ,PRSI T>
			      <TELL " doesn't have ">
			      <HIM-HER-IT ,PRSO>
			      <TELL "!" CR>)>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<DOBJ? YOU TEST-TANK PLAYER-NAME>
		<RFALSE>)
	       (<DOBJ? GREENUP GLOBAL-GREENUP>
		<COND (<NOT <FSET? ,GREENUP ,MUNGBIT>>
		       <PERFORM ,V?ARREST ,PRSO>
		       <RTRUE>)>)
	       (<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
		<COND (<NOT <FSET? ,PRSO ,PERSON>>
		       <NOT-HERE ,PRSO>)>)
	       (<IN? ,PRSO ,WINNER>
		<ALREADY ,PLAYER "holding it">)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<YOU-CANT "reach">)
	       (<==? ,PRSO <LOC ,WINNER>>
		<TELL "You're in it, nitwit!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<HE-SHE-IT ,WINNER T "is">
		<TELL " now holding" THE-PRSO "." CR>)>>

<ROUTINE V-TAKE-TO ()	;"Parser should have ITAKEn PRSO."
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

<ROUTINE V-TAKE-WITH ()
	<TELL "You can't remove" THE-PRSO " with" THE-PRSI "!" CR>>

<ROUTINE V-DISEMBARK ()
	 <COND (<==? <LOC ,PRSO> ,WINNER>
		<TELL
"You don't need to take out" THE-PRSO " to use it." CR>)
	       (<DOBJ? ROOMS HERE GLOBAL-HERE GLOBAL-WATER BAY SEA>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in" THE-PRSO "!" CR>
		<RFATAL>)
	       (T
		<OWN-FEET>)>>

<ROUTINE OWN-FEET ()
	 <MOVE ,WINNER ,HERE>
	 <TELL "You're on your own feet again." CR>>

;<ROUTINE V-HOLD-UP ()
	 <TELL "That doesn't seem to help at all." CR>>

<ROUTINE V-TELL ("AUX" P)
	 <COND (<==? ,PRSO ,PLAYER>
		<COND (<NOT <==? ,WINNER ,PLAYER>>
		       <SET P ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .P>
		       <RTRUE>)
		      (,QCONTEXT
		       <SETG QCONTEXT <>>
		       <COND (,P-CONT <SETG WINNER ,PLAYER>)
			     (T <TELL
"Okay, you're not talking to anyone else." CR>)>)
		      (T
		       <WONT-HELP-TO-TALK-TO ,PLAYER>
		       <SETG QUOTE-FLAG <>>
		       <SETG P-CONT <>>
		       <RFATAL>)>)
	       (<OR <FSET? ,PRSO ,PERSON> <DOBJ? COMPUTESTOR>>
		<COND (,P-CONT
		       <SETG WINNER ,PRSO>)
		      (T
		       <TELL D ,PRSO " is listening." CR>)>
		<SETG QCONTEXT ,PRSO>
		<SETG QCONTEXT-ROOM ,HERE>)
	       (T
		<YOU-CANT "talk to">
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE PRE-TELL-ABOUT ("AUX" P)
 <COND (<AND <QCONTEXT-GOOD?>
	     <DOBJ? PLAYER>>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSI>
	<RTRUE>)
       (<AND <DOBJ? PLAYER>
	     <SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	     <NOT <FSET? .P ,INVISIBLE>>>
	<PERFORM ,V?ASK-ABOUT .P ,PRSI>
	<RTRUE>)
       (T <PRE-ASK-ABOUT>)>>

<ROUTINE V-TELL-ABOUT ("AUX" P)
 <COND (<GETP ,PRSI ,P?TEXT> <TELL <GETP ,PRSI ,P?TEXT> CR>)
       (<DOBJ? PLAYER> <ARENT-TALKING>)
       (T <PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI> <RTRUE>)>>

<ROUTINE PRE-TALK-ABOUT ("AUX" P)
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<PERFORM ,V?TELL-ABOUT ,PLAYER ,PRSO>
	<RTRUE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-TALK-ABOUT () <ARENT-TALKING>>

<ROUTINE V-THANKS ("AUX" (P <>))
	 <COND (<AND ,PRSO <FSET? ,PRSO ,PERSON>>
		<SET P ,PRSO>)
	       (<QCONTEXT-GOOD?>
		<SET P ,QCONTEXT>)
	       (<SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>
		T)>
	 <COND (.P <TELL D .P " acknowledges your thanks." CR>)
	       (T <TELL "You're more than welcome." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>>
		<RTRUE>)>
	 <COND (<IOBJ? PLAYER>
		<TELL "Don't be silly!" CR>
		<RTRUE>)>
	 <COND (<AND <NOT <FSET? ,PRSI ,PERSON>>
		     <NOT <FSET? ,PRSI ,NARTICLEBIT>>>
		<TELL "The ">)>
	 <TELL D ,PRSI
	       <COND (<FSET? ,PRSI ,PERSON> " ducks") (T " doesn't duck")>
	       " as" THE-PRSO " flies by." CR>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Let's not resort to violence, please." CR>)
	       (T <V-THROW>)>>

<ROUTINE PRE-TIE-TO ()
	 <COND (<IOBJ? GLOBAL-SUB LOCAL-SUB CLAW
			GLOBAL-SONAR SONAR-EQUIPMENT>
		<RFALSE>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-TO ()
	<TELL "You can't tie" THE-PRSO " to that." CR>>

<ROUTINE PRE-TIE-WITH ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSON>>
		    <NOT <FSET? ,PRSI ,TOOLBIT>>>
		<TELL "That won't do any good." CR>)>>

<ROUTINE V-TIE-WITH ()
	<TELL
"\"If you don't formally arrest me first, I'll sue!\"" CR>>

<ROUTINE V-TURN ()
 <COND (<DOBJ? OXYGEN-GEAR-OTHER OXYGEN-GEAR-DIVER OXYGEN-GEAR-BLY>
	<HAR-HAR>)
       (<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
	<NOT-HERE ,PRSO>)
       (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	<PERFORM ,V?CLOSE ,PRSO>
	<RTRUE>)
       (T <TELL "What do you want that to do?" CR>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Your vulgar ways would turn anyone off." CR>)
	       (<NOT <FSET? ,PRSO ,ON?BIT>>
		<YOU-CANT "turn off">)
	       (<NOT <FSET? ,PRSO ,ONBIT>>
		<ALREADY ,PRSO "off">)
	       (<AND <DOBJ? MICROPHONE MICROPHONE-DOME OXYGEN-GEAR>
		     <NOT-HOLDING? ,PRSO>>
		<RTRUE>)
	       (T
		<OKAY ,PRSO "off">)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,ONBIT>
		<ALREADY ,PRSO "on">)
	       (<AND <DOBJ? MICROPHONE MICROPHONE-DOME OXYGEN-GEAR>
		     <NOT-HOLDING? ,PRSO>>
		<RTRUE>)
	       (<FSET? ,PRSO ,ON?BIT>
		<OKAY ,PRSO "on">)
	       (<FSET? ,PRSO ,PERSON>
		<HAR-HAR>)
	       (T <YOU-CANT "turn on">)>>

<ROUTINE V-UNLOCK ()
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<YOU-CANT ;"unlock">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <YOU-CANT <> ,PRSO "open">)
		      (<NOT <FSET? ,PRSO ,LOCKED>>
		       <ALREADY ,PRSO "unlocked">)
		      (T
		       <FCLEAR ,PRSO ,LOCKED>
		       <OKAY ,PRSO "unlocked">)>)
	       (T <YOU-CANT ;"unlock">)>>

<ROUTINE V-UNTIE ()
	 <TELL "You can't tie ">
	 <HIM-HER-IT ,PRSO>
	 <TELL ", so you can't untie ">
	 <HIM-HER-IT ,PRSO>
	 <TELL "!" CR>>

<ROUTINE MORE-SPECIFIC () <TELL "How do you want to do that?" CR>>

<ROUTINE V-USE () <MORE-SPECIFIC>>

<ROUTINE V-USE-AGAINST () <MORE-SPECIFIC>>

"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that many moves.
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

<GLOBAL WHO-WAIT 0>

<ROUTINE HAS-ARRIVED (WHO)
	<FSET .WHO ,TOUCHBIT>
	<TELL D .WHO ", for whom you're waiting, has arrived." CR>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM -1) (WHO <>) (INT <>) "AUX" VAL HR(RESULT T))
	 #DECL ((NUM) FIX)
	 <COND (<==? -1 .NUM>
		<SET NUM 10>
		<TELL ,I-ASSUME " wait 10 turns.)" CR>)>
	 <SET HR ,HERE>
	 <SETG WHO-WAIT 0>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<OR <==? .VAL ,M-FATAL>
				   <NOT <==? .HR ,HERE>>>
			       <SET RESULT ,M-FATAL>
			       <RETURN>)
			      (<AND .WHO <IN? .WHO ,HERE>>
			       <HAS-ARRIVED .WHO>
			       <RETURN>)
			      (<0? .NUM> <RETURN>)
			      (T
			       <SETG WHO-WAIT <+ ,WHO-WAIT 1>>
			       <COND (.INT <TELL
"Do you want to continue what you were doing?">)
				     (T <TELL
"Do you want to keep waiting?">)>
			       <COND (<NOT <YES?>> <RETURN>)
				     (T <USL>)>)>)
		       (<AND .WHO <IN? .WHO ,HERE>>
			<HAS-ARRIVED .WHO>
			<RETURN>)
		       (<AND .WHO <G? <SETG WHO-WAIT <+ ,WHO-WAIT 1>> 30>>
			<TELL D .WHO
" still hasn't arrived.  Do you want to keep waiting?">
			<COND (<NOT <YES?>> <RETURN>)>
			<SETG WHO-WAIT 0>
			<USL>)
		       (T <USL>)>>
	 <SETG CLOCK-WAIT T>
	 .RESULT>

<ROUTINE INT-WAIT (N "AUX" TIM REQ VAL)
	 <SET TIM ,MOVES>
	 <COND (<==? ,M-FATAL <V-WAIT <SET REQ <RANDOM <* .N 2>>> <> T>>
		<RFATAL>)
	       (<NOT <L? <- ,MOVES .TIM> .REQ>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN>>
		<COND ;(<G? ,P-NUMBER ,MOVES> <V-WAIT-UNTIL> <RTRUE>)
		      (<G? ,P-NUMBER 180>
		       <TELL "That's too long to wait." CR>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<DOBJ? ROOMS TURN GLOBAL-HERE> <V-WAIT> <RTRUE>)
	       (<DOBJ? PLAYER> <ALREADY ,PLAYER "here">)
	       (<FSET? ,PRSO ,PERSON>
		<SET WHO <GET ,CHARACTER-TABLE
			      <GETP ,PRSO ,P?CHARACTER>>>
		<COND (<==? <META-LOC .WHO> ,HERE>
		       <ALREADY .WHO "here">)
		      (T <V-WAIT 10000 .WHO>)>)
	       (T <TELL "Not a good idea. You might wait forever." CR>)>>

<ROUTINE V-WAIT-UNTIL ()
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>> <==? ,PRSO ,TURN>>
		<COND (<G? ,P-NUMBER ,MOVES>
		       <V-WAIT <- ,P-NUMBER ,MOVES>>)
		      (T <TELL "It's already past that time." CR>)>)
	       (T <YOU-CANT "wait until">)>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<HE-SHE-IT ,PRSO T>
		<TELL "'s wide awake, or haven't you noticed?" CR>)
	       (T
		<TOO-BAD-BUT ,PRSO "not asleep">)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<DOBJ? LEFT RIGHT>
		<PERFORM ,V?TURN ,PRSO>
		<RTRUE>)
	       (<NOT ,P-WALK-DIR>
		<V-WALK-AROUND>
		<RFATAL>)
	       ;(<NOT ,PRSO>
		;<COND (,DEBUG <TELL "[1] ">)>
		<YOU-CANT "go">
		<RTRUE>)>
	 ;<COND (,DEBUG <TELL "[PRSO=" N ,PRSO "] ">)>
	 <COND (<SET PT <GETPT <LOC ,WINNER> ,PRSO>>
		;<COND (,DEBUG <TELL "[GETPT OK] ">)>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <SET RM <GETB .PT ,REXIT>>
		       <COND (<GOTO .RM> <OKAY>)>
		       <RTRUE>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <COND (<GOTO .RM> <OKAY>)>
			      <RTRUE>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <COND (<GOTO <GETB .PT ,REXIT>> <OKAY>)>
			      <RTRUE>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      ;<COND (,DEBUG <TELL "[2] ">)>
			      <YOU-CANT "go">
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <COND (<GOTO <GETB .PT ,REXIT>> <OKAY>)>
			      <RTRUE>)
			     (<AND <FSET? .OBJ ,INVISIBLE>
				   <NOT <AND ,DEBUG
					     <TELL "[invisible] ">>>>
			      ;<COND (,DEBUG <TELL "[3] ">)>
			      <YOU-CANT "go">)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TOO-BAD-BUT .OBJ "closed">
			      <THIS-IS-IT .OBJ>
			      <RFATAL>)>)>)
	       (<EQUAL? ,PRSO ,P?IN ,P?OUT>
		<V-WALK-AROUND>)
	       (T
		;<COND (,DEBUG <TELL "[4] ">)>
		<YOU-CANT "go">
		<RFATAL>)>>

<ROUTINE V-WALK-AROUND ()
	 <SETG P-WON <>>
	 <TELL "(What " D ,INTDIR " do you want to go in?)" CR>
	 <RFATAL>>

<ROUTINE V-WALK-TO ("AUX" O L)
 <SET O ,PRSO>
 <COND (<EQUAL? .O ,LOCAL-SUB ,GLOBAL-SUB>
	<SET O ,SUB>
	;<COND (<EQUAL? ,HERE ,SUB> <SET O ,SUB>)
	      (,SUB-IN-TANK
	       <COND (<EQUAL? ,HERE ,NORTH-TANK-AREA> <SET O ,SUB>)
		     (T <SET O ,NORTH-TANK-AREA>)>)
	      (T ;,SUB-IN-DOME
	       <COND (<EQUAL? ,HERE ,AIRLOCK> <SET O ,SUB>)
		     (T <SET O ,AIRLOCK>)>)>)
       (<AND <FSET? .O ,PERSON> <IN? .O ,GLOBAL-OBJECTS>>
	<SET O <GET ,CHARACTER-TABLE <GETP .O ,P?CHARACTER>>>)>
 <SET L <META-LOC .O>>
 ;<COND (,DEBUG <TELL "[WALK-TO: " D .O "/" D .L "]" CR>)>
 <COND (<AND <EQUAL? ,HERE ,SUB> <FSET? ,PRSO ,UNITBIT>>
	<PERFORM ,V?SET ,DEPTH-CONTROL ,PRSO>
	<RTRUE>)
       (<AND <EQUAL? ,HERE <LOC ,WINNER>>
	     <OR <EQUAL? .L ,HERE>
		 <AND <EQUAL? .L ,LOCAL-GLOBALS> <GLOBAL-IN? .O ,HERE>>
		 ;<FSET? .O ,DOORBIT>
		 ;<FSET? .O ,WINDOWBIT>>>
	<HE-SHE-IT ,WINNER T>
	<COND (<==? ,WINNER ,PLAYER> <TELL " do">)
	      (T <TELL " does">)>
	<TELL "n't need to walk around within a "
		<COND ;(<OUTSIDE? ,HERE> "part of the grounds.")
		      (T "room.")>
		CR>)
       (<EQUAL? .L ,LOCAL-GLOBALS>
	<MORE-SPECIFIC>)
       (<DOBJ? JOB>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
	<MORE-SPECIFIC>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
	<CRLF>
	<RTRUE>)
       (<DOBJ? INTDIR>
	<V-WALK-AROUND>)
       (<FAR-AWAY? .L>
	<HE-SHE-IT ,WINNER T>
	<TELL " can't go from here to there">
	<COND (<NOT <EQUAL? .L ,GLOBAL-OBJECTS>>
	       <TELL ", at least not directly">)>
	<TELL "." CR>)
       (<NOT <EQUAL? ,WINNER ,PLAYER>>
	<COND (<GOTO .L>
	       <TELL "\"Okay.">
	       ;<COND (,DEBUG <TELL " [again?]">)>
	       <COND (<==? ,WINNER ,TIP>
		      <TELL " But I'll still follow you if you move!">)>
	       <TELL "\"" CR>)>)
       (<AND ,SUB-IN-DOME
	     <NOT <FSET? ,FOOT-OF-RAMP ,TOUCHBIT>>
	     <NOT <EQUAL? .L ,FOOT-OF-RAMP>>
	     <NOT <EQUAL? .L ,SUB ,AIRLOCK ,AIRLOCK-WALL>>>
	<TELL "You should go to the " D ,FOOT-OF-RAMP " first." CR>)
       (<IN? .O ,ROOMS>
	<COND (<GOTO .O> <OKAY>)>
	<RTRUE>)
       (T ;<IN? .L ,ROOMS>
	<HE-SHE-IT .O T>
	<TELL "'s in" THE .L "." ;" Now you're there, too." CR>
	<COND (<GOTO .L> <OKAY>)>
	<RTRUE>)>>

<ROUTINE V-WALK-UNDER ()
	<COND (<DOBJ? GLOBAL-WATER SEA BAY>
	       <PERFORM ,V?DIVE>
	       <RTRUE>)
	      (T <YOU-CANT "go under">)>>

<ROUTINE V-RUN-OVER ()
	 <TELL "That doesn't make much sense." CR>>

<ROUTINE V-WHAT ("AUX" P)
	 <COND (<DOBJ? PLAYER>
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
		<TELL "You're the inventor!">
		<COND (<NOT <EQUAL? ,WINNER ,PLAYER>> <TELL "\"">)>
		<CRLF>)
	       (<OR <AND <QCONTEXT-GOOD?>
			 <FSET? <SET P ,QCONTEXT> ,PERSON>>
		    <SET P <FIND-FLAG ,HERE ,PERSON ,WINNER>>>
		<PERFORM ,V?ASK-ABOUT .P ,PRSO>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL <GETP ,TIP ,P?TEXT> CR>)
	       (T <WONT-HELP-TO-TALK-TO ,PLAYER>)>>

"<ROUTINE V-WHO-WAS-NEAR () <V-WHAT>>"

<ROUTINE V-YELL () <V-YES>>

<ROUTINE V-YELL-FOR ()
 <COND (<AND ,DOME-AIR-BAD?
	     <DOBJ? UNIVERSAL-TOOL SPECIAL-TOOL SPECIAL-TOOL-GLOBAL>>
	<TELL
"The three crew members who are still on their feet shout back that the
" D ,SPECIAL-TOOL " should be there on the hook." CR>)
       (T <V-YES>)>>

<ROUTINE V-YES ("OPTIONAL" (NO? <>))
	 <COND (<AND <QCONTEXT-GOOD?> <==? ,WINNER ,PLAYER>>
		<SETG WINNER ,QCONTEXT>
		<COND (.NO? <PERFORM ,V?NO>) (T <PERFORM ,V?YES>)>
		<RTRUE>)
	       (T <ARENT-TALKING>)>>

<ROUTINE V-NO () <V-YES T>>

"SUBTITLE SCORING"

<GLOBAL MOVES 0>
<GLOBAL SCORE 0>

"<CONSTANT SCORE-MAX 100>"

<ROUTINE SCORE-UPD (NUM)
	 #DECL ((NUM) FIX)
	 <SETG SCORE <+ ,SCORE .NUM>>
	 <TELL "(">
	 <COND (<G? 0 .NUM> <TELL "Oh no! ">)>
	 <TELL "Your score just went ">
	 <COND (<L? 0 .NUM> <TELL "up">)
	       (T <SET NUM <- 0 .NUM>> <TELL "down">)>
	 <TELL " by " N .NUM " point">
	 <COND (<NOT <1? .NUM>> <TELL "s">)>
	 <TELL "!)" CR>>

<ROUTINE SCORE-OBJ (OBJ "AUX" TEMP)
	 #DECL ((OBJ) OBJECT (TEMP) FIX)
	 <COND (<SET TEMP <GETP .OBJ ,P?VALUE>>
		<COND (<G? .TEMP 0>
		       <SCORE-UPD .TEMP>
		       <PUTP .OBJ ,P?VALUE 0>)>)>>

<ROUTINE V-SCORE ()
	 <TELL "Your score is " N ,SCORE " point">
	 <COND (<NOT <1? ,SCORE>> <TELL "s">)>
	 <TELL " out of 100, in " N ,MOVES " turn">
	 <COND (<1? ,MOVES> <TELL ".">) (ELSE <TELL "s.">)>
	 <CRLF>
	 <TELL "This score gives you the rank of a "
	       <COND (<G? 0 ,SCORE> <GET ,RANKS 0>)
		     (T <GET ,RANKS </ ,SCORE 20>>)>
	       " adventurer." CR>
	 ,SCORE>

<GLOBAL RANKS<PTABLE "beginning" "fair" "good" "very good" "master" "famous">>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>) VAL)
	 <COND (,DEBUG <RTRUE>)>
	 <CRLF>
	 <CRLF>
	 <COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL
"Would you like to:|
   RESTORE your place from where you saved it,|
   RESTART the story from the beginning, or|
   QUIT for now?|
">
	<REPEAT ()
	 <TELL ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <SET VAL <GET ,P-LEXV ,P-LEXSTART>>
	 <COND (<NOT <0? .VAL>>
		<SET VAL <WT? .VAL ,PS?VERB ,P1?VERB>>
		<COND (<EQUAL? .VAL ,ACT?RESTART>
		       <RESTART>
		       ;<TELL ,FAILED CR>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?RESTORE>
		       <COND (<V-RESTORE> <RETURN>)>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?QUIT>
		       <QUIT>)>)>
	 <TELL "(Type RESTORE, RESTART, or QUIT.) ">>>

<ROUTINE DIVESTMENT? (OBJ)
	<AND <==? ,PRSO .OBJ>
	     <VERB? DROP GIVE PUT THROW-AT THROW-THROUGH>>>

<ROUTINE EXIT-VERB? ()
 <COND (<VERB? WALK> <RTRUE>)
       (<VERB? WALK-TO FOLLOW THROUGH>
	<COND (<NOT <==? ,HERE <META-LOC ,PRSO>>> <RTRUE>)>)>>

<ROUTINE GAME-VERB? ()
	<VERB?	TELL BRIEF SUPER-BRIEF VERBOSE SAVE RESTORE QUIT RESTART
		VERSION SCRIPT UNSCRIPT SCORE $VERIFY DEBUG>>

<ROUTINE REMOTE-VERB? ()
	<VERB?	ASK-ABOUT ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR ASK-FOR
		DISEMBARK DROP FIND GIVE LOOK-UP MAKE
		SEARCH SEARCH-FOR SGIVE TAKE-WITH TELL-ABOUT WALK-TO WHAT
		;$GO ;$WHERE>>

<ROUTINE SPEAKING-VERB? ()
	<VERB? $CALL ASK ASK-ABOUT ASK-FOR GOODBYE HELLO
		NO TELL TELL-ABOUT WHAT YES>>

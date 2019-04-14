"PEOPLE for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

"Necessary Flags"

;<GLOBAL LOAD-MAX 100>
;<GLOBAL LOAD-ALLOWED 100>

"Customization"

<CONSTANT NAME-LENGTH 19>
;"<GLOBAL  GAME-NAME <ITABLE BYTE 19>>"
<GLOBAL FIRST-NAME <ITABLE BYTE 19>>
<GLOBAL  LAST-NAME <ITABLE BYTE 19>>
<GLOBAL FN-SPACE 0>
<GLOBAL LN-SPACE 0>

%<COND (<GASSIGNED? PREDGEN>

<GLOBAL RESTORED-DURING-NAME-INPUT <>>
<ROUTINE READ-NAME (TBL STR "AUX" PTR LEN N NUMTOKENS TOK)
	<TELL .STR CR>
	<TELL ">">
	<READ ,P-INBUF ,P-LEXV>
	<COND (<0? <GETB ,P-LEXV ,P-LEXWORDS>>
	       <TELL "I beg your pardon?" CR>
	       <AGAIN>)>
	<COND (<NOT <0? <SET N <GET ,P-LEXV ,P-LEXSTART>>>>
	       <COND (<EQUAL? ,ACT?RESTART <SET N <WT? .N ,PS?VERB ,P1?VERB>>>
		      <RESTART>
		      <TELL ,FAILED CR>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?$VERIFY>
		      <V-$VERIFY>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?RELEASE>
		      <V-VERSION>
		      <AGAIN>)
		     (<EQUAL? .N ,ACT?RESTORE>
		      <COND (<V-RESTORE>
			     <SETG RESTORED-DURING-NAME-INPUT T>
			     <RFATAL>)
			    (T
			     <AGAIN>)>)>)>
	<SET NUMTOKENS <GETB ,P-LEXV 1>>
	<SET TOK .NUMTOKENS>
	<SETG NAME-OUTLEN 1>
	<SET N <* 2 <+ 1 ,P-LEXSTART>>>
	<REPEAT ()
		<COND (<DLESS? TOK 0> <RETURN>)>
		<SET LEN <GETB ,P-LEXV .N>>
		<SET PTR <GETB ,P-LEXV <+ 1 .N>>>
		<READ-NAME-REPEAT .TBL .PTR .LEN>
		<COND (<G? ,NAME-OUTLEN ,NAME-LENGTH> <RETURN>)>
		<PUTB .TBL ,NAME-OUTLEN 32>
		<COND (<IGRTR? NAME-OUTLEN ,NAME-LENGTH> <RETURN>)>
		<COND (<EQUAL? .TBL ,FIRST-NAME>
		       <COND (<NOT ,FN-SPACE>
			      <SETG FN-SPACE <- ,NAME-OUTLEN 1>>)>)
		      (<NOT ,LN-SPACE>
		       <SETG LN-SPACE <- ,NAME-OUTLEN 1>>)>
		<SET N <+ 4 .N>>>
	<COND (<G? ,NAME-OUTLEN ,NAME-LENGTH> <PUTB .TBL 0 ,NAME-LENGTH>)
	      (T <PUTB .TBL 0 <- ,NAME-OUTLEN 2>>)>
	<RTRUE>>

<GLOBAL NAME-OUTLEN 0>

<ROUTINE READ-NAME-REPEAT (TBL PTR LEN "AUX" CH)
	<REPEAT ()
		<SET CH <GETB ,P-INBUF .PTR>>
		<COND (<DLESS? LEN 0> <RETURN>)>
		<COND (<NOT <EQUAL? .CH
				    %<ASCII !\-> %<ASCII !\'> %<ASCII !\&>>>
		       <SET CH <+ *140* <MOD .CH 32>>>)>
		<PUTB .TBL ,NAME-OUTLEN .CH>
		<COND (<IGRTR? NAME-OUTLEN ,NAME-LENGTH> <RETURN>)>
		<SET PTR <+ 1 .PTR>>>>

)(T

;<ROUTINE IN-MOTION? (PERSON) <RFALSE>>
<ROUTINE IS-CREW? (PERSON) <RFALSE>>

)>

<ROUTINE PRINT-NAME (TBL "OPTIONAL" (CAP <>) "AUX" (PTR 0) LEN CH (SP? T))
	 <SET LEN <GETB .TBL 0>>
	 <REPEAT ()
		<COND (<IGRTR? PTR .LEN> <RETURN>)>
		<SET CH <GETB .TBL .PTR>>
		<COND (<AND <OR .CAP .SP?>
			    <NOT <EQUAL? .CH 32 %<ASCII !\-> %<ASCII !\'>>>
			    <NOT <EQUAL? .CH %<ASCII !\&>>>>
		       <PRINTC <- .CH 32>>)
		      (T <PRINTC .CH>)>
		<COND (<EQUAL? .CH 32 %<ASCII !\-> %<ASCII !\'>> <SET SP? T>)
		      (<EQUAL? .CH %<ASCII !\&>> <SET SP? T>)
		      (T <SET SP? <>>)>>>

<ROUTINE NAME? (PTR)
	<OR <XNAME? .PTR ,FIRST-NAME ,FN-SPACE>
	    <XNAME? .PTR  ,LAST-NAME ,LN-SPACE>>>

<ROUTINE XNAME? (PTR TBL MAX "AUX" CNT BPTR CHR (N? T) (NCNT 0))
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <COND (<G? .CNT 6> <SET CNT 6>)>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 <COND (<NOT .MAX> <SET MAX <GETB .TBL 0> ;<-  1>>)>
	 <COND (<NOT <DLESS? MAX 7>> <SET MAX 6>)>
	 ;<COND (,DEBUG <TELL "[Namelen=" N .MAX "]" CR>)>
	 <REPEAT ()
		 <COND (<IGRTR? NCNT .MAX>
			;<COND (,DEBUG
			       <TELL "[NCNT=" N .NCNT " CNT=" N .CNT "]" CR>)>
			<COND (<NOT <0? .CNT>> <SET N? <>>)>
			<RETURN>)
		       (<L? <SET CNT <- .CNT 1>> 0>
			;<COND (,DEBUG <TELL "[CNT=" N .CNT "]" CR>)>
			<SET N? <>>
			<RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			;<COND (,DEBUG <TELL "[CHR=" N .CHR>)>
			<COND (<NOT <EQUAL? .CHR
					%<ASCII !\->%<ASCII !\&>%<ASCII !\'>>>
			       <SET CHR <+ *140* <MOD .CHR 32>>>
			       ;<COND (,DEBUG <TELL "->" N .CHR>)>)>
			;<COND (,DEBUG
			       <TELL " Namechr=" N <GETB .TBL .NCNT> "]" CR>)>
			<COND (<NOT <==? .CHR <GETB .TBL .NCNT>>>
			       <SET N? <>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <COND (.N?
		<COND (<==? .TBL ,FIRST-NAME>
		       <PUT ,P-LEXV .PTR ,W?$FN>
		       ,W?$FN)
		      (T
		       <PUT ,P-LEXV .PTR ,W?$LN>
		       ,W?$LN)>)>>

"People"

"Constants used as table offsets for each character, including the player:"

<CONSTANT PLAYER-C 0>
<CONSTANT TIP-C 1>
<CONSTANT SHARON-C 2>
;<CONSTANT PERELLI-C 3>
<CONSTANT THORPE-C 4>
<CONSTANT BLY-C 5>
<CONSTANT ANTRIM-C 6>
<CONSTANT HORVAK-C 7>
<CONSTANT SIEGEL-C 8>
<CONSTANT GREENUP-C 9>
<CONSTANT LOWELL-C 10>
<CONSTANT CHARACTER-MAX 10>

<GLOBAL CHARACTER-TABLE
	<TABLE PLAYER TIP SHARON GLOBAL-PERELLI THORPE
	       BLY ANTRIM HORVAK SIEGEL GREENUP LOWELL>>

<GLOBAL GLOBAL-CHARACTER-TABLE
	<TABLE PLAYER GLOBAL-TIP GLOBAL-SHARON GLOBAL-PERELLI GLOBAL-THORPE
	       GLOBAL-BLY GLOBAL-ANTRIM GLOBAL-HORVAK GLOBAL-SIEGEL
	       GLOBAL-GREENUP GLOBAL-LOWELL>>

<ROUTINE CAPITAL-NOUN? (WRD)
	<OR <EQUAL? .WRD ,W?DOC ,W?TIP ,W?RANDALL>
	    <EQUAL? .WRD ,W?DOC\'S ,W?TIP\'S ,W?BILL\'S>
	    <EQUAL? .WRD ,W?KEMP\'S ,W?ZOE\'S ,W?MARV\'S>
	    <EQUAL? .WRD ,W?SHARON ,W?KEMP ,W?ZOE>
	    <EQUAL? .WRD ,W?BLY\'S ,W?AMY\'S ,W?FROBTON>
	    <EQUAL? .WRD ,W?BLY ,W?AMY ,W?LOWELL>
	    <EQUAL? .WRD ,W?MICK\'S ,W?WALT\'S>
	    <EQUAL? .WRD ,W?MICK ,W?ANTRIM ,W?WALT>
	    <EQUAL? .WRD ,W?DOCTOR ,W?DR ,W?MARV>
	    <EQUAL? .WRD ,W?SIEGEL ,W?BILL ,W?GREENUP>
	    <EQUAL? .WRD ,W?HORVAK ,W?JEROME ,W?THORPE>>>

<OBJECT PLAYER
	(IN CENTER-LAB)
	(DESC "yourself" ;"famous young inventor")
	(ADJECTIVE FAMOUS YOUNG)
	(SYNONYM I ME MYSELF ;INVENT)
	(ACTION PLAYER-F)
	(FLAGS NDESCBIT NARTICLEBIT TRANSBIT ;VOWELBIT PERSON)
	(CHARACTER 0)>

<OBJECT PLAYER-NAME
	(IN GLOBAL-OBJECTS)
	(DESC "yourself")
	(ADJECTIVE $FN)
	(SYNONYM ;$FN $LN WE US ;SKIPPER)
	(ACTION PLAYER-NAME-F)
	(FLAGS NARTICLEBIT)>

<ROUTINE PLAYER-NAME-F ()
	<DO-INSTEAD-OF ,PLAYER ,PLAYER-NAME>
	<RTRUE>>

;<GLOBAL PLAYER-HIDING <>>

<ROUTINE PLAYER-F ("AUX" LON LAT)
 <COND (<DOBJ? PLAYER>
	<COND (<VERB? HELLO GOODBYE>
	       <HAR-HAR>)
	      (<VERB? EXAMINE>
	       <PERFORM ,V?INVENTORY>
	       <RTRUE>
	       ;<TELL "Hey, look at you! You're a " D ,PLAYER "!" CR>)
	      (<VERB? FIND>
	       <COND (<EQUAL? ,NOW-TERRAIN
			      ,BAY-TERRAIN ,SEA-TERRAIN> ;<EQUAL? ,HERE ,SUB>
		      <TELL "The ">
		      <COND (<EQUAL? ,NOW-TERRAIN ,BAY-TERRAIN>
			     <SET LON <- ,SUB-LON ,SEA-WALL-LON>>
			     <SET LAT <- ,SUB-LAT ,SEA-WALL-LAT>>
			     <TELL D ,SEA-WALL>)
			    (T
			     <SET LON ,SUB-LON>
			     <SET LAT ,SUB-LAT>
			     <COND (,FINE-SONAR <INC LAT>)>
			     <TELL D ,AIRLOCK>)>
		      <TELL " is ">
		      <COND (<NOT <0? .LON>>
			     <TELL N <* 5 <ABS .LON>>>
			     <COND (<NOT ,FINE-SONAR> <TELL "00">)>
			     <TELL " meters "
				   <COND (<G? 0 .LON> "ea") (T "we")>
				   "st ">
			     <COND (<NOT <0? .LAT>> <TELL "and ">)>)>
		      <COND (<NOT <0? .LAT>>
			     <TELL N <* 5 <ABS .LAT>>>
			     <COND (<NOT ,FINE-SONAR> <TELL "00">)>
			     <TELL " meters "
				   <COND (<G? 0 .LAT> "nor") (T "sou")>
				   "th ">)>
		      <TELL "of here." CR>
		      <SET LON <- ,AIRLOCK-DEPTH ,SUB-DEPTH>>
		      <COND (<AND <==? ,NOW-TERRAIN ,SEA-TERRAIN>
				  <NOT <0? .LON>>>
			     <TELL
"It's also " N <* 5 .LON> " meters below you." CR>)>
		      <RTRUE>)>)
	      (<VERB? SEARCH>
	       <PERFORM ,V?INVENTORY>
	       <RTRUE>)>)
       ;"(<AND <NOT ,PLAYER-HIDING> <IN? <LOC ,PLAYER> ,ROOMS>>
	<RFALSE>)
       (<NOT ,PRSO>
	<RFALSE>)
       (<VERB? WALK>
	<TOO-BAD-SIT-HIDE>)
       (<NOT <STANDING-VERB?>>
	<RFALSE>)
       (<NOT <IN? ,PRSO ,WINNER>>
	<COND (<AND <VERB? TAKE> <DOBJ? HINT>>
	       <RFALSE>)
	      (T
	       <TOO-BAD-SIT-HIDE>)>)
       (<NOT ,PRSI>			<RFALSE>)
       (<IN? ,PRSI ,WINNER>		<RFALSE>)
       (T
	<TOO-BAD-SIT-HIDE>)">>

<OBJECT ARM
	(IN ;GLOBAL-OBJECTS PLAYER)
	(DESC "your arm")
	(ADJECTIVE MY)
	(SYNONYM ARM)
	(FLAGS ;"VOWELBIT" NDESCBIT NARTICLEBIT SEARCHBIT)
	(ACTION ARM-F)>

<OBJECT GASH
	(IN ARM)
	(DESC "gash")
	(ADJECTIVE WARM SPREADING REDDISH SERIOUS MY)
	(SYNONYM GASH MOISTURE STAIN)
	(FLAGS INVISIBLE NDESCBIT)
	(ACTION ARM-F)>

<ROUTINE ARM-F ()
 <COND (<OR <DIVESTMENT? ,ARM> <DIVESTMENT? ,GASH>>
	<HAR-HAR>)
       (<VERB? ANALYZE EXAMINE>
	<COND (<FSET? ,ARM ,MUNGBIT>
	       <TELL "Your arm is seriously gashed." CR>)
	      (T <TELL "There's nothing special about" THE-PRSO "." CR>)>)>>

<OBJECT GLOBAL-TIP
	(DESC "Tip Randall")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE TIP)
	(SYNONYM TIP RANDALL)
	(FLAGS PERSON)
	(ACTION GLOBAL-PERSON)
	(CHARACTER 1)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<OBJECT TIP
	(DESC "Tip")
	;(IN NORTH-WALL)
	(ADJECTIVE TIP)
	(SYNONYM TIP RANDALL SAILOR)
	(ACTION TIP-F)
	(DESCFCN TIP-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(FLAGS PERSON TOUCHBIT)
	(CAPACITY 40)
	(CHARACTER 1)>

<GLOBAL TIP-PLAYS <>>
<GLOBAL TIP-PICKS <LTABLE STATION-MONITOR WINDOW>>
<ROUTINE TIP-IS-PLAYING ()
	<TELL <COND (<==? ,TIP-PLAYS ,WINDOW> "looking out")
		    (T "playing with")>
	      " the " D ,TIP-PLAYS>>

<ROUTINE TIP-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,TIP>))
 <COND (<==? .ARG ,M-OBJDESC>
	<COND ;(<IN-MOTION? ,TIP> <RTRUE>)
	      (<NOT <FSET? ,TIP ,TOUCHBIT>>
	       <FSET ,TIP ,TOUCHBIT>
	       <TELL CR D ,TIP " follows you into" THE .L>
	       <COND (<EQUAL? .L ,BLY-OFFICE>
		      <SETG TIP-PLAYS <PICK-ONE ,TIP-PICKS>>
		      <TELL " and begins ">
		      <TIP-IS-PLAYING>)>
	       <TELL "." CR>)
	      (<==? .L ,SUB>
	       <TELL D ,TIP " is sitting behind you, ">
	       <COND (<IN? ,MAGAZINE ,TIP>
		      <TELL "reading a magazine." CR>)
		     (<NOT ,TIP-FOLLOWS-YOU?>
		      <TELL "installing a " D ,FINE-GRID "." CR>)
		     (T
		      <TELL "checking the instruments." CR>
		      ;<CARRY-CHECK ,TIP>)>)
	      (<==? .L ,BLY-OFFICE>
	       <TELL D ,TIP " is ">
	       <TIP-IS-PLAYING>
	       <TELL "." CR>
	       ;<CARRY-CHECK ,TIP>)
	      (T <DESCRIBE-COLLAPSE ,TIP>)>
	<RTRUE>)
       (<==? ,WINNER ,TIP>
	<COND (<NOT <GRAB-ATTENTION ,TIP>> <RTRUE>)
	      (<OR <AND <DOBJ? FINE-GRID>
			<OR <VERB? TAKE>
			    <AND <VERB? PUT TIE-TO>
				 <IOBJ? THROTTLE GLOBAL-SONAR SONARSCOPE>>>>
		   <MOUNTING-VERB? ,FINE-GRID>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,TIP ,FINE-GRID>
	       <RTRUE>)
	      (<OR <AND <VERB? WAIT-FOR> <DOBJ? HERE>>
		   <AND <VERB? FOLLOW> <DOBJ? PLAYER>>>
	       <TELL "\"I won't let you out of my sight, " FN "!\"" CR>)
	      (<SET X <COM-CHECK ,TIP>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? TIP>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,TIP>> <RTRUE>)>
	<SAID-TO ,TIP>
	<COND (<AND <EQUAL? .OBJ ,AUTO-PILOT>
		    ,SUB-IN-OPEN-SEA
		    <NOT <FSET? ,AUTO-PILOT ,ONBIT>>>
	       <TIME-FOR-PILOT>)
	      (<EQUAL? .OBJ ,REACTOR ,CATALYST-CAPSULE>
	       <COND (<NOT <IN? ,CATALYST-CAPSULE ,REACTOR>>
		      <TELL-HINT 33 ;8 ,CATALYST-CAPSULE <>>)>)
	      (<EQUAL? .OBJ ,SPECIAL-TOOL-GLOBAL ,SPECIAL-TOOL>
	       <COND (<EQUAL? ,HERE ,SUB>
		      <TELL-HINT 61 ,TIP <>>)>)
	      (<AND <EQUAL? .OBJ ,TRAITOR ,BLACK-BOX> <TIP-COMES>>
	       <RTRUE>)
	      (<AND <EQUAL? .OBJ ,TIP-IDEA ,GLOBAL-SONAR>
		    <IN? ,TIP-IDEA ,GLOBAL-OBJECTS>>
	       <TELL-HINT 13 ,SIEGEL <>>)
	      (<EQUAL? .OBJ ,STATION-MONITOR>
	       <TELL "\"I just like to play with it.\"" CR>)
	      (<EQUAL? .OBJ ,FINE-GRID>
	       <COND (<OR ,FINE-SONAR
			  <AND <NOT ,SUB-IN-DOME>
			       <NOT <==? ,NOW-TERRAIN ,SEA-TERRAIN>>>>
		      <TELL "\"I think it's swell!\"" CR>
		      <RTRUE>)>
	       %<XTELL
"\"If the " D ,SNARK " stays near the
sea floor, "FN", it may churn up silt. Even with our " D ,SEARCH-BEAM"
on, we might have trouble aiming a weapon. Wouldn't it be easier if we
could spot its exact position by sonar?\"">
	       <COND (<YES?>
		      %<XTELL
"\""FN", our " D ,SONARSCOPE " shows each " D ,GRID-UNIT " as 500 meters
across. A blip indicates the APPROXIMATE position of an object. That's not
good enough to hit the broad side of a barn! ">
		      <COND (<AND <NOT ,SUB-IN-DOME>
				  <NOT <IN? ,FINE-GRID ,TIP>>>
			     <TELL
"When we're in the " D ,AQUADOME ", ask me about a " D ,FINE-GRID ".\"" CR>
			     <RTRUE>)>
		      <TELL
"Let me install a " D ,FINE-GRID " on the " D ,SONARSCOPE " that'll show
a blip's position to within 5 meters, okay?\"">
		      <COND (<YES?>
			     <ENABLE <QUEUE I-TIP-REPORTS 5>>
			     <FSET ,TIP ,BUSYBIT>
			     <COND (,SUB-IN-DOME
				    <COND (<EQUAL? ,HERE
						   ,SUB ,AIRLOCK,AIRLOCK-WALL>
					   <MOVE ,TIP ,DOME-STORAGE>)
					  (T <MOVE ,TIP ,SUB>)>
				    <MOVE ,FINE-GRID ,TIP>
				    <SETG TIP-FOLLOWS-YOU? <>>
				    <TELL "\""FN", I checked">
				    <COND (<NOT <EQUAL? ,HERE ,DOME-STORAGE>>
					   <TELL " the " D ,DOME-STORAGE>)>
				    <TELL
" and found a " D ,FINE-GRID " that'll fit our " D ,SONARSCOPE ". I can
install it quickly! I'll have someone install a fine throttle control,
too, for tight maneuvering. It has the same 3 settings, but for small "
D ,GRID-UNIT "s -- 0, 5, 10, or 15 meters per turn.\"" CR>)>)>)>
	       <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,TIP .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T
	       ;<OR <EQUAL? .OBJ ,GLOBAL-SUB ,LOCAL-SUB ,VOLTAGE-REGULATOR>
		   <EQUAL? .OBJ ,OVERHEATING ,CONTROL-CIRCUITS ,MICROPHONE>
		   <EQUAL? .OBJ ,ELECTROLYTE-RELAY ,MICROPHONE-DOME
				,SPECIAL-TOOL-GLOBAL ,SPECIAL-TOOL>
		   <EQUAL? .OBJ ,GLOBAL-SNARK ,CONTROL-CIRCUITS-GAUGE>>
	       %<XTELL "\"You know as much as I do, "FN".\"" CR>)
	      ;(T <DONT-KNOW ,TIP .OBJ>)>)
       (<VERB? TELL-ABOUT>
	<COND (<DOBJ? GLOBAL-SNARK>
	       %<XTELL
"\"I know, " FN "! We'd better go there fast in the " D ,GLOBAL-SUB "!\""
CR>)>)
       (<COMMON-OTHER ,TIP> <RTRUE>)>>

<OBJECT GLOBAL-SHARON
	(IN GLOBAL-OBJECTS)
	(DESC "Sharon Kemp")
	(ADJECTIVE SHARON)
	(SYNONYM SHARON KEMP)
	(FLAGS PERSON FEMALE NDESCBIT)
	(CHARACTER 2)
	(ACTION GLOBAL-SHARON-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL SHARON-EXPLAINED <>>

<ROUTINE GLOBAL-SHARON-F ("OPTIONAL" (ARG <>) "AUX" OBJ L X)
 <SET L ,REMOTE-PERSON-LOC>
 <COND (<AND <NOT ,SHARON-EXPLAINED>
	     <==? ,REMOTE-PERSON ,GLOBAL-SHARON>>
	<SETG SHARON-EXPLAINED T>
	<SHARON-EXPLAINS>
	<RFATAL>)
       (<==? ,WINNER ,GLOBAL-SHARON>
	<COND (<AND <VERB? FIND>
		    <DOBJ? GLOBAL-SHARON>>
	       %<XTELL "\"I'm in the Sea Cat.\"" CR>)
	      (<AND <VERB? FIND>
		    <DOBJ? GLOBAL-SNARK>
		    ;<==? ,REMOTE-PERSON-ON ,SONARPHONE>>
	       %<XTELL "\"It's right here, next to me.\"" CR>)
	      (<AND <VERB? STOP MOVE MOVE-DIR PUSH>
		    <DOBJ? SNARK THORPE-SUB>>
	       <TELL "\"I'm afraid I can't control it that well.\"" CR>)
	      (<SET X <COM-CHECK ,GLOBAL-SHARON>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       ;(<VERB? ASK> <RFALSE>)
       (<AND <EQUAL? ,REMOTE-PERSON ,GLOBAL-SHARON>
	     <OR <AND ,PRSI <SET OBJ ,PRSI>
		      <DOBJ? GLOBAL-SHARON> <VERB? CONFRONT ASK-ABOUT>>
		 <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		      <VERB? FIND WHAT>>>>
	;<COND (<NOT <GRAB-ATTENTION ,GLOBAL-SHARON>> <RTRUE>)>
	<SAID-TO ,GLOBAL-SHARON>
	<COND (<EQUAL? .OBJ ,SNARK> <TELL ,SHARON-ABOUT-MONSTER CR>)
	      (<EQUAL? .OBJ ,THORPE-SUB> <TELL ,SHARON-ABOUT-CAT CR>)
	      (<EQUAL? .OBJ ,GLOBAL-THORPE> <SHARON-ABOUT-THORPE> <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,GLOBAL-SHARON .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T
	       <DONT-KNOW ,GLOBAL-SHARON .OBJ>)>)
       (<AND <DOBJ? GLOBAL-SHARON>
	     <VERB? HELLO>
	     <EQUAL? ,REMOTE-PERSON-ON ,SONARPHONE ,INTERCOM>>
	%<XTELL "You hear " D ,PRSO " nodding at you." CR>)
       (<AND <DOBJ? GLOBAL-SHARON> <VERB? LISTEN REPLY>>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (<AND <DOBJ? GLOBAL-SHARON>
	     <VERB? PHONE>
	     <NOT <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>>
	     <NOT ,SUB-IN-DOME ;<IN-DOME? ,HERE>>>
	%<XTELL "There's no phone line to where she is." CR>)
       (<AND <DOBJ? GLOBAL-SHARON> <VERB? READ>>
	%<XTELL
"That's just a figure of speech! Try the command: SHARON, HELLO." CR>)
       (T <GLOBAL-PERSON>)>>

<OBJECT SHARON
	(IN OFFICE)
	(DESC "Sharon Kemp")
	(ADJECTIVE SHARON)
	(SYNONYM SHARON KEMP)
	(FLAGS PERSON TOUCHBIT FEMALE NDESCBIT)
	(CAPACITY 40)
	(ACTION SHARON-F)
	(DESCFCN SHARON-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(CHARACTER 2)>

;<GLOBAL SHARON-CALLED <>>

<ROUTINE DONT-KNOW-ANYTHING ()
	%<XTELL "\"Uh . . . I don't know anything about it.\"" CR>>

<ROUTINE SHARON-F ("OPTIONAL" (ARG <>) "AUX" OBJ (L <LOC ,SHARON>) X)
 <COND (<==? .ARG ,M-OBJDESC>
	<COND ;(<IN-MOTION? ,SHARON> <RTRUE>)
	      (<IN? ,SHARON ,OFFICE>
	       %<XTELL "Sharon is looking through the file drawer." CR>)
	      (<AND <IN? ,SHARON ,HERE> <IN? ,HERE ,ROOMS>>
	       %<XTELL "Sharon is pacing back and forth." CR>)
	      (T %<XTELL "Sharon is sitting on the " D <LOC ,SHARON> "." CR>)>
	;<CARRY-CHECK ,SHARON>)
       (<==? ,WINNER ,SHARON>
	<COND (<VERB? FIND>
	       <COND (<DOBJ? MAGAZINE>
		      <PERFORM ,V?ASK-ABOUT ,SHARON ,MAGAZINE>
		      <RTRUE>)
		     (<DOBJ? GLOBAL-THORPE>
		      %<XTELL
"Sharon looks surprised. \"I don't know, " FN ".\"" CR>)>)
	      (<AND <VERB? LOOK-INSIDE> <DOBJ? FILE-DRAWER>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,SHARON ,FILE-DRAWER>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,SHARON>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T %<XTELL "\"I'm too busy right now.\"" CR>)>)
       (<AND <VERB? ASK> <IN? ,SHARON ,OFFICE>>
	<PERFORM ,V?ASK-ABOUT ,SHARON ,FILE-DRAWER>
	<RTRUE>)
       (<OR <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>
	    <AND ,PRSI <SET OBJ ,PRSI>
		 <DOBJ? SHARON> <VERB? CONFRONT ASK-ABOUT>>>
	<COND (<NOT <GRAB-ATTENTION ,SHARON>> <RTRUE>)>
	<SAID-TO ,SHARON>
	<COND (<AND <EQUAL? .OBJ ,MAGAZINE ,ARTICLE>
		    <EQUAL? <LOC ,MAGAZINE> ,SHARON ,PLAYER>>
	       %<XTELL "\"Uh . . . That's not the magazine I'm looking for.\""
		       ;"\"I've never seen it before.\"" CR>)
	      (<AND <EQUAL? .OBJ ,CIRCUIT-BREAKER ,ELECTRICAL-CONTROL-PANEL>
		    ,SHARON-BROKE-CIRCUIT>
	       <DONT-KNOW-ANYTHING>)
	      (<EQUAL? .OBJ ,CATALYST-CAPSULE>
	       %<XTELL "\"Uh . . . I guess I forgot about it. Sorry.\"" CR>)
	      (<EQUAL? .OBJ ,GLOBAL-SHARON ,SHARON>
	       %<XTELL "\"You know me well and trust me completely.\"" CR>)
	      (<OR <EQUAL? .OBJ ,PROBLEM>
		   ;<AND ,SHARON-CALLED
			<EQUAL? .OBJ ,TELEPHONE ,GLOBAL-CALL>>>
	       %<XTELL
"\"Sorry, " FN ", but I just got word that my mother is ill. They want
me to come to the hospital at once.">
	       ;<COND (,SHARON-CALLED
		      <TELL
" That's why I didn't bother answering the phone.">)>
	       <TELL "\"" CR>)
	      (<OR <EQUAL? .OBJ ,ARTICLE>
		   <EQUAL? .OBJ ,FILE-DRAWER ,PAPERS ,MAGAZINE>>
	       %<XTELL
"\"I can't find the " D ,MAGAZINE " I bought for my mother this morning. I
thought it might be in the " D ,FILE-DRAWER ". I wanted to take it to the
hospital for her to read. I really must rush off, "FN"!\"" CR>)
	      (<EQUAL? .OBJ ,THORPE ,GLOBAL-THORPE ;,PRIVATE-MATTER>
	       <PERFORM ,V?ASK-ABOUT ,SHARON ,PRIVATE-MATTER>
	       <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,SHARON .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL <PICK-ONE ,SHARON-ASKED> CR>)>)
       (<VERB? GOODBYE>
	<TELL "\"I'm going as soon as I find that " D ,MAGAZINE ".\"" CR>)
       ;(<AND <DOBJ? SHARON> <VERB? PHONE>>
	<SETG SHARON-CALLED T>
	<TELL "She doesn't answer." CR>)
       (<COMMON-OTHER ,SHARON> <RTRUE>)>>

<GLOBAL SHARON-ASKED
	<LTABLE "\"I can't help you there.\""
		"\"That has nothing to do with me.\"">>

<OBJECT GLOBAL-BLY
	(IN GLOBAL-OBJECTS)
	(DESC "Commander Bly")
	(ADJECTIVE	COMMANDER ZOE)
	(SYNONYM	COMMANDER ZOE BLY)
	(FLAGS PERSON FEMALE NDESCBIT)
	(ACTION GLOBAL-BLY-F)
	(DESCFCN GLOBAL-BLY-F)
	(CHARACTER 5)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL REMOTE-PERSON <>>
<GLOBAL REMOTE-PERSON-LOC <>>
<GLOBAL REMOTE-PERSON-REMLOC <>>
<GLOBAL REMOTE-PERSON-ON <>>
<GLOBAL BLY-TOLD-PROBLEM <>>

<ROUTINE BLY-TELLS-PROBLEM ()
	<SETG BLY-TOLD-PROBLEM T>	;<FCLEAR ,GLOBAL-SNARK ,INVISIBLE>
	<ENABLE <QUEUE I-SHARON-TO-HALLWAY 6 ;12>>
	<SAID-TO ,GLOBAL-BLY>
	<THIS-IS-IT ,GLOBAL-SNARK>
	%<XTELL
FN "! Our transparent dome enclosing the " ,URS
" is being battered by a huge monster!\"" CR>>

<ROUTINE MIKE-2-F ()
	 %<XTELL
"\"The " D ,SNARK "'s gone for now, " FN ". It's no longer in sight.">>

<ROUTINE GLOBAL-BLY-F ("OPTIONAL" (ARG <>) "AUX" OBJ L X)
 <SET L ,REMOTE-PERSON-LOC>
 <COND (<==? .ARG ,M-OBJDESC>
	<COND (<EQUAL? .L ,CENTER-OF-LAB>
	       <COND (,WOMAN-ON-SCREEN
		      %<XTELL "You can't tell who the woman is." CR>)
		     (T %<XTELL
"You can see a picture of " D ,BLY " on the " D ,REMOTE-PERSON-ON "." CR>)>)>)
       (<AND <EQUAL? .L ,CENTER-OF-LAB>
	     <SPEAKING-VERB?>
	     <EQUAL? ,PRSO <> ,GLOBAL-BLY ,PLAYER ;"Added 4/11/84 by MARC">
	     <OR <NOT <IN? ,MICROPHONE ,PLAYER>>
		 <NOT <FSET? ,MICROPHONE ,ONBIT>>>>
	<SETG P-CONT <>>
	<THIS-IS-IT ,MICROPHONE>
	%<XTELL "She can't hear you unless you ">
	<COND (<NOT <IN? ,MICROPHONE ,PLAYER>>
	       %<XTELL "pick up your " D ,MICROPHONE>
	       <COND (<NOT <FSET? ,MICROPHONE ,ONBIT>>
		      %<XTELL " and switch it on">)>
	       %<XTELL "." CR>)
	      (T %<XTELL "switch on your " D ,MICROPHONE "." CR>)>)
       (<AND <NOT ,BLY-TOLD-PROBLEM>	;<FSET? ,GLOBAL-SNARK ,INVISIBLE>
	     <NOT <VERB? GOODBYE LISTEN>>
	     <NOT ,MONSTER-GONE>
	     <IN? ,MICROPHONE ,PLAYER>
	     <==? ,REMOTE-PERSON ,GLOBAL-BLY>>
	<ENABLE <QUEUE I-SEND-SUB 8>>
	<TELL "\"">
	<COND (T ;<VERB? SAY> <TELL FN "! ">)
	      ;(T <TELL "Wait a second, ">)>
	<BLY-TELLS-PROBLEM>
	<RFATAL>)
       (<==? ,WINNER ,GLOBAL-BLY>
	<COND (<AND <VERB? FIND>
		    <DOBJ? GLOBAL-BLY>>
	       %<XTELL "\"I'm at the " D ,AQUADOME ".\"" CR>)
	      (<AND <DOBJ? PLAYER>
		    <==? ,P-ADVERB ,W?PRIVATELY>
		    <OR <AND <VERB? TELL>>
			<AND <VERB? TELL-ABOUT> <IOBJ? PRIVATE-MATTER>>>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,GLOBAL-BLY ,PRIVATE-MATTER>
	       <RTRUE>)
	      (<OR <AND <VERB? EXAMINE> <DOBJ? GLOBAL-SNARK>>
		   <AND <VERB? SHOW> <DOBJ? PLAYER> <IOBJ? GLOBAL-SNARK>>>
	       <COND ;(<EQUAL? .L ,SUB>
		      <TELL
"\"There have been no further attacks, " FN ". But the creature
may return any time.\"" CR>)
		     (,MONSTER-GONE
		      <MIKE-2-F>
		      <TELL "\"" CR>)
		     (T %<XTELL
"The " D ,AQUADOME "'s camera pans, and the monster comes into
view on your " D ,VIDEOPHONE " screen. It resembles a huge sea slug, about
5 meters tall. Its clawed tentacles pound and scratch at the dome." CR>)>)
	      (<OR <AND <VERB? KILL> <DOBJ? GLOBAL-SNARK>>
		   <AND <VERB? ATTACK SHOOT> <DOBJ? GLOBAL-SNARK>
			<EQUAL? ,PRSI <> ,GLOBAL-WEAPON ,GLOBAL-EXPLOSIVE>>
		   <AND <DOBJ? GLOBAL-WEAPON GLOBAL-EXPLOSIVE>
			<OR <VERB? USE>
			    <AND <VERB? USE-AGAINST> <IOBJ? GLOBAL-SNARK>>>>>
	       <COND (,MONSTER-GONE
		      <MIKE-2-F>
		      <TELL "\"" CR>)
		     (<OR <DOBJ? GLOBAL-EXPLOSIVE> <IOBJ? GLOBAL-EXPLOSIVE>>
		      %<XTELL
"\"Setting off explosions so close might damage the
" D ,AQUADOME " even worse than the Snark is doing.\"" CR>)
		     (T %<XTELL
"\"" FN ", this is a peaceful research facility. We
have no weapons.\"" CR>)>)
	      (<AND <VERB? SEND SEND-OUT> <DOBJ? GLOBAL-SUB>>
	       %<XTELL
"\"No subs are stationed here at the " D ,AQUADOME ", " FN ".\"" CR>)
	      (<AND <DOBJ? DISTRESS-CALL>
		    <OR <VERB? SEND>
			<AND <VERB? SEND-TO> <IOBJ? GLOBAL-SUB>>>>
	       %<XTELL
"\"No response to our " D ,SONARPHONE " " D ,DISTRESS-CALL "s.\"" CR>)
	      (<AND <DOBJ? GLOBAL-SUB>
		    <OR <VERB? FIND>
			<AND <VERB? FIND-WITH> <IOBJ? GLOBAL-SONAR>>>>
	       %<XTELL
"\"Sonar pulses show no echo blips on the " D ,SONARSCOPE ".\"" CR>)
	      (<OR <VERB? LEAVE DISEMBARK>
		   <AND <VERB? COME>
			<DOBJ? GLOBAL-SURFACE YOUR-LABORATORY GLOBAL-HERE>>>
	       %<XTELL
"\"Our emergency escape bell would be vulnerable to a monster
as big as the Snark. Ditto for SCUBA gear, deep-sea diving suits, or
jet-propelled observation bubbles.\"" CR>)
	      (<VERB? ASK-ABOUT ASK-FOR>
	       <TELL <PICK-ONE ,WHY-ME> CR>
	       <RFATAL>)
	      (<AND <VERB? REPLY TELL ;TELL-ABOUT>
		    <DOBJ? PLAYER>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK ,GLOBAL-BLY>
	       <RTRUE>)
	      (<OR <AND <VERB? WAIT-FOR> ;<EQUAL? ,PRSO <> ,PLAYER>>
		   <AND <VERB? FIND ;"LOOK FOR"> <DOBJ? PLAYER>>>
	       %<XTELL "\"Okay, "FN", but hurry!\"" CR>)
	      (<SET X <COM-CHECK ,GLOBAL-BLY>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<AND <EQUAL? ,REMOTE-PERSON ,GLOBAL-BLY>
	     <OR <AND ,PRSI <SET OBJ ,PRSI>
		      <DOBJ? GLOBAL-BLY> <VERB? CONFRONT ASK-ABOUT>>
		 <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		      <VERB? FIND WHAT>>>>
	;<COND (<NOT <GRAB-ATTENTION ,GLOBAL-BLY>> <RTRUE>)>
	<SAID-TO ,GLOBAL-BLY>
	<COND ;(<EQUAL? .OBJ ,GLOBAL-BLY>
	       <TELL 
"\"I'm the commander of the " ,URS ". If you want to
know more, look in the personnel file.\"" CR>)
	      (<EQUAL? .OBJ ,PROBLEM>
	       <COND (<EQUAL? .L ,SUB>
		      %<XTELL
"\"I'll tell you when we can talk privately.\"" CR>)
		     ;(,MONSTER-GONE
		      <MIKE-2-F>
		      <TELL
" We're working to repair the damage, but the Snark may return and
attack at any time!
" FN ", the Snark looks like a creature of the abyssal deep.\"" CR>
		      <PERFORM ,V?TELL-ABOUT ,GLOBAL-BLY ,GLOBAL-SUB>
		      <RTRUE>)
		     (T
		      ;<SETG BLY-TOLD-PROBLEM T>
		      ;<FCLEAR ,GLOBAL-SNARK ,INVISIBLE>
		      <TELL "\"">
		      <BLY-TELLS-PROBLEM>)>)
	      (<EQUAL? .OBJ ,GLOBAL-SNARK>
	       <COND (<EQUAL? ,REMOTE-PERSON-ON ,SONARPHONE>
		      <MOVE ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
		      <INC BLY-PRIVATELY-COUNT>
		      %<XTELL
"\"There have been no new attacks, "FN". But the creature may come back. And">
		      <DISCUSS-PRIVATE>)
		     (T
		      %<XTELL
"\"Some of our divers saw it while exploring the undersea environment. They
nicknamed it the Snark. This is the first time it has approached the " D ,AQUADOME ",
and it may be the last time, " FN "! I'm not sure how long our plastic dome
enclosure c">
		      <COND (,MONSTER-GONE <TELL "ould">) (T <TELL "an">)>
		      %<XTELL " withstand such a battering!\"" CR>)>
	       <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,GLOBAL-BLY .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T
	       <DONT-KNOW ,GLOBAL-BLY .OBJ>)>)
       (<VERB? ASK $CALL>
	<TELL "\"Ask me about something in particular, "FN".\"" CR>)
       (<AND ,WOMAN-ON-SCREEN <VERB? EXAMINE>>
	%<XTELL "You can't tell who the woman is." CR>)
       (<AND <DOBJ? GLOBAL-BLY>
	     <VERB? HELLO>
	     <EQUAL? ,REMOTE-PERSON-ON ,SONARPHONE ,INTERCOM>>
	%<XTELL "You hear " D ,PRSO " nodding at you." CR>)
       (<AND <VERB? GOODBYE>
	     ;<EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE>>
	<TELL "\"I hope to see you soon, " FN ".\"" CR>
	<COND (<EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE> <I-SHARON-TO-HALLWAY>)>
	<PHONE-OFF>
	<RTRUE>)
       (<AND <DOBJ? GLOBAL-BLY> <VERB? LISTEN REPLY>>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (<AND <DOBJ? GLOBAL-BLY>
	     <VERB? PHONE ;$CALL>
	     <NOT <EQUAL? ,HERE ,SUB ,CRAWL-SPACE>>
	     <NOT ,SUB-IN-DOME ;<IN-DOME? ,HERE>>>
	<RFALSE>)
       (<AND <DOBJ? GLOBAL-BLY> <VERB? READ>>
	%<XTELL
"That's just a figure of speech! Try the command: BLY, HELLO." CR>)
       (<VERB? TELL-ABOUT>
	<COND (<IOBJ? GLOBAL-SUB>
	       %<XTELL
"\"The only submarine capable of hunting it at such depths is
your " D ,GLOBAL-SUB ". Please send us that!\"" CR>)>)
       (<COMMON-OTHER ,GLOBAL-BLY> <RTRUE>)
       (T <GLOBAL-PERSON>)>>

<OBJECT BLY
	(IN FOOT-OF-RAMP)
	(DESC "Commander Bly")
	(ADJECTIVE	COMMANDER ZOE)
	(SYNONYM	COMMANDER ZOE BLY)
	(FLAGS PERSON FEMALE TOUCHBIT ;OPENBIT)
	(CAPACITY 40)
	(ACTION BLY-F)
	(DESCFCN BLY-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(VALUE 5)
	(CHARACTER 5)>

<GLOBAL BLY-SAW-PHOTO <>>
<GLOBAL ZOE-BLUSHING <>>
<GLOBAL ANTRIM-EXPLODED <>>

<ROUTINE BLY-F ("OPTIONAL" (ARG <>) "AUX" OBJ (L <LOC ,BLY>) X)
 <COND (<==? .ARG ,M-OBJDESC>
	<DESCRIBE-COLLAPSE ,BLY>)
       (<AND ,DOME-AIR-BAD? <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	%<XTELL
"\"Never mind me, " FN "!\" she cries. \"S-S-Something's wrong with the "
D ,AIR-SUPPLY-SYSTEM "! ... F-Fix it -- or we'll all s-s-soon be ...\"" CR>
	<RFATAL>)
       (<==? ,WINNER ,BLY>
	;<FSET ,BLY ,TOUCHBIT>
	<COND (<NOT <GRAB-ATTENTION ,BLY>> <RTRUE>)
	      (<AND <VERB? FIND> <DOBJ? PHOTO> <NOT ,BLY-SAW-PHOTO>>
	       %<XTELL
"\"It's either on his person or in his locker, in the
dormitory.\"" CR>)
	      (<AND <VERB? GIVE> <DOBJ? JOB> <IOBJ? SIEGEL GLOBAL-SIEGEL>>
	       <TELL "\"I'll have him check the " D ,SONAR-EQUIPMENT ". Okay?\"">
	       <COND (<YES?> <ZOE-SENDS-MARV ,COMM-BLDG> <RTRUE>)>
	       <TELL
"\"Should I give him some chore that's close to the " D ,SONAR-EQUIPMENT " so he
can keep an eye on it?\"">
	       <COND (<YES?>
		      <ZOE-SENDS-MARV ,COMM-BLDG>
		      <RTRUE>)>
	       <TELL
"\"Then somewhere out of sight of the " D ,COMM-BLDG "? That's
where the " D ,SONAR-EQUIPMENT "is.\"">
	       <COND (<YES?>
		      <SETG SIEGEL-OUT-OF-SIGHT T>
		      <ZOE-SENDS-MARV ,AIRLOCK>
		      <RTRUE>)
		     (T <TELL
"\"Then, you'd better do it, " FN ".\"" CR>)>)
	      (<AND <VERB? PUT TIE-TO>
		    <DOBJ? BLACK-BOX>
		    <IOBJ? GLOBAL-SONAR SONAR-EQUIPMENT>>
	       <MOVE ,BLACK-BOX ,SONAR-EQUIPMENT>
	       <TELL "\"Wilco, " FN ". Consider it done.\"" CR>)
	      (<AND <VERB? READ EXAMINE> <DOBJ? DIARY>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,BLY ,DIARY>
	       <RTRUE>)
	      (<AND <VERB? SHOW> <DOBJ? PLAYER> <IOBJ? EVIDENCE>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,BLY ,PRSI>
	       <RTRUE>)
	      (<OR <AND <DOBJ? PLAYER>
			<==? ,P-ADVERB ,W?PRIVATELY>
			<OR <VERB? TELL>
			    <AND <VERB? TELL-ABOUT> <IOBJ? PRIVATE-MATTER>>>>>
	       <SETG WINNER ,PLAYER>
	       <ASK-BLY-ABOUT-PRIVATE-MATTER>
	       <RTRUE>)
	      (<AND <VERB? ASK> <DOBJ? PLAYER> <I-BLY-SAYS T>>
	       <RTRUE>)
	      (<AND <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT> <EXIT-VERB?>>
	       <TELL "\"Not now, "FN".\"" CR>)
	      (<SET X <COM-CHECK ,BLY>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <VERB? ASK>
	    <AND <DOBJ? BLY> <VERB? TELL> <==? ,P-ADVERB ,W?PRIVATELY>>>
	<ASK-BLY-ABOUT-PRIVATE-MATTER>
	<RTRUE>)
       (<AND <VERB? ASK-ABOUT TELL-ABOUT>
	     <IOBJ? GLOBAL-SUB LOCAL-SUB VOLTAGE-REGULATOR OVERHEATING
		    CONTROL-CIRCUITS CONTROL-CIRCUITS-GAUGE>>
	%<XTELL
"\"You mean the problem you had on the way here? Shall I ask Mick to
check on it?\"">
	<COND (<NOT <YES?>> <RTRUE>)>
	<MOVE ,ANTRIM ,HERE>
	<SETG WINNER ,ANTRIM>
	<PERFORM ,V?FIX ,GLOBAL-SUB>
	<RTRUE>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <DOBJ? BLY> <VERB? CONFRONT ASK-ABOUT>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,BLY>> <RTRUE>)>
	<SAID-TO ,BLY>
	<FSET ,BLY ,TOUCHBIT>
	<COND (<EQUAL? .OBJ ,PRIVATE-MATTER ;,PROBLEM>
	       <ASK-BLY-ABOUT-PRIVATE-MATTER>)
	      (<EQUAL? .OBJ ,PROBLEM>
	       <COND (<AND ,DOME-AIR-BAD? <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
		      <BADGES-RED>
		      <RTRUE>)
		     (<NOT ,ZOE-MENTIONED-EVIDENCE>
		      <SETG WINNER ,PLAYER>
		      <ASK-BLY-ABOUT-PRIVATE-MATTER>
		      <RTRUE>)
		     (<AND <EQUAL? ,HERE ,BLY-OFFICE>
			   ,ZOE-BLUSHING>
		      <DOC-IN-LOVE>)
		     (T
		      <TELL
"\"I'm worried that the " D ,SNARK " may attack again, "FN".\"" CR>
		      ;<DONT-KNOW ,BLY .OBJ>)>)
	      (<EQUAL? .OBJ ,DIARY>
	       %<XTELL "\"I think that I can guess what's in it.\"" CR>)
	      (<EQUAL? .OBJ ,REASON ,PHOTO>
	       <COND (<EQUAL? .OBJ ,PHOTO> <SETG BLY-SAW-PHOTO T>)>
	       <DISCRETION ,BLY ,HORVAK>
	       %<XTELL
"\"A friend took a picture of me just before I was assigned here.
I usually keep it on my desk, but a few days after Doc came on to me,
I realized it was gone.">
	       <COND (<NOT ,BLY-SAW-PHOTO>
		      <TELL " It still hasn't turned up.">)>
	       %<XTELL
" I think Doc took it. He wanted a picture of me.\"" CR>)
	      (<EQUAL? .OBJ ,EVIDENCE ,BLACK-BOX>
	       <COND (<NOT ,ZOE-MENTIONED-EVIDENCE>
		      <ASK-BLY-ABOUT-PRIVATE-MATTER>
		      <RTRUE>)>
	       %<XTELL
"\"I wanted to make sure the " D ,SONAR-EQUIPMENT " would warn us if the "
D ,SNARK "
approached again. I was worried because the blips on the scope looked fuzzy,
as if the system was out of alignment. When I inspected it, I found someone
had secretly attached ">
	       <COND (<NOT <IN? ,BLACK-BOX ,BLY-DESK>>
		      <TELL "th"
			    <COND (<IN? ,BLACK-BOX ,BLY> "is ") (T "at ")>
			    D ,BLACK-BOX>)
		     (T <TELL "this device">)>
	       <TELL " to it!\"" CR>
	       <COND (<IN? ,BLACK-BOX ,BLY-DESK> ;<NOT <META-LOC ,BLACK-BOX>>
		      <MOVE ,BLACK-BOX ,BLY>
		      <THIS-IS-IT ,BLACK-BOX>
		      <TELL
"Zoe takes a small \"" D ,BLACK-BOX "\" device from her desk drawer." CR>)>
	       <ENABLE <QUEUE I-TIP-SONAR-PLAN -1>>
	       <MOVE ,TIP-IDEA ,GLOBAL-OBJECTS>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,SIEGEL ,GLOBAL-SIEGEL>
	       <COND (<OR ,SIEGEL-TESTED
			  <FSET? ,SIEGEL ,BUSYBIT>
			  <IN? ,BLACK-BOX ,BLY-DESK>>
		      <DISCRETION ,BLY ,SIEGEL>
		      <TELL "\"">)
		     (T
		      <DISCRETION ,BLY ,SIEGEL ,ANTRIM>
		      %<XTELL
"\"I bet you're wondering if he could have attached that " D ,BLACK-BOX
" to the " D ,SONAR-EQUIPMENT ".|
I agree that he had the opportunity, but all I can say, " FN ", is that he's
no troublemaker like " D ,ANTRIM "." CR>)>
	       %<XTELL
"He's a great diver and a skilled electronics engineer.|
I think he really enjoys exploring the undersea
environment. He discovered that " D ,ORE-NODULES "
on the sea floor near the " D ,AQUADOME ".|
I have no reason to suspect him of trying to sabotage
the " ,URS " of " D ,IU-GLOBAL ".">
	       <COND (<OR ,SIEGEL-TESTED
			  <FSET? ,SIEGEL ,BUSYBIT>
			  <IN? ,BLACK-BOX ,BLY-DESK>>
		      <TELL "\"" CR>)
		     (T
		      %<XTELL
" But I do have a plan
that will help us find out. Do you want to hear it, " FN "?\"">
		      <MOVE ,BLY-PLAN ,GLOBAL-OBJECTS>
		      <COND (<NOT <YES?>> <RTRUE>)>
		      <TELL-HINT 13 ;18 ,SIEGEL <>>
		      ;<PERFORM ,V?ASK-ABOUT ,BLY ,BLY-PLAN>
		      <RTRUE>)>)
	      (<EQUAL? .OBJ ,BLY-PLAN>
	       <TELL-HINT 13 ;18 ,SIEGEL <>>)
	      (<EQUAL? .OBJ ,ANTRIM ,GLOBAL-ANTRIM>
	       %<XTELL
"Just hearing Antrim's name makes her eyes flash fire, and she
clenches her fists. You can tell she's had a hard time keeping her
temper when dealing with Antrim.|">
	       <DISCRETION ,BLY ,ANTRIM>
	       %<XTELL
"\"" FN ", that redheaded troublemaker's been nothing but bad news since
the day I arrived! He's always got a chip on his shoulder and looks
for ways to embarrass me or start a fight.">
	       <COND (,ANTRIM-EXPLODED
		      <TELL
" You heard his remarks about the " D ,OXYGEN-GEAR ".">)>
	       %<XTELL
" Most of
the time he complains about discipline, but whenever I ease up he's always the
first to accuse me of laxity!\"" CR>)
	      (<EQUAL? .OBJ ,ORE-NODULES>
	       %<XTELL
"\"Oops, I forgot you hadn't heard about it, " FN ". I was
about to report it when we were attacked.
" D ,SIEGEL " discovered it by accident. The ore is mostly
manganese and iron, but there's gold and platinum, and there may
be traces of rare earths, too.
This could be the richest payoff yet from the " D ,AQUADOME "!\"" CR>)
	      (<EQUAL? .OBJ ,SPECIAL-TOOL ;,SPECIAL-TOOL-GLOBAL>
	       %<XTELL "\"That belongs on the " D ,HOOK "!">
	       <COND (<IN? ,SPECIAL-TOOL ,BLY-OFFICE>
		      <TELL
" Why is it in my office? It hasn't been there long! When I ">
		      <COND (<EQUAL? ,HERE ,BLY-OFFICE> <TELL "came back ">)
			    (T <TELL "went back t">)>
		      %<XTELL ;"that black box"
"here to put something
in a drawer, I knocked a pen off my desk.
I had to stoop down to find it. Had that wrench
been lying under my desk, I would have seen it!">)>
	       <TELL "\"" CR>)
	      (<EQUAL? .OBJ ,GLOBAL-HORVAK ,HORVAK>
	       <COND (<NOT ;,DOME-AIR-CRIME <FSET? ,SPECIAL-TOOL ,TOUCHBIT>>
		      <DOC-IN-LOVE>)
		     (T
		      <SETG ZOE-BLUSHING T>
		      <DISCRETION ,BLY ,HORVAK>
		      <TELL "\"I bet you're wondering if he">
		      <COND (<NOT ,HORVAK-FIXED-AIR>
			     <TELL " ditched the wrench there after he">)>
		      <TELL " sabotaged the " D ,AIR-SUPPLY-SYSTEM "?">
		      <COND (<NOT ,HORVAK-FIXED-AIR>
			     <TELL
" He had the opportunity: he could have tossed it there when he came to
get my " D ,OXYGEN-GEAR ". But">)>
		      <TELL
" I just can't BELIEVE Doc would cut off our air supply!\"|
Zoe blushes and her voice trembles with emotion as she speaks." CR>)>)
	      (<OR <EQUAL? .OBJ ,LOWELL ,GLOBAL-LOWELL>
		   <AND <EQUAL? .OBJ ,GREENUP ,GLOBAL-GREENUP>
			<NOT ,GREENUP-GUILT>>>
	       <TELL "\"">
	       <HE-SHE-IT .OBJ T>
	       <TELL "'s an excellent diver.\"" CR>)
	      (<EQUAL? .OBJ ,GREENUP ,GLOBAL-GREENUP>
	       %<XTELL "\"I never would have suspected him!\"" CR>)
	      (<AND <NOT <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
		    <EQUAL? .OBJ ,AIR-SUPPLY-SYSTEM ,AIR-SUPPLY-SYSTEM-GLOBAL
				 ,GLOBAL-SABOTAGE>>
	       <COND (<IN? ,CREW ,HERE>
		      %<XTELL
"Zoe shoots a troubled glance at her five crew members.|">)>
	       %<XTELL
"\"Once we saw your " D ,SEARCH-BEAM " beam, " FN ", we were all
watching for your arrival outside the dome. Any one of us could have
tampered with the " D ,AIR-SUPPLY-SYSTEM " without being noticed.\"|
">
	       <TIP-SAYS>
	       <TELL
"One thing's for sure. Whoever did it
also took that " D ,SPECIAL-TOOL "!\"|">
	       <COND (<IN? ,ANTRIM ,HERE>
		      <SETG ANTRIM-EXPLODED T>
		      %<XTELL
D ,ANTRIM " explodes: \"That shows you what kind of a commander Bly is!
Regulations state that EVERYONE has to wear " D ,OXYGEN-GEAR " all the time.
But neither of those two divers were wearing theirs! Bly wasn't even wearing
HER OWN!\"" CR>)>
	       <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,BLY .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,BLY .OBJ>)>)
       (<COMMON-OTHER ,BLY> <RTRUE>)>>

<ROUTINE ASK-BLY-ABOUT-PRIVATE-MATTER ()
	<QUEUE I-BLY-PRIVATELY 0>
	<COND (<EQUAL? ,HERE ,BLY-OFFICE>
	       <ZOE-MENTIONS-EVIDENCE>
	       <RTRUE>)>
	<TELL "\"Come to my office" ", " FN ".\"|
">
	<COND (<AND <NOT ,DOME-AIR-BAD?>
		    <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	       <MOVE ,ANTRIM ,HERE>
	       %<XTELL
"As you turn to leave with " D ,BLY ", " D ,ANTRIM " explodes
angrily:|
\"What's so private, 'Captain Bly'? If you have a complaint, why not spill
it now? Or are you afraid we might complain about YOU?!\"|
Before you can say anything, Zoe yells:|
\"That's enough, Antrim! Maybe I have some complaints about the way
the crew performs. When I make any about you, or hand out disciplinary
action, you'll be the first to -- to --\"|
">
	       <I-DOME-AIR T>)
	      (T
	       <MOVE ,BLY ,BLY-OFFICE>
	       <FSET ,BLY ,NDESCBIT>
	       <SETG WINNER ,PLAYER>
	       <GOTO ,BLY-OFFICE>
	       ;<RTRUE>)>>

<ROUTINE DOC-IN-LOVE ()
	<DISCRETION ,BLY ,HORVAK>
	%<XTELL
"\"This is embarrassing. Doc's in love with me, or so he says.|
When he said he loved me, I didn't handle it well. I lost my poise
and told him this was a scientific research station,
not a singles resort, and that I was his commanding officer -- so
cut the romantic stuff and go back to work.|
">
	<COND (<FSET? ,SPECIAL-TOOL ,TOUCHBIT>
	       <MOVE ,REASON ,GLOBAL-OBJECTS>
	       <TELL
"Maybe you'll say Doc was angry over that, and hurting the "
D ,AIR-SUPPLY-SYSTEM " was his way of getting revenge. But I don't think
so. I've reason to think he still loves me.|
">)>
	<TELL "Anyhow, if ">
	<COND (<FSET? ,SPECIAL-TOOL ,TOUCHBIT>
	       <TELL "you still suspect him, and ">)>
	<TELL
"you want another slant on what makes him tick, you should talk to his "
D ,LAB-ASSISTANT ".\"" CR>>

<ROUTINE ZOE-SENDS-MARV (PLACE)
	<TELL "\"Wilco, " FN ".">
	<COND (<NOT ,SIEGEL-OUT-OF-SIGHT>
	       <TELL
" I'm afraid he may have seen me going there to put the " D ,BLACK-BOX
" on the " D ,SONAR-EQUIPMENT ".">)>
	<MOVE ,SIEGEL .PLACE>
	<COND (<AND <==? .PLACE ,COMM-BLDG>
		    <IN? ,BLACK-BOX ,SONAR-EQUIPMENT>>
	       <FSET ,SIEGEL ,BUSYBIT>
	       <ENABLE <QUEUE I-SIEGEL-REPORTS 4>>)>
	<TELL "\"" CR "Zoe sends " D ,SIEGEL " into the " D .PLACE "." CR>>

<ROUTINE IS-CREW? (PERSON)
	<OR <EQUAL? .PERSON ,LOWELL ,ANTRIM ,HORVAK>
	    <EQUAL? .PERSON ,SIEGEL ,GREENUP>>>

<ROUTINE CREW-5-TOGETHER? ("AUX" (L <LOC ,LOWELL>))
 <COND (<AND <==? .L <LOC ,ANTRIM>>
	     <==? .L <LOC ,HORVAK>>
	     <==? .L <LOC ,SIEGEL>>
	     <==? .L <LOC ,GREENUP>>>
	<MOVE ,CREW .L>
	<RTRUE>)
       (T
	<REMOVE ,CREW ;,GLOBAL-OBJECTS>
	<RFALSE>)>>

<OBJECT GLOBAL-ANTRIM
	(IN GLOBAL-OBJECTS)
	(DESC "Mick Antrim")
	(ADJECTIVE MICK)
	(SYNONYM MICK ANTRIM)
	(FLAGS PERSON)
	(CHARACTER 6)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-PERSON)>

<OBJECT ANTRIM
	(IN FOOT-OF-RAMP)
	(DESC "Mick Antrim")
	(ADJECTIVE MICK)
	(SYNONYM MICK ANTRIM)
	(FLAGS PERSON TOUCHBIT)
	(CHARACTER 6)
	(ACTION ANTRIM-F)
	(DESCFCN ANTRIM-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL ASKED-ANTRIM <>>
<GLOBAL ANTRIM-CHECKED-SUB <>>

<ROUTINE ANTRIM-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,ANTRIM>))
 <COND (<==? .ARG ,M-OBJDESC>
	<COND (<IN? ,ANTRIM ,AIRLOCK>
	       <DESCRIBE-PERSON ,ANTRIM "working on the SCIMITAR">)
	      (T <DESCRIBE-COLLAPSE ,ANTRIM>)>
	<RTRUE>)
       (<==? ,WINNER ,ANTRIM>
	<COND (<NOT <GRAB-ATTENTION ,ANTRIM>> <RTRUE>)
	      (<AND <VERB? ADJUST ANALYZE EXAMINE FIX>
		    <DOBJ? GLOBAL-SUB LOCAL-SUB VOLTAGE-REGULATOR OVERHEATING
			   CONTROL-CIRCUITS CONTROL-CIRCUITS-GAUGE>>
	       <COND (,ANTRIM-CHECKED-SUB
		      %<XTELL "\"I already did that!\"" CR>
		      <RTRUE>)>
	       <MOVE ,BLY ,HERE>
	       <SETG ASKED-ANTRIM T>
	       <I-ANTRIM-TO-SUB "\"Wilco, ">
	       %<XTELL
"But " D ,BLY " has heard your order. \"Please remember, " FN ",\"
she says, \"while Mick is working on your " D ,SUB ", it'll
be out of action. The " D ,SNARK " may return at any time, and we'll
be defenseless! Are you sure you want to repair the
" D ,SUB " now?\"">
	       <COND (<YES?>
		      <COND (<OR <NOT <==? ,BAZOOKA <GET ,ON-SUB 0>>>
				 <NOT <==? ,DART <GET ,ON-SUB 1>>>>
			     %<XTELL
"\"Then why not use the time to arm the " D ,SUB>
			     <COND (<OR <==? ,BAZOOKA <GET ,ON-SUB 0>>
					<==? ,DART <GET ,ON-SUB 1>>>
				    <TELL " better">)>
			     %<XTELL "?\" Zoe goes on." CR>
			     <COND (<NOT <==? ,BAZOOKA <GET ,ON-SUB 0>>>
				    <TELL-HINT 73 ;22 ,CLAW <>>)>
			     <COND (<NOT <==? ,DART <GET ,ON-SUB 1>>>
				    <TELL-HINT 72 ;23 ,DART ;<>>)>
			     <SETG BLY-PRIVATELY-DELAY T>
			     %<XTELL "|
\"If you want to consider your options">
			     %<XTELL ", let's go to">
			     <COND (<NOT <==? ,DART <GET ,ON-SUB 1>>>
				    <TELL " the " D ,DOME-LAB>)
				   (<NOT <==? ,BAZOOKA <GET ,ON-SUB 0>>>
				    <TELL THE <LOC ,BAZOOKA>>)>
			     <TELL ".\"" CR>)>)>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,ANTRIM>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      ;(<VERB? HELP> <RFALSE>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? ANTRIM>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,ANTRIM>> <RTRUE>)>
	<SAID-TO ,ANTRIM>
	<COND (<EQUAL? .OBJ ,GLOBAL-BLY>
	       %<XTELL
"\"What a slave driver! Sometimes I call her 'Captain Bly'!\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,ANTRIM .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,ANTRIM .OBJ>)>)
       (<COMMON-OTHER ,ANTRIM> <RTRUE>)>>

<OBJECT GLOBAL-HORVAK
	(IN GLOBAL-OBJECTS)
	(DESC "Doc Horvak")
	(ADJECTIVE DOCTOR DOC WALT DR)
	(SYNONYM DOC WALT HORVAK MEDIC)
	(FLAGS PERSON)
	(CHARACTER 7)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-PERSON)>

<OBJECT HORVAK
	(IN FOOT-OF-RAMP)
	(DESC "Doc Horvak")
	(ADJECTIVE DOCTOR DOC WALT DR)
	(SYNONYM DOC WALT HORVAK MEDIC)
	(FLAGS PERSON TOUCHBIT)
	(CHARACTER 7)
	(ACTION HORVAK-F)
	(DESCFCN HORVAK-F)
	(VALUE 5)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<ROUTINE HORVAK-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,HORVAK>))
 <COND (<==? .ARG ,M-OBJDESC>
	<DESCRIBE-COLLAPSE ,HORVAK>)
       (<==? ,WINNER ,HORVAK>		;"? embarrassed if given diary?"
	<COND (<NOT <GRAB-ATTENTION ,HORVAK>> <RTRUE>)
	      (<AND <VERB? ANALYZE EXAMINE FIX>
		    <DOBJ? SYRINGE ESCAPE-POD-UNIT>>
	       <MOVE ,SYRINGE ,HORVAK>
	       <FCLEAR ,SYRINGE ,TAKEBIT>
	       <FSET ,HORVAK ,BUSYBIT>
	       <ENABLE <QUEUE I-ANALYSIS 4>>
	       <COND (<NOT <IN? ,HORVAK ,DOME-LAB>>
		      <MOVE ,HORVAK ,DOME-LAB>
		      <TELL "He heads for the " D ,DOME-LAB ". ">)>
	       %<XTELL
"It will take " D ,HORVAK " 4 turns to analyze the chemical contents of"
THE-PRSO "." CR>)
	      (<AND <VERB? FIX TAKE> <DOBJ? DART>>
	       <FCLEAR ,PRSO ,NDESCBIT>
	       <COND (<VERB? TAKE>
		      <MOVE ,PRSO ,HORVAK>
		      <TELL "\"Okay.\"" CR>)
		     (T <FIX-DART>)>)
	      (<OR <AND <DOBJ? HORVAK-LOCKER>	<VERB? OPEN>>
		   <AND <DOBJ? HORVAK-KEY>	<VERB? GIVE>>
		   <AND <IOBJ? HORVAK-KEY>	<VERB? SGIVE>>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?SEARCH ,HORVAK>
	       <RTRUE>)
	      (<AND <VERB? ANALYZE EXAMINE READ> <DOBJ? MAGAZINE ARTICLE>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,HORVAK ,MAGAZINE>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,HORVAK>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      ;(,PRSO
	       <TELL "\"I'm a doctor, not " A ,PRSO " ">
	       <VERB-PRINT>
	       <TELL "er!\"" CR>)
	      ;(<VERB? HELP> <RFALSE>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? HORVAK>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,HORVAK>> <RTRUE>)>
	<SAID-TO ,HORVAK>
	<COND (<EQUAL? .OBJ ,SPECIAL-TOOL ,SPECIAL-TOOL-GLOBAL>
	       <COND (,HORVAK-FIXED-AIR
		      %<XTELL
"\"I found it in the " D ,BLY-OFFICE ", "FN", when I ran in there to get
her " D ,OXYGEN-GEAR ". I spotted it under her desk.\"" CR>)
		     (T <DONT-KNOW-ANYTHING>)>)
	      (<EQUAL? .OBJ ,BLY ,GLOBAL-BLY>
	       <COND (<IN? ,REASON ,GLOBAL-OBJECTS>
		      <TELL
"\"It's true. I can't hide my love for her any longer.\"" CR>)
		     (T <TELL "\"I have no complaints.\"" CR>)>)
	      (<EQUAL? .OBJ ,HORVAK-LOCKER ,HORVAK-KEY>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?SEARCH ,HORVAK>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,PHOTO>
	       %<XTELL "\"I took it because I wanted a picture of her.\"" CR>)
	      (<EQUAL? .OBJ ,SYRINGE ,ESCAPE-POD-UNIT>
	       <COND (,GREENUP-GUILT
		      %<XTELL
"\"" FN ", the " D ,SYRINGE " contains a lot of arsenic, and some arsenic is
missing from my " D ,CHEMICAL-SUPPLY-SHELVES "! If you'd been jabbed with that
" D ,SYRINGE ", you'd be dead!\"" CR>)
		     (T
		      <SETG WINNER ,HORVAK>
		      <PERFORM ,V?ANALYZE ,SYRINGE>
		      <RTRUE>)>)
	      (<AND <EQUAL? .OBJ ,MAGAZINE ,ARTICLE> <FSET? ,DART ,MUNGBIT>>
	       %<XTELL
"Doc quickly reads the " D ,ARTICLE ", then flashes you an excited glance.|
\"" FN ", Thorpe's sea creatures evolved from AMINO-HYDROPHASE. If the
Snark's his creation, then I know exactly what drug will
tranquilize it! Shall I make some up?\"">
	       <COND (<NOT <YES?>> <RTRUE>)>
	       <FIX-DART>
	       <COND (<==? ,BAZOOKA <GET ,ON-SUB 0>>
		      <RTRUE>)
		     (<NOT <EQUAL? <META-LOC ,BLY> ,HERE>>
		      <RTRUE>)>
	       %<XTELL
D ,BLY " still looks worried.
\"" FN ", you should have a really high-powered weapon, too. You may run up
against an enemy sub, if Thorpe himself is operating around here. Can you
think of any device to use as a weapon of last resort?\"">
	       <COND (<YES?>
		      %<XTELL
"\"Show me what device you have in mind, " FN ".\"" CR>
		      <RTRUE>)>
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT> <RTRUE>)>
	       <SAID-TO ,TIP>
	       <THIS-IS-IT ,BAZOOKA>
	       %<XTELL "Once again, Tip has an idea." CR>
	       <TELL-HINT 71 ;15 ,BAZOOKA ;<>>
	       %<XTELL
"\"Shall I have it mounted on the other " D ,CLAW " of the
" D ,SUB "?\"">
	       <COND (<YES?>
		      <MOUNT-WEAPON ,BAZOOKA>
		      ;<SCORE-OBJ ,BAZOOKA>
		      <FINE-SEQUENCE>)>
	       <RTRUE>)
	      (<SET X <COMMON-ASK-ABOUT ,HORVAK .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,HORVAK .OBJ>)>)
       (<AND <VERB? GIVE>
	     <IN? ,PRSO ,PLAYER>
	     <IOBJ? HORVAK>>
	<COND (<DOBJ? MAGAZINE>
	       <MOVE ,PRSO ,HORVAK>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,HORVAK ,MAGAZINE>
	       <RTRUE>)
	      (<DOBJ? SYRINGE>
	       <MOVE ,PRSO ,HORVAK>
	       <TELL "\"Want me to analyze this, "FN"?\"">
	       <COND (<YES?>
		      <SETG WINNER ,HORVAK>
		      <PERFORM ,V?ANALYZE ,SYRINGE>
		      <RTRUE>)>)>)
       (<VERB? SEARCH>
	%<XTELL
"\"Certainly not! The contents of my locker are my private property!\"" CR>)
       (<COMMON-OTHER ,HORVAK> <RTRUE>)>>

<ROUTINE FIX-DART ()
 <COND (<NOT <FSET? ,DART ,MUNGBIT>>
	%<XTELL "\"Hey, I already did that!\"" CR>)
       (T
	<MOVE ,HORVAK ,DOME-LAB>
	<MOVE ,DART ,HORVAK>
	<ENABLE <QUEUE I-SYNTHESIS 5>>
	<FSET ,HORVAK ,BUSYBIT>
	%<XTELL "This will take 5 turns." CR>)>>

<OBJECT GLOBAL-SIEGEL
	(IN GLOBAL-OBJECTS)
	(DESC "Marv Siegel")
	(ADJECTIVE MARV SONAR ELECTR)
	(SYNONYM MARV SIEGEL ;MAN OPERATOR EXPERT)
	(FLAGS PERSON)
	(CHARACTER 8)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-PERSON)>

<OBJECT SIEGEL
	(IN FOOT-OF-RAMP)
	(DESC "Marv Siegel")
	(ADJECTIVE MARV SONAR ELECTR)
	(SYNONYM MARV SIEGEL ;MAN OPERATOR EXPERT)
	(FLAGS PERSON TOUCHBIT)
	(CHARACTER 8)
	(ACTION SIEGEL-F)
	(DESCFCN SIEGEL-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL SIEGEL-OUT-OF-SIGHT <>>

<ROUTINE SIEGEL-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,SIEGEL>))
 <COND (<==? .ARG ,M-OBJDESC>
	<COND (<FSET? ,SIEGEL ,BUSYBIT>
	       <DESCRIBE-PERSON ,SIEGEL "working on the sonar equipment">)
	      (T <DESCRIBE-COLLAPSE ,SIEGEL>)>)
       (<==? ,WINNER ,SIEGEL>
	<COND (<NOT <GRAB-ATTENTION ,SIEGEL>> <RTRUE>)
	      (<AND <VERB? ADJUST ANALYZE EXAMINE FIX>
		    <DOBJ? GLOBAL-SONAR SONAR-EQUIPMENT>>
	       <COND ;(<NOT ,SIEGEL-OUT-OF-SIGHT>	;"[does this work?]"
		      <TELL
"\"Okay, if you say so, " FN ". But I just noticed " D ,BLY " going
in the " D ,COMM-BLDG " a little while ago. She may have checked
it out. But I'll double-check it anyhow.\"" CR>)
		     (T
		      %<XTELL
"\"Right, " FN ". No doubt you're testing all systems. I'll ">
		      <COND (<NOT <EQUAL? ,HERE ,COMM-BLDG>>
			     <TELL "report back and ">)>
		      <TELL"let you know if the sonar's working okay.\"" CR>)>
	       <MOVE ,SIEGEL ,COMM-BLDG>
	       <FSET ,SIEGEL ,BUSYBIT>
	       <ENABLE <QUEUE I-SIEGEL-REPORTS 4>>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,SIEGEL>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      ;(<VERB? HELP> <RFALSE>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? SIEGEL>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,SIEGEL>> <RTRUE>)>
	<SAID-TO ,SIEGEL>
	<COND (<EQUAL? .OBJ ,GLOBAL-SONAR ,SONAR-EQUIPMENT ,SONAR-MAN>
	       %<XTELL "\"I operate the " D ,SONAR-EQUIPMENT ".\"" CR>)
	      (<==? .OBJ ,BLACK-BOX>
	       <COND (<AND <FSET? ,SIEGEL ,BUSYBIT> <I-SIEGEL-REPORTS>>
		      <RTRUE>)
		     (T <TELL "\""> <SIEGEL-BOX> <RTRUE>)>)
	      (<SET X <COMMON-ASK-ABOUT ,SIEGEL .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,SIEGEL .OBJ>)>)
       (<COMMON-OTHER ,SIEGEL> <RTRUE>)>>

<OBJECT GLOBAL-GREENUP
	(IN GLOBAL-OBJECTS)
	(DESC "Bill Greenup")
	(ADJECTIVE BILL)
	(SYNONYM BILL GREENUP DIVER TECHNICIAN)
	(FLAGS PERSON)
	(CHARACTER 9)
	(VALUE 5)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-PERSON)>

<OBJECT GREENUP
	(IN FOOT-OF-RAMP)
	(DESC "Bill Greenup")
	(ADJECTIVE BILL)
	(SYNONYM BILL GREENUP DIVER TECHNICIAN)
	(FLAGS PERSON TOUCHBIT)
	(CHARACTER 9)
	(ACTION GREENUP-F)
	(DESCFCN GREENUP-F)
	(VALUE 5)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<GLOBAL GREENUP-ESCAPE <>>	"trying to escape"
<GLOBAL GREENUP-TRAPPED <>>	"trapped in ,AIRLOCK"
<GLOBAL GREENUP-CUFFED <>>	"handcuffed"

<ROUTINE GREENUP-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,GREENUP>))
 <COND (<==? .ARG ,M-OBJDESC>
	<COND (,GREENUP-CUFFED
	       <TELL "Greenup is handcuffed to a pipe." CR>)
	      (T <DESCRIBE-COLLAPSE ,GREENUP>)>)
       (<==? ,WINNER ,GREENUP>
	<COND (<NOT <GRAB-ATTENTION ,GREENUP>> <RTRUE>)
	      (<AND <MOUNTING-VERB? ,ESCAPE-POD-UNIT>
		    <FSET? ,ESCAPE-POD-UNIT ,TAKEBIT>>
	       <INSTALL-ESCAPE-POD-UNIT ,GREENUP>)
	      (<SET X <COM-CHECK ,GREENUP>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      ;(<VERB? HELP> <RFALSE>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? GREENUP>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,GREENUP>> <RTRUE>)>
	<SAID-TO ,GREENUP>
	<COND (<AND <EQUAL? .OBJ ,SYRINGE ,ESCAPE-POD-UNIT>
		    <IN? ,ESCAPE-POD-UNIT ,SUB>>
	       <COND (<AND ,GREENUP-GUILT
			   <NOT <FSET? ,GREENUP ,MUNGBIT>>>
		      <PERFORM ,V?ARREST ,GREENUP>
		      <RTRUE>)
		     (T
		      <DONT-KNOW-ANYTHING>
		      <RTRUE>)>)
	      (<AND <OR ,GREENUP-TRAPPED ,GREENUP-CUFFED>
		    ;<EQUAL? .OBJ ,MOTIVE ,SYRINGE ,ESCAPE-POD-UNIT>>
	       %<XTELL
"His only response is a sneer and silence." CR>)
	      (<SET X <COMMON-ASK-ABOUT ,GREENUP .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,GREENUP .OBJ>)>)
       (<VERB? ASK>
	<COND (,GREENUP-TRAPPED
	       <PERFORM ,V?ASK-ABOUT ,GREENUP ,MOTIVE>
	       <RTRUE>)>)
       (<COMMON-OTHER ,GREENUP> <RTRUE>)>>

<OBJECT GLOBAL-LOWELL
	(IN GLOBAL-OBJECTS)
	(DESC "Amy Lowell")
	(ADJECTIVE AMY)
	(SYNONYM AMY LOWELL DIVER TECHNICIAN)
	(FLAGS PERSON FEMALE VOWELBIT)
	(CHARACTER 10)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-PERSON)>

<OBJECT LOWELL
	(IN FOOT-OF-RAMP)
	(DESC "Amy Lowell")
	(ADJECTIVE AMY)
	(SYNONYM AMY LOWELL DIVER TECHNICIAN)
	(FLAGS PERSON FEMALE VOWELBIT TOUCHBIT)
	(CHARACTER 10)
	(ACTION LOWELL-F)
	(DESCFCN LOWELL-F)
	(TEXT "(You'll find that information in your SEASTALKER package.)")>

<ROUTINE LOWELL-F ("OPTIONAL" (ARG <>) "AUX" OBJ X (L <LOC ,LOWELL>))
 <COND (<==? .ARG ,M-OBJDESC>
	<DESCRIBE-COLLAPSE ,LOWELL>)
       (<==? ,WINNER ,LOWELL>
	<COND (<NOT <GRAB-ATTENTION ,LOWELL>> <RTRUE>)
	      (<VERB? FIND>
	       <COND (<DOBJ? DIARY>
		      <PERFORM ,V?ASK-ABOUT ,LOWELL ,DIARY>
		      <RTRUE>)>)
	      (<AND <MOUNTING-VERB? ,ESCAPE-POD-UNIT>
		    <FSET? ,ESCAPE-POD-UNIT ,TAKEBIT>>
	       <INSTALL-ESCAPE-POD-UNIT ,LOWELL>)
	      (<SET X <COM-CHECK ,LOWELL>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      ;(<VERB? HELP> <RFALSE>)
	      (T <TELL <PICK-ONE ,WHY-ME> CR> <RFATAL>)>)
       (<OR <AND ,PRSI <SET OBJ ,PRSI>
		 <VERB? ASK-ABOUT CONFRONT> <DOBJ? LOWELL>>
	    <AND ,PRSO <IN? ,PRSO ,GLOBAL-OBJECTS> <SET OBJ ,PRSO>
		 <VERB? FIND WHAT>>>
	<COND (<NOT <GRAB-ATTENTION ,LOWELL>> <RTRUE>)>
	<SAID-TO ,LOWELL>
	<COND (<EQUAL? .OBJ ,HORVAK ,GLOBAL-HORVAK>
	       <DISCRETION ,LOWELL ,HORVAK>
	       %<XTELL
"\"He's dedicated to scientific research. He's a great marine
biologist and enjoys his work here at the " D ,AQUADOME ", or he HAS enjoyed it
until recently.|
I don't know why, but " D ,HORVAK " has become moody and introverted.
I've seen him writing in a private diary.\"" CR>)
	      (<AND <EQUAL? .OBJ ,DIARY> <NOT <FSET? ,DIARY ,TOUCHBIT>>>
	       <DISCRETION ,LOWELL ,HORVAK>
	       %<XTELL
"\"It's not in the lab. " D ,HORVAK "'s always secretive about his diary.
He would never leave it around where anyone might find it. It's
probably in his locker, in the crew's dormitory.\"" CR>)
	      (<EQUAL? .OBJ ,LAB-ASSISTANT>
	       %<XTELL "\"I'm " D ,HORVAK "'s " D ,LAB-ASSISTANT ".\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,LOWELL .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW ,LOWELL .OBJ>)>)
       (<COMMON-OTHER ,LOWELL> <RTRUE>)>>

<OBJECT THORPE
	(DESC "Doctor Jerome Thorpe")
	(FLAGS PERSON)
	(CHARACTER 4)>

<OBJECT GLOBAL-THORPE
	(IN GLOBAL-OBJECTS)
	(DESC "Doctor Jerome Thorpe")
	(ADJECTIVE DOCTOR DR ;DOC JEROME)
	(SYNONYM JEROME THORPE)
	(FLAGS PERSON NDESCBIT)
	(CHARACTER 4)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION GLOBAL-THORPE-F)>

<ROUTINE GLOBAL-THORPE-F ()
 <COND (<OR <AND <VERB? AIM>			<DOBJ? DART BAZOOKA>>
	    <AND <VERB? SHOOT KILL ATTACK>	<IOBJ? DART BAZOOKA>>>
	<RFALSE>)
       (<AND <VERB? TELL-ABOUT> <DOBJ? PLAYER>>
	<COND (<IN? ,MAGAZINE ,PLAYER>
	       %<XTELL
"He is a noted marine biologist.|
The " D ,ARTICLE " mentions that he may have created synthetic
forms of sea life by genetic engineering.|
He can't be located to discuss this. He apparently has
gone into hiding to evade the resulting publicity.|
He has told close friends he will soon marry an American woman named
" D ,SHARON "." CR>)	;"He is a Cuban national.|"
	      (<FSET? ,MAGAZINE ,TOUCHBIT>
	       %<XTELL "Try looking in the " D ,MAGAZINE "." CR>)
	      ;(T <RFALSE>)>)
       (T <GLOBAL-PERSON>)>>

"People Functions"

<GLOBAL WHY-ME
	<LTABLE "\"If you think that will help, do it!\""
		"\"I think you can do that better yourself.\"">>

<ROUTINE BRING-ME (WHAT WHO "AUX" L ;(C <GETP .WHO ,P?CHARACTER>))
 <COND (<AND <IN? .WHAT ,GLOBAL-OBJECTS>
	     <FSET? .WHAT ,PERSON>>
	<SET WHAT <GET ,CHARACTER-TABLE <GETP .WHAT ,P?CHARACTER>>>)>
 <SET L <META-LOC .WHAT>>
 ;<COND (,DEBUG <TELL "[Bring: " D .WHAT " from " D .L "]" CR>)>
 <COND (<AND <IN? .L ,ROOMS>
	     <NOT <FAR-AWAY? .L>>
	     <OR <AND <FSET? .WHAT ,PERSON>
		      <NOT <FSET? .WHAT ,MUNGBIT>>
		      <NOT <FSET? .WHAT ,BUSYBIT>>>
		 <AND <FSET? .WHAT ,TAKEBIT>
		      <NOT <EQUAL? ,HERE ,CRAWL-SPACE ,SUB>>>>>
	<COND (<AND <EQUAL? .L ,HERE>
		    <FSET? .WHAT ,PERSON>>
	       <ALREADY .WHAT "here">
	       <RTRUE>)>
	<MOVE .WHO ,HERE>
	<MOVE .WHAT .WHO>
	<FCLEAR .WHAT ,NDESCBIT>
	<FCLEAR .WHAT ,INVISIBLE>
	<FSET .WHAT ,TOUCHBIT>
	<COND (<EQUAL? .L ,HERE> <TELL "\"Okay.\"">)
	      (T %<XTELL "\"Here is" THE .WHAT ", " FN ".\" ">)>
	<COND (<FSET? .WHAT ,PERSON>
	       <MOVE .WHAT ,HERE>
	       <HE-SHE-IT .WHAT T>
	       %<XTELL "'s wondering why you want to see ">
	       <HIM-HER-IT .WHAT>
	       <TELL ".">)>
	<CRLF>
	;<COND (<FSET? .WHAT ,TAKEBIT> <SCORE-OBJ .WHAT>)>
	<RTRUE>)
       (<AND ,ZOE-MENTIONED-EVIDENCE <EQUAL? .WHAT ,EVIDENCE>>
	<RFALSE>)
       (T
	<TELL "\"Sorry, " FN ", but I don't think I can.\"" CR>)>>

<ROUTINE CARRY-CHECK (PERSON)
	 <COND (T ;<FIRST? .PERSON>
		<PRINT-CONT .PERSON T 0>
		;<RTRUE>)>>

<GLOBAL TOLD-SNARK-WENT <>>
<ROUTINE COM-CHECK (PERSON)
 	 <COND (<NOT <GRAB-ATTENTION .PERSON>> <RTRUE>)
	       (<VERB? ARM>
		<COND (<DOBJ? LOCAL-SUB GLOBAL-SUB>
		       %<XTELL
"\"Good idea, "FN"! How do you want to do that?\"" CR>)>)
	       (<VERB? COME>
		<COND (<DOBJ? GLOBAL-HERE>
		       %<XTELL "\"I am here, "FN"!\"" CR>)>)
	       (<AND <DOBJ? DART BAZOOKA>
		     <MOUNTING-VERB? ,PRSO>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,PRSA ,PRSO ,PRSI>
		<RTRUE>)
	       (<VERB? FIND>
		<COND (<AND <DOBJ? GLOBAL-SNARK>
			    ,MONSTER-GONE
			    <OR <IS-CREW? .PERSON>
				<EQUAL? .PERSON ,BLY ,GLOBAL-BLY>>>
		       <SETG TOLD-SNARK-WENT T>
		       <TELL-HINT 62 ,SNARK <>>)
		      (T <RFATAL>)>)
	       (<VERB? FIX>
		<COND (<AND <EQUAL? ,PRSO ,ARM ,GASH> <FSET? ,ARM ,MUNGBIT>>
		       <COND (<==? ,WINNER ,HORVAK>
			      <FCLEAR ,ARM ,MUNGBIT>
			      <FSET ,GASH ,INVISIBLE>
			      %<XTELL
D ,HORVAK " quickly bandages your gash. Your arm is as good as new." CR>)
			     (T %<XTELL
"\"I think Doc can do that better himself.\"" CR>)>)>)
	       (<VERB? ;GOODBYE ;HELLO THANKS> <RFATAL>)
	       (<VERB? BRING SEND SEND-TO TAKE ;GET>
		<COND (<IN? ,PRSO ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?GIVE ,PRSO .PERSON>
		       <RTRUE>)
		      (<AND ;<DOBJ? DART> <FSET? ,PRSO ,TRYTAKEBIT>>
		       <RFALSE>)
		      (T
		       <BRING-ME ,PRSO .PERSON>)>)
	       (<VERB? EXAMINE>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?SHOW .PERSON ,PRSO>
		<RTRUE>)
	       (<VERB? FOLLOW>
		<COND (<DOBJ? PLAYER>
		       <TELL
"\"If you want me to go somewhere, just say so.\"" CR>)>)
	       (<AND <VERB? GIVE> <IOBJ? PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?TAKE ,PRSO .PERSON>
		<RTRUE>)
	       (<AND <VERB? SGIVE> <DOBJ? PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?TAKE ,PRSI .PERSON>
		<RTRUE>)
	       (<VERB? DROP GIVE SGIVE WALK WALK-TO LEAVE THROUGH>
		<COND (<NOT <==? .PERSON ,REMOTE-PERSON>> <RFATAL>)>)
	       (<VERB? HELLO GOODBYE>
		<COND (<OR <NOT ,PRSO> <==? ,PRSO .PERSON>>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,PRSA .PERSON>
		       <RTRUE>)>)
	       (<VERB? HELP>
		<COND (<EQUAL? ,PRSO <> ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PERSON>
		       <RTRUE>)
		      (<FSET? ,PRSO ,PERSON>
		       %<XTELL "\"I don't need any help.\"" CR>)
		      (T <RFATAL>)>)
	       (<VERB? INVENTORY>
		<COND (<NOT <CARRY-CHECK .PERSON>>
		       <TELL D .PERSON " isn't holding anything." CR>)>
		<RTRUE>)
	       (<VERB? LISTEN>
		<COND (<OR <DOBJ? PLAYER-NAME>
			   <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
		       %<XTELL "\"I'm trying to, " FN "!\"" CR>)>)
	       (<VERB? SHOW>
		<COND (<DOBJ? PLAYER>
		       <COND (<IN? ,PRSI .PERSON>
			      <SETG WINNER ,PLAYER>
			      <PERFORM ,V?TAKE ,PRSI .PERSON>
			      <RTRUE>)
			     (T
			      %<XTELL "\"I'm sure you can find ">
			      <HIM-HER-IT ,PRSI>
			      <TELL ", " FN ".\"" CR>)>)>)
	       (<VERB? TELL>
		<COND (<DOBJ? PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PERSON>
		       <RTRUE>)>)
	       (<VERB? TELL-ABOUT>
		<COND (<DOBJ? PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT .PERSON ,PRSI>
		       <RTRUE>)>)
	       (<OR ;<VERB? WAIT>
		    <AND <VERB? WAIT-FOR> <DOBJ? PLAYER>>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?$CALL .PERSON>
		<RTRUE>)
	       (<VERB? WHAT TALK-ABOUT>
		<SETG WINNER ,PLAYER>
	        <PERFORM ,V?ASK-ABOUT .PERSON ,PRSO>
		<RTRUE>)
	       (<VERB? YES NO>
		<PRINTC %<ASCII !\">>
		<COND (<VERB? YES> <TELL "Glad">) (T <TELL "Sorry">)>
		%<XTELL " to hear it, " FN ".\"" CR>)>>

<ROUTINE COMMON-ASK-ABOUT (PER OBJ)
 ;<COND (,DEBUG <TELL "[COMMON-ASK-ABOUT: " D .PER "/" D .OBJ "]" CR>)>
 <COND (<EQUAL? .OBJ ,DEPTH ,CREW ,CREW-GLOBAL> <RFATAL>)
       (<EQUAL? .OBJ ,DEPTHFINDER> <RFATAL>)
       (<EQUAL? .OBJ ,GLOBAL-WEAPON ,MORE>
	%<XTELL "\"Ask me about something specific, "FN".\"" CR>)
       (<OR <EQUAL? .OBJ ,BAY ,GLOBAL-SONAR ,SONAR-EQUIPMENT>
	    <EQUAL? .OBJ ,GLOBAL-SUB ,LOCAL-SUB ,CLAW>>
	%<XTELL "\"You know more about it than I do, " FN ".\"" CR>)
       (<EQUAL? .OBJ .PER>
	%<XTELL "\"I have no secrets. Anyone can see what I am.\"" CR>)
       (<EQUAL? .OBJ ,PLAYER>
	%<XTELL "\"You're "FN" "LN", the famous young inventor.\"" CR>)
       (<EQUAL? .OBJ ,AIRLOCK-ELECTRICITY>
	%<XTELL "\"It powers the " D ,AIRLOCK-HATCH ".\"" CR>)
       (<EQUAL? .OBJ ,VIDEOPHONE>	;"Player could mean PHOTO."
	<COND (<GLOBAL-IN? ,VIDEOPHONE ,HERE>
	       <SETG P-WON <>>
	       <TELL <GETP .OBJ ,P?TEXT> CR>)>)
       (<FSET? .OBJ ,PERSON>
	<RFALSE>)
       (<EQUAL? <GETP .OBJ ,P?TEXT>
		"(You'll find that information in your SEASTALKER package.)">
	<SETG P-WON <>>
	<TELL <GETP .OBJ ,P?TEXT> CR>)
       (<EQUAL? .OBJ ,DIARY>
	<COND (<FSET? ,DIARY ,TOUCHBIT>
	       %<XTELL "\"I think that it's pretty obvious.\"" CR>)>)
       (<EQUAL? .OBJ ,EVIDENCE ,BLACK-BOX>
	<SHOULD-ASK ,BLY .PER>)
       (<EQUAL? .OBJ ,FINE-GRID>
	<SHOULD-ASK ,TIP .PER>)
       (<EQUAL? .OBJ ,MAGAZINE ,ARTICLE>
	%<XTELL "\"It's a magazine called 'SCIENCE WORLD.'\"" CR>)
       (<EQUAL? .OBJ ,CONTROL-CIRCUITS-GAUGE>
	<TELL
"The " D ,CONTROL-CIRCUITS-GAUGE " is a thermometer for an important
part of the engine." CR>)
       (<EQUAL? .OBJ ,OXYGEN-GEAR>
	%<XTELL
"\"Your Dad made the rule about it, " FN ". Everyone in
the " D ,AQUADOME " should carry one at all times, remember?|
They're little canisters of oxygen that you can wear around
your neck. When you turn the valve, you can suck air through the rubber
straw at the top.">
	<COND (<IN? ,OXYGEN-GEAR ,SUB>
	       <TELL "|
The canister is in the " D ,SUB ", just like in all " LN " submarines."
;" clipped under your pilot's seat">)>
	<TELL "\"" CR>)
       (<IN? .OBJ .PER>
	%<XTELL "\"I have it right here, "FN".\"" CR>)
       (<OR <EQUAL? .OBJ ,BLACK-CIRCUITRY ,GLOBAL-SABOTAGE>
	    <EQUAL? .OBJ ,AIR-SUPPLY-SYSTEM ,AIR-SUPPLY-SYSTEM-GLOBAL>>
	%<XTELL "\"You know as much as I do.\"" CR>)
       (<EQUAL? .OBJ ,PRIVATE-MATTER>
	<COND (<==? .PER ,REMOTE-PERSON>	;<IN? .PER ,GLOBAL-OBJECTS>
	       %<XTELL "\"Wait until you see me, " FN ".\"" CR>)
	      (T
	       <MOVE ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
	       %<XTELL
D .PER " says, \"I'm sorry, " FN ", but that's a " D ,PRIVATE-MATTER ".\""
CR>)>)
       (<OR <EQUAL? .OBJ ,PROBLEM>
	    <AND ,DEPTH-WARNING
		 <EQUAL? .OBJ ,DEPTHFINDER-LIGHT ,ALARM>>
	    <AND <OR ,SONAR-WARNING ,SHIP-WARNING>
		 <EQUAL? .OBJ ,SONARSCOPE-LIGHT ,ALARM>>>
	<COND (<OR ,DEPTH-WARNING ,SONAR-WARNING ,SHIP-WARNING>
	       %<XTELL "\"I think you're going too close to "
		       <COND (,DEPTH-WARNING "the bottom") (T "an obstacle")>
		       ", " FN ".\"" CR>)
	      (<AND ,DOME-AIR-BAD? <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	       <BADGES-RED>
	       <RTRUE>)
	      (T %<XTELL D .PER " says, \"I don't know, " FN ".\"" CR>)>)
       (<EQUAL? .OBJ ,BADGE-GLOBAL ,BADGE-GLOBAL-2 ,BADGE-GLOBAL-3>
	<PRINTC %<ASCII !\">>
	<EXAMINE-BADGE>
	<TELL "\"" CR>
	<RTRUE>)
       (<EQUAL? .OBJ ,GLOBAL-SONAR ,SONAR-MAN>
	%<XTELL "\"" D ,SIEGEL " operates the " D ,SONAR-EQUIPMENT ".\"" CR>)
       (<EQUAL? .OBJ ,LAB-ASSISTANT>
	%<XTELL
"\"" D ,LOWELL " is " D ,HORVAK "'s " D ,LAB-ASSISTANT ".\"" CR>)
       (<EQUAL? .OBJ ,ALARM>
	<COND (,ALARM-RINGING
	       <WHY-NOT-VP>)>)
       (<EQUAL? .OBJ ,SYRINGE ,ESCAPE-POD-UNIT ,GLOBAL-GREENUP>
	<COND (,GREENUP-GUILT
	       %<XTELL
"\"I never suspected " D ,GREENUP " of being a " D ,TRAITOR ".\"" CR>
	       <COND (<AND <IN? ,GREENUP ,HERE>
			   <NOT <FSET? ,GREENUP ,MUNGBIT>>
			   ;<NOT ,GREENUP-ESCAPE>
			   ;<NOT ,GREENUP-TRAPPED>>
		      ;<SETG WINNER ,PLAYER>
		      <PERFORM ,V?ARREST ,GREENUP>)>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,SYRINGE ,ESCAPE-POD-UNIT>
	       <TELL "\"Maybe " D ,HORVAK " can analyze it.\"" CR>)>)
       (<AND <FSET? ,ARM ,MUNGBIT> <EQUAL? .OBJ ,ARM ,GASH>>
	%<XTELL "\"That looks pretty serious, "FN".\"" CR>)
       (<OR <IS-CREW? .PER> <EQUAL? .PER ,BLY ;,GLOBAL-BLY>>
	<COND (<AND <EQUAL? .OBJ ,ELECTROLYTE-RELAY> ,SUB-IN-DOME>
	       <TELL "\"It belongs in the " D ,EMPTY-SPACE ".\"" CR>)
	      (<AND <EQUAL? .OBJ ,SPECIAL-TOOL-GLOBAL ,SPECIAL-TOOL>
		    ,SUB-IN-DOME>
	       <COND (<OR <FSET? ,SPECIAL-TOOL ,INVISIBLE>
			  <FSET? ,ELECTROLYTE-RELAY ,MUNGBIT>>
		      %<XTELL
"\"The " D ,SPECIAL-TOOL " should be on that hook.\"" CR>
		      <RTRUE>)>
	       <TELL "\"I'm sure glad ">
	       <COND (,HORVAK-FIXED-AIR
		      <COND (<DOBJ? HORVAK> <TELL "I">) (T <TELL "Doc">)>)
		     (T <TELL "you">)>
	       <TELL " fixed the " D ,AIR-SUPPLY-SYSTEM ", " FN "!\"" CR>)
	      (<AND <EQUAL? .OBJ ,GLOBAL-SNARK> ,MONSTER-GONE>
	       <SETG TOLD-SNARK-WENT T>
	       <TELL-HINT 62 ,SNARK <>>)>)>>

<ROUTINE SHOULD-ASK (WHO "OPTIONAL" (PER <>))
	<COND (.PER <TELL D .PER " says, ">)>
	%<XTELL
"\"I think you should ask " D .WHO " about that.\"" CR>>

<ROUTINE COMMON-OTHER (PER "AUX" (LPER <>))
 <COND (<IN? .PER ,GLOBAL-OBJECTS>
	<SET LPER <GET ,CHARACTER-TABLE <GETP .PER ,P?CHARACTER>>>)
       (T <SET LPER .PER>)>
 <COND (<VERB? ASK> <RFALSE>)
       (<VERB? EXAMINE>
	<COND (<NOT <CARRY-CHECK .LPER>>
	       <TELL <GETP ,LOCAL-SUB ,P?TEXT> CR>)>
	<RTRUE>)
       (<AND <EQUAL? ,PRSI .LPER>
	     <IN? ,PRSO ,PLAYER>
	     <NOT <DOBJ? BADGE-PLAYER>>
	     <VERB? GIVE>>
	<MOVE ,PRSO .LPER>
	%<XTELL "\"Hey, thanks, " FN "!\"" CR>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? HELP>>
	<COND (<AND ,DOME-AIR-BAD? <FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>>
	       %<XTELL
"It would help more to fix the " D ,AIR-SUPPLY-SYSTEM "." CR>)
	      (<NOT <IN? .PER ,GLOBAL-OBJECTS>>
	       %<XTELL
PRSO " looks offended. \"I'm quite capable by myself, you know.\"" CR>)>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? RUB>>
	%<XTELL
D .PER " looks bewildered. \"What are you trying to do?\"" CR>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? SHOW>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
	<RTRUE>)>>

<ROUTINE DESCRIBE-COLLAPSE (PERSON)
 <COND (<FSET? ,BLY ,MUNGBIT>	;,DOME-AIR-BAD?
	<COND (<EQUAL? .PERSON ,TIP>
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		      <DESCRIBE-PERSON .PERSON "looking at you anxiously">)
		     (T
		      <DESCRIBE-PERSON .PERSON>)>)
	      (<EQUAL? .PERSON ,BLY ,LOWELL ,GREENUP>
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		      <DESCRIBE-PERSON .PERSON "collapsing on the floor">)
		     (T
		     <DESCRIBE-PERSON .PERSON "recovering from collapse">)>)
	      (T
	       <COND (<FSET? ,AIR-SUPPLY-SYSTEM ,MUNGBIT>
		      <COND (,BADGES-RED-SAID?
			     <DESCRIBE-PERSON .PERSON "using Oxygen Gear">)
			    (T
			     <DESCRIBE-PERSON .PERSON
					      "looking at you anxiously">)>)
		     (T
		     <DESCRIBE-PERSON .PERSON>)>)>)
       (T <DESCRIBE-PERSON .PERSON>)>>

<ROUTINE DESCRIBE-PERSON (PERSON "OPTIONAL" (STR <>))
 <COND (<AND <IS-CREW? .PERSON>
	     <CREW-5-TOGETHER?>
	     <NOT <FSET? ,BLY ,MUNGBIT>>>
	<COND (<==? .PERSON ,LOWELL>
	       <TELL "The five " D ,CREW " members are here." CR>)>)
       (T <TELL D .PERSON " is "
		<COND (<NOT .STR> "here") (T .STR)>
		"." CR>
	;<COND (,DEBUG <TELL "[now calling CARRY-CHECK:]" CR>)>
	;<CARRY-CHECK .PERSON>)>>

<ROUTINE DISCRETION (P1 P2 "OPTIONAL" (P3 <>))
	 <COND (<AND <==? ,HERE <META-LOC .P2>>
		     .P3 <==? ,HERE <META-LOC .P3>>>
	        %<XTELL D .P1 " looks briefly toward " D .P2 " and " D .P3
" and then speaks in a whisper." CR>)
	       (<==? ,HERE <META-LOC .P2>>
	        %<XTELL D .P1 " looks briefly toward " D .P2
" and then speaks in a whisper." CR>)
	       (<AND .P3 <==? ,HERE <META-LOC .P3>>>
	        %<XTELL D .P1 " looks briefly toward " D .P3
" and then speaks in a whisper." CR>)>>

<ROUTINE NOT-IMPORTANT (CHAR) <DONT-KNOW .CHAR ,PROBLEM>>

<ROUTINE DONT-KNOW (CHAR OBJ)
	<TELL
D .CHAR " says, \"I don't think that's important right now, " FN ".\"" CR>>

<ROUTINE FOLLOWED? (PERSON "AUX" (L <LOC .PERSON>))
	 <COND (<==? .L ,HERE> <RTRUE>)
	       (<NOT <==? <BAND <GETP .L ,P?CORRIDOR>
				<GETP ,HERE ,P?CORRIDOR>> 0>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE GLOBAL-PERSON ("AUX" L)
 <COND (<VERB? ;$WHERE ARREST FIND FOLLOW LOOK-UP
		;$CALL PHONE WAIT-FOR WALK-TO WHAT>
	<RFALSE>)
       (<AND <VERB? EXAMINE>
	     <FSET? ,PRSO ,PERSON>
	     <SET L <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>>
	<COND ;(<AND <EQUAL? ,REMOTE-PERSON ,PRSO>
		    <EQUAL? ,REMOTE-PERSON-ON ,VIDEOPHONE>>
	       <COND (T <SET L <GETP .L ,P?TEXT>>
		      <TELL .L CR>)
		     ;(T <TELL
"There's nothing special about" THE-PRSO "." CR>)>)
	      (<NOT <CORRIDOR-LOOK .L>>
	       <NOT-HERE ,PRSO>
	       ;<TELL "You can't see " D ,PRSO " here!" CR>)>)
       ;(<VERB? PHONE>
	<COND (<AND <FSET? ,PRSO ,PERSON>
		    <SET L <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>>
	       <PERFORM ,PRSA .L ,PRSI>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<AND <VERB? ASK-ABOUT ASK-FOR HELLO REPLY TELL TELL-ABOUT>
	     ,PRSO
	     <FSET? ,PRSO ,PERSON>
	     <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
	<COND (<VERB? REPLY> <SETG PRSA ,V?TELL>)>
	<RFALSE>)
       (<AND <VERB? ASK-ABOUT TELL-ABOUT>
	     ,PRSI
	     <FSET? ,PRSI ,PERSON>
	     <IN? ,PRSI ,GLOBAL-OBJECTS>>
	<PERFORM ,PRSA ,PRSO
		 <GET ,CHARACTER-TABLE <GETP ,PRSI ,P?CHARACTER>>>
	<RTRUE>)
       ;(<VERB? TELL>
	<TELL "You can't speak to someone who isn't here." CR>
	<SETG P-CONT <>>
	<RTRUE>)
       (T
	<SETG P-CONT <>>
	<COND (<OR <VERB? ASK-ABOUT TELL-ABOUT>
		   <NOT ,NOW-PRSI>>
	       <TELL D ,PRSO>)
	      (,PRSI <TELL D ,PRSI>)
	      (T <TELL D ,WINNER>)>
	<NOT-HERE-PERSON ,PRSO>
	<RTRUE>)>>

<ROUTINE NOT-HERE-PERSON (PER "AUX" L)
	<COND (<FSET? .PER ,PERSON>
	       <SET L <LOC <GET ,CHARACTER-TABLE <GETP .PER ,P?CHARACTER>>>>)
	      (T <SET L <LOC .PER>>)>
	<COND (<AND .L
		    ;<GETP ,HERE ,P?CORRIDOR>
		    ;<GETP .L    ,P?CORRIDOR>
		    <NOT <==? 0 <BAND <GETP ,HERE ,P?CORRIDOR>
				      <GETP .L    ,P?CORRIDOR>>>>>
	       <TELL " isn't close enough">
	       <COND (<SPEAKING-VERB?> <TELL " to hear you">)>
	       <TELL "." CR>)
	      (T <TELL " isn't here!" CR>)>>

<ROUTINE INHABITED? (RM) <NOT <0? <POPULATION .RM>>>>

<ROUTINE POPULATION (RM "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" (CNT 0) OBJ)
	 #DECL ((RM) OBJECT (CNT) FIX)
 <COND (<NOT <SET OBJ <FIRST? .RM>>> <RETURN .CNT>)>
 <REPEAT ()
	 <COND (<AND <FSET? .OBJ ,PERSON>
		     <NOT <FSET? .OBJ ,INVISIBLE>>
		     <OR <NOT .NOT1> <NOT <EQUAL? .OBJ .NOT1>>>
		     <OR <NOT .NOT2> <NOT <EQUAL? .OBJ .NOT2>>>>
		<SET CNT <+ .CNT 1>>)
	       (<FSET? .OBJ ,CONTBIT>
		<SET CNT <+ .CNT <POPULATION .OBJ .NOT1 .NOT2>>>)>
	 <SET OBJ <NEXT? .OBJ>>
	 <COND (<NOT .OBJ> <RETURN .CNT>)>>>

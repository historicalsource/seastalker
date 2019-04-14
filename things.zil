"THINGS for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<OBJECT PSEUDO-OBJECT
	(DESC "pseudo" ;"Place holder (MUST BE 6 CHARACTERS!!!!!)")
	(CONTFCN NULL-F)	;"to establish property"
	(ACTION NULL-F ;"Place holder")>

<ROUTINE RANDOM-PSEUDO ()
	 <TELL "You can't do anything useful with that." CR>>

<OBJECT NOT-HERE-OBJECT
	(DESC "that thing")
	(FLAGS NARTICLEBIT)
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	;"Protocol: return ,M-FATAL if case was handled and msg TELLed,
			  <> if PRSO/PRSI ready to use"
	<COND ;"This COND is game independent (except the TELL)"
	       (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "(Those things aren't here!)" CR>
		<RFATAL>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 <COND (<AND <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR>
		     <FSET? ,PRSO ,PERSON>
		     <IN? ,PRSO ,GLOBAL-OBJECTS>>
		<TELL D ,PRSO>
		<NOT-HERE-PERSON ,PRSO>)>
	 <COND (.PRSO?
		<COND (<OR <EQUAL? ,PRSA ,V?ASK-CONTEXT-ABOUT ,V?BOARD>
			   <EQUAL? ,PRSA ,V?ASK-CONTEXT-FOR ,V?TAKE-WITH>
			   <EQUAL? ,PRSA ,V?FIND ,V?FOLLOW ,V?USE>
			   <EQUAL? ,PRSA ,V?LEAVE ,V?DISEMBARK ,V?PHONE>
			   <EQUAL? ,PRSA ,V?THROUGH ,V?WALK-TO ,V?WHAT>
			   <AND <EQUAL? ,PRSA ,V?BRING ,V?TAKE ,V?SSHOW>
				<NOT <==? ,WINNER ,PLAYER>>>>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
				     <RFATAL>)>)
			     (T
			      <RFALSE>)>)>)
	       (T
		<COND (<OR <EQUAL? ,PRSA ,V?ASK-ABOUT ,V?ASK-FOR ,V?TAKE-TO>
			   <EQUAL? ,PRSA ,V?SEARCH-FOR ,V?TELL-ABOUT>
			   <AND <EQUAL? ,PRSA ,V?SBRING ,V?SHOW>
				<NOT <==? ,WINNER ,PLAYER>>>>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
				     <RFATAL>)>)
			     (T
			      <RFALSE>)>)>)>
	 ;"Here is the default 'cant see any' printer"
	 <TELL "(You can't see any">
	 <NOT-HERE-PRINT>
	 <TELL " here!)" CR>
	 <RFATAL>>

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ (PERSON? T))
	;"Protocol: return T if case was handled and msg TELLed,
	    ,NOT-HERE-OBJECT if 'can't see' msg TELLed,
			  <> if PRSO/PRSI ready to use"
	;"Here is where special-case code goes. <MOBY-FIND .TBL> returns
	   number of matches. If 1, then P-MOBY-FOUND is it. One may treat
	   the 0 and >1 cases alike or different. It doesn't matter. Always
	   return RFALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	<COND (,DEBUG
	       <TELL "[Found " N .M-F " objects]" CR>)>
	<COND (<==? 1 .M-F>
	       <COND (,DEBUG <TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>
	       <COND (.PRSO? <SETG PRSO ,P-MOBY-FOUND>)
		     (T <SETG PRSI ,P-MOBY-FOUND>)>
	       ;<THIS-IS-IT ,P-MOBY-FOUND>
	       <RFALSE>)
	     (<AND <L? 1 .M-F>
		    <SET OBJ <APPLY <GETP <SET OBJ <GET .TBL 1>> ,P?GENERIC>
				    .OBJ>>>
	;"Protocol: returns .OBJ if that's the one to use,
		,NOT-HERE-OBJECT if case was handled and msg TELLed,
			      <> if WHICH-PRINT should be called"
	       <COND (,DEBUG <TELL "[Generic: " D .OBJ "]" CR>)>
	       <COND (<==? .OBJ ,NOT-HERE-OBJECT> <RTRUE>)
		     (.PRSO? <SETG PRSO .OBJ>)
		     (T <SETG PRSI .OBJ>)>
	       ;<THIS-IS-IT .OBJ>
	       <RFALSE>)
	      (<OR <AND <NOT .PRSO?>
			<IN? ,PRSO ,HERE>
			<VERB? ASK-ABOUT ASK-FOR TELL-ABOUT>>
		   <AND .PRSO?
			<QCONTEXT-GOOD?>
			<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR>>
		   <AND <NOT <==? ,WINNER ,PLAYER>>
			<VERB? FIND WHAT GIVE SGIVE>>>
	       <COND (<VERB? ASK-ABOUT ASK-FOR>
		      <COND (<NOT <FSET? ,PRSO ,PERSON>>
			     <SET PERSON? <>>
			     <TELL "The ">)>
		      <TELL D ,PRSO>)
		     (<QCONTEXT-GOOD?>
		      <COND (<NOT <FSET? ,QCONTEXT ,PERSON>>
			     <SET PERSON? <>>
			     <TELL "The ">)>
		      <TELL D ,QCONTEXT>)
		     (<NOT <==? ,WINNER ,PLAYER>>
		      <TELL D ,WINNER>)
		     (<SET OBJ <FIND-FLAG ,HERE ,PERSON ,PLAYER>>
		      <TELL D .OBJ>)
		     (<VISIBLE? ,TIP>
		      <TELL "Tip">)
		     (T <TELL "Someone">)>
	       <COND (<NOT .PERSON? ;<FSET? ,PRSO ,PERSON>>
		      <TELL " isn't connected to any">)
		     (T <TELL
" looks confused. \"I don't know anything about any">)>
	       <NOT-HERE-PRINT>
	       <TELL "!">
	       <COND (.PERSON? <TELL "\"">)>
	       <CRLF>
	       <RTRUE>)
	      (<NOT .PRSO?>
	       <TELL "You wouldn't find any">
	       <NOT-HERE-PRINT>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T ,NOT-HERE-OBJECT)>>

<ROUTINE NOT-HERE-PRINT ()
 <COND (<OR ,P-OFLAG ,P-MERGED>
	<COND (,P-XADJ <TELL " "> <PRINTB ,P-XADJN>)>
	<COND (,P-XNAM <TELL " "> <PRINTB ,P-XNAM>)>)
       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

;"<ROUTINE NO-TOUCH ()
	 <TELL
'Only clods fool around with these things for no good reason.' CR>>"

<ROUTINE THE? (NOUN)
	<COND (<OR <AND <FSET? .NOUN ,PERSON>
			<NOT <EQUAL? .NOUN ,PLAYER>>>
		   <FSET? .NOUN ,NARTICLEBIT>>
	       <RTRUE>)
	      (T <TELL " the">)>>

<OBJECT NOTEBOOK
	(IN PLAYER)
	(DESC "Logbook")
	(ADJECTIVE LOG ;LAB ;LABORATORY)
	(SYNONYM LOGBOOK BOOK)
	(FLAGS TAKEBIT READBIT ;BURNBIT)
	(ACTION NOTEBOOK-F)>

<ROUTINE NOTEBOOK-F ()
 <COND (<VERB? OPEN READ EXAMINE ANALYZE TELL-ABOUT>
	<TELL
"(You'll find the " D ,NOTEBOOK " in your " D ,GAME " package.)" CR>)>>

<OBJECT MAGAZINE
	(IN TIP)
	(DESC "magazine")
	(ADJECTIVE ;TIP TIP\'S RANDALL MAGAZINE MAG)
	(SYNONYM MAGAZINE MAG COVER NEWSPAPER)
	(FLAGS READBIT TAKEBIT ;NDESCBIT CONTBIT SEARCHBIT)
	(CAPACITY 1)
	(ACTION MAGAZINE-F)>

<ROUTINE MAGAZINE-F ()
 <COND ;(<REMOTE-VERB?>
	<RFALSE>)
       (<VERB? LOOK-INSIDE OPEN>
	<COND (<NOT-HOLDING? ,MAGAZINE> <RTRUE>)>)
       (<AND <VERB? LOOK-UP> <DOBJ? GLOBAL-THORPE>>
	<PERFORM ,V?READ ,ARTICLE>
	<RTRUE>)
       (<VERB? READ EXAMINE ANALYZE>
	<COND (<NOT-HOLDING? ,MAGAZINE> <RTRUE>)>
	<TELL
"\"Science World\" is a popular " D ,MAGAZINE " about new
scientific developments.|
The cover shows " D ,GLOBAL-THORPE ", marine
biologist, surrounded by imaginative drawings of weird undersea life
forms. The cover says:|
\"HOT FLASH FROM THE MARINE BIOLOGY FRONT!|
... NEW SEA CREATURES SPAWNED BY TEST TUBE?|
(SEE ARTICLE INSIDE)\"" CR>)>>

<OBJECT ARTICLE
	(IN MAGAZINE)
	(DESC "article")
	(ADJECTIVE COVER)
	(SYNONYM ARTICLE STORY REPORT PAGE)
	(FLAGS READBIT ;TAKEBIT ;NDESCBIT VOWELBIT)
	(SIZE 1)
	(ACTION ARTICLE-F)>

<ROUTINE ARTICLE-F ()
 <COND (<DIVESTMENT? ,ARTICLE>
	<PERFORM ,PRSA ,MAGAZINE ,PRSI>
	<RTRUE>)
       (<VERB? READ LOOK-INSIDE EXAMINE ANALYZE>
	<COND (<NOT-HOLDING? ,MAGAZINE> <RTRUE>)>
	<TELL
"It says that " D ,GLOBAL-THORPE " may have created synthetic forms of
marine life by genetic engineering. You learn that Thorpe went into
hiding to duck publicity, but before that he told friends he would soon
marry " D ,SHARON ".|
The form of the creatures is unknown. They may be stimulated by
ultrasonic pulses and might be trained to respond to such pulses.|
Some scientists are skeptical, but Thorpe has claimed that one-celled
organisms had evolved in his lab from AMINO-HYDROPHASE or A.H. If rumors
are true, these synthetic sea creatures should be based on the A.H.
molecule." CR>)>>

<OBJECT CATALYST-CAPSULE
	(IN WORK-COUNTER)
	(DESC "catalyst capsule")
	(ADJECTIVE CATALYST)
	(SYNONYM CAPSULE)
	(ACTION CATALYST-CAPSULE-F)
	(FLAGS TAKEBIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(SIZE 11)
	(VALUE 5)>

<ROUTINE CATALYST-CAPSULE-F ()
 <COND (<AND <VERB? COMPARE>
	     <OR <AND <IOBJ? CATALYST-CAPSULE> <DOBJ? REACTOR>>
		 <AND <DOBJ? CATALYST-CAPSULE> <IOBJ? REACTOR>>>>
	<TELL
"It looks as if the " D ,CATALYST-CAPSULE " fits perfectly into the "
D ,REACTOR "." CR>)
       (<AND <VERB? FIND> <NOT <FSET? ,CATALYST-CAPSULE ,TOUCHBIT>>>
	<TELL
"The capsule is usually stored on a " D ,WORK-COUNTER" on the west wall of the
tank area." CR>)
       (<AND <VERB? PUT> <IOBJ? GLOBAL-SUB LOCAL-SUB>>
	<TELL "You'll have to take it there yourself." CR>)
       (<AND <VERB? TAKE> <FSET? ,CATALYST-CAPSULE ,TRYTAKEBIT>>
	<TELL "It's too hot to pick up." CR>)>>

<OBJECT OXYGEN-GEAR-OTHER
	(IN GLOBAL-OBJECTS)
	(DESC "other Gear")
	(ADJECTIVE OTHER DOC\'S WALT\'S HORVAK MARV\'S SIEGEL MICK\'S ANTRIM)
	(SYNONYM GEAR GEARS)
	(FLAGS ;NARTICLEBIT VOWELBIT ;ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(GENERIC GENERIC-OXYGEN-GEAR-F)
	(ACTION OXYGEN-GEAR-GLOBAL-F)>

<OBJECT OXYGEN-GEAR-DIVER
	(IN GLOBAL-OBJECTS)
	(DESC "divers' Gear")
	(ADJECTIVE DIVER DIVERS ;BILL BILL\'S GREENUP ;AMY AMY\'S LOWELL)
	(SYNONYM GEAR GEARS)
	(FLAGS ;NARTICLEBIT ;ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(GENERIC GENERIC-OXYGEN-GEAR-F)
	(ACTION OXYGEN-GEAR-GLOBAL-F)>

<OBJECT OXYGEN-GEAR-BLY
	(IN GLOBAL-OBJECTS)
	(DESC "Bly's Emergency Oxygen Gear")
	(ADJECTIVE COMMANDER ;ZOE ZOE\'S BLY\'S EMERGE OXYGEN)
	(SYNONYM GEAR)
	(FLAGS NARTICLEBIT ;ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(GENERIC GENERIC-OXYGEN-GEAR-F)
	(ACTION OXYGEN-GEAR-GLOBAL-F)>

<ROUTINE GENERIC-OXYGEN-GEAR-F (OBJ)
	<COND (<REMOTE-VERB?> ,OXYGEN-GEAR)
	      (<AND <VERB? TAKE> ,PRSI <FSET? ,PRSI ,PERSON>>
	       <COND (<IOBJ? HORVAK SIEGEL ANTRIM> ,OXYGEN-GEAR-OTHER)
		     (<IOBJ? GREENUP LOWELL> ,OXYGEN-GEAR-DIVER)
		     (<IOBJ? BLY> ,OXYGEN-GEAR-BLY)>)>>

<ROUTINE OXYGEN-GEAR-GLOBAL-F ()
 <COND (<OR <NOT ,SUB-IN-DOME ;<IN-DOME? ,HERE>>
	    <NOT <FIND-FLAG ,HERE ,PERSON ,WINNER>>>
	<NOT-HERE ,OXYGEN-GEAR-OTHER>)
       (<VERB? ASK-ABOUT ASK-CONTEXT-ABOUT FIND SEARCH-FOR TELL-ABOUT EXAMINE>
	<RFALSE>)
       (T <YOU-CANT>)>>

<OBJECT OXYGEN-GEAR
	(IN SUB)
	(DESC "Emergency Oxygen Gear")
	(ADJECTIVE EMERGE OXYGEN RUBBER MY)
	(SYNONYM GEAR CANISTER VALVE STRAW)
	(FLAGS NARTICLEBIT VOWELBIT TAKEBIT NDESCBIT ON?BIT)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION OXYGEN-GEAR-F)>

<ROUTINE OXYGEN-GEAR-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)>
 <FCLEAR ,OXYGEN-GEAR ,NDESCBIT>
 <COND (<AND <VERB? TAKE> <DOBJ? OXYGEN-GEAR>>
	<COND (<==? <ITAKE> T>
		<TELL
"You're now wearing" THE-PRSO " around your neck." CR>)>
	<RTRUE>)
       (<VERB? LAMP-ON TURN USE OPEN>
	<COND (<FSET? ,OXYGEN-GEAR ,ONBIT>
	       <ALREADY ,OXYGEN-GEAR "on">
	       <RTRUE>)
	      (<NOT-HOLDING? ,OXYGEN-GEAR>
	       <RTRUE>)
	      (<NOT ,DOME-AIR-BAD?>
	       <TELL "You don't need it now!" CR>
	       <RTRUE>)>
	<FSET ,OXYGEN-GEAR ,ONBIT>
	<TELL
"As you open the valve and suck on the rubber straw, you feel your lungs
filling with pure oxygen.">
	<COND (<AND ,DOME-AIR-BAD? <CORRIDOR-LOOK ,BLY>>
	       <TELL CR
"But you notice Zoe Bly collapsing, and you realize she has
no " D ,OXYGEN-GEAR ;" around her neck" "!">)>
	<CRLF>)
       (<VERB? CLOSE>
	<PERFORM ,V?LAMP-OFF ,OXYGEN-GEAR>
	<RTRUE>)>>

<OBJECT BADGE-PLAYER
	(IN PLAYER)
	(DESC "your badge")
	(ADJECTIVE THIS SPECIAL IDENTIFY MY ;YOUR)
	(SYNONYM BADGE)
	(FLAGS NDESCBIT ;VOWELBIT NARTICLEBIT)
	(ACTION BADGE-PLAYER-F)>

<ROUTINE BADGE-PLAYER-F ()
	;<FCLEAR ,BADGE-PLAYER ,NDESCBIT>
	<COND (<DIVESTMENT? ,BADGE-PLAYER>
	       <TELL "That wouldn't be good for security." CR>)
	      (<VERB? ANALYZE EXAMINE READ>
	       <TELL "It's a special identification badge for">
	       <RESEARCH-LAB>
	       <TELL "." CR>)>>

<OBJECT BADGE-TIP
	(IN TIP)
	(DESC "Tip's badge")
	(ADJECTIVE THIS SPECIAL IDENTIFY ;TIP TIP\'S RANDALL)
	(SYNONYM BADGE)
	(FLAGS NDESCBIT ;VOWELBIT NARTICLEBIT)
	(ACTION BADGE-PLAYER-F)>

<OBJECT BADGE-SHARON
	(IN SHARON)
	(DESC "Sharon's badge")
	(ADJECTIVE THIS SPECIAL IDENTIFY SHARON KEMP\'S)
	(SYNONYM BADGE)
	(FLAGS NDESCBIT ;VOWELBIT NARTICLEBIT)
	(ACTION BADGE-PLAYER-F)>

<OBJECT UNIVERSAL-TOOL
	(IN TIP)
	(DESC "Universal Tool")
	(ADJECTIVE UNIVERSAL TIP\'S RANDALL)
	(SYNONYM TOOL)
	(FLAGS ;NDESCBIT TAKEBIT TOOLBIT)
	(GENERIC GENERIC-TOOL-F)>

<ROUTINE GENERIC-TOOL-F (OBJ)
 <COND (<VERB? OPEN-WITH TAKE-WITH> ,UNIVERSAL-TOOL)>>


"<ROUTINE V-$CODE ('AUX' (I 0) CH)
 <REPEAT ()
	<COND (<OR <IGRTR? I 19>
		   <AND <G? .I 5>
			<0? <GETB ,FIRST-NAME .I>>
			<0? <GETB ,LAST-NAME .I>>>
		   <0? <GETB ,GAME-NAME .I>>>
	       <CRLF>
	       <RTRUE>)>
	<SET CH <+ 1
		   <GETB ,FIRST-NAME .I>
		   <GETB ,LAST-NAME .I>
		   <GETB ,GAME-NAME .I>>>
	<PRINTC <+ *101* <MOD .CH 26>>>>>"

<ROUTINE V-$BAY ()
	<COND (<NOT ,SUB-IN-TANK> <TELL "too late" CR> <RTRUE>)>
	<SETG HERE ,SUB>
	<MOVE ,PLAYER ,SUB>
	<MOVE ,TIP ,SUB>
	<MOVE ,CATALYST-CAPSULE ,REACTOR>
	<FCLEAR ,REACTOR ,OPENBIT>
	<FSET ,REACTOR ,ONBIT>
	<FSET ,ENGINE ,ONBIT>
	<FCLEAR ,SUB-DOOR ,OPENBIT>
	<SETG MONSTER-GONE T>
	;<FCLEAR ,GLOBAL-SNARK ,INVISIBLE>
	<SETG JOYSTICK-DIR ,P?EAST>
	<SETG SUB-DLON 1>
	<SETG SUB-DLAT 0>
	<SETG NOW-TERRAIN ,BAY-TERRAIN>
	<SETG SUB-IN-TANK <>>
	<ENABLE <QUEUE I-UPDATE-SUB-POSITION -1>>
	;<TELL
'\'What a totally awesome invention, ' FN '!\' says Tip sarcastically.' CR>>

"<ROUTINE V-$OCEAN ()
	<V-$BAY>
	<SETG NOW-TERRAIN <>>
	<SETG SUB-IN-OPEN-SEA T>>

;<ROUTINE V-$DOME ()
	<V-$OCEAN>
	<FSET ,SUB-DOOR ,OPENBIT>
	<FSET ,AIRLOCK-ROOF ,OPENBIT>
	<MOVE ,PRIVATE-MATTER ,GLOBAL-OBJECTS>
	<MOVE ,OXYGEN-GEAR ,PLAYER>
	<FCLEAR ,OXYGEN-GEAR ,NDESCBIT>
	<SETG SUB-IN-DOME T>
	<SETG SUB-DEPTH ,AIRLOCK-DEPTH>
	;<QUEUE I-UPDATE-SUB-POSITION 0>
	<SETG SUB-IN-OPEN-SEA <>>
	;<SETG NOW-TERRAIN ,SEA-TERRAIN>
	;<SETG SUB-LON 6>
	;<SETG SUB-LAT 5>
	;<SETG SUB-DEPTH 28>
	<SETG AIRLOCK-FULL <>>>

;<ROUTINE V-$SNARK ()
	<V-$BAY>
	<SETG NOW-TERRAIN ,SEA-TERRAIN>
	<SETG JOYSTICK-DIR ,P?SE>
	<SETG SUB-DEPTH ,AIRLOCK-DEPTH>
	<SETG SUB-DLON 1>
	<SETG SUB-DLAT -1>
	<MOUNT-WEAPON ,BAZOOKA>
	<MOUNT-WEAPON ,DART>
	<SETG SUB-LON +19>
	<SETG SUB-LAT -19>
	<I-THORPE-APPEARS>>"

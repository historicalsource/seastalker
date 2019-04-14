"MAIN for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<GLOBAL P-WON <>>

<CONSTANT M-FATAL 2>

<CONSTANT M-HANDLED 1>   

<CONSTANT M-NOT-HANDLED <>>   

<CONSTANT M-BEG 1>  

<CONSTANT M-END 6> 

<CONSTANT M-ENTER 2>

<CONSTANT M-LOOK 3> 

<CONSTANT M-FLASH 4>

<CONSTANT M-OBJDESC 5>

<ROUTINE GO ()
	%<COND (<NOT <GASSIGNED? PREDGEN>>
		'(<SETG XTELLCHAN <OPEN "READB" ,XTELLFILE>>
		  <SETG LIT T>))
	       ('<SETG LIT T>)>
	<PUTB ,P-LEXV 0 59>
	<PUTB ,YES-LEXV 0 4>
	<SETG SCORE 0>
	<PUTB ,FIRST-NAME 0 3>
	<PUTB ,FIRST-NAME 1 %<ASCII !\->>
	<PUTB ,FIRST-NAME 2 %<ASCII !\->>
	<PUTB ,FIRST-NAME 3 %<ASCII !\->>
	<PUTB  ,LAST-NAME 0 3>
	<PUTB  ,LAST-NAME 1 %<ASCII !\->>
	<PUTB  ,LAST-NAME 2 %<ASCII !\->>
	<PUTB  ,LAST-NAME 3 %<ASCII !\->>
	;"<PUTB  ,GAME-NAME 1 %<ASCII !\S>>
	<PUTB  ,GAME-NAME 2 %<ASCII !\E>>
	<PUTB  ,GAME-NAME 3 %<ASCII !\A>>
	<PUTB  ,GAME-NAME 4 %<ASCII !\S>>
	<PUTB  ,GAME-NAME 5 %<ASCII !\T>>
	<PUTB  ,GAME-NAME 6 %<ASCII !\A>>
	<PUTB  ,GAME-NAME 7 %<ASCII !\L>>
	<PUTB  ,GAME-NAME 8 %<ASCII !\K>>
	<PUTB  ,GAME-NAME 9 %<ASCII !\E>>
	<PUTB  ,GAME-NAME 10 %<ASCII !\R>>"
	<SETG WINNER ,PLAYER>
	<SETG HERE ,CENTER-OF-LAB>
	<THIS-IS-IT ,VIDEOPHONE>
	<MOVE ,TIP ,HERE>
	<THIS-IS-IT ,TIP>
	<THIS-IS-IT ,SHARON>
	%<COND (<GASSIGNED? PREDGEN>
		'<COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
			<QUEUE-MAIN-EVENTS>
			<INTRO>)>)
	       (T '<NULL-F>)>
	<MOVE ,PLAYER ,HERE>
	<COND (<NOT ,RESTORED-DURING-NAME-INPUT> <V-LOOK>)>
	<MAIN-LOOP>
	<AGAIN>>    

<ROUTINE INTRO ("AUX" N)
	%<XTELL
"Copyright (c) 1984 Infocom, Inc.  All rights reserved.|
|
Welcome to junior-level interactive fiction from Infocom!|
|
In this story, you're the hero or heroine, so
we'll use your name!" CR>
	<REPEAT ()
		<TELL CR>
		<SET N <READ-NAME ,FIRST-NAME "Please type your first name.">>
		<COND (<==? .N ,M-FATAL> <RFALSE>)>
		%<XTELL "Hello " FN "! ">
		<SET N <READ-NAME ,LAST-NAME "Now type your last name.">>
		<COND (<==? .N ,M-FATAL> <RFALSE>)>
		%<XTELL "Is " FN " " LN " right?">
		<COND (<YES?> <RETURN>)>>
	%<XTELL "Then let the story begin!">
	<SET N 24>
	<REPEAT () <COND (<DLESS? N 0> <RETURN>) (T <CRLF>)>>
	<V-VERSION>
	<CRLF>
	%<XTELL
"\"" FN ", snap out of it!\" cries " D ,GLOBAL-TIP ", bursting into
" D ,YOUR-LABORATORY ". \"The alert signal is on!\"|
You look up from your plans for the " D ,SUB ", a top-secret submarine
that's still being tested. It's designed for capturing marine life on
the ocean floor. You notice the " D ,ALARM " on the " D ,VIDEOPHONE "
ringing. Someone's trying to reach you over the private " D ,VIDEOPHONE
" network of " D ,IU-GLOBAL "!|
" CR>>

<ROUTINE QUEUE-MAIN-EVENTS ()
	<SETG ALARM-RINGING T>
	<ENABLE <QUEUE I-ALARM-RINGING -1>>
	<QUEUE I-SHOW-SONAR 0>
	<QUEUE I-UPDATE-FREIGHTER 0>
	<QUEUE I-UPDATE-SUB-POSITION 0>
	<SETG OLD-HERE ,HERE>
	<SETG TIP-FOLLOWS-YOU? T>
	<ENABLE <QUEUE I-SNARK-ATTACKS <+ 250 <RANDOM 250>>>>
	<ENABLE <QUEUE I-LAMP-ON-SCOPE 5>>
	<ENABLE <QUEUE I-PROMPT-1 1>>
	<ENABLE <QUEUE I-PROMPT-2 10>>
	<ENABLE <QUEUE I-SHARON-GONE 25>>>


<ROUTINE MAIN-LOOP ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP) 
   #DECL ((CNT OCNT ICNT NUM) FIX (V) <OR 'T FIX FALSE> (OBJ)<OR FALSE OBJECT>
	  (OBJ1) OBJECT (TBL) TABLE (PTBL) <OR FALSE ATOM>)
   <REPEAT ()
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <COND (<NOT <==? ,QCONTEXT-ROOM ,HERE>>
	    <SETG QCONTEXT <>>)>
     <COND (<SETG P-WON <PARSER>>
	    <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
	    <SET NUM
		 <COND (<0? <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>> .OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<0? .ICNT> <SET OBJ <>>)
			      (T <SET OBJ <GET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <GET ,P-PRSO 1>>
			.ICNT)
		       (T 1)>>
	    <COND (<AND <NOT .OBJ> <1? .ICNT>> <SET OBJ <GET ,P-PRSI 1>>)>
	    <COND (<==? ,PRSA ,V?WALK>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<0? .NUM>
		   <COND (<0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (T
			  <TELL "(There isn't anything to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (,P-OFLAG
				 <PRINTB <GET .TMP 0>>)
				(T
				 <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
			  <TELL "!)" CR>
			  <SET V <>>)>)
		  (<AND .PTBL <G? .NUM 1> <VERB? COMPARE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET TMP 0>
		   <REPEAT ()
		    <COND (<G? <SET CNT <+ .CNT 1>> .NUM>
			   <COND (<G? .TMP 0>
				  <TELL "The other thing">
				  <COND (<NOT <EQUAL? .TMP 1>>
					 <TELL "s">)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .TMP 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't here." CR>)>
			   <RETURN>)
			  (T
			   <COND (.PTBL <SET OBJ1 <GET ,P-PRSO .CNT>>)
				 (T <SET OBJ1 <GET ,P-PRSI .CNT>>)>
			   <COND (<G? .NUM 1>
				  <COND (<==? .OBJ1 ,NOT-HERE-OBJECT>
					 <SET TMP <+ .TMP 1>>
					 <AGAIN>)
					(<==? .OBJ1 ,PLAYER> <AGAIN>)
					;(<FSET? .OBJ1 ,DUPLICATE> <AGAIN>)
					(T
					 <COND (<EQUAL? .OBJ1 ,IT>
						<PRINTD ,P-IT-OBJECT>)
					       (T <PRINTD .OBJ1>)>
					 <TELL ": ">)>)>
			   <SET V <QCONTEXT-CHECK <COND (.PTBL .OBJ1)
							(T .OBJ)>>>
			   <SET V
				<PERFORM ,PRSA ;"? SETG PRSx to these?"
					 <COND (.PTBL .OBJ1) (T .OBJ)>
					 <COND (.PTBL .OBJ)(T .OBJ1)>>>
			   <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG P-CONT <>>)>
     <COND (,P-WON
	    <COND (<NOT <GAME-VERB?>> <SET V <CLOCKER>>)>)>>>

<ROUTINE QCONTEXT-CHECK (PRSO "AUX" OTHER (WHO <>) (N 0))
	 <COND (<OR <VERB? ;FIND HELP WHAT>
		    <AND <VERB? SHOW TELL-ABOUT>
			 <==? .PRSO ,PLAYER>>> ;"? more?"
		<SET OTHER <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .OTHER> <RETURN>)
			      (<AND <FSET? .OTHER ,PERSON>
				    <NOT <FSET? .OTHER ,INVISIBLE>>
				    <NOT <==? .OTHER ,PLAYER>>>
			       <SET N <+ 1 .N>>
			       <SET WHO .OTHER>)>
			<SET OTHER <NEXT? .OTHER>>>
		<COND (<AND <==? 1 .N> <NOT ,QCONTEXT>>
		       <SAID-TO .WHO>)>
		<COND (<AND <QCONTEXT-GOOD?>
			    <==? ,WINNER ,PLAYER>> ;"? more?"
		       <SETG WINNER ,QCONTEXT>
		       <TELL "(said to " D ,QCONTEXT ")" CR>)>)>>

<ROUTINE QCONTEXT-GOOD? ()
 <COND (<AND ,QCONTEXT
	     <NOT <FSET? ,QCONTEXT ,INVISIBLE>>
	     <==? ,HERE ,QCONTEXT-ROOM>
	     <==? ,HERE <META-LOC ,QCONTEXT>>>
	<RTRUE>)>>

<ROUTINE SAID-TO (WHO)
	<SETG QCONTEXT .WHO>
	<SETG QCONTEXT-ROOM ,HERE>>

"<GLOBAL L-PRSA <>> 
<GLOBAL L-PRSO <>> 
<GLOBAL L-PRSI <>>"

<OBJECT OBJECT-PAIR
	(DESC "such things")
	(ACTION OBJECT-PAIR-F)>

<ROUTINE OBJECT-PAIR-F ("AUX" P1 P2)
 <COND (<L? 2 <GET ,P-PRSO ,P-MATCHLEN>>
	<COND (<VERB? COMPARE>
	       %<XTELL
"That's too many things to compare all at once!" CR>)>
	<RTRUE>)
       (<VERB? COMPARE>
	<PERFORM ,PRSA <1 ,P-PRSO> <2 ,P-PRSO>>
	<RTRUE>)>>

<ROUTINE THIS-IS-IT (OBJ)
 <COND (<NOT .OBJ>
	<RTRUE>)>
 <COND (<AND <VERB? WALK> <==? .OBJ ,PRSO>>
	<RTRUE>)>
 <COND (<NOT <FSET? .OBJ ,PERSON>>
	<COND (<NOT <EQUAL? .OBJ ,GLOBAL-HERE ,INTDIR>>
	       <SETG P-IT-OBJECT .OBJ>)>)
       (<FSET? .OBJ ,FEMALE>
	<SETG P-HER-OBJECT .OBJ>)
       (T
	<SETG P-HIM-OBJECT .OBJ>)>
 <RTRUE>>  

<ROUTINE FAKE-ORPHAN ("AUX" TMP)
	 <ORPHAN ,P-SYNTAX <>>
	 <TELL "(Be specific: what thing do you want to ">
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<==? .TMP 0> <TELL "tell">)
	       (<0? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		<PUTB ,P-VTBL 2 0>)>
	 <SETG P-OFLAG T>
	 <SETG P-WON <>>
	 <TELL "?)" CR>>

<GLOBAL NOW-PRSI <>>

<ROUTINE TELL-D-LOC (OBJ)
	<TELL D .OBJ>
	<COND (<IN? .OBJ ,GLOBAL-OBJECTS>	<TELL "(gl)">)
	      (<IN? .OBJ ,LOCAL-GLOBALS>	<TELL "(lg)">)
	      (<IN? .OBJ ,ROOMS>		<TELL "(rm)">)>>

<ROUTINE FIX-HIM-HER (HEM-OBJECT "AUX" V)
	<COND (<NOT-ACCESSIBLE? .HEM-OBJECT>
	       ;<COND (,DEBUG <TELL "[" D .HEM-OBJECT ":NA]" CR>)>
	       <RETURN <GET ,GLOBAL-CHARACTER-TABLE
			    <GETP .HEM-OBJECT ,P?CHARACTER>>>)>
	<SET V <GET ,CHARACTER-TABLE <GETP .HEM-OBJECT ,P?CHARACTER>>>
	<COND (<EQUAL? ,HERE <LOC .V>>
	       ;<COND (,DEBUG <TELL "[" D .HEM-OBJECT ":LO]" CR>)>
	       <RETURN .V>)>>

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI) 
	#DECL ((A) FIX (O) <OR FALSE OBJECT FIX> (I) <OR FALSE OBJECT> (V)ANY)
	<COND (,DEBUG
	       <TELL "[Perform: ">
	       %<COND (<GASSIGNED? PREDGEN> '<TELL N .A>)
		      (T '<PRINC <NTH ,ACTIONS <+ <* .A 2> 1>>>)>
	       <COND (.O
		      <TELL "/">
		      <COND (<==? .A ,V?WALK> <TELL N .O>)
			    (T <TELL-D-LOC .O>)>)>
	       <COND (.I
		      <TELL "/">
		      <TELL-D-LOC .I>)>
	       <TELL "]" CR>)>
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<COND (<NOT <EQUAL? .A ,V?WALK>>
	       <COND (<AND <EQUAL? ,IT .I .O>
			   <NOT-ACCESSIBLE? ,P-IT-OBJECT>>
		      <COND (<NOT .I> <FAKE-ORPHAN>)
			    (T <TELL
"(Sorry, but" THE ,P-IT-OBJECT " isn't here!)" CR>)>
		      <RFATAL>)>
	       <COND (<EQUAL? ,HER .I .O>
		      <COND (<SET V <FIX-HIM-HER ,P-HER-OBJECT>>
			     <COND (<==? ,HER .O> <SET O .V>)>
			     <COND (<==? ,HER .I> <SET I .V>)>)>)>
	       <COND (<EQUAL? ,HIM .I .O>
		      <COND (<SET V <FIX-HIM-HER ,P-HIM-OBJECT>>
			     <COND (<==? ,HIM .O> <SET O .V>)>
			     <COND (<==? ,HIM .I> <SET I .V>)>)>)>
	       <COND (<==? .O ,IT>  <SET O ,P-IT-OBJECT>)
		     (<==? .O ,HER> <SET O ,P-HER-OBJECT>)
		     (<==? .O ,HIM> <SET O ,P-HIM-OBJECT>)>
	       <COND (<==? .I ,IT>  <SET I ,P-IT-OBJECT>)
		     (<==? .I ,HER> <SET I ,P-HER-OBJECT>)
		     (<==? .I ,HIM> <SET I ,P-HIM-OBJECT>)>)>
	<SETG PRSI .I>
	<SETG PRSO .O>
	<COND (<AND <NOT <EQUAL? .A ,V?WALK>>
		    <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>
		    <SET V <D-APPLY "Not Here" ,NOT-HERE-OBJECT-F>>>
	       <SETG P-WON <>>
	       .V)
	      (<AND <THIS-IS-IT ,PRSI>
		    <THIS-IS-IT ,PRSO>
		    <SET O ,PRSO>
		    <SET I ,PRSI>
		    <NULL-F>>
	       <NULL-F>)		;"[in case last clause changed PRSx]"
	      (<SET V <DD-APPLY "Actor" ,WINNER <GETP ,WINNER ,P?ACTION>>> .V)
	      (<SET V <D-APPLY "Room (M-BEG)"
			       <GETP <LOC ,WINNER> ,P?ACTION>
			       ,M-BEG>> .V)
	      (<SET V <D-APPLY "Preaction"
			       <GET ,PREACTIONS .A>>> .V)
	      (<AND .I
		    <SETG NOW-PRSI T>
		    <SET V <D-APPLY "PRSI" <GETP .I ,P?ACTION>>>>
	       .V)
	      (<AND <NOT <SETG NOW-PRSI <>>>
		    .O
		    <NOT <==? .A ,V?WALK>>
		    <LOC .O>
		    <GETP <LOC .O> ,P?CONTFCN>
		    <SET V <DD-APPLY "Container" <LOC .O>
				    <GETP <LOC .O> ,P?CONTFCN>>>>
	       .V)
	      (<AND .O
		    <NOT <==? .A ,V?WALK>>
		    <SET V <D-APPLY "PRSO"
				    <GETP .O ,P?ACTION>>>>
	       .V)
	      (<SET V <D-APPLY <>
			       <GET ,ACTIONS .A>>> .V)>
	<COND (<NOT <==? .V ,M-FATAL>>
	       <COND (<==? <LOC ,WINNER> ,PRSO>	;"was not in compiled PERFORM"
		      <SETG PRSO <>>)>
	       <SET V <D-APPLY "Room (M-END)"
			       <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>

<ROUTINE DD-APPLY (STR OBJ FCN)
	<COND (,DEBUG <TELL "[" D .OBJ "=]">)>
	<D-APPLY .STR .FCN>>

<ROUTINE D-APPLY (STR FCN "OPTIONAL" (FOO <>) "AUX" RES)
	<COND (<NOT .FCN> <>)
	      (T
	       <COND (,DEBUG
		      <COND (<NOT .STR>
			     <TELL "[Action:]" CR>)
			    (T <TELL "[" .STR ": ">)>)>
	       <SET RES
		    <COND (.FOO <APPLY .FCN .FOO>)
			  (T <APPLY .FCN>)>>
	       <COND (<AND ,DEBUG .STR>
		      <COND (<==? .RES ,M-FATAL>
			     <TELL "Fatal]" CR>)
			    (<NOT .RES>
			     <TELL "Not handled]" CR>)
			    (T <TELL "Handled]" CR>)>)>
	       .RES)>>

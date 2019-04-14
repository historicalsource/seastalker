"BATTLE for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

<GLOBAL SUB-IN-BATTLE <>>
<GLOBAL THORPE-LON 0>	"position"
<GLOBAL THORPE-LAT 0>
<GLOBAL THORPE-DLON -1>	"motion"
<GLOBAL THORPE-DLAT +1>
<GLOBAL THORPE-HLON -1>	"heading"
<GLOBAL THORPE-HLAT +1>
<GLOBAL SNARK-LON +1>	"position"
<GLOBAL SNARK-LAT -1>
<GLOBAL SNARK-HLON -1>	"heading"
<GLOBAL SNARK-HLAT +1>
<GLOBAL SNARK-TRANKED <>>

<ROUTINE THORPE-SHOOT? (X Y)
	<COND (,SNARK-TRANKED
	       <FORWARD-OF-THORPE? .X .Y>)
	      (T
	       <AND <STARBOARD-OF-THORPE? .X .Y>
		    <FORWARD-OF-THORPE? .X .Y>>)>>

<ROUTINE STARBOARD-OF-THORPE? (X Y)
 <COND (<NOT <G? 0 <- <* ,THORPE-HLAT <- .X ,THORPE-LON>>
		      <* ,THORPE-HLON <- .Y ,THORPE-LAT>>>>>
	<RTRUE>)
       (T <RFALSE>)>>

<ROUTINE FORWARD-OF-THORPE? (X Y)
 <COND (<NOT <G? 0 <- <* ,THORPE-HLON <- .X ,THORPE-LON>>
		      <* ,THORPE-HLAT <- ,THORPE-LAT .Y>>>>>
	<RTRUE>)
       (T <RFALSE>)>>

<ROUTINE THORPE-POS? (LON LAT)
	<COND (<NOT <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>>
	       <RFALSE>)
	      (<AND <==? .LAT <- ,THORPE-LAT ,THORPE-HLAT>>
		    <==? .LON <- ,THORPE-LON ,THORPE-HLON>>>
	       <RTRUE>)
	      (<AND <==? .LAT ,THORPE-LAT>
		    <==? .LON ,THORPE-LON>>
	       <RTRUE>)>>

<ROUTINE SNARK-POS? (LON LAT)
	<OR <SNARK-HEAD-POS? .LON .LAT>
	    <SNARK-TAIL-POS? .LON .LAT>>>

<ROUTINE SNARK-HEAD-POS? (LON LAT)
	<COND (<NOT <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>>
	       <RFALSE>)
	      (<AND <==? .LAT ,SNARK-LAT> <==? .LON ,SNARK-LON>>
	       <RTRUE>)>>

<ROUTINE SNARK-TAIL-POS? (LON LAT "AUX" X Y HLON HLAT)
	<COND (<NOT <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>>
	       <RFALSE>)
	      (,SNARK-TRANKED
	       <SET HLON ,SNARK-HLON>
	       <SET HLAT ,SNARK-HLAT>)
	      (T
	       <SET HLON ,THORPE-HLON>
	       <SET HLAT ,THORPE-HLAT>)>
	<SET X <- ,SNARK-LON .HLON>>
	<SET Y <- ,SNARK-LAT .HLAT>>
	<COND (<AND <==? .LAT .Y> <==? .LON .X>>
	       <RTRUE>)>
	<SET X <- .X .HLON>>
	<SET Y <- .Y .HLAT>>
	<COND (<AND <==? .LAT .Y> <==? .LON .X>>
	       <RTRUE>)>
	<COND (<AND <==? .LAT <- .Y .HLAT>>
		    <==? .LON <- .X .HLON>>>
	       <RTRUE>)>>

<OBJECT SNARK
	(IN SUB)
	(FLAGS NDESCBIT INVISIBLE)
	(DESC "Snark")
	(ADJECTIVE SEA THIS HUGE)
	(SYNONYM SNARK MONSTER SLUG CREATURE ;BOOJUM)
	(VALUE 5)
	(ACTION THORPE-SUB-F)>

<OBJECT THORPE-SUB
	(IN SUB)
	(FLAGS NDESCBIT INVISIBLE ;NARTICLEBIT)
	(DESC "Sea Cat" ;"Thorpe's tractor")
	(ADJECTIVE DOCTOR DOC\'S JEROME THORPE MARINE AQUATIC SEA POWER)
	(SYNONYM TRACTOR ;SUB CAT SEACAT POD)
	(VALUE 5)
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(ACTION THORPE-SUB-F)>

<ROUTINE THORPE-SUB-F ()
 <COND (<VERB? FIND> <TELL "It's not far away!" CR>)
       (<VERB? MOVE PUSH> <TELL "It's too big!" CR>)
       (<VERB? SHOOT KILL ATTACK>
	<TELL
"You have to shoot" THE-PRSO " with a weapon." CR>)
       (<VERB? WALK-TO> <TELL "You're the pilot!" CR>)>>

<GLOBAL THORPE-TURNING? <>>

<ROUTINE I-UPDATE-THORPE ("AUX" DLAT DLON Z)
 <COND (,SUB-IN-BATTLE
	<SET Z <* ,THORPE-HLON ,THORPE-HLAT>>
	<COND (<NOT <THORPE-SHOOT? ,SUB-LON ,SUB-LAT>>
	       <COND (<AND <0? ,THORPE-DLON> <0? ,THORPE-DLAT>>
		      <SETG THORPE-TURNING? <NOT ,THORPE-TURNING?>>
		      <COND (,THORPE-TURNING? T)
			    (<STARBOARD-OF-THORPE? ,SUB-LON ,SUB-LAT>
			     <COND (<0? ,THORPE-HLON>
				    <SETG THORPE-HLON ,THORPE-HLAT>)
				   (<==? -1 .Z>
				    <SETG THORPE-HLON 0>)
				   (<==? +1 .Z>
				    <SETG THORPE-HLAT 0>)
				   (T <SETG THORPE-HLAT <- ,THORPE-HLON>>)>)
			    (T
			     <COND (<0? ,THORPE-HLON>
				    <SETG THORPE-HLON <- ,THORPE-HLAT>>)
				   (<==? -1 .Z>
				    <SETG THORPE-HLAT 0>)
				   (<==? +1 .Z>
				    <SETG THORPE-HLON 0>)
				   (T <SETG THORPE-HLAT ,THORPE-HLON>)>)>)
		     (T <SETG THORPE-DLON 0> <SETG THORPE-DLAT 0>)>
	       ;<COND (,DEBUG
		      <TELL "[T-HLon=" N ,THORPE-HLON
			   ", T-HLat=" N ,THORPE-HLAT "]" CR>)>)
	      (T
	       <TELL
"Thorpe zeroed in on you and fired his rocket! It streaks through the
water toward the " D ,SUB "! In an instant your sub will be just twisted
metal, trapping you and Tip forever in Davy Jones's locker!">
	       <FINISH>)>)>
	<SETG THORPE-LON <+ ,THORPE-LON ,THORPE-DLON>>
	<SETG THORPE-LAT <+ ,THORPE-LAT ,THORPE-DLAT>>
	;<COND (,DEBUG
	       <TELL "[T-Lon=" N ,THORPE-LON ", T-Lat=" N ,THORPE-LAT "]"CR>)>
	<SET Z <* ,THORPE-HLON ,THORPE-HLAT>>
	<COND (<0? .Z>
	       <COND (<0? ,THORPE-HLAT>
		      <SETG SNARK-LAT <+ ,THORPE-LAT ,THORPE-HLON>>
		      <SETG SNARK-LON <+ ,THORPE-LON ,THORPE-HLON>>)
		     (T
		      <SETG SNARK-LAT <+ ,THORPE-LAT ,THORPE-HLAT>>
		      <SETG SNARK-LON <- ,THORPE-LON ,THORPE-HLAT>>)>)
	      (<==? -1 .Z>
	       <SETG SNARK-LON <+ ,THORPE-LON ,THORPE-HLON>>
	       <SETG SNARK-LAT ,THORPE-LAT>)
	      (<==? +1 .Z>
	       <SETG SNARK-LAT <+ ,THORPE-LAT ,THORPE-HLAT>>
	       <SETG SNARK-LON ,THORPE-LON>)>
	<RFALSE>>

<GLOBAL LON-AIMED-AT <TABLE 0 0>>
<GLOBAL LAT-AIMED-AT <TABLE 0 0>>
<GLOBAL OBJ-AIMED-AT <TABLE 0 0>>
<GLOBAL ALREADY-SHOT <TABLE <> <>>>
<GLOBAL ON-SUB <TABLE <> <>>>

<OBJECT DART
	(IN DOME-LAB ;GLOBAL-OBJECTS)
	(DESC "dart gun")
	(ADJECTIVE	AQUATIC DART TRANQUILIZER TRANK)
	(SYNONYM	DART GUN WEAPON)
	(FLAGS WEAPONBIT MUNGBIT ;TAKEBIT TRYTAKEBIT NDESCBIT)
	(LDESC "There's a dart gun here.")	;"need prop to change later"
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(VALUE 5)
	(ACTION DART-F)>

<ROUTINE DART-F () <WEAPON-F ,DART>>

<ROUTINE MOUNTING-VERB? (OBJ)
 <COND (<NOT ,SUB-IN-DOME> <RFALSE>)
       (<AND <EQUAL? ,PRSO .OBJ>
	     <OR <VERB? USE>
		 <AND <VERB? SHOW>
		      <DOBJ? BLY>
		      <IOBJ? BAZOOKA>>
		 <AND <VERB? PUT-UNDER>
		      <DOBJ? ESCAPE-POD-UNIT>
		      <IOBJ? CHAIR PILOT-SEAT>>
		 <AND <VERB? PUT TIE-TO>
		      <IOBJ? GLOBAL-SUB LOCAL-SUB CLAW ;GLOBAL-HERE>>>>
	<RTRUE>)
       ;(<AND <EQUAL? ,PRSI .OBJ>
	     <AND <VERB? TELL-ABOUT ASK-ABOUT>
		  <FSET? ,PRSO ,PERSON>>>
	<RTRUE>)>>

<ROUTINE NO-GOOD-MUNGED ()
	<TELL D ,HORVAK " has to fix it first." CR>>

<ROUTINE WEAPON-F (OBJ "AUX" (WHICH 0) O (NOT-ON-SUB <>) (SOMEONE <>))
 <COND (<BAD-AIR?>	;<FSET? ,BLY ,MUNGBIT>
	<RTRUE>)
       (<VERB? FIND SEARCH-FOR TAKE> T)
       (<MOUNTING-VERB? .OBJ> T)
       (<REMOTE-VERB?> <RFALSE>)>
 <COND (<EQUAL? .OBJ ,DART>
	<SET WHICH 1>)>
 <COND (<NOT <==? .OBJ <GET ,ON-SUB .WHICH>>>
	<SET NOT-ON-SUB T>)>
 <COND (<AND <NOT ,SUB-IN-DOME> .NOT-ON-SUB>
	<TELL "You can't use" THE .OBJ " now!" CR>
	<RTRUE>)>
 <COND (.NOT-ON-SUB
	<COND (<VERB? FIND SEARCH-FOR>
	       <COND (<AND <EQUAL? ,HERE <LOC .OBJ>>
			   <NOT <FSET? .OBJ ,TOUCHBIT>>>
		      <FCLEAR .OBJ ,NDESCBIT>
		      <HE-SHE-IT ,WINNER T "find">
		      <TELL " it among lots of equipment and supplies." CR>)>)
	      (<VERB? TAKE>
	       <COND (<1? .WHICH>
		      <FCLEAR ,DART ,NDESCBIT>
		      <COND (<FSET? ,DART ,MUNGBIT>
			     <NO-GOOD-MUNGED>)>)>)
	      (<MOUNTING-VERB? .OBJ>
	       <COND (<NOT <==? ,WINNER ,PLAYER>> <SET SOMEONE ,WINNER>)
		     (<SET SOMEONE <FIND-FLAG ,HERE ,PERSON ,PLAYER>> T)>
	       <COND (<NOT .SOMEONE>
		      <COND (<NOT <==? ,HERE <META-LOC .OBJ>>>
			     <NOT-HERE .OBJ>
			     <RTRUE>)
			    (<NOT <==? ,HERE ,AIRLOCK>>
			     <NOT-HERE ,CLAW>
			     <RTRUE>)>)>
	       <COND (<0? .WHICH>
		      <COND (<AND .SOMEONE <NOT <==? ,HERE ,AIRLOCK>>>
			     <TELL
"\"Good idea! That should stop the " D ,SNARK "! It could disable an
enemy sub, too! Shall I ">
			     <COND (<VERB? PUT> <TELL "do it">)
				   (T
				    <TELL "have it mounted">
				    <COND (<NOT <IOBJ? CLAW>>
					   <TELL
" on an " D ,CLAW " of the " D ,SUB>)>)>
			     <TELL "?\"">
			     <COND (<YES?>
				    <MOUNT-WEAPON ,BAZOOKA>
				    <FINE-SEQUENCE>)>
			     <RTRUE>)
			    (T
			     <MOUNT-WEAPON ,BAZOOKA>
			     <OKAY ,BAZOOKA "mounted">
			     <FINE-SEQUENCE>
			     <RTRUE>)>)
		     (<FSET? ,DART ,MUNGBIT>
		      <NO-GOOD-MUNGED>)
		     (T
		      <MOUNT-WEAPON ,DART>
		      <COND (<AND .SOMEONE <NOT <==? ,HERE ,AIRLOCK>>>
			     <TELL
D .SOMEONE " promptly mounts the " D ,DART " on an " D ,CLAW "." CR>)
			    (T
			     <OKAY ,DART "mounted">)>
		      <COND (<==? ,BAZOOKA <GET ,ON-SUB 0>>
			     <FINE-SEQUENCE>)>
		      <RTRUE>)>)>)
       (T
	<COND (<VERB? FIND EXAMINE>
	       <TELL
"It's mounted on one of the " D ,SUB "'s " D ,CLAW "s." CR>)
	      (<OR <VERB? TAKE> <MOUNTING-VERB? .OBJ>>
	       <TELL "You'd better leave it mounted on the " D ,CLAW "."CR>)
	      (<REMOTE-VERB?> <RFALSE>)
	      ;(,SUB-IN-DOME	;<NOT <EQUAL? ,HERE ,SUB>>
	       <TELL
"You shouldn't do that inside the " D ,AQUADOME "!" CR>)
	      (<VERB? MOVE MOVE-DIR>
	       <TELL "You should type where you want to aim it." CR>)
	      (<VERB? AIM>
	       <COND (<FSET? ,CLAW ,MUNGBIT>
		      <TELL
"Nothing happens. Either the " D ,CLAW " or the " D .OBJ " was damaged
when you rammed the " D ,SNARK "!" CR>
		      <RTRUE>)
		     (<IOBJ? THORPE-SUB GLOBAL-THORPE>
		      <COND (<NOT <STARBOARD-OF-THORPE? ,SUB-LON ,SUB-LAT>>
			     <YOU-CANT "aim" ,GLOBAL-SNARK "in the way">
			     <RTRUE>)
			    (T
			     <COND (,SUB-IN-BATTLE <SCORE-OBJ ,THORPE-SUB>)>
			     <PUT ,OBJ-AIMED-AT .WHICH ,THORPE-SUB>
			     <PUT ,LON-AIMED-AT .WHICH ,THORPE-LON>
			     <PUT ,LAT-AIMED-AT .WHICH ,THORPE-LAT>)>)
		     (<IOBJ? SNARK GLOBAL-SNARK>
		      <PUT ,OBJ-AIMED-AT .WHICH ,SNARK>
		      <PUT ,LON-AIMED-AT .WHICH ,SNARK-LON>
		      <PUT ,LAT-AIMED-AT .WHICH ,SNARK-LAT>)
		     (T <RFALSE>)>
	       ;<COND (<AND ,DEBUG <GET ,OBJ-AIMED-AT .WHICH>>
		      <TELL "[at: " D <GET ,OBJ-AIMED-AT .WHICH> "] ">)>
	       <TELL "Aimed." CR>)
	      (<VERB? SHOOT KILL ATTACK>
	       <SET O <GET ,OBJ-AIMED-AT .WHICH>>
	       <COND (<GET ,ALREADY-SHOT .WHICH>
		      <TELL "You already shot" THE-PRSI "!" CR>
		      <RTRUE>)
		     (<NOT .O>
		      <TELL "You have to aim it first!" CR>
		      <RTRUE>)>
	       ;<COND (<0? .I> <SET I ,PRSO>)>
	       <COND (<OR <AND <==? ,THORPE-SUB .O>
			       <NOT <DOBJ? THORPE-SUB GLOBAL-THORPE>>>
			  <AND <==? ,SNARK .O>
			       <NOT <DOBJ? SNARK GLOBAL-SNARK>>>>
		      <TELL "You didn't aim it at" THE-PRSO "." CR>
		      <RTRUE>)>
	       <COND (<DOBJ? THORPE-SUB GLOBAL-THORPE>
		      <COND (<AND <==? <GET ,LON-AIMED-AT .WHICH> ,THORPE-LON>
				  <==? <GET ,LAT-AIMED-AT .WHICH>,THORPE-LAT>>
			     <PUT ,ALREADY-SHOT .WHICH T>
			     <COND (<0? .WHICH> <MUNG-TARGET>)
				   (T
				    <TELL
"Fudge! Your tranquilizer dart hit the " D ,THORPE-SUB ", and its metal
hull can't be put to sleep! Tough luck, "FN"." CR>)>)
			    (T
			     <TOO-BAD-BUT ,PRSO>
			     <TELL " moved since you aimed." CR>)>)
		     (<DOBJ? SNARK GLOBAL-SNARK>
		      <COND (<AND <==? <GET ,LON-AIMED-AT .WHICH> ,SNARK-LON>
				  <==? <GET ,LAT-AIMED-AT .WHICH> ,SNARK-LAT>>
			     <PUT ,ALREADY-SHOT .WHICH T>
			     <SETG SNARK-TRANKED T>
			     <SETG SNARK-HLON ,THORPE-HLON>
			     <SETG SNARK-HLAT ,THORPE-HLAT>
			     <COND (<0? .WHICH>
				    <TELL
"KA-VOOOM! The " D ,SNARK " shudders and stops moving! You scored a
clean hit with your " D ,BAZOOKA "!|
">
				    <TIP-SAYS>
				    <TELL
"Rats! There goes our safety shield!\" And he's right.
Even though you've saved the " D ,AQUADOME " from further danger of
monster attack, the " D ,SUB " is now exposed to the " D ,THORPE-SUB
"'s rocket weapon!" CR>)
				   (T <TELL
"Right on! The dart hits the " D ,SNARK " and sticks out of its side.
The tranquilizer spreads through the " D ,SNARK ", sending it to Slumberland.|
But this may have been a bad move. With the " D ,SNARK " fast asleep, its
huge body can't hide you from the " D ,THORPE-SUB "'s rocket attack!"
CR>)>)
			    (T
			     <TOO-BAD-BUT ,PRSO>
			     <TELL " moved since you aimed." CR>)>)
		     ;(T <RFALSE>)>)>)>>

<ROUTINE MUNG-TARGET ()
	<SCORE-UPD 5>
	<FSET ,PRSO ,MUNGBIT>
	<TELL
"Great! You and Tip can see" THE-PRSI " slam into the " D ,THORPE-SUB"'s power
pod!|
\"Hooray! That crippled the " D ,THORPE-SUB " for keeps!\" Tip cheers.|
You hear a voice come over the " D ,SONARPHONE ": ">
	<REPEAT ()
		<TELL "\"" FN ", this is Sharon! Do you read me?\"">
		<COND (<YES?> <RETURN>)>>
	<TELL
"\"Something hit us, and Thorpe's out cold! He cracked his skull on the
bulkhead! I was waking up when I saw it all happen. I'll tie him up so
he can't cause any trouble.|
The " D ,THORPE-SUB "'s regular engine is kaput, but he installed a
backup engine for emergencies. And the sonar control's still working. If
you like, I'll guide the monster to its cavern.\"|
">
	<COND (<NOT <0? <GETP ,GREENUP ,P?VALUE>>>
	       <TIP-SAYS>
	       <TELL
"It's too bad we didn't find the " D ,TRAITOR " at the " D ,AQUADOME ".\"|
">)>
	<TELL "|
CONGRATULATIONS, ">
	<PRINT-NAME ,FIRST-NAME T>
	<TELL
"! YOU'VE COMPLETED YOUR MISSION!!">
	<FINISH>>

<ROUTINE MOUNT (WHICH WEAPON "AUX" OBJ)
	<COND (<SET OBJ <GET ,ON-SUB .WHICH>> <MOVE .OBJ ,AIRLOCK>)>
	<PUT ,ON-SUB .WHICH .WEAPON>
	;<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE> <MOVE .WEAPON ,SUB>)
	      (T <MOVE .WEAPON ,AIRLOCK>)>>

<ROUTINE MOUNT-WEAPON (OBJ)
	<COND (<==? .OBJ ,BAZOOKA>
	       <SCORE-OBJ ,BLY>
	       <PUTP ,BAZOOKA ,P?LDESC "The bazooka is mounted on a claw.">
	       <COND (<NOT <0? <GETP ,BAZOOKA ,P?VALUE>>>
		      <TELL "\"Of course I'll have to get it first.\"" CR>
		      <SCORE-OBJ ,BAZOOKA>)>
	       <MOUNT 0 ,BAZOOKA>)
	      (<==? .OBJ ,DART>
	       <PUTP ,DART ,P?LDESC "The dart is mounted on a claw.">
	       <SCORE-OBJ ,HORVAK>
	       <MOUNT 1 ,DART>)
	      (<GET ,ON-SUB 0>
	       <COND (<GET ,ON-SUB 1>
		      <TELL "The claws are holding all they can." CR>
		      <RFALSE>)
		     (T <PUT ,ON-SUB 1 .OBJ>)>)
	      (T <PUT ,ON-SUB 0 .OBJ>)>
	<COND (<EQUAL? ,HERE ,SUB ,CRAWL-SPACE> <MOVE .OBJ ,SUB>)
	      (,SUB-IN-DOME <MOVE .OBJ ,AIRLOCK>)
	      (T <MOVE .OBJ ,NORTH-TANK-AREA>)>
	<FSET .OBJ ,NDESCBIT>
	<FCLEAR .OBJ ,TAKEBIT>
	<FSET .OBJ ,TRYTAKEBIT>>

<ROUTINE FINE-SEQUENCE ()
	<COND (<NOT ,TIP-FOLLOWS-YOU?>
	       <RFALSE>)
	      (<READY-FOR-SNARK?>
	       <RFALSE>)>
	<MOVE-HERE-NOT-SUB ,BLY>
	<TELL "\"Are you ready to take off now, "FN"?\" Zoe Bly "
		<COND (<IN? ,BLY ,HERE> "ask") (T "shout")>
		"s anxiously.">
	<COND (<NOT <YES?>> <RFALSE>)>
	<TELL "\"Wait!\" Tip cuts in. ">
	<SETG WINNER ,PLAYER>
	<PERFORM ,V?ASK-ABOUT ,TIP ,FINE-GRID>>

<OBJECT BAZOOKA
	(IN DOME-STORAGE)
	(DESC "bazooka")
	(ADJECTIVE 49-ER 49ER PROSPECTING)
	(SYNONYM BAZOOKA GUN WEAPON)
	(FLAGS NDESCBIT WEAPONBIT TAKEBIT)
	(LDESC "There's a bazooka here.")	;"need prop to change later"
	(TEXT "(You'll find that information in your SEASTALKER package.)")
	(VALUE 5)
	(ACTION BAZOOKA-F)>

<ROUTINE BAZOOKA-F () <WEAPON-F ,BAZOOKA>>

<ROUTINE I-THORPE-APPEARS ()
 <COND (<OR <G? +17 ,SUB-LON>
	    <L? -17 ,SUB-LAT>
	    <NOT <==? ,SUB-DEPTH ,AIRLOCK-DEPTH>>>
	<COND (<L? 40 <- ,MOVES ,LEFT-DOME>>
	       <SETG LEFT-DOME ,MOVES>
	       <TELL "Suddenly ">
	       <TIP-SAYS>
	       <TELL FN>
	       <COND (<==? ,SUB-DEPTH ,AIRLOCK-DEPTH>
		      <TELL
", what " D ,INTDIR " do you think the " D ,SNARK " went, anyway?\"" CR>)
		     (T <TELL
", I wonder if we're at the right depth?\"" CR>)>)>)
       (T
	<QUEUE I-SNARK-ATTACKS 0>
	<QUEUE I-THORPE-APPEARS 0>
	<ENABLE <QUEUE I-THORPE-AWAKES 9 ;-1>>
	<FSET ,SEARCH-BEAM ,ONBIT>
	<TELL
"\"Holy halibut!\" cries Tip. \"There's a big cloud of silt ahead in the "
D ,SEARCH-BEAM ". It's out of sonar range. This
could be the " D ,SNARK "! Want to hold course till we find out?\"">
	<YES?>
	<TELL
"However you steer, the cloud holds steady.
You may be on a collision course with the behemoth
that almost wrecked the " D ,AQUADOME "!|
">
	<TELL
"Your " D ,SEARCH-BEAM " reveals TWO
objects dead ahead!|
One is the " D ,SNARK ". To the left of the tentacled
creature -- YOUR left -- you can make out a vehicle
crawling along the ocean floor.|
">
	<TIP-SAYS>
	<TELL
"That's one of your Sea Cats!\"|
A voice crackles over the " D ,SONARPHONE ": \"This is " D ,GLOBAL-THORPE
", " FN "! Do you read me?\"">
	<YES?>
	<TELL
"Your answer brings a rasping laugh. \"Of course
you read me, or you wouldn't be answering!
Your " D ,LAB-ASSISTANT
", " D ,SHARON ", is
seated behind me. She'll enjoy what's about to happen as much as I will.
Would you like to hear what's in store for you?\"">
	<COND (<NOT <YES?>>
	       <TELL "\"You'll soon find out -- like it or not! ">)
	      (T <TELL "\"">)>
	<TELL
"I'll blast your sub with a rocket! Then I'll guide my
synthetic monster to the " D ,AQUADOME " to destroy it! Can you guess
what sealed your doom, " FN "?\"">
	<COND (<NOT <YES?>> <TELL "\"">)
	      (T <TELL "\"I'll tell you anyhow. ">)>
	<TELL
"I want to own the " D ,ORE-NODULES " near the " D ,AQUADOME
"! Sharon and I consider it a wedding present from you and your dad ...\"|
Thorpe breaks off with a sudden gulp, followed by some noise and
then a soft female voice:|
">
	<REPEAT ()
		<TELL "\"This is " D ,SHARON ", " FN "! Do you read me?\"">
		<COND (<YES?>
		       <RETURN>)>>
	<PHONE-ON ,GLOBAL-SHARON ,THORPE-SUB ,SONARPHONE ;,SUB>
	<ENABLE <QUEUE I-UPDATE-THORPE -1>>
	<FCLEAR ,SNARK ,INVISIBLE>
	<FCLEAR ,THORPE-SUB ,INVISIBLE>
	<SETG THORPE-LON <+ 2 <+ ,SUB-LON ,SONAR-RANGE>>>
	<SETG THORPE-LAT <- ,SUB-LAT ,SONAR-RANGE>>
	<SETG SNARK-LON <+ ,THORPE-LON ,THORPE-HLON>>
	<SETG SNARK-LAT ,THORPE-LAT>
	<FSET ,THORPE ,MUNGBIT>
	<TELL
"\"Thank goodness! I conked Thorpe with a wrench! He fell onto the
microphone, and he's too heavy for me to move!\"" CR>
	<SCORE-OBJ ,SNARK>
	<RFATAL>)>>

<ROUTINE SHARON-EXPLAINS ()
	<COND (<NOT <VERB? SAY>>
	       <TELL
"\"Wait a second, "FN", till I catch my breath!\" Sharon cuts in. ">)>
	<SHARON-ABOUT-THORPE>
	<TELL "\"Can I interrupt, "FN"?\" asks Tip.">
	<COND (<NOT <YES?>>
	       <TIP-SAYS>
	       <TELL
"Sorry, but I have to. This is important.\"|
">)>
	<TELL
"\"Sharon, how does Thorpe control the monster?\"|
\"By sonar pulse signals,\" she replies. ">
	<SHARON-ABOUT-MONSTER>
	<TELL
"\"Is the transducer sending out signals now?\" Tip asks her.|
\"Yes, it operates all the time. Can you make out our position on your "
D ,SONARSCOPE "?\"|
\"Thanks to the " D ,FINE-GRID "!\" says Tip.">
	<COND (<NOT <0? ,THROTTLE-SETTING>>
	       <SETG THROTTLE-SETTING 0>
	       <TELL
" \"Maybe we'd better stop the " D ,SUB " before we collide with you!\"|
Tip uses his dual-control throttle to stop your sub.
Then he adds apologetically:
\"This isn't mutiny, "FN"! I just figured we should stop now.\"">)>
	<CRLF>
	<SHARON-ABOUT-CAT>
	<TELL
"\"Was it out of control when it attacked the " D ,AQUADOME "?\" asks Tip.|
\"Oh no!\" Sharon replies. ">
	<REPEAT ()
		<TELL
"\"Thorpe has a helper at the " D ,AQUADOME " who put a
" D ,BLACK-BOX " on the " D ,SONAR-EQUIPMENT ", which made it emit signals to
ATTRACT the monster and make it attack. Do you follow me so far, " FN "?\"">
		<COND (<YES?> <RETURN>)>>
	<TELL
"\"Good. Before that first attack, Thorpe got the monster close enough
for the " D ,BLACK-BOX " to take over. Then he surfaced near " D ,BAY
" to get me.
By the time we went back to the ocean floor, something had gone wrong: the " D
,AQUADOME " was okay, and the monster had wandered off to its cavern.
That reminds me, "FN". ">
	<REPEAT ()
		<TELL
"Do you want to take the monster to its cavern peacefully? (With no
more sonar pulse input, it'll stay there until you're ready to study it
scientifically.)\"">
		<COND (<YES?> <RETURN>)>
		<TELL
"(Better listen, "FN". Sharon's trying to show you how to deal with
this threat to the " D ,AQUADOME ".)|
\"">>
	<TELL
"\"First tell me, "FN": do you have any tranquilizer or weapon
to use against it?\"">
	<COND (<YES?>
	       <TELL "\"Do you want to capture it for scientific study?\"">
	       <COND (<YES?>
		      <TELL
"\"Then try the following:|
Position your sub on the other side of the monster -- on the monster's
LEFT side -- just 5 meters from it. If anything goes wrong and it gets out
of control, you can tranquilize it immediately.\"" CR>)
		     (T <TELL "\"That's odd! I thought you would.\"" CR>)>)>
	<RTRUE>>

<ROUTINE SHARON-ABOUT-THORPE ()
	<TELL
"\"I'm not in on Thorpe's plot, "FN". I'm playing along, trying to wreck
his plans. I know it was risky for me to leave that " D
,CATALYST-CAPSULE " out of the " D ,SUB>
	<COND (,SHARON-BROKE-CIRCUIT
	       <TELL ", and to open that " D ,CIRCUIT-BREAKER>)>
	<TELL
", but it was part of my plan, and you got to the " D ,AQUADOME " anyway.\""
CR>>

<ROUTINE SHARON-ABOUT-MONSTER ()
	<TELL
"\"It's sensitive to the signals on its RIGHT side.
Thorpe has installed a sonar transducer on the LEFT or
PORT side of this sub. He has to stay on the same side of
the monster all the time.\"">>

<ROUTINE SHARON-ABOUT-CAT ()
	<TELL
"Sharon says, \"Notice how we keep 5 meters to the monster's right and 5
meters behind its nose.
The Sea Cat is programmed that way, so the signals reach
the monster with enough strength to keep it in control.\"">>

<ROUTINE I-THORPE-AWAKES ()
	<FCLEAR ,THORPE ,MUNGBIT>
	<SETG SUB-IN-BATTLE T>
	<PHONE-OFF>
	<PHONE-ON ,GLOBAL-THORPE ,THORPE-SUB ,SONARPHONE>
	<TELL "|
Suddenly the sonarphone gets louder.|
">
	<TIP-SAYS>
	<TELL
"That could mean Thorpe is awake and has moved away from the microphone!\"|
You hear a sharp cry of pain from Sharon, then Thorpe yelling: \"That'll
take care of you, my little double-crosser!\"|
Thorpe speaks into the microphone: \"Now then, "FN" "LN", I'm stopping my "
D ,THORPE-SUB " so I can blow you into
Kingdom Come as soon as you're in my sights!\"|
">
	<COND (<NOT <STARBOARD-OF-THORPE? ,SUB-LON ,SUB-LAT>>
	       <TIP-SAYS>
	       <TELL
"He'll have to go around the " D ,SNARK " to fire at us, "FN"!
And we'll have to go around its tail to shoot at HIM!\"|
">)>
	<TELL-HINT 42 ;25 ,THORPE-SUB <>>
	<RFATAL>>

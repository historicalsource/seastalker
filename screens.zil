"The SPLIT & SCREEN operations allow you to divide the screen into two
parts: one that behaves as usual and another that you update without
scrolling.

<SPLIT INT>
divides the screen into two windows: #1 occupies INT lines, preferably
at the top of the screen, and #0 occupies the remainder of the screen.
<SPLIT 0>
restores the normal screen format.

<SCREEN INT>
causes subsequent screen output to fall into window #INT.
If INT is 1, the output cursor is moved to the upper left-hand corner;
if INT is 0, the output cursor is restored to its previous position.
You should be careful not to let window #1 scroll; output will be
unpredictable.

Only the more popular micro-computers support these operations.
To check whether the program is running on one, use this:"

<ROUTINE SPLIT-SCREEN? () <NOT <EQUAL? 0 <BAND 32 <GETB 0 1>>>>>

"Here's a fragment from Seastalker that splits the screen:"

	<COND (<AND ,AUTOMATIC-SONAR	;"Did player SET SCOPE TO AUTO ?"
		    <SPLIT-SCREEN?>>
	       <SETG SCREEN-NOW-SPLIT T>
	       <START-SONAR?>)>
	<TELL "The submarine glides smoothly out of the tank ...">

"And here are the routines that support it:"

<ROUTINE START-SONAR? ()
	 <COND (,SCREEN-NOW-SPLIT
		<SPLIT <+ 3 <* 2 ,SONAR-RANGE>>>
		<SETG SONAR-DIR 0>	;"to ensure update"
		<I-SHOW-SONAR>		;"to update immediately"
		<ENABLE <QUEUE I-SHOW-SONAR -1>>)>>

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

"In Seastalker, nothing happens unless the player 'turns on' the scope:"

<ROUTINE SONARSCOPE-F ("AUX" DEP N)
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<VERB? LAMP-ON>
	<COND (<SPLIT-SCREEN?>
	       <FSET ,SONARSCOPE ,ONBIT>
	       <PERFORM ,V?SET ,SONARSCOPE ,AUTOMATIC>
	       <RTRUE>)>)
       (<NOT <FSET? ,SONARSCOPE ,ONBIT>>
	<THIS-IS-IT ,SONARSCOPE>
	<TELL "It's not turned on!" CR>
	<RTRUE>)
       (<VERB? LAMP-OFF>
	<COND (,AUTOMATIC-SONAR
	       <PERFORM ,V?SET ,SONARSCOPE ,MANUAL>
	       <SETG AUTOMATIC-SONAR <>>
	       <RTRUE>)>)
       (<VERB? ANALYZE EXAMINE READ LOOK-INSIDE LOOK-ON>
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
		     (T <NOT-AVAILABLE>)>)>)>>

"And there are times when the scope must be 'off':"

<ROUTINE SONAR-TO-MANUAL ()
 <COND (<AND ,AUTOMATIC-SONAR <SPLIT-SCREEN?>>
	<SETG AUTOMATIC-SONAR <>>
	<SETG SCREEN-NOW-SPLIT <>>
	<SPLIT 0>
	<DISABLE <INT I-SHOW-SONAR>>
	<TELL "The sonarscope automatically sets itself to manual." CR>)>>

"Finally, there's a little extra work for SAVE & RESTORE:"

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

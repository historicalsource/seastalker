
<SETG VBUFF <IBYTES 8 <* 7 1024>>>	"for vocab up to 1024 words"
<GDECL (VBUFF) <BYTES 8>>

<DEFINE VOCAB (FILE
	       "AUX" BYTADDR VLEN VNUM (C <OPEN "READB" .FILE>) OUTCHAN
		     (NDUP 0) (NORD 0) (BUF <IBYTES 16 6>))
	#DECL ((BYTADDR VLEN VNUM NDUP NORD) FIX
	       (C) <OR CHANNEL FALSE>
	       (OUTCHAN) <SPECIAL <OR CHANNEL FALSE>>
	       (BUF) <OR <BYTES 8> <BYTES 16>>)
	<COND (.C
	       <SET OUTCHAN <OPEN "PRINT" <7 .C> "VOCAB">>
	       <READB .BUF .C>
	       <SET BYTADDR <5 .BUF>>
	       <ACCESS .C </ .BYTADDR 4>>
	       <READB ,VBUFF .C>
	       <SET BUF <REST ,VBUFF <MOD .BYTADDR 4>>>
	       <SET VLEN <5 .BUF>>
	       <SET VNUM <+ <7 .BUF> <* 256 <6 .BUF>>>>
	       <SET BUF <REST .BUF 7>>
	       <REPEAT ((N .VNUM) X X1 (OX #WORD 0) (OX1 #WORD 0))
		       #DECL ((N) FIX (X X1 OX OX1) WORD)
		       <SET X
			    <ORB <LSH <1 .BUF> 24>
				 <LSH <2 .BUF> 16>
				 <LSH <3 .BUF> 8>
				 <4 .BUF>>>
		       <PRINT .X>
		       <PRINC " \"">
		       <ZWORD-PRINT .X>
		       <PRINC "\"">
		       <COND (<L? <CHTYPE .X FIX> <CHTYPE .OX FIX>>
			      <SET NORD <+ 1 .NORD>>
			      <PRINC " [out of order!]">)>
		       <SET X1 <ANDB .X #WORD *037777677777*>>
		       <COND (<L? <CHTYPE .X1 FIX> <CHTYPE .OX1 FIX>>
			      <SET NORD <+ 1 .NORD>>
			      <PRINC " [out of order!]">)
			     (<==? .X1 .OX1>
			      <SET NDUP <+ 1 .NDUP>>
			      <PRINC " [duplicate!]">)>
		       <SET OX .X>
		       <SET OX1 .X1>
		       <COND (<0? <SET N <- .N 1>>> <RETURN>)>
		       <SET BUF <REST .BUF .VLEN>>>
	       <CRLF>
	       <PRINC "Errors found: " ,OUTCHAN>
	       <COND (<AND <0? .NDUP> <0? .NORD>>
		      <PRINC "none" ,OUTCHAN>)>
	       <COND (<NOT <0? .NDUP>>
		      <PRINC .NDUP ,OUTCHAN>
		      <PRINC " duplications " ,OUTCHAN>)>
	       <COND (<NOT <0? .NORD>>
		      <PRINC .NORD ,OUTCHAN>
		      <PRINC " out of order " ,OUTCHAN>)>
	       <CRLF ,OUTCHAN>
	       <CLOSE .OUTCHAN>)>>

<SETG ZWORD-BUF <IBYTES 5 6>>
<GDECL (ZWORD-BUF) <BYTES 5>>

<DEFINE ZWORD-PRINT (X) 
	<1 ,ZWORD-BUF <CHTYPE <LSH .X -26> FIX>>
	<2 ,ZWORD-BUF <CHTYPE <LSH .X -21> FIX>>
	<3 ,ZWORD-BUF <CHTYPE <LSH .X -16> FIX>>
	<4 ,ZWORD-BUF <CHTYPE <LSH .X -10> FIX>>
	<5 ,ZWORD-BUF <CHTYPE <LSH .X -5> FIX>>
	<6 ,ZWORD-BUF <CHTYPE .X FIX>>
	<REPEAT ((N 0) CH (CASE 0) (TCASE -1))
		#DECL ((N CH CASE TCASE) FIX)
		<COND (<L? 6 <SET N <+ 1 .N>>> <RETURN>)>
		<SET CH <NTH ,ZWORD-BUF .N>>
		<COND (<0? .CH> <PRINC " "> <SET TCASE -1>)
		      (<G? 4 .CH>
		       <PRINC "F">
		       <PRINC <ASCII <+ 48 .CH>>>
		       <SET TCASE -1>)
		      (<AND <==? -1 .TCASE> <SET TCASE .CASE> <>>)
		      (<==? 4 .CH>
		       <COND (<0? .TCASE> <SET TCASE 1>)
			     (<1? .TCASE> <SET CASE 1>)
			     (T <SET CASE 0>)>)
		      (<==? 5 .CH>
		       <COND (<0? .TCASE> <SET TCASE 2>)
			     (<1? .TCASE> <SET CASE 0>)
			     (T <SET CASE 2>)>)
		      (<0? .TCASE> <PRINC <ASCII <+ 91 .CH>>> <SET TCASE -1>)
		      (<1? .TCASE> <PRINC <ASCII <+ 59 .CH>>> <SET TCASE -1>)
		      (<==? 6 .CH>
		       <PRINC <ASCII <+ <NTH ,ZWORD-BUF <+ 2 .N>>
					<* 32 <NTH ,ZWORD-BUF <+ 1 .N>>>>>>
		       <SET N <+ 2 .N>>
		       <SET TCASE -1>)
		      (T<PRINC <NTH ,SPEC-CHARS <- .CH 6>>> <SET TCASE -1>)>>>

<SETG SPEC-CHARS "|0123456789.,!?_#'\"/\\-:()">
<GDECL (SPEC-CHARS) STRING>

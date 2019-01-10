* Program-ID..:  MAIN.PRG
* Purpose.....:  MAIN program for application

CLEAR ALL
CLOSE ALL
CLEAR
CLOSE ALL
SET TALK       OFF
SET CONFIRM    ON
SET MULTILOCKS ON
SET CENTURY    ON
SET EXCLUSIVE  ON
SET SAFETY     OFF
SET DELETED    ON
SET STRICTDATE TO 0

WITH _Screen
.AddObject ( [Title1], [Title], 0, 0 )
.AddObject ( [Title2], [Title], 3, 3 )
.Title2.ForeColor = RGB ( 255, 0, 0  )
ENDWITH

ON ERROR DO ErrTrap WITH LINENO(), PROGRAM(), MESSAGE(), MESSAGE(1)

SET PROCEDURE TO DataTier.PRG
oDataTier = CREATEOBJECT ( [DataTier] )
oDataTier.AccessMethod = [DBF]

DO MENU.MPR

SET MARK OF BAR 1 OF DataAccess TO .T.

IF NOT EMPTY ( oDataTier.AccessMethod )
   READ EVENTS
ENDIF

ON ERROR

SET PROCEDURE TO
SET CLASSLIB TO 

SET SYSMENU TO DEFAULT

WITH _Screen
.RemoveObject ( [Title1] )
.RemoveObject ( [Title2] )
ENDWITH


DEFINE CLASS Title AS Label
Visible   = .T.
BackStyle =  0
FontName  = [Times New Roman]
FontSize  =  48
Height    = 100
Width     = 800
Left      =  25
Caption   = [My application]
ForeColor = RGB ( 192, 192, 192 )

PROCEDURE Init
LPARAMETERS nTop, nLeft
THIS.Top = _Screen.Height - 100 - nTop
THIS.Left=                   25 - nLeft
ENDPROC

ENDDEFINE


PROCEDURE ErrTrap
LPARAMETERS nLine, cProg, cMessage, cMessage1
OnError = ON("Error")
ON ERROR
IF NOT FILE ( [ERRORS.DBF] )
   CREATE TABLE ERRORS (;
    Date	 Date,		;
    Time	 Char(5),	;
    LineNum	 Integer,	;
    ProgName Char(30),	;
    Msg		 Char(240),	;
    CodeLine Char(240)	)
ENDIF
IF NOT USED ( [Errors] )
   USE ERRORS IN 0
ENDIF
SELECT Errors
INSERT INTO Errors VALUES ( DATE(), LEFT(TIME(),5),  nLine, cProg, cMessage, cMessage1 )
USE IN Errors
cStr = [Error at line ] + TRANSFORM(nLine) + [ of ] + cprog + [:] + CHR(13)	;
	 + cMessage + CHR(13) + [Code that caused the error:] + CHR(13) + cMessage1
IF MESSAGEBOX( cStr, 292, [Continue] ) <> 6
   SET SYSMENU TO DEFAULT
   IF TYPE ( [_Screen.Title1] ) <> [U]
      _Screen.RemoveObject ( [Title2] )
      _Screen.RemoveObject ( [Title1] )
   ENDIF
   CLOSE ALL
   RELEASE ALL
   CANCEL
  ELSE
   ON ERROR &OnError
ENDIF
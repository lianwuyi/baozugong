DEFINE CLASS DataTier AS Custom
AccessMethod = []	&& Any attempt to assign a value to this property will be trapped 
* 					   by the "setter" method AccessMethod_Assign.
ConnectionString = [Driver={SQL Server};Server=(local);Database=Northwind;UID=sa;PWD=;]
Handle       = 0

PROCEDURE AccessMethod_Assign
PARAMETERS AM
DO CASE
   CASE AM = [DBF]
		THIS.AccessMethod = [DBF]	&& FoxPro tables
   CASE AM = [SQL]
		THIS.AccessMethod = [SQL]	&& MS Sql Server
		THIS.GetHandle
   CASE AM = [XML]
        MESSAGEBOX( [Implemented in Chapter 5], 16, _VFP.Caption, 2000 )
		THIS.AccessMethod = []	&& FoxPro XMLAdapter
   CASE AM = [WC]
        MESSAGEBOX( [Implemented in Chapter 5], 16, _VFP.Caption, 2000 )
		THIS.AccessMethod = []	&& FoxPro XMLAdapter
   OTHERWISE
		MESSAGEBOX( [Incorrect access method ] + AM, 16, [Setter error] )
		THIS.AccessMethod = []
ENDCASE
_VFP.Caption = [Data access method: ] + THIS.AccessMethod
ENDPROC


PROCEDURE CreateCursor
LPARAMETERS pTable, pKeyField
IF THIS.AccessMethod = [DBF]
   IF NOT USED ( pTable )
      SELECT 0
      USE ( pTable ) ALIAS ( pTable )
   ENDIF
   SELECT ( pTable )
   IF NOT EMPTY ( pKeyField )
      SET ORDER TO TAG ( pKeyField )
   ENDIF
   RETURN
ENDIF
Cmd = [SELECT * FROM ] + pTable + [ WHERE 1=2]
DO CASE
   CASE THIS.AccessMethod = [SQL]
		SQLEXEC( THIS.Handle, Cmd )
		AFIELDS ( laFlds )
		USE
		CREATE CURSOR ( pTable ) FROM ARRAY laFlds
   CASE THIS.AccessMethod = [XML]
   CASE THIS.AccessMethod = [WC]
ENDCASE


PROCEDURE GetHandle
IF THIS.AccessMethod = [SQL]
   IF THIS.Handle > 0
      RETURN
   ENDIF
   THIS.Handle = SQLSTRINGCONNECT( THIS.ConnectionString )
   IF THIS.Handle < 1
      MESSAGEBOX( [Unable to connect], 16, [SQL Connection error], 2000 )
   ENDIF
  ELSE
   Msg = [A SQL connection was requested, but access method is ] + THIS.AccessMethod
   MESSAGEBOX( Msg, 16, [SQL Connection error], 2000 )
   THIS.AccessMethod = []
ENDIF
RETURN


PROCEDURE GetMatchingRecords
LPARAMETERS pTable, pFields, pExpr
pFields = IIF ( EMPTY ( pFields ), [*], pFields )
pExpr   = IIF ( EMPTY ( pExpr ), [], ;
		  [ WHERE ] + STRTRAN ( UPPER ( ALLTRIM ( pExpr ) ), [WHERE ], [] ) )
cExpr   = [SELECT ] + pFields + [ FROM ] + pTable + pExpr
IF NOT USED ( pTable )
   RetVal = THIS.CreateCursor ( pTable )
ENDIF
DO CASE
   CASE THIS.AccessMethod = [DBF]
		&cExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr >= 0
		   THIS.FillCursor()
		  ELSE
		   Msg = [Unable to return records] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDPROC


PROCEDURE CreateView
LPARAMETERS pTable
IF NOT USED( pTable )
   MESSAGEBOX( [Can't find cursor ] + pTable, 16, [Error creating view], 2000 )
   RETURN
ENDIF
SELECT ( pTable )
AFIELDS( laFlds )
SELECT 0
CREATE CURSOR ( [View] + pTable ) FROM ARRAY laFlds
ENDFUNC


PROCEDURE GetOneRecord
LPARAMETERS pTable, pKeyField, pKeyValue
SELECT ( pTable )
Dlm   = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
IF THIS.AccessMethod = [DBF]
   cExpr = [LOCATE FOR ] + pKeyField + [=] + Dlm + TRANSFORM ( pKeyValue ) + Dlm
 ELSE
   cExpr = [SELECT * FROM ] + pTable + [ WHERE ] + pKeyField + [=] + Dlm + TRANSFORM ( pKeyValue ) + Dlm
ENDIF
DO CASE
   CASE THIS.AccessMethod = [DBF]
		&cExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr >= 0
		   THIS.FillCursor( pTable )
		  ELSE
		   Msg = [Unable to return record] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDFUNC


PROCEDURE FillCursor
LPARAMETERS pTable
IF THIS.AccessMethod = [DBF]
   RETURN
ENDIF
SELECT ( pTable )
ZAP
APPEND FROM DBF ( [SQLResult] )
USE IN SQLResult
GO TOP
ENDPROC


PROCEDURE DeleteRecord
LPARAMETERS pTable, pKeyField
ForExpr  = IIF ( THIS.AccessMethod = [DBF], [ FOR ], [ WHERE ] )
KeyValue = EVALUATE ( pTable + [.] + pKeyField )
Dlm      = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
DO CASE
   CASE THIS.AccessMethod = [DBF]
		cExpr = [DELETE FOR ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm
		&cExpr
		SET DELETED ON
		GO TOP
   CASE THIS.AccessMethod = [SQL]
		cExpr = [DELETE ] + pTable + [ WHERE ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   Msg = [Unable to delete record] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDFUNC


PROCEDURE SaveRecord
PARAMETERS pTable, pKeyField, pAdding
IF THIS.AccessMethod = [DBF]
   RETURN
ENDIF
IF pAdding
	THIS.InsertRecord ( pTable, pKeyField )
 ELSE
	THIS.UpdateRecord ( pTable, pKeyField )
ENDIF
ENDPROC


PROCEDURE InsertRecord
LPARAMETERS pTable, pKeyField
cExpr = THIS.BuildInsertCommand ( pTable, pKeyField )
_ClipText = cExpr
DO CASE
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   msg = [Unable to insert record; command follows:] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDFUNC

******************************************
PROCEDURE lianwuyi
*LPARAMETERS pTable, pFields, pExpr
  MESSAGEBOX([lianwuyi], 16, [SQL error] )
ENDPROC
******************************************

PROCEDURE UpdateRecord
LPARAMETERS pTable, pKeyField
cExpr = THIS.BuildUpdateCommand ( pTable, pKeyField )
_ClipText = cExpr
DO CASE
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   msg = [Unable to update record; command follows:] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDFUNC


FUNCTION BuildInsertCommand
PARAMETERS pTable, pKeyField
Cmd = [INSERT ] + pTable + [ ( ]
FOR I = 1 TO FCOUNT()

	Fld = UPPER(FIELD(I))

* Can't deal with GENERAL fields, so ignore them
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF

* Skip SQL Server identity fields:
*!*		IF Fld = UPPER(pKeyField)
*!*		   LOOP
*!*		ENDIF
***************************************

	Cmd = Cmd + Fld + [, ]
ENDFOR
Cmd = LEFT(Cmd,LEN(Cmd)-2) + [ } VALUES ( ]
FOR I = 1 TO FCOUNT()
	Fld = FIELD(I)
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF

* Skip SQL Server identity fields:
*!*		IF Fld = UPPER(pKeyField)
*!*		   LOOP
*!*		ENDIF
***************************************

	Dta = ALLTRIM(TRANSFORM ( &Fld ))
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		&& get rid of single quotes in the data
	Dta = IIF ( Dta = [/  /], [], Dta )
	Dta = IIF ( Dta = [.F.], [0], Dta )
	Dta = IIF ( Dta = [.T.], [1], Dta )
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],;
	      IIF ( TYPE ( Fld ) $ [DT],['],;
	      IIF ( TYPE ( Fld ) $ [IN],[],	[])))
	Cmd = Cmd + Dlm + Dta + Dlm + [, ]
ENDFOR
Cmd = LEFT ( Cmd, LEN(Cmd) -2) + [ )]  && Remove ", " add " )"
RETURN Cmd
ENDFUNC


FUNCTION BuildUpdateCommand
PARAMETERS pTable, pKeyField
Cmd = [UPDATE ]  + pTable + [ SET ]
FOR I = 1 TO FCOUNT()
	Fld = UPPER(FIELD(I))
	IF Fld = UPPER(pKeyField)
	   LOOP
	ENDIF
	IF TYPE ( Fld ) = [G]
	   LOOP
	ENDIF
	Dta = ALLTRIM(TRANSFORM ( &Fld ))
	IF Dta = [.NULL.]
	   DO CASE
		  CASE TYPE ( Fld ) $ [CMDT]
			   Dta = []
		  CASE TYPE ( Fld ) $ [INL]
			   Dta = [0]
	   ENDCASE
	ENDIF
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		&& get rid of single quotes in the data
	Dta = IIF ( Dta = [/  /], [], Dta )
	Dta = IIF ( Dta = [.F.], [0], Dta )
	Dta = IIF ( Dta = [.T.], [1], Dta )
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],;
	      IIF ( TYPE ( Fld ) $ [DT],['],;
	      IIF ( TYPE ( Fld ) $ [IN],[],	[])))
	Cmd = Cmd + Fld + [=] + Dlm + Dta + Dlm + [, ]
ENDFOR
Dlm = IIF ( TYPE ( pKeyField ) = [C], ['], [] )
Cmd = LEFT ( Cmd, LEN(Cmd) -2 )			;
	+ [ WHERE ] + pKeyField + [=] 		;
	+ + Dlm + TRANSFORM(EVALUATE(pKeyField)) + Dlm
RETURN Cmd
ENDFUNC


PROCEDURE SelectCmdToSQLResult
LPARAMETERS pExpr
DO CASE
   CASE THIS.AccessMethod = [DBF]
		 pExpr = pExpr + [ INTO CURSOR SQLResult]
		&pExpr
   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, pExpr )
		IF lr < 0
		   Msg = [Unable to return records] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
ENDCASE
ENDFUNC


FUNCTION GetNextKeyValue
LPARAMETERS pTable
EXTERNAL ARRAY laVal
pTable = UPPER ( pTable )
DO CASE

   CASE THIS.AccessMethod = [DBF]
		IF NOT FILE ( [Keys.DBF] )
		   CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )
		ENDIF
		IF NOT USED ( [Keys] )
		   USE Keys IN 0
		ENDIF
		SELECT Keys
		LOCATE FOR TableName = pTable
		IF NOT FOUND()
		   INSERT INTO Keys VALUES ( pTable, 0 )
		ENDIF
		Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 ]	;
			+ [ WHERE TableName='] + pTable + [']
		&Cmd
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName = '] ;
			+ pTable + [' INTO ARRAY laVal]
		&Cmd
		USE IN Keys
		RETURN TRANSFORM(laVal(1))

   CASE THIS.AccessMethod = [SQL]

		Cmd = [SELECT Name FROM SysObjects WHERE Name='KEYS' AND Type='U']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF
		IF RECCOUNT([SQLResult]) = 0
		   Cmd = [CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )]
		   SQLEXEC( THIS.Handle, Cmd )
		ENDIF
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] + pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		IF RECCOUNT([SQLResult]) = 0
		   Cmd = [INSERT INTO Keys VALUES ('] +  pTable + [', 0 )]
		   lr = SQLEXEC( THIS.Handle, Cmd )
		   IF lr < 0
		      MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		   ENDIF
		ENDIF

		Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 )
		ENDIF

		nLastKeyVal = TRANSFORM(SQLResult.LastKeyVal)
		USE IN SQLResult
		RETURN TRANSFORM(nLastKeyVal)

ENDCASE

ENDDEFINE
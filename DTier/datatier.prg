*!*	---------------------------------------------------------------
*!*	����˵����
*!*	1.DEFINE CALSS ���� as Custom���Զ�������̡�
*!*	2.PARAMETERS�������ó����������ݸ�ֵ��˽���ڴ���������顣�����յĲ������ڱ��γ�������Ч������õ��ӳ���Ҳ�ǿ�������(�൱���ڲ����ϼ���һ��Local)��
*!*	3.LPARAMETERS�������ó���������ݣ���ֵ���ֲ��ڴ���������顣�����ڱ���������Ч�������ӳ�����Ҳ�ɷ��ʡ�
*!*----------------------------------------------------------------
*!*	����˵����
*!*	1.pTable�ǵ�ǰ��ʱ��
*!*	---------------------------------------------------------------
*!*	PROCEDURE CreateCursor   && ������ʱ������һ����SQL��һ���ֶε�dbf��
*!*	PROCEDURE GetHandle      && ��þ��


*!*	FUNCTION GetNextKeyValue  && ��ȡkeys�����ID��
*!*	---------------------------------------------------------------


DEFINE CLASS DataTier AS Custom   && �Զ���DataTier��
*!*	AccessMethod = []	&& Any attempt to assign a value to this property will be trapped 
* 					   by the "setter" method AccessMethod_Assign.
*!*	ConnectionString = [Driver={SQL Server};Server=(local);Database=Northwind;UID=sa;PWD=;]
ConnectionString = [Driver={SQL Server};Server=123.207.38.110;Database=xlydb;UID=sa;PWD=Eb123456;]
Handle       = 0

*!*	PROCEDURE AccessMethod_Assign  && ����̣��ж�AM������ʲô���͵ı�ǩ��
*!*	PARAMETERS AM
*!*	DO CASE
*!*	   CASE AM = [DBF]
*!*			THIS.AccessMethod = [DBF]	&& FoxPro tables
*!*	   CASE AM = [SQL]
*!*			THIS.AccessMethod = [SQL]	&& MS Sql Server
*!*			THIS.GetHandle
*!*	   CASE AM = [XML]
*!*	        MESSAGEBOX( [Implemented in Chapter 5], 16, _VFP.Caption, 2000 )
*!*			THIS.AccessMethod = []	&& FoxPro XMLAdapter
*!*	   CASE AM = [WC]
*!*	        MESSAGEBOX( [Implemented in Chapter 5], 16, _VFP.Caption, 2000 )
*!*			THIS.AccessMethod = []	&& FoxPro XMLAdapter
*!*	   OTHERWISE
*!*			MESSAGEBOX( [Incorrect access method ] + AM, 16, [Setter error] )
*!*			THIS.AccessMethod = []
*!*	ENDCASE
*!*	_VFP.Caption = [Data access method: ] + THIS.AccessMethod
*!*	ENDPROC


PROCEDURE CreateCursor   && ������ʱ��---------------------------
LPARAMETERS pTable  && pTable ��ʱ��
LPARAMETERS pTable, pKeyField  

*!*	IF THIS.AccessMethod = [DBF]
*!*	   IF NOT USED ( pTable )
*!*	      SELECT 0
*!*	      USE ( pTable ) ALIAS ( pTable )
*!*	   ENDIF
*!*	   SELECT ( pTable )
*!*	   IF NOT EMPTY ( pKeyField )
*!*	      SET ORDER TO TAG ( pKeyField )
*!*	   ENDIF
*!*	   RETURN
*!*	ENDIF
Cmd = [SELECT * FROM ] + pTable + [ WHERE 1=2]
*!*	DO CASE
*!*	   CASE THIS.AccessMethod = [SQL]
		SQLEXEC( THIS.Handle, Cmd )  && ���������ǣ�SQLEXEC(THIS.Handle,select * from ���� WHERE 1=2 )  �鿴��ṹ(1=2����FALSE ��û�еõ��κ����ݣ�ֻ����ʾ�ֶ����ƶ��ѡ�)
		AFIELDS ( laFlds )  && ���� laFlds ���ֶ�����
		USE
		CREATE CURSOR ( pTable ) FROM ARRAY laFlds  && ������ʱ�� ptable �ֶθ�SQL���ֶ�һ����
*!*	   CASE THIS.AccessMethod = [XML]
*!*	   CASE THIS.AccessMethod = [WC]
*!*	ENDCASE


PROCEDURE GetHandle  && ��þ��------------------------------------
*!*	IF THIS.AccessMethod = [SQL]
   IF THIS.Handle > 0
      RETURN
   ENDIF
   THIS.Handle = SQLSTRINGCONNECT( THIS.ConnectionString ) && ��������������ֵ��Ϊ����������SQLSTRINGCONNECT�����޷��������ӣ��򷵻�-1��
   IF THIS.Handle < 1
*!*	      MESSAGEBOX( [Unable to connect], 16, [SQL Connection error], 2000 )
      MESSAGEBOX( [�޷�����], 16, [SQL���ӳ���], 2000 )
   ENDIF
*!*	  ELSE
*!*	   Msg = [A SQL connection was requested, but access method is ] + THIS.AccessMethod
*!*	   MESSAGEBOX( Msg, 16, [SQL Connection error], 2000 )
*!*	   THIS.AccessMethod = []
*!*	ENDIF
RETURN


PROCEDURE GetMatchingRecords  && ��ȡƥ���¼-----------------------------
LPARAMETERS pTable, pFields, pExpr
pFields = IIF ( EMPTY ( pFields ), [*], pFields )  && �ж� pFields�Ƿ�Ϊ�գ�������ʾ*�ţ�������ʾ�ֶΡ�
pExpr   = IIF ( EMPTY ( pExpr ), [], ;
		  [ WHERE ] + STRTRAN ( UPPER ( ALLTRIM ( pExpr ) ), [WHERE ], [] ) )  && �ж�pExpr�Ƿ�Ϊ�գ�������ʾ�գ�������ʾ where + 
cExpr   = [SELECT ] + pFields + [ FROM ] + pTable + pExpr  && cExpr= select (pFields����*) from ��ǰ���� (�ջ���where pExpr)
IF NOT USED ( pTable )
   RetVal = THIS.CreateCursor ( pTable )
ENDIF
*!*	DO CASE
*!*	   CASE THIS.AccessMethod = [DBF]
*!*			&cExpr
*!*	   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr >= 0
		   THIS.FillCursor()
		  ELSE
		   Msg = [Unable to return records] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
*!*	ENDCASE
ENDPROC


PROCEDURE CreateView  && ������ͼ --------------------------------
LPARAMETERS pTable
IF NOT USED( pTable ) && ���ptable�޷��򿪡�
   MESSAGEBOX( [Can't find cursor ] + pTable, 16, [Error creating view], 2000 )  && �Ҳ����α� pTable,������ͼʱ����
   RETURN
ENDIF
SELECT ( pTable ) && �򿪵�ǰ��ʱ��
AFIELDS( laFlds ) && ���� laFlds ���ֶ�����
SELECT 0
CREATE CURSOR ( [View] + pTable ) FROM ARRAY laFlds && ������ʱ�� View+pTable,�ֶθ�ԭ�����ֶ�һ����
ENDFUNC


PROCEDURE GetOneRecord  && ���һ����¼----------------------------
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


PROCEDURE FillCursor  && ����ȫ������  ----------------------------
LPARAMETERS pTable
*!*	IF THIS.AccessMethod = [DBF]
*!*	   RETURN
*!*	ENDIF
SELECT ( pTable )  && �򿪵�ǰ��
ZAP  && ɾ��ȫ������
APPEND FROM DBF ( [SQLResult] ) && ׷��SQL���صĽ������
USE IN SQLResult && ��SQL���صĽ�����ݱ�
GO TOP && ָ�������ݵ�һ������
ENDPROC


PROCEDURE DeleteRecord  && ɾ����¼  --------------------------------
LPARAMETERS pTable, pKeyField
*!*	ForExpr  = IIF ( THIS.AccessMethod = [DBF], [ FOR ], [ WHERE ] )
KeyValue = EVALUATE ( pTable + [.] + pKeyField )  && EVALUATE()�����ַ����ʽ��ֵ�����ؽ��
Dlm      = IIF ( TYPE ( pKeyField ) = [C], ['], [] )  && �ж�pKeyField �Ƿ�Ϊ"c"�ַ��ͣ�����ǣ�����'�������򲻼ӡ�
*!*	DO CASE
*!*	   CASE THIS.AccessMethod = [DBF]
*!*			cExpr = [DELETE FOR ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm
*!*			&cExpr
*!*			SET DELETED ON
*!*			GO TOP
*!*	   CASE THIS.AccessMethod = [SQL]
		cExpr = [DELETE ] + pTable + [ WHERE ] + pKeyField + [=] + Dlm + TRANSFORM ( m.KeyValue ) + Dlm  && cExpr= Delete cp where 
		lr = SQLExec ( THIS.Handle, cExpr )
		IF lr < 0
		   Msg = [Unable to delete record] + CHR(13) + cExpr
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ENDIF
*!*	ENDCASE
ENDFUNC


PROCEDURE SaveRecord  && �����¼  --------------------------------
PARAMETERS pTable, pKeyField, pAdding
*!*	IF THIS.AccessMethod = [DBF]
*!*	   RETURN
*!*	ENDIF
*IF pAdding  && ���ݹ��������� adding�������в������
	THIS.InsertRecord ( pTable, pKeyField )  && �������¼���̡�
* ELSE  && ���ǣ���ִ���޸����
*	THIS.UpdateRecord ( pTable, pKeyField )  && ���޸ļ�¼���̡�
*ENDIF
ENDPROC


PROCEDURE InsertRecord  && �����¼ ------------------------------
LPARAMETERS pTable, pKeyField
cExpr = THIS.BuildInsertCommand ( pTable, pKeyField )   && ����������������̡�
_ClipText = cExpr && ��ϵͳ�����洢�ľ��Ǽ����������
*!*	DO CASE
*!*	   CASE THIS.AccessMethod = [SQL]
		lr = SQLExec ( THIS.Handle, cExpr )   && ��CP��ִ�к�ó� lr=SQLExec(this.handle,instert cp(��Ʒid,��Ʒ���,��Ʒ����) values ��1,'1','1')��
		IF lr < 0  && �������<0
       *!* msg = [Unable to insert record; command follows:] + CHR(13) + cExpr  
		   msg = [�޷������¼���������£�] + CHR(13) + cExpr  
		   MESSAGEBOX( Msg, 16, [SQL error] )
		ELSE 
		  MESSAGEBOX( [����ɹ�!], 16, [��ʾ��] )
		ENDIF
*!*	ENDCASE
ENDFUNC


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


FUNCTION BuildInsertCommand && ������������-------------------------------------
PARAMETERS pTable, pKeyField

Cmd = [INSERT ] + pTable + [ ( ]  && Cmd = insert ��ǰ���� (
FOR I = 1 TO FCOUNT() && FCOUNT() ���ص�ǰ���ֶ���Ŀ

	Fld = UPPER(FIELD(I)) && ���ر��и��ֶε����ƣ���������д���Ҹ�ֵ�� fld

    * Can't deal with GENERAL fields, so ignore them �޷�����ͨ���ֶΣ���˺�������
	IF TYPE ( Fld ) = [G]  && ����ַ�������G��ͨ���ֶεĻ��������
	   LOOP && ��ѭ�����������loop������������ѭ�����������·���ѭ����ʼ��do while��for��俪ͷ���������ж�ѭ��������������������ѭ����
	ENDIF

    * Skip SQL Server identity fields:
    *!*		IF Fld = UPPER(pKeyField)
    *!*		   LOOP
    *!*		ENDIF
    ***************************************

	Cmd = Cmd + Fld + [, ]  && ѭ��д�� Cmd  
ENDFOR
Cmd = LEFT(Cmd,LEN(Cmd)-2) + [ } VALUES ( ]  && ��CP��ִ�к�ó�?cmd���� instert cp(��Ʒid,��Ʒ���,��Ʒ����) values �� ��

FOR I = 1 TO FCOUNT()  && �ٴ�ѭ����fcount�������ص�ǰ���ֶε���Ŀ
	Fld = FIELD(I)  && ��ȡ��ǰ�ֶε����ƣ���ֵ��Fld
	IF TYPE ( Fld ) = [G]  && ������ֶ��� G���ͣ���ͨ�����͵��ַ��������
	   LOOP && ѭ����������
	ENDIF

	* Skip SQL Server identity fields:
	*!*		IF Fld = UPPER(pKeyField)
	*!*		   LOOP
	*!*		ENDIF
	***************************************

	Dta = ALLTRIM(TRANSFORM ( &Fld )) &&  TRANSFORM()���ַ���������ת�����ַ���
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		&& get rid of single quotes in the data ɾ�������еĵ�����
	Dta = IIF ( Dta = [/  /], [], Dta )  && ���������/ /,��ȥ��
	Dta = IIF ( Dta = [.F.], [0], Dta )  && ��������� .F.,���Ϊ0
	Dta = IIF ( Dta = [.T.], [1], Dta )  && ��������� .T.,���Ϊ1
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],; && ����������ַ��ͣ����[']
	      IIF ( TYPE ( Fld ) $ [DT],['],; && ��������������ͣ�Ҳ��[']
	      IIF ( TYPE ( Fld ) $ [IN],[],	[]))) &&�����������ֵ�ͣ��򲻼��κη���
	Cmd = Cmd + Dlm + Dta + Dlm + [, ]  && ѭ��д��
ENDFOR
Cmd = LEFT ( Cmd, LEN(Cmd) -2) + [ )]  && Remove ", " add " )"    ɾ��[��]�ţ�����[)]��
RETURN Cmd  && ����Cmd  ��CP��ִ�к�ó�?cmd���� instert cp(��Ʒid,��Ʒ���,��Ʒ����) values ��1,'1','1') ��
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


FUNCTION GetNextKeyValue  && ��ȡ��һ����ֵ----------------------------------------����KEYS����ID�����ҽ�KEYS���ID+1��
LPARAMETERS pTable  &&  ��ǰ������
EXTERNAL ARRAY laVal  && ����һ������
pTable = UPPER ( pTable )  && ����ǰ�������ָĳɴ�д
*!*	DO CASE

*!*	   CASE THIS.AccessMethod = [DBF]
*!*			IF NOT FILE ( [Keys.DBF] )
*!*			   CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )
*!*			ENDIF
*!*			IF NOT USED ( [Keys] )
*!*			   USE Keys IN 0
*!*			ENDIF
*!*			SELECT Keys
*!*			LOCATE FOR TableName = pTable
*!*			IF NOT FOUND()
*!*			   INSERT INTO Keys VALUES ( pTable, 0 )
*!*			ENDIF
*!*			Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 ]	;
*!*				+ [ WHERE TableName='] + pTable + [']
*!*			&Cmd
*!*			Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName = '] ;
*!*				+ pTable + [' INTO ARRAY laVal]
*!*			&Cmd
*!*			USE IN Keys
*!*			RETURN TRANSFORM(laVal(1))

*!*	   CASE THIS.AccessMethod = [SQL]
        *** ��ѯkeys���Ƿ���ڡ�������������
		Cmd = [SELECT Name FROM SysObjects WHERE Name='KEYS' AND Type='U']  && Cmd= select Name from SysObjects where name='KEYS' and type='U'
		lr = SQLEXEC( THIS.Handle, Cmd )  && ��ѯ�Ƿ��б����� KEYS �ı�
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 ) && ��ѯ������
		ENDIF
		IF RECCOUNT([SQLResult]) = 0 && �����ѯ���ؽ����0 ����û��KEYS��
		   Cmd = [CREATE TABLE Keys ( TableName Char(20), LastKeyVal Integer )] && ���� ���� KEYS���ֶ� TableName char(20),LastKeyVal Integer
		   SQLEXEC( THIS.Handle, Cmd )
		ENDIF
		*** ����������������������������������
		
		***��ѯkeys����lastkeyval�Ƕ��١�����
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] + pTable + ['] && �����ѯ�������0�����ѯKeys����tablename���ڵ�ǰ������lastkeyval�Ƕ��٣�
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 ) && �����������
		ENDIF

		IF RECCOUNT([SQLResult]) = 0 && �����ѯ���ؽ����0 ����
		   Cmd = [INSERT INTO Keys VALUES ('] +  pTable + [', 0 )] && ���keys���� ��ǰ������0 ��2��ֵ��
		   lr = SQLEXEC( THIS.Handle, Cmd )
		   IF lr < 0
		      MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 ) && �����������
		   ENDIF
		ENDIF
        ***������������������������������������

		***�޸�keys�����tablename=ctable��lastkeyvalֵ+1������
		Cmd = [UPDATE Keys SET LastKeyVal=LastKeyVal + 1 WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 ) && �����������
		ENDIF
        ***������������������������������������
     
		***��ѯkeys�����tablename=ctable��lastkeyvalֵ������        
		Cmd = [SELECT LastKeyVal FROM Keys WHERE TableName='] +  pTable + [']
		lr = SQLEXEC( THIS.Handle, Cmd )
		IF lr < 0
		   MESSAGEBOX( "SQL Error:"+ CHR(13) + Cmd, 16 ) && �����������
		ENDIF
        ***������������������������������������
        
		nLastKeyVal = TRANSFORM(SQLResult.LastKeyVal) &&transform������������ȡlastkeyva�����ֵ����ֵ��nLastKeyVal
		USE IN SQLResult
		RETURN TRANSFORM(nLastKeyVal)

*!*	ENDCASE
ENDDEFINE


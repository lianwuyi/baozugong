*������ת���б����е�EXCEL��DBF��������ת��DBF���ֶ�����
*���XLS�ļ���û���⣬������ǰ����һ�հ��м��ɡ�
*Ҳ��תXLSX��ǰ��ð�װEXCEL2007���ϰ汾

SET DELETED ON
xlsfile = GETFILE('XLS*','XLS�ļ�:')
IF EMPTY(xlsfile)
    RETURN
ENDIF

newxls = JUSTPATH(xlsfile)+'\'+SYS(2015)+'.xls'
thisform.text1.Value = newxls

WAIT WINDOW '���ڼ���...' NOWAIT NOCLEAR 

IF VARTYPE(eole)<>'O'
    eole=CREATEOBJECT('Excel.application')
ENDIF
eole.Workbooks.Open(xlsfile)
C=eole.SHEETS(1).UsedRange.Columns.Count  &&�����ݵ�������
cstr = 'CREATE CURSOR xxx ('
cStr1 = cstr
FOR i=1 TO c
cstr = cstr + IIF(EMPTY(eole.Cells(1,i).text),SYS(2015),eole.Cells(1,i).text) + ' C('+ ALLTRIM(STR(EOLE.ActiveSheet.Columns(i).ColumnWidth)) + '),'
cstr1 = cstr1 + 'A'+ALLTRIM(STR(i)) +  ' C('+ ALLTRIM(STR(EOLE.ActiveSheet.Columns(i).ColumnWidth)) + '),'
NEXT
cstr = left(cstr,LEN(cstr)-1)+')'
cstr1 = left(cstr1,LEN(cstr1)-1)+')'
ERR=.f.
ON ERROR err=.t.
&cstr
IF err
    err = .f.
    &cstr1
    IF err
        MESSAGEBOX('XLS�ļ���ͷ����'+CHR(13)+cstr,16,'����')
        ON ERROR        
        RETURN
    ENDIF
ENDIF
ON ERROR 
eole.ActiveWorkbook.SaveAs(newxls,39)
EOLE.ActiveWorkbook.Close

APPEND FROM (newxls) XLS 
DELETE FILE (newxls)
GO TOP 
DELETE 
BROWSE
*--------------------------
*COPY all to ..\test.dbf 

*!*	SELECT cp
*!*	DELETE ALL 
*!*	APPEND FROM ..\test.dbf 
*!*	GO TOP 
*!*	thisform.grdcp.column2.text1.setfocus  &&���
*!*	thisform.Refresh 
*!*	WAIT CLEAR 
*--------------------------
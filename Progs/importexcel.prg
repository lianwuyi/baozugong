*本程序转换有标题行的EXCEL至DBF，标题行转成DBF的字段名，
*如果XLS文件中没标题，可在最前新增一空白行即可。
*也可转XLSX，前提得安装EXCEL2007以上版本

SET DELETED ON
xlsfile = GETFILE('XLS*','XLS文件:')
IF EMPTY(xlsfile)
    RETURN
ENDIF

newxls = JUSTPATH(xlsfile)+'\'+SYS(2015)+'.xls'
thisform.text1.Value = newxls

WAIT WINDOW '正在加载...' NOWAIT NOCLEAR 

IF VARTYPE(eole)<>'O'
    eole=CREATEOBJECT('Excel.application')
ENDIF
eole.Workbooks.Open(xlsfile)
C=eole.SHEETS(1).UsedRange.Columns.Count  &&有数据的总列数
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
        MESSAGEBOX('XLS文件表头错误！'+CHR(13)+cstr,16,'错误')
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
*!*	thisform.grdcp.column2.text1.setfocus  &&光标
*!*	thisform.Refresh 
*!*	WAIT CLEAR 
*--------------------------
*赋值
USE c:\eberp\data\cp.dbf EXCLUSIVE && 打开需要提交的表单
GO TOP && 指向需要提交到SQL的数据

pTable = [cp] && 在[]内输入插入到SQL的哪个表内。

*开始执行

*FUNCTION BuildInsertCommand && 建立插入命令-------------------------------------
*PARAMETERS pTable, pKeyField
Cmd = [INSERT ] + pTable + [ ( ]  && Cmd = insert 当前表名 (
FOR I = 1 TO FCOUNT() && FCOUNT() 返回当前表单字段数目

	Fld = UPPER(FIELD(I)) && 返回表中该字段的名称，并将他大写，且赋值给 fld

    * Can't deal with GENERAL fields, so ignore them 无法处理通用字段，因此忽略它们
	IF TYPE ( Fld ) = [G]  && 如果字符类型是G，通用字段的话，则忽略
	   LOOP && 在循环中如果遇到loop命令，则结束本次循环，程序重新返回循环开始（do while或for语句开头），重新判断循环条件，如果满足则继续循环。
	ENDIF

    * Skip SQL Server identity fields:
    *!*		IF Fld = UPPER(pKeyField)
    *!*		   LOOP
    *!*		ENDIF
    ***************************************

	Cmd = Cmd + Fld + [, ]  && 循环写入 Cmd  
ENDFOR
Cmd = LEFT(Cmd,LEN(Cmd)-2) + [ } VALUES ( ]  && 拿CP表执行后得出?cmd：【 instert cp(产品id,产品类别,产品名称) values （ 】

FOR I = 1 TO FCOUNT()  && 再次循环，fcount（）返回当前表单字段的数目
	Fld = FIELD(I)  && 获取当前字段的名称，赋值给Fld
	IF TYPE ( Fld ) = [G]  && 如果该字段是 G类型，即通用类型的字符，则忽略
	   LOOP && 循环忽略命令
	ENDIF

	* Skip SQL Server identity fields:
	*!*		IF Fld = UPPER(pKeyField)
	*!*		   LOOP
	*!*		ENDIF
	***************************************

	Dta = ALLTRIM(TRANSFORM ( &Fld )) &&  TRANSFORM()将字符或者数字转换成字符串
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		&& get rid of single quotes in the data 删除数据中的单引号
	Dta = IIF ( Dta = [/  /], [], Dta )  && 如果数据是/ /,则去除
	Dta = IIF ( Dta = [.F.], [0], Dta )  && 如果数据是 .F.,则改为0
	Dta = IIF ( Dta = [.T.], [1], Dta )  && 如果数据是 .T.,则改为1
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],; && 如果数据是字符型，则加[']
	      IIF ( TYPE ( Fld ) $ [DT],['],; && 如果数据是日期型，也加[']
	      IIF ( TYPE ( Fld ) $ [IN],[],	[]))) &&如果数据是数值型，则不加任何符号
	Cmd = Cmd + Dlm + Dta + Dlm + [, ]  && 循环写入
ENDFOR
Cmd = LEFT ( Cmd, LEN(Cmd) -2) + [ )]  && Remove ", " add " )"

?cmd && 生成的插入语句。

RETURN Cmd
ENDFUNC
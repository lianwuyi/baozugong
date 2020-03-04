*--------------------------------------------------------------------------------------
* 连接MSSQL数据库
*--------------------------------------------------------------------------------------
SQLDISCONNECT(0)  && 断开所有数据连接
RELEASE lnHandle  && 设定连接句柄为公共变量,可以为后面的程式引用
PUBLIC  lnHandle
lnHandle = 0

*！* *从sys1.dbf文件里获取
*!*	SELECT 0
*!*	USE ..\Data\sys1.Dbf
*!*	csqlserver = ALLTRIM(sqlserver)
*!*	USE

* 从sys.ini 文件里面获取IP地址
If !File('Sys.ini')
    Messagebox('配制文件 Sys.ini 不存在！'+Space(5),16,'信息提示')
    Quit
Endif
lcConfigStr=Upper(Filetostr('Sys.ini')) &&将INI文件转成字符串
lnConfigStrLine=Memlines(lcConfigStr)      &&取得INI文件的行数
Store '' To lcPCName,lcPCIPAdress,lcDBName &&如果有必要也可以将这几个变量定义为全局变量
For I=1 To lnConfigStrLine
    lcRowStr=Mline(lcConfigStr,I)  &&取得INI文件的每行
    Do Case
        Case Upper('ServerIPAdress=')$lcRowStr
            csqlserver=Alltrim(Strextract(lcRowStr,Upper('ServerIPAdress=')))
    Endcase
Endfor
IF EMPTY(csqlserver)
    Messagebox('配制文件Sys.ini中有错误！'+Space(5),16,'信息提示')
    Quit
Endif

SQLSETPROP(0,"DispLogin" ,3) && 不打开ODBC连接界面
* 设定连接串
TempStr1 = 'Eb123456'          && 登陆账号密码
linkdb1 = 'driver=SQL Server;Server='  && 数据库类型
linkdb1 = linkdb1+csqlserver           && 数据库路径
linkdb1 = linkdb1+';Uid=sa;pwd=&TempStr1;database=Baozugong_tao_db'
lnHandle= SQLSTRINGCONNECT(linkdb1)

IF lnHandle <= 0 && 连接不成功,
  SQLDISCONNECT(0) && 断开所有数据连接
  RELEASE lnHandle && 删除连接句柄变量
  MESSAGEBOX ("连接数据库失败……",16+0+0,ALLTRIM(c版本号)+"提示")
  RETURN TO MASTER && 返回到最高级程序的调用处 
ENDIF

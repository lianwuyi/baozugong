*--------------------------------------------------------------------------------------
* 连接MSSQL数据库
*--------------------------------------------------------------------------------------
SQLDISCONNECT(0)  && 断开所有数据连接
RELEASE lnHandle  && 设定连接句柄为公共变量,可以为后面的程式引用
PUBLIC  lnHandle
lnHandle = 0

SELECT 0
USE ..\Data\sys1.Dbf
csqlserver = ALLTRIM(sqlserver)
SQLSETPROP(0,"DispLogin" ,3) && 不打开ODBC连接界面
USE

* lnHandle=SQLSTRINGCONNECT("driver=SQL Server;Server=192.168.1.246;Uid=wk666;pwd=3b7d29akfq93lgs8;database=xlyywdb")
* 设定连接串
TempStr1 = 'Eb123456'          && 登陆账号密码
linkdb1 = 'driver=SQL Server;Server='  && 数据库类型
linkdb1 = linkdb1+csqlserver           && 数据库路径
linkdb1 = linkdb1+';Uid=sa;pwd=&TempStr1;database=xlydb'
lnHandle= SQLSTRINGCONNECT(linkdb1)

IF lnHandle <= 0 && 连接不成功,
  SQLDISCONNECT(0) && 断开所有数据连接
  RELEASE lnHandle && 删除连接句柄变量
  MESSAGEBOX ("连接数据库失败……",16+0+0,ALLTRIM(c版本号)+"提示")
  RETURN TO MASTER && 返回到最高级程序的调用处 
ENDIF

*WAIT WINDOW lnHandle NOWAIT NOCLEAR 

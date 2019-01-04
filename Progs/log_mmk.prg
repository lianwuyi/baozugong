*--------------------------------------------------------------------------------------
* log_mmk.PRG
*--------------------------------------------------------------------------------------
DO 连接数据库.prg

*-查询公司设置
ln1=SQLExec(lnHandle,'select * from sys_gssetup ')
  If ln1<=0   && 查询数据不成功，断开所有数据连接
    SQLDISCONNECT(0) && 断开所有数据连接
    RELEASE lnHandle && 删除连接句柄变量
    MESSAGEBOX ("查询数据库失败！","提示")
    QUIT && 因为启动程序，所以要退出系统 -----
    RETURN 
  ENDIF

c原寄地 = ALLTRIM(原寄地)
c公司名称 = ALLTRIM(公司名称)
c工厂名称  = ALLTRIM(工厂名称)
c公司地址 = ALLTRIM(公司地址)
c工厂地址 = ALLTRIM(工厂地址)
c公司电话 = ALLTRIM(公司电话)
c公司传真 = ALLTRIM(公司传真)
c寄件司手机 = ALLTRIM(寄件司手机)
c对帐单地址 = ALLTRIM(对帐单地址)
USE

SQLDISCONNECT(0) && 断开所有数据连接
RELEASE lnHandle && 删除连接句柄变量
Close Databases All
Close Tables All
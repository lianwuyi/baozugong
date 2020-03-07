*--------------------------------------------------------------------------------------
* 系统参数.PRG
*--------------------------------------------------------------------------------------
SET SAFETY OFF        && 决定改写已有文件之前是否显示对话框
SET TALK OFF          && 决定 Visual FoxPro 是否显示命令结果
SET CENTURY ON        && 显示年份为4位
SET DATE ANSI         && yy.mm.dd (年月日格式)
SET DELETED ON        && ON 为使用范围子句处理记录(包括在相关表中的记录)的命令忽略标有删除标记的记录。
SET EXCLUSIVE OFF     && (私有数据工作期的默认方式)允许网络上的任何用户共享和修改网络上打开的表。
SET HELP ON           && 允许打开帮助
SET ESCAPE OFF        && 禁止运行的程序在按 Esc 键后被中断
SET NULLDISPLAY TO '' && 去除一切值带 null
SET MULTILOCKS ON


*-----设置程序主目录-------------------------
RELEASE gcMainPath
PUBLIC  gcMainPath
gcMainPath = Sys(5)+"\"          && 设置当前根目录为系统路径 +SYS(2003)
*gcMainPath = ADDBS(JUSTPATH(SYS(16,1)))  && 设置当前目录为系统路径
*SET DEFAULT TO c:\ 
SET DEFAULT TO &gcMainPath

CD "\Baozugong\"
SET PATH TO ;DATA;FORMS;LIBS;MENUS;PROGS;REPORTS;BMP;EXCEL
*----------------------------------------------


*-----设置系统公共变量-------------------------
RELEASE c版本号,c版权,c系统日期,c测试
PUBLIC  c版本号,c版权,c系统日期,c测试

c版本号="包租公自建房出租管理系统 Ver 1.0"
c版权 = '版权所有：(C)EbongSoft 2020'
c系统日期 = DTOC(DATE())
c测试=1   && 未测试状态
*----------------------------------------------

*--------------------------------------------------------------------------------------

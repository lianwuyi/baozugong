RELEASE c标题,c提示
PUBLIC  c标题,c提示

*** 【提前三天到期提醒】
*!*	IF c采购审核=1
   c标题 = "【审核提醒】"
   c提示 = "您有未审核的采购单据，请尽快处理！"
   DO ..\progs\popwindows.prg
*!*	ENDIF
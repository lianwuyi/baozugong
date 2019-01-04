*IF messagebox('您确定退出当前系统?',68,'提示') = 7
*  WAIT CLEAR    
*  RETURN
*ENDIF

RELEASE WINDOWS && 关闭顶层表单
CLOSE DATABASES All
CLOSE TABLES All
QUIT

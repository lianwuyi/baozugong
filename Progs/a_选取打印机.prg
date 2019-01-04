*a_设置打印机
*---------------------------------------------------------------------------------------------------------
* 这段代码设置VFP默认与WINDOWS打印机一致，VFP默认打印机是与WINDOW 默认打印机是不同的概念，所以要使两者一致，才能打印。
WshNetwork=Createobject("WScript.Network")
Public YD_Printer,SD_Printer
*-------------------------------------------------------------------------
YD_Printer=Set("Printer",2)  &&获取当前系统的默认打印机名称
Wait Window "提示:当前系统的默认打印机为：" +YD_Printer At 10,100 Nowait Noclear
*-------------------------------------------------------------------------
SD_Printer = Getprinter() && 选择WINDOWS中的打印机

If Empty(SD_Printer)
	Wait Window '提示：你没有未选取打印机并进行打印！' At 10,40 Nowait Noclear
	RETURN
ENDIF 

If ! Empty(SD_Printer)
	WshNetwork.SetDefaultPrinter(SD_Printer)
	YD_Printer=Set("Printer",2)  &&重新获取当前系统的默认打印机名称
Set Printer To Default  && 设置 VFP 和 WINDOWS 默认打印机一致
printk1 = SYS(1037) && 设置页面
IF printk1 ='0'
Wait Window '提示：你取消打印！' At 10,40 Nowait Noclear
RETURN 
ENDIF
WAIT CLEAR
ENDIF 
*--------------------------------------------------------------------------------------

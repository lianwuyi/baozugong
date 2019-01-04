*----------------------------------
*	防止程序被多次开启
*----------------------------------
Public handle
Declare Integer CreateFileMapping In kernel32.Dll Integer hFile, ;
	INTEGER lpFileMappingAttributes,Integer flProtect, ;
	INTEGER dwMaximumSizeHigh, Integer dwMaximumSizeLow, ;
	STRING lpName
Declare Integer GetLastError In kernel32.Dll
Declare Integer CloseHandle In kernel32.Dll Integer hObject

szname="Xgerp-sos"   
handle = CreateFileMapping(0xFFFFFFFF,0,4,0,128,szname)

If handle = 0
	Wait Window "CreateFileMapping 失败 - LastError: " + Ltrim(Str(GetLastError()))
	Return
Endif

If handle=0
	Messagebox("内存映射文件创建失败！",16,"错误")
	Return .F.
Else
	If GetLastError()=183
		=Messagebox("该程序程序已经运行！",16,"提示")
		Close All
		Clear Dlls
		Clear Events
		Quit
	Endif
ENDIF
*-- 定义常量
#DEFINE LOGPIXELSX 88
#DEFINE LOGPIXELSY 90
#DEFINE PHYSICALOFFSETX 112
#DEFINE PHYSICALOFFSETY 113
#DEFINE SRCCOPY 13369376
#DEFINE DIB_RGB_COLORS 0

*-- 调用本程序段中的子过程
DO decl

*-- 定义变量
PRIVATE pnWidth, pnHeight, lnBitsPerPixel, lnBytesPerScan
STORE 0 TO pnWidth, pnHeight, lnBitsPerPixel, lnBytesPerScan
LOCAL hwnd, hFormDC, hPrnDC, hMemDC, hMemBmp, hSavedBitmap,;
xOffsPrn, yOffsPrn, xScale, yScale, lcDocInfo, lcBInfo, lpBitsArray

*-- 得到打印机设备的坐标偏移量
hPrnDC = getDefaultPrnDC() && 没有进行错误检查
xOffsPrn = GetDeviceCaps(hPrnDC, PHYSICALOFFSETX)
yOffsPrn = GetDeviceCaps(hPrnDC, PHYSICALOFFSETY)

*-- 得到屏幕的窗口句柄，及她们的宽度、高度等。
hwnd = GetFocus() && a window with keyboard focus
hFormDC = GetWindowDC(hwnd)
= getWinRect (hwnd, @pnWidth, @pnHeight)

*-- 根据屏幕和打印机得到缩放值
xScale = GetDeviceCaps(hPrnDC, LOGPIXELSX)/GetDeviceCaps(hFormDC,LOGPIXELSX)
yScale = GetDeviceCaps(hPrnDC, LOGPIXELSY)/GetDeviceCaps(hFormDC,LOGPIXELSY)

*-- 将屏幕的内容创建为位图图象数据
hMemDC = CreateCompatibleDC (hFormDC)
hMemBmp = CreateCompatibleBitmap (hFormDC, pnWidth, pnHeight)
hSavedBitmap = SelectObject(hMemDC, hMemBmp)

*-- 将位图数据从屏幕拷贝到虚拟设备上
= BitBlt (hMemDC, 0,0, pnWidth,pnHeight, hFormDC, 0,0, SRCCOPY)
= SelectObject(hMemDC, hSavedBitmap)

* retrieving bits from the compatible bitmap into a buffer
* as a device-independent bitmap (DIB) with a BitsPerPixel value
* as one of the printer device context
lcBInfo = InitBitmapInfo(hPrnDC)
lpBitsArray = InitBitsArray()
= GetDIBits (hMemDC, hMemBmp, 0, pnHeight,;
lpBitsArray, @lcBInfo, DIB_RGB_COLORS)

lcDocInfo = Chr(20) + Repli(Chr(0), 19) && DOCINFO struct - 20 bytes
IF StartDoc(hPrnDC, @lcDocInfo) > 0
= StartPage(hPrnDC)

= StretchDIBits (hPrnDC, xOffsPrn, yOffsPrn,;
xOffsPrn + Int(xScale * pnWidth),;
yOffsPrn + Int(yScale * pnHeight),;
0,0, pnWidth, pnHeight,;
lpBitsArray, @lcBInfo, DIB_RGB_COLORS, SRCCOPY)

= EndPage(hPrnDC)
= EndDoc(hPrnDC)
ENDIF

*-- 退出时释放系统资源
= GlobalFree(lpBitsArray)
= DeleteObject(hMemBmp)
= DeleteDC(hMemDC)
= DeleteDC(hPrnDC)
= ReleaseDC(hwnd, hFormDC)
RETURN

PROCEDURE getWinRect (lnHwnd, lnWidth, lnHeight)
*-- 返回指定句柄的窗口的宽和高
#DEFINE maxDword 4294967295 && 0xffffffff
LOCAL lpRect, lnLeft, lnTop, lnRight, lnBottom
lpRect = REPLI (Chr(0), 16)
= GetWindowRect (lnHwnd, @lpRect)

lnRight = buf2dword(SUBSTR(lpRect, 9,4))
lnBottom = buf2dword(SUBSTR(lpRect, 13,4))

lnLeft = buf2dword(SUBSTR(lpRect, 1,4))
IF lnLeft > lnRight
lnLeft = lnLeft - maxDword
ENDIF
lnTop = buf2dword(SUBSTR(lpRect, 5,4))
IF lnTop > lnBottom
lnTop = lnTop - maxDword
ENDIF

lnWidth = lnRight - lnLeft
lnHeight = lnBottom - lnTop
RETURN

FUNCTION getDefaultPrnDC
* returns device context for the default printer
#DEFINE PD_RETURNDC 256
#DEFINE PD_RETURNDEFAULT 1024
LOCAL lcStruct, lnFlags
lnFlags = PD_RETURNDEFAULT + PD_RETURNDC

* fill PRINTDLG structure
lcStruct = num2dword(66) + Repli(Chr(0), 16) +;
num2dword(lnFlags) + Repli(Chr(0), 42)
IF PrintDlg (@lcStruct) <> 0
RETURN buf2dword (SUBSTR(lcStruct, 17,4))
ENDIF
RETURN 0

FUNCTION InitBitmapInfo(hTargetDC)
#DEFINE BI_RGB 0
#DEFINE RGBQUAD_SIZE 4 && RGBQUAD
#DEFINE BHDR_SIZE 40 && BITMAPINFOHEADER

LOCAL lnRgbQuadSize, lcRgbQuad, lcBIHdr

* use printer BitPerPixel value
lnBitsPerPixel = 24

* initializing BitmapInfoHeader structure
lcBIHdr = num2dword(BHDR_SIZE) +;
num2dword(pnWidth) + num2dword(pnHeight) +;
num2word(1) + num2word(lnBitsPerPixel) +;
num2dword(BI_RGB) + Repli(Chr(0), 20)

* creating a buffer for the color table
IF lnBitsPerPixel <= 8
lnRgbQuadSize = (2^lnBitsPerPixel) * RGBQUAD_SIZE
lcRgbQuad = Repli(Chr(0), lnRgbQuadSize)
ELSE
lcRgbQuad = ""
ENDIF
RETURN lcBIHdr + lcRgbQuad

PROCEDURE InitBitsArray()
#DEFINE GMEM_FIXED 0
LOCAL lnPtr, lnAllocSize

* making sure the value is DWORD-aligned
lnBytesPerScan = Int((pnWidth * lnBitsPerPixel)/8)
IF Mod(lnBytesPerScan, 4) <> 0
lnBytesPerScan = lnBytesPerScan + 4 - Mod(lnBytesPerScan, 4)
ENDIF

lnAllocSize = pnHeight * lnBytesPerScan
lnPtr = GlobalAlloc (GMEM_FIXED, lnAllocSize)
= ZeroMemory (lnPtr, lnAllocSize)
RETURN lnPtr

FUNCTION num2word (lnValue)
RETURN Chr(MOD(m.lnValue,256)) + CHR(INT(m.lnValue/256))

FUNCTION num2dword (lnValue)
#DEFINE m0 256
#DEFINE m1 65536
#DEFINE m2 16777216
LOCAL b0, b1, b2, b3
b3 = Int(lnValue/m2)
b2 = Int((lnValue - b3*m2)/m1)
b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
b0 = Mod(lnValue, m0)
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)

FUNCTION buf2word (lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
Asc(SUBSTR(lcBuffer, 2,1)) * 256

FUNCTION buf2dword (lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
Asc(SUBSTR(lcBuffer, 2,1)) * 256 +;
Asc(SUBSTR(lcBuffer, 3,1)) * 65536 +;
Asc(SUBSTR(lcBuffer, 4,1)) * 16777216

PROCEDURE decl && so many of them declared here
DECLARE INTEGER GetFocus IN user32
DECLARE INTEGER EndDoc IN gdi32 INTEGER hdc
DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd
DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObject
DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc
DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc
DECLARE INTEGER GetWindowRect IN user32 INTEGER hwnd, STRING @lpRect
DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER wFlags, INTEGER dwBytes
DECLARE INTEGER GetDeviceCaps IN gdi32 INTEGER hdc, INTEGER nIndex
DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObject
DECLARE INTEGER StartDoc IN gdi32 INTEGER hdc, STRING @ lpdi
DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem
DECLARE INTEGER PrintDlg IN comdlg32 STRING @ lppd
DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc
DECLARE INTEGER StartPage IN gdi32 INTEGER hdc
DECLARE INTEGER EndPage IN gdi32 INTEGER hdc

DECLARE RtlZeroMemory IN kernel32 As ZeroMemory;
INTEGER dest, INTEGER numBytes

DECLARE INTEGER CreateCompatibleBitmap IN gdi32;
INTEGER hdc, INTEGER nWidth, INTEGER nHeight

DECLARE INTEGER BitBlt IN gdi32;
INTEGER hDestDC, INTEGER x, INTEGER y,;
INTEGER nWidth, INTEGER nHeight, INTEGER hSrcDC,;
INTEGER xSrc, INTEGER ySrc, INTEGER dwRop

DECLARE INTEGER StretchDIBits IN gdi32;
INTEGER hdc, INTEGER XDest, INTEGER YDest,;
INTEGER nDestWidth, INTEGER nDestHeight, INTEGER XSrc,;
INTEGER YSrc, INTEGER nSrcWidth, INTEGER nSrcHeight,;
INTEGER lpBits, STRING @lpBitsInfo,;
INTEGER iUsage, INTEGER dwRop

DECLARE INTEGER GetDIBits IN gdi32;
INTEGER hdc, INTEGER hbmp, INTEGER uStartScan,;
INTEGER cScanLines, INTEGER lpvBits, STRING @lpbi,;
INTEGER uUsage
RETURN && decl 
 
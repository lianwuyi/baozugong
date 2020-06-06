CLEAR 

CLOSE DATABASES ALL 
CLOSE TABLES ALL 

SELECT 0 
USE C:\baozugong\data\asset.dbf

Cmd  = []
FOR I = 1 TO FCOUNT()
    fld  = FIELD(I)
    dta  = &Fld
    typ  = VARTYPE(dta)
    *cdta = ALLTRIM(TRANSFORM(dta))
    *cdta = CHRTRAN ( cdta, CHR(39),CHR(146) )
    cmd = cmd + [,] + fld + [ ]+ typ
ENDFOR
?cmd
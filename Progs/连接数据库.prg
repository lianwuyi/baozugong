*--------------------------------------------------------------------------------------
* ����MSSQL���ݿ�
*--------------------------------------------------------------------------------------
SQLDISCONNECT(0)  && �Ͽ�������������
RELEASE lnHandle  && �趨���Ӿ��Ϊ��������,����Ϊ����ĳ�ʽ����
PUBLIC  lnHandle
lnHandle = 0

*csqlserver Ϊ������������ϵͳ�������Ŀ¼sys.ini�ļ����ȡ

SQLSETPROP(0,"DispLogin" ,3) && ����ODBC���ӽ���
* �趨���Ӵ�
TempStr1 = 'Eb123456'          && ��½�˺�����
Database1 = 'baozugong_'+ALLTRIM(cCustomer)     && �����ݿ����ƣ���sys.ini���޸ġ�
linkdb1 = 'driver=SQL Server;Server='  && ���ݿ�����
linkdb1 = linkdb1+csqlserver           && ���ݿ�·��
linkdb1 = linkdb1+';Uid=sa;pwd=&TempStr1;database=&Database1'
lnHandle= SQLSTRINGCONNECT(linkdb1)

IF lnHandle <= 0 && ���Ӳ��ɹ�,
  SQLDISCONNECT(0) && �Ͽ�������������
  RELEASE lnHandle && ɾ�����Ӿ������
  MESSAGEBOX ("�������ݿ�ʧ�ܡ���",16+0+0,ALLTRIM(c�汾��)+"��ʾ")
  RETURN TO MASTER && ���ص���߼�����ĵ��ô� 
ENDIF


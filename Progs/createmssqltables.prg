
* �������ݿ��
* CreateMSSQLTables.PRG

SET TALK OFF
CLEAR
CLOSE ALL
SET STRICTDATE TO 0
SET SAFETY OFF
SET EXCLUSIVE ON
SET CONFIRM ON

*!*	����SQL���ݿ�---------------------------------------------------------------------------------
ConnStr = [Driver={SQL Server};Server=192.168.2.8;UID=sa;PWD=3b7d29akfq93lgs8;Database=lyerp;]
Handle = SQLSTRINGCONNECT( ConnStr )
IF Handle < 1
   MESSAGEBOX( "�޷����ӵ����ݿ�" + CHR(13) + ConnStr, 16 )
   RETURN
ENDIF


     
*!* ����MSSQL��
TEXT TO cmd NOSHOW TEXTMERGE
	    
	/* ��Ʒ�� */
	CREATE TABLE [product] ( 
		product_id int,
		product_na varchar(150),
		category varchar(60),
		code varchar(60),
		colour varchar(60),
		model varchar(10),
		company varchar(250),
		bar_code varchar(50), 
	)

		/* �ͻ��� */
	CREATE TABLE [customer] ( 
		customerid int,
		customerno varchar(10),
		customerna varchar(150),
		currency varchar(10),
		address varchar(150),
		nature varchar(30),
		contact varchar(10),
		phone varchar(30), 
                     fax varchar(30), 
                     email varchar(30), 
                     mobile varchar(30), 
                     banker varchar(60), 
                     company varchar(60), 
                     account varchar(60), 
                    taxpayerno varchar(60), 
                    paymethond varchar(60), 
                    remark varchar(150), 
                    qq varchar(50), 
                    wechat varchar(50), 
                   receivable varchar(50), 
                   loanperiod varchar(10)
)


		/* ��Ӧ�� */
	CREATE TABLE [supplier] ( 
		supplierid int,
		supplierno varchar(10),
		supplierna varchar(150),
		currency varchar(10),
		address varchar(150),
		nature varchar(30),
		contact varchar(10),
		phone varchar(30), 
                     fax varchar(30), 
                     email varchar(30), 
                     mobile varchar(30), 
                      banker varchar(60),
                      taxpayerno varchar(60), 
                       company varchar(60), 
                       account varchar(60),
                        accountpay numeric(8,2),
                        paymethond varchar(60),
                          remark varchar(150),
                          qq varchar(50), 
                          wechat varchar(50), 
                           payterm varchar(10), 
)



ENDTEXT 

lr = SQLEXEC(Handle, Cmd) && ����SQL����
IF lr < 0 
  MESSAGEBOX("�������ݱ�ʧ��",16 )
  SUSPEND  && ��ֹ����̵�����
ELSE 
  MESSAGEBOX("�������ݿ��ɹ�!",8)
ENDIF       

SQLDISCONNECT(0) && �Ͽ����ݿ�
*!*	---------------------------------------------------------------------------------------------
Handle = 0
ConnectionString = [Driver={SQL Server};Server=123.207.38.110;Database=xlydb;UID=sa;PWD=Eb123456;]
Handle = SQLSTRINGCONNECT(ConnectionString)
IF Handle <=0
  MESSAGEBOX( [�������ݿ�ʧ�ܡ���], 16, [����] )
ENDIF 

Cmd = [INSERT ] + pTable + [ ( ]  && Cmd = insert ��ǰ���� (
FOR I = 1 TO FCOUNT() && FCOUNT() ���ص�ǰ���ֶ���Ŀ
	Fld = UPPER(FIELD(I)) && ���ر��и��ֶε����ƣ���������д���Ҹ�ֵ�� fld
	IF TYPE ( Fld ) = [G]  && ����ַ�������G��ͨ���ֶεĻ��������
	   LOOP && ��ѭ�����������loop������������ѭ�����������·���ѭ����ʼ��do while��for��俪ͷ���������ж�ѭ��������������������ѭ����
	ENDIF
	Cmd = Cmd + Fld + [, ]  && ѭ��д�� Cmd  
ENDFOR
Cmd = LEFT(Cmd,LEN(Cmd)-2) + [ ) VALUES ( ]  && ��CP��ִ�к�ó�?cmd���� instert cp(��Ʒid,��Ʒ���,��Ʒ����) values �� ��

FOR I = 1 TO FCOUNT()  && �ٴ�ѭ����fcount�������ص�ǰ���ֶε���Ŀ
	Fld = FIELD(I)  && ��ȡ��ǰ�ֶε����ƣ���ֵ��Fld
	IF TYPE ( Fld ) = [G]  && ������ֶ��� G���ͣ���ͨ�����͵��ַ��������
	   LOOP && ѭ����������
	ENDIF
	Dta = ALLTRIM(TRANSFORM ( &Fld )) &&  TRANSFORM()���ַ���������ת�����ַ���
	Dta = CHRTRAN ( Dta, CHR(39), CHR(146) )		&& get rid of single quotes in the data ɾ�������еĵ�����
	Dta = IIF ( Dta = [/  /], [], Dta )  && ���������/ /,��ȥ��
	Dta = IIF ( Dta = [.F.], [0], Dta )  && ��������� .F.,���Ϊ0
	Dta = IIF ( Dta = [.T.], [1], Dta )  && ��������� .T.,���Ϊ1
	Dlm = IIF ( TYPE ( Fld ) $ [CM],['],; && ����������ַ��ͣ����[']
	      IIF ( TYPE ( Fld ) $ [DT],['],; && ��������������ͣ�Ҳ��[']
	      IIF ( TYPE ( Fld ) $ [IN],[],	[]))) &&�����������ֵ�ͣ��򲻼��κη���
	Cmd = Cmd + Dlm + Dta + Dlm + [, ]  && ѭ��д��
ENDFOR
Cmd = LEFT ( Cmd, LEN(Cmd) -2) + [ )]  && Remove ", " add " )"    ɾ��[��]�ţ�����[)]��

WAIT WINDOW cmd NOWAIT NOCLEAR 

lr = SQLExec (Handle, cmd )   && ��CP��ִ�к�ó� lr=SQLExec(this.handle,instert cp(��Ʒid,��Ʒ���,��Ʒ����) values ��1,'1','1')��
IF lr < 0  && �������<0
   MESSAGEBOX( [�޷������¼], 16, [����] )
ELSE 
  MESSAGEBOX( [����ɹ�!], 16, [��ʾ] )
ENDIF




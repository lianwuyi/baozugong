form1 = createobject('form1')                  && ����һ����
form1.addobject('cmdcmndbtn1','cmdmycmndbtn1') && �˳����ť
form1.top=0      &&���ö�������
form1.left=0     &&����������
form1.width=1024 &&���ÿ��
form1.height=768 &&���ø߶�
form1.show                                     && ��ʾ��
read events                                    && �����¼�����

define class form1 as form     && ������
   autocenter=.t.              && ����ʼ��ʱ����
   caption="Commandbottonʾ��" && ������
   closable=.f.                && ���رհ�ť������
   procedure load
      *---������ʱ��
      create cursor tabname (name c (10))
      for i=1 to 10
          insert into tabname values (replicate(chr(i+64),10))
      endfor
      browse
enddefine

define class cmdmycmndbtn1 as commandbutton && �������ť
   caption = '�˳�' && ���ť�ϵı���
   cancel = .t.     && Ĭ�ϡ�ȡ�������ť (esc)
   left = 125       && ���ť��
   top = 150        && ���ť��
   height = 25      && ���ť��
   visible=.t.      && ���ť
   procedure click
      clear events && ��ֹ�¼�����,�رձ�
enddefine
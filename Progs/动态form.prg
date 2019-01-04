form1 = createobject('form1')                  && 创建一个表单
form1.addobject('cmdcmndbtn1','cmdmycmndbtn1') && 退出命令按钮
form1.top=0      &&设置顶部距离
form1.left=0     &&设置左侧距离
form1.width=1024 &&设置宽度
form1.height=768 &&设置高度
form1.show                                     && 显示表单
read events                                    && 启动事件处理

define class form1 as form     && 创建表单
   autocenter=.t.              && 表单初始化时居中
   caption="Commandbotton示例" && 表单标题
   closable=.f.                && 表单关闭按钮不可用
   procedure load
      *---创建临时表
      create cursor tabname (name c (10))
      for i=1 to 10
          insert into tabname values (replicate(chr(i+64),10))
      endfor
      browse
enddefine

define class cmdmycmndbtn1 as commandbutton && 创建命令按钮
   caption = '退出' && 命令按钮上的标题
   cancel = .t.     && 默认“取消”命令按钮 (esc)
   left = 125       && 命令按钮列
   top = 150        && 命令按钮行
   height = 25      && 命令按钮高
   visible=.t.      && 命令按钮
   procedure click
      clear events && 终止事件处理,关闭表单
enddefine
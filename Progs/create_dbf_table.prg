*!* ʾ��  crea table abc(a c(10),b n(12,4))

*!* ����¼����ʱ��
CREATE TABLE customer(;
	cust_id i,cust_name c(60),sex c(60),id_type c(60),id_no c(60),tel c(60),;
	wechat c(60),email c(60),vocation c(60),campany c(60),cpy_add c(60),;
	cyp_tel c(60),ice c(60),ice_tel c(60),payee_ac c(60),;
	other c(100),operator c(60),act_date D)
		
CREATE TABLE zone(zone_id i,zone_no c(60),zone_name c(60),zone_add c(60),zone_nts c(60),worker_id i)

CREATE TABLE asset(asset_id i,asset_no c(60),asset_name c(60),type c(60),area c(60),floor c(60),pay_type c(60),price n(8,2),ornt c(60),status c(60),zone_id i,zong_name c(60))

CREATE TABLE template(temp_id i,temp_name c(60))

CREATE TABLE cost(cost_id i,cost_name c(60),cost_tpye c(60),formula c(60),deposit i,rent i,;
	unit_prx n(8,2),cycle_time i,cycle_unit i,temp_id i,temp_ name(60))

CREATE TABLE worker(worker_id i,worker c(60),worker_tel c(60))

CREATE TABLE contract(coont_id i,cont_no c(60),zone_id i,zone_name c(60),asset_id i,asset_name c(60),;
	type c(60),area c(60),floor c(60),cust_id i,cust_name c(60),sex c(60),tel c(60),id_type c(60),id_no c(60),;
	signed_s d,signed_o d,signed_d d,cont_nts c(60),operator c(60),act_date d,rent_date d,temp_id i,temp_name c(60))

*!*	CREATE TABLE information(cpy_id i,full_name c(60),attn c(60),fax c(60),tel c(60),mobile c(60),add c(60))

CREATE TABLE receipt(rec_id i,rec_no c(60),cust_id i,asset_id i,date d,amount n(8,2),remark c(60),collection c(60),account c(60),operator c(60),act_date d)

*!*	CREATE TABLE mmk(login_id c(60),password c(60),login_name c(60),daty c(60))

*!*	CREATE TABLE keys(tablename c(60),lastkeyval i)

*!*	CREATE TABLE error(date d,time t,linenum i,progname c(60),codeline c(60))

CREATE TABLE income(date d,title c(60),datail c(60),cicome n(8,2),pay_out n(8,2),balance n(8,2))

CREATE TABLE conitem(contitemid i,cost_id i,cost_name c(60),cost_tpye c(60),formula c(60),deposit i,rent i,;
	unit_prx n(8,2),cycle_time i,cycle_unit i,temp_id i,temp_name c(60))

*** ���ɲ�ѯdbf

CREATE TABLE customers(;
	cust_id i,cust_name c(60),sex c(60),id_type c(60),id_no c(60),tel c(60),;
	wechat c(60),email c(60),vocation c(60),campany c(60),cpy_add c(60),;
	cyp_tel c(60),ice c(60),ice_tel c(60),payee_ac c(60),;
	other c(100),operator c(60),act_date D)
		
CREATE TABLE zones(zone_id i,zone_no c(60),zone_name c(60),zone_add c(60),zone_nts c(60),worker_id i)

CREATE TABLE assets(asset_id i,asset_no c(60),asset_name c(60),type c(60),area c(60),floor c(60),pay_type c(60),price n(8,2),ornt c(60),status c(60),zone_id i,zong_name c(60))

CREATE TABLE templates(temp_id i,temp_name c(60))

CREATE TABLE costs(cost_id i,cost_name c(60),cost_tpye c(60),formula c(60),deposit i,rent i,;
	unit_prx n(8,2),cycle_time i,cycle_unit i,temp_id i,temp_ name(60))

CREATE TABLE workers(worker_id i,worker c(60),worker_tel c(60))

CREATE TABLE contracts(coont_id i,cont_no c(60),zone_id i,zone_name c(60),asset_id i,asset_name c(60),;
	type c(60),area c(60),floor c(60),cust_id i,cust_name c(60),sex c(60),tel c(60),id_type c(60),id_no c(60),;
	signed_s d,signed_o d,signed_d d,cont_nts c(60),operator c(60),act_date d,rent_date d,temp_id i,temp_name c(60))

*!*	CREATE TABLE information(cpy_id i,full_name c(60),attn c(60),fax c(60),tel c(60),mobile c(60),add c(60))

CREATE TABLE receipts(rec_id i,rec_no c(60),cust_id i,asset_id i,date d,amount n(8,2),remark c(60),collection c(60),account c(60),operator c(60),act_date d)

*!*	CREATE TABLE mmk(login_id c(60),password c(60),login_name c(60),daty c(60))

*!*	CREATE TABLE keys(tablename c(60),lastkeyval i)

*!*	CREATE TABLE error(date d,time t,linenum i,progname c(60),codeline c(60))

CREATE TABLE incomes(date d,title c(60),datail c(60),cicome n(8,2),pay_out n(8,2),balance n(8,2))

CREATE TABLE conitems(contitemid i,cost_id i,cost_name c(60),cost_tpye c(60),formula c(60),deposit i,rent i,;
	unit_prx n(8,2),cycle_time i,cycle_unit i,temp_id i,temp_name c(60))
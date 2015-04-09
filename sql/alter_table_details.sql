ALTER TABLE tbltradesdetail
ADD ClientName varchar(100) NULL
go
ALTER TABLE tbltradesdetail
ADD ClientNetwork varchar(40) NULL



delete tbltradesdetail where ems_name = 'INSTINET' AND tradedate like '201304%'

select clientname,clientnetwork, tradedate, count(*) as total 
from tbltradesdetail where ems_name = 'INSTINET'
group by clientname, clientnetwork, tradedate
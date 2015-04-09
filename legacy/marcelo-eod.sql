/**
tradedate,source,symbol,side,price,SharesTraded,

ordertype,DestID,exchange,ClearingBroker,exSystemID)
*/
INSERT into tblTrades (tradedate,source,symbol,side,price,SharesTraded,ordertype,DestID,exchange,ClearingBroker,exSystemID)
SELECT ltrim(rtrim(TradeDate)) as tradedate,  'UNX-'+listID as source, symbol, 
case side 
	when '1' then 'B' 
	when '2' then 'S'
	when '3' then 'T'
	when '5' then 'T'
end as side,
SUM( lastSh  *   cast(lastpx as Decimal(18,4))  ) /   SUM ( lastSh )  as AVGPRICE,
SUM (LastSh)  as SHARES,
--HARDCODED
'N/A'as ordertype ,0 as DestID, 'N/A' as exchange,'ML'as clearingBroker, 11 as exSystem
FROM   tbltradesUNX where tradedate = '20110930'  
group by tradeDate, listID, symbol, side
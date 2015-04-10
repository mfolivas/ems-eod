alter table tblTradesDetail ADD column RawLiquidity VARCHAR(100);
alter table tblTradesDetail ADD column LastMkt VARCHAR(100) null;
alter table tblTradesDetail ADD column LastLiquidity VARCHAR(100) null;
alter table tblTradesDetail ADD column Currency VARCHAR(20) null;
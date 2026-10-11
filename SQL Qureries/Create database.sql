create database SSIS_Telecom_DB


use SSIS_Telecom_DB
go


create table fact_transaction (
	id int not null identity (1,1) primary key, -- surrogate key
	transaction_id int not null , 
	imsi varchar(9) not null,
	subscriber_id int,
	tac varchar(8) not null,
	snr varchar(6) not null,
	imei varchar(14) not null,
	cell int not null,
	lac int not null,
	event_type varchar(1) null,
	event_ts datetime not null,
    audit_id int not null,

);

alter table fact_transaction alter column tac varchar(8) null;
alter table fact_transaction alter column snr varchar(8) null;


create table error_destination_output (
    id int,
    imsi varchar(9),
    imei varchar(14),
    cell int,
    lac int,
    event_type varchar(1),
    event_ts datetime,
	tac varchar(8),
	snr varchar(6),
    ErrorCode int,
    ErrorColumn int
)


CREATE TABLE [err_source_output] (
	id int identity(1,1),
    [Flat File Source Error Output Column] varchar(max),
    [ErrorCode] int,
    [ErrorColumn] int
)


select * from fact_transaction

select * from error_destination_output

select * from dim_imsi_reference

truncate table fact_transaction;
select * from fact_transaction;



create table dim_audit (
    id int identity(1,1) not null primary key,
    batch_id int,
    package_name nvarchar(255) not null,
    file_name nvarchar(255) not null,
    rows_extracted int, -- rows in the source file
    rows_inserted int,
    --rows_updated int,
    rows_rejected int,
    created_at datetime default(getdate()),
    updated_at datetime default(getdate()),
    SuccessfulProcessingInd nchar(1) not null default 'N'
)
go

insert into dim_audit (
    batch_id,
    package_name,
    file_name,
    rows_extracted, rows_inserted, rows_rejected,
    SuccessfulProcessingInd)
output inserted.id as audit_id
values
    ( 8, 'SSMS Manual Insert', 'SSMS - File 1', NULL, NULL, NULL,  'N' )
go

select * from dim_audit;

update dim_audit
set
    [rows_extracted] = 100,
    [rows_inserted] = 90,
    [rows_rejected] = 10,
    SuccessfulProcessingInd = 'Y'
where id = 11

select * from dim_audit;

SET IDENTITY_INSERT dim_audit ON

insert into dim_audit (id, batch_id, package_name, file_name, rows_extracted, rows_inserted, rows_rejected)
values (-1, 0, 'Unknown', 'Unknown', null, null, null)

SET IDENTITY_INSERT dim_audit off

-- add audit id filed to error tables
alter table [err_source_output] add audit_id int not null default(-1);
alter table [error_destination_output] add audit_id int not null default(-1);

alter table [fact_transaction] add audit_id int not null default(-1);



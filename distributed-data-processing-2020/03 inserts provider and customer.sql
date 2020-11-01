use ws1db;

insert into provider (provider_taxpayer_id)
SELECT TOP 10 taxpayer_id FROM organization type ORDER BY NEWID();

insert into customer (customer_taxpayer_id)
SELECT TOP 10 taxpayer_id FROM organization type ORDER BY NEWID();
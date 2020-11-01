use ws1db;

CREATE TABLE customer
( 
	customer_taxpayer_id int  NOT NULL
)
go

ALTER TABLE customer
	ADD CONSTRAINT XPKcustomer PRIMARY KEY  NONCLUSTERED (customer_taxpayer_id ASC)
go



CREATE TABLE customer_product
( 
	customer_product_id  int  NOT NULL IDENTITY(1,1),
	customer_taxpayer_id int  NULL ,
	product_id           int  NULL 
)
go

ALTER TABLE customer_product
	ADD CONSTRAINT XPKcustomer_product PRIMARY KEY  NONCLUSTERED (customer_product_id ASC)
go



CREATE TABLE organization
( 
	taxpayer_id          int  NOT NULL IDENTITY(1,1),
	name                 varchar(100)  NOT NULL ,
	phone_number         varchar(11)  NOT NULL ,
	address              varchar(100)  NOT NULL ,
	head_full_name       varchar(100)  NOT NULL ,
	manager_full_name    varchar(100)  NOT NULL ,
	property_type_id     int  NOT NULL 
)
go

ALTER TABLE organization
	ADD CONSTRAINT XPKorganization PRIMARY KEY  NONCLUSTERED (taxpayer_id ASC)
go



CREATE TABLE product
( 
	product_id           int  NOT NULL IDENTITY(1,1),
	name                 varchar(100)  NOT NULL ,
	provider_taxpayer_id int  NOT NULL ,
	fat_percentage       tinyint  NOT NULL ,
	price                money  NOT NULL 
)
go

ALTER TABLE product
	ADD CONSTRAINT XPKproduct PRIMARY KEY  NONCLUSTERED (product_id ASC)
go



CREATE TABLE property_type
( 
	property_type_id     int  NOT NULL IDENTITY(1,1),
	name                 varchar(100)  NOT NULL 
)
go

ALTER TABLE property_type
	ADD CONSTRAINT XPKproperty_type PRIMARY KEY  NONCLUSTERED (property_type_id ASC)
go



CREATE TABLE provider
( 
	provider_taxpayer_id int  NOT NULL 
)
go

ALTER TABLE provider
	ADD CONSTRAINT XPKprovider PRIMARY KEY  NONCLUSTERED (provider_taxpayer_id ASC)
go








ALTER TABLE customer
	ADD CONSTRAINT r_organization_customer FOREIGN KEY (customer_taxpayer_id) REFERENCES organization(taxpayer_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE customer_product
	ADD CONSTRAINT r_customer_customer_product FOREIGN KEY (customer_taxpayer_id) REFERENCES customer(customer_taxpayer_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE customer_product
	ADD CONSTRAINT r_product_customer_product FOREIGN KEY (product_id) REFERENCES product(product_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE organization
	ADD CONSTRAINT r_property_type_organization FOREIGN KEY (property_type_id) REFERENCES property_type(property_type_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE product
	ADD CONSTRAINT r_provider_product FOREIGN KEY (provider_taxpayer_id) REFERENCES provider(provider_taxpayer_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE provider
	ADD CONSTRAINT r_organization_provider FOREIGN KEY (provider_taxpayer_id) REFERENCES organization(taxpayer_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go
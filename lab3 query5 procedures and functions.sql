use airport_db;
go
----------------------------------------------------
----------------------------------------------------
-- 1)	c������� �������� ���������
----------------------------------------------------
-- a)	��� ����������, � �������������� ���������� �������
----------------------------------------------------
-- ��������� ������� ���������� ����������� ������
----------------------------------------------------
create procedure get_today_flights as
begin	
	declare @dt datetime = getdate();
	declare @d date = convert (date, getdate());
	declare @vch varchar(10) = convert (varchar(10), @d);
	
	declare @vch1 varchar(19) = @vch + ' 00:00:00';
    declare @vch2 varchar(19) = @vch + ' 23:59:59';
    
    declare @dt1 datetime = convert(datetime, @vch1, 120);
    declare @dt2 datetime = convert(datetime, @vch2, 120);
    
	select departure_date, destination, arrival_date, flight_id, aircraft_id, aircrew_id 
	from flight
	where departure_date between @dt1 and @dt2;
end;
go
----------------------------------------------------
create function get_today_start_as_varchar()
returns varchar(19)
as
begin	
	declare @dt datetime = getdate();
	declare @d date = convert (date, getdate());

	declare @vch varchar(10) = convert (varchar(10), @d);
	declare @vch1 varchar(19) = @vch + ' 00:00:00';

	return @vch1;
end;
go
----------------------------------------------------
create function get_today_end_as_varchar()
returns varchar(19)
as
begin	
	declare @dt datetime = getdate();
	declare @d date = convert (date, getdate());

	declare @vch varchar(10) = convert (varchar(10), @d);
	declare @vch2 varchar(19) = @vch + ' 23:59:59';

	return @vch2;
end;
go
----------------------------------------------------
select * from flight 
order by arrival_date;
----------------------------------------------------
exec get_today_flights;
----------------------------------------------------
----------------------------------------------------
-- ��������� ������� ���������� ��������� �� ������� �������
----------------------------------------------------
create procedure calculate_number_of_tickets_sold_for_today as
begin	
	declare @dt datetime = getdate();
	declare @d date = convert (date, getdate());
	declare @vch varchar(10) = convert (varchar(10), @d);
		
	declare @vch1 varchar(19) = @vch + ' 00:00:00';
	declare @vch2 varchar(19) = @vch + ' 23:59:59';
	    
	declare @dt1 datetime = convert(datetime, @vch1, 120);
	declare @dt2 datetime = convert(datetime, @vch2, 120);
	    
	select count(*) as ����������_���������_��_�������_�������
	from ticket t
	inner join flight f
	on t.flight_id = f.flight_id
	where (departure_date between @dt1 and @dt2) and t.passenger_id is not null;
end;
go
----------------------------------------------------
select * from ticket;
----------------------------------------------------
declare @d date = getdate();
select @d as �����������_�����;
exec calculate_number_of_tickets_sold_for_today;
----------------------------------------------------
----------------------------------------------------
-- b)	a ������� ����������/�����������
----------------------------------------------------
create procedure reduce_percentage_of_ticket_prices_for_specific_flight
    @n int,
    @p smallmoney
as
update ticket set price = price * (1 - @p/100)
where flight_id = @n;
go
----------------------------------------------------
select 
	ticket_id as �����,
	price as ����,
	cashier_id as �����_�������,
	passenger_id as �����_���������,
	flight_id as �����_�����
from ticket;
----------------------------------------------------
exec reduce_percentage_of_ticket_prices_for_specific_flight 1, 10
----------------------------------------------------
----------------------------------------------------
-- c)	a �������� � ��������� �����������
-------------------------------------------------------------------------------------------------
create proc get_total_price_of_sold_tickets_per_specific_month
	@m int,
	@s smallmoney output
as
select @s=sum(price)
from ticket t
inner join flight f
on t.flight_id = f.flight_id
where t.passenger_id is not null
group by month(f.departure_date)
having month(f.departure_date)=@m;
go
----------------------------------------------------
select 
	price as ����,
	passenger_id as �����_���������,
	f.departure_date as ����_�������
from ticket t
inner join flight f
on t.flight_id = f.flight_id
order by f.departure_date;
----------------------------------------------------
declare @res smallmoney
exec get_total_price_of_sold_tickets_per_specific_month 4, @res output
select @res as �����_���������_�������_��_������;
----------------------------------------------------
----------------------------------------------------
-- 2)	�������� �������� ��������� ��� ���������� � 
-- ��������� ������� � ��������, 
-- ����������� ������������� ������������� ������ � 
-- ������������ �������� ������������ ���������� ����� �� ��������� ��� ����� �������
----------------------------------------------------
create proc add_pilot
	@full_name varchar(100),
	@number_of_flights int,
	@admission_group int
as
begin
	INSERT INTO pilot (full_name, number_of_flights, admission_group)
	VALUES  (@full_name, @number_of_flights, @admission_group);
end
----------------------------------------------------
select 
	pilot_id as �����, 
	full_name as ���, 
	number_of_flights as ����������_������,
	admission_group as ������_�������
from pilot
order by full_name;
----------------------------------------------------
exec add_pilot 
	@full_name = '�������� ���� ��������', 
	@number_of_flights = 55, 
	@admission_group = 1;
----------------------------------------------------
----------------------------------------------------
-- 6) c������� �������
----------------------------------------------------
-- a)	������������ ��������� �������� (��� ������� Scalar)
----------------------------------------------------
create function get_total_price_of_sold_tickets_per_specific_month_function(@m int)
returns smallmoney
as
begin
	declare @s smallmoney;

	select @s=sum(price)
	from ticket t
	inner join flight f
	on t.flight_id = f.flight_id
	group by month(f.departure_date)
	having month(f.departure_date)=@m;

	return @s
end
go
----------------------------------------------------
declare @s int;
set @s = dbo.get_total_price_of_sold_tickets_per_specific_month_function(4);
select @s as �����_���������_�������_��_������;
----------------------------------------------------
----------------------------------------------------
-- b)	������������ ����� ������ Table (��� ������� Inline)
----------------------------------------------------
create function get_aircrafts_with_max_number_of_seats()
returns table
as
return (select top 5 
	aircraft_id, 
	m.model_name, 
	number_of_seats, 
	admission_group, 
	fuel, 
	run_length, 
	takeoff_weight, 
	height, 
	speed
from aircraft a
inner join model m 
on a.model_name = m.model_name
order by number_of_seats desc);
----------------------------------------------------
select 
	model_name, 
	number_of_seats 
from model
order by number_of_seats desc;
----------------------------------------------------
select 
	aircraft_id, 
	model_name, 
	number_of_seats 
from get_aircrafts_with_max_number_of_seats();
----------------------------------------------------
----------------------------------------------------
-- c)	���������������� �������, ������������ ������� (��� ������� Multi-statement)
----------------------------------------------------
create function find_aircraft(@m varchar(100))
returns @t table (
			aircraft_id_ int, 
			model_name_ varchar(100), 
			number_of_seats_ int, 
			admission_seats_ int, 
			fuel_ varchar(100), 
			run_length_ int, 
			takeoff_weight_ int, 
			height_ int, 
			speed_ int)
as
begin
	declare @temp varchar(100);
	set @temp = @m + '%';

	insert into @t (
		aircraft_id_, 
		model_name_, 
		number_of_seats_, 
		admission_seats_, 
		fuel_, 
		run_length_, 
		takeoff_weight_, 
		height_, 
		speed_)
	select 
		aircraft_id, 
		m.model_name, 
		number_of_seats, 
		admission_group, 
		fuel, 
		run_length, 
		takeoff_weight, 
		height, 
		speed
	from aircraft a
	inner join model m 
	on a.model_name = m.model_name
	where m.model_name LIKE @temp
	
	return;
end
go
----------------------------------------------------
select
	aircraft_id_ as �����, 
	model_name_ as ������,
	number_of_seats_ as ����������_����������_����,
	admission_seats_ as ������_�������,
	fuel_ as �������,
	run_length_ as �����_�������,
	takeoff_weight_ as �������_�����,
	height_ as ������,
	speed_ as ��������
from find_aircraft('Boeing');
----------------------------------------------------
----------------------------------------------------
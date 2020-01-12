use airport_db;
go
----------------------------------------------------
----------------------------------------------------
-- 1)	cоздайте хранимые процедуры
----------------------------------------------------
-- a)	без параметров, с использованием агрегатных функций
----------------------------------------------------
-- процедура выводит количество сегодняшних рейсов
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
-- процедура считает количество проданных на сегодня билетов
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
	    
	select count(*) as количество_проданных_на_сегодня_билетов
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
select @d as сегодняшнее_число;
exec calculate_number_of_tickets_sold_for_today;
----------------------------------------------------
----------------------------------------------------
-- b)	a входным параметром/параметрами
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
	ticket_id as номер,
	price as цена,
	cashier_id as номер_кассира,
	passenger_id as номер_пассажира,
	flight_id as номер_полёта
from ticket;
----------------------------------------------------
exec reduce_percentage_of_ticket_prices_for_specific_flight 1, 10
----------------------------------------------------
----------------------------------------------------
-- c)	a входными и выходными параметрами
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
	price as цена,
	passenger_id as номер_пассажира,
	f.departure_date as дата_отбытия
from ticket t
inner join flight f
on t.flight_id = f.flight_id
order by f.departure_date;
----------------------------------------------------
declare @res smallmoney
exec get_total_price_of_sold_tickets_per_specific_month 4, @res output
select @res as сумма_проданных_билетов_за_апрель;
----------------------------------------------------
----------------------------------------------------
-- 2)	создайте хранимые процедуры для добавления и 
-- изменения записей в таблицах, 
-- проверяющих существование редактируемой записи и 
-- определяющие значение суррогатного первичного ключа по умолчанию для новых записей
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
	pilot_id as номер, 
	full_name as ФИО, 
	number_of_flights as количество_полётов,
	admission_group as группа_допуска
from pilot
order by full_name;
----------------------------------------------------
exec add_pilot 
	@full_name = 'Михайлов Семён Иванович', 
	@number_of_flights = 55, 
	@admission_group = 1;
----------------------------------------------------
----------------------------------------------------
-- 6) cоздайте функцию
----------------------------------------------------
-- a)	возвращающую скалярное значение (тип функции Scalar)
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
select @s as сумма_проданных_билетов_за_апрель;
----------------------------------------------------
----------------------------------------------------
-- b)	возвращающую набор данных Table (тип функции Inline)
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
-- c)	многооператорную функцию, возвращающую таблицу (тип функции Multi-statement)
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
	aircraft_id_ as номер, 
	model_name_ as модель,
	number_of_seats_ as количество_посадочных_мест,
	admission_seats_ as группа_допуска,
	fuel_ as топливо,
	run_length_ as длина_разбега,
	takeoff_weight_ as взлётная_масса,
	height_ as высота,
	speed_ as скорость
from find_aircraft('Boeing');
----------------------------------------------------
----------------------------------------------------
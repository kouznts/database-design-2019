use airport_db;

-- выдать расписание аэропорта на определённую дату:
select * from flight
where departure_date between '26/04/2019 00:00:00' and '26/04/2019 23:59:59';

-- выдать список самолетов, имеющих более 200 посадочных мест:
select 
	c.aircraft_id, 
	c.model_name, 
	m.number_of_seats
from aircraft c
inner join model m 
on c.model_name = m.model_name
where number_of_seats > 200;

-- в связи c участившимися террористическими актами 
-- для охранных служб аэропорта создаётся запрос на выборку, 
-- в котором отражается информация о том, 
-- сколько и кому каждый cashier продал билетов, 
-- на какой flight:
select 
	c.full_name AS cashier, 
	p.full_name AS passenger, 
	t.flight_id
from ticket t
inner join cashier c 
on t.cashier_id = c.cashier_id
inner join passenger p 
on t.passenger_id = p.passenger_id
order by c.full_name, t.passenger_id;

-- выдать информацию об экипаже, назначенном на определённый рейс:
select 
	f.flight_id as flight, 
	f.aircrew_id as aircrew, 
	a.admission_group,
	p.full_name as pilot,
	p.admission_group as pilot_admission_group,
	c.full_name as copilot,
	c.admission_group as copilot_admission_group
from flight f
inner join aircrew a 
on f.aircrew_id = a.aircrew_id
inner join pilot p
on a.pilot_id = p.pilot_id
inner join copilot c
on a.copilot_id = c.copilot_id;

-- выдать список самолетов, совершивших полёты в определённый день:
select 
	р.aircraft_id, 
	c.model_name,  
	р.departure_date 
from flight р
inner join aircraft c 
on р.aircraft_id = c.aircraft_id
where р.departure_date between '26/04/2019 00:00:00' and '26/04/2019 23:59:59';

-- выдать список всех направлений, по которым осуществляются авиаперевозки:
select destination 
from flight;

-- расписание для информационного табло аэропорта:
select 
	flight_id, 
	destination, 
	departure_date, 
	arrival_date 
from flight
where departure_date between '26/04/2019 00:00:00' and '26/04/2019 23:59:59';

-- для обслуживания самолёта:
select 
	c.aircraft_id, 
	m.model_name, 
	m.fuel, 
	m.run_length, 
	m.takeoff_weight, 
	m.number_of_seats 
from aircraft c
inner join model m 
on c.model_name = m.model_name;

-- для службы безопасности:
select flight_id, COUNT(*) as количество_купленных_билетов
from ticket
where passenger_id = 1
group by flight_id;

-- вывести список моделей самолетов и их вместимость в порядке убывания вместимости:
select 
	a.aircraft_id, 
	m.model_name, 
	m.number_of_seats 
from aircraft a
inner join model m 
on a.model_name = m.model_name
order by number_of_seats desc;

-- вывести фамилии пилотов, у которых количество вылетов больше 50 и упорядочить по фамилии:
select 
	full_name, 
	number_of_flights
from pilot
where number_of_flights > 50
order by full_name;

-- вывести все имеющиеся самолёты марки 'Boeing':
select 
	m.model_name, 
	a.aircraft_id
from aircraft a
inner join model m 
on a.model_name = m.model_name
where m.model_name LIKE 'Boeing%';

-- вывести модели самолетов, назначенные на рейсы:
select 
	р.flight_id, 
	c.model_name
from flight р
inner join aircraft c
on р.aircraft_id = c.aircraft_id;

-- вывести пофамильный состав всех экипажей:
select * from aircrew;

select 
	aircraft_id as номер, 
	model_name as модель 
from aircraft;

select 
	cashier_id as номер, 
	full_name as ФИО 
from cashier;

select 
	aircrew_id as номер, 
	admission_group as группа_допуска 
from aircrew;

select 
	pilot_id as номер, 
	full_name as ФИО, 
	number_of_flights as количество_полётов,
	admission_group as группа_допуска
from pilot
order by full_name;

select 
	flight_id as номер,
	aircrew_id as номер_экипажа,
	destination as место_назначения,
	departure_date as время_отбытия,
	arrival_date as время_прибытия,
	aircraft_id as номер_самолёта
from flight;

select
	model_name as модель,
	admission_group as группа_допуска,
	fuel as топливо,
	run_length as длина_раз,
	takeoff_weight as взлётная_масса,
	height as потолок,
	number_of_seats as количество_посадочных_мест,
	speed as скорость
from model;

select 
	passenger_id as номер,
	full_name as ФИО
from passenger;

select 
	ticket_id as номер,
	price as цена,
	cashier_id as номер_кассира,
	passenger_id as номер_пассажира,
	flight_id as номер_полёта
from ticket;
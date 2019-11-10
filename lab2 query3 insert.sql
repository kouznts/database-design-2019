use airport_db;

insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
insert into aircrew (admission_group) values (1);
select * from aircrew;

insert into pilot (full_name, admission_group, number_of_flights)  
values ('Данилов Карл Кимович', 1, 55);
insert into pilot (full_name, admission_group, number_of_flights)  
values ('Шилов Ермак Геннадьевич', 1, 173);
insert into pilot (full_name, admission_group, number_of_flights)  
values ('Федотов Людвиг Георгиевич', 1, 28);
insert into pilot (full_name, admission_group, number_of_flights)  
values ('Воронов Герасим Тимурович', 1, 66);
insert into pilot (full_name, admission_group, number_of_flights)  
values ('Мартынов Казимир Мэлорович', 1, 93);
select * from pilot;

insert into copilot (full_name, admission_group, number_of_flights)  
values ('Захаров Натан Михайлович', 1, 112);
insert into copilot (full_name, admission_group, number_of_flights)  
values ('Шубин Венедикт Фролович', 1, 168);
insert into copilot (full_name, admission_group, number_of_flights)  
values ('Гуляев Соломон Андреевич', 1, 113);
insert into copilot (full_name, admission_group, number_of_flights)  
values ('Николаев Марк Адольфович', 1, 118);
insert into copilot (full_name, admission_group, number_of_flights)  
values ('Нестеров Ефрем Юлианович', 1, 190);
insert into copilot (full_name, admission_group, number_of_flights)  
values ('Иванков Юстиниан Андреевич', 1, 134);
select * from copilot;

insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Airbus A320neo', 2, 'авиационный керосин', 2000, 78000, 11900, 830, 236);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Airbus A330-900neo', 1, 'авиационный керосин', 2000, 251000, 11900, 830, 287);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Boeing 737 MAX 7', 2, 'авиационный керосин', 2000, 80290, 12000, 840, 230);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Boeing 777-8', 1, 'авиационный керосин', 2000, 351500, 13000, 900, 211);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Иркут МС-21', 2, 'авиационный керосин', 2000, 87230, 13000, 870, 88);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Mitsubishi Regional Jet', 2, 'авиационный керосин', 2000, 42800, 11000, 830, 88);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Airbus A220-100', 2, 'авиационный керосин', 2000, 58150, 12500, 870, 190);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Comac C919', 2, 'авиационный керосин', 2000, 20400, 12100, 870, 250);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Boeing 767-200', 1, 'авиационный керосин', 2000, 179170, 13100, 850, 224);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Bombardier CRJ-100/200', 2, 'авиационный керосин', 2000, 24040, 12500, 790, 50);
insert into model (model_name, admission_group, fuel, run_length, takeoff_weight, height, speed, number_of_seats)  
values ('Ил-114', 2, 'авиационный керосин', 2000, 23500, 7600, 500, 64);
select * from model;

insert into aircraft (model_name) values ('Airbus A320neo');
insert into aircraft (model_name) values ('Airbus A330-900neo');
insert into aircraft (model_name) values ('Boeing 737 MAX 7');
insert into aircraft (model_name) values ('Boeing 777-8');
insert into aircraft (model_name) values ('Иркут МС-21');
insert into aircraft (model_name) values ('Mitsubishi Regional Jet');
insert into aircraft (model_name) values ('Airbus A220-100');
insert into aircraft (model_name) values ('Comac C919');
insert into aircraft (model_name) values ('Boeing 767-200');
insert into aircraft (model_name) values ('Bombardier CRJ-100/200');
insert into aircraft (model_name) values ('Ил-114');
select * from aircraft;

insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Олонец', '03.05.19 15:20', '04.05.19 04:51', 1, 1);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Сегежа', '22.04.19 18:20', '23.04.19 19:30', 2, 2);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Кандалакша', '06.05.19 19:17', '07.05.19 14:47', 3, 3);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Стерлитамак', '19.04.19 1:23', '20.04.19 18:51', 4, 4);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Фокино', '02.05.19 15:12', '03.05.19 5:11', 5, 5);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Таштагол', '24.04.19 8:13', '25.04.19 11:32', 6, 6);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Дигора', '22.04.19 16:10', '23.04.19 18:19', 7, 7);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Курильск', '05.05.19 14:50', '06.05.19 18:12', 8, 8);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Беломорск', '08.04.19 12:35', '09.04.19 0:34', 9, 9);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Лиски', '06.05.19 6:00', '07.05.19 21:52', 1, 1);
insert into flight (destination, departure_date, arrival_date, aircraft_id, aircrew_id) 
values ('Дрезна', '26.04.19 19:09', '27.04.19 9:00', 2, 2);
select * from flight;

insert into passenger (full_name) values ('Хохлов Велор Максимович');
insert into passenger (full_name) values ('Александров Егор Евсеевич');
insert into passenger (full_name) values ('Мельников Наум Улебович');
insert into passenger (full_name) values ('Александров Федор Геласьевич');
insert into passenger (full_name) values ('Зайцев Мечеслав Донатович');
insert into passenger (full_name) values ('Новиков Лука Всеволодович');
insert into passenger (full_name) values ('Иванков Бенедикт Константинович');
insert into passenger (full_name) values ('Чернов Витольд Тихонович');
insert into passenger (full_name) values ('Иванов Августин Феликсович');
insert into passenger (full_name) values ('Белоусов Руслан Давидович');
insert into passenger (full_name) values ('Дорофеев Родион Рудольфович');
select * from passenger;

insert into cashier (full_name) values ('Бобров Иосиф Протасьевич');
insert into cashier (full_name) values ('Силин Трофим Антонович');
insert into cashier (full_name) values ('Потапов Святослав Никитевич');
insert into cashier (full_name) values ('Трофимов Ермолай Тарасович');
insert into cashier (full_name) values ('Веселов Виктор Юлианович');
insert into cashier (full_name) values ('Силин Касьян Натанович');
insert into cashier (full_name) values ('Быков Михаил Ростиславович');
insert into cashier (full_name) values ('Баранов Эрнест Яковович');
insert into cashier (full_name) values ('Тимофеев Ефим Владиславович');
insert into cashier (full_name) values ('Павлов Корней Лукьевич');
insert into cashier (full_name) values ('Белоусов Герасим Мэлсович');
select * from cashier;

insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (1, 3093, 1, 1);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (2, 4648, 2, 2);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (3, 3668, 3, 3);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (4, 4522, 4, 4);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (5, 4351, 5, 5);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (6, 3101, 6, 6);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (7, 4235, 7, 7);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (8, 4090, 8, 8);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (9, 3722, 9, 9);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (1, 4723, 1, 1);
insert into ticket (flight_id, price, passenger_id, cashier_id) 
values (2, 3963, 2, 2);
insert into ticket (flight_id, price, passenger_id, cashier_id)
values (3, 3722, 3, 3);
insert into ticket (flight_id, price, passenger_id, cashier_id)
values (4, 3722, 4, 4);
select * from ticket;
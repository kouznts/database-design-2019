-- Создадим нового пользователя new_user и предоставим ему привилегии на выборку информации 
-- из ранее созданных представлений и запуска ранее созданных процедур:
create login new_user
with password = 'password';  
go
create user new_user
for login new_user;  
go
grant select 
on object::dbo.aircrews 
to new_user;
go
grant select 
on object::dbo.info_table 
to new_user;
go
grant select 
on object::dbo.pilot 
to new_user;
go
grant execute
on object::dbo.add_pilot 
to new_user;
go
grant execute
on object::dbo.calculate_number_of_tickets_sold_for_today
to new_user;
go
grant execute
on object::dbo.get_aircrafts_with_cursor
to new_user;
go
grant execute
on object::dbo.get_today_flights
to new_user;
go
grant execute
on object::dbo.get_total_price_of_sold_tickets_per_specific_month
to new_user;
go
grant execute
on object::dbo.reduce_percentage_of_ticket_prices_for_specific_flight
to new_user;
go

-- Соединимся с СУБД от имени нового пользователя 
-- и проверим возможность доступа к данным. 
-- Выполним запрос на выборку из представления aircrews:
select * from aircrews;

-- Проверим невозможность доступа к данным через таблицу copilot, 
-- к которой новому пользователю не был предоставлен доступ:
select * from copilot;

-- Соединимся с СУБД от своего имени и предоставим новому пользователю привилегии 
-- на выборку, вставку, изменение и удаление данных из таблиц:
grant all
on object::dbo.pilot 
to new_user;
go

-- Соединимся с СУБД от имени нового пользователя 
-- и проверим возможность изменения данных в таблицах 
-- — для этого вставим новую строку в таблицу pilot 
-- и выполним выборку из этой таблицы:
insert into pilot (full_name, admission_group, number_of_flights)
values ('Гурьев Пётр Петрович', 3, 22);
select * from pilot;

-- Соединимся с СУБД от своего имени 
-- и отберём у нового пользователя все предоставленные ему привилегии:
revoke all
on object::dbo.pilot 
to new_user;
go

-- Соединимся с СУБД от имени нового пользователя 
-- и проверим невозможность изменения данных в созданных таблицах 
-- — для это выполним выборку из таблицы pilot:
select * from pilot;

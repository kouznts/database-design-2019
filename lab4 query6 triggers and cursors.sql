-- Создадим триггер, срабатывающий при добавлении экипажа; 
-- особенностями этого триггера откатывание транзакции при добавлении экипажа со вторым пилотом, 
-- но без командира, при не соответствии группы допуска пилоты и экипажа и при не соответствии группы допуска второго пилота и экипажа:
create trigger inserting_aircrew
on aircrew
for insert
as
declare 
	@p_id	smallint,
	@c_id	smallint,
	@p_ag	tinyint,
	@c_ag	tinyint,
	@a_ag	tinyintp
select 
	@a_ag	= admission_group,
	@p_id	= pilot_id,
	@c_id	= copilot_id
from inserted;
if (@p_id is null)
begin
	if (@c_id is null)
	begin
		return;
	end
	else
	begin
		print 'ошибка: вы не можете добавить ЭКИПАЖ со ВТОРЫМ ПИЛОТОМ без КОМАНДИРА';
		rollback transaction;
	end
end
select @p_ag = admission_group
from pilot
where pilot_id = @p_id;
if (@p_ag > @a_ag)
begin
	print 'ошибка: группа допуска ПИЛОТА должна соответствовать группе допуска его ЭКИПАЖА';
	rollback transaction;
end
select @c_ag = admission_group
from copilot
where copilot_id = @c_id;
if (@c_ag > @a_ag)
begin
	print 'ошибка: группа допуска ВТОРОГО ПИЛОТА должна соответствовать группе допуска его ЭКИПАЖА';
	rollback transaction;
end
go

-- Добавим экипаж с группой допуска 2 и с пилотом под номером 9:
insert into aircrew (admission_group, pilot_id) 
values(2, 9);

-- Добавим экипаж с группой допуска 1 и с вторым пилотом под номером 6:
insert into aircrew (admission_group, copilot_id) 
values(1, 6);

-- Добавим экипаж с группой допуска 1 с пилотом под номером 1 и со вторым пилотом под номером 6:
insert into aircrew (admission_group, pilot_id, copilot_id) 
values(1, 1, 6)

-- Добавим экипаж с группой допуска 2 с пилотом под номером 1 и со вторым пилотом под номером 1:
insert into aircrew (admission_group, pilot_id, copilot_id) 
values(2, 1, 1);

-- триггер, запрещающий изменение группы допуска у экипажа:
create trigger updating_aircrew
on aircrew
for update
as
if (update(admission_group))
begin
	print 'ошибка: нельзя изменить группу допуска ЭКИПАЖА';
	rollback transaction;
end
go

-- Изменим экипаж под номером 4, установим ему группа допуска 4:
update aircrew 
set admission_group = 4 
where aircrew_id = 4;

-- Теперь изменим триггер и изменим тот же экипаж:
alter trigger updating_aircrew
on aircrew
for update
as
print 'изменённый триггер';
go
update aircrew 
set admission_group = 4 
where aircrew_id = 4;

-- Создадим последовательность для отношения «История»:
create sequence seq_for_history
start with 1
increment by 1
go
select current_value as текушее_значение
from sys.sequences  
where name = 'seq_for_history';

-- Создадим триггер вставки для ведения аудита изменения записей в таблицах, 
-- определяющий значение суррогатного первичного ключа по умолчанию с помощью созданной ранее последовательности:
create trigger history_insert_trigger_for_pilot
on pilot
after insert, update
as
insert into history (id, operation)
select 
	(next value for seq_for_history),
	'добавлен пилот ' + full_name
from inserted
go

-- Добавим пилота Григорьева Павла Михайловича с группой допуска 1 и количеством вылетом 90:
insert into pilot (full_name, admission_group, number_of_flights)
values ('Григорьев Павел Михайлович', 1, 90);

-- Создадим триггер удаления для ведения аудита изменения записей в таблицах, 
-- определяющий значение суррогатного первичного ключа по умолчанию с помощью созданной ранее последовательности:
create trigger history_delete_trigger_for_pilot
on pilot
after delete, update
as
insert into history (id, operation)
select 
	(next value for seq_for_history),
	'удалён пилот ' + full_name
from deleted
go

-- Удалим пилота под номером 10:
delete from pilot
where pilot_id = 10;

-- Внесём такие изменения в триггер inserting_aircrew, 
-- чтобы пользователь не мог добавлять записи с дублирующими названиями:
alter trigger inserting_aircrew
on aircrew
for insert
as
declare 
	@p_id	smallint,	
	@c_id	smallint,
	@p_ag	tinyint,
	@c_ag	tinyint,
	@a_ag	tinyint
select 
	@a_ag	= admission_group,
	@p_id	= pilot_id,
	@c_id	= copilot_id
from inserted;
if (@p_id is null)
begin
	if (@c_id is null)
	begin
		return;
	end
	else
	begin
		print 'ошибка: вы не можете добавить ЭКИПАЖ со ВТОРЫМ ПИЛОТОМ без КОМАНДИРА';
		rollback transaction;
	end
end
select @p_ag = admission_group
from pilot
where pilot_id = @p_id;
if (@p_ag > @a_ag)
begin
	print 'ошибка: группа допуска ПИЛОТА должна соответствовать группе допуска его ЭКИПАЖА';
	rollback transaction;
end
select @c_ag = admission_group
from copilot
where copilot_id = @c_id;
if (@c_ag > @a_ag)
begin
	print 'ошибка: группа допуска ВТОРОГО ПИЛОТА должна соответствовать группе допуска его ЭКИПАЖА';
	rollback transaction;
end
if (exists(
		select 
			aircrew_id, 
			pilot_id
		from aircrew
		where pilot_id = 1))
begin
	print 'ошибка: ПИЛОТ уже назначен на ЭКИПАЖ';
	rollback transaction;
end
go

-- Добавим экипажа с пилотом, уже состоящем другом в экипаже:
insert into aircrew(admission_group, pilot_id)
values(1, 1);

-- Внесём такие изменения в триггер updating_aircrew, 
-- чтобы пользователь не мог добавлять записи с дублирующими названиями:
create trigger updating_aircrew
on aircrew
for update
as
if (update(admission_group))
begin
	print 'ошибка: нельзя изменить группу допуска ЭКИПАЖА';
	rollback transaction;
end
declare @p_id_from_inserted smallint; -- pilot's id	
select 
	@p_id_from_inserted	= pilot_id
from inserted;
if (@p_id_from_inserted is not null)
begin
	if ((select count(*)
		from aircrew
		where pilot_id = @p_id_from_inserted) > 1)
	begin
		print 'ошибка: ПИЛОТ уже назначен на ЭКИПАЖ';
		rollback transaction;
	end
end
go

-- Изменим экипаж под номером 2, назначив пилота под номером 1:
update aircrew 
set pilot_id = 1
where aircrew_id = 2;

-- Создадим представление «Экипажи»:
create view aircrews
as
select 
	a.aircrew_id, 
	a.admission_group as aircrew_ag,
	p.pilot_id,
	p.full_name as pilot,
	p.admission_group as pilot_ag,
	c.copilot_id,
	c.full_name as copilot,
	c.admission_group as copilot_ag
from aircrew a
left outer join pilot p
on a.pilot_id = p.pilot_id
left outer join copilot c
on a.copilot_id = c.copilot_id
go

-- Создадим триггер для этого не обновляемого представления, 
-- позволяющий изменять данные:
alter trigger updating_aircrews
on aircrews
instead of update
as
declare 
	@a_id smallint,
	@p_id smallint,
	@c_id smallint;
select 
	@a_id = aircrew_id,
	@p_id = pilot_id,
	@c_id = copilot_id
from inserted;
if (@p_id is not null)
begin
	update aircrew
	set pilot_id = @p_id
	where aircrew_id = @a_id;
end
if (@c_id is not null)
begin
	update aircrew
	set copilot_id = @c_id
	where aircrew_id = @a_id;
end
go

-- Добавим в это представление экипаж под номер 11 со вторым пилотом под номером 3:
update aircrews
set copilot_id = 3
where aircrew_id = 11;

-- Создадим курсор для вывода записей из таблицы удовлетворяющих заданному условию и 
-- выведем с помощью него фамилии пилотов, у которых количество вылетов больше 50:
print 'список пилотов, у которых кол-во вылетов больше 50';
declare pilot_cur cursor local
for	
	select
		pilot_id, 
		full_name, 
		admission_group, 
		number_of_flights
	from pilot	
	where number_of_flights > 50
	order by full_name;
open pilot_cur
declare	@p_id smallint,
	@fn varchar(100),
	@ag tinyint,
	@nof smallint,
	@buf varchar(200); 
fetch next
from pilot_cur
into
	@p_id,
	@fn,
	@ag,
	@nof;
while (@@fetch_status = 0) begin
	select @buf =
		'номер '		+ cast(@p_id	as varchar(10)) 	+
		' ФИО '		+ @fn					+
		' группа допуска '	+ cast(@ag		as varchar(10)) 	+
		' кол-во вылетов '	+ cast(@nof		as varchar(10));
	print @buf;
	fetch next
	from pilot_cur
	into
		@p_id,
		@fn,
		@ag,
		@nof
end
close pilot_cur;
deallocate pilot_cur;
go

-- Создадим процедуру, использующую курсор как выходной параметр, 
-- и с помощью полученного курсора выведем список всех моделей самолётов аэропорта:
create proc get_aircrafts_with_cursor @cur_ cursor varying output
as
set @cur_ =
	cursor forward_only static 
	for 
		select
			model_name, 
			aircraft_id
		from aircraft
open @cur_
go
declare @aircrafts_cur cursor;
exec get_aircrafts_with_cursor @aircrafts_cur output;
declare
	@mn varchar(100),
	@a_id smallint,
	@buf varchar(200);
fetch next 
from @aircrafts_cur
into
	@mn,
	@a_id;
while (@@fetch_status = 0)
begin
	select @buf =
		'модель ' + @mn +
		' номер ' + cast(@a_id	as varchar(10));
	print @buf;
	fetch next 
	from @aircrafts_cur
	into
		@mn,
		@a_id;
end
close @aircrafts_cur;
deallocate @aircrafts_cur;

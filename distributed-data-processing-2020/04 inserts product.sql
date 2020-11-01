use ws1db;

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Наринэ детский 3,2% 0,2л Лелея',
3.2,
36
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Творог детский 50 г Лелея',
10,
32
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Йогурт овсяный с персиком Здоровое меню 0,33л',
4,
58
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Овсяный БИО-Кисель Яблочный 0,33л',
3,
50
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Йогурт овсяный со вкусом клубничного мороженого',
4,
58
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Напиток б/а из раст.сырья Молоко овсяное – Здоровое меню 1л',
2,
126
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Напиток б/а из раст.сырья Молоко рисовое – Здоровое меню 1л',
1,
126
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Напиток б/а из раст.сырья Молоко соевое – Здоровое меню 1л',
1,
126
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Напиток б/а из раст.сырья на рисовой основе Кокос Green Milk 0,75л',
1,
137
);

insert into product (provider_taxpayer_id, name, fat_percentage, price)
values
(
(SELECT TOP 1 provider_taxpayer_id FROM provider type ORDER BY NEWID()),
'Напиток б/а из раст.сырья на рисовой основе Миндаль Green Milk 0,75л',
1,
152
);
-- CRUD = Create + Read + Update + Delete

-- create == insert
insert into fs.rating values (12, 12, '200m SF', '1:20.83', '1');
insert into fs.judge_x_position values (6, 7, 'Секундометрист');
insert into fs.rating values (13, 4, '100m SF', '0:39.78', '2');

-- read == select
select avg(foot_size)
from fs.inventory join fs.sportsman s on fs.inventory.inventory_id = s.inventory_id
where s.sex = 'W';

select full_name
from fs.rating join fs.sportsman s on s.sportsman_id = fs.rating.sportsman_id
where place = 'DSQ';

select t.full_name, t.category
from fs.rating join fs.sportsman s on s.sportsman_id = fs.rating.sportsman_id
join fs.trainer t on t.trainer_id = s.trainer_id
where place = '1';

select full_name, foot_size
from fs.inventory join fs.sportsman s on fs.inventory.inventory_id = s.inventory_id
where fs.inventory.bifins is not null and fs.inventory.monofin is not null;

-- update
update fs.sportsman
set sports_category = '1'
where sports_category = 'КМС' and category_expire <= current_date;

update fs.inventory
set race_suit = null
where race_suit like 'Diana%';

-- delete
delete from fs.rating
where place = 'DNS';
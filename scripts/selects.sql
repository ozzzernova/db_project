-- спортсмены, которые принимали участие хотя бы в одном соревновании успешно и хотя бы раз были призером
select full_name, count(place) as competitions
from fs.rating as r join fs.sportsman as s on r.sportsman_id = s.sportsman_id
where place != 'DNS' and place != 'DSQ'
group by full_name
having min(cast(place as int)) <= 3;

-- список тренеров, у которых тренируется как минимум один мастер спорта и выше
select t.full_name, count(s.sportsman_id) as ms
from fs.sportsman s join fs.trainer t on s.trainer_id = t.trainer_id
join fs.categories c on c.sports_category = s.sports_category
where c.ind <= 3
group by s.trainer_id, t.full_name
order by ms desc, t.full_name asc;

-- самые часто встречающиеся позиции для каждого судьи
select distinct on (j.judge_id) j.full_name, jp.position, count(jp.position) as amount
from fs.judge_x_position as jp right outer join fs.judge as j on jp.judge_id = j.judge_id
group by j.judge_id, j.full_name, jp.position
order by j.judge_id, amount desc;

-- внутри каждого бассейна проранжировать по разрядам
select full_name, s.sports_category,
       dense_rank() over (partition by sc.sports_center_id order by c.ind asc) as rank, sc.name as pool
from fs.sportsman s join (
    select trainer_id, sports_center_id
    from fs.trainer
) t on s.trainer_id = t.trainer_id
join fs.sports_center sc on t.sports_center_id = sc.sports_center_id
join fs.categories c on s.sports_category = c.sports_category;

-- средний размер ноги пловцов в моноласте по полу
select distinct on (s.sex) s.sex, avg(i.foot_size) over (partition by s.sex) as avg_foot_size
from fs.sportsman s join fs.inventory i on i.inventory_id = s.inventory_id
where i.monofin is not null;

-- разряд, который получит спортсмен после истечения срока действия текущего(если он истечет)
-- (т.е. все, что ниже МС сдвинется на одну строку низ, а мастера сохранятся)
select s.full_name, s.sports_category as current,
       case
           when previous is null then s.sports_category
       else c.previous
       end as after_expiration
from fs.sportsman s left join (
    select *, lead(cat.sports_category, 1, 'without class') over (order by ind) as previous
    from fs.categories cat
    where ind > 3
) c on s.sports_category = c.sports_category
join fs.categories cat on cat.sports_category = s.sports_category
order by cat.ind, full_name;
-- защищенные данные по спортсменам
create or replace view fs.protected_sportsmen as
    select s.sportsman_id, md5(s.full_name) as full_name, s.region, s.sex, s.sports_category
    from fs.sportsman s;

-- защищенные данные по тренерам и количество воспитанников
create or replace view fs.protected_trainers as
    select t.trainer_id, md5(t.full_name) as full_name, t.category, count(s.sportsman_id) as students
    from fs.trainer t left join fs.sportsman s on t.trainer_id = s.trainer_id
    group by t.trainer_id;

-- защищенные данные по судьям и самая частая их позиция на соревнованиях
create or replace view fs.protected_judges as
    select distinct on (j.judge_id) j.judge_id, md5(j.full_name) as full_name, j.category, jxp.position, count(jxp.position) as amount
    from fs.judge j left join fs.judge_x_position jxp on j.judge_id = jxp.judge_id
    group by j.judge_id, jxp.position
    order by j.judge_id, amount desc;

-- сводка по спортсменам
create or replace view fs.sportsman_info as
    select s.full_name, s.sex, s.birth_date, s.sports_category, t.full_name as trainer, s.region, sc.name as pool, i.foot_size
    from fs.sportsman s join fs.trainer t on t.trainer_id = s.trainer_id
    join fs.sports_center sc on t.sports_center_id = sc.sports_center_id
    join fs.inventory i on i.inventory_id = s.inventory_id;

-- сводка по соревнованиям
create or replace view fs.comp_info as
    select c.name as comp_name, sc.name as pool_name, sc.pool_len, c.level, c.event_start_time,
           c.event_end_time, jp.cnt as num_of_judges, r.cnt as participants
    from fs.competition c left join fs.sports_center sc on sc.sports_center_id = c.sports_center_id
    left join (
        select competition_id, count(judge_id) as cnt
        from fs.judge_x_position jxp
        group by jxp.competition_id
    ) jp on c.competition_id = jp.competition_id
    left join (
        select competition_id, count(sportsman_id) as cnt
        from fs.rating r
        group by r.competition_id
    ) r on c.competition_id = r.competition_id;

-- для тренера вывести список воспитанников и место работы
create or replace view fs.trainers_info as
    select t.trainer_id, t.full_name, t.category, sc.name as sports_center,
           count(s.sportsman_id) over (partition by t.trainer_id) as students,
           s.full_name as student_name, s.sports_category as student_category
    from fs.trainer t left join fs.sportsman s on t.trainer_id = s.trainer_id
    left join fs.sports_center sc on t.sports_center_id = sc.sports_center_id;
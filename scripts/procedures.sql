-- список людей, у которых последнее подтверждение разряда было не раньше чем какая-то дата

create or replace function fs.confirmations_from (date_from date)
returns table (full_name varchar, last_confirmation date, sports_category varchar) as
$$
    select full_name, last_confirmation, sports_category
    from fs.sportsman
    where last_confirmation > date_from
    order by full_name asc
$$ language sql;

-- для конкретного человека вывести табличку с дистанциями и соревнованиями, в которых он принимал участие
-- в случае, если такого имени нет - ошибку

create or replace function fs.distances_by (name varchar)
returns table (competition varchar, distance varchar, place varchar) as
$$
    declare
        name_exist  bool;
        sp_id int;
    begin
        select exists(select 1 from fs.sportsman where full_name = name) into name_exist;
        if (name_exist) then
            select (select sportsman_id from fs.sportsman where full_name = name) into sp_id;
            return query
                select c.name as competition, r.distance as distance, r.place as place
                from fs.rating r join fs.competition c on r.competition_id = c.competition_id
                where r.sportsman_id = sp_id;
        else
            raise exception 'Sportsman "%s" is absent in database', name
            using errcode = '02000';
        end if;
    end;
$$ language plpgsql;

-- проверить, что участник соревнований достиг 14 лет при участии
-- в дисциплине ныряния, в противном случае проставить дисквалификацию

create or replace procedure fs.update_place_in_apnoe() as
$$
    begin
        with id_to_update as (
            select s.sportsman_id as id
            from fs.sportsman s join fs.rating r on s.sportsman_id = r.sportsman_id
            join fs.competition c on c.competition_id = r.competition_id
            where extract(year from (c.event_start_time::timestamp - s.birth_date::timestamp)) < 14
            and (r.distance = '50m AP' or r.distance = '100m IM' or r.distance = '400m IM')
            and r.place not like 'DSQ'
        )
        update fs.rating
        set place = 'DSQ'
        from id_to_update
        where sportsman_id = id_to_update.id;
    end;
$$ language plpgsql;

select * from fs.confirmations_from('2022-02-22');
select * from fs.distances_by('Слисева Диана Игоревна');
call fs.update_place_in_apnoe();

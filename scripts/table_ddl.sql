create schema fs; -- finswimming

create table fs.sports_center (
    sports_center_id integer primary key not null,
    name varchar(255) not null,
    address varchar(255) not null,
    pool_len integer check ( pool_len > 0 ) not null,
    num_of_tracks integer check ( num_of_tracks > 0 ) not null
);

create table fs.trainer (
    trainer_id integer primary key not null,
    full_name varchar(255) not null,
    category varchar(30) default '2',
    sports_center_id integer not null,
    foreign key (sports_center_id) references fs.sports_center (sports_center_id)
);

create table fs.competition (
    competition_id integer primary key not null,
    name varchar(255) not null,
    sports_center_id integer not null,
    foreign key (sports_center_id) references fs.sports_center (sports_center_id),
    event_start_time date not null,
    event_end_time date not null,
    level varchar(255),
    electronic_system bool default false
);

create table fs.inventory (
    inventory_id integer primary key not null,
    monofin varchar(50),
    bifins varchar(50),
    foot_size integer not null,
    race_suit varchar(50)
);

create table fs.judge (
    judge_id integer primary key not null,
    full_name varchar(255) not null,
    category varchar(30) default 'б/к'
);

create table fs.judge_x_position (
    competition_id integer references fs.competition (competition_id) not null,
    judge_id integer references fs.judge (judge_id) not null,
    position varchar(50) not null,
    primary key (competition_id, judge_id)
);

create table fs.sportsman (
    sportsman_id integer primary key not null,
    full_name varchar(255) not null,
    inventory_id integer not null,
    foreign key (inventory_id) references fs.inventory (inventory_id),
    trainer_id integer not null,
    foreign key (trainer_id) references fs.trainer (trainer_id),
    sports_category varchar(50) default 'without class',
    category_expire date default current_date,
    last_confirmation date default current_date,
    region varchar(50),
    birth_date date not null,
    sex char not null
);

drop table fs.rating;

create table fs.rating (
    sportsman_id integer not null,
    foreign key (sportsman_id) references fs.sportsman (sportsman_id),
    competition_id integer not null,
    foreign key (competition_id) references fs.competition (competition_id),
    distance varchar(255) not null,
    time timestamp,
    place varchar(10) default 'DNS',
    primary key (sportsman_id, competition_id)
);

-- вспомогательная табличка для разрядов
create table fs.categories (
    sports_category varchar(50),
    ind integer
);
import os
import pytest
from . import execute_sql_to_df
from . import read_sql


@pytest.fixture()
def select_scripts():
    path = os.getenv("SCRIPT_PATH")
    return read_sql(path).split(";")[:-1]


@pytest.fixture()
def select_dfs(select_scripts, sqlalchemy_conn):
    return [execute_sql_to_df(conn=sqlalchemy_conn, sql=script) for script in select_scripts]


def select_1(df):
    assert len(df) == 13
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "sportsman_id",
        "full_name",
        "region",
        "sex",
        "sports_category"
    ]


def select_2(df):
    assert len(df) == 10
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "trainer_id",
        "full_name",
        "category",
        "students"
    ]


def select_3(df):
    assert len(df) == 10
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "judge_id",
        "full_name",
        "category",
        "position",
        "amount"
    ]


def select_4(df):
    assert len(df) == 13
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "full_name",
        "sex",
        "birth_date",
        "sports_category",
        "trainer",
        "region",
        "pool",
        "foot_size"
    ]


def select_5(df):
    assert len(df) == 12
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "comp_name",
        "pool_name",
        "pool_len",
        "level",
        "event_start_time",
        "event_end_time",
        "num_of_judges",
        "participants"
    ]


def select_6(df):
    assert len(df) == 13
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == [
        "trainer_id",
        "full_name",
        "category",
        "sports_center",
        "students",
        "student_name",
        "student_category"
    ]


def test(select_dfs):
    select_1(select_dfs[0])
    select_2(select_dfs[1])
    select_3(select_dfs[2])
    select_4(select_dfs[3])
    select_5(select_dfs[4])
    select_6(select_dfs[5])

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
    assert len(df) == 9
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["full_name", "competitions"]


def select_2(df):
    assert len(df) == 6
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["full_name", "ms"]


def select_3(df):
    assert len(df) == 10
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["full_name", "position", "amount"]


def select_4(df):
    assert len(df) == 13
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["full_name", "sports_category", "rank", "pool"]


def select_5(df):
    assert len(df) == 2
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["sex", "avg_foot_size"]


def select_6(df):
    assert len(df) == 13
    print(df.columns.to_list(), df.dtypes)
    assert df.columns.to_list() == ["full_name", "current", "after_expiration"]


def test(select_dfs):
    select_1(select_dfs[0])
    select_2(select_dfs[1])
    select_3(select_dfs[2])
    select_4(select_dfs[3])
    select_5(select_dfs[4])
    select_6(select_dfs[5])

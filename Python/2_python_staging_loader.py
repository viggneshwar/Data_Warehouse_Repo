#python -m pip install pandas sqlalchemy pymysql
#pip install pandas sqlalchemy
#1.Importing of Necessary Libraries
import pandas as pd
from sqlalchemy import create_engine
import os

#2. Defining necessary variables with values assigned
username = 'we47user'
password = "We47%40123" #rather than @ i am mentioning %40
host = '34.63.107.222'
db = 'stgdb_viggneshwar'

#3. Creating the DB connection using connection url using create_engine function & pymysql is used for providing driver to connect
engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:3306/{db}")

#4. Create a variable to represent the source location of the data.
ds_folder="D:\\Learn\\Inceptez Data Engineering\\DW Project\\dataset\\"

#5. Mapping of the source file with the target table using python dictionary
files = {
    "stg_accounts": "accounts.csv",
    "stg_transactions": "transactions.csv",
    "stg_payments": "payments.csv",
    "stg_creditcard": "creditcard.csv",
    "stg_loans": "loans.csv",
    "stg_cust_profile": "cust.csv",
    "stg_branches": "branches.csv",
    "stg_employees": "employee.csv"
}

#first iteration of for loop will assign table='stg_transactions' , file=folder+'transactions.csv'
for table, file in files.items():
    if os.path.exists(ds_folder+file):
        #print(f"File {file} exists, proceeding to load data into table {table}.")
        #read files from iteration and convert it into dataframe/memorytable
        df = pd.read_csv(ds_folder+file)
        #load the data from df/memorytable to actual db table
        df.to_sql(table, con=engine, index=False, if_exists="replace")
        print(f"{len(df):,} Rows loaded in the table {table}")
    else:
        print(f"File {file} does not exist, skipping table {table}.")

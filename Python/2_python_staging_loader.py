#python -m pip install pandas sqlalchemy pymysql
#pip install pandas sqlalchemy
#1.Importing of Necessary Libraries
import pandas as pd
from sqlalchemy import create_engine

#2. Defining necessary variables with values assigned
username = 'we47user'
password = "We47%40123" #rather than @ i am mentioning %40
host = '34.63.107.222'
db = 'test_w47'

#3. Creating the DB connection using connection url using create_engine function & pymysql is used for providing driver to connect
engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:3306/{db}")

#4. Create a variable to represent the source location of the data.
ds_folder="D:\\Learn\\Inceptez Data Engineering\\DW Project\\dataset\\"

#5. Mapping of the source file with the target table using python dictionary
files = {
    "stg_accounts": ds_folder+"accounts.csv",
    "stg_transactions": ds_folder+"transactions.csv",
    "stg_payments": ds_folder+"payments.csv",
    "stg_creditcard": ds_folder+"creditcard.csv",
    "stg_loans": ds_folder+"loans.csv",
    "stg_cust_profile": ds_folder+"cust.csv",
    "stg_branches": ds_folder+"branches.csv",
    "stg_employees": ds_folder+"employee.csv"
}

#first iteration of for loop will assign table='stg_transactions' , file=folder+'transactions.csv'
for table, file in files.items():
    #read files from iteration and convert it into dataframe/memorytable
    df = pd.read_csv(file)
    #load the data from df/memorytable to actual db table
    df.to_sql(table, con=engine, index=False, if_exists="replace")
    print(f"Rows loaded in the table {table}")

#python -m pip install pandas sqlalchemy pymysql
#pip install pandas sqlalchemy
import pandas as pd
from sqlalchemy import create_engine

username = 'we47user'
password = "We47@123"
host = '34.63.107.222'
db = 'stgdb'

engine = create_engine(f"mysql+pymysql://{username}:{password}@{host}:3306/{db}")
folder="D:\\Learn\\Inceptez Data Engineering\\DW Project\\dataset\\"
files = {
    "stg_accounts": folder+"accounts.csv",
    "stg_transactions": folder+"transactions.csv",
    "stg_payments": folder+"payments.csv",
    "stg_creditcard": folder+"creditcard.csv",
    "stg_loans": folder+"loans.csv",
    "stg_cust_profile": folder+"cust.csv",
    "stg_branches": folder+"branches.csv",
    "stg_employees": folder+"employee.csv"
}

for table, file in files.items():
    df = pd.read_csv(file)
    df.to_sql(table, con=engine, index=False, if_exists="replace")
    print(f"Rows loaded in the table {table}")

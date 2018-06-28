import pandas as pd
from matplotlib import pyplot as plt
from sklearn.utils import shuffle
import datetime
import time

# slave_data = pd.read_csv('AER_2013_1483_data/CalomirisPritchett_data.csv', ';')



def return_data(path):
    slave_data = pd.read_excel(path)
    slave_data["Sales Date"] = pd.to_datetime(slave_data["Sales Date"], errors='coerce')#.apply(lambda x: datetime.datetime.strptime(x, '%m/%d/%Y').date())
    slave_data["Price"] = pd.to_numeric(slave_data["Price"], errors='coerce')
    slave_data["Age"] = pd.to_numeric(slave_data["Age"], errors='coerce')
    slave_data = slave_data.dropna(subset=["Price", "Age", "Sales Date"])
    # print(sum(slave_data["Price"] > 2000))
    slave_data = slave_data.drop(slave_data["Number of Total Slaves"][slave_data["Number of Total Slaves"] > 1].index)
    # slave_data = slave_data.drop(slave_data["Number of Child Slaves"][slave_data["Number of Child Slaves"] > 0].index)
    slave_data["Sellers County of Origin"] = slave_data["Sellers County of Origin"].apply(lambda x: 1 if str(x) in 'New Orleans' else 0)
    slave_data["Buyers County of Origin"] = slave_data["Buyers County of Origin"].apply(lambda x: 1 if str(x) in 'New Orleans' else 0)
    # slave_data = slave_data.drop(slave_data["Sellers County of Origin"][slave_data["Sellers County of Origin"] != 1].index)
    slave_data["Price"] = slave_data["Price"]/(slave_data["Number of Total Slaves"]/slave_data["Number of Prices"])
    # slave_data = slave_data.drop(slave_data["Price"][slave_data["Price"] < 10].index)
    slave_data = slave_data.drop(slave_data["Price"][slave_data["Price"] > 2000].index)
    # slave_data = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'M'].index)

    slave_data["Sex"] = slave_data["Sex"].apply(lambda x: 1 if x is 'M' else 0)
    # slave_data["Sales Date"] = slave_data["Sales Date"].apply(lambda x: 1 if x.month <= 5 or x.month >= 12 else 0)
    # slave_data = slave_data.drop(slave_data["Sales Date"][slave_data["Sales Date"].apply(lambda x: x.date() < datetime.date(1857,6,1))].index)
    slave_data["Sales Date"] = slave_data["Sales Date"].apply(lambda x: (x.year - 1956)*12 + x.month)
    slave_data["Age_Sex"] = slave_data["Age"]*slave_data["Sex"]
    print(slave_data.shape)
    return shuffle(slave_data, random_state=0)


# slave_data = slave_data.drop(slave_data["Age"][slave_data["Age"] > 30].index)
# slave_data = slave_data.drop(slave_data["Age"][slave_data["Age"] < 10].index)



def print_statistic(slave_data):
    # slave_data["Price"].hist()
    # print(slave_data.describe())
    # slave_data1 = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'M'].index)
    # slave_data2 = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'F'].index)
    # plt.plot(slave_data1["Age"], slave_data1["Price"], 'r.')
    # plt.plot(slave_data2["Age"], slave_data2["Price"], 'b.')
    # plt.plot(slave_data["Age"], slave_data["Price"], 'b.')
    plt.plot(slave_data["Sex"], slave_data["Price"], 'b.')
    plt.show()


# print_statistic(return_data('AER_2013_1483_data/CalomirisPritchett_data.xlsx'))
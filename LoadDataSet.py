import pandas as pd
from matplotlib import pyplot as plt
from sklearn.utils import shuffle
import datetime
import time

# slave_data = pd.read_csv('AER_2013_1483_data/CalomirisPritchett_data.csv', ';')



def return_data(path):
    slave_data = pd.read_excel(path)
    slave_data = clear_data_from_errors(slave_data)
    change_form_of_data_for_easier_analise_in_classifier(slave_data)
    add_new_future(slave_data)

    slave_data = clear_data_to_more_general_form(slave_data)

    shuffle(slave_data, random_state=0)
    train_end = int(slave_data.shape[0] * 0.8)
    slave_data_train_test = {"train": slave_data[:train_end], "test": slave_data[train_end:]}
    print(slave_data.shape)
    return slave_data_train_test


def clear_data_to_more_general_form(slave_data):
    slave_data = slave_data.drop(slave_data["Number of Total Slaves"][slave_data["Number of Total Slaves"] > 1].index)
    slave_data = slave_data.drop(slave_data["Price"][slave_data["Price"] > 2000].index)
    # # slave_data = slave_data.drop(slave_data["Number of Child Slaves"][slave_data["Number of Child Slaves"] > 0].index)
    # # slave_data = slave_data.drop(slave_data["Sellers County of Origin"][slave_data["Sellers County of Origin"] != 1].index)
    # slave_data["Price"] = slave_data["Price"] / (slave_data["Number of Total Slaves"] / slave_data["Number of Prices"])
    # slave_data = slave_data.drop(slave_data["Price"][slave_data["Price"] < 10].index)
    # # slave_data = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'M'].index)
    return slave_data


def add_new_future(slave_data):
    slave_data["Age_Sex"] = slave_data["Age"] * slave_data["Sex"]


def change_form_of_data_for_easier_analise_in_classifier(slave_data):
    slave_data["Sex"] = slave_data["Sex"].apply(lambda x: 1 if x is 'M' else 0)
    slave_data["Sales Date"] = slave_data["Sales Date"].apply(lambda x: (x.year - 1956) * 12 + x.month)
    slave_data["Sellers County of Origin"] = slave_data["Sellers County of Origin"].apply(
        lambda x: 1 if str(x) in 'New Orleans' else 0)
    slave_data["Buyers County of Origin"] = slave_data["Buyers County of Origin"].apply(
        lambda x: 1 if str(x) in 'New Orleans' else 0)
    skin_color = []
    for color in slave_data["Color"]:
        color_token = 1
        if str(color).lower() in "negro":
            color_token = 2
        elif str(color).lower() in "mulatto":
            color_token = 3
        elif str(color).lower() in "griff" or str(color).lower() in "light griff":
            color_token = 4
        elif str(color).lower() in "yellow":
            color_token = 5
        skin_color.append(color_token)
    slave_data["Color"] = skin_color
    slave_data["Color"] = slave_data["Color"]*(1-slave_data["Sex"])
    # slave_data["Occupation"] = slave_data["Occupation"].apply(
    #     lambda x: 1 if len(str(x)) > 2 else 0)


def clear_data_from_errors(slave_data):
    slave_data["Sales Date"] = pd.to_datetime(slave_data["Sales Date"], errors='coerce')
    slave_data["Price"] = pd.to_numeric(slave_data["Price"], errors='coerce')
    slave_data["Age"] = pd.to_numeric(slave_data["Age"], errors='coerce')
    slave_data = slave_data.dropna(subset=["Price", "Age", "Sales Date"])
    return slave_data


# slave_data = slave_data.drop(slave_data["Age"][slave_data["Age"] > 30].index)
# slave_data = slave_data.drop(slave_data["Age"][slave_data["Age"] < 10].index)



def print_statistic(slave_data):
    slave_data["Price"].hist()
    # print(slave_data.describe())
    # slave_data1 = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'M'].index)
    # slave_data2 = slave_data.drop(slave_data["Sex"][slave_data["Sex"] == 'F'].index)
    # plt.plot(slave_data1["Age"], slave_data1["Price"], 'r.')
    # plt.plot(slave_data2["Age"], slave_data2["Price"], 'b.')
    # plt.plot(slave_data["Age"], slave_data["Price"], 'b.')
    # plt.plot(slave_data["Sex"], slave_data["Price"], 'b.')
    plt.show()


# print_statistic(return_data('AER_2013_1483_data/CalomirisPritchett_data.xlsx')['train'])


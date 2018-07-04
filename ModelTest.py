import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import PolynomialFeatures
from sklearn.ensemble import RandomForestRegressor
import LoadDataSet

path = 'AER_2013_1483_data/CalomirisPritchett_data.xlsx'
poly_sex = PolynomialFeatures(6)
poly_sax_age = PolynomialFeatures(3)
slave_data_train = LoadDataSet.return_data(path)["train"]
slave_data_test = LoadDataSet.return_data(path)["test"]

Y = slave_data_train['Price']
Y_test = slave_data_test['Price']
# convert to be used further to linear regression
X = np.c_[poly_sex.fit_transform(slave_data_train[['Age']].as_matrix()), poly_sax_age.fit_transform(slave_data_train[['Age_Sex']].as_matrix()),
          slave_data_train[['Sex']].as_matrix(), slave_data_train[['Sales Date']].as_matrix(), slave_data_train[['Buyers County of Origin']].as_matrix(),
          slave_data_train[['Sellers County of Origin']].as_matrix(), slave_data_train[['Color']].as_matrix()]
X_test = np.c_[poly_sex.fit_transform(slave_data_test[['Age']].as_matrix()), poly_sax_age.fit_transform(slave_data_test[['Age_Sex']].as_matrix()),
          slave_data_test[['Sex']].as_matrix(), slave_data_test[['Sales Date']].as_matrix(), slave_data_test[['Buyers County of Origin']].as_matrix(),
          slave_data_test[['Sellers County of Origin']].as_matrix(), slave_data_test[['Color']].as_matrix()]
X_test_plot = slave_data_test[['Age']]

# Create linear regression object
regr = LinearRegression()
# regr = RandomForestRegressor()

# Train the model using the training sets
regr.fit(X, Y)

# Make predictions using the testing set
y_pred = regr.predict(X_test)

# The mean squared error
print("Mean squared error: %.2f"
      % mean_squared_error(Y_test, y_pred))
# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % r2_score(Y_test, y_pred))

print("Mean squared error: %.2f on slave"
      % (mean_squared_error(Y_test, y_pred)/len(Y_test)))

plt.hist((Y_test - y_pred)*(Y_test - y_pred))
plt.xlabel('error')
plt.ylabel('amount')
plt.show()
# Plot outputs
x_max = max(int(X_test_plot.max()), int(X_test_plot.max()))
y_max = max(int(Y_test.max()), int(y_pred.max()))
plt.plot(X_test_plot, Y_test, '.', color='black', label='true')
plt.plot(X_test_plot, y_pred, '.', color='red', label="predict")
plt.legend()
plt.axes([0, x_max, 0, y_max])

plt.show()
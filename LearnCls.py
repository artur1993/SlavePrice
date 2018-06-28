import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

import LoadDataSet

path = 'AER_2013_1483_data/CalomirisPritchett_data.xlsx'

# Load the diabetes dataset
slave_data = LoadDataSet.return_data(path)
train_end = int(slave_data.shape[0]*0.8)\

# pass the order of your polynomial here
poly = PolynomialFeatures(6)
poly2 = PolynomialFeatures(2)

# Use only one feature
# X = slave_data[['Age','Sex']].as_matrix()
X = slave_data[['Age']].as_matrix()
X_test_plot = X[train_end:]

# convert to be used further to linear regression
# diabetes_X = poly.fit_transform(slave_data[['Age']].as_matrix())
diabetes_X = np.c_[poly.fit_transform(slave_data[['Age']].as_matrix()), poly2.fit_transform(slave_data[['Age_Sex']].as_matrix()), slave_data[['Sex']].as_matrix(), poly2.fit_transform(slave_data[['Sales Date']].as_matrix()), slave_data[['Sellers County of Origin']].as_matrix(), slave_data[['Buyers County of Origin']].as_matrix()]
# diabetes_X = np.c_[poly.fit_transform(slave_data[['Age']].as_matrix()), slave_data[['Sales Date']].as_matrix(), slave_data[['Sex']].as_matrix()]
# Split the data into training/testing sets
diabetes_X_train = diabetes_X[:train_end]
diabetes_X_test = diabetes_X[train_end:]

# Split the targets into training/testing sets
diabetes_y_train = slave_data['Price'][:train_end]
diabetes_y_test = slave_data['Price'][train_end:]

# Create linear regression object
regr = LinearRegression()

# Train the model using the training sets
regr.fit(diabetes_X_train, diabetes_y_train)

# Make predictions using the testing set
diabetes_y_pred = regr.predict(diabetes_X_test)

# The coefficients
# print('Coefficients: \n', regr.coef_)
# The mean squared error
print("Mean squared error: %.2f"
      % mean_squared_error(diabetes_y_test, diabetes_y_pred))
# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % r2_score(diabetes_y_test, diabetes_y_pred))

# Plot outputs
plt.scatter(X_test_plot, diabetes_y_test,  color='black')
plt.plot(X_test_plot, diabetes_y_pred,'r.')#, linewidth=3)
plt.xlim()
plt.ylim()

plt.xticks(())
plt.yticks(())

plt.show()
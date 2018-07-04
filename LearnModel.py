import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression, Lasso
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
from sklearn.model_selection import cross_val_score, learning_curve
from sklearn.ensemble import RandomForestRegressor

import LoadDataSet

def plot_learning_curve(model, title, X, y, ylim=None, cv=None,
                        n_jobs=1, train_sizes=np.linspace(.1, 1.0, 5)):
    """
    Generate a simple plot of the test and training learning curve.

    Parameters
    ----------
    model : object type that implements the "fit" and "predict" methods
        An object of that type which is cloned for each validation.

    title : string
        Title for the chart.

    X : array-like, shape (n_samples, n_features)
        Training vector, where n_samples is the number of samples and
        n_features is the number of features.

    y : array-like, shape (n_samples) or (n_samples, n_features), optional
        Target relative to X for classification or regression;
        None for unsupervised learning.

    ylim : tuple, shape (ymin, ymax), optional
        Defines minimum and maximum yvalues plotted.

    cv : int, cross-validation generator or an iterable, optional
        Determines the cross-validation splitting strategy.
        Possible inputs for cv are:
          - None, to use the default 3-fold cross-validation,
          - integer, to specify the number of folds.
          - An object to be used as a cross-validation generator.
          - An iterable yielding train/test splits.

        For integer/None inputs, if ``y`` is binary or multiclass,
        :class:`StratifiedKFold` used. If the estimator is not a classifier
        or if ``y`` is neither binary nor multiclass, :class:`KFold` is used.

        Refer :ref:`User Guide <cross_validation>` for the various
        cross-validators that can be used here.

    n_jobs : integer, optional
        Number of jobs to run in parallel (default 1).
    """
    plt.figure()
    plt.title(title)
    if ylim is not None:
        plt.ylim(*ylim)
    plt.xlabel("Training examples")
    plt.ylabel("error")
    train_sizes, train_scores, test_scores = learning_curve(
        model, X, y, cv=cv, n_jobs=n_jobs, train_sizes=train_sizes, scoring='mean_squared_error')
    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)
    plt.grid()

    plt.fill_between(train_sizes, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.1,
                     color="r")
    plt.fill_between(train_sizes, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
    plt.plot(train_sizes, train_scores_mean, 'o-', color="r",
             label="Training score")
    plt.plot(train_sizes, test_scores_mean, 'o-', color="g",
             label="Cross-validation score")

    plt.legend(loc="best")

    return plt

path = 'AER_2013_1483_data/CalomirisPritchett_data.xlsx'
cross_validation_iteration = 5
# pass the order of your polynomial here

poly_age = PolynomialFeatures(6)
poly_sax_age = PolynomialFeatures(3)

# Load the diabetes dataset
slave_data = LoadDataSet.return_data(path)["train"]
train_end = int(slave_data.shape[0]*0.8)
Y = slave_data['Price']
# convert to be used further to linear regression
# X = poly_age.fit_transform(slave_data[['Age']].as_matrix())
# X = np.c_[poly.fit_transform(slave_data[['Age']].as_matrix()), slave_data[['Sex']].as_matrix()]
X = np.c_[poly_age.fit_transform(slave_data[['Age']].as_matrix()), poly_sax_age.fit_transform(slave_data[['Age_Sex']].as_matrix()),
          slave_data[['Sex']].as_matrix(), slave_data[['Sales Date']].as_matrix(), slave_data[['Buyers County of Origin']].as_matrix(),
          slave_data[['Sellers County of Origin']].as_matrix(), slave_data[['Color']].as_matrix()]
# diabetes_X = np.c_[poly.fit_transform(slave_data[['Age']].as_matrix()), poly2.fit_transform(slave_data[['Age_Sex']].as_matrix()), slave_data[['Sex']].as_matrix(), poly2.fit_transform(slave_data[['Sales Date']].as_matrix()), slave_data[['Sellers County of Origin']].as_matrix(), slave_data[['Buyers County of Origin']].as_matrix()]

# Split the data into train/valid sets
X_train = X[:train_end]
X_valid = X[train_end:]

# Split the targets into train/valid sets

y_train = Y[:train_end]
y_valid = Y[train_end:]

# Create linear regression object
regr = LinearRegression()
# regr = Lasso(alpha=0.5)
# regr = RandomForestRegressor()

# Train the model using the training sets
regr.fit(X_train, y_train)

# Make predictions using the testing set
validation_part = 5
y_pred = regr.predict(X_valid)
mean_squared_error = cross_val_score(regr, X, Y, scoring='mean_squared_error', cv=validation_part)
r2 = cross_val_score(regr, X, Y, scoring='r2', cv=validation_part)
mean_squared_error_on_slave = np.mean(mean_squared_error)/(int(len(Y)/validation_part))

plot_learning_curve(regr, 'learning curve', X, Y)

plt.show()
# The coefficients
# print('Coefficients: \n', regr.coef_)
# The mean squared error
print("Mean squared error: %.2f"
      % np.mean(mean_squared_error))
# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % np.mean(r2))
print("Mean squared error: %.2f"
      % mean_squared_error_on_slave)
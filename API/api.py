from flask import Flask, request

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')

from statsmodels.tsa.arima_model import ARIMA
from pmdarima.arima import auto_arima
from sklearn.metrics import mean_squared_error, mean_absolute_error

from nsepy import get_history
from datetime import date

app = Flask(__name__)


@app.route('/api',methods=['GET'])
def stocks():
    Symbol = str(request.args['Symbol'])
    data = get_history(symbol=Symbol, start=date(2018,1,1), end=date.today()).fillna(0)
    df_close=data["Close"]

    model = auto_arima(df_close.values, start_p=1, start_q=1,
                      test='adf',    # use adftest to find optimal 'd'
                      max_p=5, # maximum p
                      max_q=5, # maximum q
                      m=1, # frequency of series - m = 4, quaterly, m=12 Monthly
                      d=1,  # difference order d
                      seasonal=True, # Seasonal ARIMA, 
                      stepwise=True, with_intercept=False)

    # Forecast
    horizons = 30
    forecasted_values = model.predict(n_periods=30)
    index_forecasted = np.arange(len(df_close.values), len(df_close.values) + horizons)

    # make series for plotting purpose
    forecasted_series = pd.Series(forecasted_values, index=index_forecasted)
           
    return forecasted_series

if __name__ == '__main__':
    app.run()
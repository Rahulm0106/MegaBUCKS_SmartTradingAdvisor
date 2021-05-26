from flask import Flask, request, jsonify, render_template

import numpy as np
import pandas as pd

from pmdarima.arima import auto_arima

from nsepy import get_history
from datetime import date

from sklearn.metrics import mean_squared_error, mean_absolute_error
import math

app = Flask(__name__, template_folder='templates')


@app.route('/api',methods=['GET'])
def stocks():
    Symbol = str(request.args['Symbol'])
    data = get_history(symbol=Symbol, start=date(2019,1,1), end=date.today()).fillna(0)
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
    index_original = np.arange(0, len(df_close.values))

    legend = 'Forecasted Graph'
    labels = index_forecasted.tolist()
    values = forecasted_values.tolist()

    day = index_original.tolist()
    close = df_close.values.tolist()
    name = 'Previous Data'

    return render_template('graph.html', values=values, labels=labels, legend=legend, day=day, close=close, name=name, sym=Symbol)

@app.route('/error',methods=['GET'])
def error():
    Symbol = str(request.args['Symbol'])
    data = get_history(symbol=Symbol, start=date(2019,1,1), end=date.today()).fillna(0)
    df_close=data["Close"]

    train_data, test_data = df_close[1:int(len(df_close)*0.90)], df_close[int(len(df_close)*0.90):]

    model = auto_arima(train_data.values, start_p=1, start_q=1,
                    test='adf',    # use adftest to find optimal 'd'
                    max_p=5, # maximum p
                    max_q=5, # maximum q
                    m=1, # frequency of series - m = 4, quaterly, m=12 Monthly
                    d=1,  # difference order d
                    seasonal=True, # Seasonal ARIMA, 
                    stepwise=True, with_intercept=False)
    # Forecast
    forecasted_values = model.predict(n_periods=len(test_data))

    # Error
    rmse = math.sqrt(mean_squared_error(test_data, forecasted_values))
    mape = np.mean(np.abs(forecasted_values - test_data)/np.abs(test_data))*100

    # Message
    slope=forecasted_values[len(forecasted_values)-1]-forecasted_values[0]
    if(slope>0):
        message = 'The slope of the graph is positive, the stock price will increase in the next 30 days.'
    elif(slope<0):
        message = 'The slope of the graph is negative, the stock price will decrease in the next 30 days.'
    else:
        message = 'The slope of the graph is zero, the stock price will increase or decrease substantially in the next 30 days.'

    return render_template('error.html',rmse=round(rmse, 2), mape=round(mape, 2), sym=Symbol, message=message)

@app.route('/')
def index():
    return "<h1>Enter Stock symbol in URL</h1>"

if __name__ == '__main__':
    app.run(threaded=True, port=5000)

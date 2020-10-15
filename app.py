from flask import Flask, request, jsonify

import numpy as np
import pandas as pd

from pmdarima.arima import auto_arima

from nsepy import get_history
from datetime import date

from collections import Counter 

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
    index_original = np.arange(0, len(df_close.values))

    # make series for plotting purpose
    forecasted_series = pd.Series(forecasted_values, index=index_forecasted)
    original_series = pd.Series(df_close.values, index=index_original)

    r=forecasted_series.to_dict()
    i=original_series.to_dict()
    f=Counter(i)+Counter(r)
           
    return jsonify(f)

if __name__ == '__main__':
    app.run()
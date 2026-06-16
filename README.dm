DATAbility: Explainable Flight Delay Risk Assistant for Airline Operations Controllers

## Team Information

Team Number: 05
Team Name : Team Fox

Team Members:
* [Harshal Hisoriya]
* [Tanay Patel]
* [Yash Thummar]
* [Bhargava Reddy]

---

## Challenge

Challenge Name: DATAbility | Ready for Takeoff

We are tackling the problem of flight delay prediction and decision support for airline operations teams. The goal is not only to predict whether a flight may be delayed, but also to explain why the delay risk exists and recommend what an operations controller can do about it.

---

## Problem

Every day, airline operations teams must decide which flights are at risk of delay and what actions should be taken before the delay spreads through the network.

The biggest operational problem is not only one delayed flight. The real damage happens when one delayed aircraft affects its next leg, then the next leg, and eventually causes missed connections, crew issues, gate conflicts, and network-wide disruption.

Today, operations controllers often rely on scattered dashboards, manual monitoring, and experience-based judgment. Existing tools may show flight status or delay numbers, but they often do not clearly explain the reason behind the risk. A black-box risk score is difficult for an operator to trust and act on.

---

## Customer

Our primary customer is:

**Airline Operations Controller / Duty Controller / OCC Dispatcher**

This user works inside the airline operations control center and makes real-time decisions such as:

* Which flights need close monitoring
* Whether to prepare faster turnaround support
* Whether to alert ground operations
* Whether to check backup aircraft availability
* Whether to prioritize certain flights because of cascade risk
* Whether weather or congestion may affect departure reliability

We are not building this tool for passengers. We are building it for the people responsible for keeping the airline schedule running.

---

## Validated Problem

The provided challenge material identifies flight delays and cancellations as a major operational and financial problem for airlines. It also emphasizes that delays often spread through the aircraft network. A late aircraft can delay the next flight, which can then delay later flights.

The provided dataset also supports this problem because it contains:

* Real scheduled flights
* Aircraft tail numbers
* Departure and arrival delay outcomes
* Weather conditions at the origin airport
* Delay causes
* Cancellation labels

The key insight is that late inbound aircraft, weather pressure, and airport congestion together create operational delay risk. Weather alone is not the full explanation. It often acts as a catalyst that triggers congestion and cascade delays.

---

## Solution

Our solution is an explainable flight delay risk assistant called:

# Turnaround Guardian

Turnaround Guardian predicts whether a flight is likely to be delayed by 15 minutes or more. More importantly, it explains the reason behind the risk and gives a recommended action to the operations controller.

Instead of showing only:

> Delay Risk = 72%

the tool shows:

> High Risk
> Main Reason: Late inbound aircraft
> Evidence: Previous aircraft arrived 38 minutes late, turnaround buffer is short, departure is during a congestion-prone hour
> Recommended Action: Monitor inbound tail, alert gate team, and prepare fast-turnaround support

---

## Value Proposition

Turnaround Guardian helps airline operations teams move from reactive delay management to proactive decision support.

### What makes it valuable?

1. **Explainable risk prediction**
   The tool does not behave like a black-box model. Every flagged flight includes a reason.

2. **Cascade-aware decision support**
   The model uses aircraft tail-number chaining to estimate whether the previous flight can affect the current one.

3. **Weather-aware but not weather-only**
   Weather is treated as an operational pressure signal, not as the only cause of delay.

4. **Actionable recommendations**
   The tool recommends what the controller should do, such as monitoring the inbound aircraft, alerting ground operations, or preparing fast turnaround support.

5. **Built for airline operations, not passengers**
   The interface is designed for a duty controller or OCC dispatcher who needs to make fast operational decisions.

---

## Model Approach

We use an interpretable hybrid approach:

### 1. Logistic Regression Model

The main prediction model is Logistic Regression.

Target variable:

```text
delayed_15
```

This predicts whether a flight will be delayed by 15 minutes or more.

Logistic Regression was selected because:

* It is suitable for binary classification
* It is interpretable
* It is fast to train
* It works well on structured tabular data
* Its coefficients can be inspected
* It avoids the black-box problem

### 2. Rule-Based Explanation Engine

The prediction score is supported by a rule-based explanation engine.

For each flagged flight, the system identifies the main operational driver:

* Cascade / late inbound aircraft
* Weather pressure
* Congestion / schedule pressure
* General operational risk

### 3. Recommended Action Engine

Each reason is mapped to a practical controller action.

Example:

| Main Reason           | Recommended Action                                                     |
| --------------------- | ---------------------------------------------------------------------- |
| Late inbound aircraft | Monitor inbound tail, alert gate team, prepare fast-turnaround support |
| Weather pressure      | Alert ground operations and monitor airport-wide weather impact        |
| Congestion pressure   | Coordinate pushback/gate sequencing and prioritize critical flights    |
| General risk          | Keep flight under monitoring                                           |

---

## Key Features Used

The model uses only pre-flight or operationally derivable information.

### Schedule Features

* Date
* Day of week
* Departure hour
* Origin airport
* Destination airport
* Carrier
* Distance

### Weather Features

* Temperature
* Wind speed
* Wind gust
* Precipitation
* Snowfall
* Cloud cover
* Weather code

### Cascade Features

Built using aircraft `tail_number`:

* Previous flight arrival delay
* Previous flight departure delay
* Previous flight delayed flag
* Turnaround buffer
* Recovery gap
* Whether previous destination matches current origin

### Congestion Features

* Morning bank flag
* Evening bank flag
* Number of flights scheduled from same origin in same hour

---

## Data Leakage Prevention

The following columns are not used as model inputs:

```text
dep_delay_min
arr_delay_min
delayed_15
cancelled
delay_cause
late_aircraft_delay_min
weather_delay_min
```

These columns describe what happened after the flight or provide the answer key. Using them as input would create data leakage and produce misleading results.

The only exception is that previous flight delay values can be used to construct cascade features, because the previous flight has already happened before the current flight departure decision.

---

## Dataset

We use the provided starter dataset:

```text
flights_weather_sample.csv
```

Dataset description:

* 9,197 real scheduled flights
* Airports: Chicago O'Hare and Denver
* Date range: 5 January 2015 to 11 January 2015
* Source: US DOT on-time performance data
* Weather source: Open-Meteo historical weather
* One row per scheduled flight
* Includes schedule, weather, delay outcomes, cancellation labels, and delay causes

---

## Train/Test Split

The data is split chronologically.

* Training data: first 85% of rows
* Test data: last 15% of rows

This is more realistic than a random split because operations teams predict future flights using past data.

---

## Prototype Output

For each flight, the tool outputs:

* Predicted delay probability
* Risk level: Low / Medium / High
* Main reason
* Explanation
* Recommended action
* Actual delay result for validation
* Actual delay cause for comparison

Example output:

```text
Flight: UA123
Route: DEN → ORD
Predicted Delay Risk: High
Probability: 0.76

Main Reason:
Cascade / late inbound aircraft

Explanation:
- Previous aircraft arrival delay was 42 minutes
- Turnaround buffer was only 30 minutes
- Recovery gap was negative
- Departure was during a congestion-prone bank

Recommended Action:
Monitor inbound tail, alert gate team, prepare fast-turnaround support, and check backup aircraft availability.
```

---

## Demo Link

Demo link:

[Add your demo link here]

Examples:

* Streamlit app link
* GitHub Pages link
* Local demo video link
* Google Drive demo video link
* Loom video link

---

## Repository Structure

```text
.
├── README.md
├── flights_weather_sample.csv
├── data_dictionary.md
├── build_starter_dataset.py
├── notebooks/
│   └── explainable_delay_risk_model.ipynb
├── saved_model/
│   ├── delay_risk_logistic_regression_pipeline.joblib
│   └── model_info.json
├── app/
│   └── streamlit_app.py
├── outputs/
│   └── explainable_delay_risk_test_results.csv
└── requirements.txt
```

---

## Files Included

### `flights_weather_sample.csv`

The real historical flight and weather dataset used for training and testing.

### `data_dictionary.md`

Explains the meaning of every column and identifies which columns are valid inputs and which are answer-key columns.

### `build_starter_dataset.py`

The starter script used to build or extend the dataset from raw US DOT data and Open-Meteo weather.

### `explainable_delay_risk_model.ipynb`

Jupyter Notebook containing:

* Data loading
* Feature engineering
* Cascade feature creation
* Train/test split
* Logistic Regression training
* Model evaluation
* Explanation generation
* Recommended action generation
* Output export

### `delay_risk_logistic_regression_pipeline.joblib`

Saved trained model pipeline containing:

* Preprocessing
* Scaling
* One-hot encoding
* Logistic Regression model

### `streamlit_app.py`

Interactive dashboard prototype for the operations controller.

---

## How to Run

### 1. Install requirements

```bash
pip install -r requirements.txt
```

### 2. Run the notebook

Open:

```text
notebooks/explainable_delay_risk_model.ipynb
```

Run all cells to train the model and generate predictions.

### 3. Run the dashboard

```bash
streamlit run app/streamlit_app.py
```

---

## Why This Is Not a Black Box

The tool is explainable by design.

It does not only produce a probability. It also shows:

* Which operational factor created the risk
* Which feature values triggered the risk
* Whether the risk came from cascade, weather, or congestion
* What the controller should do next

This makes the output usable for real operations decision-making.

---

## Limitations

This prototype uses a limited one-week dataset from two US hubs. It does not include:

* Crew duty limits
* Aircraft type
* Maintenance status
* Gate availability
* Passenger connection data
* Full airline network rotation
* Live METAR/TAF aviation weather
* Air traffic control slot restrictions

These limitations should be addressed before production deployment.

---

## Future Improvements

Possible next steps:

* Add live METAR/TAF aviation weather
* Add aircraft type and turnaround-time requirements
* Add crew duty and crew connection constraints
* Add gate and airport capacity data
* Expand dataset across more airports and seasons
* Add real-time flight tracking using OpenSky
* Improve cascade modeling across the full aircraft network
* Add SHAP explanations for comparison while keeping the main interface rule-based and interpretable

---

## Final Summary

Turnaround Guardian is an explainable delay-risk assistant for airline operations controllers. It predicts flight delay risk using schedule, weather, congestion, and aircraft cascade features, then converts the prediction into a clear reason and recommended action.

The goal is not just to predict delay.

The goal is to help the operations controller make a better decision before one delay becomes many.

# Motor Insurance Claim Frequency Statistical Modeling

This project investigates the factors associated with motor insurance claim frequency using statistical modeling and risk analytics techniques.

The analysis is based on the `freMTPL2freq` motor insurance dataset, which contains more than 678,000 policy records with information about claim counts, policy exposure, driver characteristics, vehicle characteristics, and geographical factors.

## Project Objectives

The main objectives of this project are to:

- explore and understand the motor insurance portfolio
- identify factors associated with claim frequency
- perform statistical hypothesis testing
- build and compare count-based statistical models
- evaluate model assumptions and performance
- interpret the effects of important risk factors
- translate statistical findings into practical insurance risk insights

## Statistical Methods

The project includes:

- descriptive statistical analysis
- hypothesis testing
- Poisson regression
- Negative Binomial regression
- LASSO Poisson regression
- Elastic Net Poisson regression
- model diagnostics
- overdispersion analysis
- calibration analysis
- Principal Component Analysis (PCA)
- Bayesian Poisson regression
- experimental design concepts
- time-series analysis as a proposed future extension

## Main Modeling Approach

Claim frequency is modeled as count data using policy exposure as an offset.

The main model structure is:

```text
ClaimNb ~ Driver Characteristics
        + Vehicle Characteristics
        + Geographic Characteristics
        + log(Exposure)
```

The Poisson GLM is used as an interpretable baseline model, while alternative models are evaluated to address issues such as overdispersion and regularization.

## Key Findings

The analysis identified several variables associated with differences in claim frequency, including:

- driver age
- vehicle age
- Bonus-Malus score
- geographical area
- population density

The analysis also found evidence of overdispersion in the claim counts, which motivates further comparison between Poisson and Negative Binomial models.

Model evaluation includes out-of-sample testing, Poisson deviance, MAE, RMSE, calibration, and statistical diagnostics.

## Repository Structure

```text
insurance-claim-frequency-statistical-modeling/
│
├── data/
│   └── dataset files are excluded from Git
│
├── scripts/
│   ├── Statistical Inference.R
│   ├── test_task3.ipynb
│   ├── task5_full_models_.ipynb
│   ├── task5_poisson_vs_negative_binomial.ipynb
│   ├── Task_7_Exploratory_PCA.ipynb
│   └── task8_bayesian_methods.ipynb
│
├── outputs/
│   └── generated figures and model outputs
│
├── .gitignore
└── README.md
```

## Dataset

The project uses the French Motor Third-Party Liability claim-frequency dataset `freMTPL2freq`.

The dataset contains policy-level information including:

- claim count
- policy exposure
- driver age
- vehicle age
- vehicle power
- vehicle brand
- fuel type
- Bonus-Malus score
- geographical area
- region
- population density

The raw dataset is not included in this repository.

## Project Status

The academic version of the project has been completed.

The portfolio version is being extended with:

- improved Negative Binomial modeling
- additional GLM diagnostics
- confidence intervals and rate-ratio interpretation
- nonlinear effects for continuous predictors
- cross-validation
- improved calibration analysis
- model stability analysis
- a possible interactive risk analytics dashboard

## Purpose

This project demonstrates the use of statistical modeling for a real-world insurance risk problem, with emphasis on interpretability, model diagnostics, statistical validity, and practical decision support.

The goal is not to create a complete insurance pricing system, but to develop an evidence-based claim-frequency risk analytics framework that could support underwriting, portfolio monitoring, and risk management.

from pathlib import Path

import joblib
import pandas as pd


PROJECT_DIR = Path(__file__).resolve().parents[1]

DATA_PATH = (
    PROJECT_DIR
    / "data"
    / "processed"
    / "customer_churn_cleaned.csv"
)

MODEL_PATH = (
    PROJECT_DIR
    / "models"
    / "customer_churn_random_forest.joblib"
)


def main():
    # Check required files
    if not DATA_PATH.exists():
        raise FileNotFoundError(f"Dataset not found: {DATA_PATH}")

    if not MODEL_PATH.exists():
        raise FileNotFoundError(f"Model not found: {MODEL_PATH}")

    # Load data and model
    df = pd.read_csv(DATA_PATH)
    model = joblib.load(MODEL_PATH)

    # Select one customer for demonstration
    customer = df.drop(
        columns=["customerID", "Churn"]
    ).iloc[[0]]

    # Predict
    prediction = int(model.predict(customer)[0])
    probability = float(model.predict_proba(customer)[0, 1])

    print("Customer Churn Prediction")
    print("-" * 30)
    print("Predicted status:", "Churn" if prediction == 1 else "No Churn")
    print(f"Estimated churn probability: {probability:.2%}")


if __name__ == "__main__":
    main()
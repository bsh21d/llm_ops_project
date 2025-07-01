from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score
import sys

# Generate dummy data
X, y = make_classification(n_samples=1000, n_features=20, n_informative=5, n_redundant=2, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Train model
clf = RandomForestClassifier(random_state=42)
clf.fit(X_train, y_train)

# Predict probabilities and compute AUC
y_probs = clf.predict_proba(X_test)[:, 1]
auc = roc_auc_score(y_test, y_probs)

print(f"AUC: {auc:.4f}")

# Exit with failure if AUC < 0.8
if auc < 0.8:
    print("❌ AUC is below threshold. Test failed.")
    sys.exit(1)
else:
    print("✅ AUC is above threshold. Test passed.")

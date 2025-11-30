# Dataset Files

Due to GitHub file size limits, dataset files are not included in this repository.

## Required Files

Place the following files in this directory before running tests:

1. **kddcup.data_10_percent.csv** (~65 MB)
   - Source: [KDD Cup 1999 Dataset](http://kdd.ics.uci.edu/databases/kddcup99/kddcup99.html)
   - Description: 10% subset of KDD Cup network intrusion data

2. **data_after_smote.csv** (~258 MB)
   - Description: Preprocessed dataset with SMOTE augmentation (1,847,149 samples)
   - Features: 28 numeric features extracted from KDD Cup data
   - Required for retraining PCA model

## Download Instructions

```bash
# Option 1: Download from KDD Cup website
wget http://kdd.ics.uci.edu/databases/kddcup99/kddcup.data_10_percent.gz
gunzip kddcup.data_10_percent.gz
mv kddcup.data_10_percent kddcup.data_10_percent.csv

# Option 2: Contact repository maintainer for preprocessed data_after_smote.csv
```

## Note

The trained PCA model coefficients are already included in `model/pca_coeffs.json`, so you can run simulations without downloading datasets. Datasets are only needed if you want to retrain the model.

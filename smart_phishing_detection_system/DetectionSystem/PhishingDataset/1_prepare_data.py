import pandas as pd
import numpy as np

# --- 1. Load SMS Data ---
print("--- Loading SMS Data ---")
try:
    df_sms = pd.read_csv('sms_data.csv')
    print(f"SMS Columns found: {df_sms.columns.tolist()}")
    
    # Standardize columns
    # We look for 'target' or 'type' or 'v1' (common in SMS datasets)
    if 'v1' in df_sms.columns: df_sms.rename(columns={'v1': 'target', 'v2': 'text'}, inplace=True)
    
    # Map text labels to numbers
    df_sms['label'] = df_sms['target'].map({'spam': 1, 'ham': 0})
    df_sms = df_sms[['text', 'label']]
    print("SMS Data loaded successfully.")
except Exception as e:
    print(f"Error loading SMS data: {e}")

# --- 2. Load Email Data ---
print("\n--- Loading Email Data ---")
try:
    df_email = pd.read_csv('email_data.csv', on_bad_lines='skip')
    print(f"Email Columns found: {df_email.columns.tolist()}")
    
    # Standardize columns
    # Your dataset likely has 'body' and 'label'
    if 'body' in df_email.columns:
        df_email = df_email.rename(columns={'body': 'text'})
    
    # Ensure label column exists
    if 'label' not in df_email.columns and 'Label' in df_email.columns:
        df_email = df_email.rename(columns={'Label': 'label'})
        
    df_email = df_email[['text', 'label']]
    df_email = df_email.dropna(subset=['text'])
    print("Email Data loaded successfully.")
except Exception as e:
    print(f"Error loading Email data: {e}")

# --- 3. Load URL Data (THE FIX IS HERE) ---
print("\n--- Loading URL Data ---")
try:
    df_url = pd.read_csv('url_data.csv', on_bad_lines='skip')
    print(f"URL Columns found: {df_url.columns.tolist()}") # <--- LOOK AT THIS OUTPUT IN TERMINAL

    # FIX: Check for Capitalized 'URL' or 'url'
    if 'url' in df_url.columns:
        df_url = df_url.rename(columns={'url': 'text'})
    elif 'URL' in df_url.columns:
        df_url = df_url.rename(columns={'URL': 'text'})

    # FIX: Check for 'label', 'Label', 'status', 'type'
    if 'Label' in df_url.columns:
        df_url = df_url.rename(columns={'Label': 'label'})
    elif 'status' in df_url.columns:
        df_url = df_url.rename(columns={'status': 'label'})
    elif 'type' in df_url.columns:
        df_url = df_url.rename(columns={'type': 'label'})

    # FIX: Handle Phishing/Legitimate text labels if they aren't numbers
    # Ensure everything is string first to avoid errors
    df_url['label'] = df_url['label'].astype(str)
    
    def clean_url_labels(x):
        x = x.lower().strip()
        if x in ['phishing', 'malicious', 'bad', '1']:
            return 1
        if x in ['legitimate', 'benign', 'safe', '0']:
            return 0
        return None # Unknown

    df_url['label'] = df_url['label'].apply(clean_url_labels)
    df_url = df_url.dropna() # Remove any rows we couldn't figure out
    
    df_url = df_url[['text', 'label']]
    print("URL Data loaded successfully.")
except Exception as e:
    print(f"Error loading URL data: {e}")
    # Stop execution if URL data fails, so you can see the error
    exit()

# --- 4. Merge All ---
print("\n--- Merging Datasets ---")
# Sampling to keep it fast on your laptop
df_final = pd.concat([
    df_sms, 
    df_email.sample(min(len(df_email), 50000)), 
    df_url.sample(min(len(df_url), 50000))
], ignore_index=True)

# Shuffle
df_final = df_final.sample(frac=1).reset_index(drop=True)

print(f"Final Dataset Size: {len(df_final)} rows")
print("Label Distribution:")
print(df_final['label'].value_counts())

# Save
df_final.to_csv('merged_training_data.csv', index=False)
print("\nSUCCESS: Saved to 'merged_training_data.csv'")
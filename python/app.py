from flask import Flask, render_template, request, jsonify
import joblib
import re
import numpy as np

app = Flask(__name__)

# --- 1. LOAD THE MODEL ---
try:
    model = joblib.load('phishing_model.pkl')
    print("✅ Model loaded successfully!")
except Exception as e:
    print(f"❌ Error loading model: {e}")
    print("Make sure 'phishing_model.pkl' is in the same folder as app.py")

# --- 2. TEXT CLEANING FUNCTION ---
# This MUST match the function used during training exactly
def clean_text(text):
    text = str(text).lower()
    # Replace links with special token
    text = re.sub(r'http\S+', ' http_link ', text)
    text = re.sub(r'www\S+', ' http_link ', text)
    # Keep alpha-numeric and ! ?
    text = re.sub(r'[^a-z0-9!? ]', '', text)
    return text

# --- 3. ROUTES ---

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get data from JSON request
        data = request.get_json()
        message = data['message']
        
        # Preprocess the input
        cleaned_message = clean_text(message)
        
        # Predict
        prediction = model.predict([cleaned_message])[0]
        probability = model.predict_proba([cleaned_message])[0]
        
        # Format results
        if prediction == 1:
            result = "PHISHING DETECTED 🚨"
            is_phishing = True
            confidence = probability[1] * 100
        else:
            result = "SAFE MESSAGE ✅"
            is_phishing = False
            confidence = probability[0] * 100
            
        return jsonify({
            'result': result,
            'confidence': f"{confidence:.2f}%",
            'is_phishing': is_phishing
        })

    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
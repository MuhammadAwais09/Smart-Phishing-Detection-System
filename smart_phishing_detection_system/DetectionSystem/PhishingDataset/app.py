from flask import Flask, render_template, request
import pickle
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.sequence import pad_sequences

app = Flask(__name__)

# Load model and tokenizer
model = load_model('phishing_model.h5')

with open('tokenizer.pickle', 'rb') as handle:
    tokenizer = pickle.load(handle)

# Same values used during training
max_length = 150
padding_type = 'post'
trunc_type = 'post'

@app.route('/', methods=['GET', 'POST'])
def index():
    prediction = None
    confidence = None
    text_input = ""

    if request.method == 'POST':
        text_input = request.form['text']

        # Preprocess input
        sequence = tokenizer.texts_to_sequences([text_input])
        padded = pad_sequences(
            sequence,
            maxlen=max_length,
            padding=padding_type,
            truncating=trunc_type
        )

        # Predict
        result = model.predict(padded)[0][0]

        confidence = round(float(result) * 100, 2)

        if result >= 0.5:
            prediction = "🚨 Phishing Website"
        else:
            prediction = "✅ Legitimate Website"

    return render_template(
        'index.html',
        prediction=prediction,
        confidence=confidence,
        text_input=text_input
    )

if __name__ == '__main__':
    app.run(debug=True)

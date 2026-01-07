from flask import Flask, render_template, request, jsonify
import pickle
import datetime
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

# --- Load the Model ---
print("⏳ Loading model...")
try:
    with open('chatbot_model.pkl', 'rb') as f:
        vectorizer = pickle.load(f)
        tfidf_matrix = pickle.load(f)
        answers = pickle.load(f)
    print("✅ Model loaded successfully.")
except FileNotFoundError:
    print("❌ Error: 'chatbot_model.pkl' not found.")
    print("   Please run 'train_bot.py' first to generate the model.")
    exit()

# --- Logic to find the best answer ---
def get_response(user_input):
    # 1. Convert user input to vector
    user_vec = vectorizer.transform([user_input])
    
    # 2. Calculate similarity
    similarities = cosine_similarity(user_vec, tfidf_matrix).flatten()
    
    # 3. Find best match
    best_match_index = similarities.argmax()
    confidence_score = similarities[best_match_index]

    # Threshold: If similarity is too low (e.g., < 20%), assume it's unknown
    if confidence_score < 0.2:
        return "I'm not sure about that. My training is limited to specific cybersecurity policies and definitions."
    
    return answers[best_match_index]

# --- Logic to save chat history ---
def log_conversation(user_text, bot_text):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # IMPORTANT: Added encoding='utf-8' here to prevent the crash you saw earlier
    try:
        with open("chat_history.txt", "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}]\n")
            f.write(f"User: {user_text}\n")
            f.write(f"Bot:  {bot_text}\n")
            f.write("-" * 40 + "\n")
    except Exception as e:
        print(f"⚠️ Could not save log: {e}")

# --- Web Routes ---
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/ask', methods=['POST'])
def ask():
    user_message = request.form.get('message', '').strip()
    
    if not user_message:
        return jsonify({'response': 'Please type a question.'})

    bot_response = get_response(user_message)
    
    # Save log
    log_conversation(user_message, bot_response)
    
    return jsonify({'response': bot_response})

if __name__ == '__main__':
    app.run(debug=True)
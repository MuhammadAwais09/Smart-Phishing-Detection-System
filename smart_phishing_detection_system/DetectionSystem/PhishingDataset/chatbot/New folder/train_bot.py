import json
import pickle
import numpy as np
import datetime 
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# --- Helper function to print to console AND save to file ---
def log_print(text):
    # 1. Print to the console (screen)
    print(text)
    
    # 2. Append to a text file (using utf-8 to prevent errors here too)
    with open("training_log.txt", "a", encoding="utf-8") as f:
        f.write(text + "\n")

def train_model():
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_print(f"\n--- Training Session Started: {current_time} ---")
    
    log_print("⏳ Loading dataset...")
    
    # 1. Load Data
    try:
        # FIX: Added encoding='utf-8' here to fix the crash
        with open('cyber_dataset.json', 'r', encoding='utf-8') as f:
            raw_data = json.load(f)
    except FileNotFoundError:
        log_print("❌ Error: 'cyber_dataset.json' file not found.")
        return
    except json.JSONDecodeError:
        log_print("❌ Error: 'cyber_dataset.json' is not formatted correctly.")
        return

    questions = []
    answers = []

    # Extract clean questions and answers
    for item in raw_data:
        try:
            q = item['vars']['question']
            a = item['vars']['answer']
            questions.append(q)
            answers.append(a)
        except KeyError:
            continue 

    dataset_count = len(questions)
    log_print(f"✅ Dataset Loaded. Total Q&A Pairs: {dataset_count}")

    if dataset_count == 0:
        log_print("❌ Error: No valid questions found in dataset.")
        return

    # 2. Train Vectorizer (Convert text to numbers)
    log_print("⏳ Training TF-IDF Model...")
    vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = vectorizer.fit_transform(questions)

    # 3. Calculate Accuracy
    log_print("⏳ Calculating Index Accuracy...")
    correct_matches = 0
    
    for i, question in enumerate(questions):
        query_vec = vectorizer.transform([question])
        similarities = cosine_similarity(query_vec, tfidf_matrix).flatten()
        best_match_index = np.argmax(similarities)
        
        if best_match_index == i:
            correct_matches += 1

    accuracy = (correct_matches / dataset_count) * 100
    log_print(f"📊 Model Accuracy (Recall@1): {accuracy:.2f}%")
    
    # 4. Save the Model and Data
    log_print("⏳ Saving model files...")
    with open('chatbot_model.pkl', 'wb') as f:
        pickle.dump(vectorizer, f)
        pickle.dump(tfidf_matrix, f)
        pickle.dump(answers, f)

    log_print("✅ Training Complete! Results saved to 'training_log.txt'.")

if __name__ == "__main__":
    train_model()
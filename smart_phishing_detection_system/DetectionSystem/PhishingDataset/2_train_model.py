import pandas as pd
import numpy as np
import pickle
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Embedding, GlobalAveragePooling1D, Dropout

# ==========================================
# 1. LOAD DATA
# ==========================================
print("Loading Merged Data...")
df = pd.read_csv('merged_training_data.csv')
df['text'] = df['text'].astype(str)

# ==========================================
# 2. TOKENIZATION
# ==========================================
vocab_size = 10000
max_length = 150
trunc_type = 'post'
padding_type = 'post'
oov_tok = "<OOV>"

print("Tokenizing text...")
tokenizer = Tokenizer(num_words=vocab_size, oov_token=oov_tok)
tokenizer.fit_on_texts(df['text'])

sequences = tokenizer.texts_to_sequences(df['text'])
padded = pad_sequences(
    sequences,
    maxlen=max_length,
    padding=padding_type,
    truncating=trunc_type
)

# ==========================================
# 3. TRAIN / TEST SPLIT
# ==========================================
X_train, X_test, y_train, y_test = train_test_split(
    padded,
    df['label'].values,
    test_size=0.2,
    random_state=42
)

# ==========================================
# DATASET SUMMARY
# ==========================================
total_samples = len(df)
train_samples = len(X_train)
test_samples = len(X_test)

print("\n===== DATASET SUMMARY =====")
print(f"Total samples:    {total_samples}")
print(f"Training samples: {train_samples}")
print(f"Testing samples:  {test_samples}")
print("===========================\n")

# ==========================================
# 4. BUILD MODEL
# ==========================================
model = Sequential([
    Embedding(vocab_size, 16),
    GlobalAveragePooling1D(),
    Dense(24, activation='relu'),
    Dropout(0.5),
    Dense(1, activation='sigmoid')
])

model.compile(
    loss='binary_crossentropy',
    optimizer='adam',
    metrics=['accuracy']
)

# ==========================================
# 5. TRAIN MODEL
# ==========================================
print("Starting Training...")
history = model.fit(
    X_train,
    y_train,
    epochs=5,
    validation_data=(X_test, y_test),
    verbose=1
)

# ==========================================
# 6. SAVE MODEL & TOKENIZER
# ==========================================
print("Saving Model and Tokenizer...")
model.save('phishing_model.h5')

with open('tokenizer.pickle', 'wb') as handle:
    pickle.dump(tokenizer, handle, protocol=pickle.HIGHEST_PROTOCOL)

# ==========================================
# 7. GENERATE GRAPHS
# ==========================================
print("Generating Graphs...")
acc = history.history['accuracy']
val_acc = history.history['val_accuracy']
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs_range = range(1, len(acc) + 1)

plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)
plt.plot(epochs_range, acc, label='Training Accuracy')
plt.plot(epochs_range, val_acc, label='Validation Accuracy')
plt.legend()
plt.title('Training vs Validation Accuracy')

plt.subplot(1, 2, 2)
plt.plot(epochs_range, loss, label='Training Loss')
plt.plot(epochs_range, val_loss, label='Validation Loss')
plt.legend()
plt.title('Training vs Validation Loss')

plt.savefig('model_graphs.png')
plt.close()

print("Saved graph to 'model_graphs.png'")

# ==========================================
# 8. FINAL EVALUATION
# ==========================================
test_loss, test_accuracy = model.evaluate(X_test, y_test, verbose=0)

# ==========================================
# 9. GENERATE REPORT (UTF-8 FIX)
# ==========================================
print("Generating Report...")

with open('model_report.txt', 'w', encoding='utf-8') as f:
    f.write("=========================================\n")
    f.write("       PHISHING DETECTION MODEL REPORT\n")
    f.write("=========================================\n\n")

    f.write("---- Dataset Summary ----\n")
    f.write(f"Total samples:    {total_samples}\n")
    f.write(f"Training samples: {train_samples}\n")
    f.write(f"Testing samples:  {test_samples}\n\n")

    f.write("---- Final Test Performance ----\n")
    f.write(f"Accuracy: {test_accuracy * 100:.2f}%\n")
    f.write(f"Loss:     {test_loss:.4f}\n\n")

    f.write("---- Model Architecture ----\n")
    model.summary(print_fn=lambda x: f.write(x + '\n'))

    f.write("\n---- Training History ----\n")
    for i in range(len(acc)):
        f.write(
            f"Epoch {i+1}: "
            f"Accuracy={acc[i]:.4f}, "
            f"Val_Accuracy={val_acc[i]:.4f}, "
            f"Loss={loss[i]:.4f}, "
            f"Val_Loss={val_loss[i]:.4f}\n"
        )

    f.write("\n=========================================\n")
    f.write("Files Generated:\n")
    f.write("1. phishing_model.h5\n")
    f.write("2. tokenizer.pickle\n")
    f.write("3. model_graphs.png\n")
    f.write("4. model_report.txt\n")
    f.write("=========================================\n")

print("SUCCESS: All files generated successfully!")


# 🛡️ Smart Phishing Detection System

**Version:** 1.0  
**Author:** SolutionWing.io  

Smart Phishing Detection System is a cross-platform mobile application designed to protect users from phishing attacks in real time. It integrates with SMS and Gmail, analyzes URLs and message content using AI/ML models, and alerts users before they interact with malicious links.

---

## 📘 Overview

Phishing attacks are one of the most common cybersecurity threats. This system proactively detects phishing attempts by analyzing URLs and message content using machine learning and natural language processing (NLP). The application provides real-time alerts, a history dashboard, and an educational AI chatbot to improve user awareness.

This repository contains:
- Mobile application source code  
- Machine learning model files  
- Backend and cloud configuration  
- Project documentation  

---

## 🎯 Key Features

| Feature | Description |
|------|------------|
| 🔐 Secure Authentication | Firebase Authentication with optional Multi-Factor Authentication (MFA) |
| 🔄 Real-Time Sync | Secure SMS and Gmail synchronization using Firebase and Gmail API |
| 🌐 Phishing Detection Engine | AI/ML models classify URLs as **Real** or **Fake** |
| 🚨 Instant Alerts | High-priority notifications for detected phishing links |
| 📜 History Log | View and filter analyzed messages and URLs |
| 🤖 AI Chatbot | Educates users about phishing and cybersecurity best practices |
| ☁️ Cloud Integration | Firebase for authentication, storage, and real-time database |

---

## 🧠 System Architecture

### Core Components

#### 📱 Mobile Frontend (Android / iOS)
- Built with **Flutter** (or React Native)
- Authentication, dashboard, history, and chatbot interfaces

#### 🤖 ML / AI Module
- **URL Phishing Detection**
  - Algorithms: XGBoost, Random Forest
  - Features: lexical, host-based, content-based
- **NLP Text Analysis**
  - Detects urgency, financial terms, scam patterns, and poor grammar

#### ☁️ Backend Services
- Firebase (Authentication, Firestore, Cloud Functions)
- Gmail API (OAuth 2.0)
- Secure communication via HTTPS / TLS 1.2+

---

## ⚙️ Tech Stack

| Component | Technology |
|--------|-----------|
| Frontend | Flutter / React Native |
| Backend | Firebase, Firestore |
| ML Framework | Scikit-learn, TensorFlow Lite |
| API Integration | Gmail API (OAuth 2.0) |
| Languages | Python, Dart, JavaScript |
| Security | AES-256, TLS 1.2+, MFA |

---

## 🧩 Project Structure

```text
smart-phishing-detection/
│
├── app/                              # Mobile application source code
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
│
├── backend/
│   ├── firebase-config/              # Firebase configuration files
│   ├── api/                          # Serverless functions
│   └── models/
│
├── ml_models/
│   ├── url_detection_model.pkl       # Trained URL detection model
│   ├── nlp_model.pkl                 # NLP phishing detection model
│   └── feature_engineering.ipynb
│
├── docs/                             # Project documentation
│   └── SRS.pdf
│
└── README.md
````

---

## 🚀 Setup & Installation

### Prerequisites

* Flutter SDK or Node.js
* Firebase account
* Python 3.8+
* Gmail API OAuth 2.0 credentials

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/<your-username>/smart-phishing-detection.git
cd smart-phishing-detection
```

---

### 2️⃣ Firebase Setup

1. Create a Firebase project
2. Enable Authentication and Firestore
3. Download:

   * `google-services.json` (Android)
   * `GoogleService-Info.plist` (iOS)
4. Place them in the appropriate app directories

---

### 3️⃣ Install Dependencies

**Mobile App**

```bash
flutter pub get
```

**ML Environment**

```bash
pip install -r requirements.txt
```

---

### 4️⃣ Configure Gmail API

* Enable Gmail API in Google Cloud Console
* Configure OAuth consent screen
* Download credentials and store them securely in:

```
backend/credentials/
```

---

### 5️⃣ Run the Application

```bash
flutter run
```

---

## 🧮 ML Model Details

### URL Detection

* **Algorithms:** XGBoost, Random Forest
* **Features:**

  * URL length
  * Number of subdomains
  * SSL certificate
  * Special characters
  * Keyword patterns
* **Output:** Real / Fake with confidence score

### NLP Content Analysis

* **Techniques:** Naive Bayes / Lightweight Transformer
* **Focus:**

  * Urgency indicators
  * Financial terms
  * Social engineering language

---

## 🤖 AI Chatbot

The built-in chatbot helps users:

* Identify phishing indicators
* Learn cybersecurity best practices
* Get help using the application

---

## 🔒 Security & Privacy

* TLS encryption for data transmission
* AES-256 encryption for stored data
* No raw SMS or email data is shared without user consent
* Explicit runtime permission handling
* Firebase Authentication with MFA support

---

## 📊 Performance Metrics

| Metric            | Target            |
| ----------------- | ----------------- |
| Detection Latency | ≤ 500 ms          |
| Sync Throughput   | ≥ 10 messages/sec |
| Service Uptime    | ≥ 99%             |

---

## 🧠 Future Enhancements

* On-device ML for offline detection
* Browser extension integration
* WhatsApp and Telegram message scanning
* Federated learning for privacy-preserving training

---

## 👩‍💻 Contributors

* **Lead Developer:** Your Name
* **ML Research Lead:** Contributor Name
* **Mobile Developer:** Contributor Name
* **UI/UX Designer:** Contributor Name

---

## 📄 License

This project is licensed under the **MIT License**.
See the `LICENSE` file for more details.

---

## 💡 Acknowledgments

* Mandadi et al., *Phishing Website Detection Using ML*, IEEE Xplore
* Rehman et al., *Real-Time Phishing URL Detection*, MDPI
* Linh et al., *Feature-Engineered Dataset for URLs*, ScienceDirect

---

🧭 **Smart Protection, Smarter Learning — keeping your inbox safe, one link at a time.**

```

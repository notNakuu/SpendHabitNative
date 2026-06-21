# Spend Habit

Personal finance tracking iOS application built with **SwiftUI**, **SwiftData**, and a custom **Spring Boot backend**.  
Designed to track expenses, visualize spending habits, and sync data across devices using cloud-based persistence.

---

## 📱 Tech Stack

- SwiftUI
- SwiftData
- Async/Await
- MVVM Architecture
- CloudKit (iCloud sync)
- REST API integration
- Spring Boot
- PostgreSQL
- Docker

---

## 🚀 Features

- Create, edit, and delete expenses
- Categorize transactions
- Monthly spending analytics
- Interactive charts and summaries
- Favorites and quick access
- Cloud synchronization via iCloud
- Secure backend API integration
- User authentication flow

---

## 🧠 Architecture

This project follows a **MVVM architecture** with a clear separation of concerns:

- **Views** → SwiftUI UI layer
- **ViewModels** → Business logic and state management
- **Models** → SwiftData persistent models
- **Services** → Networking layer (REST API communication)
- **Backend** → Spring Boot API with PostgreSQL database

Async/Await is used throughout the networking layer to ensure modern concurrency handling and responsive UI updates.

---

## 📊 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/ec33649e-5f55-4486-85bd-45f0bbd4754c" width="260"/>
  <img src="https://github.com/user-attachments/assets/426d2a3d-097d-411d-a0cc-9801c1cfe073" width="260"/>
  <img src="https://github.com/user-attachments/assets/53d0d243-e1bf-473f-9a33-c018e38c8f7d" width="260"/>
</p>

<p align="center">
  <img width="260" src="https://github.com/user-attachments/assets/75f7db22-9aad-444b-8be0-63f95b70528e" />
  <img width="260" src="https://github.com/user-attachments/assets/3e7ca661-af6e-4bd4-bf5c-f27958780848" />
  <img width="260" src="https://github.com/user-attachments/assets/3b2e518a-510c-4eaf-829b-ea339dd3afa9" />
</p>

> ⚠️ Full feature set includes additional views for transactions, analytics, and profile management.

---

## 🧩 Project Structure
SpendHabitNative
├── Models
├── Views
├── ViewModels
├── Services
├── Core

---

## 🧠 What I Learned

- Building scalable MVVM architecture in SwiftUI
- Managing state and persistence with SwiftData
- Implementing async/await networking
- Designing and consuming REST APIs
- Backend development with Spring Boot
- Structuring a full-stack mobile application
- Working with real-world app constraints and UX flows

---

## 📦 Backend

The backend is built separately using:

- Spring Boot
- PostgreSQL
- Docker

It provides:
- Authentication
- Expense CRUD operations
- Category management
- Analytics data endpoints

---

## 📈 Project Status

Active development – new features and improvements are continuously being added.

---

## 🔗 Related Projects

- Track Them – Subscription tracking iOS app (App Store published)

---

## 📌 Notes

This project is part of a personal portfolio focused on becoming a professional iOS developer.

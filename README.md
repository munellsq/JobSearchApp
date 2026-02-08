# JobSearchApp

JobSearchApp is an iOS application built with SwiftUI that allows users to search for remote jobs, save favorite positions, and track job applications.  
The project is developed as a team assignment and follows the MVVM architecture pattern.

---

## Team Members

- **Murat Narynbekov**
- **Kalizhan Makush**

---

## Features

- 🔍 Search remote jobs using a live external API
- 🏷 Filter jobs by category
- ⭐ Save jobs to Favorites
- 📋 Track job applications by status
- 🔄 Pull-to-refresh job list
- 💾 Persistent storage using UserDefaults
- 🎨 Custom SwiftUI UI components
- 📱 Modern iOS design

---

## Tech Stack

- **Language:** Swift  
- **UI Framework:** SwiftUI  
- **Architecture:** MVVM  
- **State Management:** Combine (`@Published`, `@StateObject`)  
- **Networking:** URLSession + async/await  
- **Persistence:** UserDefaults  
- **Version Control:** Git & GitHub  

---

## External API

The application uses a real public REST API:

- **API Name:** Remotive Jobs API  
- **Endpoint:** `https://remotive.com/api/remote-jobs`  
- **Data:** Remote job listings (title, company, category, location, description)

The API is integrated using async/await with proper error handling and cache bypass on refresh.

---

## Deployment

This project is deployed as a production-ready iOS application.

- Successfully builds and runs in Xcode
- Uses a live external API
- No additional environment configuration required
- Source code is deployed to a public GitHub repository

---

## Project Structure

```
JobSearchApp/
├── JobSearchAppApp.swift
├── ContentView.swift
│
├── Models/
│   ├── Application.swift
│   ├── FavoriteJob.swift
│   └── RemotiveDTO.swift
│
├── Networking/
│   ├── JobsAPI.swift
│   └── RemotiveAPI.swift
│
├── Services/
│   ├── ApplicationsStore.swift
│   └── FavoritesStore.swift
│
├── ViewModels/
│   └── JobsViewModel.swift
│
├── Views/
│   ├── JobsListView.swift
│   ├── JobDetailsView.swift
│   ├── FavoritesView.swift
│   ├── ApplicationsView.swift
│   ├── ApplicationDetailView.swift
│   └── UIComponents.swift
│
├── Assets.xcassets
└── JobSearchAppTests/
    └── JobSearchAppTests.swift
```

---

## Architecture

The project follows the **MVVM (Model–View–ViewModel)** architecture:

- **Model:** Data structures and DTOs
- **View:** SwiftUI views and UI components
- **ViewModel:** Business logic and API interaction

This ensures clean separation of concerns and scalable code structure.

---

## How to Run

1. Clone the repository
2. Open `JobSearchApp.xcodeproj` in Xcode
3. Select any iOS Simulator
4. Run the project (`Cmd + R`)

---

## Author

Developed by:

- **Murat Narynbekov**
- **Kalizhan Makush**

2026

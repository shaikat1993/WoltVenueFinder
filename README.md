# WoltVenueFinder

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange?logo=swift)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue?logo=apple)](https://developer.apple.com/ios)
[![License](https://img.shields.io/badge/License-MIT-green)](#license)

A modern, high-performance venue discovery and management application designed for the Wolt ecosystem. This interview preparation project demonstrates advanced iOS architecture patterns, API integration strategies, and user-centric design principles.

## Overview

A modern iOS app that helps users discover nearby restaurants in Helsinki
Built as part of the Wolt Software Engineering Internship application
Features • Architecture • Installation • Demo • Technical Stack

```
┌─────────────────────────────────────────────┐
│                   Views                     │
│  (VenueListView, VenueRow, etc.)            │
└─────────────┬───────────────────────────────┘
              │ User Actions
              ▼
┌─────────────────────────────────────────────┐
│                ViewModels                   │
│  (VenueListViewModel, FavoritesViewModel)   │
└─────────────┬───────────────────────────────┘
              │ Business Logic
              ▼
┌─────────────────────────────────────────────┐
│                 Services                    │
│  (VenueService, LocationSimulator,          │
│   FavoritesManager)                         │
└─────────────┬───────────────────────────────┘
              │ Data
              ▼
┌─────────────────────────────────────────────┐
│                  Models                     │
│  (Venue, VenueResponse, Location)           │
└─────────────────────────────────────────────┘
```
```
WoltVenueFinder/
├── Models/                      # Data models (Codable)
│   ├── Venue.swift
│   ├── VenueResponse.swift
│   └── Location.swift
│
├── Services/                    # Business logic layer
│   ├── VenueService.swift       # API networking
│   ├── LocationSimulator.swift  # Location updates
│   └── FavoritesManager.swift   # Persistence
│
├── ViewModels/                  # Presentation logic
│   ├── VenueListViewModel.swift
│   └── FavoritesViewModel.swift
│
├── Views/                       # SwiftUI views
│   ├── VenueListView.swift
│   ├── VenueRow.swift
│   ├── FavoritesView.swift
│   ├── LoadingView.swift
│   ├── ErrorView.swift
│   └── EmptyStateView.swift
│
├── Utilities/                   # Shared utilities
│   └── Constants.swift
│
└── Tests/                       # Unit tests
    ├── VenueServiceTests.swift
    ├── FavoritesManagerTests.swift
    └── VenueListViewModelTests.swift
```
## Contributing

This project is maintained as an interview preparation portfolio piece. For suggestions or improvements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👨‍💻 Author

**Md Sadidur Rahman**

- 🎓 Master's Student - Software, Web & Cloud Computing, Tampere University
- 💼 6+ years iOS Development experience (Pathao Ltd.)
- 🔬 Thesis: "OWASP LLM Security Mitigations in Multi-Agent Systems"
- 📍 Based in Tampere, Finland

### Connect

- GitHub: [@shaikat1993](https://github.com/yourusername](https://github.com/shaikat1993))
- LinkedIn: [Md Sadidur Rahman](https://linkedin.com/in/yourprofile](https://www.linkedin.com/in/md-sadidur-rahman-39a1b5146/))
- Email: mdsadidurrahman74@gmail.com

---

## 📄 License

This project is created for educational purposes as part of a job application.
```
MIT License

Copyright (c) 2026 Md Sadidur Rahman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

---

**Last Updated**: February 2026  
**Version**: 1.0.0

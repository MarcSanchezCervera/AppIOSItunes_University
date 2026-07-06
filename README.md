# AppIOSItunes_University

## About the Project

This project was developed as a university assignment using **SwiftUI** and the **iTunes Search API**. The application allows users to search for songs and music videos while providing additional features to improve usability and personalization.

Developed by:

* Àlex Alonso
* Ricard Colet
* Marc Sánchez

---

## Features

✅ Search songs and music videos using the iTunes API
✅ Dynamic pagination with infinite scrolling
✅ Favorites system with persistent storage using UserDefaults
✅ User preferences screen
✅ Content filtering by genre, country, and explicit content settings
✅ Responsive and user-friendly interface built with SwiftUI

---

## Technologies Used

* Swift
* SwiftUI
* iTunes Search API
* UserDefaults
* JSON

---

## Project Structure

* **ITunesStore** → Handles API requests and pagination logic
* **SongsFavorites** → Manages favorite items and local persistence
* **SearchItemsView** → Displays search results
* **ItemDetailsView** → Shows detailed item information
* **UserView** → User profile and preferences
* **OptionsDropDownView** → Reusable dropdown component for filters

---

## Main Functionalities

### Pagination

Results are loaded in blocks of 20 items and automatically fetched as the user scrolls through the list.

### Favorites

Users can add or remove songs and music videos from favorites. Data is stored locally using UserDefaults so it persists between app sessions.

### User Preferences

Users can customize search preferences such as:

* Genre
* Country
* Explicit content visibility

---

## References

* SwiftUI Documentation
* iTunes Search API Documentation
* Apple Developer Resources

---

## Academic Context

This application was developed as a university project for the Interactive Television course and focuses on implementing API integration, data persistence, pagination, and user customization features.

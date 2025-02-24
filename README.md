# RecipeFetchapp

**Recipe App Using Swift Async/await and Custom Image Disk Caching**

![Image](https://github.com/user-attachments/assets/4e76250c-d61e-4465-8694-30fe1a7e0fb1)

---

## Summary

My Recipe App is a single-screen SwiftUI application that displays a list of recipes loaded from a remote JSON API. Key features include:

- **Custom Disk Caching:**  
  Images are loaded only when needed and are stored on disk in a custom cache. This minimizes repeated network requests and conserves bandwidth.

- **Asynchronous Image and Data Loading with Async/Await:**  
  The app leverages Swift’s new async/await syntax to perform asynchronous networking operations in a clean and efficient way. Both the recipe data from the API and the images are loaded asynchronously, ensuring a smooth and responsive user experience.

- **Dynamic Filtering:**  
  Users can filter recipes by cuisine using a horizontal tab bar. The app dynamically filters the loaded recipes based on the selected cuisine, and it gracefully handles scenarios where no recipes are available or if the data is malformed by displaying appropriate states.

- **Pull-to-Refresh:**  
  With SwiftUI’s `.refreshable` modifier, users can refresh the recipe list at any time by pulling down on the list. This triggers asynchronous data loading, ensuring that the latest recipes are always displayed without blocking the UI.

---


# RecipeFetchapp

**Recipe App Using Swift Async/await and  Disk Caching**

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

## Focus Areas

I spent most of my time developing a custom solution to cache images on disk. This involved creating a dedicated cache directory using FileManager, generating safe file URLs via percent encoding, and implementing robust read/write operations for image data. Although SwiftUI’s built‑in AsyncImage could have simplified image loading, the project requirements specified that images must be cached on disk asynchronously. Consequently, I prioritized rewriting the networking and caching code with Swift’s async/await syntax, which made asynchronous operations cleaner. Additionally, I focused on seamless SwiftUI integration by building a custom CachedAsyncImage view that effectively manages loading states and displays images as soon as they’re available.

---

## Time Spent

I didn’t clock the exact time, but I spent almost 20 hours on this project over 3 days, dedicating most of that time to learning new techniques and refining my custom disk caching and asynchronous image loading solution to make the project as robust as possible.

---

## Tradeoffs and Decisions

By implementing a custom disk caching solution instead of using the built‑in caching methods documented by Apple, I gained greater control over how images are stored and managed. However, there are tradeoffs to this approach. While the custom solution works for now, it is not as thoroughly proven as Apple’s built‑in methods. There might be potential risks that edge cases or unexpected errors could arise in the future that the custom cache may not handle as robustly as the system-provided caching. Additionally, this approach adds more code complexity.

---

## Additional Information

This project helped me gain new knowledge and a practical understanding of how async/await works in Swift. Implementing this project was both a challenge and a valuable learning experience.

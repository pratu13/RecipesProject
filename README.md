### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I prioritized the following areas:
1. View Models: Ensuring that the RecipeImageViewModel and RecipesViewModel are functioning correctly, as they are crucial for data handling and state management.
2. Error Handling: Implementing and testing error handling for network issues, malformed data, and empty data to ensure the app can gracefully handle these scenarios.
3. Unit Tests: Writing comprehensive unit tests to cover various scenarios, including successful data fetching, network errors, and data parsing issues.
   
I chose to focus on these areas because they are critical for the app's stability and user experience. Properly functioning view models and robust error handling ensure that the app can provide a smooth and reliable experience for users.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent approximately 6 hours working on this project. The time was allocated as follows:
* Understanding the Codebase: 1 hour
* Implementing Error Handling: 1.5 hours
* Writing Unit Tests: 2 hours
* Debugging and Refining: 3 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
One significant trade-off was the decision to focus on unit tests rather than UI tests. While UI tests are important, unit tests provide a more granular level of testing and can catch issues early in the development process. Additionally, unit tests are generally faster to run and easier to maintain.

### Weakest Part of the Project: What do you think is the weakest part of your project?
While I implemented basic error handling, there could be more comprehensive strategies for retry mechanisms, user notifications, and logging to improve the robustness of the app.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I wanted to also focus on the UI for the app so I moved away from traditional list based layout and added a carousel paginated cards that user can scroll view. Alos added a search and sort funcationality 

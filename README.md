# Welcome to Football Leagues application.

By using this SwiftUI application, you will be able to follow up the available leagues information like teams exising on this league and matches for all teams also you'll be able to check the results of the previous matches.

Steps followed while implementing the application:

- Created the API key and checked the EndPoint response and created the Model based on needed data.
- The architecture used is MVVM-C, used it since ViewModel is pure logic and it’s not coupled with the view code, this will helps on clean visibility of the logic behavior and helps a lot with adding tests to the app, also the coordinator is spliting the logic for presentation than screens logic,
- Created the main Network Service class to handle APIs calls which will be injected to the ViewModel.
- For Networking used the URL session with using generic Data Request items which can automatically decode each model request based on it's defined type.
  - Added the ability to use Sample data mechanism to allow using hardcoded data if needed for unit testing or even for manual testing purposes to avoid api calling.
- Used Async Await methodology in the ViewModel to fetch the data from the service object then working on that data to properly display it.
- Used Combine in View models to get the updates from image loader and update the logo images based on the new fetched value.
- Used SQlite for data presetency on local disk, installed by SPM.
  - also used some UserDefaults properties to save the total number of the original data from the server to make sure no data is missing from the saved data on the data base.

- Created multiple screens for the application flow.
	- `LoadingView`: A view with progress view to be used when there is APIs calling is in progress, will be shown when the main screen is being loaded mainly as almost all of the next screens have the data already prepared.
	- `ErrorView`: A view that will appear if there is an error occurred while fetching the data, giving the user an option to retry fetching the data by tapping on retry button.
  - `LeaguesView`: A view with list presenting the competitions list using List component.
	- `LeagueCell`: A view to display the content of each league on the list.
  - `TeamsView`: A view with list presenting the selected competition on the top of screen and the list of teams included on this competition.
	- `TeamCell`: A view to display the content of each team on the list.
  - `MatchesView`: A view with list presenting the selected team on the top of screen and the list of matches attached to this team.
	- `MatchCell`: A view to display the content of each match on the list.

*Troubleshooting:*
- if you faced any issues related to installed package/s please follow these steps:
  - go to File -> Packages -> Reset Package Caches.
  - go to File -> Packages -> Resolve Package Versions.

- To run the application properly and get data, the `API_KEY` value in `Constants` file should be updated to a valid one.
	- `there are many ways to keep it secure either locally or remotely but safe ways will need backend handling thats why its skipped for now.`

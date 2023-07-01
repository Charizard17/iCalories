# iCalories

iCalories is a simple iOS app that helps users track their food consumption and monitor their calorie intake. With iCalories, you can easily add food items and keep a record of your daily food intake.

## Features

- **Food Tracking**: Add food items to track by entering their name, grams, and calories. The app provides sliders for selecting the values of grams and calories, making it quick and intuitive to add food items.

- **Auto Calculation**: Toggle the auto-calculation feature if you know the calorie-to-gram ratio for a particular food item. The app automatically calculates the calories based on the grams entered, saving you time and effort.

- **Date Selection**: Assign a specific date to each food entry to keep track of when you consumed it. The app includes a date picker for easy selection of the desired date.

- **Core Data Integration**: All food entries are stored using Core Data, a powerful and efficient data persistence framework provided by Apple. This ensures that your food diary is saved and can be accessed even when the app is closed.

- **API Integration**: iCalories integrates with the CalorieNinja API to provide additional information about food items, such as serving size, fat content, protein, sodium, and more.

## Getting Started

To get started with iCalories, follow these steps:

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the app on the iOS simulator or a physical device.

## Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.0 or later

## Reminder

You need an API Key from Calories Ninjas API. Go to https://calorieninjas.com/ and
get your API Key.
Then in Helpers folder create a file called Secrets.swift and add your
api key like this one:

```
let apiKey = "YOUR_API_KEY"
```

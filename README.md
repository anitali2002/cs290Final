# Scotland Final Project

### Project Goals

From searching each product’s packaging for nutrition information to looking up substitutes for certain ingredients in popular recipes, dietary restrictions can make it stressful to find delicious recipes with ingredients that work. Our project goal is to create an app that aims to fix that.

This app will be a user-friendly recipe-finding application that serves people with specific dietary needs or restrictions. Users will be able to link to their Health App data and/or upload information to their personal profile on our app, including allergen information and dietary restrictions (e.g. vegan, vegetarian, etc). They can then search for recipes that satisfy their dietary and other restrictions (possibly including cost, meal prep time, ingredients already owned, etc.) and pin favorite recipes for later.

### Features
-  Users can create a profile on the app and allow it to link to the Health App on their phone
-  User profile is saved locally in the app with information about allergies, dietary restrictions, preferences, etc.
-  Users can edit profile information to add, delete, or edit lists of allergies, dietary restrictions, preferences, etc.
-  Searched recipes align with the user’s allergen information, dietary restrictions, preferences, and other filters
-  Searched recipes allow for additional filtering, e.g. by cuisines, ingredients, meal type, time to make
-  Users can optionally upload information about ingredients already owned to their virtual fridge
-  Searched recipes automatically filter based on user profile information, e.g. allergens
-  Users can save/pin recipes for later 
-  [new] Users can optionally upload information on groceries they want to buy to a grocery list for future reference
-  [new] When fridge items are depleted, users will be able to automatically add them to the grocery list
-  [new] Users can add the nutrition information of a recipe to their Health app

### Overall Architecture

The application will have a main dashboard that includes multiple tabs to allow the user to switch between the recipe finder, recommendations, their virtual fridge, and their user profile. The application will use Apple’s HealthKit to access the user’s allergen information from the Health App and also to allow changes in allergies or dietary restrictions on the recipe app to be reflected back in the Health App. We will use a database model, SQLite, and data persistence to store user preferences locally on the app. The database will include information about the user’s allergies, dietary restrictions, saved recipes, and virtual fridge. User’s will have the ability to fill in text fields about themselves to customize their profile as much as they would like. Additionally, we will use the Spoonacular API to find recipes based on user searches. Users will be able to narrow down recipe searches based on things like cuisine, ingredients, meal type, etc., and view a table view of recipes that match their search criteria. Recipes that appear to the user will automatically be filtered so that they don’t include ingredients that the user has specified in their profile that they are allergic to or do not eat. Additionally, users can view detailed views of the recipes, save recipes to their profile, and view suggested recipes that will be supplied based on the current saved recipes 

### Presentation

The video for the presentation can be found at https://youtu.be/8tbGDmN-yTo. The slides for the presentation of our final roject can be found at https://docs.google.com/presentation/d/1ejAGBuB55Nuz7JOyFkHmw7KrCo1ABTEc7vJjDlzzwTI/edit?usp=sharing. Overall, we were able to create an app with our intended functionality and even add on top of that with a grocery list, profile picture, nutrition save, and more!

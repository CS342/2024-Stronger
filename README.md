<!--

This source file is part of the Stronger based on the Stanford Spezi Template Application project

SPDX-FileCopyrightText: 2023 Stanford University

SPDX-License-Identifier: MIT

-->

# CS342 2024 Stronger

[![Build and Test](https://github.com/CS342/2024-Stronger/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/CS342/2024-Stronger/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/CS342/2024-Stronger/graph/badge.svg?token=Vs0EuX6wgf)](https://codecov.io/gh/CS342/2024-Stronger)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10521605.svg)](https://doi.org/10.5281/zenodo.10521605)

This repository contains the CS342 2024 Stronger application.
The CS342 2024 Stronger application is using the [Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem and builds on top of the [Stanford Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).

> [!NOTE]  
> Do you want to try out the CS342 2024 Stronger application? You can download it to your iOS device using [TestFlight](https://testflight.apple.com/join/7jyDe6Hm)!
## Overview
The CS342 Stronger Application provides a way to track protein intake and resistance exercise training in postmenopausal Stanford research participants. Participants can use Stronger to track these two critical behaviors by: Inputting progressive resistance training metrics, inputting their food intake, and viewing their progress compared to their custom workout and protein goals.


## CS342 2024 Stronger Features

*Provide a comprehensive description of your application, including figures showing the application. You can learn more on how to structure a README in the [Stanford Spezi Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide)*


The Stronger App consists of three main screens. 



Home, Workout, and Food Tracking. 

| Home Screen | Daily Protein Screen | Weekly Stats Screen |
|-------------|-----------------|-------------------|
| ![Home Screen](https://github.com/CS342/2024-Stronger/assets/121056442/40827ace-e938-42f3-a4b8-85e0aa6ce47b) | ![Daily Protein Screen](https://github.com/CS342/2024-Stronger/assets/121056442/e641ee25-ddc6-40af-9757-324718963c95) | ![Local Chat Screen](https://github.com/CS342/2024-Stronger/assets/121056442/113a61b0-a06c-44cf-a9f4-2a17da642b6c) |

### Home 

#### Daily Protein

The top half of the page features a ring to help the user track her protein intake for the day. 
The ring fills up as protein gets logged in for the user and changes colour from red to orange to green corresponding to 3 levels of protein intake - 0-67%, 67%-99%, 100% of daily protein target met. 


##### Weekly Stats 

The Weekly Stats button takes the user to the Weekly Protein Intake Data page, allowing the user to take a look at their protein consumption over the last week. 
It depicts data in the form of a bar graph with each bar showing the protein intake for a given day. 
It also shows the 'average' daily protein intake for the week and the 'target' daily protein intake, helping the user understand how well they have been meeting their goals over the last 7 days. 

| Estimating portion size | Log Protein with Pro-Bot | Weekly Fitness Progress |
|-------------|-----------------|-------------------|
| ![Estimating portion size](https://github.com/CS342/2024-Stronger/assets/121056442/8150613d-2029-4754-bfd3-4d5c1c04abf0) | ![Log with Pro-Bot](https://github.com/CS342/2024-Stronger/assets/121056442/934f5334-2c74-49b0-bb44-0e6fd08eec1b) | ![Weekly Fitness Progress](https://github.com/CS342/2024-Stronger/assets/121056442/ab98cbfc-cca9-4ba7-b628-c284087acfb6) |

##### Estimating portion size

The "estimating portion size" button opens up a pdf with suggested ways in which the user can estimate the quantity of their meal while logging in their protein intake via the chatbot.

##### Log more with ProBot

This link is a shortcut to ProBot, the LLM-powered chatbot that logs in protein intake for the user.

#### Weekly Fitness Progress 

The bottom half of the *Home* page is the weekly fitness progress. 
It shows the current week and last week's progress.  If it is the first week for the participant, only one week will be shown. 
THe three buttons will navigate to workout selection. 
Each button has a text below that will show if the exercise day was on average "Easy", "Medium", "Hard" or of it is incomplete. 

### Workout

| Workout selection | Workout Input | Weekly Fitness Progress |
|-------------|-----------------|-------------------|
| ![Workout selection](https://github.com/CS342/2024-Stronger/assets/121056442/b40013c6-b51e-4983-bcfc-3aa774dae91a) | ![Workout Input](https://github.com/CS342/2024-Stronger/assets/121056442/ce14b1e7-4f68-4df2-8d03-a7727c9b13c9) | ![Workout Makeup Selection](https://github.com/CS342/2024-Stronger/assets/121056442/041a6ae2-59b4-43fb-9026-cedf1f609b0b) |

#### Workout selection

For week selection We use the account information. See Account info for more details.
To determine the exercise it queries the firestore to see what exercises are there. THere must be exercises for all workouts of a day for it to move onto the next exercise. 
For example, if Day 1 consists of Squats, Pushups, Lunge Left and Lunge Right, there must be all 4 exercises for the workout to move onto the next date. 

#### Workout Input

The user can navigate to the Workout Input Form from the Workout Selection page. For whichever specific exercise they selected, they can input the reps, resistance, and difficulty for 3 Sets. They can also see which sets they might have already completed, and edit the information if necessary. The workout input form also has a thumbnail of the selected workout, which the user can click and be directed to the workout video for that exercise. The user can also pre-populate form with saved data from the last time they completed the current exercise.

#### Workout Makeup Selection

If the user wants to submit a workout for a particular week or exercise day, They can navigate here and select the exact week and day. 

### Foodtracking

| ProBot | Protein via Image Recognition | Account Details |
|-------------|-----------------|-------------------|
| ![ProBot](https://github.com/CS342/2024-Stronger/assets/121056442/22372efa-0fe9-4f1e-8b18-aa213a8efbe7) | ![Protein via Image Recognition](https://github.com/CS342/2024-Stronger/assets/155938578/ec636be8-7c3f-49e1-9142-af45fb265274) | ![Account Details](https://github.com/CS342/2024-Stronger/assets/121056442/c62e4e74-6446-4972-abd9-fce3f19b7975) |

#### ProBot

ProBot is a gpt-powered chatbot that logs in the user's protein intake. It performs two main tasks:
1. It asks the user what they had for their last meal and extracts the protein content for each food item based on its quantity. To do this, it utilizes an external nutrition API to get the protein content for each food item per 100 grams.
2. It adds the total protein content from all the food items and logs in the total protein content for the meal. For this too, it makes use of function calling to store protein data for the meal into firestore.


#### Protein intake via image recognition
The protein intake via image recognition allows the user to click a picture of their meal to log in their protein intake. The app recognizes the food item, pre-populates the chatbot with the recognized food item and allows the user to log in their protein intake in a more hands-free manner. The user also has the option to edit the recognized food item in case the model misclassifies.


## Account details

Account has been augmented to include a startdate, weight, and height.  The current week is determined by the amount of weeks from the Monday of the startdate selected. i.e. Monday is considered the start of a week. 

> [!NOTE]  
> Do you want to learn more about the Stanford Spezi Template Application and how to use, extend, and modify this application? Check out the [Stanford Spezi Template Application documentation](https://stanfordspezi.github.io/SpeziTemplateApplication)


## Contributing

Theo: Augmenting Account. Weekly summary on Home Page. Workout Selection, Workout day and week selection.
Logic for determining current week and curreent exercise day. 

Tulika: ProBot (chatbot for logging in protein intake). Protein ring on Home Page. Weekly Stats view for weekly protein intake.
Logic for storing and retrieving protein data from Firestore.

Mena: Creating Input Form for user to submit workout information, reading and writing data from Firestore

Kevin: Food tracking via image recognition, includes creating CoreML Image Recognition model from scratch, Chatbot version to fetch
and store protein data following image recognition. Also created SavedMeals workflow (scrapped)

Yanav: Worked on the Workout Video view, thumbnails for different workouts, added the button for the portion size pdf, image recognition

## License

This project is licensed under the MIT License. See [Licenses](LICENSES) for more information.

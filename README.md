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


## CS342 2024 Stronger Features

*Provide a comprehensive description of your application, including figures showing the application. You can learn more on how to structure a README in the [Stanford Spezi Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide)*


The Stronger App consists of three main screens. 



Home, Workout, and Food Tracking. 

### Home 
#### Daily Protein
#### Weekly Fitness Progress 
The bottom half of the *Home* page is the weekly fitness progress. 
It shows the current week and last week's progress.  If it is the first week for the participant, only one week will be shown. 
THe three buttons will navigate to workout selection. 
Each button has a text below that will show if the exercise day was on average "Easy", "Medium", "Hard" or of it is incomplete. 



### Workout

#### Workout selection
For week selection We use the account information. See Account info for more details.
To determine the exercise it queries the firestore to see what exercises are there. THere must be exercises for all workouts of a day for it to move onto the next exercise. 
For example, if Day 1 consists of Squats, Pushups, Lunge Left and Lunge Right, there must be all 4 exercises for the workout to move onto the next date. 

#### Workout INput


#### Workout Makeup Selection.
If the user wants to submit a workout for a particular week or exercise day, They can navigate here and select the exact week and day. 


### Foodtracking


## Account details
Account has been augmented to include a startdate, weight, and height. 

THe current week is determined by the amount of weeks from the Monday of the startdate selected. i.e. Monday is considered the start of a week. 

> [!NOTE]  
> Do you want to learn more about the Stanford Spezi Template Application and how to use, extend, and modify this application? Check out the [Stanford Spezi Template Application documentation](https://stanfordspezi.github.io/SpeziTemplateApplication)


## Contributing

*Ensure that you add an adequate contribution section to this README.*


## License

This project is licensed under the MIT License. See [Licenses](LICENSES) for more information.

//
//  WorkoutHome.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/6/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import SpeziAccount
import SwiftUI

struct WorkoutSelections: View {
    // Struct to hold view and string data
    struct MenuItem {
        var view: WorkoutInputForm
        var title: String
        var video: String
    }
    @State private var menuItems: [MenuItem] = []
    @Binding var presentingAccount: Bool
    @State var selectedWeek: Int?
    @State var selectedDay: Int?
    @State private var geometry: CGSize = .zero
    @Environment(Account.self) var account

    private var menuItemsBackup: [MenuItem] = [
        MenuItem(
            view: WorkoutInputForm(
                workoutName: "Squats",
                presentingAccount: .constant(false),
                selectedWeek: 1,
                selectedDay: 1
            ),
            title: "Squats",
            video: "squats"
        ),
        MenuItem(
            view: WorkoutInputForm(
                workoutName: "Row",
                presentingAccount: .constant(false),
                selectedWeek: 1,
                selectedDay: 1
            ),
            title: "Row",
            video: "row"
        ),
        MenuItem(
            view: WorkoutInputForm(
                workoutName: "Pull Downs",
                presentingAccount: .constant(false),
                selectedWeek: 1,
                selectedDay: 1
            ),
            title: "Pull Downs",
            video: "straightarmpulldowns"
        )
    ]
    
    
    var body: some View {
        GeometryReader {geometry in
            NavigationStack {
                VStack {
                    Text("Workout Home")
                        .font(.title)
                        .padding()
                    
                    // Use the initialized menuItems array
                    ForEach(menuItems, id: \.title) { menuItem in
                        WorkoutHomeButton(
                            presentingAccount: $presentingAccount,
                            item: menuItem.title,
                            totalWidth: widthForMenuItems(in: geometry),
                            selectedWeek: selectedWeek ?? 1,
                            selectedDay: selectedDay ?? 1
                        )
                    }
                    
                    Spacer()
                    NavigationLink(destination: WorkoutHome(presentingAccount: $presentingAccount)) {
                        Text("Enter Missed Workout")
                            .foregroundColor(.primary)
                            .padding()
//                            .frame(width: totalWidth)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Workout Selection")
            .onAppear {
                Task {
                    try await onAppearFunc()
                }
            }
        }
    }
    
    init(presentingAccount: Binding<Bool>, selectedWeek: Int?, selectedDay: Int?) {
        self._presentingAccount = presentingAccount
        self.selectedWeek = selectedWeek
        self.selectedDay = selectedDay
    }
    
    private func onAppearFunc() async throws {
        selectedWeek = try? await calculateWeeksElapsed()
        print("Selected Week: \(selectedWeek ?? 1)")
        try await updateExerciseDate()
        if let exercises = parseExercises(week: selectedWeek ?? 1, day: selectedDay ?? 1) {
            buildMenuItem(workoutInst: exercises)
        } else {
            print("Error: Unable to parse exercises for the selected week and day.")
        }
    }
    
    private func widthForMenuItems(in geometry: GeometryProxy) -> CGFloat {
        // Calculate the width of the longest title
        let longestTitleWidth = menuItems.map { menuItem in
            menuItem.title.widthOfString(usingFont: .systemFont(ofSize: 17))
        }
        .max() ?? 0
//        print(longestTitleWidth)
        // Calculate the width as a percentage of the screen width
        let desiredWidth = longestTitleWidth + 32 // Add padding
        
        // Ensure the width does not exceed the screen width
        return min(desiredWidth, geometry.size.width * 0.5) // Set width as 50% of screen width
    }
    
    private func parseExercises(week: Int, day: Int) -> Workout? {
        // Get the URL of the JSON file in the app bundle
        if let fileURL = Bundle.main.url(forResource: "exercise_list", withExtension: "json") {
            do {
                // Read JSON data from the file
                let jsonData = try Data(contentsOf: fileURL)
                // print("JSON Data: \(String(describing: String(data: jsonData, encoding: .utf8)))")
                // Decode JSON data into WorkoutPlan struct
                let workoutPlan = try JSONDecoder().decode(WorkoutPlan.self, from: jsonData)
                var workout = workoutPlan.weeks1to3
                switch week {
                case 1...3:
                    workout = workoutPlan.weeks1to3
                case 4...6:
                    workout = workoutPlan.weeks4to6
                case 7...9:
                    workout = workoutPlan.weeks7to9
                case 10...12:
                    workout = workoutPlan.weeks10to12
                default:
                    workout = workoutPlan.weeks1to3// Return the original value for any other cases
                }
                print("Day at parse exercises: \(day)")
                
                if day >= workout.count || day <= 0 {
                    return workout[0]
                }
                
                return workout[day - 1]
                // Access the decoded data
                
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        } else {
            print("JSON file not found in the app bundle.")
            return nil
        }
    }

    
    // week should be a value 1 - 12.
    // Day should be value 1 - 3
    private func buildMenuItem(workoutInst: Workout) {
        self.menuItems = []
        for exerciseNumber in 1...4 {
            let exercise: String
            let video: String
            switch exerciseNumber {
            case 1:
                exercise = workoutInst.exercise1
                video = workoutInst.exercise1video
            case 2:
                exercise = workoutInst.exercise2
                video = workoutInst.exercise2video
            case 3:
                exercise = workoutInst.exercise3
                video = workoutInst.exercise3video
            case 4:
                exercise = workoutInst.exercise4
                video = workoutInst.exercise4video
            default:
                exercise = "" // This should never happen
                video = ""
            }
            let menuItem = MenuItem(
                view: WorkoutInputForm(
                    workoutName: exercise,
                    presentingAccount: $presentingAccount,
                    selectedWeek: selectedWeek ?? 1,
                    selectedDay: selectedDay ?? 1
                ),
                title: exercise,
                video: video
            )
            self.menuItems.append(menuItem)
            }
        }
    
    private func updateExerciseDate() async throws {
        // Get current user ID
        guard let userID = try await getCurrentUserID() else {
            print("Error getting user id")
            return
        }

        // Reference to Firestore database
        let dbe = Firestore.firestore()

        let userDocRef = dbe.collection("users").document(userID).collection("exerciseLog")
        let query = userDocRef.whereField("week", isEqualTo: self.selectedWeek)

        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                // Get the count of documents
                let documentCount = querySnapshot?.documents.count ?? 0

                // Check if there are no documents
                if documentCount == 0 {
                    print("No documents found. Setting selectedDay to 1.")
                    selectedDay = 1
                } else {
                    // Check if there are documents with selectedDay equal to 1
                    let selectedDay1Count = querySnapshot?.documents.filter { $0["exerciseDay"] as? Int == 2 }.count ?? 0
                    if selectedDay1Count > 3 {
                        print("Documents found with selectedDay equal to 2. Setting selectedDay to 3.")
                        selectedDay = 3
                    } else {
                        // Check if there are documents with selectedDay equal to 2
                        let selectedDay2Count = querySnapshot?.documents.filter { $0["exerciseDay"] as? Int == 1 }.count ?? 0
                        if selectedDay2Count > 3 {
                            print("Documents found with selectedDay equal to 1. Setting selectedDay to 2.")
                            selectedDay = 2
                        } else {
                            // If no documents have selectedDay equal to 1 or 2, set selectedDay to 1
                            print("No documents found with selectedDay equal to 1 or 2. Setting selectedDay to 1.")
                            selectedDay = 1
                        }
                    }
                }
            }
        }
    }


     // Function to get the current user ID
    private func getCurrentUserID() async throws -> String? {
        guard let details = try? await account.details else {
            return nil
        }
        return details.accountId
    }

    // Function to retrieve start day field and calculate weeks elapsed
    private func calculateWeeksElapsed() async throws -> Int {
        // Get current user ID
        guard let userID = try await getCurrentUserID() else {
            return 1
        }

        // Reference to Firestore database
        let dbe = Firestore.firestore()

        // Reference to document for current user
        let userDocRef = dbe.collection("users").document(userID)

        // Get snapshot of document
        let userDocSnapshot = try await userDocRef.getDocument()

        // Check if document exists and contains start day field
        guard let userData = userDocSnapshot.data(),
              let startDayTimestamp = userData["StartDateKey"] as? Timestamp else {
            print("did not find start day key", userID)
            return 1
        }
        
        print("Found start date key", userID)
        // Get start date from Timestamp
        var startDayDate = startDayTimestamp.dateValue()

        // Get current date
        let currentDate = Date()

        // Get Calendar instance
        let calendar = Calendar.current
        
        // Move start day to closest Monday
        let weekday = calendar.component(.weekday, from: startDayDate)
        let daysToMonday = (7 - weekday + 2) % 7 // +2 because Sunday is 1-based in `weekday` but we want Monday to be 0-based
        print("daysTOMonday \(daysToMonday)")
        startDayDate = calendar.date(byAdding: .day, value: -daysToMonday, to: startDayDate) ?? startDayDate
        print("startDayDate \(startDayDate)")

        // Calculate difference in weeks between start day and current date
        let weeksElapsed = calendar.dateComponents([.weekOfYear], from: startDayDate, to: currentDate).weekOfYear ?? 0
        print("weeksElapsed \(weeksElapsed)")
        let roundedWeeksElapsed = weeksElapsed > 0 ? weeksElapsed : 0 // Ensure weeksElapsed is non-negative
        print("rounded weeks elapsed \(roundedWeeksElapsed)")
        return weeksElapsed
    }
    
    private func uploadUserData() {
        let dbe = Firestore.firestore()
        
        // Data to be uploaded
        let userData: [String: Any] = [
            "name": "Rohan Gondor",
            "role": "admin"
        ]
        
        // Upload data to Firestore
        dbe.collection("users").document("admin").setData(userData) { error in
            if let error = error {
                print("Error uploading user data: \(error.localizedDescription)")
            } else {
                print("User data uploaded successfully!")
            }
        }
    }
}
  
struct Preview: PreviewProvider {
    static var previews: some View {
        WorkoutSelections(presentingAccount: .constant(false), selectedWeek: 1, selectedDay: 2)
    }
}

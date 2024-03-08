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
    @State var selectedWeek: Int
    @State var selectedDay: Int
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
                            selectedWeek: selectedWeek,
                            selectedDay: selectedDay
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
    
    init(presentingAccount: Binding<Bool>, selectedWeek: Int, selectedDay: Int) {
        self._presentingAccount = presentingAccount
        self.selectedWeek = selectedWeek
        self.selectedDay = selectedDay
    }
    
    private func onAppearFunc() async throws {
        if let exercises = parseExercises(week: selectedWeek, day: selectedDay) {
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
                    selectedWeek: selectedWeek,
                    selectedDay: selectedDay
                ),
                title: exercise,
                video: video
            )
            self.menuItems.append(menuItem)
            }
        }
    
     // Function to get the current user ID
    private func getCurrentUserID() async throws -> String? {
        guard let details = try? await account.details else {
            return nil
        }
        return details.accountId
    }
}
  
struct Preview: PreviewProvider {
    static var previews: some View {
        WorkoutSelections(presentingAccount: .constant(false), selectedWeek: 1, selectedDay: 2)
    }
}

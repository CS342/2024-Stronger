//
//  ExerciseWeek.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/19/24.
//
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Firebase
import SpeziAccount
import SwiftUI

struct ExerciseWeek: View {
    enum Tabs: String {
        case home
        case workout
        case chatWindow
    }
    
    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.home
    @State private var documents: [DocumentSnapshot] = []
    @Binding var presentingAccount: Bool
    var value: Int
    @State private var colorOne: Color = .gray.opacity(0.5)
    @State private var colorTwo: Color = .gray.opacity(0.5)
    @State private var colorThree: Color = .gray.opacity(0.5)
    @State private var averageDifficulties: [Double] = [0, 0, 0]
    private let defaultColor: Color = .green.opacity(0.3)
    @Environment(Account.self) var account
    // Array to store average difficulties for each day

    var body: some View {
        HStack {
            Button(action: {
                selectedTab = Tabs.workout
            }) {
                Text(" Workout 1 ")
                    .padding()
            }
             // Apply background color
            
            .frame(width: 120, height: 50)
            .background(defaultColor)
            .cornerRadius(8)
            // .border(Color.black, width: 1) // Add black border
            Button(action: {
                selectedTab = Tabs.workout
            }) {
                Text(" Workout 2 ")
            }
             // Apply background color
            
            .frame(width: 120, height: 50)
            .background(defaultColor)
            .cornerRadius(8)
            .border(Color.black, width: 1) // Add black border
           

            Button(action: {
                selectedTab = Tabs.workout
            }) {
                Text(" Workout 3 ")
            }
            
            
            .frame(width: 120, height: 50)
            .cornerRadius(8)
            .border(Color.black, width: 1)
            .background(defaultColor) // Apply background color
            //  // Add black border
//            NavigationLink(destination: WorkoutHome(presentingAccount: $presentingAccount)) {
//                Text("Exercise 1")
//                    .modifier(NavButton())
//            }
//                           NavigationLink(destination: WorkoutHome(presentingAccount: $presentingAccount)) {
//                Text("Exercise 2")
//                    .modifier(NavButton())
//            }
//                           NavigationLink(destination: WorkoutHome(presentingAccount:$presentingAccount)) {
//                Text("Exercise 3")
//                    .modifier(NavButton())
//            }
        }
        .onAppear {
            fetchDocuments(week: value)
        }
    }
    
    init(value: Int, presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
        self.value = value
    }
    private func fetchDocuments(week: Int) {
        Task {
            do {
                if let currentUserID = try await getCurrentUserID() {
                    for day in 1...3 {
                        await queryDocumentsForWeekAndDay(week: week, day: day, currentUserID: currentUserID)
                    }
                    updateColor()
                }
            } catch {
                print("Error fetching current week:", error)
            }
        }
    }

    // Function to get the current user ID
    private func getCurrentUserID() async throws -> String? {
        guard let details = try await account.details else {
            return nil
        }
        return details.accountId
    }

    // Function to query documents for a specific week and day
    private func queryDocumentsForWeekAndDay(week: Int, day: Int, currentUserID: String) async {
        let dbe = Firestore.firestore()
        do {
            let snapshot = try await dbe.collection("users").document(currentUserID).collection("exerciseLog")
                .whereField("week", isEqualTo: week)
                .whereField("exerciseDay", isEqualTo: day)
                .getDocuments()
            try await processDocuments(snapshot.documents, forWeek: week, andDay: day)
        } catch {
            print("Error querying documents for week \(week), day \(day):", error.localizedDescription)
        }
    }

    // Function to process queried documents and calculate average difficulty
    private func processDocuments(_ documents: [QueryDocumentSnapshot], forWeek week: Int, andDay day: Int) async throws {
        var totalDifficulty = 0
        var documentCount = 0

        for document in documents {
            let data = document.data()
            if let difficulty = data["difficulty"] as? String {
                switch difficulty {
                case "easy":
                    totalDifficulty += 1 // Assuming easy is represented as 1
                case "medium":
                    totalDifficulty += 2 // Assuming medium is represented as 2
                case "hard":
                    totalDifficulty += 3 // Assuming hard is represented as 3
                default:
                    break
                }
                documentCount += 1
            }
        }

        if documentCount > 0 {
            let averageDifficulty = Double(totalDifficulty) / Double(documentCount)
            print("Average difficulty for week \(week), day \(day): \(averageDifficulty)")
            // Update the averageDifficulties array
            await updateAverageDifficulty(averageDifficulty, forDay: day)
        } else {
            print("No documents with matching criteria found for week \(week), day \(day)")
        }
    }

    // Function to update the averageDifficulties array
    private func updateAverageDifficulty(_ averageDifficulty: Double, forDay day: Int) {
        averageDifficulties[day - 1] = averageDifficulty
    }
    
    private func updateColor() {
        for button in 1...3 {
            let averageDifficulty = averageDifficulties[button - 1]
            switch averageDifficulty {
            case 0..<1:
                colorOne = button == 1 ? .gray.opacity(0.5) : colorOne
                colorTwo = button == 2 ? .gray.opacity(0.5) : colorTwo
                colorThree = button == 3 ? .gray.opacity(0.5) : colorThree
            case 1..<2:
                colorOne = button == 1 ? .green.opacity(0.3) : colorOne
                colorTwo = button == 2 ? .green.opacity(0.3) : colorTwo
                colorThree = button == 3 ? .green.opacity(0.3) : colorThree
            case 2..<3:
                colorOne = button == 1 ? .green.opacity(0.75) : colorOne
                colorTwo = button == 2 ? .green.opacity(0.75) : colorTwo
                colorThree = button == 3 ? .green.opacity(0.75) : colorThree
            default:
                colorOne = button == 1 ? .green : colorOne
                colorTwo = button == 2 ? .green : colorTwo
                colorThree = button == 3 ? .green : colorThree
            }
        }
        print("We are updating color", colorOne, colorTwo, colorThree)
    }
}

#Preview {
                ExerciseWeek(value: 1, presentingAccount: .constant(false))
}

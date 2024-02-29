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
    @State private var dayOne: String = "Hard"
    @State private var dayTwo: String = "Hard"
    @State private var dayThree: String = "Hard"
    @State private var averageDifficulties: [Double] = [0, 0, 0]
    
    @State private var weeksSince: Int = 0
    private let defaultColor: Color = .green.opacity(0.3)
    @Environment(Account.self) var account
    // Array to store average difficulties for each day
    
    var body: some View {
        VStack {
            HStack {
                workoutButton("Workout 1", tab: Tabs.workout)
                workoutButton("Workout 2", tab: Tabs.workout)
                workoutButton("Workout 3", tab: Tabs.workout) // Apply background color
            }
            .onAppear {
                fetchDocuments(week: value)
            }
            HStack {
                Text("\(dayOne)")
                    .frame(width: 120)
                Text("\(dayTwo)")
                    .frame(width: 120)
                Text("\(dayThree)")
                    .frame(width: 120)
            }
            Button(action: {
                Task {
                    do {
                        weeksSince = try await calculateWeeksElapsed() ?? 0
                    } catch {
                        // Handle error
                        print("Error: \(error)")
                    }
                }
            }) {
                Text("\(weeksSince)")
                    .padding()
            }
        }
    }
    
    init(value: Int, presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
        self.value = value
    }
    
    @ViewBuilder
    func workoutButton(_ title: String, tab: Tabs) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .padding()
        }
        .frame(width: 120, height: 50)
        .background(defaultColor)
        .cornerRadius(8)
    }
    
    private func fetchDocuments(week: Int) {
        Task {
            do {
                if let currentUserID = try await getCurrentUserID() {
                    for day in 1...3 {
                        await queryDocumentsForWeekAndDay(week: week, day: day, currentUserID: currentUserID)
                    }
//                    updateColor()
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
    
    
    // Function to retrieve start day field and calculate weeks elapsed
    private func calculateWeeksElapsed() async throws -> Int? {
        // Get current user ID
        guard let userID = try await getCurrentUserID() else {
            return nil
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
            return nil
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
        startDayDate = calendar.date(byAdding: .day, value: -daysToMonday, to: startDayDate) ?? startDayDate


        // Calculate difference in weeks between start day and current date
        let weeksElapsed = calendar.dateComponents([.weekOfYear], from: startDayDate, to: currentDate).weekOfYear ?? 0
        let roundedWeeksElapsed = weeksElapsed > 0 ? weeksElapsed : 0 // Ensure weeksElapsed is non-negative
        
        return weeksElapsed
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
    
//    private func updateColor() {
//        for button in 1...3 {
//            let averageDifficulty = averageDifficulties[button - 1]
//            switch averageDifficulty {
//            case 0..<1:
//                colorOne = button == 1 ? .gray.opacity(0.5) : colorOne
//                colorTwo = button == 2 ? .gray.opacity(0.5) : colorTwo
//                colorThree = button == 3 ? .gray.opacity(0.5) : colorThree
//            case 1..<2:
//                colorOne = button == 1 ? .green.opacity(0.3) : colorOne
//                colorTwo = button == 2 ? .green.opacity(0.3) : colorTwo
//                colorThree = button == 3 ? .green.opacity(0.3) : colorThree
//            case 2..<3:
//                colorOne = button == 1 ? .green.opacity(0.75) : colorOne
//                colorTwo = button == 2 ? .green.opacity(0.75) : colorTwo
//                colorThree = button == 3 ? .green.opacity(0.75) : colorThree
//            default:
//                colorOne = button == 1 ? .green : colorOne
//                colorTwo = button == 2 ? .green : colorTwo
//                colorThree = button == 3 ? .green : colorThree
//            }
//        }
//        print("We are updating color", colorOne, colorTwo, colorThree)
//    }
}

#Preview {
                ExerciseWeek(value: 1, presentingAccount: .constant(false))
}

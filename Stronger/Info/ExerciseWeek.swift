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
    var difficulty: String
    @State private var dayOne: String = "Hard"
    @State private var dayTwo: String = "Hard"
    @State private var dayThree: String = "Hard"
    @State private var averageDifficulties: [Double] = [-1, -1, -1]
    
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
        }
    }
        
    
    init(value: Int, presentingAccount: Binding<Bool>, difficulty: String) {
        self._presentingAccount = presentingAccount
        self.value = value
        self.difficulty = difficulty
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
                    updateDifficulty()
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
            let snapshot = try await dbe
                .collection("users")
                .document(currentUserID)
                .collection("exerciseLog")
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
                case "Easy":
                    totalDifficulty += 1 // Assuming easy is represented as 1
                case "Medium":
                    totalDifficulty += 2 // Assuming medium is represented as 2
                case "Hard":
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
    
    private func updateDifficulty() {
        for button in 1...3 {
            let averageDifficulty = averageDifficulties[button - 1]
            print("button: \(button), averageDifficulty: \(averageDifficulty)")
            switch averageDifficulty {
            case 0..<1.01:
                dayOne = button == 1 ? "Easy" : dayOne
                dayTwo = button == 2 ? "Easy" : dayTwo
                dayThree = button == 3 ? "Easy" : dayThree
            case 1.01..<2.01:
                dayOne = button == 1 ? "Medium" : dayOne
                dayTwo = button == 2 ? "Medium" : dayTwo
                dayThree = button == 3 ? "Medium" : dayThree
            case 2.01..<4:
                dayOne = button == 1 ? "Hard" : dayOne
                dayTwo = button == 2 ? "Hard" : dayTwo
                dayThree = button == 3 ? "Hard" : dayThree
            default:
                dayOne = button == 1 ? "Incomplete" : dayOne
                dayTwo = button == 2 ? "Incomplete" : dayTwo
                dayThree = button == 3 ? "Incomplete" : dayThree
            }
        }
        print("We are updating difficulty", dayOne, dayTwo, dayThree)
    }
}

#Preview {
    ExerciseWeek(value: 1, presentingAccount: .constant(false), difficulty: "Medium")
}

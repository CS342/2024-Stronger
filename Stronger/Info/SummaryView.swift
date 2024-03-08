//
//  Summary.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/1/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// Store current week in user information.
// This can be updated.
// 

import Firebase
import SpeziAccount
import SpeziMockWebService
import SwiftUI

struct SummaryView: View {
    enum Tabs: String {
        case home
        case workout
        case chatWindow
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }
    @Environment(Account.self) var account
    
    @State private var presentingAccount = false
    @State private var selectedWeek: Int?
    @State private var targetProtein: Double?

    var body: some View {
        VStack {
            // Welcome message
            if let details = account.details {
                if let name = details.name {
                    Text("Hello \(name.formatted(.name(style: .medium)))")
                        .font(.title)
                        .multilineTextAlignment(.center)
//                        .padding(.bottom, 50)
                } else {
                    Text("Hello")
                }
            } else {
                Text("Hello")
            }
            
            MainPage()

            Text("This Week's Fitness Progress\n")
            ExerciseWeek(value: selectedWeek ?? 3, presentingAccount: $presentingAccount, difficulty: "Hard")
                .padding(.bottom, 20)
            Spacer()
            if selectedWeek != 1 {
                Text("Last Week's Fitness Progress\n")
                    .padding(.top, 10)
                ExerciseWeek(value: (selectedWeek ?? 1) - 1, presentingAccount: $presentingAccount, difficulty: "Medium")
            }
        }
        .onAppear {
            Task {
                selectedWeek = try? await calculateWeeksElapsed()
                print("selected week in summaryView \(selectedWeek)")
                targetProtein = try await getdailyTargetProtein()
                print("Daily target protein intake is \(targetProtein)")
            }
            Task {
                targetProtein = try await getdailyTargetProtein()
                print("Daily target protein intake is \(targetProtein)")
            }
        }
        .padding()
    }
    
    private func getdailyTargetProtein() async throws -> Double {
        guard let details = try await account.details else {
            return 0.0
        }
        if let weight = details.weight {
            let target = Double(weight) * 0.8
            return target
        } else {
            return 0.0
        }
    }

    
    // Function to get the current user ID
   private func getCurrentUserID() async throws -> String? {
       guard let details = try await account.details else {
           return nil
       }
       return details.accountId
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
                return nil
            }
            
        // Get start date from Timestamp
        // Adjust time zones apparently
        var startDayDate = startDayTimestamp.dateValue().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))

        // Get current date
        let currentDate = Date()

        // Get Calendar instance
        let calendar = Calendar.current
        
        // Move start day to closest Monday
        // If startDayDate is Monday, keep it as is, otherwise move it to the previous Monday
        if calendar.component(.weekday, from: startDayDate) != 2 {
            // Calculate days to Monday
            let weekday = calendar.component(.weekday, from: startDayDate)
            let daysToMonday = (weekday - 2) % 7
            startDayDate = calendar.date(byAdding: .day, value: -daysToMonday, to: startDayDate) ?? startDayDate
        }
        // Calculate difference in weeks between start day and current date
        let weeksElapsed = calendar.dateComponents([.weekOfYear], from: startDayDate, to: currentDate).weekOfYear ?? 0
        let roundedWeeksElapsed = weeksElapsed > 0 ? weeksElapsed : 0 // Ensure weeksElapsed is non-negative
        return weeksElapsed + 1 // as we are using 1 based for selected week.
    }
}

extension VerticalAlignment {
    private enum ImageAlignment: AlignmentID {
        static func defaultValue(in tmp: ViewDimensions) -> CGFloat {
            tmp[.top]
        }
    }
    
    static let imageAlignment = VerticalAlignment(ImageAlignment.self)
}

#Preview {
    SummaryView()
}

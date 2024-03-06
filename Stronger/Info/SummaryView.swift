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
    
    // var username: String
    // @State private var firstName: String = ""
    // @State private var lastName: String = ""
    // @State private var exerciseValue: Double = 50
    // @State private var dietValue: Double = 80
    // @State private var totalProtein: Double = 66
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
//                      .padding(.bottom, 50)
                } else {
                    Text("Hello")
                }
            } else {
                Text("Hello")
            }
            
//            if let targetProtein {
//                MainPage(targetProtein: 45.0)
//            } else {
//                
//            }
//                .id(UUID())

            if let target = targetProtein {
                MainPage(target: target)
            } else {
                MainPage(target: 65.0)
            }
            Text("This Week's Fitness Progress\n")
            ExerciseWeek(value: selectedWeek ?? 3, presentingAccount: $presentingAccount, difficulty: "Hard")
                .padding(.bottom, 20)
//            Spacer()
            Spacer()
            Text("Last Week's Fitness Progress\n")
                .padding(.top, 10)
            ExerciseWeek(value: (selectedWeek ?? 1) - 1, presentingAccount: $presentingAccount, difficulty: "Medium")
//            Spacer()
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

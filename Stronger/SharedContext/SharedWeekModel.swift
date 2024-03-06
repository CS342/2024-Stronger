//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import Foundation
import SpeziAccount

class SharedWeekModel: ObservableObject {
    @Published var currentWeek: Int?
//    @Environment(Account.self) var account
//    
//    // Function to get the current user ID
//    private func getCurrentUserID() async throws -> String? {
//        guard let details = try await account.details else {
//            return nil
//        }
//        return details.accountId
//    }
//    // Function to retrieve start day field and calculate weeks elapsed
//    func calculateWeeksElapsed() async throws -> Int? {
//       // Get current user ID
//       guard let userID = try await getCurrentUserID() else {
//           return nil
//       }
//
//       // Reference to Firestore database
//       let dbe = Firestore.firestore()
//
//       // Reference to document for current user
//       let userDocRef = dbe.collection("users").document(userID)
//
//       // Get snapshot of document
//       let userDocSnapshot = try await userDocRef.getDocument()
//
//       // Check if document exists and contains start day field
//       guard let userData = userDocSnapshot.data(),
//             let startDayTimestamp = userData["StartDateKey"] as? Timestamp else {
////           print("did not find start day key", userID)
//           return nil
//       }
//       
////       print("Found start date key", userID)
//       // Get start date from Timestamp
//       var startDayDate = startDayTimestamp.dateValue()
//
//       // Get current date
//       let currentDate = Date()
//
//       // Get Calendar instance
//       let calendar = Calendar.current
//       
//       // Move start day to closest Monday
//       let weekday = calendar.component(.weekday, from: startDayDate)
//       let daysToMonday = (7 - weekday + 2) % 7 // +2 because Sunday is 1-based in `weekday` but we want Monday to be 0-based
////       print ("daysTOMonday \(daysToMonday)")
//       startDayDate = calendar.date(byAdding: .day, value: -daysToMonday, to: startDayDate) ?? startDayDate
////       print("startDayDate \(startDayDate)")
//
//       // Calculate difference in weeks between start day and current date
//       let weeksElapsed = calendar.dateComponents([.weekOfYear], from: startDayDate, to: currentDate).weekOfYear ?? 0
////       print("weeksElapsed \(weeksElapsed)")
//       let roundedWeeksElapsed = weeksElapsed > 0 ? weeksElapsed : 0 // Ensure weeksElapsed is non-negative
////       print("rounded weeks elapsed \(roundedWeeksElapsed)")
//       return weeksElapsed
//   }
}

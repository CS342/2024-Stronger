//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Firebase
import SpeziAccount
import SwiftUI

struct ExerciseLogUploaderView: View {
    @Environment(Account.self) var account
    @State private var currentUserID: String?
    
    var body: some View {
        Button("Upload Exercise Log") {
            Task {
                if let details = try? await account.details {
                    currentUserID = details.accountId
                    await uploadWorkout()
                }
            }
        }
    }
    
    private func uploadExerciseLog() async {
        guard let currentUserID = currentUserID else {
            print("User ID not available")
            return
        }
        
        let date = Date()
        let exercise = "Push-up"
        let exerciseDay = 1
        let exerciseNum = 1
        let reps = 10
        let set = 3
        let week = 1
        
        let dbe = Firestore.firestore()
        
        do {
            try await dbe.collection("users").document(currentUserID).collection("exerciseLog").addDocument(data: [
                "date": date,
                "exercise": exercise,
                "exerciseDay": exerciseDay,
                "exerciseNum": exerciseNum,
                "reps": reps,
                "set": set,
                "week": week
            ])
            print("Document added successfully")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    private func uploadWorkout() {
        // Reference to the Firestore database
        let db = Firestore.firestore()

        // Reference to the "workout" collection
        let workoutCollection = db.collection("workout")

        // Add document for week 1
        workoutCollection.addDocument(data: [
            "week": 1,
            // Add other fields related to week 1 if needed
        ]) { error in
            if let error = error {
                print("Error adding document for week 1: \(error)")
            } else {
                print("Document added successfully for week 1")
            }
        }

        // Add document for week 2
        workoutCollection.addDocument(data: [
            "week": 2,
            // Add other fields related to week 2 if needed
        ]) { error in
            if let error = error {
                print("Error adding document for week 2: \(error)")
            } else {
                print("Document added successfully for week 2")
            }
        }
    }
}

struct ExerciseLogUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogUploaderView()
    }
}

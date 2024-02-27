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
                    await uploadExerciseLog()
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
}

struct ExerciseLogUploaderView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogUploaderView()
    }
}

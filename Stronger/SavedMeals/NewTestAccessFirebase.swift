//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu

// import SwiftUI
// import FirebaseCore
// import FirebaseFirestore
//
// func configureFirebase() -> String {
//     FirebaseApp.configure()
//         return "done"
//     }
// let db = Firestore.firestore()
// let food = "chicken"
// func logData(_ food: String) async -> String {
//     let foodData = [
//         "proteinContent": "31" // Adjusted for demonstration
//         // Add any other data you want to merge here
//     ]
//     do {
//         try await db.collection("protein_content").document(food).setData(foodData, merge: true)
//         print("Document successfully written!")
//     } catch {
//         print("Error writing document: \(error)")
//     }
//     return "done"
// }

// import SwiftUI
// import FirebaseCore
// import FirebaseFirestore
//
// var isFirebaseConfigured = false
//
// func configureFirebase() {
//     if !isFirebaseConfigured {
//         FirebaseApp.configure()
//         isFirebaseConfigured = true
//     }
// }
// let db = Firestore.firestore()
//
// This async function logs data to Firestore
// func logData(_ food: String) async -> String {
//     // Ensure Firebase is configured before proceeding
//     configureFirebase()
//     let foodData = [
//         "proteinContent": "31" // Adjusted for demonstration
//     ]
//     do {
//         try await db.collection("protein_content").document(food).setData(foodData, merge: true)
//         print("Document successfully written!")
//     } catch {
//         print("Error writing document: \(error)")
//     }
//     return "done"
// }
// struct SelectNeworSaved: View {
//     var body: some View {
//         NavigationView {
//             VStack {
//                 Text("Are you logging a new or saved meal?")
//                     .font(.title)
//                     .bold()
//                     .multilineTextAlignment(.center)
//                     .padding()
//
//                 // Custom Divider
//                 Rectangle()
//                     .frame(height: 2)
//                     .foregroundColor(.gray)
//                     .padding(.vertical)
//                 Spacer()
//                 Button("Log Data") {
//                     Task {
//                         // Assuming 'chicken' is the food you want to log
//                         let result = await logData("chicken")
//                         print(result) // This will print "done" when the task is completed
//                     }
//                 }
//                 .foregroundColor(.black)
//                 .font(.headline)
//                 .padding(.vertical, 20)
//                 .padding(.horizontal, 40)
//                 .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 2))
//                 Spacer()
//             }
//         }
//     }
// }
// Preview Provider
// struct SelectNeworSaved_Previews: PreviewProvider {
//     static var previews: some View {
//         SelectNeworSaved()
//     }
// }

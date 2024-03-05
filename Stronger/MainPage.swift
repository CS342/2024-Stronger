//
//  HomePage.swift
//  Stronger
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
//  Created by Tulika Jha on 18/02/24.
//


import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI


struct MainPage: View {
    @State private var userID: String = "jtulika"
    @State private var targetProtein: Float = 45.0
    @State private var currProtein: Float = 0.0
    
    var body: some View {
        @ScaledMetric var proteinVStackSpace = 10
        NavigationView {
        VStack {
                VStack {
                    HStack {
                        ZStack {
                            var fractionComplete: Float = currProtein / targetProtein
                            ProteinRing(fracComplete: fractionComplete)
                            Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", targetProtein)) g")
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.45)
                        Spacer()
                        VStack(spacing: proteinVStackSpace) {
                            Text("Daily Protein")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                            
                            NavigationLink(destination: ChatWindow()) {
                                Text("Log more with ProBot!")
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.45)
                    }.padding()
                    NavigationLink(destination: ProteinStats()) {
                        Text("Weekly Stats")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            
            // Exercise View
//            Text("this is where the exercise buttons/stats will show")
        }
        }
        // .navigationBarTitle("Welcome, Mary")
        .onAppear {
            DispatchQueue.main.async {
                    // Call your function to fetch data and update state variables here
                fetchDataFromFirestore()
            }
        }
    }
    private func fetchDataFromFirestore() {
        let firestoreDB = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let date = Date()
        
        let startOfDay = calendar.startOfDay(for: date)
        let startDateString = dateFormatter.string(from: startOfDay)
        var endDateString = dateFormatter.string(from: startOfDay)
        
        if let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) {
            endDateString = dateFormatter.string(from: endOfDay)
        } else {
            endDateString = dateFormatter.string(from: startOfDay)
        }
        
        let collectionRef = firestoreDB.collection("users").document(userID).collection("ProteinIntake")
        
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            print("User ID: \(userID)")
        } else {
            print("No user is currently signed in.")
        }
        currProtein = 0
        collectionRef.whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: startDateString)
                         .whereField(FieldPath.documentID(), isLessThan: endDateString)
                         .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                             if let temp = querySnapshot {
                                 for document in temp.documents {
                                     if let proteinContentString = document.data()["protein content"] as? String {
                                         if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Float.init) {
                                             currProtein += numericValue
                                         }
                                     }
                                 }
                             } else {
                                 print("No documents found!")
                             }
                         }
    }
}

#Preview {
    MainPage()
}

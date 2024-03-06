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
import SpeziAccount
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI


struct MainPage: View {
    @State private var userID: String = "temp"
    @State private var currProtein: Double = 0.0
    @State private var targetProtein: Double = 0.0
    
    @Environment(Account.self) var account
    
//    private var targetProtein: Double = 0.0
    
    init(target: Double = 0.0) {
        targetProtein = target
        print("targetProtein is = \(targetProtein)")
    }
        
    var body: some View {
        @ScaledMetric var proteinVStackSpace = 10
        NavigationView {
        VStack {
                VStack {
                    HStack {
                        ZStack {
//                            if let tarProtein = targetProtein {
//                                let fractionComplete: Double = currProtein / tarProtein
//                                ProteinRing(fracComplete: fractionComplete)
//                                Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", targetProtein!)) g")
//                            } else {
//                            }
                            
//                            if targetProtein != 0 {
//                                let fractionComplete: Double = currProtein / targetProtein
//                                ProteinRing(fracComplete: fractionComplete)
//                                Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", targetProtein)) g")
//                            } else {
//
//                            }
                            
                            let fractionComplete: Double = currProtein / targetProtein
                            ProteinRing(fracComplete: fractionComplete)
                            Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", targetProtein)) g")
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.45)
//                        Spacer()
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
                    NavigationLink(destination: ProteinStats().id(UUID())) {
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
        .onAppear {
            Task {
                targetProtein = try await getdailyTargetProtein()
            }
            fetchDataFromFirestore()
        }
    }
    
    private func getdailyTargetProtein() async throws -> Double {
        guard let details = try await account.details else {
            return 48.0
        }
        if let weight = details.weight {
            targetProtein = Double(weight) * 0.8
            return targetProtein
        } else {
            return 48.0
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
        
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            print("User ID: \(userID)")
        } else {
            print("No user is currently signed in.")
        }
        
        let collectionRef = firestoreDB.collection("users").document(userID).collection("ProteinIntake")
        
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
                                         if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Double.init) {
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

//
//  HomePage.swift
//  Stronger
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
    @State private var targetProtein: Float = 45
    @State private var currProtein: Float = 0
    
    
    var body: some View {
        @ScaledMetric var proteinVStackSpace = 10
        VStack {
            // Protein View
            ZStack {
                Rectangle()
                    .foregroundColor(Color(white: 0.9, opacity: 0.7))
                HStack {
                    ZStack {
                        ProteinRing(fractionComplete: currProtein / targetProtein)
                        Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", targetProtein)) g")
                    }.frame(width: UIScreen.main.bounds.width * 0.45)
                    Spacer()
                    VStack(spacing: proteinVStackSpace) {
                        Text("Daily Protein")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                                        
                        Text("Hello, \(userID). Your target protein consumption for today is \(String(format: "%.1f", targetProtein)) g. You have consumed \(String(format: "%.1f", currProtein)) g so far.")
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: ChatWindow()) {
                                        Text("Log more with ProBot!")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.45)
                }.padding()
            }.onAppear {
                fetchDataFromFirestore()
            }
            
            // Exercise View
            Rectangle()
                .foregroundColor(.green)
        }
        }
    private func fetchDataFromFirestore() {
        let firestoreDB = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let date = Date()
        
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let startDateString = dateFormatter.string(from: startOfDay)
        let endDateString = dateFormatter.string(from: endOfDay)
        
        let collectionRef = firestoreDB.collection("users").document(userID).collection("ProteinIntake")
        
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            print("User ID: \(userID)")
        } else {
            print("No user is currently signed in.")
        }
        
        collectionRef.whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: startDateString)
                         .whereField(FieldPath.documentID(), isLessThan: endDateString)
                         .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }

                for document in querySnapshot!.documents {
                    if let proteinContentString = document.data()["protein content"] as? String {
                        if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Float.init) {
                            currProtein += numericValue
                        }
                    }
                }
                         }
    }
}

#Preview {
    MainPage()
}

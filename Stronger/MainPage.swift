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
import PDFKit
import SwiftUI
import WebKit

struct PDFViewer: View {
    var body: some View {
        if let path = Bundle.main.path(forResource: "measurements", ofType: "pdf"), let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
            PDFKitView(pdfDocument: pdfDocument)
        } else {
            Text("Unable to load the PDF file.")
        }
    }
}

// Create a PDFKitView to wrap the PDFKit's PDFView
struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update the view if needed
    }
}
struct EstimatePortionButton: View {
    @Binding var showingPDF: Bool

    var body: some View {
        Button(action: {
            showingPDF = true
        }) {
            Text("Estimate Portion Size?")
                
                .font(.system(size: 10))
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding() // Adjust padding as needed
        .sheet(isPresented: $showingPDF) {
            PDFViewer()
        }
    }
}

struct MainPage: View {
    @State private var userID: String = "jtulika"
    @State private var targetProtein: Float = 45.0
    @State private var currProtein: Float = 0.0
    @State private var showingPDF = false
    var body: some View {
        @ScaledMetric var proteinVStackSpace = 0.0000000000000002
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
                            EstimatePortionButton(showingPDF: $showingPDF)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.45)
                    }
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

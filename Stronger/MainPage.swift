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
import SpeziAccount
import SwiftUI
import WebKit

struct PDFViewer: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            if let path = Bundle.main.path(forResource: "measure", ofType: "pdf"), let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                PDFKitView(pdfDocument: pdfDocument)
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .accessibilityLabel("Close")
                    })
            } else {
                Text("Unable to load the PDF file.")
            }
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
            VStack {
                Text("How to estimate").bold()
                Text("portion size?").bold()
            }
                .font(.system(size: 11))
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
    @State private var userID: String = "temp"
    @State private var currProtein: Double = 0.0
    @State private var showingPDF = false
    @Environment(Account.self) var account
            
    var body: some View {
        @ScaledMetric var proteinVStackSpace = 0.0
        NavigationView {
        VStack {
                VStack {
                    HStack {
                        ZStack {
                            let fractionComplete: Double = currProtein / getdailyTargetProtein()
                            ProteinRing(fracComplete: fractionComplete)
                            Text("\(String(format: "%.1f", currProtein)) g/ \(String(format: "%.1f", getdailyTargetProtein())) g")
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.40)
//                        Spacer()
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
                    NavigationLink(destination: ProteinStats().id(UUID())) {
                        Text("Weekly Stats")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
        }
        }
        .task {
            fetchDataFromFirestore()
        }
    }
    
    
    @MainActor
    private func getdailyTargetProtein() -> Double {
        guard let details = account.details else {
            return 48.0
        }
        if let weight = details.weight {
            return Double(weight) * 0.8 / 2.2
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

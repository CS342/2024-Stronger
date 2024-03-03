//
//  ProteinStats.swift
//  Stronger
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
//  Created by Tulika Jha on 25/02/24.
//

import Charts
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI


struct ProteinDataDaily: Identifiable {
    var date: String
    var protein: Double
    var id = UUID()
}


struct ProteinStats: View {
    @State private var userID: String = "jtulika"
    @State private var dailyTargetProtein: Double = 45.0
    @State private var averageWeeklyProtein: Double = 0.0
    @State private var strokeStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4])
    @State private var weeklyData: [ProteinDataDaily] = []
    
    var body: some View {
        VStack {
            Text("Protein Intake Data")
                .font(.title)
            Text("Protein intake in the last 7 days")
                .font(.headline)
            Chart {
                ForEach(weeklyData) { dailyData in
                    BarMark(
                        x: .value("Date", dailyData.date),
                        y: .value("Protein intake (grams)", dailyData.protein),
                        width: 12
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .position(by: .value("Date", dailyData.date))
                    .annotation {
                        Text(verbatim: dailyData.protein.formatted())
                            .font(.caption)
                    }
                }
                RuleMark(y: .value("Target Protein Intake", dailyTargetProtein))
                            .foregroundStyle(.orange)
                            .lineStyle(strokeStyle)
                RuleMark(y: .value("Average Protein Intake", averageWeeklyProtein))
                            .foregroundStyle(.pink)
                            .lineStyle(strokeStyle)
            }
            .chartLegend(position: .bottom, spacing: 20)
            .chartForegroundStyleScale(["Daily target": Color.orange, "Weekly average": Color.pink])
            .frame(height: 300)
            .onAppear {
                fetchDataFromFirestore()
            }
        }
        .padding()
//        .chartXAxis(content: {
//            AxisMarks { value in
//                AxisValueLabel {
//                    if let date = value.as(String.self) {
//                        Text(date)
//                            .rotationEffect(Angle(degrees: -45))
//                            .padding()
//                    }
//                }
//            }
//        }
//        )
    }
    
    private func getLastWeekDates() -> [Date] {
        let calendar = Calendar.current
        var dates = [Date]()
        let today = Date()
        for index in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -index, to: today) {
                dates.append(date)
            }
        }
        dates = dates.reversed()
        return dates
    }
    
    private func fetchDataFromFirestore() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterXLabel = DateFormatter()
        dateFormatterXLabel.dateFormat = "MM-dd"
        
        let dates = getLastWeekDates()
        let calendar = Calendar.current
        
//        var dates = [Date]()
//        let today = Date()
//        
//        for index in 0...6 {
//            if let date = calendar.date(byAdding: .day, value: -index, to: today) {
//                dates.append(date)
//            }
//        }
//        dates = dates.reversed()
        
        let collectionRef = Firestore.firestore().collection("users").document(userID).collection("ProteinIntake")
        
        for date in dates {
            let startOfDay = calendar.startOfDay(for: date)
            var endOfDay = calendar.startOfDay(for: date)
            if let temp = calendar.date(byAdding: .day, value: 1, to: startOfDay) {
                endOfDay = temp
            } else {
                endOfDay = calendar.startOfDay(for: date)
            }
//            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            let startDateString = dateFormatter.string(from: startOfDay)
            let endDateString = dateFormatter.string(from: endOfDay)
            
            if let currentUser = Auth.auth().currentUser {
                userID = currentUser.uid
                print("User ID: \(userID)")
            } else {
                print("No user is currently signed in.")
            }
            
            let storeDateString = dateFormatterXLabel.string(from: startOfDay)
            var proteinContent = 0.0
            
            collectionRef.whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: startDateString)
                             .whereField(FieldPath.documentID(), isLessThan: endDateString)
                             .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        return
                    }
                     if let allDocuments = querySnapshot.documents {
                         for document in allDocuments {
                             if let proteinContentString = document.data()["protein content"] as? String {
                                 if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Double.init) {
                                     proteinContent += numericValue
                                 }
                             }
                         }
                     } else {
                         print("There are no documents for startDate = \(startOfDay) and endDate = \(endOfDay)")
                     }
//                    for document in querySnapshot!.documents {
//                        if let proteinContentString = document.data()["protein content"] as? String {
//                            if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Double.init) {
//                                proteinContent += numericValue
//                            }
//                        }
//                    }
                 print("Protein content value is \(proteinContent)")
                 averageWeeklyProtein += (proteinContent / 7)
                 weeklyData.append(.init(date: storeDateString, protein: proteinContent))
                             }
        }
    }
}

#Preview {
    ProteinStats()
}

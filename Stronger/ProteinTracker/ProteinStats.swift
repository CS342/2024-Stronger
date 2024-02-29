//
//  ProteinStats.swift
//  Stronger
//
//  Created by Tulika Jha on 25/02/24.
//

import Charts
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct ProteinStats: View {
    @State private var userID: String = "jtulika"
    @State private var weeklyData: [ProteinDataDaily] = []
    @State private var dailyTargetProtein: Double = 45.0
    @State private var averageWeeklyProtein: Double = 0.0
    
    struct ProteinDataDaily: Identifiable {
        var date: String
        var protein: Double
        var id = UUID()
    }
    
    let strokeStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4])

//    var weeklyData: [ProteinDataDaily] = [
//        .init(date: "02-25", protein: 30),
//        .init(date: "02-23", protein: 15),
//        .init(date: "02-20", protein: 20),
//        .init(date: "02-11", protein: 45),
//        .init(date: "02-12", protein: 30),
//        .init(date: "02-13", protein: 15),
//        .init(date: "02-14", protein: 20)
//    ]
    
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
    
    private func fetchDataFromFirestore() {
        let firestoreDB = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterXLabel = DateFormatter()
        dateFormatterXLabel.dateFormat = "MM-dd"
        
        let calendar = Calendar.current
        var dates = [Date]()
        let today = Date()
        
        for index in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -index, to: today) {
                dates.append(date)
            }
        }
        dates = dates.reversed()
        
        let collectionRef = firestoreDB.collection("users").document(userID).collection("ProteinIntake")
        
        for date in dates {
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
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
                    for document in querySnapshot!.documents {
                        if let proteinContentString = document.data()["protein content"] as? String {
                            if let numericValue = proteinContentString.components(separatedBy: " ").first.flatMap(Double.init) {
                                proteinContent += numericValue
                            }
                        }
                    }
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

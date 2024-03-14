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
import SpeziAccount
import SwiftUI

struct ProteinDataDaily: Identifiable {
    var date: String
    var protein: Double
    var id = UUID()
}

struct ProteinStats: View {
    @State private var userID: String = "temp"
    @State private var dailyTargetProtein: Double = 45.0
    @State private var averageWeeklyProtein: Double = 0.0
    @State private var strokeStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4])
    @State private var weeklyData: [ProteinDataDaily] = []

    @Environment(Account.self) var account

    var body: some View {
        VStack {
            Text("Protein Intake Data")
                .font(.title)
            Spacer()
            Spacer()

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

            Spacer()

            Text(getTextualSummary())

            Spacer()
        }
        .padding()
        .task {
            try? await fetchDataFromFirestore()
            weeklyData.sort { $0.date < $1.date }
            print(weeklyData)
            dailyTargetProtein = (try? await getdailyTargetProtein()) ?? 48.0
        }
    }

    @MainActor
    private func getTextualSummary() -> String {
        let target = (dailyTargetProtein * 10).rounded() / 10
        let avg = (averageWeeklyProtein * 10).rounded() / 10
        let message = """
your daily protein target is \(target) g. You have consumed an average of \(avg) g \
of protein per day this week.
"""
        if let details = account.details {
            if let name = details.name {
                if let givenName = name.givenName {
                    return "Hello \(givenName), " + message
                } else {
                    return "Hello, " + message
                }
            } else {
                return "Hello, " + message
            }
        } else {
            return "Hello, " + message
        }
    }

    private func getLastWeekDates() -> [Date] {
        var calendar = Calendar(identifier: .gregorian)
        if let tzPST = TimeZone(identifier: "America/Los_Angeles") {
            calendar.timeZone = tzPST
        } else {
        }
        var dates = [Date]()
        let today = Date()
        print("today = \(today)")
        for index in 0...6 {
            if let date = calendar.date(byAdding: .day, value: -index, to: today) {
                dates.append(date)
            }
        }
        return dates.reversed()
    }

    private func getUserID() -> String {
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            print("User ID: \(userID)")
        } else {
            print("No user is currently signed in.")
        }
        return userID
    }

    private func getdailyTargetProtein() async throws -> Double {
        guard let details = try await account.details else {
            return dailyTargetProtein
        }
        if let weight = details.weight {
            dailyTargetProtein = Double(weight) * 0.8
            return dailyTargetProtein
        } else {
            return dailyTargetProtein
        }
    }

    private func fetchDataFromFirestore() async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterXLabel = DateFormatter()
        dateFormatterXLabel.dateFormat = "MM-dd"

        let dates = getLastWeekDates()
        var calendar = Calendar(identifier: .gregorian)
        if let tzPST = TimeZone(identifier: "America/Los_Angeles") {
            calendar.timeZone = tzPST
        } else {
        }

        userID = getUserID()

        let collectionRef = Firestore.firestore().collection("users").document(userID).collection("ProteinIntake")
        print("Dates = \(dates)")
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

            let storeDateString = dateFormatterXLabel.string(from: startOfDay)
            var proteinContent = 0.0

            let result = try await collectionRef
                .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: startDateString)
                .whereField(FieldPath.documentID(), isLessThan: endDateString)
                .getDocuments()

            for document in result.documents {
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

        weeklyData.sort { $0.date < $1.date }
    }
}

#Preview {
    ProteinStats()
}

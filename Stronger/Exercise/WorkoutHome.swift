//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Firebase
import SpeziAccount
import SwiftUI

struct WorkoutHome: View {
    @State private var selectedWeek: Int = 0
    @State private var selectedDay: Int = 0
    @Binding var presentingAccount: Bool
    @State private var currentWeek: Int?
    @Environment(Account.self) var account
    
    var body: some View {
        // let weekPicker = Picker("Select Week to input results", selection: $selectedWeek) {
        //     ForEach(0..<4) { index in
        //         Text("Week \(index * 3 + 1)-\(index * 3 + 3)").tag(index)
        //     }
        // }
        // .pickerStyle(SegmentedPickerStyle())
        // .padding()
        let firstSixWeeks = Picker("Select Week to input results", selection: $selectedWeek) {
            ForEach(0..<6) { index in
                Text("Week \(index + 1)").tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()

        let secondSixWeeks = Picker("Select Week to input results", selection: $selectedWeek) {
            ForEach(6..<12) { index in
                Text("Week \(index + 1)").tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        let dayPicker = Picker("Select Day", selection: $selectedDay) {
            ForEach(0..<3) { index in
                Text("Day \(index + 1)").tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        return NavigationStack {
            VStack {
                Text("Your current week is \(currentWeek ?? 1)")
                    .font(.headline)
                    .padding()
                // ExerciseLogUploaderView()
                Text("Please select week.")
                // weekPicker
                firstSixWeeks
                secondSixWeeks
                Spacer()
                Text("Please select Exercise Date")
                dayPicker
                Spacer()
                NavigationLink(destination:
                               WorkoutSelection(presentingAccount: $presentingAccount,
                                                selectedWeek: selectedWeek + 1,
                                                selectedDay: selectedDay + 1)) {
                    Text("Enter Workout Information\n for Week \(selectedWeek + 1) Day \(selectedDay + 1).")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                Spacer()
            }
            .navigationBarTitle("Workout Home")
            .onAppear {
                fetchCurrentWeek()
            }
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }

    private func fetchCurrentWeek() {
        Task {
            do {
                if let details = try await account.details {
                    let currentUserID = details.accountId
                    let db = Firestore.firestore()
                    db.collection("users").document(currentUserID).getDocument { document, _ in
                        if let document = document, document.exists {
                            let data = document.data()
                            self.currentWeek = data?["curWeek"] as? Int
                        } else {
                            print("Document does not exist", details.accountId)
                        }
                    }
                }
            } catch {
                print("Error fetching current week:", error)
            }
        }
    }
}

//
// struct WorkoutHome: View {
//    @State private var selectedWeek: Int = 0
//    @State private var selectedDay: Int = 0
//    @Binding var presentingAccount: Bool
//    @State private var currentWeek: Int?
//    @Environment(Account.self) var account
//    
//    var body: some View {
//        NavigationStack{
//            VStack {
//                Text("Your current week is \(currentWeek ?? 1)").font(.headline).padding()
//
//                Picker("Select Week to input results", selection: $selectedWeek) {
//                    ForEach(0..<4) { index in
//                        Text("Week \(index * 3 + 1)-\(index * 3 + 3)").tag(index)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle()).padding()
//                
//                Picker("Select Day", selection: $selectedDay) {
//                    ForEach(0..<3) { index in
//                        Text("Day \(index + 1)").tag(index)
//                    }
//                }.pickerStyle(SegmentedPickerStyle()).padding()
//                
//                NavigationLink(destination:
//                               WorkoutSelection(presentingAccount: $presentingAccount, selectedWeek: selectedWeek + 1, selectedDay: selectedDay + 1)){
//                    Text("Navigate to New View").padding().background(Color.blue).foregroundColor(.white).cornerRadius(8)
//                }.padding()
//            }.navigationBarTitle("Workout Home")
//            .onAppear {
//                Task {
//                    if let details = try? await account.details {
//                        let currentUserID = details.accountId
//                        let db = Firestore.firestore()
//                        db.collection("users").document(currentUserID).getDocument { document, error in
//                            if let document = document, document.exists {
//                                let data = document.data()
//                                self.currentWeek = data?["curWeek"] as? Int
//                            } else {
//                                print("Document does not exist", details.accountId)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    init(presentingAccount: Binding<Bool>) {
//        self._presentingAccount = presentingAccount
//    }
//
//    private func fetchCurrentWeek() {
//        var currentUserID = "12345"
//        let db = Firestore.firestore()
//        if let details = account.details {
//            currentUserID = details.userId
//        } else {
//            return
//        }
//        // Assuming the current user's ID is known and stored somewhere
//        // Replace with actual user ID
//        
//        db.collection("users").document(currentUserID).getDocument { document, error in
//            if let document = document, document.exists {
//                let data = document.data()
//                self.currentWeek = data?["curWeek"] as? Int
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
// }

//
//  WorkoutHome.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/6/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import SwiftUI


struct WorkoutSelection: View {
    // Struct to hold view and string data
    struct MenuItem {
        var view: WorkoutInputForm
        var title: String
    }
    @State private var menuItems: [MenuItem] = []
    @Binding var presentingAccount: Bool
    
    private var selectedWeek: Int
    private var selectedDay: Int
    
    init(presentingAccount: Binding<Bool>, selectedWeek: Int, selectedDay: Int) {
        self._presentingAccount = presentingAccount
        self.selectedWeek = selectedWeek
        self.selectedDay = selectedDay
    }
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
                Text("Workout Home")
                    .font(.title)
                    .padding()
                
                // Use the initialized menuItems array
                ForEach(menuItems, id: \.title) { menuItem in
                    WorkoutHomeButton(presentingAccount: $presentingAccount,
                                      item: menuItem.title, totalWidth: widthForMenuItems(in: geometry))
                }
                
                Spacer()
            }
            .navigationBarTitle("Workout Selection")
            .onAppear {
                fetchMenuItemsFromFirestore()
            }
            // .navigationBarHidden(true) // Hide the navigation bar
            //                 .toolbar {
            //                     if AccountButton.shouldDisplay {
            //                         AccountButton(isPresented: $presentingAccount)
            //                     }
            //                 }
            
        }
    }
    
    private func widthForMenuItems(in geometry: GeometryProxy) -> CGFloat {
        // Calculate the width of the longest title
        let longestTitleWidth = menuItems.map { menuItem in
            menuItem.title.widthOfString(usingFont: .systemFont(ofSize: 17)) // Adjust font size as needed
        }.max() ?? 0
        print(longestTitleWidth)
        // Calculate the width as a percentage of the screen width
        let desiredWidth = longestTitleWidth + 32 // Add padding
        
        // Ensure the width does not exceed the screen width
        return min(desiredWidth, geometry.size.width * 0.5) // Set width as 50% of screen width
    }
    
    
    @State private var geometry: CGSize = .zero
    
    private func fetchMenuItemsFromFirestore() {
        print("Fetch MenuItems from firestore", "week\(self.selectedWeek)", "day\(self.selectedDay)")
        let dbe = Firestore.firestore()
        
        dbe.collection("workouts").document("week\(self.selectedWeek)").collection("day\(self.selectedDay)").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching menu items: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            documents.map { document in
                let data = document.data()
                if let exercises = data["exercises"] as? [String] {
                    self.menuItems = exercises.map { exercise in
                        MenuItem(view: WorkoutInputForm(workoutName: exercise, presentingAccount: $presentingAccount), title: exercise)
                        //                return MenuItem(view: WorkoutInputForm(workoutName: exerciseName, presentingAccount: $presentingAccount), title: exerciseName)
                    }
                }
            }
        }
    }

    
    private func fetchWorkoutsFromFirebase(completion: @escaping ([MenuItem]?, Error?) -> Void) {
        let dbe = Firestore.firestore()
        dbe.collection("workouts").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            
            let menuItems = documents.compactMap { document -> MenuItem? in
                let data = document.data()
                let title = data["title"] as? String ?? ""
                let view = WorkoutInputForm(workoutName: title, presentingAccount: self.$presentingAccount)
                return MenuItem(view: view, title: title)
            }
            completion(menuItems, nil)
        }
    }
    
    private func uploadUserData() {
        let dbe = Firestore.firestore()
        
        // Data to be uploaded
        let userData: [String: Any] = [
            "name": "Rohan Gondor",
            "role": "admin"
        ]
        
        // Upload data to Firestore
        dbe.collection("users").document("admin").setData(userData) { error in
            if let error = error {
                print("Error uploading user data: \(error.localizedDescription)")
            } else {
                print("User data uploaded successfully!")
            }
        }
    }
}
  

// Extension to calculate the width of a string
extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSelection(presentingAccount: .constant(false), selectedWeek: 1, selectedDay: 1 )
    }
}

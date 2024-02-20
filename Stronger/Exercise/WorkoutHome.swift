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

import SwiftUI

struct WorkoutHome: View {
    // Struct to hold view and string data
    struct MenuItem {
        var view: WorkoutInputForm
        var title: String
    }
    
    // Array of MenuItem structs
    // TODO Modify to pull workouts from database of update to schedule.
    
    private var menuItems: [MenuItem] = [
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 1", presentingAccount: .constant(false)), title: "Workout 1"),
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 2", presentingAccount: .constant(false)), title: "Workout 2"),
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 3", presentingAccount: .constant(false)), title: "Workout 3")
    ]
    
    @Binding var presentingAccount: Bool
    
    var body: some View {
        VStack {
            Text("Workout Home")
                .font(.title)
                .padding()
            
            ForEach(menuItems, id: \.title) { menuItem in
                HStack {
                    NavigationLink(destination: WorkoutVideoView()) {
                        Image( "woman_workout_leg", label: Text("Workout")) .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 180)
                            .clipped()
                    }

                    NavigationLink(destination: menuItem.view) {
                        Text(menuItem.title)
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove default button styling
                .padding()
            }
            
            Spacer()
            NavigationLink(destination: HomeReal().navigationBarBackButtonHidden(true)) {
                        Text("Home")
                            .modifier(NavButton())
            }
        }
        .navigationBarTitle("Workout Home")
        // .navigationBarBackButtonHidden(true) // Hide the back button on this view
        // .isDetailLink(false)
        .navigationBarHidden(true) // Hide the navigation bar
        .toolbar {
            if AccountButton.shouldDisplay {
                AccountButton(isPresented: $presentingAccount)
            }
        }
    }
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHome(presentingAccount: .constant(false))
    }
}

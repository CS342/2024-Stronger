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
    private var menuItems: [MenuItem] = [
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 1"), title: "Workout 1"),
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 2"), title: "Workout 2"),
        MenuItem(view: WorkoutInputForm(workoutName: "Workout 3"), title: "Workout 3")
    ]
    
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHome()
    }
}

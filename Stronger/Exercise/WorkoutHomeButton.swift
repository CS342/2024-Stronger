//
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
//  WorkoutHomeButton.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/25/24.
//

import SwiftUI

struct WorkoutHomeButton: View {
    let viewModel = ExerciseViewModel()
    static var exerciseName = "Rows" // Specify name here
    
    
    @Binding var presentingAccount: Bool

    private var item: String
    private var totalWidth: CGFloat
    private var selectedWeek: Int
    private var selectedDay: Int
    
    var body: some View {
        let navLink = NavigationLink(
            destination: WorkoutInputForm(
                workoutName: item,
                presentingAccount: $presentingAccount,
                selectedWeek: selectedWeek,
                selectedDay: selectedDay
            )
        ) {
            Text(item)
                .foregroundColor(.primary)
                .padding()
                .frame(width: totalWidth)
                .background(Color.blue)
                .cornerRadius(8)
        }
        
        GeometryReader { geometry in
            HStack {
                Spacer()
                // Optional binding to safely unwrap `exercise`
                Group {
                    let exercise = viewModel.exerciseByName(item)
                    if let safeExercise = exercise {
                        NavigationLink(destination: WorkoutVideoView(exercise: safeExercise)) {
                            Image("woman_workout_leg")
                                .resizable()
                                .accessibilityLabel("Woman working out")
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 180)
                                .clipped()
                        }
                    } else {
                        // Here you can handle the nil case as you see fit
                        Image("woman_workout_leg")
                            .resizable()
                            .accessibilityLabel("No workout available")
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 180)
                            .clipped()
                        // Maybe add some disabled state or message
                    }
                }
                .frame(width: geometry.size.width * 0.3) // Set width as 30% of screen width
                Spacer()

                navLink
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
    
    init
    (
        presentingAccount: Binding<Bool>,
        item: String,
        totalWidth: CGFloat,
        selectedWeek: Int,
        selectedDay: Int
    ) {
        self._presentingAccount = presentingAccount
        self.item = item
        self.totalWidth = totalWidth
        self.selectedWeek = selectedWeek
        self.selectedDay = selectedDay
    }
}

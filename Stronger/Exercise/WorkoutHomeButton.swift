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
//     struct MenuItem {
//        var view: WorkoutInputForm
//        var title: String
//    }
    
    static var viewModel = ExerciseViewModel()
    static var exerciseName = "Rows" // Specify name here
    let exercise = viewModel.exerciseByName(exerciseName)
            
    @Binding var presentingAccount: Bool

    private var item: String
    private var totalWidth: CGFloat
    private var selectedWeek: Int
    private var selectedDay: Int
    
    var body: some View {
        GeometryReader {geometry in
            HStack {
                Spacer()
                NavigationLink(destination: WorkoutVideoView(exercise: exercise!)) {
                    Image("woman_workout_leg")
                        .resizable()
                        .accessibilityLabel("Woman working out")
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 180)
                        .clipped()
                }
                .frame(width: geometry.size.width * 0.3) // Set width as 30% of screen width
                Spacer()
                NavigationLink(destination: WorkoutInputForm(workoutName: item, presentingAccount: $presentingAccount)) {
                    Text(item)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(width: totalWidth)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
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

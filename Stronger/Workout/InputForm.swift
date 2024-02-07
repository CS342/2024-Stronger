// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct WorkoutInputForm: View {
    var workoutName: String

    @AppStorage("numReps") private var numReps: String = ""
    @State private var selectedBand: String = "Band 1" // Default selection
        let bands = ["Band 1", "Band 2", "Band 3", "Band 4", "Band 5"] // Dropdown options
    @State private var selectedDifficulty: String = "Easy" // Default selection
        let difficulties = ["Easy", "Medium", "Hard"] // Dropdown options
    @State private var currentSet: Int = 1 //
    @State private var showAlert = false
    @State private var navigateToHome = false


    var body: some View {
        NavigationStack {
            Form {
                exerciseInputSection
                submitSection
                Image("WorkoutThumbnail", label: Text("Workout"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 350)
                    .clipped()
            }
            .navigationBarTitle("Input Results")
            .alert(isPresented: $showAlert) { submissionAlert }
            .navigationDestination(isPresented: $navigateToHome) { EmptyView() }
        }
    }

    private var exerciseInputSection: some View {
        Section(header: Text("\(workoutName): Set \(String(currentSet))")) {
            TextField("Number of Reps", text: $numReps)
            Picker("Select Band", selection: $selectedBand) {
                ForEach(bands, id: \.self) { Text($0).tag($0) }
            }
            Picker("Select Difficulty", selection: $selectedDifficulty) {
                ForEach(difficulties, id: \.self) { Text($0).tag($0) }
            }
        }
    }

    private var submitSection: some View {
        Section {
            HStack {
                Spacer()
                Button("Submit", action: submitForm)
                Spacer()
            }
        }
    }

    private var submissionAlert: Alert {
        Alert(
            title: Text("Great Job!"),
            message: Text("Is this your last set for this exercise?"),
            primaryButton: .destructive(Text("Yes")) {
                navigateToHome = true
            },
            secondaryButton: .cancel(Text("No")) {
                currentSet += 1
            }
        )
    }

    private func submitForm() {
        showAlert = true
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputForm(workoutName: "Squats")
    }
}

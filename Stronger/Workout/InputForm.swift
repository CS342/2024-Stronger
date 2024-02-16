// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct WorkoutInputForm: View {
    var workoutName: String = "Squats"
    @AppStorage("numReps") private var numReps: String = ""
    @State private var selectedBand: String = "Band 1"
    let bands = ["Band 1", "Band 2", "Band 3", "Band 4", "Band 5"]
    @State private var selectedDifficulty: String = "Easy"
    let difficulties = ["Easy", "Medium", "Hard"]
    @State private var currentSet: Int = 1
    @State private var showAlert = false
    @State private var navigateToHome = false
    @State private var totalSets: Int = 3

    var body: some View {
        NavigationStack {
            VStack {
                Text("Input Results")
                    .font(.title)
                    .padding()
                
                Picker("Select Set", selection: $currentSet) {
                    ForEach(1...totalSets, id: \.self) {
                        Text("Set \($0)").tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                formView(forSet: currentSet)
            }
            .alert(isPresented: $showAlert) { submissionAlert }
            .navigationDestination(isPresented: $navigateToHome) { WorkoutHome() }
        }
    }
    
    private func formView(forSet setNumber: Int) -> some View {
            Form {
                Section(header: Text("\(workoutName): Set \(setNumber)")) {
                    TextField("Number of Reps", text: $numReps)
                    Picker("Select Band or Body Weight", selection: $selectedBand) {
                        ForEach(bands, id: \.self) { Text($0).tag($0) }
                    }
                    Picker("Select Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Submit", action: {
                            submitForm(forSet: setNumber)
                        })
                        Spacer()
                    }
                }
                Image("WorkoutThumbnail", label: Text("Workout"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 320)
                    .clipped()
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
                if currentSet < totalSets {
                    currentSet += 1
                }
            }
        )
    }

    private func submitForm(forSet setNumber: Int) {
        if currentSet == totalSets {
            navigateToHome = true
        }
        else {
            showAlert = true
        }
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputForm(workoutName: "Squats")
    }
}

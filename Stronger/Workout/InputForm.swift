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
    let bands = ["Bodyweight", "Band 1", "Band 2", "Band 3", "Band 4", "Band 5"]
    @State private var selectedDifficulty: String = "Easy"
    let difficulties = ["Easy", "Medium", "Hard"]
    @State private var currentSet: Int = 1
    @State private var showAlert = false
    @State private var navigateToHome = false
    @State private var totalSets: Int = 3
    @State private var completedSets = Set<Int>()
    @State private var comments: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Log Resistance Training")
                    .font(.title)
                    .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Spacer()
                        HStack(spacing: 20) {
                            ForEach(1...totalSets, id: \.self) { index in
                                VStack {
                                    HStack {
                                        Text("Set \(index)")
                                        Image(systemName: completedSets.contains(index) ? "checkmark.circle.fill" : "xmark.circle")
                                            .accessibilityLabel(Text("Incomplete"))
                                            .foregroundColor(completedSets.contains(index) ? .green : .red)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(currentSet == index ? Color.blue : Color.gray)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                                    .onTapGesture {
                                        self.currentSet = index
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)
                
                formView(forSet: currentSet)
            }
            .alert(isPresented: $showAlert) { submissionAlert }
            .navigationDestination(isPresented: $navigateToHome) { WorkoutHome() }
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
    
    private func formView(forSet setNumber: Int) -> some View {
            Form {
                Section(header: Text("\(workoutName): Set \(setNumber)")) {
                    TextField("Number of Reps", text: $numReps)
                    Picker("Select Resistance", selection: $selectedBand) {
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
                    .frame(height: 315)
                    .clipped()
            }
    }
    
    private func overlayView(for index: Int) -> some View {
        Group {
            if completedSets.contains(index) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .offset(x: 20, y: 0)
                    .accessibilityLabel(Text("Completed"))
            }
        }
    }
    
    private func submitForm(forSet setNumber: Int) {
        completedSets.insert(setNumber)
        if setNumber == 3 {
            navigateToHome = true
        } else {
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

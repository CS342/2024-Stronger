// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

// swiftlint:disable file_types_order
struct WorkoutInputForm: View {
    var workoutName: String
    @Binding var presentingAccount: Bool

    @AppStorage("numReps") private var numReps: String = ""
    @State private var selectedBand: String = "Band 1"
    let bands = ["Band 1", "Band 2", "Band 3", "Band 4", "Band 5"]
    @State private var selectedDifficulty: String = "Easy"
    let difficulties = ["Easy", "Medium", "Hard"]
    @State private var currentSet: Int = 1
    @State private var showAlert = false
    @State private var navigateToHome = false
    @State private var onFirstSet = true
    @State private var onLastSet = true
    @State private var maxSet: Int = 1
    

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
            .navigationDestination(isPresented: $navigateToHome) { WorkoutHome(presentingAccount: $presentingAccount)
            }
        }
    }
    
    init(workoutName: String, presentingAccount: Binding<Bool>) {
            self._presentingAccount = presentingAccount
            self.workoutName = workoutName
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
                if !onFirstSet {
                    Button("Back", action: backToSet)
                        .buttonStyle(BackButtonStyle())
                    Spacer()
                    Spacer()
                } else {
                    EmptyView()
                }
                if onLastSet {
                    Button("Submit", action: submitForm)
                        .buttonStyle(SubmitButtonStyle())
                } else {
                    Button("Next Set", action: goToNextSet)
                        .buttonStyle(BackButtonStyle())
                }
            }
            .listRowInsets(EdgeInsets())
        }
        .listRowBackground(Color.clear)
    }

    private var submissionAlert: Alert {
        Alert(
            title: Text("Great Job!"),
            message: Text("Is this your last set for this exercise?"),
            primaryButton: .destructive(Text("Yes")) {
                navigateToHome = true
            },
            secondaryButton: .cancel(Text("No")) {
                onFirstSet = false
                onLastSet = true
                currentSet += 1
                maxSet += 1
            }
        )
    }
    
    private func backToSet() {
        currentSet -= 1
        onLastSet = false
        if currentSet == 1 {
            onFirstSet = true
        }
    }
    
    private func goToNextSet() {
        currentSet += 1
        onFirstSet = false
        if currentSet == maxSet {
            onLastSet = true
        }
    }

    private func submitForm() {
        showAlert = true
    }
}

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .foregroundColor(.blue)
    }
}

struct SubmitButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .foregroundColor(.red)
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputForm(workoutName: "Squats", presentingAccount: .constant(false))
    }
}

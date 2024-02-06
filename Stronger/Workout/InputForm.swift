
// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct InputForm: View {
    @AppStorage("numReps") private var numReps: String = ""
    @State private var selectedBand: String = "Band 1" // Default selection
        let bands = ["Band 1", "Band 2", "Band 3", "Band 4", "Band 5"] // Dropdown options
    @State private var selectedDifficulty: String = "Easy" // Default selection
        let difficulties = ["Easy", "Medium", "Hard"] // Dropdown options
    @State private var currentSet: Int = 1 //
    @State private var showAlert = false // State to control the alert visibility
    @State private var navigateToHome = false


    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Squats: Set \(String(currentSet))")) {
                    TextField("Number of Reps", text: $numReps)
                    
                    // Dropdown Picker
                    Picker("Select Band", selection: $selectedBand) {
                        ForEach(bands, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                    // Dropdown Picker
                    Picker("Select Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Submit") {
                            showAlert = true
                            print("Form submitted")
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Input Results")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Great Job!"),
                    message: Text("Is this your last set for this exercise?"),
                    primaryButton: .destructive(Text("Yes")) {
                        navigateToHome = true
                        print("Yes, it's the last set")
                    },
                    secondaryButton: .cancel(Text("No")) {
                        currentSet += 1
                        print("No, it's not the last set")
                    }
                )
            }
            .navigationDestination(isPresented: $navigateToHome) {
                EmptyView() // Placeholder destination view
            }
        }
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        InputForm()
    }
}

//
//  InputForm.swift
//  Stronger
//
//  Created by Mena Hassan on 1/30/24.
//

import SwiftUI

struct InputForm: View {
    @AppStorage("numReps") private var numReps: String = ""
    @State private var selectedBand: String = "Band 1" // Default selection
        let bands = ["Band 1", "Band 2", "Band 3", "Band 4", "Band 5"] // Dropdown options
    @State private var selectedDifficulty: String = "Easy" // Default selection
        let difficulties = ["Easy", "Medium", "Hard"] // Dropdown options

    var body: some View {
        NavigationStack {
            Form {
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
            .navigationBarTitle("Input Results")
        }
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        InputForm()
    }
}

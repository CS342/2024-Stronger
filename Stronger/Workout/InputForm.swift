// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Firebase
import SpeziAccount
import SwiftUI

struct WorkoutInputForm: View {
    struct WorkoutData: Codable {
        var reps: String
        var band: String
        var difficulty: String
    }
    @Environment(Account.self) var account
    var workoutName: String = "Squats"
    
    
    @Binding var presentingAccount: Bool
    @State private var selectedWeek: Int = 1
    @State private var imageName: String = "WorkoutThumbnail"
    @State private var selectedDay: Int = 1
    @State private var numReps: String = ""
    @State private var selectedBand: String = "Band 1"
    @State private var currentUserID: String?
    let bands = ["Bodyweight", "Band 1", "Band 2", "Band 3", "Band 4", "Band 5", "Band 6", "Band 7", "Band 8"]
    @State private var selectedDifficulty: String = "Easy"
    let difficulties = ["Easy", "Medium", "Hard"]
    @State private var currentSet: Int = 1
    @State private var showAlert = false
    @State private var navigateToHome = false
    @State private var totalSets: Int = 3
    @State private var completedSets = Set<Int>()
    @State private var comments: String = ""
    @State private var populateWithPreviousData = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Log \(workoutName)")
                    .font(.title)
                    .padding()
                setsDisplay()
                formView(forSet: currentSet)
            }
            .alert(isPresented: $showAlert) { submissionAlert }
            .navigationDestination(isPresented: $navigateToHome) { WorkoutHome(presentingAccount: $presentingAccount) }
            .onChange(of: populateWithPreviousData) {
                handleToggleChange(to: populateWithPreviousData)
            }
        }
    }
    
    
    private var submissionAlert: Alert {
        Alert(
            title: Text("Great Job!"),
            message: Text("Is this your last set for this exercise?"),
            primaryButton: .destructive(Text("Yes")) {
                print("current account", account)
                Task {
                    await self.uploadExerciseData()
                }
                navigateToHome = true
            },
            secondaryButton: .cancel(Text("No")) {
                if currentSet < totalSets {
                    currentSet += 1
                }
            }
        )
    }

    // init(workoutName: String, presentingAccount: Binding<Bool>, selectedWeek: Int, selectedDay: Int) {
    //     self.workoutName = workoutName
    //     self._presentingAccount = presentingAccount
    //     self.selectedWeek = selectedWeek
    //     self.selectedDay = selectedDay
    // }
    
    private func setsDisplay() -> some View {
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
    }
    
    private func handleToggleChange(to newValue: Bool) {
        if newValue {
            loadPreviousWorkoutData()
        } else {
            resetToDefaultValues()
        }
    }

    private func loadPreviousWorkoutData() {
        if let workoutData = loadWorkoutData(for: workoutName) {
            numReps = workoutData.reps
            selectedBand = workoutData.band
            selectedDifficulty = workoutData.difficulty
        }
    }

    private func resetToDefaultValues() {
        numReps = "" // Or your default "starting" value for reps
        selectedBand = bands.first ?? "Band 1" // Reset to the first band or a default
        selectedDifficulty = difficulties.first ?? "Easy" // Reset to the first difficulty or a default
    }
    
    private func uploadExerciseData() async {
        await uploadExerciseLog()
    }
    
    private func uploadExerciseLog() async {
        print(account)
        guard let details = await account.details else {
            print("User ID not available")
            return
        }
        let currentUserID = details.accountId
        let date = Date()
        let exercise = workoutName
        let exerciseNum = 1
        let reps = Int(numReps) ?? 0
        let set = currentSet
        let difficulty = selectedDifficulty
        let band = selectedBand
        let datab = Firestore.firestore()
        
        do {
            try await datab.collection("users").document(currentUserID).collection("exerciseLog").addDocument(data: [
                "date": date,
                "exercise": exercise,
                "exerciseDay": selectedDay,
                "exerciseNum": exerciseNum,
                "reps": reps,
                "set": set,
                "week": selectedWeek,
                "band": band,
                "difficulty": difficulty
            ])
            print("Document added successfully")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    private func formView(forSet setNumber: Int) -> some View {
        Form {
            toggleSection()
            Section(header: Text("Set \(setNumber)")) {
                repsInputSection()
                pickersSection()
            }
            submitButtonSection(forSet: setNumber)
            workoutThumbnail()
        }
    }

    private func toggleSection() -> some View {
        Toggle(isOn: $populateWithPreviousData) {
            Text("Populate with previous workout data")
        }
    }

    private func repsInputSection() -> some View {
        HStack {
            Text("Reps")
            Spacer()
            TextField("", text: $numReps)
                .frame(width: 80)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
        }
    }

    private func pickersSection() -> some View {
        Section {
            Picker("Select Resistance", selection: $selectedBand) {
                ForEach(bands, id: \.self) { Text($0).tag($0) }
            }
            Picker("Select Difficulty", selection: $selectedDifficulty) {
                ForEach(difficulties, id: \.self) { Text($0).tag($0) }
            }
        }
    }

    private func submitButtonSection(forSet setNumber: Int) -> some View {
        Section {
            HStack {
                Spacer()
                Button("Submit") {
                    submitForm(forSet: setNumber)
                }
                Spacer()
            }
        }
    }

    private func workoutThumbnail() -> some View {
        Image(imageName, label: Text("Workout"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 315)
            .clipped()
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
    
    private func saveWorkoutData() {
        let workoutData = WorkoutData(reps: numReps, band: selectedBand, difficulty: selectedDifficulty)
        if let encodedData = try? JSONEncoder().encode(workoutData) {
            UserDefaults.standard.set(encodedData, forKey: "workoutData_\(workoutName)")
        }
    }
    
    private func loadWorkoutData(for workoutName: String) -> WorkoutData? {
        if let savedWorkoutData = UserDefaults.standard.object(forKey: "workoutData_\(workoutName)") as? Data {
            let decoder = JSONDecoder()
            if let loadedWorkoutData = try? decoder.decode(WorkoutData.self, from: savedWorkoutData) {
                return loadedWorkoutData
            }
        }
        return nil
    }
    
    private func submitForm(forSet setNumber: Int) {
        completedSets.insert(setNumber)
        if setNumber == 3 {
            navigateToHome = true
        } else {
            showAlert = true
        }
        saveWorkoutData()
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputForm(workoutName: "Squats", presentingAccount: .constant(false))
    }
}

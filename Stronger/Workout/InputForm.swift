// This source file is part of the Stronger project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Firebase
import SpeziAccount
import SwiftUI

struct RepsInputSection: View {
    @Binding var numReps: String

    var body: some View {
        HStack {
            Text("Reps")
            Spacer()
            TextField("", text: $numReps)
                .frame(width: 80)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("Reps")
        }
    }
}

struct PickersSection: View {
    @Binding var selectedBand: String
    @Binding var selectedDifficulty: String
    let bands: [String]
    let difficulties: [String]

    var body: some View {
        Section {
            Picker("Select Resistance", selection: $selectedBand) {
                ForEach(bands, id: \.self) { band in
                    Text(band).tag(band)
                }
            }.accessibilityIdentifier("Select Resistance")
            Picker("Select Difficulty", selection: $selectedDifficulty) {
                ForEach(difficulties, id: \.self) { difficulty in
                    Text(difficulty).tag(difficulty)
                }
            }.accessibilityIdentifier("Select Difficulty")
        }
    }
}

struct SetsDisplayView: View {
    let totalSets: Int
    var completedSets: Set<Int>
    var loggedSets: Set<Int>
    @Binding var currentSet: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                HStack(spacing: 20) {
                    ForEach(1...totalSets, id: \.self) { idx in
                        setCapsule(forSet: idx)
                    }
                }
                Spacer()
            }
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func setCapsule(forSet setNumber: Int) -> some View {
        VStack {
            HStack {
                Text("Set \(setNumber)")
                Image(systemName: completedSets.contains(setNumber) || loggedSets.contains(setNumber) ? "checkmark.circle.fill" : "xmark.circle")
                    .accessibilityLabel(Text(completedSets.contains(setNumber) || loggedSets.contains(setNumber) ? "Complete" : "Incomplete"))
                    .foregroundColor(completedSets.contains(setNumber) || loggedSets.contains(setNumber) ? .green : .red)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(currentSet == setNumber ? Color.blue : Color.gray)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
            .onTapGesture {
                self.currentSet = setNumber
            }
        }
    }
}

struct WorkoutInputForm: View {
    struct WorkoutData: Codable {
        var reps: String
        var band: String
        var difficulty: String
    }
    let viewModel = ExerciseViewModel()
    
    @Environment(Account.self) var account
    var workoutName: String = "Squats"
    @Binding var presentingAccount: Bool
    @State private var selectedWeek: Int = 1
    
    var imageName: String {
        workoutName.removingNonAlphabeticCharacters2()
    }
    @State private var selectedDay: Int = 1
    @State private var numReps: String = ""
    @State private var selectedBand: String = "Band 1"
    @State private var currentUserID: String?
    let bands = ["Bodyweight", "Band 1", "Band 2", "Band 3", "Band 4", "Band 5", "Band 6", "Band 7", "Band 8"]
    @State private var selectedDifficulty: String = "Easy"
    let difficulties = ["Easy", "Medium", "Hard"]
    @State private var currentSet: Int = 1
    @State private var navigateToWorkoutSelection = false
    @State private var totalSets: Int = 3
    @State private var completedSets = Set<Int>()
    @State private var comments: String = ""
    @State private var populateWithPreviousData = false
    @State private var loggedSets = Set<Int>()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Log \(workoutName)")
                    .font(.title)
                    .padding()
                SetsDisplayView(totalSets: totalSets, completedSets: completedSets, loggedSets: loggedSets, currentSet: $currentSet)
                formView(forSet: currentSet)
            }
            .navigationDestination(isPresented: $navigateToWorkoutSelection) {
                WorkoutSelection(presentingAccount: $presentingAccount)
            }
            .onChange(of: populateWithPreviousData) {
                handleToggleChange(to: populateWithPreviousData)
            }
            .onAppear {
                Task {
                    await fetchLoggedSets()
                }
            }
        }
    }
  
     init(workoutName: String, presentingAccount: Binding<Bool>, selectedWeek: Int, selectedDay: Int) {
         self.workoutName = workoutName
         _presentingAccount = presentingAccount
         _selectedWeek = State(initialValue: selectedWeek)
         _selectedDay = State(initialValue: selectedDay)
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
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    private func fetchLoggedSets() async {
        guard let details = await account.details else {
            print("User ID not available")
            return
        }
        let currentUserID = details.accountId
        let datab = Firestore.firestore()
        let path = datab.collection("users").document(currentUserID).collection("exerciseLog")
        let query = path.whereField("exercise", isEqualTo: workoutName)
                        .whereField("exerciseDay", isEqualTo: selectedDay)
                        .whereField("week", isEqualTo: selectedWeek)
        do {
            let snapshot = try await query.getDocuments()
            self.loggedSets.removeAll()
            for document in snapshot.documents {
                if let setNumber = document.data()["set"] as? Int {
                    self.loggedSets.insert(setNumber)
                }
            }
        } catch {
            print("Error fetching logged sets: \(error)")
        }
    }

    
    private func formView(forSet setNumber: Int) -> some View {
        Form {
            toggleSection()
            Section(header: Text("Set \(setNumber)")) {
                RepsInputSection(numReps: $numReps)
                PickersSection(selectedBand: $selectedBand, selectedDifficulty: $selectedDifficulty, bands: bands, difficulties: difficulties)
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

    private func submitButtonSection(forSet setNumber: Int) -> some View {
        Section {
            HStack {
                Spacer()
                Button("Submit") {
                    submitForm(forSet: setNumber)
                }
                .accessibilityIdentifier("Submit")
                .disabled(numReps.isEmpty) // Disable the button if numReps is empty
                Spacer()
            }
        }
        .foregroundColor(numReps.isEmpty ? .gray : .red)
    }

    private func workoutThumbnail() -> some View {
        Group {
            if let safeExercise = viewModel.exerciseByName(workoutName) {
                NavigationLink(destination: WorkoutVideoView(exercise: safeExercise)) {
                    Image(imageName, label: Text("Workout"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 315)
                        .clipped()
                        .accessibilityIdentifier("WorkoutThumbnail")
                }
            } else {
                Image(imageName, label: Text("Workout"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 315)
                    .clipped()
                    .accessibilityIdentifier("WorkoutThumbnail")
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
        Task {
            await uploadExerciseLog()
            completedSets.insert(setNumber)
            if setNumber >= totalSets {
                navigateToWorkoutSelection = true
            } else {
                currentSet += 1
            }
            saveWorkoutData()
        }
    }
}

extension String {
    func removingNonAlphabeticCharacters2() -> String {
        self.filter { $0.isLetter }
    }
}

// Preview
struct InputForm_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInputForm(workoutName: "Squats", presentingAccount: .constant(false), selectedWeek: 2, selectedDay: 1)
    }
}

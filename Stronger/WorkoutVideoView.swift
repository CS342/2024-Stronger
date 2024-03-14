// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import AVKit
import Foundation
import SwiftUI
struct Exercise: Identifiable, Codable {
    let id = UUID()
    let name: String
    let videoName: String
    let thumbnailName: String?
    let tips: [String]
    
    var videoURL: URL? {
        Bundle.main.url(forResource: videoName, withExtension: "mp4")
    }
}
class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    
    init() {
        loadExercisesFromJSON()
    }
    func loadExercisesFromJSON() {
        guard let url = Bundle.main.url(forResource: "ExerciseInfo", withExtension: "json") else {
            print("ExerciseInfo.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            exercises = try decoder.decode([Exercise].self, from: data)
        } catch {
            print("Error loading exercises: \(error)")
        }
    }
    
    func exerciseByName(_ name: String) -> Exercise? {
        exercises.first { $0.name.lowercased() == name.lowercased() }
    }
}
struct VideoPlayerView: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = true
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    // Fill Later Info
    }
}
private struct TitleView: View {
    var body: some View {
        Text("Stronger")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .bold()
            .foregroundColor(Color.purple)
            .padding(.bottom, 8)
    }
}
private struct ExerciseOverlay: View {
    let overlayText: String
    
    var body: some View {
        Text(overlayText)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.black)
            .padding(10)
            .cornerRadius(10)
    }
}
private struct VideoPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder()
            .foregroundColor(.gray)
            .frame(width: 350, height: 300)
            .overlay(
                Text("Video Placeholder")
                    .foregroundColor(.white)
            )
    }
}
private struct TipsView: View {
    let tips: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                    tipRow(number: "\(index + 1)", text: tip)
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.pink.opacity(0.1))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
    @ViewBuilder
    func tipRow(number: String, text: String) -> some View {
        HStack(alignment: .top) {
            Text("\(number).")
                .bold()
                .foregroundColor(.accentColor)
                .padding(.trailing, 4)
            Text(text)
        }
    }
}
struct WorkoutVideoView: View {
    let exercise: Exercise
    var body: some View {
        VStack {
            TitleView()
            ExerciseOverlay(overlayText: "Play the video to see how to do \(exercise.name)!")
            if let videoURL = exercise.videoURL {
                VideoPlayerView(url: videoURL)
                    .frame(height: 310)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
            } else {
                VideoPlaceholder()
            }
            
            Spacer()
            
            TipsView(tips: exercise.tips)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
struct WorkoutVideoView_Previews: PreviewProvider {
    static var viewModel = ExerciseViewModel()
    static var exerciseName = "Squats" // Specify name here
    
    static var previews: some View {
        Group {
            if let exercise = viewModel.exerciseByName(exerciseName) {
                WorkoutVideoView(exercise: exercise)
            } else {
                Text("Exercise named \(exerciseName) not found")
            }
        }
        .onAppear {
            viewModel.loadExercisesFromJSON() // Make sure the exercises are loaded
        }
    }
}

// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import AVKit
import SwiftUI

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

private struct SquatOverlay: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.yellow)
            .frame(width: 250, height: 74.0)
            .overlay(
                Text("How to Squat!")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.leading)
            )
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

private struct SquatTipsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                tipRow(number: "1", label: "STANCE", text: "Stand with feet shoulder-width apart, toes slightly pointed out.")
                tipRow(number: "2", label: "MOVEMENT", text: "Bend at the hips and knees, sitting back as if into a chair")
                tipRow(number: "3", label: "POSTURE", text: "Keep your back straight and core engaged throughout the " +
                        "movement, driving up through your heels.")
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
    func tipRow(number: String, label: String, text: String) -> some View {
        HStack(alignment: .top) {
            Text("\(number).")
                .bold()
                .foregroundColor(.accentColor)
                .padding(.trailing, 4)

            Text(label)
                .bold() +
            Text(": " + text)
        }
    }
}

struct WorkoutVideoView: View {
    let videoURL: URL? = Bundle.main.url(forResource: "workout", withExtension: "mp4")
    
    var body: some View {
        VStack {
            TitleView()
            SquatOverlay()
            if let videoURL = videoURL {
                VideoPlayerView(url: videoURL)
                    .frame(height: 310)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
            } else {
                VideoPlaceholder()
            }
            
            Spacer()
            
            SquatTipsView()
                .frame(maxWidth: .infinity) //
        }
        .padding()
    }
}

struct WorkoutVideoView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVideoView()
    }
}

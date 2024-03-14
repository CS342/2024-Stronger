//
//  Chatwindow.swift
//  Stronger
//
//  Created by Kevin Zhu and Yanav Lell on 02/28/2024.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// s

import Combine
import CoreML
import SwiftUI
import UIKit
import Vision

// ImageClassifier to handle image processing and classification
class ImageClassifier: ObservableObject {
    @Published var image: UIImage?
    @Published var classificationResults: String = "No results"
    @Published var highestConfidenceClassification: String?
    @Published var showingClassificationOptions = false
    @Published var classificationOptions: [String] = []
    @Published var showAlertAfterLog = false
    @Published var showNextStepOptions = false
    @Published var loggedFoodItems: [String] = []
    @Published var foodLog: [String] = []
    func prepareForNextSteps() {
        DispatchQueue.main.async {
            self.showNextStepOptions = true
        }
    }
    func classifyImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            DispatchQueue.main.async {
                self.classificationResults = "Could not create CIImage from UIImage"
            }
            return
        }

        guard let model = try? VNCoreMLModel(for: SeeFood().model) else {
            DispatchQueue.main.async {
                self.classificationResults = "Failed to load model"
            }
            return
        }

        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else {
                return
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.classificationResults = "Classification failed: \(error.localizedDescription)"
                }
                return
            }

            guard let results = request.results as? [VNClassificationObservation] else {
                DispatchQueue.main.async {
                    self.classificationResults = "Could not process classification results"
                }
                return
            }

            let topResults = results.prefix(3)
            self.classificationOptions = topResults.map { "\($0.identifier) (\(String(format: "%.2f", $0.confidence * 100))%)" }

            if let highestResult = topResults.first {
                DispatchQueue.main.async {
                    self.highestConfidenceClassification = highestResult.identifier
                    self.classificationResults = "Highest: \(highestResult.identifier) Confidence: \(Int(highestResult.confidence * 100))%"
                    self.showingClassificationOptions = true
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            DispatchQueue.main.async {
                self.classificationResults = "Failed to perform classification request: \(error.localizedDescription)"
            }
        }
    }

    func logFoodItem(_ foodItem: String) {
        DispatchQueue.main.async {
            self.loggedFoodItems.append(foodItem)
            self.classificationResults = "\(foodItem) logged."
        }
    }
}

struct FoodImageRecognitionApp: App {
    var body: some Scene {
        WindowGroup {
            ProteinTrackerOptions()
        }
    }
}

// entry point
struct ProteinTrackerOptions: View {
    private var greeting: String {
        "How would you like to input your meal?"
    }

    var body: some View {
        NavigationView {
            VStack {
                Text(greeting)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()

                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray)
                    .padding(.vertical)

                Spacer()
                // Ensure NavigationLink directs to the correct view
                NavigationLink(destination: FoodClassifierApp()) {
                    Text("Input with Camera")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
                NavigationLink(destination: ChatWindow()) {
                    Text("Input with ChatBot")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
}

// PhotoPicker to handle image selection or capturing
struct PhotoPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: PhotoPicker
        var imageClassifier: ImageClassifier

        init(_ parent: PhotoPicker, imageClassifier: ImageClassifier) {
            self.parent = parent
            self.imageClassifier = imageClassifier
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                imageClassifier.image = uiImage // Update the image in ImageClassifier
                imageClassifier.classifyImage(uiImage) // Trigger classification
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    var imageClassifier: ImageClassifier
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self, imageClassifier: imageClassifier)
    }
}

struct EditClassificationView: View {
    @Binding var classification: String?
    @Binding var showingEditView: Bool
    @ObservedObject var imageClassifier: ImageClassifier
    @State private var editableClassification: String = ""
    var onSave: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Classification")
                .font(.headline)

            TextField("Classification", text: $editableClassification)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Classification") {
                classification = editableClassification
                imageClassifier.highestConfidenceClassification = editableClassification
                imageClassifier.logFoodItem(editableClassification)
                showingEditView = false
                // Prepare for showing next step options after editing and logging the classification.
                imageClassifier.prepareForNextSteps()
                onSave()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            // Initialize the editableClassification with the current classification value
            // This is necessary to handle the optional nature of classification
            editableClassification = classification ?? ""
        }
    }
}

// main view
struct FoodClassifierApp: View {
    @StateObject private var imageClassifier = ImageClassifier()
    @State private var showImagePicker = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingEditView = false
    @State private var showNextStepOptions = false
    @State private var navigateToChatAfterCamera = false

    var body: some View {
        // NavigationStack {
            VStack {
                Spacer()
                imageDisplay
                Text(imageClassifier.classificationResults).padding()
                selectOrTakePictureButton
                if let classification = imageClassifier.highestConfidenceClassification {
                    classificationActions(classification: classification)
                }
                if showNextStepOptions {
                    nextStepOptions
                }
                Spacer()

                NavigationLink(
                    destination: ChatWindowAfterCamera(
                        loggedFoodItems: imageClassifier.loggedFoodItems
                    ),
                    isActive: $navigateToChatAfterCamera
                ) {
                    EmptyView()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(imageClassifier: imageClassifier, sourceType: sourceType)
            }
            .alert(isPresented: $imageClassifier.showAlertAfterLog, content: logFoodAlert)
            .navigationTitle("Food Image Classifier")
        // }
    }
    private var selectOrTakePictureButton: some View {
        Button("Select or Take Picture") {
            showingActionSheet = true
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .actionSheet(isPresented: $showingActionSheet, content: selectImageActionSheet)
    }

    private var nextStepOptions: some View {
        HStack { // Change from VStack to HStack to align buttons horizontally
            logAnotherFoodButton
            finishLoggingButton
        }
    }
    private var imageDisplay: some View {
        Group {
            if let image = imageClassifier.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("image")
            } else {
                Text("Tap below to select an image or take a picture")
                    .foregroundColor(.gray)
            }
        }
    }
    private var logAnotherFoodButton: some View {
        Button("Log Another Food") {
            imageClassifier.image = nil
            imageClassifier.classificationResults = "No results"
            imageClassifier.highestConfidenceClassification = nil
            showNextStepOptions = false
            showingActionSheet = true // Reopen the action sheet to select or take a new picture
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }

    private var finishLoggingButton: some View {
        Button("Finish Logging") {
            navigateToChatAfterCamera = true
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)

        .navigationDestination(isPresented: $navigateToChatAfterCamera) {
            ChatWindowAfterCamera(loggedFoodItems: imageClassifier.loggedFoodItems)
        }
    }
    private func classificationActions(classification: String) -> some View {
        HStack {
            logFoodButton(classification: classification)
            editClassificationButton()
        }
    }
    private func selectImageActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Choose an option"),
            buttons: [
                .default(Text("Take Photo")) {
                    self.sourceType = .camera
                    self.showImagePicker = true
                },
                .default(Text("Choose from Library")) {
                    self.sourceType = .photoLibrary
                    self.showImagePicker = true
                },
                .cancel()
            ]
        )
    }
    private func logFoodButton(classification: String) -> some View {
        Button("Log Food") {
            imageClassifier.logFoodItem(classification)
            self.showNextStepOptions = true
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    private func editClassificationButton() -> some View {
        Button("Edit Classification") {
            self.showingEditView = true
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .sheet(isPresented: $showingEditView) {
            // Make sure to pass imageClassifier and onSave closure here
            EditClassificationView(
                classification: $imageClassifier.highestConfidenceClassification,
                showingEditView: $showingEditView,
                imageClassifier: imageClassifier,
                onSave: {
                    self.showNextStepOptions = true
                } // Here is where you pass the imageClassifier
            )
        }
    }
    private func logFoodAlert() -> Alert {
        Alert(
            title: Text("Food Logged"),
            message: Text("What would you like to do next?"),
            primaryButton: .default(Text("Log Another Food")) {
                // Reset the necessary properties to log another food
                self.imageClassifier.image = nil
                self.imageClassifier.classificationResults = "No results"
                self.imageClassifier.highestConfidenceClassification = nil
                self.showImagePicker = true // Open the image picker to log another food
                self.imageClassifier.prepareForNextSteps()
            },
            secondaryButton: .default(Text("Finish Logging")) {
                // Perform any clean-up or navigation as needed to finish logging
            }
        )
    }
    private func resetForNextFoodLogging() {
        imageClassifier.image = nil
        imageClassifier.classificationResults = "No results"
        imageClassifier.highestConfidenceClassification = nil
        showNextStepOptions = false
        showingActionSheet = true // Ready to select or take a new picture
    }
    private func finishLogging() {
        showNextStepOptions = false
        // Any cleanup or final actions
    }
}

extension Binding where Value: ExpressibleByStringLiteral {
    static func orEmpty(_ binding: Binding<Value?>) -> Binding<Value> {
        Binding<Value>(
            get: { binding.wrappedValue ?? "" },
            set: { binding.wrappedValue = $0 }
        )
    }
}

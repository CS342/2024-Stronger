//
//  FoodImageRecognition.swift
//  Stronger
//
//  Created by Kevin Zhu and Yanav Lall on 2/27/24.
//

import CoreML
import SwiftUI
import UIKit
import Vision

struct FoodClassifierApp: View {
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var classificationResults: String = "No results"
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingActionSheet = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Tap below to select an image or take a picture")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(classificationResults)
                    .padding()
                
                Button("Select or Take Picture") {
                    self.showingActionSheet = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .actionSheet(isPresented: $showingActionSheet, content: getActionSheet)
                
                Spacer()
            }
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: self.$image, classificationResults: self.$classificationResults, sourceType: self.sourceType)
            }
            .navigationTitle("Food Image Classifier")
        }
    }

    // Extracted method to configure the action sheet
    func getActionSheet() -> ActionSheet {
        ActionSheet(title: Text("Select Image"), message: nil, buttons: [
            .default(Text("Take Photo")) {
                self.sourceType = .camera
                self.showImagePicker = true
            },
            .default(Text("Choose from Library")) {
                self.sourceType = .photoLibrary
                self.showImagePicker = true
            },
            .cancel()
        ])
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var classificationResults: String
    var sourceType: UIImagePickerController.SourceType // Add this line
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                classifyImage(uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func classifyImage(_ image: UIImage) {
            guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
                parent.classificationResults = "Loading model failed"
                return
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                    self.parent.classificationResults = "Could not classify image."
                    return
                }
                
                DispatchQueue.main.async {
                    self.parent.classificationResults = "Classification: \(topResult.identifier) Confidence: \(Int(topResult.confidence * 100))%"
                }
            }
            
            guard let ciImage = CIImage(image: image) else {
                parent.classificationResults = "Creating CIImage failed"
                return
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                parent.classificationResults = "Image classification failed: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    FoodClassifierApp()
}

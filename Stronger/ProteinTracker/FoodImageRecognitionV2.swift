//
//  FoodImageRecognitionV2.swift
//  Stronger
//
//  Created by Kevin Zhu and Yanav Lall 2/29/24.
//

import SwiftUI
import Vision
import CoreML

struct FoodImageRecognitionV2: View {
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var analysisResult = "Results will appear here."
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Take Photo") {
                self.sourceType = .camera
                self.showImagePicker = true
            }
            .background(Color.blue)
            .foregroundColor(.white)
            
            Button("Choose Photo") {
                self.sourceType = .photoLibrary
                self.showImagePicker = true
            }
            .background(Color.green)
            .foregroundColor(.white)
            
            Spacer()
            
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Text(analysisResult).padding()
            }
            
            Spacer()
            
            Button("Fix Result") {
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Log Food") {
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, analysisResult: self.$analysisResult, sourceType: self.sourceType)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var analysisResult: String
    var sourceType: UIImagePickerController.SourceType
    
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
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                classifyImage(image)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func classifyImage(_ image: UIImage) {
            guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
            
            let request = VNCoreMLRequest(model: model) { request, _ in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        self.parent.analysisResult = "\(topResult.identifier) with confidence \(topResult.confidence)"
                    }
                }
            }
            
            guard let ciImage = CIImage(image: image) else { return }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try? handler.perform([request])
        }
    }
}
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            FoodImageRecognitionV2()
        }
    }
}

#Preview {
    FoodImageRecognitionV2()
}

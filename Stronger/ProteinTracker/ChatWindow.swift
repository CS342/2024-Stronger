//
//  Chatwindow.swift
//  Stronger
//
//  Created by Tulika Jha on 29/01/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SpeziLLM
import SpeziLLMLocal
import SpeziLLMOpenAI
import SwiftUI


func get_protein_content(for foodItem: String, defaultProtein: Int = 0) -> Int {
    let proteinContentMapping = [
        "chicken pasta": 30,
        "chicken salad": 30,
        "chicken sandwich": 35,
        "tuna": 40,
        "salmon": 40,
        "lentils": 11,
        "black beans": 11,
        "omelette": 15
    ]
    
    return proteinContentMapping[foodItem.lowercased()] ?? defaultProtein
}

func log_protein_intake(for totalProteinContent: String, for foodItems: String, defaultTotalProteinContent: String = "") async -> String {
    let firestoreDB = Firestore.firestore()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let onlyDateFormatter = DateFormatter()
    onlyDateFormatter.dateFormat = "yyyy-MM-dd"
    let currentDateString = dateFormatter.string(from: Date())
    let currentOnlyDateString = onlyDateFormatter.string(from: Date())
    
    var userID = "jtulika"
    if let currentUser = Auth.auth().currentUser {
        userID = currentUser.uid
        print("User ID: \(userID)")
    } else {
        print("No user is currently signed in.")
    }
    
    let userDocumentRef = firestoreDB.collection("users").document(userID)
    let userData: [String: Any] = [
        "userID": userID,
        "timestamp": currentDateString,
        "protein content": totalProteinContent,
        "food items": foodItems
    ]
    do {
        try await userDocumentRef.collection("ProteinIntake").document(currentDateString).setData(userData)
        print("Document successfully written!")
    } catch {
        print("Error writing document: \(error)")
    }
    return "done"
}

 struct GetProteinContent: LLMFunction {
    static let name: String = "get_protein_content"
    static let description: String = "Get protein content of food item"
    @Parameter(description: "The food item whose protein content you want to know") var foodItem: String
    
    func execute() async throws -> String? {
            "The protein content of \(foodItem) is \(get_protein_content(for: foodItem))."
        }
 }


struct LogProteinIntake: LLMFunction {
    static let name: String = "log_protein_intake"
    static let description: String = "Log total protein intake for the user"
    @Parameter(description: "The total protein intake for the user in the format: x grams.") var totalProteinIntake: String
    @Parameter(description: "List of food items for the user.") var foodItems: String
    
    func execute() async throws -> String? {
        "Logged in protein intake for this user with status \(await log_protein_intake(for: totalProteinIntake, for: foodItems))"
        }
}


struct ChatWindow: View {
    @State var showOnboarding = true
    
    @State var model: LLMOpenAI = .init(
        parameters: .init(
            modelType: .gpt3_5Turbo,
            systemPrompt: """
        You are Pro-Chatbot. Your task is to ask the user what they had for food today \
        and log in their total protein intake. You will approach this task in a step-by-step manner.\
        
        [STEP 1]. Ask the user what they had for food today. Extract the food items as a list.
        
        [STEP 2]. Now for each food item in the list, call the "get_protein_content" \
        function to get its protein content.
        
        [STEP 3]. Add the protein content of all the food items to get the total protein intake \
        for the user. Ask the user if they want to add more food items.

        [STEP 4]. If the user adds more food items, repeat the steps to compute the protein content\
        for every new food item and update the total protein intake.
        
        [STEP 5]. If the user does not add new food items, call the "log_protein_content" function \
        to log in the total protein intake for the user. Once you have logged in the total protein \
        intake for the user, inform the user that their protein intake has been logged in \
        and end the conversation.
        """
        )
    ) {
        GetProteinContent()
        LogProteinIntake()
    }
    
//    @State var model: LLMOpenAI = .init(
//        parameters: .init(
//            modelType: .gpt3_5Turbo,
//            systemPrompt: """
//        You are Pro-Chatbot. Your task is to ask the user what food they had today, estimate the total protein content \
//        of their meal and log this information for them. You will approach this task in a step-by-step manner. \
//        
//        [STEP 1] Ask the user what they had for food today. Extract the foods items as a list. \
//        
//        [STEP 2] Estimate the protein content of each food item in the list by yourself. Show your working. \
//        
//        [STEP 3] Add the protein content of all the food items to get the total protein intake \
//        for the user. Ask the user if they want to add more food items. \
//        
//        [STEP 4] If the user adds more food items, repeat the steps to compute the protein content \
//        for every new food item and update the total protein intake.
//        
//        [STEP 5] If the user does not add new food items, call the "log_protein_content" function \
//        to log in the total protein intake for the user. Once you have logged in the total protein \
//        intake for the user, inform the user that their protein intake has been logged in \
//        and end the conversation.
//        """
//        )
//    ) {
////        GetProteinContent()
//        LogProteinIntake()
//    }
    
    var body: some View {
        let greetingMessage: String = "Hello! What did you have for your last meal?"
        
        NavigationStack {
            LLMChatView(
                model: model
            )
                .navigationTitle("Pro-ChatBot")
                .sheet(isPresented: $showOnboarding) {
                    LLMOnboardingView(showOnboarding: $showOnboarding)
                }
                .task {
                    print("Before the model.context.append line. Here is the model.context before: ")
                    print(model.context)
                    model.context.removeAll()
                    model.context.append(assistantOutput: greetingMessage)
                    print("the model.context.append line executed. Here is the model.context after: ")
                    print(model.context)
                }
//                .onDisappear {
//                    model.context.removeAll()
//                }
        }
    }
}

#Preview {
    ChatWindow()
        .previewWith {
            LLMRunner()
        }
}

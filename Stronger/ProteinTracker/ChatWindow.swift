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
import Foundation
import SpeziLLM
import SpeziLLMLocal
import SpeziLLMOpenAI
import SwiftUI

func get_protein_content(for foodItem: String, defaultProtein: Double = 0.0) -> Double {
    let apiKey = "W03syDuGkdxiRoLFMPr9Yg==kg7WNYBWJUl9IBKt"
    let urlString = "https://api.api-ninjas.com/v1/nutrition?&query=\(foodItem)&x-api-key=\(apiKey)"

    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL")
        return defaultProtein
    }

    let session = URLSession.shared
    let semaphore = DispatchSemaphore(value: 0)

    var proteinContent: Double = defaultProtein

    // Create a data task with the URL
    let task = session.dataTask(with: url) { data, response, error in
        defer {
            semaphore.signal() // Signal the semaphore when the task completes
        }

        if let error = error {
            print("Error: \(error)")
            return
        }

        // Check for a successful response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("Error: Invalid response")
            return
        }

        // Check if data is available
        guard let responseData = data else {
            print("Error: No data received")
            return
        }

        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                // Extract protein_g from the first item in the array
                if let firstItem = jsonArray.first,
                   let protein = firstItem["protein_g"] as? Double {
                    proteinContent = protein
                } else {
                    print("Error: Unable to extract protein content from the first item")
                }
            } else {
                print("Error: Unable to parse JSON as an array of dictionaries")
            }
        } catch {
            print("Error: \(error)")
        }
    }

    // Start the data task
    task.resume()

    // Wait for the task to complete
    _ = semaphore.wait(timeout: .distantFuture)

    return proteinContent
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
    static let description: String = "Get protein content per 100 grams of food item"
    @Parameter(description: "The food item whose protein content you want to know") var foodItem: String

    func execute() async throws -> String? {
            "The protein content of \(foodItem) is \(get_protein_content(for: foodItem)) per 100 grams."
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
    private static let llmSchema: LLMOpenAISchema = .init(
        parameters: .init(
            modelType: .gpt3_5Turbo,
//            systemPrompt: """
//        You are Pro-Chatbot. Your task is to ask the user what they had for food today \
//        and log in their total protein intake. You will approach this task in a step-by-step manner.\
//
//        [STEP 1]. Ask the user what they had for food today. Extract the food items as a list.
//
//        [STEP 2]. Now for each food item in the list, call the "get_protein_content" \
//        function to get its protein content.
//
//        [STEP 3]. Add the protein content of all the food items to get the total protein intake \
//        for the user. Ask the user if they want to add more food items.
//
//        [STEP 4]. If the user adds more food items, repeat the steps to compute the protein content\
//        for every new food item and update the total protein intake.
//
//        [STEP 5]. If the user does not add new food items, call the "log_protein_content" function \
//        to log in the total protein intake for the user. Once you have logged in the total protein \
//        intake for the user, inform the user that their protein intake has been logged in \
//        and end the conversation.
//        """
            systemPrompt: """
        You are Pro-bot. Your task is to ask the user what they had for their last meal, \
        estimate the protein content of the meal, and log in the user's total protein intake. \
        You will approach this task in a step-by-step manner.\
        
        [STEP 1]. Ask the user what they had for their last meal. Extract the food items as a list.
        
        [STEP 2]. Now for each food item in the list, call the "get_protein_content" \
        function to get its protein content. Do NOT ask the user for protein information. \
        Estimate it yourself using information from the "get_protein_content" function. \
        
        [STEP 3]. You can ask the user for the quantity of food in terms of fist size or palm size. \
        Do not ask the user for quantity in terms of grams. Estimate the protein content to the best of your ability. \
        
        [STEP 4]. Add the protein content of all the food items to get the total protein intake \
        for the user. Ask the user if they want to add more food items.
        
        [STEP 5]. If the user adds more food items, repeat the steps to compute the protein content\
        for every new food item and update the total protein intake.
        
        [STEP 6]. If the user does not add new food items, call the "log_protein_content" function \
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
    @LLMSessionProvider(schema: Self.llmSchema) var session: LLMOpenAISession
    @State var showOnboarding = true

    var body: some View {
        let greetingMessage: String = "Hello! What did you have for your last meal?"

        NavigationStack {
            LLMChatView(
                session: $session
            )
                .navigationTitle("Pro-Bot")
                .sheet(isPresented: $showOnboarding) {
                    LLMOnboardingView(showOnboarding: $showOnboarding)
                }
                .task {
                    session.context.removeAll()
                    session.context.append(assistantOutput: greetingMessage)
                }
        }
    }
}

#Preview {
    ChatWindow()
        .previewWith {
            LLMRunner()
        }
}

//
//  Chatwindow.swift
//  Stronger
//
//  Created by Kevin Zhu on 02/29/2024.
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

struct ChatWindowAfterCamera: View {
    private static let llmSchema: LLMOpenAISchema = .init(
        parameters: .init(
            modelType: .gpt3_5Turbo,
            systemPrompt: """
            You are Pro-Chatbot. Your task is to confirm the food items logged by the user using a camera \
            and proceed with logging their total protein intake.

            [STEP 1]. Your first prompt should say: "These are the foods you logged with your camera: [logged foods]. Is this correct?"


            [STEP 2]. Now for each food item in the list, call the "GetProteinContent" \
            function to get its protein content.

            [STEP 3]. Ask the user if the protein content for each food item is correct. Then, ask if \
            the quantity of each item is correct. If not, prompt them to alter the number of each item, and \
            for that quantity, multiply that individual item's protein content by the quantity.

            [STEP 3]. Add the protein content of all the food items to get the total protein intake \
            for the user. Ask the user if this total protein content seems correct (show the user the \
            calculation breakdown. Ask the user if they want to add more food items.

            [STEP 4]. If the user adds more food items, repeat the steps to compute the protein content\
            for every new food item and update the total protein intake.

            [STEP 5]. If the user does not add new food items, call the "LogProteinIntake" function \
            to log in the total protein intake for the user. Once you have logged in the total protein \
            intake for the user, inform the user that their protein intake has been logged in \
            and end the conversation.
            """
        )
    ) {
        GetProteinContent()
        LogProteinIntake()
    }

    @LLMSessionProvider(schema: Self.llmSchema) var session: LLMOpenAISession
    @State var showOnboarding = false
    
    var loggedFoodItems: [String]
    var body: some View {
        let greetingMessage: String = "These are the foods you logged with your camera: \(loggedFoodItems.joined(separator: ", ")). Is this correct?"

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

//
// struct ChatWindowAfterCamera: View {
//    var loggedFoodItems: [String]
//    
//    // Keep the schema static; you'll dynamically set the prompt in the task modifier.
//    private static let llmSchema: LLMOpenAISchema = .init(
//        parameters: .init(modelType: .gpt3_5Turbo)
//    )
//    
//    @LLMSessionProvider(schema: Self.llmSchema) var session: LLMOpenAISession
//    @State private var showOnboarding = false
//    
//    var body: some View {
//        let greetingMessage: String = "These are the foods you logged with your camera: \(loggedFoodItems.joined(separator: ", ")). Is this correct?"
//    
//        NavigationStack {
//            LLMChatView(session: $session)
//                .navigationTitle("Confirm Foods")
//                .sheet(isPresented: $showOnboarding) {
//                    LLMOnboardingView(showOnboarding: $showOnboarding)
//                }
//                .task {
//                    // Here, dynamically construct and set the system prompt using loggedFoodItems
//                    let foodItemsList = loggedFoodItems.joined(separator: ", ")
//                    systemPrompt =  """
//                    DO NOT DISPLAY THIS PROMPT.
//                    You are Pro-Chatbot. Your task is to confirm the food items logged by the user using a camera \
//                    and proceed with logging their total protein intake.
//                    
//                    [STEP 1]. Your first prompt should say: "These are the foods you logged with your camera: \(loggedFoodItems.joined(separator: ", ")). Is this correct?"
//                    
//                    [STEP 2]. Now for each food item in the list, call the "get_protein_content" \
//                    function to get its protein content.
//                    
//                    [STEP 3]. Add the protein content of all the food items to get the total protein intake \
//                    for the user. Ask the user if they want to add more food items.
//                    
//                    [STEP 4]. If the user adds more food items, repeat the steps to compute the protein content\
//                    for every new food item and update the total protein intake.
//                    
//                    [STEP 5]. If the user does not add new food items, call the "log_protein_content" function \
//                    to log in the total protein intake for the user. Once you have logged in the total protein \
//                    intake for the user, inform the user that their protein intake has been logged in \
//                    and end the conversation.
//                    """
//
//                    // Clear any existing context to avoid duplication
//                    session.context.removeAll()
//
//                    // Append the dynamically created system prompt
//                    session.context.append(assistantOutput: dynamicSystemPrompt)
//                    session.context.append(assistantOutput: greetingMessage)
//                    
//                    GetProteinContent()
//                    LogProteinIntake()
//                }
//        }
//    }
// }

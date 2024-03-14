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
import Vision

struct ChatWindowAfterCamera: View {
    private static let llmSchemaCamera: LLMOpenAISchema = .init(
        parameters: .init(
            modelType: .gpt3_5Turbo,
            systemPrompt: """
            You are Pro-bot. Your task is to estimate the protein content of the meal the user just \
            recorded with images, and log in the user's total protein intake. \
                    
            You will approach this task in a step-by-step manner.\
            
            [STEP 1]. Process the [logged foods] list, if there are "_" in any strings or food, remove them and replace it with a space.
            
            [STEP 2]. Your first prompt should say: "These are the foods you logged with your camera: [logged foods]. Is this correct?"

            [STEP 3]. Your next prompt will say "The protein content for the food is: [logged food]: [x] grams. \
            Repeat for each food. To get the protein content, or each food item in the list, call the "get_protein_content" \
            function to get its protein content. Do NOT ask the user for protein information. \
            Estimate it yourself using information from the "get_protein_content" function. \
            
            [STEP 4]. You can ask the user for the quantity of food in terms of fist size or palm size. \
            Do not ask the user for quantity in terms of grams. Estimate the protein content to the best of your ability. \
            
            [STEP 5]. Add the protein content of all the food items to get the total protein intake \
            for the user. Ask the user if they want to add more food items.
                    
            [STEP 6]. If the user adds more food items, repeat the steps to compute the protein content\
            for every new food item and update the total protein intake.
            
            [STEP 7]. If the user does not add new food items, call the "log_protein_content" function \
            to log in the total protein intake for the user. Once you have logged in the total protein \
            intake for the user, inform the user that their protein intake has been logged in \
            and end the conversation.
            """
        )
    ) {
        GetProteinContent()
        LogProteinIntake()
    }

    @LLMSessionProvider(schema: Self.llmSchemaCamera) var session: LLMOpenAISession
    @State var showOnboarding = true

    var loggedFoodItems: [String]
    var body: some View {
        let greetingMessage: String = "These are the foods you logged with your camera: \(loggedFoodItems.joined(separator: ", ")). Is this correct?"

        NavigationStack {
            LLMChatView(
                session: $session
            )
                .navigationTitle("Pro-Bot")
                .sheet(isPresented: $showOnboarding) {
                    LLMOnboardingViewCamera(showOnboarding: $showOnboarding)
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

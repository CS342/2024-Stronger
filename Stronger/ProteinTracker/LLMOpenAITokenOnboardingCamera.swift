//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziLLMOpenAI
import SpeziOnboarding
import SwiftUI

/// Onboarding view that gets the OpenAI token from the user.
struct LLMOpenAITokenOnboardingCamera: View {
    @Binding var showOnboarding: Bool

    var body: some View {
        LLMOpenAIAPITokenOnboardingStep {
            showOnboarding = false
        }
    }
}

#Preview {
    LLMOpenAITokenOnboardingCamera(showOnboarding: .constant(false))
}

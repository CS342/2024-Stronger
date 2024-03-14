//
//  LLMOnboardingView.swift
//  Stronger
//
//  Created by Kevin Zhu on 03/02/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziLLMOpenAI
import SpeziOnboarding
import SwiftUI

struct LLMOnboardingViewCamera: View {
    @Binding var showOnboarding: Bool

    var body: some View {
        OnboardingStack {
            LLMOpenAITokenOnboardingCamera(showOnboarding: $showOnboarding)
        }
        .interactiveDismissDisabled(showOnboarding)
    }
}

#Preview {
    LLMOnboardingViewCamera(showOnboarding: .constant(false))
}

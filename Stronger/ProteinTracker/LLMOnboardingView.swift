//
//  LLMOnboardingView.swift
//  Stronger
//
//  Created by Tulika Jha on 01/02/24.
//

import SpeziLLMOpenAI
import SpeziOnboarding
import SwiftUI

struct LLMOnboardingView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: !$showOnboarding) {
            LLMOpenAITokenOnboarding()
        }
        .interactiveDismissDisabled(showOnboarding)
    }
}

#Preview {
    LLMOnboardingView(showOnboarding: .constant(false))
}

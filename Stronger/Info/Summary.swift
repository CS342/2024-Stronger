//
//  Summary.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/1/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import SpeziAccount
import SpeziMockWebService

struct Summary: View {
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

   
    @State private var presentingAccount = false
    
    // var username: String
    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        VStack() {
            // Welcome message
            Text("Welcome Mary")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
            //Spacer()
            // Image and text boxes
            HStack {
//                Image(systemName: "person.circle")
//                    .resizable()
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text("You've had 30 grams of protein today. 150 grams to go!")
                        .padding(.bottom, 30)
                    //Spacer()
                    Text("You've finished your exercises for the day! Way to go!")
                }
                .alignmentGuide(.imageAlignment) { d in d[.bottom] }
            }
        }
        .padding()
    }
}

extension VerticalAlignment {
    private enum ImageAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.top]
        }
    }
    
    static let imageAlignment = VerticalAlignment(ImageAlignment.self)
}

#Preview {
    Summary()
}

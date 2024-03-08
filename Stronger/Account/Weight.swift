//
// This source file is part of the STRONGER based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SpeziAccount
import SpeziFoundation
import SpeziValidation
import SpeziViews
import SwiftUI

/// The weight of a user.
public struct WeightKey: AccountKey {
    public typealias Value = Int
    public static let name = LocalizedStringResource("WEIGHT")
    public static let category: AccountKeyCategory = .personalDetails
}


extension AccountKeys {
    /// this is the weightKey of the user
    public var weight: WeightKey.Type {
        WeightKey.self
    }
}


extension AccountValues {
    /// this is the weight value to be stored
    public var weight: Int? {
        storage[WeightKey.self]
    }
}


// MARK: - UI
extension WeightKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = WeightKey
        private let weight: Int
        public init(_ value: Int) {
            self.weight = value
        }
        public var body: some View {
            HStack {
                Text(WeightKey.name)
                Spacer()
                Text("\(weight) lbs")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}


extension WeightKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = WeightKey
        @Binding private var weight: Int
        @State private var showAlert = false // State variable to control alert visibility

        public var body: some View {
            HStack {
                Text("\(WeightKey.name): lbs")
                Spacer()
                Button(action: {
                    showAlert.toggle() // Toggle alert visibility
                }) {
                    Image(systemName: "info.circle") // Info symbol
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 4) // Adjust spacing
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Weight Information"),
                        message: Text("Weight is gathered to determine protein intake."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                TextField("Weight: lbs", value: $weight, formatter: NumberFormatter())
                    .frame(width: 120) // set frame width to enable more spaces.
            }
        }
        
        public init(_ value: Binding<Int>) {
            self._weight = value
        }
    }
}

// extension WeightKey {
//     public struct DataEntry: DataEntryView {
//         public typealias Key = WeightKey
//         @Binding private var weight: Int
//         @State private var isShowingInfo = false // State variable to control info pop-up
//         public var body: some View {
//             HStack {
//                 Text(WeightKey.name)
//                 Spacer()
//                 Button(action: {
//                     isShowingInfo.toggle() // Toggle info pop-up visibility
//                 }) {
//                     Image(systemName: "info.circle") // Info symbol
//                         .foregroundColor(.blue)
//                 }
//                 .popover(isPresented: $isShowingInfo, content: {
//                     VStack {
//                         Text("Weight Information")
//                             .font(.headline)
//                             .padding()
//                         Text("Weight is gathered to determine protein intake.")
//                             .padding()
//                     }
//                 })
//                 .frame(width:200, height:100)
//                 .padding(.trailing, 4) // Adjust spacing
//                 TextField("Weight", value: $weight, formatter: NumberFormatter())
//                     .frame(width: 120) // set frame width to enable more spaces.
//             }
//         }
//         public init(_ value: Binding<Int>) {
//             self._weight = value
//         }
//     }
// }

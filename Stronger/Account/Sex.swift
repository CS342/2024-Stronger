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

/// The sex of a user.
public struct SexKey: AccountKey {
    public typealias Value = String
    public static let name = LocalizedStringResource("SEX")
    public static let category: AccountKeyCategory = .personalDetails
}

extension AccountKeys {
    /// The sex key of the user.
    public var sex: SexKey.Type {
        SexKey.self
    }
}

extension AccountValues {
    /// The value of the sex to store.
    public var sex: String? {
        storage[SexKey.self]
    }
}

// MARK: - UI

extension SexKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = SexKey
        private let sex: String
        public init(_ value: String) {
            self.sex = value
        }
        public var body: some View {
            HStack {
                Text(SexKey.name)
                Spacer()
                Text(sex)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

extension SexKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = SexKey
        @Binding private var sex: String
        public var body: some View {
            HStack {
                Text(SexKey.name)
                Spacer()
                Picker(selection: $sex, label: Text("Sex")) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 160) // Adjust width as needed
            }
        }
        public init(_ value: Binding<String>) {
            self._sex = value
        }
    }
}

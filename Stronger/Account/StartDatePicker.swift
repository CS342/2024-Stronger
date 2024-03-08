//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
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

/// A simple `DatePicker` implementation tailored towards entry of a start date.
public struct StartDatePicker: DataEntryView {
    public typealias Key = StartDateKey

    private let titleLocalization: LocalizedStringResource

    @Environment(Account.self) private var account
    @Environment(\.accountViewType) private var viewType

    @Binding private var startDate: Date
    @State private var dateAdded = false

    @State private var layout: DynamicLayout?

    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1800, month: 1, day: 1)
        let curDate = Date.now
        guard let endDate = Calendar.current.date(byAdding: .day, value: 1, to: curDate) else {
            fatalError("Could not translate \(startDateComponents) to a valid date.")
        }

        guard let startDate = calendar.date(from: startDateComponents) else {
            fatalError("Could not translate \(startDateComponents) to a valid date.")
        }

        return startDate...endDate
    }

    
    /// We want to show the picker if
    ///  - The start date is configured to be required.
    ///  - We are NOT entering new date. Showing existing data the user might want to change.
    ///  - If we are entering new data and the user pressed the add button.
    @MainActor private var showPicker: Bool {
        account.configuration[Key.self]?.requirement == .required
            || viewType?.enteringNewData == false
            || dateAdded
    }


    public var body: some View {
        HStack {
            DynamicHStack {
                Text(titleLocalization)
                    .multilineTextAlignment(.leading)

                if layout == .horizontal {
                    Spacer()
                }

                if showPicker {
                    DatePicker(
                        selection: $startDate,
                        in: dateRange,
                        displayedComponents: .date
                    ) {
                        Text(titleLocalization)
                    }
                    .labelsHidden()
                } else {
                    Button(action: addDateAction) {
                        Text("ADD_DATE")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 7)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: .tertiarySystemFill))
                    )
                }
            }

            if layout == .vertical {
                Spacer()
            }
        }
            .accessibilityRepresentation {
                // makes sure the accessibility view spans the whole width, including the label.
                if showPicker {
                    DatePicker(selection: $startDate, in: dateRange, displayedComponents: .date) {
                        Text(titleLocalization)
                    }
                } else {
                    Button(action: addDateAction) {
                        Text("VALUE_ADD \(titleLocalization)")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .onPreferenceChange(DynamicLayout.self) { value in
                layout = value
            }
    }


    /// Initialize a new `StartDatePicker`.
    /// - Parameters:
    ///   - startDate: A binding to the `Date` state.
    ///   - customTitle: Optionally provide a custom label text.
    public init(
        startDate: Binding<Date>,
        title customTitle: LocalizedStringResource? = nil
    ) {
        self._startDate = startDate
        self.titleLocalization = customTitle ?? StartDateKey.name
    }

    public init(_ value: Binding<Date>) {
        self.init(startDate: value)
    }


    private func addDateAction() {
        dateAdded = true
    }
}


#if DEBUG
struct StartDatePicker_Previews: PreviewProvider {
    struct Preview: View {
        @State private var startDate = Date.now

        var body: some View {
            Form {
                StartDatePicker(startDate: $startDate)
            }
            VStack {
                StartDatePicker(startDate: $startDate)
                    .padding(32)
            }
                .background(Color(.systemGroupedBackground))
        }
    }

    static var previews: some View {
        // preview entering new data.
        Preview()
            .environment(Account(MockUserIdPasswordAccountService()))
            .environment(\.accountViewType, .signup)

        // preview entering new data but displaying existing data.
        Preview()
            .environment(Account(MockUserIdPasswordAccountService()))
            .environment(\.accountViewType, .overview(mode: .existing))

        // preview entering new data but required.
        Preview()
            .environment(Account(MockUserIdPasswordAccountService(), configuration: [.requires(\.startDate)]))
            .environment(\.accountViewType, .signup)
    }
}
#endif

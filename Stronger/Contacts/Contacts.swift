//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziContact
import SwiftUI


/// Displays the contacts for the Stronger.
struct Contacts: View {
    let contacts = [
        Contact(
            name: PersonNameComponents(
                givenName: "Mike",
                familyName: "Baiocchi, PhD"
            ),
            image: Image(systemName: "figure.wave.circle"), // swiftlint:disable:this accessibility_label_for_image
            title: "Principal Investigator",
            description: String(localized: "MICHAEL_BAIOCCHI_BIO"),
            organization: "Stanford University",
            address: {
                let address = CNMutablePostalAddress()
                address.country = "USA"
                address.state = "CA"
                address.postalCode = "94305"
                address.city = "Stanford"
                address.street = "1265 Welch Road"
                return address
            }(),
            contactOptions: [
                .call("+1 (650) 723-2300"),
                .text("+1 (650) 723-2300"),
                .email(addresses: ["baiocchi@stanford.edu"]),
                ContactOption(
                    image: Image(systemName: "safari.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "Website",
                    action: {
                        if let url = URL(string: "https://profiles.stanford.edu/michael-baiocchi") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            ]
        ),
        Contact(
            name: PersonNameComponents(
                givenName: "Marily",
                familyName: "Oppezzo, PhD, MS, RDN, DipACLM"
            ),
            image: Image(systemName: "figure.wave.circle"), // swiftlint:disable:this accessibility_label_for_image
            title: "Principal Investigator",
            description: String(localized: "MARILY_OPPEZZO_BIO"),
            organization: "Stanford University",
            address: {
                let address = CNMutablePostalAddress()
                address.country = "USA"
                address.state = "CA"
                address.postalCode = "94305"
                address.city = "Stanford"
                address.street = "Mail Code: 5411"
                return address
            }(),
            contactOptions: [
                .call("+1 (650) 723-2300"),
                .text("+1 (650) 723-2300"),
                .email(addresses: ["moppezzo@stanford.edu"]),
                ContactOption(
                    image: Image(systemName: "safari.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "Website",
                    action: {
                        if let url = URL(string: "https://profiles.stanford.edu/marily-oppezzo") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            ]
        )
    ]
    
    @Binding var presentingAccount: Bool
    
    
    var body: some View {
        NavigationStack {
            ContactsList(contacts: contacts)
                .navigationTitle(String(localized: "CONTACTS_NAVIGATION_TITLE"))
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview {
    Contacts(presentingAccount: .constant(false))
}
#endif

//
//  GeneralPreferencesView.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/4/22.
//

import SwiftUI

struct GeneralPreferencesView: View {
    @State var appearance = "System"

    var body: some View {
        VStack {
            Form {
                Picker("Appearance: ", selection: $appearance) {
                    Text("System").tag("System")
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
                .pickerStyle(.inline)
            }
            Spacer()
        }
        .padding()
    }
}

struct GeneralPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
//        GeneralPreferencesView()
        PreferencesView()
    }
}

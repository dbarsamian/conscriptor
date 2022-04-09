//
//  PreferencesView.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/4/22.
//

import SwiftUI

struct PreferencesView: View {
    private enum Tabs: Hashable {
        case general, keyBindings
    }

    @State private var tab = Tabs.general

    var body: some View {
        TabView(selection: $tab) {
//            GeneralPreferencesView()
//                .tabItem {
//                    Label("General", systemImage: "gearshape")
//                }
//                .tag(Tabs.general)
            KeyBindingsView()
                .tabItem {
                    Label("Key Bindings", systemImage: "keyboard")
                }
                .tag(Tabs.keyBindings)
        }
        .padding()
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .previewLayout(.fixed(width: 450, height: 250))
    }
}

//
//  ConscriptorApp.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import SwiftUI

@main
struct ConscriptorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ConscriptorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}

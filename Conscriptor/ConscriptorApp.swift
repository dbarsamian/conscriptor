//
//  ConscriptorApp.swift
//  Conscriptor
//
//  Created by David Barsamian on 7/27/21.
//

import KeyboardShortcuts
import SwiftUI

@main
struct ConscriptorApp: App {
    let persistenceController = PersistenceController.shared
    let notificationCenter = NotificationCenter.default

    @Environment(\.scenePhase) var scenePhase
    @State var templateToUse: Template?
    @State private var showingAlert = false

    var body: some Scene {
        WindowGroup("Templates") {
            OpenTemplateView(templateToUse: $templateToUse)
                .frame(minWidth: 800, minHeight: 500)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .alert("Error", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("There was an error trying to save your custom templates. Please try again.")
                }
        }
        .windowStyle(.hiddenTitleBar)
        .onChange(of: scenePhase) { _ in
            let results = persistenceController.save()
            switch results {
            case .error:
                showingAlert.toggle()
            default:
                break
            }
        }

        DocumentGroup(newDocument: ConscriptorDocument(text: templateToUse?.document ?? "")) { file in
            MarkdownEditorView(conscriptorDocument: file.$document)
                .frame(minWidth: 650, minHeight: 500)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowToolbarStyle(.unified)
        .commands {
            ToolbarCommands()
            TextEditingCommands()
            CommandGroup(after: .saveItem) {
                Button {
                    notificationCenter.post(name: .saveNewTemplate, object: nil)
                } label: {
                    Text("Save as Template")
                }
                .keyboardShortcut("s", modifiers: [.control, .shift])
            }
            CommandGroup(replacing: .textFormatting) {
                Button {
                    notificationCenter.post(name: .formatBold, object: nil)
                } label: {
                    Text("Bold")
                }
                .keyboardShortcut("b", modifiers: .command)

                Button {
                    notificationCenter.post(name: .formatItalic, object: nil)
                } label: {
                    Text("Italic")
                }
                .keyboardShortcut("i", modifiers: .command)

                Button {
                    notificationCenter.post(name: .formatStrikethrough, object: nil)
                } label: {
                    Text("Strikethrough")
                }
                .keyboardShortcut("k", modifiers: .command)

                Button {
                    notificationCenter.post(name: .formatInlineCode, object: nil)
                } label: {
                    Text("Inline Code")
                }
                .keyboardShortcut("/", modifiers: .command)

                Divider()

                Button {
                    notificationCenter.post(name: .insertImage, object: nil)
                } label: {
                    Text("Insert Image")
                }
                .keyboardShortcut("i", modifiers: [.command, .option])

                Button {
                    notificationCenter.post(name: .insertLink, object: nil)
                } label: {
                    Text("Add Link")
                }
                .keyboardShortcut("l", modifiers: [.command, .option])
            }
        }

//        Settings {
//            PreferencesView()
//                .frame(width: 450, height: 250)
//        }
    }
}

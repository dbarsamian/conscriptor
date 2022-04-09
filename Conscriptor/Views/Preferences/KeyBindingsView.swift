//
//  KeyBindingsView.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/4/22.
//

import KeyboardShortcuts
import SwiftUI

struct KeyBindingsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Save As Template", name: .saveAsTemplate)
            KeyboardShortcuts.Recorder("Format Bold", name: .formatBold)
            KeyboardShortcuts.Recorder("Format Italic", name: .formatItalic)
            KeyboardShortcuts.Recorder("Format Strikethrough", name: .formatStrikethrough)
            KeyboardShortcuts.Recorder("Format Inline Code", name: .formatInlineCode)
            KeyboardShortcuts.Recorder("Insert Image", name: .insertImage)
            KeyboardShortcuts.Recorder("Insert Link", name: .insertLink)
        }
        .padding()
    }
}

struct KeyBindingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyBindingsView()
    }
}

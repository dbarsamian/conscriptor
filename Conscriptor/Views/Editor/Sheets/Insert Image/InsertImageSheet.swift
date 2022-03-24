//
//  InsertImageSheet.swift
//  Conscriptor
//
//  Created by David Barsamian on 3/22/22.
//

import SwiftUI

struct InsertImageSheet: View {
    @Binding var newImageLocation: String
    @Binding var newImageAlt: String
    @Binding var showingInsertImageSheet: Bool
    @Binding var conscriptorDocument: ConscriptorDocument
    let textView: NSTextView?

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: newImageLocation)) { image in
                image.resizable()
            } placeholder: {
                Color(NSColor.windowBackgroundColor)
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 400, height: 400, alignment: .center)

            VStack(alignment: .leading) {
                Text("Insert Image")
                    .font(.title)
                Spacer()
                Text("URL")
                    .font(.headline)
                TextField("Image URL",
                          text: $newImageLocation,
                          prompt: Text("https://en.wikipedia.org/wiki/Wikipedia#/media/File:Wikipedia-logo-v2.svg"))
                Text("Alt Text")
                    .font(.headline)
                TextField("Image Alt Text",
                          text: $newImageAlt,
                          prompt: Text("Optional"))
                HStack {
                    Button("Cancel", role: .cancel) {
                        showingInsertImageSheet.toggle()
                    }
                    Spacer()
                    Button("Insert") {
                        MarkdownEditorController.insert(image: newImageLocation,
                                                        withAlt: newImageAlt,
                                                        in: textView,
                                                        update: &conscriptorDocument)
                        newImageLocation = ""
                        newImageAlt = ""
                        showingInsertImageSheet.toggle()
                    }
                    .disabled(newImageLocation.isEmpty)
                }
            }
            .padding()
        }
    }
}

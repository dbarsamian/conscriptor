//
//  SaveTemplateSheet.swift
//  Conscriptor
//
//  Created by David Barsamian on 3/22/22.
//

import SwiftUI

struct SaveTemplateSheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var conscriptorDocument: ConscriptorDocument
    @Binding var newTemplateName: String
    @Binding var showingTemplateSaveAlert: Bool

    var body: some View {
        VStack {
            Text("Save as Template")
                .font(.title2)
            TextField("Template Title", text: $newTemplateName, prompt: Text("Enter a name for this template..."))
                .padding(.vertical)
            HStack {
                Button("Cancel", role: .cancel) {
                    showingTemplateSaveAlert.toggle()
                }
                Spacer()
                Button("Save") {
                    let template = UserTemplate(context: managedObjectContext)
                    template.id = UUID()
                    template.name = newTemplateName
                    template.document = conscriptorDocument.text

                    if managedObjectContext.hasChanges {
                        try? managedObjectContext.save()
                    }

                    showingTemplateSaveAlert.toggle()
                }
                .disabled(newTemplateName.isEmpty)
            }
        }
        .padding()
    }
}

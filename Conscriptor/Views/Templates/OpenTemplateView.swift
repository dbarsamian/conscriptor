//
//  OpenTemplateView.swift
//  Conscriptor
//
//  Created by David Barsamian on 1/6/22.
//

import SwiftUI

struct OpenTemplateView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var templateToUse: Template?
    
    private let TemplateCategoryIcons: [TemplateCategory: String] = [
        .AllTemplates: "rectangle.3.group",
        .Basic: "doc.plaintext",
    ]
    
    var body: some View {
        NavigationView {
            List(TemplateCategory.allCases) { category in
                NavigationLink {
                    Text(category.rawValue)
                } label: {
                    Label(category.rawValue, systemImage: TemplateCategoryIcons[category] ?? "") 
                }
            }
            .frame(minWidth: 200)
            .navigationTitle("Choose a Template")
            .listStyle(SidebarListStyle())
            
            VStack {
                TemplateGridView(dismissTemplateWindow: dismiss, templateToUse: $templateToUse)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                    .foregroundColor(Color.black)
                HStack(alignment: .center) {
                    Spacer()
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .padding(.bottom, 8)
                    Button("Open") {
                        NSDocumentController.shared.newDocument(self)
                        dismiss()
                    }
                    .disabled(templateToUse == nil)
                    .padding(.bottom, 8)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
        }
        .introspectSplitView { splitView in
            configureSplitView(splitView)
        }
    }
    
    private func configureSplitView(_ splitView: NSSplitView) {
        if let splitVC = splitView.delegate as? NSSplitViewController, let sidebar = splitVC.splitViewItems.first {
            sidebar.canCollapse = false
            sidebar.minimumThickness = 200
            sidebar.maximumThickness = 200
        }
    }
}

struct OpenTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        OpenTemplateView(templateToUse: Binding<Template?>.constant(Template.Presets.first!))
            .frame(width: 600, height: 400)
    }
}

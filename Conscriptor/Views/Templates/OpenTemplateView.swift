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

    @State var filter: TemplateCategory = .allTemplates

    private func templateGrid(displaying filter: TemplateCategory) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            TemplateGridView(templateToUse: $templateToUse, dismissTemplateWindow: dismiss, filter: filter)
                .edgesIgnoringSafeArea(.all)
            Divider()
            HStack(alignment: .center) {
                Spacer()
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .padding(.vertical)
                Button("Open") {
                    NSDocumentController.shared.newDocument(self)
                    dismiss()
                }
                .disabled(templateToUse == nil)
                .padding(.vertical)
            }
            .layoutPriority(1)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
    }

    var body: some View {
        NavigationView {
            List(TemplateCategory.allCases) { category in
                NavigationLink {
                    templateGrid(displaying: category)
                } label: {
                    Label(category.rawValue.localizedCapitalized, systemImage: TemplateCategory.getIcon(for: category))
                }
            }
            .frame(width: 200)
            .navigationTitle("Choose a Template")
            .listStyle(SidebarListStyle())

            templateGrid(displaying: .allTemplates)
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
            splitVC.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
        }
    }
}

struct OpenTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        OpenTemplateView(templateToUse: Binding<Template?>.constant(Template.Presets.first!))
            .previewLayout(.sizeThatFits)
    }
}

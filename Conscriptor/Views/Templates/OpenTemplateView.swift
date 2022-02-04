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
    @State var filter: TemplateCategory = .AllTemplates
    
    private func templateGrid(displaying filter: TemplateCategory) -> some View {
        return VStack(alignment: .leading) {
            TemplateGridView(dismissTemplateWindow: dismiss, filter: filter, templateToUse: $templateToUse)
                .edgesIgnoringSafeArea(.all)
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
                    Label(category.rawValue, systemImage: TemplateCategory.getIcon(for: category))
                }
            }
            .frame(width: 200)
            .navigationTitle("Choose a Template")
            .listStyle(SidebarListStyle())
            
            templateGrid(displaying: .AllTemplates)
            
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

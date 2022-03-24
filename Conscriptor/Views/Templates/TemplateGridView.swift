//
//  TemplateGridView.swift
//  Conscriptor
//
//  Created by David Barsamian on 1/7/22.
//

import SwiftUI

struct TemplateGridView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(entity: UserTemplate.entity(),
                  sortDescriptors: [],
                  predicate: nil, animation:
                    Animation.default) var userTemplates: FetchedResults<UserTemplate>

    @Binding var templateToUse: Template?

    @State var showingDeleteAlert = false
    @State var templateToDelete: UserTemplate?

    let dismissTemplateWindow: DismissAction
    var filter: TemplateCategory

    private var templates: [Template] {
        var presets = Template.Presets.filter { $0.templateType == filter || filter == .allTemplates }
        if !userTemplates.isEmpty {
            let userPresets = userTemplates.map { userTemplate in
                Template(id: userTemplate.id ?? UUID(),
                         templateType: .user,
                         document: userTemplate.document ?? "",
                         name: userTemplate.name ?? "")
            }
            presets.append(contentsOf: userPresets)
        }
        return presets
    }

    private func templateView(displaying template: Template) -> some View {
        return TemplateView(template: template)
            .frame(width: 280 / 2, height: 360 / 2)
            .scaleEffect(0.25, anchor: UnitPoint.center)
            .allowsHitTesting(false)
            .background(Color(nsColor: NSColor.textBackgroundColor))
            .cornerRadius(8)
            .shadow(radius: 6, y: 4)
            .overlay(
                templateToUse?.id == template.id
                    ? AnyView(selectedOverlay)
                    : AnyView(normalOverlay)
            )
            .onTapGesture {
                if templateToUse?.id == template.id {
                    NSDocumentController.shared.newDocument(self)
                    dismissTemplateWindow()
                } else {
                    templateToUse?.id = template.id
                }
                templateToUse = template
            }
    }

    private func templateName(displaying template: Template) -> some View {
        return Text(template.name)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .foregroundColor(
                templateToUse?.id == template.id
                    ? Color.black
                    : Color(nsColor: NSColor.textColor)
            )
            .background(
                templateToUse?.id == template.id
                    ? AnyView(selectedBackground)
                    : AnyView(EmptyView())
            )
    }

    private func grid(displaying templates: [Template]) -> some View {
        let columns: [GridItem] = [.init(.adaptive(minimum: 160))]
        return LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
            ForEach(templates) { preset in
                VStack {
                    templateView(displaying: preset)
                    templateName(displaying: preset)
                    if filter == .allTemplates {
                        Text(preset.templateType.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .contextMenu {
                    if preset.templateType == .user {
                        Button(role: .destructive) {
                            templateToDelete = userTemplates.first(where: { $0.id == preset.id })
                            if templateToDelete != nil {
                                showingDeleteAlert.toggle()
                            }
                        } label: {
                            Label("Delete Template", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Choose a Template")
                    .font(.title)
                    .bold()
                    .padding(.leading, 26)
                    .padding(.top, 40)
                    .multilineTextAlignment(.leading)
                grid(displaying: templates)
                    .padding(.horizontal, 26)
            }
        }
        .alert("Are you sure?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                managedObjectContext.delete(templateToDelete!)
                try? managedObjectContext.save()
                templateToDelete = nil
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var selectedBackground: some View {
        RoundedRectangle(cornerRadius: 4).fill(Color.accentColor)
    }

    private var normalOverlay: some View {
        return RoundedRectangle(cornerRadius: 8)
            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
    }

    private var selectedOverlay: some View {
        return RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 3)
    }
}

struct TemplateGridView_Previews: PreviewProvider {
    @Environment(\.dismiss) static var dismiss

    static var previews: some View {
        TemplateGridView(templateToUse: .constant(Template.Presets.first!),
                         dismissTemplateWindow: dismiss,
                         filter: .allTemplates)
            .previewLayout(.sizeThatFits)
    }
}

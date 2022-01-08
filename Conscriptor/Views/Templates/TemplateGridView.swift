//
//  TemplateGridView.swift
//  Conscriptor
//
//  Created by David Barsamian on 1/7/22.
//

import SwiftUI

struct TemplateGridView: View {
    let dismissTemplateWindow: DismissAction
    @Binding var templateToUse: Template?
    
    var body: some View {
        let rows: [GridItem] = [.init(.fixed(360 / 2), alignment: .topLeading)]
        LazyHGrid(rows: rows, alignment: .top, spacing: 20) {
            ForEach(Template.Presets) { preset in
                VStack {
                    TemplateView(template: preset)
                        .frame(width: 280 / 2, height: 360 / 2)
                        .scaleEffect(0.25, anchor: UnitPoint.center)
                        .allowsHitTesting(false)
                        .background(Color(nsColor: NSColor.textBackgroundColor))
                        .cornerRadius(8)
                        .shadow(radius: 6)
                        .overlay(
                            templateToUse?.id == preset.id
                            ? AnyView(selectedOverlay)
                            : AnyView(normalOverlay)
                        )
                        .onTapGesture {
                            if templateToUse?.id == preset.id {
                                NSDocumentController.shared.newDocument(self)
                                dismissTemplateWindow()
                            } else {
                                templateToUse?.id = preset.id
                            }
                            templateToUse = preset
                        }
                    Text(preset.name)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .foregroundColor(
                            templateToUse?.id == preset.id
                            ? Color.black
                            : Color(nsColor: NSColor.textColor)
                        )
                        .background(
                            templateToUse?.id == preset.id
                            ? AnyView(selectedBackground)
                            : AnyView(EmptyView())
                        )
                }
            }
            .padding()
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
            .stroke(Color.accentColor, lineWidth: 2)
    }
}

struct TemplateGridView_Previews: PreviewProvider {
    @Environment(\.dismiss) static var dismiss
    
    static var previews: some View {
        TemplateGridView(dismissTemplateWindow: dismiss, templateToUse: Binding<Template?>.constant(Template.Presets.first!))
            .frame(width: 400, height: 400)
    }
}

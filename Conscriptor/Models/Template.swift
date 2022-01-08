//
//  Template.swift
//  Conscriptor
//
//  Created by David Barsamian on 1/7/22.
//

import Foundation
import SwiftUI
import Ink

public enum TemplateCategory: String, CaseIterable, Identifiable {
    public var id: RawValue { rawValue }
    
    case AllTemplates = "All Templates"
    case Basic = "Basic"
}

public struct Template: Identifiable {
    public var id: UUID = UUID()
    var templateType: TemplateCategory
    var document: String
    var name: String
    
    static let Presets: [Template] = [
        Template(templateType: .Basic, document: "", name: "Empty"),
        Template(templateType: .Basic, document: "# Notes\n\n## Subject 1\n\n- Note 1\n\n- Note 2\n\n- Note 3", name: "Note Taking")
    ]
}

struct TemplateView: View {
    let template: Template
    
    var html: String {
        let parser = MarkdownParser()
        return parser.html(from: template.document)
    }
    
    var body: some View {
        WebView(html: html)
            .frame(width: 280 * 2, height: 360 * 2)
    }
}

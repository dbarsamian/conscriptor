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
    
    static func getIcon(for category: TemplateCategory) -> String {
        switch category {
        case .AllTemplates:
            return "rectangle.3.group"
        case .Basic:
            return "doc.plaintext"
        case .Blogging:
            return "books.vertical"
        case .Developer:
            return "hammer"
        }
    }
    
    case AllTemplates = "All Templates"
    case Basic = "Basic"
    case Blogging = "Blogging"
    case Developer = "Developer"
}

public struct Template: Identifiable {
    public var id: UUID = UUID()
    var templateType: TemplateCategory
    var document: String
    var name: String
    
    static let Presets: [Template] = [
        Template(templateType: .Basic, document: "", name: "Empty"),
        Template(templateType: .Basic, document: "# Notes\n\n## Subject 1\n\n- Note 1\n\n- Note 2\n\n- Note 3", name: "Note Taking"),
        Template(templateType: .Blogging, document: "# Title\n\n## Subtitle\n\n### Author\n\nStart writing... maybe insert [some links](https://www.youtube.com/watch?v=dQw4w9WgXcQ)", name: "Blog Post"),
        Template(templateType: .Developer, document: "# README\n\n## About The Project\n\nLorem ipsum...\n\n## Getting Started\n\nLorem ipsum...", name: "README.md"),
        Template(templateType: .Developer, document: "# Feature Name\n\n### Author\n\nA paragraph describing the feature...\n\n```\nExample\nblock\nof\ncode\n```", name: "Documentation")
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

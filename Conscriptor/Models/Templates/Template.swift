//
//  Template.swift
//  Conscriptor
//
//  Created by David Barsamian on 1/7/22.
//

import Foundation
import Ink
import SwiftUI

public enum TemplateCategory: String, CaseIterable, Identifiable {
    public var id: RawValue { rawValue }

    static func getIcon(for category: TemplateCategory) -> String {
        switch category {
        case .allTemplates:
            return "rectangle.3.group"
        case .basic:
            return "doc.plaintext"
        case .blogging:
            return "books.vertical"
        case .developer:
            return "hammer"
        case .user:
            return "person"
        }
    }

    case allTemplates = "All Templates"
    case basic
    case blogging
    case developer
    case user
}

public struct Template: Identifiable {
    public var id: UUID = .init()
    var templateType: TemplateCategory
    var document: String
    var name: String

    static let Presets: [Template] = [
        Template(templateType: .basic,
                 document: "",
                 name: "Empty"),
        Template(templateType: .basic,
                 document: "# Notes\n\n## Subject 1\n\n- Note 1\n\n- Note 2\n\n- Note 3",
                 name: "Note Taking"),
        Template(templateType: .blogging,
                 document: """
                 # Title

                 ## Subtitle

                 ### Author

                 Start writing... maybe insert [some links](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
                 """,
                 name: "Blog Post"),
        Template(templateType: .developer,
                 document: """
                 # README

                 ## About The Project

                 Lorem ipsum...

                 ## Getting Started

                 Lorem ipsum...
                 """,
                 name: "README.md"),
        Template(templateType: .developer,
                 document: """
                 # Feature Name

                 ### Author

                 A paragraph describing the feature...

                 ```
                 Example
                 block
                 of
                 code
                 ```
                 """,
                 name: "Documentation")
    ]
}

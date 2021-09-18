//
//  MarkdownManager.swift
//  Conscriptor
//
//  Created by David Barsamian on 9/16/21.
//

import Foundation

struct MarkdownFormatter {
    public enum Formatting: String, CaseIterable {
        case bold = "**"
        case italic = "*"
        case strikethrough = "~~"
        case code = "`"
    }
    
    
    public static func format(_ string: String, style: Formatting) -> String {
        switch(style) {
            case .bold:
                if string.range(of: CMarkdown.boldRegex, options: .regularExpression) != nil {
                    return format(string, style: .bold, wrapped: false)
                } else {
                    return format(string, style: .bold, wrapped: true)
                }
            case .italic:
                if string.range(of: CMarkdown.italicRegex, options: .regularExpression) != nil {
                    return format(string, style: .italic, wrapped: false)
                } else {
                    return format(string, style: .italic, wrapped: true)
                }
            case .strikethrough:
                if string.range(of: CMarkdown.strikethroughRegex, options: .regularExpression) != nil {
                    return format(string, style: .strikethrough, wrapped: false)
                } else {
                    return format(string, style: .strikethrough, wrapped: true)
                }
            case .code:
                if string.range(of: CMarkdown.inlineCodeRegex, options: .regularExpression) != nil {
                    return format(string, style: .code, wrapped: false)
                } else {
                    return format(string, style: .code, wrapped: true)
                }
        }
    }
    
    private static func format(_ string: String, style: Formatting, wrapped: Bool) -> String {
        var formattedString = ""
        if wrapped {
            formattedString = string
            formattedString.insert(contentsOf: style.rawValue, at: formattedString.startIndex)
            formattedString.append(style.rawValue)
        } else {
            formattedString = string.replacingOccurrences(of: style.rawValue, with: "")
        }
        return formattedString
    }
}

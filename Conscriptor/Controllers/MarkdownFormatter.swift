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

    /// Checks if a given string is formatted with a given Markdown syntax.
    /// - Parameter string: The string to check for Markdown syntax.
    /// - Parameter format: The Markdown syntax to check for.
    /// - Returns: True if the given string contains the given Markdown syntax.
    ///
    /// Example:
    /// ```
    /// let boldString = "**Hello**"
    /// let isBold = MarkdownFormatter.isFormatted(boldString, .bold) // True
    public static func isFormatted(_ string: String, as format: Formatting) -> Bool {
        switch format {
        case .bold:
            return string.range(of: CMarkdown.boldRegex, options: .regularExpression) != nil
        case .italic:
            return string.range(of: CMarkdown.italicRegex, options: .regularExpression) != nil
        case .strikethrough:
            return string.range(of: CMarkdown.strikethroughRegex, options: .regularExpression) != nil
        case .code:
            return string.range(of: CMarkdown.inlineCodeRegex, options: .regularExpression) != nil
        }
    }

    /// Checks if a given string contains any Markdown syntax.
    /// - Parameter string: The string to check for Markdown syntax.
    public static func containsFormatting(_ string: String) -> Bool {
        return string.range(of: CMarkdown.boldRegex, options: .regularExpression) != nil
            || string.range(of: CMarkdown.italicRegex, options: .regularExpression) != nil
            || string.range(of: CMarkdown.strikethroughRegex, options: .regularExpression) != nil
            || string.range(of: CMarkdown.inlineCodeRegex, options: .regularExpression) != nil
    }

    /// Returns a string that has been reformatted based on the given Markdown style. If the input `string` is already formatted with Markdown syntax, the function will return a string without the syntax.
    /// - Parameter string: The string to format.
    /// - Parameter style: The Markdown formatting to apply.
    /// - Returns: A new formatted string containing the syntax changes.
    /// - Warning: This function assumes that an unformatted string is the default state, so if it fails to find Markdown syntax around the string, it will return a string with the selected Markdown syntax surrounding it.
    ///
    /// The following example shows the two possible types of output:
    /// ```
    /// let string = "Hello"
    /// let boldString = "**Hello**"
    /// let emboldenedString = MarkdownFormatter.format(string, .bold) // Outputs "**Hello**"
    /// let revertedString = MarkdownFormatter.format(boldString, .bold) // Outputs "Hello"
    /// ```
    ///
    /// - Author: David Barsamian
    /// - Date: October 2, 2021
    public static func format(_ string: String, style: Formatting) -> String {
        switch style {
        case .bold:
            if isFormatted(string, as: .bold) {
                return format(string, style: .bold, wrapped: false)
            } else {
                return format(string, style: .bold, wrapped: true)
            }
        case .italic:
            if isFormatted(string, as: .italic) {
                return format(string, style: .italic, wrapped: false)
            } else {
                return format(string, style: .italic, wrapped: true)
            }
        case .strikethrough:
            if isFormatted(string, as: .strikethrough) {
                return format(string, style: .strikethrough, wrapped: false)
            } else {
                return format(string, style: .strikethrough, wrapped: true)
            }
        case .code:
            if isFormatted(string, as: .code) {
                return format(string, style: .code, wrapped: false)
            } else {
                return format(string, style: .code, wrapped: true)
            }
        }
    }

    /// Helper function that appends or removes a given Markdown syntax from a string.
    /// - Parameter string: The string to format.
    /// - Parameter style: The Markdown syntax to apply or remove.
    /// - Parameter wrapped: Does the string already contain Markdown syntax?
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

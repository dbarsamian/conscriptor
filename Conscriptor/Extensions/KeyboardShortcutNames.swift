//
//  KeyboardShortcutNames.swift
//  Conscriptor
//
//  Created by David Barsamian on 4/26/22.
//

import Carbon.HIToolbox
import KeyboardShortcuts
import SwiftUI

extension KeyboardShortcuts.Name {
    static let saveAsTemplate = Self("saveAsTemplate", default: Shortcut(.s, modifiers: [.control, .shift]))
    static let formatBold = Self("formatBold", default: Shortcut(.b, modifiers: [.command]))
    static let formatItalic = Self("formatItalic", default: Shortcut(.i, modifiers: [.command]))
    static let formatStrikethrough = Self("formatStrikethrough", default: Shortcut(.k, modifiers: [.command]))
    static let formatInlineCode = Self("formatInlineCode", default: Shortcut(.slash, modifiers: [.command]))
    static let insertImage = Self("insertImage", default: Shortcut(.i, modifiers: [.command, .option]))
    static let insertLink = Self("insertLink", default: Shortcut(.l, modifiers: [.command, .option]))
}

extension KeyboardShortcuts.Shortcut {
    func swiftUI() -> KeyboardShortcut {
        return KeyboardShortcut(transformKey(), modifiers: transformModifiers())
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func transformKey() -> KeyEquivalent {
        switch self.key!.rawValue {
        case kVK_ANSI_A: return "a"
        case kVK_ANSI_B: return "b"
        case kVK_ANSI_C: return "c"
        case kVK_ANSI_D: return "d"
        case kVK_ANSI_E: return "e"
        case kVK_ANSI_F: return "f"
        case kVK_ANSI_G: return "g"
        case kVK_ANSI_H: return "h"
        case kVK_ANSI_I: return "i"
        case kVK_ANSI_J: return "j"
        case kVK_ANSI_K: return "k"
        case kVK_ANSI_L: return "l"
        case kVK_ANSI_M: return "m"
        case kVK_ANSI_N: return "n"
        case kVK_ANSI_O: return "o"
        case kVK_ANSI_P: return "p"
        case kVK_ANSI_Q: return "q"
        case kVK_ANSI_R: return "r"
        case kVK_ANSI_S: return "s"
        case kVK_ANSI_T: return "t"
        case kVK_ANSI_U: return "u"
        case kVK_ANSI_V: return "v"
        case kVK_ANSI_W: return "w"
        case kVK_ANSI_X: return "x"
        case kVK_ANSI_Y: return "y"
        case kVK_ANSI_Z: return "z"
        case kVK_ANSI_0: return "0"
        case kVK_ANSI_1: return "1"
        case kVK_ANSI_2: return "2"
        case kVK_ANSI_3: return "3"
        case kVK_ANSI_4: return "4"
        case kVK_ANSI_5: return "5"
        case kVK_ANSI_6: return "6"
        case kVK_ANSI_7: return "7"
        case kVK_ANSI_8: return "8"
        case kVK_ANSI_9: return "9"
        case kVK_Return: return .return
        case kVK_ANSI_Backslash: return "\\"
        case kVK_ANSI_Grave: return "`"
        case kVK_ANSI_Comma: return ","
        case kVK_ANSI_Equal: return "="
        case kVK_ANSI_Minus: return "-"
        case kVK_ANSI_Period: return "."
        case kVK_ANSI_Quote: return "\""
        case kVK_ANSI_Semicolon: return "'"
        case kVK_ANSI_Slash: return "/"
        case kVK_Space: return .space
        case kVK_Tab: return .tab
        case kVK_ANSI_LeftBracket: return "["
        case kVK_ANSI_RightBracket: return "]"
        case kVK_PageUp: return .pageUp
        case kVK_PageDown: return .pageDown
        case kVK_Home: return .home
        case kVK_End: return .end
        case kVK_UpArrow: return .upArrow
        case kVK_RightArrow: return .rightArrow
        case kVK_DownArrow: return .downArrow
        case kVK_LeftArrow: return .leftArrow
        case kVK_Escape: return .escape
        case kVK_Delete: return .delete
        case kVK_ForwardDelete: return .deleteForward
        case kVK_F1: return KeyEquivalent(Character(UnicodeScalar(NSF1FunctionKey)!))
        case kVK_F2: return KeyEquivalent(Character(UnicodeScalar(NSF2FunctionKey)!))
        case kVK_F3: return KeyEquivalent(Character(UnicodeScalar(NSF3FunctionKey)!))
        case kVK_F4: return KeyEquivalent(Character(UnicodeScalar(NSF4FunctionKey)!))
        case kVK_F5: return KeyEquivalent(Character(UnicodeScalar(NSF5FunctionKey)!))
        case kVK_F6: return KeyEquivalent(Character(UnicodeScalar(NSF6FunctionKey)!))
        case kVK_F7: return KeyEquivalent(Character(UnicodeScalar(NSF7FunctionKey)!))
        case kVK_F8: return KeyEquivalent(Character(UnicodeScalar(NSF8FunctionKey)!))
        case kVK_F9: return KeyEquivalent(Character(UnicodeScalar(NSF9FunctionKey)!))
        case kVK_F10: return KeyEquivalent(Character(UnicodeScalar(NSF10FunctionKey)!))
        case kVK_F11: return KeyEquivalent(Character(UnicodeScalar(NSF11FunctionKey)!))
        case kVK_F12: return KeyEquivalent(Character(UnicodeScalar(NSF12FunctionKey)!))
        case kVK_F13: return KeyEquivalent(Character(UnicodeScalar(NSF13FunctionKey)!))
        case kVK_F14: return KeyEquivalent(Character(UnicodeScalar(NSF14FunctionKey)!))
        case kVK_F15: return KeyEquivalent(Character(UnicodeScalar(NSF15FunctionKey)!))
        case kVK_F16: return KeyEquivalent(Character(UnicodeScalar(NSF16FunctionKey)!))
        case kVK_F17: return KeyEquivalent(Character(UnicodeScalar(NSF17FunctionKey)!))
        case kVK_F18: return KeyEquivalent(Character(UnicodeScalar(NSF18FunctionKey)!))
        case kVK_F19: return KeyEquivalent(Character(UnicodeScalar(NSF19FunctionKey)!))
        case kVK_F20: return KeyEquivalent(Character(UnicodeScalar(NSF20FunctionKey)!))
        default: return KeyEquivalent(Character(""))
        }
    }

    func transformModifiers() -> SwiftUI.EventModifiers {
        let modifier = [SwiftUI.EventModifiers.shift.rawValue, SwiftUI.EventModifiers.control.rawValue]
        print(modifier)
        return SwiftUI.EventModifiers(rawValue: Int(self.modifiers.rawValue))
//        print(self.modifiers)
//        var modifiers = SwiftUI.EventModifiers()
//        print(SwiftUI.EventModifiers(rawValue: Int(self.modifiers.rawValue)))
//        switch self.modifiers {
//        case .capsLock: modifiers.insert(.capsLock)
//        case .shift: modifiers.insert(.shift)
//        case .control: modifiers.insert(.control)
//        case .option: modifiers.insert(.option)
//        case .command: modifiers.insert(.command)
//        case .numericPad: modifiers.insert(.numericPad)
//        default: break
//        }
//        print(modifiers)
//        return modifiers
    }
}

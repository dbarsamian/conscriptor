//
//  OSLogExtension.swift
//  Conscriptor
//
//  Created by David Barsamian on 2/4/22.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let persistence = OSLog(subsystem: subsystem, category: "persistence")
}

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
}

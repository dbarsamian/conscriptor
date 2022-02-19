//
//  Persistence.swift
//  Conscriptor
//
//  Created by David Barsamian on 2/4/22.
//

import CoreData
import Foundation
import os.log

struct PersistenceController {
    enum PersistenceSaveResults {
        case success
        case error
        case noChanges
    }

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        for previewN in 0 ..< 4 {
            let userTemplate = UserTemplate(context: controller.container.viewContext)
            userTemplate.name = "User Template \(previewN)"
            userTemplate.document = "# User Template \(previewN)"
        }
        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "UserTemplate")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Persistence Error: \(error.localizedDescription)")
            }
        }
    }

    func save() -> PersistenceSaveResults {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return .success
            } catch {
                Logger.persistence.error("""
                "Persistence threw an error while trying to save: \(error.localizedDescription)
                """)
                return .error
            }
        } else {
            return .noChanges
        }
    }
}

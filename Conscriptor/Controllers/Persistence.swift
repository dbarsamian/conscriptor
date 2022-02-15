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
        case Success
        case Error
        case NoChanges
    }
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        for n in 0 ..< 4 {
            let userTemplate = UserTemplate(context: controller.container.viewContext)
            userTemplate.name = "User Template \(n)"
            userTemplate.document = "# User Template \(n)"
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
                return .Success
            } catch {
                Logger.persistence.error("Persistence threw an error while trying to save: \(error.localizedDescription)")
                return .Error
            }
        } else {
            return .NoChanges
        }
    }
}

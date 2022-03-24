//
//  ViewSnapshot.swift
//  Conscriptor
//
//  Created by David Barsamian on 3/23/22.
//

import Foundation
import SwiftUI

extension View {
    func snapshot() -> NSImage {
        let controller = NSHostingController(rootView: self)
        let view = controller.view

        let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds)
        guard let bitmap = bitmap else {
            return NSImage(size: .zero)
        }

        view.cacheDisplay(in: view.bounds, to: bitmap)
        let image = NSImage(size: bitmap.size)
        image.addRepresentation(bitmap)
        return image
    }
}

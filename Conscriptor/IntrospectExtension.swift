//
//  IntrospectExtension.swift
//  IntrospectExtension
//
//  Created by David Barsamian on 9/1/21.
//

import Foundation
import Introspect
import SwiftUI

extension View {
    public func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
        return inject(AppKitIntrospectionView(selector: { introspectionView in
            guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                return nil
            }
            return Introspect.previousSibling(containing: NSSplitView.self, from: viewHost)
        }, customize: customize))
    }
}

//
//  TemplateView.swift
//  Conscriptor
//
//  Created by David Barsamian on 2/4/22.
//

import Parsley
import SwiftUI

struct TemplateView: View {
    let template: Template

    var html: String {
        do {
            return try Parsley.html(template.document)
        } catch {
            return ""
        }
    }

    var body: some View {
        WebView(html, type: .html)
            .frame(width: 280 * 2, height: 360 * 2)
    }
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateView(template: .Presets.first!)
            .previewLayout(.fixed(width: 280, height: 360))
    }
}

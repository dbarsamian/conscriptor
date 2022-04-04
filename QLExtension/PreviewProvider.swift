//
//  PreviewProvider.swift
//  QLExtension
//
//  Created by David Barsamian on 4/4/22.
//

import Cocoa
import Ink
import QuickLookUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    static let markdownParser = MarkdownParser()

    /*
     Use a QLPreviewProvider to provide data-based previews.

     To set up your extension as a data-based preview extension:

     - Modify the extension's Info.plist by setting
       <key>QLIsDataBasedPreview</key>
       <true/>

     - Add the supported content types to QLSupportedContentTypes array in the extension's Info.plist.

     - Change the NSExtensionPrincipalClass to this class.
       e.g.
       <key>NSExtensionPrincipalClass</key>
       <string>$(PRODUCT_MODULE_NAME).PreviewProvider</string>

     - Implement providePreview(for:)
     */

    func providePreview(for request: QLFilePreviewRequest,
                        completionHandler handler: @escaping (QLPreviewReply?, Error?) -> Void) {
        let contentType = UTType.html
        let reply = QLPreviewReply(dataOfContentType: contentType,
                                   contentSize: CGSize(width: 800, height: 800)) { (replyToUpdate: QLPreviewReply) in
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let html = """
            <html>
            <head>
            <link rel=\"stylesheet\" href=\"cid:stylesheet\">
            </head>
            <body>
            \(Self.markdownParser.html(from: fileContents))
            </body>
            </html>
            """
            guard let data = html.data(using: .utf8) else {
                fatalError()
            }

            guard let stylesheetURL = Bundle.main.url(forResource: "github-preview", withExtension: "css"),
                  let stylesheetData = try? Data(contentsOf: stylesheetURL) else {
                fatalError()
            }

            replyToUpdate.stringEncoding = .utf8

            replyToUpdate.attachments["stylesheet"] = QLPreviewReplyAttachment(data: stylesheetData, contentType: .html)

            return data
        }
        reply.stringEncoding = .utf8
        reply.title = "HTML"
        handler(reply, nil)
    }

//    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
//        // You can create a QLPreviewReply in several ways, depending on the format of the data you want to return.
//        // To return Data of a supported content type:
//
//        let contentType = UTType.text // replace with your data type
//
//        let reply = QLPreviewReply(dataOfContentType: contentType,
//                                   contentSize: CGSize(width: 800, height: 800)) { (replyToUpdate: QLPreviewReply) in
//
//        }
//
//        return reply
//    }

    private func getStyleSheet() -> String {
        guard let path = Bundle.main.path(forResource: "github", ofType: "css"),
              let cssString = try? String(contentsOfFile: path, encoding: .utf8)
              .components(separatedBy: .newlines)
              .joined()
        else {
            fatalError()
        }

        return cssString
    }
}

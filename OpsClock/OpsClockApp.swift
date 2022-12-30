//
//  OpsClockApp.swift
//  OpsClock
//
//  Created by Daniel Skowroński on 29/12/2022.
//

import SwiftUI
import AttributedText

@main
struct OpsClockApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {        
        AttributedText.tags = [
            "large": { $0.font(Font.custom("UbuntuMono-Bold", size: 2048)) },
            "small": { $0.font(Font.custom("UbuntuMono-Bold", size: 1024)) },
        ]
        /*
         AttributedText with custom tags used here because:
            - can't have multiple Text objects in HStack that would scale together natively without grid
              (i.e. one of font size 2x and other of 1x, without ton of shitty event processing)
            - but with grid the font scaling is always clipping to proper font sizes (integers and not all of them)
              so text alignement tends to break on smaller sizes,
              not to mention issues with frame scaling and aspect ratio
            - can't use NSAttributedString as NSAttributedStringKey.font expects value of UIFont,
              which is part of UIKit which is not available on macOS
            - also markdown renderer can't handle multiple sizes in single line
         */
    }
    
}

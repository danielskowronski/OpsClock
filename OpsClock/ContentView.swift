//
//  ContentView.swift
//  OpsClock
//
//  Created by Daniel Skowroński on 29/12/2022.
//

import SwiftUI
import CoreData

struct MainClockView: View {
    @State var date = Date()
        
    let bigFont = Font.custom("Ubuntu Mono", size: 2048, relativeTo: .largeTitle)
    let smallFont = Font.custom("Ubuntu Mono", size: 1024, relativeTo: .largeTitle)
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true,
                             block: {_ in
                                 self.date = Date()
            
                               })
    }
    
    
    let ratioOfLargeClock = 8.0/9; // "12:34:56.7" is LLLLLLLLSS, wher L=large font, S=small font, which is 0.5 of L
    let ratioOfHeighToWidth = (1.0/9) / (1.0/2); // 1/9 is ratio of L-glyph width to window width, 1/2 is width to height ratio of Ubuntu Mono - see https://ubuntu.com/blog/ubuntu-monospace-beta
    
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Text("\(mainClockString(date: date))")
                        .font(bigFont)
                        .frame(width: geometry.size.width * (ratioOfLargeClock))
                        .frame(height: geometry.size.width * (ratioOfHeighToWidth))
                    
                    Text("\(millisecondClockString(date: date))")
                        .font(smallFont)
                        .frame(width: geometry.size.width * (1 - ratioOfLargeClock))
                        .frame(height: geometry.size.width * (ratioOfHeighToWidth))
                }
                .minimumScaleFactor(0.01)
            }
            
            .onAppear(perform: {
                let _ = self.updateTimer;
                
                
            })
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
                if let window = notification.object as? NSWindow {
                    window.level = .floating
                    //window.aspectRatio = NSSize(width: 9, height: 2.1)
                }
            }
            
            
            
        }
    }
    
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        TabView {
            MainClockView()
                .tabItem {
                    Label("Clock", systemImage: "clock")
                }.aspectRatio(9.0/2.5, contentMode: .fit).padding(20)
        }
    }
        
    
    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize { let mySize = NSSize(width: frameSize.width, height: frameSize.width * 2); return mySize }

    
}

var mainClockFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}
func mainClockString(date: Date) -> String {
     let time = mainClockFormatter.string(from: date)
     return time
}

var millisecondClockFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = ".S"
    return formatter
}
func millisecondClockString(date: Date) -> String {
     let time = millisecondClockFormatter.string(from: date)
     return time
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

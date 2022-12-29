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
    

    
    var body: some View {
        HStack (alignment: .firstTextBaseline) {
            Text("\(mainClockString(date: date))")
                .font(
                    .custom(
                        "Ubuntu Mono",
                        size: 100)
                )
            
            Text("\(millisecondClockString(date: date))")
                .font(
                    .custom(
                        "Ubuntu Mono",
                        size: 50)
                )
        }
        .onAppear(perform: {
            let _ = self.updateTimer;
            
            
        })
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
            if let window = notification.object as? NSWindow {
                window.level = .floating
            }
        }
        
        
    }
    
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true,
                             block: {_ in
                                 self.date = Date()
            
                               })
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
                }
        }
    }
    
    
    
}

var mainClockFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ss"
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

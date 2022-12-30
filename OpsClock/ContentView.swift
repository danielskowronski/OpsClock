//
//  ContentView.swift
//  OpsClock
//
//  Created by Daniel Skowroński on 29/12/2022.
//

import SwiftUI
import CoreData
import AttributedText

struct AboutView: View {
    var body: some View {
        VStack{
            Text("© Daniel Skowroński, 2022")
            
            Link("https://github.com/danielskowronski/OpsClock", destination: URL(string: "https://github.com/danielskowronski/OpsClock")!)
        }
    }
}

struct MainClockView: View {
    @State var date = Date()
    
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true,
                             block: {_ in
            self.date = Date()
        })
    }
    
    var body: some View {
        AttributedText("\(clockString(date: date))") //Attributed
            .scaledToFit()
            .minimumScaleFactor(0.001)
            .onAppear(perform: {
                let _ = self.updateTimer;
            })
            #if os(macOS)
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
                if let window = notification.object as? NSWindow {
                    window.level = .floating
                }
            }
            #endif
    }
}

struct ContentView: View {   
    var body: some View {
        TabView {
            MainClockView()
                .tabItem {
                    Label("Clock", systemImage: "clock")
                }.padding(20)
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }.padding(20)
        }
    }
}

var clockFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
}
var milliFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = ".S"
    return formatter
}

func clockString(date: Date) -> String {
    let clockString = clockFormatter.string(from: date);
    let milliString = milliFormatter.string(from: date);
    return "<large>"+clockString+"</large><small>"+milliString+"</small>";
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//
//  ReflowApp.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import SwiftUI
import Cocoa


@main
struct ReflowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
   
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
    
    
    func Notify(message:String){
        
        
    }

}

class AppDelegate: NSObject,NSApplicationDelegate{
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        
        if let statusButton = statusItem.button{
            if let customeImage = NSImage(named:"icon"){
                statusButton.image = customeImage
                statusButton.action = #selector(self.toggle_manu)
            }
            
            statusButton.action = #selector(self.toggle_manu)
            
        }
    }
    
    @objc private func toggle_manu(){
               let menu = NSMenu()
        
               let contentView = NSHostingView(rootView: ContentView())
        
               let customMenuItem = NSMenuItem()
               customMenuItem.view = contentView
                customMenuItem.isEnabled = false
               menu.addItem(customMenuItem)
                
     
               menu.addItem(.separator())	
               
          
               let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
               menu.addItem(quitMenuItem)
               
     
               statusItem.popUpMenu(menu)
    }
}

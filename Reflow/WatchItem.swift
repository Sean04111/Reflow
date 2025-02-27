//
//  WatchItem.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import SwiftUI
import AppKit
import Foundation

protocol Watchable {
    func Get_id()-> UUID
    func Start()-> ERROR_TYPE
    func End()-> ERROR_TYPE
}

struct WatchItem : Watchable{
    let item_name : String
    let id = UUID()
    let start_script : String
    let end_script : String
    
    init(_ item_name: String, start_script: String, end_script: String) {
        self.item_name = item_name
        self.start_script = start_script
        self.end_script = end_script
    }
    
    private func script_Execute(script:String) -> ERROR_TYPE {
        do {
            let scriptContent = try String(contentsOfFile: "./Scripts/"+script)
            
            let appleScript = NSAppleScript(source: scriptContent)
            
            var error: NSDictionary?
            
            let result = appleScript?.executeAndReturnError(&error)
            
            if let error = error{
                return SCRIPT_EXECUTE_ERROR + error.description
            }else{
                return OK
            }
        }catch{
            return SCRIPT_NOT_FOUND
        }
    }
    
    
    func Get_id() -> UUID{
        return self.id
    }
    
    func Start() -> ERROR_TYPE{
        return self.script_Execute(script: self.start_script)
    }
    
    func End()-> ERROR_TYPE{
        let exec_err = self.self.script_Execute(script: self.end_script)
        if exec_err != OK{
            return exec_err
        }else{
            return OK
        }
    }
}



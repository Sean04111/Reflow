//
//  WatchItem.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import SwiftUI
import AppKit
import Foundation
import Carbon

// for those item has status to keep
class MetaData {
    private var data : String
    private var key : String
    private var version: MetaVersion
    
    private var persister : any Persister = File_Persistance()
  
    init(data: String, key: String) {
        self.data = data
        self.version = MetaVersion()
        
        self.key = key
    }
    
   
    
    private func write () -> RESULT_TYPE{
        let res = self.persister.Write(key: self.key, data: self.data)
        return res.result
    }
    
    private func read () -> RESULT_TYPE{
        let res = self.persister.Read(key: self.key)
        if res.result == RESULT_OK{
            self.data = res.data
        }
        return res.result
    }
    
    // TODO: add version control
    func Update(new: String) -> RESULT_TYPE{
        self.data = new
        return self.write()
    }
    
    func Load() -> RESULT_TYPE{
        return self.read()
    }
    
    func Get_data()-> String{
        return self.data
    }
}

protocol Watchable {
    func GetId()-> String
    func GetStatus() -> WATCHITEM_STATUS
    func GetMeta() -> MetaData
    func UpdateMeta(newMeta: MetaData) -> RESULT_TYPE
    func Start()-> RESULT_TYPE
    func End()-> RESULT_TYPE
}

class WatchItem : Watchable{
    let item_name : String
    let id = UUID()
    let start_script : String
    let end_script : String
    
    private var status: WATCHITEM_STATUS
    
    private var meta: MetaData
    
    init(_ item_name: String, start_script: String, end_script: String) {
        self.item_name = item_name
        self.start_script = start_script
        self.end_script = end_script
        
        self.status = WATCHITEM_STATUS.UNSTARTED
        
        //TODO: fix here
        self.meta = MetaData(data: "",key: self.id.uuidString)
    }
    
    private func execute_script(bin:String,script: String,args:[String]) -> (result: RESULT_TYPE, output: String?) {
        
        //TODO: componentialize the config part
        let scriptPath = "/Users/sean/Workspace/swiftjob/Reflow/Reflow/Scripts/" + script
        let task = Process()
        
        task.executableURL = URL(fileURLWithPath: bin)
        var dollors : [String] = [scriptPath]
        dollors.append(contentsOf: args)
        task.arguments = dollors
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
            
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            return (RESULT_OK, output)
        } catch {
            return (RESULT_SCRIPT_EXECUTE_ERROR, "\(error)")
        }
        
    }
    
    
    
    func GetId() -> String{
        return self.id.uuidString
    }
    
    func GetStatus() -> WATCHITEM_STATUS {
        return self.status
    }
    
    func GetMeta() -> MetaData {
        return self.meta
    }
    
    func UpdateMeta(newMeta: MetaData) -> RESULT_TYPE {
        self.meta = newMeta
        return RESULT_OK
    }
    
    func Start() -> RESULT_TYPE{
        if self.status == WATCHITEM_STATUS.WORKING_ON {
            return RESULT_OK
        }
        
        
//        let meta_res = self.meta.Load()
//        if meta_res != RESULT_OK{
//            return meta_res
//        }
        
        let script_res = self.execute_script(bin:"/usr/bin/osascript",script: self.start_script,args: [self.meta.Get_data()])
        if script_res.result != RESULT_OK{
            return script_res.result
        }
        
        self.status = WATCHITEM_STATUS.WORKING_ON
        
        return RESULT_OK
    }
    
    func End()-> RESULT_TYPE{
        if self.status == WATCHITEM_STATUS.UNSTARTED{
            return RESULT_OK
        }
        
        let script_res = self.execute_script(bin:"/usr/bin/osascript",script: self.start_script,args: [self.meta.Get_data()])
        
        if script_res.result != RESULT_OK{
            return script_res.result
        }
        
        let res = self.meta.Update(new: script_res.output ?? "")
        if res != RESULT_OK{
            return res
        }
        
        self.status = WATCHITEM_STATUS.UNSTARTED
        
        
        return RESULT_OK
    }
}



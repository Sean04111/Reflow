//
//  WatchItem.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import SwiftUI
import AppKit
import Foundation

// for those item has status to keep
class MetaData {
    private var data : String
    private var key : String
    private var version: MetaVersion
    
    private var persister : any Persister = File_Persistance()
  
    init(data: String, item_name : String) {
        self.data = data
        self.version = MetaVersion()
        
        self.key = item_name
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
    func Get_id()-> UUID
    func Get_Status() -> WATCHITEM_STATUS
    func Start()-> RESULT_TYPE
    func End()-> RESULT_TYPE
}

class   WatchItem : Watchable{
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
        self.meta = MetaData(data: "",item_name: self.item_name)
    }
    
    private func script_execute(script:String) -> (result:RESULT_TYPE,output:String) {
        do {
            //TODO: add parameters here
            let scriptContent = try String(contentsOfFile: "./Scripts/"+script)
            
            let appleScript = NSAppleScript(source: scriptContent)
            
            let arguementList = [self.meta.Get_data()] as NSArray
            
            var error: NSDictionary?
        
            if let result = appleScript?.executeAndReturnError(&error){
                // check if the item has metadata (e.g. chrome's url)
                if let outputString = result.stringValue{
                    return (RESULT_OK, outputString)
                }
                // no metadata
                return (RESULT_OK,"")
            }else{
                if let errorInfo = error{
                    return (RESULT_SCRIPT_EXECUTE_ERROR + errorInfo.description,"")
                }else{
                    return (RESULT_UNKNOWN,"")
                }
                
            }
        }catch{
            return (RESULT_SCRIPT_NOT_FOUND,"")
        }
    }
    
    
    func Get_id() -> UUID{
        return self.id
    }
    
    func Get_Status() -> WATCHITEM_STATUS {
        return self.status
    }
    
    func Start() -> RESULT_TYPE{
        if self.status == WATCHITEM_STATUS.WORKING_ON {
            return RESULT_OK
        }
        
        
        let meta_res = self.meta.Load()
        if meta_res != RESULT_OK{
            return meta_res
        }
        
        let script_res = self.script_execute(script: self.start_script)
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
        
        let script_res = self.self.script_execute(script: self.end_script)
        
        
        if script_res.result != RESULT_OK{
            return script_res.result
        }
        let res = self.meta.Update(new: script_res.output)
        if res != RESULT_OK{
            return res
        }
        
        self.status = WATCHITEM_STATUS.UNSTARTED
        
        
        return RESULT_OK
    }
}



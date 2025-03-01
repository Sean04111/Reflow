//
//  Persistance.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import Foundation

let PERSISTANT_PREFIX_METADATA = "metadata"
let PERSISTANT_PREFIX_FLOW = "flow"
let PERSISTANT_PREFIX_MONITOR = "monitor"

// use single String for data first
protocol Persister {
    func Read(key:String) -> (data:String, result:RESULT_TYPE)
    func Append(key:String,data:String) -> (data:String,result:RESULT_TYPE)
    func Remove(key:String) -> (data:String,result:RESULT_TYPE)
    func Update(key:String) -> (data:String, result:RESULT_TYPE)
    func Test()-> RESULT_TYPE
}
  
class File_Persistance : Persister{
    private var filepath : String

    
    init(_ filepath:String){
        self.filepath = filepath
    }
    
    func Test() -> RESULT_TYPE {
        let filemanager = FileManager.default
        if !filemanager.fileExists(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_EXIST
        }
        
        if !filemanager.isReadableFile(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_READABLE
        }
        
        if !filemanager.isWritableFile(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_WRITABLE
        }
        
        return RESULT_OK
    }
    
    func Append(key: String, data: String) -> (data: String, result: RESULT_TYPE) {
     
        
        
        return (data,RESULT_OK)
    }
    
    func Remove(key: String) -> (data: String, result: RESULT_TYPE) {
        <#code#>
    }
    
    func Read(key: String) -> (data: String, result: RESULT_TYPE) {
        return ("fuck", RESULT_OK)
    }
    
    func Update(key: String) -> (data: String, result: RESULT_TYPE) {
        <#code#>
    }
    
    

    

}

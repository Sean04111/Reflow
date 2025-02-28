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


protocol Persister {
    func Read(key:String) -> (data:String, result:RESULT_TYPE)
    func Write(key:String,data:String) -> (data:String,result:RESULT_TYPE)
    
}

class File_Persistance : Persister{
    func Read(key: String) -> (data: String, result: RESULT_TYPE) {
        return ("fuck", RESULT_OK)
    }
    
    func Write(key: String, data: String) -> (data: String, result: RESULT_TYPE) {
        return (data,RESULT_OK)
    }
    

    
    init(){}
    
    func Record(){
        
    }
    
}

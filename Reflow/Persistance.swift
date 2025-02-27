//
//  Persistance.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import Foundation

protocol Persister {
    func Read(key:String) -> (data:String, result:RESULT_TYPE)
    func Write(key:String,data:String) -> (data:String,result:RESULT_TYPE)
    
}

class File_Persistance : Persister{
    func Read(key: String) -> (data: String, result: RESULT_TYPE) {
        <#code#>
    }
    
    func Write(key: String, data: String) -> (data: String, result: RESULT_TYPE) {
        <#code#>
    }
    

    
    init(){}
    
    func Record(){
        
    }
    
}

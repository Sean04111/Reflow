//
//  MetaVersion.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

struct MetaVersion {
    private var data : String
//    private var tag : String
    
    init() {
        self.data = meta_version_gen()
    }
    
    func Add(){}
    
    func Reset(){}
}

func meta_version_gen()->String{
    return ""
}



//
//  ZiraatRequestConvertable.swift
//  ZiraatAppAssistant-SPM
//
//  Created by ZT-bkabadayi on 17.10.2025.
//

import Foundation

public protocol ZiraatRequestConvertible: Encodable {
    func toProperDict() -> [String : Any?]
    func toProperRequestData() throws -> Data
}

public extension ZiraatRequestConvertible {
    
    func toProperDict() -> [String : Any?] {
        let mirror = Mirror(reflecting: self)
        var jsonDict: [String : Any?] = [:]
        
        for (propName, propValue) in mirror.children {
            if let propName = propName {
                var mutablePropValue: Any?
                let properPropName = propName.prefix(1).lowercased() + propName.dropFirst()
                
                if propValue is ZiraatRequestConvertible {
                    mutablePropValue = (propValue as! ZiraatRequestConvertible).toProperDict()
                } else {
                    mutablePropValue = propValue
                }
                
                jsonDict[properPropName] = mutablePropValue
            }
        }
        
        return jsonDict
    }
    
    func toProperRequestData() throws -> Data {
        let jsonDict = toProperDict()
        
        let data = try JSONSerialization.data(withJSONObject: jsonDict)
        return data
    }
}

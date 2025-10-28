//
//  ZiraatRequest.swift
//  ZiraatAppAssistant-SPM
//
//  Created by ZT-bkabadayi on 17.10.2025.
//

import Foundation

public protocol ZiraatRequest: ZiraatRequestConvertible {
    associatedtype Response: ZiraatResponse
}

public class ZiraatRequestModel: ZiraatRequest {
    public typealias Response = ZiraatResponseModel
    
    public var isNewVersion: Bool = false
}

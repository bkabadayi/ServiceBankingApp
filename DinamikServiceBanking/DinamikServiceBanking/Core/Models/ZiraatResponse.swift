//
//  ZiraatResponse.swift
//  ZiraatAppAssistant-SPM
//
//  Created by ZT-bkabadayi on 17.10.2025.
//

import Foundation

public protocol ZiraatResponse: Decodable { }

public class ZiraatResponseModel: ZiraatResponse {
    public var header: String = ""
}


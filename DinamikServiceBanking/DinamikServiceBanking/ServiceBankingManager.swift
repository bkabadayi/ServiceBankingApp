//
//  ServiceBankingManager.swift
//  DinamikServiceBanking
//
//  Created by ZT-bkabadayi on 28.10.2025.
//

import Foundation

public final class ServiceBankingManager: NSObject {
    
    private override init() { }
    
    public static let `default`: ServiceBankingManager = .init()
    
    public let serviceManager: ServiceManager = .init()
}

//
//  NetworkManager.swift
//  DinamikServiceBanking
//
//  Created by ZT-bkabadayi on 28.10.2025.
//

import Foundation
import UIKit
internal import Alamofire
internal import ZiraatSealMFA

public class ZiraatServiceManager: NSObject {
    
    private enum BaseURL {
        static let forUAT = "http://194.24.225.140:9002/api/base/call"
    }
    
    public enum TransactionName: String {
        case fetchInvestment = "FetchInvestment"
    }
    
    // MARK: - Typealias
    
    public typealias ServiceCompletionHandler<Response: ZiraatResponse> = ((Response?, String?) -> Void)
    
    public func fetchData<Request: ZiraatRequest>(from endpoint: TransactionName, request: Request, completion: @escaping ServiceCompletionHandler<Request.Response>) {
        var afRequest = try! URLRequest(url: URL(string: BaseURL.forUAT)!, method: .post)
        setHTTPHeaders(of: &afRequest, accordingTo: endpoint.rawValue)
        afRequest.httpBody = try! request.toProperRequestData()
        
        AF.request(afRequest).response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        let dataModel = try! JSONDecoder().decode(Request.Response.self, from: data)
                        completion(dataModel, nil)
                    } else {
                        completion(nil, "Data is not coming...")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
    }
    
    private func setHTTPHeaders(of request: inout URLRequest, accordingTo endpoint: String) {
        request.setValue("gzip", forHTTPHeaderField: "Accept")
        request.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("(ZiraatMobile / 3.0.30) - (iPhone; / iOS: 18.6 / Scale: 3.00)", forHTTPHeaderField: "User-Agent")
        request.setValue("en-TR;q=1, tr-TR;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("[{\"Version\":\"v3.0.30\",\"ClientType\":\"1\"}]", forHTTPHeaderField: "Version")
        
        switch endpoint {
        case "FirstLogin", "SealFirstLogin":
            request.setValue("true", forHTTPHeaderField: "isMobilFirstLogin")
            request.setValue("false", forHTTPHeaderField: "isMobilSecondLogin")
        case "SecondLogin", "SealPinLogin":
            request.setValue("false", forHTTPHeaderField: "isMobilFirstLogin")
            request.setValue("true", forHTTPHeaderField: "isMobilSecondLogin")
        default:
            request.setValue("false", forHTTPHeaderField: "isMobilFirstLogin")
            request.setValue("false", forHTTPHeaderField: "isMobilSecondLogin")
        }
    }
    
    private func getGeneratedHeaderForRequest(with endpoint: String) -> ZiraatHeaderModel {
        var header = ZiraatHeaderModel()
        
        header.channelType = 11
        header.clientIp = "127.0.0.1"
        header.clientType = 1
        header.culture = CultureType(rawValue: 0)! // bakcam
        header.customerId = "12" // self.context.session.customerId
        header.customerType = CustomerType(rawValue: 0)!
        header.DH2 = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header.isSecureLoginVersion = true
        header.isSecurityStepVersion = true
        header.methodType = 4
        header.roleId = 12 // bakcam
        header.sessionToken = "self.context.session.sessionId"
        header.transactionName = endpoint
        header.userName = "self.context.session.userName"
        header.bundleId = 10 //self.configuration.get(.bundleId) ?? 10
        header.AX1 = false
        
        #if targetEnvironment(simulator)
        header.BZ3 = true
        #else
        header.BZ3 = false
        #endif
        
        header.oct = "self.context.session.string(.octToken)"
        header.octChallengeToken = "context.session.string(.octChallengeToken)"
        header.isNewVersion = true
        
        header.loginViaTouchId = false
        header.actualTransactionName = endpoint
        
//        if !self.context.session.userId.isEmpty {
//            header.userId = Int64("self.context.session.userId")!
//        }
        
//        var secretString = String(bytes: SecretBuffer, encoding: .utf8)!
//        let hashKeyString = secretString + header.customerId + header.transactionName + header.sessionToken
//        header.key = hashKeyString.sha256()
        
        // Check if request holding two factory authentication info
//        if let twoFactorInfoRequest = request as? ZiraatTwoFactorAuthenticationInfoHolder {
//            // Get two factor authentication info
//            let smsLogId = twoFactorInfoRequest.smsLogId
//            let otpPin = twoFactorInfoRequest.otpPin
//            let smsPin = twoFactorInfoRequest.smsPin
//
//            // Initialize two factor authentication model
//            header.isTwoFactorTransaction = twoFactorInfoRequest.isTwoFactorTransaction
//            header.twoFactorAuthenticationInfo = ZiraatHeaderTwoFactorAuthenticationInfoModel()!
//            header.twoFactorAuthenticationInfo.otpPin = ""
//            header.twoFactorAuthenticationInfo.smsLogId = self.context.session.long(.smsLogId) ?? smsLogId
//            header.twoFactorAuthenticationInfo.smsPin = ""
//            header.twoFactorAuthenticationInfo.sealAuthorizationId = twoFactorInfoRequest.sealAuthorizationId
//            header.twoFactorAuthenticationInfo.isSMSOTP = twoFactorInfoRequest.isSMSOTP
//            header.isSMSOTP = twoFactorInfoRequest.isSMSOTP ?? false
//
//            // Obtain encryption keys
//            let encryptionKeys: EncryptionKeysModel = self.objectStore.object(.encryptionKeys) ?? EncryptionKeysModel()!
//
//            // Check if otp pin is specified
//            if !otpPin.isEmpty {
//                // Then encrypt it and append to header
//                header.twoFactorAuthenticationInfo.otpPin = ZiraatEncryptor.encrypt(plainString: otpPin, key: encryptionKeys.key, iv: encryptionKeys.iv)
//            }
//
//            // Check if sms pin is specified
//            if !smsPin.isEmpty {
//                // Then encrypt it and append to header
//                header.twoFactorAuthenticationInfo.smsPin = ZiraatEncryptor.encrypt(plainString: smsPin, key: encryptionKeys.key, iv: encryptionKeys.iv)
//            }
//
//            header.twoFactorAuthenticationInfo.smsLogId = smsLogId
//            if !isTwoFactorTransaction {
//                header.isTwoFactorTransaction = twoFactorInfoRequest.isTwoFactorTransaction
//            } else {
//                header.isTwoFactorTransaction = true
//            }
//        }
//
//        // Return header model
        return header
    }
}


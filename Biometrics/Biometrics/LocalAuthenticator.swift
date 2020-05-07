//
//  LocalAuthenticator.swift
//  Biometrics
//
//  Created by avinash gautham on 07/05/20.
//  Copyright © 2020 Avinash Gautam. All rights reserved.
//

import Foundation
import LocalAuthentication

enum LocalAuthenticatorError: Error {
    case biometricsNotAvailable
    case forwarded(Error?)
    case unknown
}

typealias LocalAuthenticatorCompletion = (_ success: Bool, _ error: LocalAuthenticatorError?) -> Void

final class LocalAuthenticator {
    private let authenticationContext = LAContext()
    private let biometricDescription: String
    
    ///face-ID description can be state only in info.plist file
    init(description: String) {
        self.biometricDescription = description
    }
    
    private func isBiometricsAvailable() -> Bool {
        switch self.authenticationContext.biometryType {
        case .none:
            return false
        default:
            return true
        }
    }
    
    public func authenticate(completion: @escaping LocalAuthenticatorCompletion) {
        if isBiometricsAvailable() {
            return completion(false, .biometricsNotAvailable)
        }
        
        var localAuthenticatorError: NSError?
        if self.authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &localAuthenticatorError),
            localAuthenticatorError == nil {
            self.evaluateAuthenticationPolicy(completion: completion)
        } else if let error = localAuthenticatorError {
            completion(false, .forwarded(error))
        } else {
            completion(false, .unknown)
        }
    }
    
    private func evaluateAuthenticationPolicy(completion: @escaping LocalAuthenticatorCompletion) {
        self.authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.biometricDescription) { (isSuccess, error) in
            if isSuccess {
                completion(true, nil)
            } else if let error = error {
                completion(false, .forwarded(error))
            } else {
                completion(false, .unknown)
            }
        }
    }
}

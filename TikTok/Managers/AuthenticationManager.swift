//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import Foundation
import FirebaseAuth

final class AuthManager{
    public static let shared = AuthManager()
    

    private init(){
    }
    enum SignInMethod{
        case email
        case facebook
        case google
    }
    //Public
    public func signIn(with method:SignInMethod){}
    
    public func signOut(){}
    
}


//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init(){
    }
    
    //Public
    public func getAllUsers(completion:([String]) -> Void){
        
    }
}

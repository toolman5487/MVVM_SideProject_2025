//
//  UserModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/12.
//

import Foundation
import FirebaseAuth

struct UserModel{
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    init(from firebaseUser: User) {
           self.uid = firebaseUser.uid
           self.email = firebaseUser.email
           self.displayName = firebaseUser.displayName
           self.photoURL = firebaseUser.photoURL
       }
}

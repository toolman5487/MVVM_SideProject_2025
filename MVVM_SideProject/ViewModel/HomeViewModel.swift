//
//  HomeViewModel.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/15.
//

import Foundation
import FirebaseAuth
import Combine

class HomeViewModel:ObservableObject{
    @Published var homeModel:HomeModel?
    private var cancellbles = Set<AnyCancellable>()
    
    init (){
        loadHomeData()
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.loadHomeData()
        }
    }
    
    func loadHomeData(){
        if let firebaseUser = Auth.auth().currentUser{
            let userModel = UserModel(from: firebaseUser)
            let homeData = HomeModel(user: userModel)
            DispatchQueue.main.async { [weak self] in
                self?.homeModel = homeData
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.homeModel = nil
            }
        }
    }
    
    func refreshData(){
        loadHomeData()
    }
}

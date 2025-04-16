//
//  MainTabBarController.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/16.
//

import Foundation
import UIKit

class MainTabBarController:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeView()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "首頁",
                                          image: UIImage(systemName: "house.fill"),
                                          tag: 0)
        let tipCalculator = TipCalculatorView()
        let tipCalculatorNav = UINavigationController(rootViewController: tipCalculator)
        tipCalculatorNav.tabBarItem = UITabBarItem(title: "服務費計算器",
                                                   image: UIImage(systemName: "dollarsign.circle.fill"),
                                                   tag: 1)
        
        let movieVC = MovieView(movieListViewModel: MovieListViewModel(httpClient: MovieHTTPClient()))
        let movieNav = UINavigationController(rootViewController: movieVC)
        movieNav.tabBarItem = UITabBarItem(title: "電影",
                                                   image: UIImage(systemName: "film.circle.fill"),
                                                   tag: 2)

    
        viewControllers = [homeNav, tipCalculatorNav, movieNav]
    }
    
}

//
//  UIViewController+Extension.swift
//

import UIKit

//MARK: - UIViewController Extension
extension UIViewController {

    //MARK: - Show & Hide Navigation Bar Methods
    func showNavigationBar(isTabbar : Bool = true) {
        if isTabbar {
            self.tabBarController?.navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    func hideNavigationBar(isTabbar : Bool = true) {
        if isTabbar {
            self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    //MARK: - Set Navigation Header Method
    func setNavigationHeader(strTitleName : String, isTabbar : Bool = true) {

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()

            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font : Fonts.InterBold16]

            navBarAppearance.backgroundColor = .white
            navBarAppearance.shadowColor = .clear

            if isTabbar {
                self.tabBarController?.navigationController?.navigationBar.standardAppearance = navBarAppearance
                self.tabBarController?.navigationController?.navigationBar.compactAppearance = navBarAppearance
                self.tabBarController?.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            } else {
                self.navigationController?.navigationBar.standardAppearance = navBarAppearance
                self.navigationController?.navigationBar.compactAppearance = navBarAppearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            }
        }

        UINavigationBar.appearance().tintColor = .black

        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = Fonts.InterBold16
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.text = strTitleName

        if isTabbar {
            self.tabBarController?.navigationItem.titleView = label

            self.tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()

            self.tabBarController?.navigationController?.navigationBar.barTintColor = .white
            self.tabBarController?.navigationController?.navigationBar.tintColor = .black
            self.tabBarController?.navigationController?.navigationBar.isTranslucent = false
        } else {
            self.navigationItem.titleView = label

            self.navigationController?.navigationBar.shadowImage = UIImage()

            self.navigationController?.navigationBar.barTintColor = .white
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
}

//
//  JokesVC.swift
//  Practical_Unlimit
//

import UIKit

class JokesVC: UIViewController {

    //MARK: - UITableView Outlet
    @IBOutlet weak var tblJokesList: UITableView!

    //MARK: - UILabel Outlet
    @IBOutlet weak var lblNoData: UILabel!

    //MARK: - Variable Declaration
    var arrJokesList = [JokesList]()
    lazy var objJokesPresenters = JokesPresenters(view : self)

    //MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()

        objJokesPresenters.fetchJokesFromDatabase()

        objJokesPresenters.callJokeAPI()
    }

    //MARK: - Initialization Method
    private func initialization() {

        hideNavigationBar(isTabbar: false)

        if #available(iOS 15.0, *) {
            tblJokesList.sectionHeaderTopPadding = 0.0
            tblJokesList.tableHeaderView = UIView()
        }

        tblJokesList.rowHeight = UITableView.automaticDimension
        tblJokesList.estimatedRowHeight = UITableView.automaticDimension
        tblJokesList.tableFooterView = UIView()
    }
}

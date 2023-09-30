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
    weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()

        callJokeAPI()
    }

    //MARK: - initialization Method
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

    //MARK: - Call Joke API Method
    private func callJokeAPI() {

        guard case ConnectionCheck.isConnectedToNetwork() = true else {
            Utility().dynamicToastMessage(strMessage: AlertMessage.msgNetworkConnection)
            return
        }

        ServiceRequest().wsGetJokes() { [weak self] (success, responseData) in

            guard let self else { return }

            if success, let responseData = responseData as? JokesList {
                setData(dictResponseData: responseData)

                startTimer()
            } else {
                mainThread {
                    Utility().dynamicToastMessage(strMessage: responseData != nil ? Utility().wsFailResponseMessage(responseData: responseData!) : AlertMessage.msgError)

                    if self.arrJokesList.count > 0 {
                        self.startTimer()
                    } else {
                        self.arrJokesList = [JokesList]()
                    }

                    self.setupUI()
                }
            }
        }
    }

    //MARK: - Set Jokes Data Method
    private func setData(dictResponseData : JokesList) {

        let dictJokes = JokesList(joke: dictResponseData.joke ?? "", date: Date())

        if arrJokesList.count == 10 {
            arrJokesList.removeLast()
        }

        arrJokesList.append(dictJokes)
        arrJokesList = arrJokesList.sorted(by: {$0.date ?? Date() > $1.date ?? Date()})

        setupUI()
    }

    //MARK: - Setup UI Method
    private func setupUI() {

        if arrJokesList.count > 0 {
            tblJokesList.reloadData()

            tblJokesList.isHidden = false
            lblNoData.isHidden = true
        } else {
            lblNoData.isHidden = false
            tblJokesList.isHidden = true
        }
    }

    //MARK: - Start & End Timer Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(callAPI), userInfo: nil, repeats: false)
    }

    private func endTimer() {

        if let timer = timer {
            timer.invalidate()
        }
    }

    //MARK: - Call API Method
    @objc private func callAPI() {

        DispatchQueue.global(qos: .background).async { [weak self] in

            guard let self else { return }

            endTimer()

            callJokeAPI()
        }
    }
}

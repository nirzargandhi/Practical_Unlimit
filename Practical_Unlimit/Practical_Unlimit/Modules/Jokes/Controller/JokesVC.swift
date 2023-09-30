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

    //MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()

        fetchJokesFromDatabase()

        callJokeAPI()
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

    //MARK: - Fetch Jokes From Database Method
    private func fetchJokesFromDatabase() {

        arrJokesList = JokesDBManager.getInstance().getAllJokesData()

        arrJokesList = arrJokesList.sorted(by: {$0.date ?? "" > $1.date ?? ""})

        setupUI()
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

        let strDate = Utility().datetimeFormatter(strFormat: DateAndTimeFormatString.strDateFormat_MMMddYYYYhhmmssa, isTimeZoneUTC: false).string(from: Date())
        let dictJoke = JokesList(joke: dictResponseData.joke ?? "", date: strDate)

        if arrJokesList.count == 10 {

            deleteJokeFromDatabase(joke: JokesList(joke: arrJokesList.last?.joke ?? "", date: arrJokesList.last?.date ?? ""))

            arrJokesList.removeLast()
        }

        arrJokesList.append(dictJoke)
        arrJokesList = arrJokesList.sorted(by: {$0.date ?? "" > $1.date ?? ""})

        insertJokeToDatabase(joke: dictJoke)

        setupUI()
    }

    //MARK: - Insert Joke To Database Method
    private func insertJokeToDatabase(joke : JokesList) {

        let isDataInserted = JokesDBManager.getInstance().addJokesData(objJokesList: joke)

        if isDataInserted {
            print("Data insert successfully")
        } else {
            print("Data insert unsuccessfully")
        }
    }

    //MARK: - Delete Joke From Database Method
    private func deleteJokeFromDatabase(joke : JokesList) {

        let isDataInserted = JokesDBManager.getInstance().deleteJokesData(objJokesList: joke)

        if isDataInserted {
            print("Data delete successfully")
        } else {
            print("Data delete unsuccessfully")
        }
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
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(callAPI), userInfo: nil, repeats: false)
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

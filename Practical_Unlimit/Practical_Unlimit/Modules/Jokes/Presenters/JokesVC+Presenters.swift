//
//  JokesVC+Presenters.swift
//  Practical_Unlimit
//

import Foundation

//MARK: - JokesPresenters Delegate
protocol JokesPresentersDelegate : AnyObject {
    func setupUI(jokesList : [JokesList])
}

//MARK: - JokesPresenters
class JokesPresenters {

    //MARK: - Variable Declaration
    weak var objJokesPresentersDelegate : JokesPresentersDelegate?
    var arrPresenterJokesList = [JokesList]()
    weak var timer: Timer?

    //MARK: - Init Method
    init(view : JokesPresentersDelegate) {
        self.objJokesPresentersDelegate = view
    }

    //MARK: - Fetch Jokes From Database Method
    internal func fetchJokesFromDatabase() {

        arrPresenterJokesList = JokesDBManager.getInstance().getAllJokesData()

        arrPresenterJokesList = arrPresenterJokesList.sorted(by: {$0.date ?? "" > $1.date ?? ""})

        objJokesPresentersDelegate?.setupUI(jokesList: arrPresenterJokesList)
    }

    //MARK: - Call Joke API Method
    internal func callJokeAPI() {

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

                    if self.arrPresenterJokesList.count > 0 {
                        self.startTimer()
                    } else {
                        self.arrPresenterJokesList = [JokesList]()
                    }

                    self.objJokesPresentersDelegate?.setupUI(jokesList: self.arrPresenterJokesList)
                }
            }
        }
    }

    //MARK: - Set Jokes Data Method
    private func setData(dictResponseData : JokesList) {

        let strDate = Utility().datetimeFormatter(strFormat: DateAndTimeFormatString.strDateFormat_MMMddYYYYhhmmssa, isTimeZoneUTC: false).string(from: Date())
        let dictJoke = JokesList(joke: dictResponseData.joke ?? "", date: strDate)

        if arrPresenterJokesList.count == 10 {

            deleteJokeFromDatabase(joke: JokesList(joke: arrPresenterJokesList.last?.joke ?? "", date: arrPresenterJokesList.last?.date ?? ""))

            arrPresenterJokesList.removeLast()
        }

        arrPresenterJokesList.append(dictJoke)
        arrPresenterJokesList = arrPresenterJokesList.sorted(by: {$0.date ?? "" > $1.date ?? ""})

        insertJokeToDatabase(joke: dictJoke)

        objJokesPresentersDelegate?.setupUI(jokesList: arrPresenterJokesList)
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

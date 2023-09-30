//
//  Constants.swift
//

import UIKit

//MARK: - StoryBoard Identifier's
enum AllStoryBoard {

    static let Main = UIStoryboard(name: "Main", bundle: nil)
}

//MARK: - ViewController Names
enum ViewControllerName {

    static let kJokesVC = "JokesVC"
}

//MARK: - Cell Identifiers
enum CellIdentifiers {

    static let kCellJokes = "CellJokes"
}

//MARK: - Message's
enum AlertMessage {

    //Internet Connection Message
    static let msgNetworkConnection = "You are not connected to internet. Please connect and try again"

    //Unauthorized Message
    static let msgUnauthorized = "You are unauthorized. Please login again"

    //General API Error Messages
    static let msgError = "Oops! That didn't work. Please try later :("
    static let msgError500 = "Error code 500 or more"
    static let msgError402 = "Payment required, go to coins packages"
    static let msgError403 = "User forbidden"
}

//MARK: - Web Service URLs
enum WebServiceURL {

    //Main URL
    static let mainURL = "https://geek-jokes.sameerkumar.website/api?"

    static let jokeURL = mainURL + "format=json"
}

//MARK: - Web Service Parameters
enum WebServiceParameter {

}

//MARK: - User Default
enum UserDefaultsKey {

}

//MARK: - DateTime Format
enum DateAndTimeFormatString {

    static let strDateFormat_MMMddYYYYhhmmssa = "MMM dd YYYY hh:mm:ss a"
}

//MARK: - Fonts
enum Fonts {

    static let InterBold16 = UIFont(name: "Inter-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    static let InterRegular16 = UIFont(name: "Inter-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    static let InterRegular14 = UIFont(name: "Inter-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
}

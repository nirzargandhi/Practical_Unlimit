//
//  AppDelegate+Configuration.swift
//

//MARK: - AppDelegate Extension
extension AppDelegate {

    //MARK: - Config App Method
    func configApp() {

        Utility().copyFile(fileName: "JokesDB.sqlite")

        setRootController()
    }

    //MARK: - Set Root Controller Method
    func setRootController() {
        Utility().setRootJokesVC()
    }
}

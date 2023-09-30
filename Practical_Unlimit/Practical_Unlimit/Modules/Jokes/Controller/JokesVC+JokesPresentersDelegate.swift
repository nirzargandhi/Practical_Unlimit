//
//  JokesVC+JokesPresentersDelegate.swift
//  Practical_Unlimit
//

//MARK: - JokesPresentersDelegate Extension
extension JokesVC : JokesPresentersDelegate {

    func setupUI(jokesList: [JokesList]) {

        arrJokesList = jokesList

        if arrJokesList.count > 0 {
            tblJokesList.reloadData()

            tblJokesList.isHidden = false
            lblNoData.isHidden = true
        } else {
            lblNoData.isHidden = false
            tblJokesList.isHidden = true
        }
    }
}

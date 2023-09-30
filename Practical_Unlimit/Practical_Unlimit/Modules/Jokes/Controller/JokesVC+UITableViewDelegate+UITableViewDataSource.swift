//
//  JokesVC+UITableViewDelegate+UITableViewDataSource.swift
//

import UIKit

//MARK: - UITableViewDelegate & UITableViewDataSource Extension
extension JokesVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJokesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.kCellJokes, for: indexPath) as! JokesTVC

        cell.lblJoke.text = arrJokesList[indexPath.row].joke ?? ""

        cell.lblDate.text = arrJokesList[indexPath.row].date ?? ""

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

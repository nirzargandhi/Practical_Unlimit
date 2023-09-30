//
//  JokesTVC.swift
//

import UIKit

class JokesTVC: UITableViewCell {

    //MARK: - UILabel Outlets
    @IBOutlet weak var lblJoke: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    //MARK: - Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

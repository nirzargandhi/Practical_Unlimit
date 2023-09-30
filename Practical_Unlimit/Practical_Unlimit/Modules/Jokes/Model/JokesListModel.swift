//
//  JokesListModel.swift
//  Practical_Unlimit
//

struct JokesList : Codable {

    var joke : String?
    var date : String?

    enum CodingKeys: String, CodingKey {

        case joke = "joke"
        case date = "date"
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(joke, forKey: .joke)
        try container.encode(date, forKey: .date)
    }

    init(joke : String, date : String) {

        self.joke = joke
        self.date = date
    }
}

//
//  GeneralResponseModel.swift
//

struct GeneralResponseModel : Codable {

    let cod : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case cod = "cod"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

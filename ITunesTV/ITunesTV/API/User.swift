/*STRUCT CON LA INFORMACIÓN DEL USUARIO*/

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    var username: String
    var profileImageURL: String
    var searchCountry: String
    var explicitContent: Bool
}


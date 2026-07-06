/*STRUCT DEL RESULTADO DE LA API Y LA ESTRUCTURA DE UN ÍTEM (canción o vídeo)*/

import Foundation

struct ItemResults: Decodable {
    let resultCount: Double
    let results: [Item]
}

struct Item: Identifiable, Decodable, Equatable, Encodable{
    let kind: String
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let trackPrice: Double?
    let releaseDate: String?
    let primaryGenreName: String
    let trackTimeMillis: Int?
    let artworkUrl100: String
    let country: String
    let currency: String
    let previewUrl: String?
    let trackExplicitness: String?
    let collectionExplicitness: String?
    
    var id: Int{trackId}
    
}

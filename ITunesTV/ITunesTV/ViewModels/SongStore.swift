import Foundation
import Observation

/* VM encargar de manejar las canciones recibidas de la API y pasarlas a la View correspondiente*/

@Observable
class SongStore{
    private(set) var state = APIState.idle
    
    //Variables de paginación
    private var allResults: [Item] = []
    private let pageSize = 20
    private var currentPage = 0
    
    //Fetch básico a la API
    func fetchSongs(query: String) {
        guard self.state != .loading else { return }
        self.state = APIState.loading
        
        Task {
            do{
                let trimmedQuery = query
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: " ", with: "+")
                
                let urlString = "https://itunes.apple.com/search?term=\(trimmedQuery)&entity=song"
                
                let results = try await APIService.fetchData(stringURL: urlString)
                self.state = .loaded(results)
            } catch{
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    //Fetch con los filtros de las preferencias del usuario
    func fetchSongsWithPreferences(query: String, country: String, explicit: Bool) {
        guard self.state != .loading else { return }
        self.state = APIState.loading
                
        Task {
            do{
                let trimmedQuery = query
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: " ", with: "+")
                
                var urlString = "https://itunes.apple.com/search?term=\(trimmedQuery)&entity=song"
                
                if country != "Default" {
                    urlString.append("&country=\(countryToISO(country: country))")
                }
                
                if explicit == false {
                    urlString.append("&explicit=No")
                }
                
                print(urlString)
                
                let results = try await APIService.fetchData(stringURL: urlString)
                
                self.handleNewResults(results)
            } catch{
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    //Funciones para la paginación
    private func handleNewResults(_ results: [Item]) {
        allResults = results
        currentPage = 0
        loadNextPage()
    }
    
    
    func loadNextPage() {
        let start = currentPage * pageSize
        let end = min(start + pageSize, allResults.count)

        guard start < end else {
            return
        }

        let nextPage = Array(allResults[start..<end])

        if case .loaded(let current) = state {
            state = .loaded(current + nextPage)
        } else {
            state = .loaded(nextPage)
        }

        currentPage += 1
    }

    //Función para convertir de string de país a código ISO
    func countryToISO(country: String) -> String {
        switch country {
            case "United States":
                return "us"
            case "Spain":
                return "es"
            case "United Kingdom":
                return "gb"
            case "France":
                return "fr"
            case "Germany":
                return "de"
            case "Italy":
                return "it"
            case "Canada":
                return "ca"
            case "Mexico":
                return "mx"
            case "Brazil":
                return "br"
            case "Argentina":
                return "ar"
            case "Japan":
                return "jp"
            case "South Korea":
                return "kr"
            case "Australia":
                return "au"
            case "Netherlands":
                return "nl"
            case "Sweden":
                return "se"
            case "Norway":
                return "no"
            case "Denmark":
                return "dk"
            case "Finland":
                return "fi"
            case "Portugal":
                return "pt"
            case "Ireland":
                return "ie"
            default:
                return ""
            }
    }
    
    //Elemento de muestra para las views
    static var dummyItem: Item {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return Item(
            kind: "song",
            trackId: 1846589813,
            trackName: "Crumbling Empire",
            artistName: "Sam Fender",
            collectionName: "People Watching",
            trackPrice: 3.99,
            releaseDate: "2010-11-02T07:00:00Z",
            primaryGenreName: "Pop-Rock",
            trackTimeMillis: 307640,
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/3c/ac/aa/3cacaa12-a598-83d6-ce13-8d6fc07085fc/25UM1IM60982.rgb.jpg/100x100bb.jpg",
            country: "USA",
            currency: "USD",
            previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview221/v4/9b/61/43/9b614376-b0fe-2ae3-1df6-9feb5d521c7d/mzaf_2906175251422113207.plus.aac.p.m4a",
            trackExplicitness: "explicit",
            collectionExplicitness: "explicit"
        )
    }
}

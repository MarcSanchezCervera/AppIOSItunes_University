import Foundation
import Observation

/* ENCARGADO DE PERSISTIR Y OBTENER LOS ÍTEMS FAVORITOS */

@Observable
class FavouritesStore{
    public var favorites: [Item] = []
    private let key = "songs_favorites" // Clave para guardar datos en la base de datos UserDefaults
    
    //Leemos y cargamos todas las canciones favoritas guardadas, de esta forma no se pierde la info
    init() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        
        do {
            favorites = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    //Decidimos si mostrar que está en favoritos o no, el ícono
    func isFavorite(item: Item) -> Bool {
        favorites.contains(item)
    }
    
    //Para el estado de la canción, si está en favoritos y le damos lo quita, y sino está lo añade. Para luego guardarlo en la base de datos
    func toggleFavorite(item: Item){
        if let index = favorites.firstIndex(where: { $0.trackId == item.trackId }) {
            favorites.remove(at: index)
        } else {
            favorites.append(item)
        }
        saveItem()
    }
    
    private func saveItem() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving favorites: \(error)")
        }
    }
}

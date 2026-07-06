import Foundation
import Observation

/* ENCARGADO DE PERSISTIR Y OBTENER LA INFORMACIÓN DE LA CUENTA DEL USUARIO*/

@Observable
class UserPresetsStore{
    public var user: User
    private let key = "users" // Clave para guardar datos en la base de datos UserDefaults
    
    //Inicialización
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decodedUser = try JSONDecoder().decode(User.self, from: data)
                user = decodedUser
            } catch {
                print("Error loading user information: \(error)")
                user = Self.dummyUser
            }
        } else {
            user = Self.dummyUser
            updateUser()
        }
    }
    
    //Actualizar selección de país
    func changeCountrySetting(newCountry: String) {
        user.searchCountry = newCountry
        updateUser()
    }
    
    //Actualizar selección de contenido explícito
    func changeExplicitContentSetting(explicit: String) {
        let explicitState: Bool

        if explicit == "No" {
            explicitState = false
        } else if explicit == "Yes" {
            explicitState = true
        } else {
            return
        }

        user.explicitContent = explicitState
        updateUser()
    }
    
    //Actualizar información del usuario de la persistencia
    private func updateUser() {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    //Creación de usuario por default
    static var dummyUser: User {
        return User(
            id: 1,
            username: "User",
            profileImageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/ITunes_logo.svg/1019px-ITunes_logo.svg.png",
            searchCountry: "Spain",
            explicitContent: true
        )
    }
}

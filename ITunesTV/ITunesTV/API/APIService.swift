import Foundation

struct APIService{

    //Hacer petición a la API
    static func fetchData(stringURL:String) async throws ->[Item]{
        guard let url = URL(string: stringURL) else{
            throw APIError.invalidURL
        }
        
        do{
            //Iniciar URLSession
            let (data, response) =  try await URLSession.shared.data(from: url)
                      
            //Obtener respuesta y verificar si es SUCCESS
            guard let responseHttp = response as? HTTPURLResponse, (200...299).contains(responseHttp.statusCode) else{
                throw APIError.invalidResponse
            }
                        
            //Decodificar la respuesta en JSON
            let decoder = JSONDecoder()
            let itemResults = try decoder.decode(ItemResults.self, from: data)
                    
            //Devolver el array de ítems con los resultados
            return itemResults.results
            
        }catch let error as DecodingError{
            throw APIError.decoding(error)
        }catch{
            throw APIError.networkError(error)
        }
    }
}

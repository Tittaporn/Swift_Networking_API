import UIKit

struct Drinks: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let name: String
    let category: String
    let instruction: String
    let image: URL
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case category = "strCategory"
        case instruction = "strInstructions"
        case image = "strImageSource"
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The server failed to reach the necessary URL."
        case .thrownError(let error):
            return "Opps, there was an error: \(error.localizedDescription)"
        case .noData:
            return "The server failed to load any data."
        case .unableToDecode:
            return "There was an error when trying to load the data."
        }
    }
}

class DrinkController {
    static let baseURL = URL(string: "www.thecocktaildb.com/api/json/v1/1")
    static let searchComponent = "search"
    static let phpComponent = "php"
    static let searchByNameQuery = "s"
    
    static func fetchDrinks(searchTerm: String, completion: @escaping (Result<[Drink],NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(searchComponent)
        let phpURL = searchURL.appendingPathExtension(phpComponent)
        var components = URLComponents(url: phpURL, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: searchByNameQuery, value: searchTerm)
        components?.queryItems = [searchQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("\n===================FinalURL! \(finalURL) IN \(#function) ======================\n")
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("\n===================ERROR! ERROR ERROR IF EROR IN\(#function) ======================\n")
                completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                print("FETCH DRINK STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                let fetchDrinks = drinks.drinks
                print("=================== \(fetchDrinks[0].name)======================")
                completion(.success(fetchDrinks))
            
            } catch {
                completion(.failure(.thrownError(error)))
                print("\n===================ERROR! ERROR ERROR CATCH ERROR IN\(#function) ======================\n")
            }
        }.resume()
    }
}


DrinkController.fetchDrinks(searchTerm: "margarita") { (results) in
    switch results {
    case .success(let drinks):
        for drink in drinks {
            print("=========================================")
            print("=================== \(drink.name)======================")
            print("=================== \(drink.category)======================")
            print("=================== \(drink.instruction)======================")
            print("=========================================")
        }
    case .failure(let error):
        print("\n===================ERROR! \(error.localizedDescription) IN \(#function) ======================\n")
    }
}


/*
 https://www.thecocktaildb.com/api.php?ref=apilist.fun
 
 Search cocktail by name
 www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita
 
 List all cocktails by first letter
 www.thecocktaildb.com/api/json/v1/1/search.php?f=a
 
 Search ingredient by name
 www.thecocktaildb.com/api/json/v1/1/search.php?i=vodka
 */

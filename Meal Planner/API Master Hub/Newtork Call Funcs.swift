//
//  Newtork Call Funcs.swift
//  Meal Planner
//
//  Created by Sterling Jenkins on 4/20/23.
//

import Foundation
import UIKit

enum APIErrors: Error {
    case fetchRecipesByNameFailed
    case fetchRecipesByIngredientsFailed
    case imageNotFound
    case fetchRecipeDetailsFailed
}


func recipieSearchByName(using text: String) async throws -> Results {

    var urlComponents = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch")
    
    let queryItems = [URLQueryItem(name: "query", value: "\(text)"), URLQueryItem(name: "number", value: "100")]
    
    urlComponents?.queryItems = queryItems
    
    let headers = [
        "X-RapidAPI-Key": "b318be8b14msh37ff82490483e11p168179jsn43a8428e48e3",
        "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: urlComponents!.url!,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIErrors.fetchRecipesByNameFailed
    }
    
    let decoder = JSONDecoder()
    let decodedRecipes = try decoder.decode(Results.self, from: data)
    
    return decodedRecipes
}

func recipieSearchByIngredientsList(using ingredients: [Ingredient]) async throws -> Results {

    var urlComponents = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch")
    
    var ingredientsString = ingredients.reduce("", { (runningString: String, ingredient: Ingredient) in
        runningString + "\(ingredient.name!.lowercased()),"
    })
    ingredientsString.removeLast()
    
    print(ingredientsString)
    
    let queryItems = [URLQueryItem(name: "query", value: ingredientsString), URLQueryItem(name: "number", value: "100")]
    
    urlComponents?.queryItems = queryItems
    
    let headers = [
        "content-type": "application/octet-stream",
        "X-RapidAPI-Key": "b318be8b14msh37ff82490483e11p168179jsn43a8428e48e3",
        "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: urlComponents!.url!,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIErrors.fetchRecipesByIngredientsFailed
    }
    
    let decoder = JSONDecoder()
    let decodedRecipes = try decoder.decode(Results.self, from: data)
    
    return decodedRecipes
}


func retrieveRecipeImage(using url: URL) async throws ->  UIImage {
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIErrors.imageNotFound
    }
    
    guard let image = UIImage(data: data) else {
        throw APIErrors.imageNotFound
    }
    
    return image
}

func retrieveRecipieInfo(usingRecipieID id: Int) async throws -> ViewedRecipe {
    
    let headers = [
        "content-type": "application/octet-stream",
        "X-RapidAPI-Key": "b318be8b14msh37ff82490483e11p168179jsn43a8428e48e3",
        "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(id)/information")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIErrors.fetchRecipeDetailsFailed
    }
    
    let decoder = JSONDecoder()
    let decodedRecipeDetails = try decoder.decode(ViewedRecipe.self, from: data)
    
    return decodedRecipeDetails
}

// MARK: - Structs for decoding information

struct Results: Codable {
    var recipes: [RecipieResult]?
    
    enum CodingKeys: String, CodingKey {
        case recipes = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipes = try container.decodeIfPresent([RecipieResult].self, forKey: .recipes)
    }
}

struct RecipieResult: CustomStringConvertible, Codable {
    var description: String {
        return "Title: \(title ?? "Unavailable"), \n Image URL: \(image ?? "Unavailable"), \n Image Type: \(imageType ?? "Unavailable"), \n ID: \(id ?? 0) "
    }
    
    var id: Int?
    var title: String?
    var image: String?
    var imageType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case imageType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.imageType = try container.decodeIfPresent(String.self, forKey: .imageType)
    }
}

struct ViewedRecipe: Codable {
    var name: String
    var ingredients: [ViewedIngredient]
    var instructions: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case ingredients = "extendedIngredients"
        case instructions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.ingredients = try container.decode([ViewedIngredient].self, forKey: .ingredients)
        self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
    }
}

struct ViewedIngredient: Codable {
    var name: String
    var quantity: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case unit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let amount = try container.decode(Double.self, forKey: .amount)
        let unit = try container.decode(String.self, forKey: .unit)
        self.quantity = "\(amount) \(unit)"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        let strings = quantity.components(separatedBy: " ")
        
        try container.encode(Double(strings.first ?? "0"), forKey: .amount)
        try container.encode(strings.last ?? "", forKey: .unit)
    }
}


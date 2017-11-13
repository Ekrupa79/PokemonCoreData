//
//  Networking.swift
//  Pokedex
//
//  Created by Mac on 11/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class JSONCalls{
    enum NetworkError:Error{
        case BadURL
        case NoDataOnServer
        case DataContainedNoImage
    }
    class func getAllPokemon(url:URL, completion: @escaping ([AllPokemon]?)->()){
        //let session = URLSession(configuration: .default)
        var returnPokemon = [AllPokemon]()
        print("made it here")
        //guard let url = URL(string: url) else {return []}
        URLSession.shared.dataTask(with: url){
            (data,response,error) in
            guard let data = data, error == nil else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data)
                guard let dict = json as? [String:Any] else {return}
                guard let pokemonDict = dict["results"] as? [[String:Any]] else {return}
                
                returnPokemon = pokemonDict.flatMap{
                    guard let url = $0["url"] as? String else {return nil}
                    guard let name = $0["name"] as? String else {return nil}
                    return AllPokemon(url: url, name: name)
                }
                print(returnPokemon.count)
                completion(returnPokemon)
            }catch let error{
                print("Bad: \(error.localizedDescription)")
            }
            }.resume()
    }
    
    class func getPokemon(from url:String, completionHandler:@escaping(Pokemon?, Error?) -> ()){
        guard let url = URL(string:url) else {
            //Check for valid url
            completionHandler(nil, NetworkError.BadURL)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                //Checks for no errors
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                //Checks for data on server
                completionHandler(nil, NetworkError.NoDataOnServer)
                return
            }
            guard let pokemon = Pokemon(data: data) else {
                //Checks for an image
                completionHandler(nil, NetworkError.DataContainedNoImage)
                return
            }
            completionHandler(pokemon, nil)
        }
        task.resume()
    }
    
    
    class func getImage(from url:String, completionHandler:@escaping(UIImage?, Error?) -> ()){
        guard let url = URL(string:url) else {
            //Check for valid url
            completionHandler(nil, NetworkError.BadURL)
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                //Checks for no errors
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                //Checks for data on server
                completionHandler(nil, NetworkError.NoDataOnServer)
                return
            }
            guard let image = UIImage(data: data) else {
                //Checks for an image
                completionHandler(nil, NetworkError.DataContainedNoImage)
                return
            }
            completionHandler(image, nil)
        }
        task.resume()
    }
}


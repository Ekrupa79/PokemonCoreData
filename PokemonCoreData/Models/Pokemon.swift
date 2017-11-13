//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mac on 11/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

struct AllPokemon{
    var url:String?
    var name:String?
    init?(url:String?, name:String?){
        self.url = url
        self.name = name
    }
}

struct Pokemon{
    var id:Int?
    var name:String?
    var base_experience:Int?
    var height:Int?
    var is_default:Bool?
    var order:Int?
    var weight:Int?
    var abilities:[PokemonAbility]?
    var forms:[NamedAPIResource]?
    var game_indices:[VersionGameIndex]?
    var held_items:[PokemonHeldItem]?
    var location_area_encounters:String?
    var moves:[PokemonMove]?
    var sprites:PokemonSprites?
    var species:NamedAPIResource?
    var stats:[PokemonStat]?
    var types:[PokemonType]?
    
    init?(data: Data){
        do{
            let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]
            guard
                let id = json?["id"] as? Int,
                let name = json?["name"] as? String,
                let base_experience = json?["base_experience"] as? Int,
                let height = json?["height"] as? Int,
                let is_default = json?["is_default"] as? Bool,
                let order = json?["order"] as? Int,
                let weight = json?["weight"] as? Int,
                let abilities = json?["abilities"] as? [[String:Any]],
                let forms = json?["forms"] as? [[String:Any]],
                let game_indices = json?["game_indices"] as? [[String:Any]],
                let held_items = json?["held_items"] as? [[String:Any]],
                let location_area_encounters = json?["location_area_encounters"] as? String,
                //Look at location_area_enounters
                let moves = json?["moves"] as? [[String:Any]],
                //Sprites and Species comes back with No Data
                let sprites = json?["sprites"] as? [String:Any],
                let species = json?["species"] as? [String:Any],
                let stats = json?["stats"] as? [[String:Any]],
                let types = json?["types"] as? [[String:Any]]
                else {return nil}
            
            //Custom types without NamedAPIResource need a struct
            self.id = id
            self.name = name
            self.base_experience = base_experience
            self.height = height
            self.is_default = is_default
            self.order = order
            self.weight = weight
            self.abilities = abilities.flatMap{PokemonAbility(dict: $0)}
            self.forms = forms.flatMap{NamedAPIResource(dict: $0)}
            self.game_indices = game_indices.flatMap{VersionGameIndex(dict: $0)}
            self.held_items = held_items.flatMap{PokemonHeldItem(dict: $0)}
            self.location_area_encounters = location_area_encounters
            self.moves = moves.flatMap{PokemonMove(dict: $0)}
            self.sprites = PokemonSprites(arr: sprites)
            self.species = NamedAPIResource(dict: species)
            self.stats = stats.flatMap{PokemonStat(dict: $0)}
            self.types = types.flatMap{PokemonType(dict: $0)}
        }catch{
            print("Bad stuff happened in the initializer")
        }
        
    }
}
struct NamedAPIResource{
    var name:String?
    var url:String?
    
    init?(dict: [String:Any]){
        guard
            let name = dict["name"] as? String,
            let url = dict["url"] as? String
            else {return nil}
        
        self.name = name;
        self.url = url
    }
}
struct PokemonAbility{
    var is_hidden:Bool?
    var slot:Int?
    var ability:NamedAPIResource?
    
    init?(dict: [String:Any]){
        guard
            let is_hidden = dict["is_hidden"] as? Bool,
            let slot = dict["slot"] as? Int,
            let ability = dict["ability"] as? NamedAPIResource
            else {return nil}
        
        self.is_hidden = is_hidden
        self.slot = slot
        self.ability = ability
    }
}
struct VersionGameIndex{
    var game_index:Int?
    var version:NamedAPIResource?
    
    init?(dict: [String:Any]){
        guard
            let game_index = dict["game_index"] as? Int,
            let version = dict["version"] as? NamedAPIResource
            else {return nil}
        
        self.game_index = game_index
        self.version = version
    }
}
struct PokemonHeldItem{
    var item:NamedAPIResource?
    var version_details:[PokemonHeldItemVersion]?
    
    init?(dict: [String:Any]){
        guard
            let item = dict["item"] as? NamedAPIResource,
            let version_details = dict["version_details"] as? [[String:Any]]
            else {return nil}
        
        //Check later
        self.item = item
        self.version_details = version_details.flatMap{PokemonHeldItemVersion(dict: $0)}
    }
}
struct PokemonHeldItemVersion{
    var version:NamedAPIResource?
    var rarity:Int?
    
    init?(dict: [String:Any]){
        guard
            let version = dict["version"] as? NamedAPIResource,
            let rarity = dict["rarity"] as? Int
            else {return nil}
        
        self.version = version
        self.rarity = rarity
    }
}
struct PokemonMove{
    var move:NamedAPIResource?
    var version_group_details:[PokemonMoveVersion]?
    
    init?(dict: [String:Any]){
        guard
            let move = dict["move"] as? NamedAPIResource,
            let version_group_details = dict["version_group_details"] as? [[String:Any]]
            else {return nil}
        
        self.move = move
        self.version_group_details = version_group_details.flatMap{PokemonMoveVersion(dict: $0)}
    }
}
struct PokemonMoveVersion{
    var move_learn_method:NamedAPIResource?
    var version_group:NamedAPIResource?
    var level_learned_at:Int?
    
    init?(dict: [String:Any]){
        guard
            let move_learn_method = dict["move_learn_method"] as? NamedAPIResource,
            let version_group = dict["version_group"] as? NamedAPIResource,
            let level_learned_at = dict["level_learned_at"] as? Int
            else {return nil}
        
        self.move_learn_method = move_learn_method
        self.version_group = version_group
        self.level_learned_at = level_learned_at
    }
}
struct PokemonSprites{
    var front_default:String?
    var front_shiny:String?
    var front_female:String?
    var front_shiny_female:String?
    var back_default:String?
    var back_shiny:String?
    var back_female:String?
    var back_shiny_female:String?
    
    //init?(front_default:String?, front_shiny:String?, front_female:String?, front_shiny_female:String?, back_default:String?, back_shiny:String?, back_female:String?, back_shiny_female:String?){
    init?(arr: [String:Any]){
        if let front_default = arr["front_default"] as? String{
            self.front_default = front_default
        }
        if let front_shiny = arr["front_shiny"] as? String{
            self.front_shiny = front_shiny
        }
        if let front_female = arr["front_female"] as? String{
            self.front_female = front_female
        }
        if let front_shiny_female = arr["front_shiny_female"] as? String{
            self.front_shiny_female = front_shiny_female
        }
        if let back_default = arr["back_default"] as? String{
            self.back_default = back_default
        }
        if let back_shiny = arr["back_shiny"] as? String{
            self.back_shiny = back_shiny
        }
        if let back_female = arr["back_female"] as? String{
            self.back_female = back_female
        }
        if let back_shiny_female = arr["back_shiny_female"] as? String{
            self.back_shiny_female = back_shiny_female
        }
    }
}
struct PokemonStat{
    var stat:NamedAPIResource?
    var effort:Int?
    var base_stat:Int?
    
    init?(dict: [String:Any]){
        guard
            let stat = dict["stat"] as? NamedAPIResource,
            let effort = dict["effort"] as? Int,
            let base_stat = dict["base_stat"] as? Int
            else {return nil}
        
        self.stat = stat
        self.effort = effort
        self.base_stat = base_stat
    }
}
struct PokemonType{
    var slot:Int?
    var type:NamedAPIResource?
    
    init?(dict: [String:Any]){
        guard
            let slot = dict["slot"] as? Int,
            let type = dict["type"] as? NamedAPIResource
            else {return nil}
        
        self.slot = slot
        self.type = type
    }
}


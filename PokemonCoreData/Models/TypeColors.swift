//
//  TypeColors.swift
//  PokemonCoreData
//
//  Created by Mac on 11/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TypeColors{
    class func getTypeColor(type: String)->(CGFloat,CGFloat,CGFloat){
        var red:CGFloat?
        var green:CGFloat?
        var blue:CGFloat?
        
        switch type{
        case "normal":
            red = 168/255
            green = 168/255
            blue = 120/255
        case "fire":
            red = 240/255
            green = 128/255
            blue = 48/255
        case "water":
            red = 104/255
            green = 144/255
            blue = 240/255
        case "grass":
            red = 120/255
            green = 200/255
            blue = 81/255
        case "electric":
            red = 248/255
            green = 208/255
            blue = 48/155
        case "ice":
            red = 152/255
            green = 216/255
            blue = 216/255
        case "ground":
            red = 224/255
            green = 192/255
            blue = 104/255
        case "flying":
            red = 168/255
            green = 144/255
            blue = 240/255
        case "poison":
            red = 159/255
            green = 64/255
            blue = 160/255
        case "fighting":
            red = 192/255
            green = 48/255
            blue = 40/255
        case "psychic":
            red = 248/255
            green = 88/255
            blue = 135/255
        case "dark":
            red = 112/255
            green = 88/255
            blue = 72/255
        case "rock":
            red = 184/255
            green = 160/255
            blue = 56/255
        case "bug":
            red = 168/255
            green = 184/255
            blue = 32/255
        case "ghost":
            red = 112/255
            green = 88/255
            blue = 152/255
        case "steel":
            red = 184/255
            green = 184/255
            blue = 208/255
        case "dragon":
            red = 112/255
            green = 56/255
            blue = 248/255
        case "fairy":
            red = 255/255
            green = 174/255
            blue = 201/255
        default:
            red = 0
            green = 0
            blue = 0
        }
        guard let redReturn = red else {return (0,0,0)}
        guard let greenReturn = green else {return (0,0,0)}
        guard let blueReturn = blue else {return (0,0,0)}
        return (redReturn, greenReturn, blueReturn)
    }
}

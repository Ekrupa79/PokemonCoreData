//
//  PokemonInformationViewController.swift
//  Pokedex
//
//  Created by Mac on 11/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class PokemonInformationViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var nameOfPokemonLbl:UILabel!
    @IBOutlet weak var move1Lbl:UILabel!
    @IBOutlet weak var move2Lbl:UILabel!
    @IBOutlet weak var move3Lbl:UILabel!
    @IBOutlet weak var move4Lbl:UILabel!
    @IBOutlet weak var generalScrollView:UIScrollView!
    @IBOutlet weak var statsScrollView:UIScrollView!
    @IBOutlet weak var sexImage:UIImageView!
    @IBOutlet weak var pokemonImage:UIImageView!
    
    var displayPokemon:Pokemon?
    
    var recievedURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.generalScrollView.delegate = self
        self.statsScrollView.delegate = self
        pokemonImage.image = #imageLiteral(resourceName: "blankfuzzy")
        styleSetup()
        
        //Activity indicator...?
        let sv = UIViewController.displaySpinner(onView: self.view)
        guard let url = recievedURL else {return}
        //pokemonSetup(pokemon: url)
        //        print("RecievedURL: \(ru)")
        JSONCalls.getPokemon(from: url) { (pokemon, error) in
            guard let pokemon = pokemon else {return}
            //self.displayPokemon = pokemon
            
            UIViewController.removeSpinner(spinner: sv)
            DispatchQueue.main.async {
                self.pokemonSetup(pokemon: pokemon)
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
typealias PokemonInformationSetup = PokemonInformationViewController
extension PokemonInformationSetup{
    private func pokemonSetup(pokemon: Pokemon){
        print("MADE IT HERE")
        nameOfPokemonLbl.text = pokemon.name
        guard let imageId = pokemon.id else {return}
        pokemonImage.imageFrom(url: Constants.kPokemonImageBase+String(imageId)+".png")
        
        print(pokemon.name ?? "Stuff")
        
        
        
        
        
        //fatalError("Pokemon doesn't know how to move! Such a shame to put them down.")
        //Set up information for GeneralScrollView and StatScrollView
        
    }
}

typealias PokemonInfoStyleSetup = PokemonInformationViewController
extension PokemonInfoStyleSetup{
    private func styleSetup(){
        pokemonImage.layer.masksToBounds = true
        pokemonImage.layer.cornerRadius = 10
        pokemonImage.layer.borderColor = UIColor.black.cgColor
        pokemonImage.layer.borderWidth = 2
        
        move1Lbl.layer.masksToBounds = true
        move1Lbl.layer.cornerRadius = 25
        move1Lbl.layer.borderColor = UIColor.black.cgColor
        move1Lbl.layer.borderWidth = 2
        
        move2Lbl.layer.masksToBounds = true
        move2Lbl.layer.cornerRadius = 25
        move2Lbl.layer.borderColor = UIColor.black.cgColor
        move2Lbl.layer.borderWidth = 2
        
        move3Lbl.layer.masksToBounds = true
        move3Lbl.layer.cornerRadius = 25
        move3Lbl.layer.borderColor = UIColor.black.cgColor
        move3Lbl.layer.borderWidth = 2
        
        move4Lbl.layer.masksToBounds = true
        move4Lbl.layer.cornerRadius = 25
        move4Lbl.layer.borderColor = UIColor.black.cgColor
        move4Lbl.layer.borderWidth = 2
    }
}


//
//  PokemonInformationViewController.swift
//  Pokedex
//
//  Created by Mac on 11/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class PokemonInformationViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var nameOfPokemonLbl:UILabel!
    @IBOutlet weak var move1Lbl:UILabel!
    @IBOutlet weak var move2Lbl:UILabel!
    @IBOutlet weak var move3Lbl:UILabel!
    @IBOutlet weak var move4Lbl:UILabel!
    @IBOutlet weak var favBtn:UIButton!
    @IBOutlet weak var generalScrollView:UIScrollView!
    @IBOutlet weak var statsScrollView:UIScrollView!
    @IBOutlet weak var pokemonImage:UIImageView!
    
    var displayPokemon:Pokemon?
    var favorites:[NSManagedObject] = []
    var nameOfPokemon:String?
    var recievedURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.generalScrollView.delegate = self
        self.statsScrollView.delegate = self
        
        favorites = []
        
        pokemonImage.image = #imageLiteral(resourceName: "blankfuzzy")
        self.styleSetup()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        guard let url = recievedURL else {return}
        JSONCalls.getPokemon(from: url) { (pokemon, error) in
            guard let pokemon = pokemon else {return}
            UIViewController.removeSpinner(spinner: sv)
            self.displayPokemon = pokemon
            DispatchQueue.main.async {
                self.pokemonSetup(pokemon: pokemon)
                guard self.checkForFavorite() else {return}
                self.favBtn.setImage(UIImage(named: "fav_after"), for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForFavorite() -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName:"PKMNEntity")
        //let tempPred = NSPredicate(format: "key === \(String(describing: Constants.kUser))")
        guard let user = Constants.kUser else {return false}
        request.predicate = NSPredicate(format: "%K == %@", "key", user)
        
        do{
            favorites = try managedContext.fetch(request)
            guard let currentPokemonName = nameOfPokemon else {return false}
            for fav in favorites{
                guard let favName = fav.value(forKey: "name") as? String else {return false}
                if favName.lowercased() == currentPokemonName{
                    return true
                }
            }
            //Reload... a UIViewController?
        }catch let error{
            print(error.localizedDescription)
        }
        return false
    }
    
    private func saveFavorite(fav: FavoritePokemon){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let favEntity = NSEntityDescription.entity(forEntityName: "PKMNEntity", in: managedContext) else {return}
        let favorite = NSManagedObject(entity: favEntity, insertInto: managedContext)
        favorite.setValue(Constants.kUser, forKey: "key")
        favorite.setValue(fav.name, forKey: "name")
        favorite.setValue(fav.url, forKey: "url")
        
        do{
            try managedContext.save()
            favorites.append(favorite)
            //Reload... a UIViewController?
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func favoriteToggle(){
        if self.favBtn.currentTitle == "0"{
            self.favBtn.setImage(UIImage(named: "fav_after"), for: .normal)
            self.favBtn.setTitle("1", for: .normal)
            guard let pokemonName = nameOfPokemonLbl.text else {return}
            guard let recievedURL = recievedURL else {return}
            guard let favPokemon = FavoritePokemon(name: pokemonName, url: recievedURL) else {return}
            saveFavorite(fav: favPokemon)
        }else{
            self.favBtn.setImage(UIImage(named: "fav_before"), for: .normal)
            self.favBtn.setTitle("0", for: .normal)
        }
    }
}
typealias PokemonInformationSetup = PokemonInformationViewController
extension PokemonInformationSetup{
    private func pokemonSetup(pokemon: Pokemon){
        self.nameOfPokemon = pokemon.name
        nameOfPokemonLbl.text = pokemon.name?.capitalizeFirstLetter()
        guard let imageId = pokemon.id else {return}
        pokemonImage.imageFrom(url: Constants.kPokemonImageBase+String(imageId)+".png")
        guard let weight = pokemon.weight else {return}
        guard let height = pokemon.height else {return}
        move1Lbl.text = "Weight: \(weight)"
        move2Lbl.text = "Height: \(height)"
        //Not getting data back from Dictionary types (Types, Moves, Abilities...)
        
        print("\(pokemon.name?.capitalizeFirstLetter() ?? "") Complete")
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


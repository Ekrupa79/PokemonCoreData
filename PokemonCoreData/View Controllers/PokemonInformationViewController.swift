//
//  PokemonInformationViewController.swift
//  Pokedex
//
//  Created by Mac on 11/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class PokemonInformationViewController: UIViewController {
    @IBOutlet weak var nameOfPokemonLbl:UILabel!
    @IBOutlet weak var move1Lbl:UILabel!
    @IBOutlet weak var move2Lbl:UILabel!
    @IBOutlet weak var move3Lbl:UILabel!
    @IBOutlet weak var move4Lbl:UILabel!
    //Stats
    @IBOutlet weak var baseExpLbl:UILabel!
    @IBOutlet weak var hpLbl:UILabel!
    @IBOutlet weak var speedLbl:UILabel!
    @IBOutlet weak var atkLbl:UILabel!
    @IBOutlet weak var spAtkLbl:UILabel!
    @IBOutlet weak var defLbl:UILabel!
    @IBOutlet weak var spDefLbl:UILabel!
    
    @IBOutlet weak var favBtn:UIButton!
    @IBOutlet weak var type1Btn:UIButton!
    @IBOutlet weak var type2Btn:UIButton!
    @IBOutlet weak var pokemonImage:UIImageView!
    
    var displayPokemon:Pokemon?
    var favorites:[NSManagedObject] = []
    var nameOfPokemon:String?
    var recievedURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        favorites = []
        
        self.toggleElements()
        
        pokemonImage.image = #imageLiteral(resourceName: "blankfuzzy")
        self.styleSetup()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        guard let url = recievedURL else {return}
        JSONCalls.getPokemon(from: url) { (pokemon, error) in
            guard let pokemon = pokemon else {return}
            UIViewController.removeSpinner(spinner: sv)

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
    
    private func removeFavorite(fav: FavoritePokemon){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let favEntity = NSEntityDescription.entity(forEntityName: "PKMNEntity", in: managedContext) else {return}
        let favorite = NSManagedObject(entity: favEntity, insertInto: managedContext)
        favorite.setValue(Constants.kUser, forKey: "key")
        favorite.setValue(fav.name, forKey: "name")
        favorite.setValue(fav.url, forKey: "url")
        
        print("Trying to delete...")
        managedContext.delete(favorite)
    }
    
    @IBAction func favoriteToggle(){
        guard let pokemonName = nameOfPokemonLbl.text else {return}
        guard let recievedURL = recievedURL else {return}
        guard let favPokemon = FavoritePokemon(name: pokemonName, url: recievedURL) else {return}
        if self.favBtn.currentTitle == "0"{
            self.favBtn.setImage(UIImage(named: "fav_after"), for: .normal)
            self.favBtn.setTitle("1", for: .normal)
            saveFavorite(fav: favPokemon)
        }else{
            self.favBtn.setImage(UIImage(named: "fav_before"), for: .normal)
            self.favBtn.setTitle("0", for: .normal)
            //removeFavorite(fav: favPokemon)
        }
    }
    @IBAction func filterForType(_ sender:AnyObject){
        if let typeText = sender.title(for: .normal){
            print(typeText)
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
        
        //Type Buttons
        guard let types = pokemon.types else {return}
        var count = 0
        for pokeType in types{
            let (red, green, blue) = TypeColors.getTypeColor(type: pokeType.type?.name ?? "")
            if count == 0{
                type1Btn.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
                type1Btn.setTitle(pokeType.type?.name?.capitalizeFirstLetter(), for: .normal)
                type1Btn.isHidden = false
            }else if count == 1{
                type2Btn.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
                type2Btn.setTitle(pokeType.type?.name?.capitalizeFirstLetter(), for: .normal )
                type2Btn.isHidden = false
            }
            count+=1
        }
        //Stats
        guard let bExp = pokemon.base_experience else {return}
        baseExpLbl.text = "Base Experience: \(bExp)"
        guard let stats = pokemon.stats else {return}
        var statArr:[String] = [String]()
        for stat in stats{statArr.append("\(stat.base_stat ?? 0)")}
        speedLbl.text = "Speed: \(statArr[0])"
        spDefLbl.text = "Sp. Def: \(statArr[1])"
        spAtkLbl.text = "Sp. Atk: \(statArr[2])"
        defLbl.text = "Defense: \(statArr[3])"
        atkLbl.text = "Attack: \(statArr[4])"
        hpLbl.text = "HP: \(statArr[5])"
        
        self.toggleElements()
        
        print("\(pokemon.name?.capitalizeFirstLetter() ?? "") Complete")
        //fatalError("Pokemon doesn't know how to move! Such a shame to put them down.")
        //Set up information for GeneralScrollView and StatScrollView
    }
    func toggleElements(){
        nameOfPokemonLbl.isHidden = !nameOfPokemonLbl.isHidden
        move1Lbl.isHidden = !move1Lbl.isHidden
        move2Lbl.isHidden = !move2Lbl.isHidden
        //Re-enable later
        //move3Lbl.isHidden = !move3Lbl.isHidden
        //move4Lbl.isHidden = !move4Lbl.isHidden
        baseExpLbl.isHidden = !baseExpLbl.isHidden
        hpLbl.isHidden = !hpLbl.isHidden
        speedLbl.isHidden = !speedLbl.isHidden
        atkLbl.isHidden = !atkLbl.isHidden
        spAtkLbl.isHidden = !spAtkLbl.isHidden
        defLbl.isHidden = !defLbl.isHidden
        spDefLbl.isHidden = !spDefLbl.isHidden
        favBtn.isHidden = !favBtn.isHidden
        //type1Btn.isHidden = !type1Btn.isHidden
        //type2Btn.isHidden = !type2Btn.isHidden
        pokemonImage.isHidden = !pokemonImage.isHidden
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
        move1Lbl.layer.borderWidth = 1.0
        
        move2Lbl.layer.masksToBounds = true
        move2Lbl.layer.cornerRadius = 25
        move2Lbl.layer.borderColor = UIColor.black.cgColor
        move2Lbl.layer.borderWidth = 1.0
        
        move3Lbl.layer.masksToBounds = true
        move3Lbl.layer.cornerRadius = 25
        move3Lbl.layer.borderColor = UIColor.black.cgColor
        move3Lbl.layer.borderWidth = 1.0
        
        move4Lbl.layer.masksToBounds = true
        move4Lbl.layer.cornerRadius = 25
        move4Lbl.layer.borderColor = UIColor.black.cgColor
        move4Lbl.layer.borderWidth = 1.0
        
        type1Btn.layer.cornerRadius = 20
        type1Btn.layer.borderColor = UIColor.black.cgColor
        type1Btn.layer.borderWidth = 1.0
        
        type2Btn.layer.cornerRadius = 20
        type2Btn.layer.borderColor = UIColor.black.cgColor
        type2Btn.layer.borderWidth = 1.0
    }
}


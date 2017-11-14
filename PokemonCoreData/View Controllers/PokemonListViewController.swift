//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Mac on 11/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var pokemonCollection:UICollectionView!
    
    var testValues:[Pokemon] = []
    var tempTest:[AllPokemon] = []
    var sendPokemon:Pokemon?
    var sendURL:String?
    var allPokemon:[Pokemon] = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pokemonCollection.delegate = self
        self.pokemonCollection.dataSource = self
        print(Constants.kUser ?? "")
        guard let tempAdd = URL(string: Constants.kPokeAPIBase+"pokemon/?limit="+Constants.kPokemonLimit) else {return}
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        JSONCalls.getAllPokemon(url: tempAdd, completion:{
            (x) in
            guard let testValues = x else {return}
            self.tempTest = testValues
            UIViewController.removeSpinner(spinner: sv)
            DispatchQueue.main.async {
                self.pokemonCollection.reloadData()
            }
        })
        
        //Cell setup
        self.setupCellSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

typealias PokemonCollectionViewSetup = PokemonListViewController
extension PokemonCollectionViewSetup:UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tempTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallPokemonCell", for: indexPath) as? PokemonCell else {fatalError("POKEMON ESCAPE! CELL NOT FOUND!")}
        
        // Configure the cell
        cell.pokeImage.image = #imageLiteral(resourceName: "blankfuzzy")
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.pokeImage.imageFrom(url: Constants.kPokemonImageBase+"\(indexPath.row+1).png")
        
        return cell
    }
    
    func setupCellSize(){
        let cellSize = CGSize(width:100, height:100)
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        pokemonCollection.setCollectionViewLayout(layout, animated: true)
        
        pokemonCollection.reloadData()
    }
}

typealias SegueSetup = PokemonListViewController
extension SegueSetup{
    //To Character Information: ShowPokemonInfo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pokemonVC = segue.destination as? PokemonInformationViewController else {fatalError("Uh oh! No segue means no Pokemon! Unless there is a void type Pokemon...")}
        pokemonVC.recievedURL = self.sendURL
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = tempTest[indexPath.row].url else {return}
        self.sendURL = url
        performSegue(withIdentifier: "ShowPokemonInfo", sender: nil)
    }
}


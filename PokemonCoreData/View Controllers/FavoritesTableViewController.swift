//
//  FavoritesTableViewController.swift
//  PokemonCoreData
//
//  Created by Mac on 11/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    @IBOutlet weak var favTableView:UITableView!
    @IBOutlet weak var reloadBtn:UIBarButtonItem!

    var favorites:[NSManagedObject]?
    var sendURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favTableView.delegate = self
        self.favTableView.dataSource = self
        
        self.favTableView.reloadData()
        self.getFavorites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFavorites(){
        let sv = UIViewController.displaySpinner(onView: self.view)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName:"PKMNEntity")
        
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDesc]
        
        guard let user = Constants.kUser else {return}
        request.predicate = NSPredicate(format: "%K == %@", "key", user)
        
        do{
            favorites = try managedContext.fetch(request)
            favTableView.reloadData()
        }catch let error{
            print(error.localizedDescription)
        }
        UIViewController.removeSpinner(spinner: sv)
    }
    
    @IBAction func reloadView(){
        self.getFavorites()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        var pokemonId:Int?
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath)
        guard let temp = favorites?[indexPath.row].value(forKey: "url") as? String else {return cell}
        if let id = NSURL(string: temp){
            guard let pID = id.lastPathComponent else {return cell}
            pokemonId = Int(pID)
        }
        guard let tempId = pokemonId else {return cell}
        cell.imageView?.imageFrom(url: Constants.kPokemonImageBase+String(tempId)+".png")
        cell.textLabel?.text = favorites?[indexPath.row].value(forKey: "name") as? String
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PokemonInformationViewController else {fatalError("Uh oh! No segue means no Pokemon! Unless there is a void type Pokemon...")}
        vc.recievedURL = self.sendURL
        super.prepare(for: segue, sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = favorites?[indexPath.row].value(forKey: "url") as? String else {return}
        self.sendURL = url
        performSegue(withIdentifier: "FromFavorites", sender: nil)
        self.favTableView.reloadData()
        self.favTableView.deselectRow(at: indexPath, animated: true)
    }
}

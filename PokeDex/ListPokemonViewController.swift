//
//  ListPokemonViewController.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-26.
//  Copyright © 2020 Louise Chan. All rights reserved.
//

import UIKit
import CoreData

class ListPokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: List Pokemon variables
    let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pokemons: [Pokemon] = []
    var battleViewController: PokemonBattleViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load pokemons from database in alphabetical order
        fetchSortedPokemonsFromDB()
    }
    
    // MARK: Table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup cell data to display for row based on custom tableview cell.
        var cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as? PokemonTableViewCell
        
        // if there are no table cells to dequeue, just create a new cell
        if (cell == nil) {
            cell = PokemonTableViewCell(style: .default, reuseIdentifier: "pokemonCell")
        }
        
        // Show the pokemon name, type, image and base experience
        let index = indexPath.row
        let imageName = pokemons[index].photo ?? ""
        if imageName == "" {
            cell?.imgPokemonPicture.image = UIImage(named: "noimage")
        } else {
            cell?.imgPokemonPicture.image = UIImage(named: imageName)
        }
        
        // Update the objects that will be shown in each table row
        cell?.txtPokemonName.text = pokemons[index].name!
        cell?.txtPokemonType.text = "Type: \(pokemons[index].type!)"
        cell?.txtPokemonBaseExp.text = "Base experience: \(pokemons[index].expPoints) pts"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let view = battleViewController {
            // Pass the pokemon that was selected in the battle screen
            view.selectedPokemon = pokemons[indexPath.row]
        }
    }
    
    // MARK: Helper functions
    func fetchSortedPokemonsFromDB() {
        let request : NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        // setup sort decriptor so that pokemon name will be sorted alphabetically
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            // store sorted pokemons in the Pokemon array
            pokemons = try dbContext.fetch(request)
            
            if pokemons.count == 0 {
                print("no pokemons stored in database")
            }
            else {
                // print saved pokemons
                print("Pokemons saved: ")
                for pokemon in pokemons {
                    print("Name: \(pokemon.name!) Type: \(pokemon.type!) Base exp.: \(pokemon.expPoints) pts")
                }
            }
        } catch {
            print("Error reading from database")
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Since this method is called before the tableView didSelectRowAt method, we have to make sure that the view controller for the segue has been properly setup.
        battleViewController = segue.destination as? PokemonBattleViewController
     }
    
}

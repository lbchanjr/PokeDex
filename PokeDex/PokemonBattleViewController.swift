//
//  PokemonBattleViewController.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-26.
//  Copyright © 2020 Louise Chan. All rights reserved.
//

import UIKit
import CoreData

class PokemonBattleViewController: UIViewController {

    // MARK: Battle view controller variables
    var selectedPokemon: Pokemon?
    var opponents: [Pokemon] = []
    let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Outlets
    
    @IBOutlet weak var lblPokePlayerName: UILabel!
    
    @IBOutlet weak var lblPokeComputerName: UILabel!
    
    @IBOutlet weak var imgPokePlayerImage: UIImageView!
    
    @IBOutlet weak var imgPokeComputerImage: UIImageView!
    
    
    @IBOutlet weak var lblPokePlayerBaseExp: UILabel!
    @IBOutlet weak var lblPokeComputerBaseExp: UILabel!
    @IBOutlet weak var lblBattleResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show selected pokemon from the list
        let player = selectedPokemon!
        let battleTimestamp = Date()
        lblPokePlayerName.text = player.name ?? ""
        lblPokePlayerBaseExp.text = "\(player.expPoints) pts"
        imgPokePlayerImage.image = UIImage(named: player.photo ?? "noimage")
        
        // Fetch opponent of different type from database
        if let opponent = fetchPokemonOpponent() {
            // Show opponent data
            lblPokeComputerName.text = opponent.name ?? ""
            lblPokeComputerBaseExp.text = "\(opponent.expPoints) pts"
            imgPokeComputerImage.image = UIImage(named: opponent.photo ?? "noimage")
            
            // Determine who won the battle.
            var winner = player
            var result = ""
            // Check for a tie
            if player.expPoints == opponent.expPoints {
                result = "It's a tie!"
            } else if player.expPoints > opponent.expPoints {
                // Selected pokemon wins
                result = "Player wins"
            } else {
                // Randomly selected opponent wins
                result = "Computer wins"
                winner = opponent
            }
            
            // Update results and save to database
            lblBattleResult.text = result
            saveBattleResultToDB(battleDate: battleTimestamp, winner: winner)
            
        } else {
            // If no opponents were found, let player 1 win by default
            lblPokeComputerName.text = "<none>"
            lblPokeComputerBaseExp.text = "-- pts"
            imgPokeComputerImage.image = UIImage(named: "noimage")
            lblBattleResult.text = "Player wins (no opponent found)"
        }
        
    }
    

    // MARK: Helper functions
    func fetchPokemonOpponent() -> Pokemon? {
        let request : NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        // Query for pokemons that are of different type compared to the selected pokemon
        let query = NSPredicate(format: "type != %@", (selectedPokemon?.type)!)
        request.predicate = query
        
        
        do {
            // Fetch all possible opponents for selected pokemon
            opponents = try dbContext.fetch(request)
            
            // Check if at least 1 opponent has been found
            if opponents.count == 0 {
                print("no pokemons of a different type stored in database")
                // return nil if no opponents were found
                return nil
            }
            else {
                // print pokemon opponents
                print("Pokemon opponents found: ")
                for opponent in opponents {
                    print("Name: \(opponent.name!) Type: \(opponent.type!) Base exp.: \(opponent.expPoints) pts")
                }
                
                // Shuffle the opponents list in order to obtain a random opponent.
                // The first item on the shuffled array will be the chosen opponent.
                return opponents.shuffled()[0]
            }
        } catch {
            print("Error reading from database")
            // return nil if there's an error during query
            return nil
        }
    }
    
    func saveBattleResultToDB(battleDate: Date, winner: Pokemon) {
        let battle = Battle(context: dbContext)
        battle.battleDateTime = battleDate as NSDate?
        winner.addToBattles(battle)
        
        do {
            // Save battle to database
            try dbContext.save()
            print("Battle saved in database!")
        } catch {
            print("Battle not saved in database!")
        }
        
        print("saving battle date \(battle.battleDateTime!) and winner \(winner.name!) to database")
        
    }
    
    func showBattleSaveMessage(msg: String) {
        let alertBox = UIAlertController(title:"Battle Save Message",
                                         message: msg,
                                         preferredStyle: .alert);
        
        // Add OK button for user action but don't specify any handler for the action
        alertBox.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        
        // Show the alert box on top of the view controller
        self.present(alertBox, animated: true)
    }

}

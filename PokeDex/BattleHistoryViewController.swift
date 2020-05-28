//
//  BattleHistoryViewController.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-26.
//  Copyright © 2020 Louise Chan. All rights reserved.
//

import UIKit
import CoreData

class BattleHistoryViewController: UIViewController {
    // MARK: Battle view controller variables
    var battles: [Battle] = []
    let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Outlets
    @IBOutlet weak var txtViewBattleHistory: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize text view output
        txtViewBattleHistory.text = ""
        
        // Fetch battles
        fetchBattleHistory()
        
        if battles.count == 0 {
            txtViewBattleHistory.text = "No battles saved in database."
        } else {
            // Setup formatter for date so that date can be displayed in YYYY-MM-DD HH:MM:SS AM/PM format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
            
            // iterate through all battles that were saved in database
            for battle in battles {
                // Display each battle using the formatted date and the winning pokemon in each line.
                let formattedDate = dateFormatter.string(from: battle.battleDateTime! as Date)
                txtViewBattleHistory.text.append("\(formattedDate)\t\((battle.winningPokemon?.name)!) wins\n")
                
            }
        }
    }
    
    // MARK: Helper functions
    func fetchBattleHistory(){
        let request : NSFetchRequest<Battle> = Battle.fetchRequest()
        
        do {
            // Fetch all battles that were saved in the database and store it in an array
            battles = try dbContext.fetch(request)
            
            if battles.count == 0 {
                print("no battles were stored in database")
            }
            else {
                // print battle info
                print("Saved battles found: ")
                for battle in battles {
                    print("Timestamp: \(battle.battleDateTime!) Winner: \((battle.winningPokemon?.name)!)")
                }
            }
        } catch {
            print("Error reading from database")
        }
    }

}

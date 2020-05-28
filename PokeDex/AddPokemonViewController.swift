//
//  AddPokemonViewController.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-25.
//  Copyright © 2020 Louise Chan. All rights reserved.
//

import UIKit

class AddPokemonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: Add Pokemon variables
    let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemonTypes = ["Normal", "Fire", "Water", "Grass", "Electric"]

    // MARK: Add Pokemon Outlets
    @IBOutlet weak var txtPokemonName: UITextField!
    
    @IBOutlet weak var txtPokemonImage: UITextField!
   
    @IBOutlet weak var pickerPokemonType: UIPickerView!
    
    @IBOutlet weak var txtBaseExp: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup delegates and data source
        self.pickerPokemonType.dataSource = self
        self.pickerPokemonType.delegate = self
        self.txtBaseExp.delegate = self
        self.txtPokemonName.delegate = self
        self.txtPokemonImage.delegate = self
        
        // Initialize text fields and picker views
        initAddInputFields()
    }
    
    // MARK: Add Pokemon Actions
    @IBAction func btnRerollPressed(_ sender: UIButton) {
        // generate new random base experience points for pokemon
        generateRandomBaseExpPoints()
    }
    
    
    @IBAction func btnSavePokemonPressed(_ sender: UIButton) {
        
            // Check if name field is empty.
        if let name = txtPokemonName.text {
            if name == "" {
                showInputError(msg: "Name field should not be empty.")
            }
            else {
                // Check if base experience input is a valid integer between 50-250
                if checkBaseExpInputIsValid() {
                    // Name input is valid, save data into database.
                    saveInputToDatabase()
                    
                    // Return to the main view controller
                   
                    showPokemonSaveMessage(msg: "Pokemon was added into the database.") { _ in
                        self.initAddInputFields()
                    }
                    
                    
                    
                } else {
                    // Tell user that base experience is invalid
                    showInputError(msg: "Base experience points should be an integer value within 50 to 250.")
                }
            }
        } else {
            showInputError(msg: "Invalid name input.")
        }
        
    }
    
    // MARK: Add Pokemon Picker view delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemonTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pokemonTypes[row]
    }
    
    // MARK: Text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Helper functions
    func showInputError(msg: String) {
        // Create alert controller object and setup title and message to show
        let alertBox = UIAlertController(title:"Input error!",
                                         message: msg,
                                         preferredStyle: .alert);
        
        // Add OK button for user action but don't specify any handler for the action
        alertBox.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        
        // Show the alert box on top of the view controller
        self.present(alertBox, animated: true)
    }
    
    func showPokemonSaveMessage(msg: String, handler: ((UIAlertAction) -> Void)?) {
        let alertBox = UIAlertController(title:"Pokemon Save Message",
                                         message: msg,
                                         preferredStyle: .alert);
        
        // Add OK button for user action but don't specify any handler for the action
        alertBox.addAction(
            UIAlertAction(title: "OK", style: .default, handler: handler)
        )
        
        // Show the alert box on top of the view controller
        self.present(alertBox, animated: true)
    }
    
    func saveInputToDatabase() {
        let pokemon = Pokemon(context: dbContext)
        
        // At this point, we are sure that all user inputs contain valid data so we can now perform force-unwrapping of optionals
        pokemon.name = txtPokemonName.text!
        pokemon.photo = txtPokemonImage.text!
        pokemon.expPoints = Int16(txtBaseExp.text!)!
        pokemon.type = pokemonTypes[pickerPokemonType.selectedRow(inComponent: 0)]
        
        //
        do {
            try dbContext.save()
        } catch {
            print("Error adding pokemon to database")
            showPokemonSaveMessage(msg: "Pokemon was not saved in the database.", handler: nil)
        }
        
    }
    
    func generateRandomBaseExpPoints() {
        let baseExpPoints = Int.random(in: 50...250)
        txtBaseExp.text = "\(baseExpPoints)"
    }
    
    func checkBaseExpInputIsValid() -> Bool {
        // Check if text input is valid
        if let baseExpString = txtBaseExp.text {
            // Check if input is a valid integer
            if let baseExpInt = Int(baseExpString) {
                // Check if base experience input is an integer between 50 and 250
                if baseExpInt >= 50 && baseExpInt <= 250 {
                    return true
                }
            }
        }
        
        // If we get here, indicate that base experience data is not valid.
        return false
    }
    
    func initAddInputFields() {
        // Clear name and image text input
        txtPokemonName.text = ""
        txtPokemonImage.text = ""
        // Set picker view to first data available
        pickerPokemonType.selectRow(0, inComponent: 0, animated: true)
        
        // generate random base experience points for the pokemon to add
        generateRandomBaseExpPoints()
    }
}

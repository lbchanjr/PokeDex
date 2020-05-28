//
//  PokemonTableViewCell.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-26.
//  Copyright © 2020 Louise Chan. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPokemonPicture: UIImageView!
    @IBOutlet weak var txtPokemonName: UILabel!
    @IBOutlet weak var txtPokemonType: UILabel!
    @IBOutlet weak var txtPokemonBaseExp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CKTableCell.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

//====================================================================================================================================
// CELL DELEGATES
//====================================================================================================================================

protocol CKTableCellDelegate: class {
    func didTapFavouriteButton(cell: CKTableCell)
    func didTapPlaybutton(cell: CKTableCell)
}

class CKTableCell: UITableViewCell {

    @IBOutlet weak var songImgView: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    weak var delegate: CKTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //====================================================================================================================================
    // CELL BUTTON ACTIONS
    //====================================================================================================================================
    
    @IBAction func playAction(_ sender: Any) {
        self.delegate?.didTapPlaybutton(cell: self)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
    }

    @IBAction func favouriteAction(_ sender: Any) {
        self.delegate?.didTapFavouriteButton(cell: self)
    }
    
}

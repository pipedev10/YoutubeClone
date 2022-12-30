//
//  OptionCell.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 28-12-22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configCell(option: String) {
        titleLabel.text = option
    }
}

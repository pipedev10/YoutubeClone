//
//  OptionCell.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 28-12-22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            highlightTitle(isSelected ? .whiteColor : .grayColor)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func highlightTitle(_ color: UIColor){
        titleLabel.textColor = color
    }
    
    func configCell(option: String) {
        titleLabel.text = option
    }
}

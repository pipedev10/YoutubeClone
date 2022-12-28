//
//  PlaylistCell.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 07-12-22.
//

import UIKit
import Kingfisher

class PlaylistCell: UITableViewCell {
    
    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var videoCountOverlay: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    var didTapoDotsButton: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        if let tap = didTapoDotsButton{
            tap()
        }
    }
    
    private func configView() {
        selectionStyle = .none
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .whiteColor
    }
    
    func configCell(model: PlaylistModel.Item) {
        videoTitle.text = model.snippet.title
        videoCount.text = String(model.contentDetails.itemCount)+" videos"
        videoCountOverlay.text = String(model.contentDetails.itemCount)
        
        let imageUrl = model.snippet.thumbnails.medium.url
        if let url = URL(string: imageUrl) {
            videoImage.kf.setImage(with: url)
        }
    }
    
}

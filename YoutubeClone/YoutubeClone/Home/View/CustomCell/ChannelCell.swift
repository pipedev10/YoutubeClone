//
//  ChannelCell.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 07-12-22.
//

import UIKit
import Kingfisher

class ChannelCell: UITableViewCell {

    @IBOutlet weak var bannerImage2: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var channelInfoLabel: UILabel!

    @IBOutlet weak var subscriberNumberLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var subscriberLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bellImage.image = .bellImage
        bellImage.tintColor = .grayColor
        profileImage.layer.cornerRadius = 51/2
        profileImage.layer.masksToBounds = true
    }

    func configCell(model: ChannelModel.Items) {
        channelInfoLabel.text = model.snippet.description
        channelTitle.text = model.snippet.title
        subscriberNumberLabel.text = "\(model.statistics?.subscriberCount ?? "0") subscribers - \(model.statistics?.videoCount ?? "0") videos"
        
        if let bannerUrl = model.brandingSettings?.image.bannerExternalUrl, let url = URL(string: bannerUrl){
                   bannerImage2.kf.setImage(with: url)
               }
               
               let imageUrl = model.snippet.thumbnails.medium.url
               
               guard let url = URL(string: imageUrl) else{
                   return
               }
               profileImage.kf.setImage(with: url)
        
    }
}

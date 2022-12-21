//
//  VideoCell.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 07-12-22.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videName: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var dotsImage: UIImageView!
    
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
        //dotsImage.tintColor
        selectionStyle = .none
    }
    
    func configCell(model: Any) {
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "whiteColor")
        if let video = model as? VideoModel.Item {
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
            }
            videName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.title ?? ""
            viewsCountLabel.text =  "\(video.statistics?.viewCount ?? "0") views - 3 months ago"
            
            
        } else if let playlistItems = model as? PlaylistItemsModel.Item {
            if let imageUrl = playlistItems.snippet.thumbnails.medium?.url, let url = URL(string: imageUrl) {
                videoImage.kf.setImage(with: url)
            }
            videName.text = playlistItems.snippet.title
            channelName.text = playlistItems.snippet.channelTitle
            viewsCountLabel.text =  "332 views - 3 months ago"
        }
    }
    
}

//
//  VideosViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

class VideosViewController: UIViewController {

    @IBOutlet weak var tableViewVideos: UITableView!
    lazy var presenter = VideosPresenter(delegate: self)
    var videoList: [VideoModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        Task {
            await presenter.getVideos()
        }
    }
    
    func configTableView() {
        // Before
        /**
         let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
         tableViewVideos.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
         */
        // After
        tableViewVideos.register(cell: VideoCell.self)
        
        tableViewVideos.separatorColor = .clear
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
    }
}


extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videoList[indexPath.row]
        // Before
        /**
         guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
             return UITableViewCell()
         }
         **/
        // After
        let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
        
        videoCell.didTapoDotsButton = { [weak self] in
            self?.configButtonSheet()
        }
        videoCell.configCell(model: video)
        return videoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension VideosViewController: VideosViewProtocol {
    func getVideos(videoList: [VideoModel.Item]) {
        self.videoList = videoList
        tableViewVideos.reloadData()
    }
    
}

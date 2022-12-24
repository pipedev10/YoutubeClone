//
//  PlaylistsViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 03-12-22.
//

import UIKit

class PlaylistsViewController: UIViewController {
    
    @IBOutlet weak var tableViewPlaylist: UITableView!
    lazy var presenter = PlaylistPresenter(delegate: self)
    var playlist: [PlaylistModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        Task {
            await presenter.getPlaylists()
        }
    }
    
    func configTableView() {
        let nibVideos = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewPlaylist.register(nibVideos, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        tableViewPlaylist.separatorColor = .clear
        tableViewPlaylist.delegate = self
        tableViewPlaylist.dataSource = self
    }
}

extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlist[indexPath.row]
        guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
            return UITableViewCell()
        }
        playlistCell.didTapoDotsButton = { [weak self] in
            self?.configButtonSheet()
        }
        playlistCell.configCell(model: playlist)
        return playlistCell
    }
    
    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension PlaylistsViewController: PlaylistViewProtocol {
    func getPlaylists(playlist: [PlaylistModel.Item]) {
        self.playlist = playlist
        tableViewPlaylist.reloadData()
    }
}

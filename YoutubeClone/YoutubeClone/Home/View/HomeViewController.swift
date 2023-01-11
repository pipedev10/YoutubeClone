//
//  HomeViewController.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 05-12-22.
//

import UIKit
import FloatingPanel

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewHome: UITableView!
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList: [[Any]] = []
    private var sectionTitleList: [String] = []
    var fpc: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configFloatingPanel()
        Task {
            await presenter.getHomeObjects()
        }
    }
    
    func configTableView() {
        // Before
        /**
            let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
            tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
            let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
            tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
            
            let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
            tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
            tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
         */
        
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        tableViewHome.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: -80, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectList[indexPath.section]
        // Before
        if let channel = item as? [ChannelModel.Items]{
            // Before
            /**guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
                return UITableViewCell()
            }*/
            let channelCell = tableView.dequeueReusableCell(for: ChannelCell.self, for: indexPath)
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
        } else if let playlistItems = item as? [PlaylistItemsModel.Item]{
            /**guard let playlistItemCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }*/
            let playlistItemCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            playlistItemCell.didTapoDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            playlistItemCell.configCell(model: playlistItems[indexPath.row])
            return playlistItemCell
        } else if let videos = item as? [VideoModel.Item]{
            /**guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }*/
            let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            videoCell.didTapoDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
        } else if let playlist = item as? [PlaylistModel.Item]{
            /**
             guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
                return UITableViewCell()
            }*/
            let playlistCell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
            playlistCell.configCell(model: playlist[indexPath.row])
            playlistCell.didTapoDotsButton = { [weak self] in
                self?.configButtonSheet()
            }
            return playlistCell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitleList[section]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return 95.0
        }
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else {
            return nil
        }
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objectList[indexPath.section]
        var videoId: String = ""
        
        if let playlistItem = item as? [PlaylistItemsModel.Item] {
            videoId = playlistItem[indexPath.row].contentDetails?.videoId ?? ""
        } else if let videos = item as? [VideoModel.Item] {
            videoId = videos[indexPath.row].id ?? ""
        } else {
            return
        }
        
        presentViewPanel(videoId)
        
    }
    
    func configButtonSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension HomeViewController: HomeViewProtocol {
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}

extension HomeViewController : FloatingPanelControllerDelegate {
    func presentViewPanel(_ videoId: String) {
        let contentVC = PlayVideoViewController()
        contentVC.videoId = videoId
        fpc?.set(contentViewController: contentVC)
        if let fpc = fpc {
            present(fpc, animated: true)
        }
    }
    
    func configFloatingPanel() {
        // Initialize a `FloatingPanelController` object.
        fpc = FloatingPanelController(delegate: self)
        fpc?.isRemovalInteractionEnabled = true
        fpc?.surfaceView.grabberHandle.isHidden = true
        fpc?.layout = MyFloatingPanelLayout()
        fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        <#code#>
    }
    
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee != .full {
            // TODO:
        } else {
            // TODO :
        }
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

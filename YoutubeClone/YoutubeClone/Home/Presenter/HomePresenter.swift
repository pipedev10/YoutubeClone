//
//  HomePresenter.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 05-12-22.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func getData(list: [[Any]], sectionTitleList: [String])
}

class HomePresenter {
    var provider: HomeProviderProtocol
    weak var delegate: HomeViewProtocol?
    private var objectList: [[Any]] = []
    private var sectionTitleList: [String] = []
    
    init(delegate: HomeViewProtocol, provider: HomeProviderProtocol = HomeProvider()) {
        self.delegate = delegate
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = HomeProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getHomeObjects() async {
        objectList.removeAll()
        sectionTitleList.removeAll()
        
        async let channel = try await provider.getChannel(channelId: Constants.channelId).items
        async let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items
        
        do {
            let (responseChannel, responsePlaylist, responseVideos) = await (try channel, try playlist, try videos)
            
            // index 0
            objectList.append(responseChannel)
            sectionTitleList.append("")
            
            if let playlistId = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId){
                // index 1
                objectList.append(playlistItems.items.filter({$0.snippet.title != "Private video"}))
                sectionTitleList.append(responsePlaylist.first?.snippet.title ?? "")
            }
            
            // Index 2
            objectList.append(responseVideos)
            sectionTitleList.append("Uploads")
            
            // index 3
            objectList.append(responsePlaylist)
            sectionTitleList.append("Created playlists")
            
            delegate?.getData(list: objectList, sectionTitleList: sectionTitleList)
        }catch{
            print(error)
        }
    }
    
    func getPlaylistItems(playlistId: String) async -> PlaylistItemsModel? {
        do{
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlistId)
            return playlistItems
        } catch {
            print("error:", error)
            return nil
        }
        
    }
}

//
//  PlaylistPresenter.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 24-12-22.
//

import Foundation

protocol PlaylistViewProtocol: AnyObject {
    func getPlaylists(playlist: [PlaylistModel.Item])
}

class PlaylistPresenter {
    
    private weak var delegate: PlaylistViewProtocol?
    private var provider: PlaylistProviderProtocol
    
    init(delegate: PlaylistViewProtocol, provider: PlaylistProviderProtocol = PlaylistProvider()) {
        self.delegate = delegate
        self.provider = provider
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = PlaylistProviderMock()
        }
        #endif
    }

    @MainActor
    func getPlaylists() async{
        do {
            let playlists = try await provider.getPlaylists(channelId: Constants.channelId).items
            delegate?.getPlaylists(playlist: playlists)
        } catch {
            print(error.localizedDescription)
        }
    }
}

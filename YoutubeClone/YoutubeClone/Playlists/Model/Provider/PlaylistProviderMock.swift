//
//  PlaylistProviderMock.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 24-12-22.
//

import Foundation

class PlaylistProviderMock: PlaylistProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        guard let model = Utils.parseJson(jsonName: "Playlists", model: PlaylistModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
}

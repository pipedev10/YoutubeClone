//
//  PlaylistProvider.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 24-12-22.
//

import Foundation

protocol PlaylistProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlaylistModel
}

class PlaylistProvider: PlaylistProviderProtocol {
    
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        let queryParams: [String: String] = ["part": "snippet,contentDetails",
                                             "channelId": channelId]
        let requestModel = RequestModel(endpoint: .playlist, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            return model
        } catch {
            print(error)
            throw error
        }
    }
    
    
}

//
//  VideosPresenter.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 24-12-22.
//

import Foundation

protocol VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel
}

class VideosProvider: VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel {
        var queryParams: [String: String] = ["part": "snippet", "type": "video", "maxResults": "50"]
        if !channelId.isEmpty {
            queryParams["channelId"] = channelId
        }
       let requestModel = RequestModel(endpoint: .search, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model
        } catch {
            print(error)
            throw error
        }
    }
}

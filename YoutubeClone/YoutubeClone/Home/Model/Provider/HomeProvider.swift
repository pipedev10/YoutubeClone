//
//  HomeProvider.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 05-12-22.
//

import Foundation

protocol HomeProviderProtocol {
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel
}

class HomeProvider: HomeProviderProtocol {
    
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel {
        var queryParams: [String: String] = ["part": "snippet"]
        if !channelId.isEmpty {
            queryParams["channelId"] = channelId
        }
        if !searchString.isEmpty {
            queryParams["q"] = searchString
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

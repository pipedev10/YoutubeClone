//
//  VideosProviderMock.swift
//  YoutubeClone
//
//  Created by Felipe Carrasco on 24-12-22.
//

import Foundation

class VideoProviderMock: VideosProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel {
        guard let model = Utils.parseJson(jsonName: "VideoList", model: VideoModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }
}

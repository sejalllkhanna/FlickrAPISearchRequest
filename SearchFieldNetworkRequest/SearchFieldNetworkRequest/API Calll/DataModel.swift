//
//  DataModel.swift
//  SearchFieldNetworkRequest
//
//  Created by Apple on 03/12/21.
//

import Foundation

// MARK: - Welcome
struct DataModel: Codable {
   let photos: Photos
   let stat: String
}

// MARK: - Photos
struct Photos: Codable {
   let page, pages, perpage, total: Int
   let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
   let id, owner, secret, server: String
   let farm: Int
   let title: String
   let ispublic, isfriend, isfamily: Int
}

//
//  CharacterDetails.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import Foundation

public struct CharacterObject: Decodable {
    let data: CharacterData?
}

public struct CharacterData: Decodable {
    let results: [CharacterDetails]?
}

public struct EventList: Decodable {
    let items: [EventSummary]?
}

public struct EventSummary: Decodable {
    let name: String?
}

public struct CharacterDetails: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    let events: EventList?
}

public struct Thumbnail: Decodable {
    enum CodingKeys: String, CodingKey {
          case path
          case extensionString = "extension"
      }
    let path: String?
    let extensionString: String?
}

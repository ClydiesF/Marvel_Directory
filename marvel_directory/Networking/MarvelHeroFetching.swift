//
//  MarvelHeroFetching.swift
//  marvel_directory
//
//  Created by clydies freeman on 8/2/20.
//  Copyright © 2020 clydies freeman. All rights reserved.
//

import Foundation
import CommonCrypto

public final class MarvelHeroFetching {
    public enum RequestError: Error {
        case invalidURL
        case invalidResponse
        case noData
    }
    
    private let session = URLSession.shared
    
    public init() {}
    
    public func getListOfCharacters(queryString: String? = nil, completetion: @escaping (Result<[CharacterDetails],Error>) -> Void) {
        makAPIRequest(queryString: queryString, completetion: completetion)
    }
    
    func makAPIRequest(queryString: String?, completetion: @escaping (Result<[CharacterDetails],Error>) -> Void) {

        let ts = "\(Date().timeIntervalSince1970)"

        let privateKey = "899bd59d00c1b6f87b5dd43405a811ba7f319990"
        let publicKey = "2a2647f8edfbdd3526509e9ccf6789b3"

        let hash = (ts + privateKey + publicKey).md5

        var url: URL
        if let queryString = queryString {
            guard let url3 = URL(string: "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(queryString)&limit=10&ts=\(ts)&apikey=2a2647f8edfbdd3526509e9ccf6789b3&hash=\(hash)") else { return }
                url = url3
        } else {
            guard let url2 = URL(string: "https://gateway.marvel.com:443/v1/public/characters?limit=10&ts=\(ts)&apikey=2a2647f8edfbdd3526509e9ccf6789b3&hash=\(hash)") else { return }
            url = url2
        }
        
        let dataTask = session.dataTask(with: url) { data, res, err in
            //checks for data from the response
            guard let jsonData = data else {
                completetion(.failure(err ?? RequestError.invalidResponse))
                return
            }
            // parses response
            do {
              let decoder = JSONDecoder()
                let characters = try decoder.decode(CharacterObject.self, from: jsonData)
                completetion(.success(characters.data.results!))
            } catch {
                completetion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
}

extension String {
    var md5: String {
      let length = Int(CC_MD5_DIGEST_LENGTH)
      var digest = [UInt8](repeating: 0, count: length)
      if let data = data(using: String.Encoding.utf8) {
        _ = data.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
          CC_MD5(body, CC_LONG(data.count), &digest)
        }
      }

      return (0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
      }
    }
}

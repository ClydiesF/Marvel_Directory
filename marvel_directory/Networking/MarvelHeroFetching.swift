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
    
    private let allowedDiskSize = 100 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "gifCache")
    }()

    private func createAndRetrieveURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfiguration.urlCache = cache
        return URLSession(configuration: sessionConfiguration)
    }
    
    private let session = URLSession.shared
    
    public init() {}
    
    public func getListOfCharacters(queryString: String? = nil, completion: @escaping (Result<CharacterData,Error>) -> Void) {
        makAPIRequest(queryString: queryString, completion: completion)
    }
    
    func makAPIRequest(queryString: String?, completion: @escaping (Result<CharacterData,Error>) -> Void) {

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
        
        let urlRequest = URLRequest(url: url)
        if let cachedData = self.cache.cachedResponse(for: urlRequest) {
            print("Cached data in bytes:", cachedData.data)
            completion(.success((cachedData.data as? CharacterData)!))
        } else {
        
        let dataTask = createAndRetrieveURLSession().dataTask(with: url) { data, res, err in
            //checks for data from the response
            guard let jsonData = data else {
                completion(.failure(err ?? RequestError.invalidResponse))
                return
            }
            // parses response
            do {
              let decoder = JSONDecoder()
                let characters = try decoder.decode(CharacterObject.self, from: jsonData)
                let cachedData = CachedURLResponse(response: res!, data: data!)
                self.cache.storeCachedResponse(cachedData, for: urlRequest)
                completion(.success(characters.data!))
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
        }
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

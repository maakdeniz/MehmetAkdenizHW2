//
//  NYTimesService.swift
//  
//
//  Created by Mehmet Akdeniz on 15.05.2023.
//

import Foundation

public protocol NYTimesServiceProtocol {
    func fetchTopStories(completion: @escaping (Result<[StoryResult], Error>) -> Void)
}

public class NYTimesService: NYTimesServiceProtocol {
  
    
    public let topStoriesURL = "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=TPrqBqAPM8c745G0zjdZnxLTTaUGALQM"
    public init() {}
    
    public func fetchTopStories(completion: @escaping (Result<[StoryResult], Error>) -> Void) {
        guard let url = URL(string: topStoriesURL) else {
            completion(.failure(NSError(domain: "", code: -1,userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1,userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(StoryResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
        
    }
}

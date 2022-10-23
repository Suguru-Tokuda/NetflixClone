//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Suguru on 10/20/22.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

enum URLType {
    case trendingMovies, trendingTvs, upcomingMovies, popularMovies, topRatedMovies, discoverMovies, movieGenre, tvGenre
}

class APICaller {
    static let shared = APICaller()
    
    private func getURL(for name: URLType) -> String {
        var retVal: String = ""

        switch name {
        case .trendingMovies:
            retVal = "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        case .trendingTvs:
            retVal = "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        case .upcomingMovies:
            retVal = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US"
        case .popularMovies:
            retVal = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US"
        case .topRatedMovies:
            retVal = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US"
        case .discoverMovies:
            retVal = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        case .movieGenre:
            retVal = "\(Constants.baseURL)/3/genre/movie/list?api_key=\(Constants.API_KEY)"
        case .tvGenre:
            retVal = "\(Constants.baseURL)/3/genre/tv/list?api_key=\(Constants.API_KEY)"
        }
        
        return retVal
    }
        
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .trendingMovies)) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .trendingTvs)) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .upcomingMovies)) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .popularMovies)) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .topRatedMovies)) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
        
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: getURL(for: .discoverMovies)) else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getAllTitles(completion: @escaping (Result<[[Title]], Error>) -> Void) async throws {
        Task {
            var retVal: [[Title]] = []

            guard
                let getTrendingMoviesURL = URL(string: getURL(for: .trendingMovies)),
                let getTrendingTVsURL = URL(string: getURL(for: .trendingTvs)),
                let getUpcomingMoviesURL = URL(string: getURL(for: .upcomingMovies)),
                let getPopularMoviesURL = URL(string: getURL(for: .popularMovies)),
                let getTopRatedMoviesURL = URL(string: getURL(for: .topRatedMovies)) else { return }
            
            let urls: [URL] = [
                getTrendingMoviesURL,
                getTrendingTVsURL,
                getUpcomingMoviesURL,
                getPopularMoviesURL,
                getTopRatedMoviesURL
            ]
            
            for url in urls {
                if let data = try? await NetworkingManager.download(url: url) {
                    let response = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    retVal.append(response.results)
                }
            }
            
            completion(.success(retVal))
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            self.handleTitleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let titles):
                    completion(.success(titles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YOUTUBE_BASE_URL)q=\(query)&key=\(Constants.YOUTUBEAPI_KEY)") else { return }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            self.handleYoutubeResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let videos):
                    completion(.success(videos[0]))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getAllGenres(completion: @escaping (Result<[GenreModel], Error>) -> Void) async throws {
        Task {
            var retVal: [GenreModel] = []
            
            guard
                let movieGenreURL = URL(string: getURL(for: .movieGenre)),
                let tvGenreURL = URL(string: getURL(for: .tvGenre)) else { return }
            
            let urls: [URL] = [movieGenreURL, tvGenreURL]
            
            for url in urls {
                if let data = try? await NetworkingManager.download(url: url) {
                    let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                    retVal.append(contentsOf: response.genres)
                }
            }
            
            completion(.success(retVal))
        }
    }
    
    private func handleTitleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let data = data, error == nil else {
            return
        }

        do {
            let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
            completion(.success(results.results))
        } catch {
            completion(.failure(APIError.failedToGetData))
        }
    }
    
    private func handleYoutubeResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<[VideoElement], Error>) -> Void) {
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
            completion(.success(results.items))
        } catch {
            completion(.failure(APIError.failedToGetData))
        }
    }
}

//
//  API.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation

public struct Config {
    public static var apikey: String = "9f06e686d2df727befa904b934eea181"
    public static var baseURL: String = "https://api.themoviedb.org/3"
    public static var baseURLDiscover: String = "\(baseURL)/discover/movie"
    public static var baseURLDetail: String = "\(baseURL)/movie"
    
    public static func getURLWithApiKeyList() -> String {
        return "\(Config.baseURLDiscover)?api_key=\(Config.apikey)"
    }
    
    public static var imageURL: String = "https://image.tmdb.org/t/p/w500/"
    public static func getImageURL(imageId: String) -> String {
        return "\(Config.imageURL)\(imageId)"
    }
    
    public static func getImageUrlAsUrl(imageId: String) -> URL?{
        let urlString = "\(Config.imageURL)\(imageId)"
        if let url = URL(string: urlString) {
            return url
        }
        return nil
    }
}

protocol ClientServiceProtocol : class {
    func moviesRequest(pageNumber: Int, completion: @escaping (Response<Movies>) -> ()) -> ()
    func detailMoviesRequest(movieID: Int, completion: @escaping (Response<MovieDetail>) -> ()) -> ()
}



class Client: ClientServiceProtocol {
    func moviesRequest(pageNumber: Int, completion: @escaping (Response<Movies>) -> ()) -> (){
        let urlString = "\(Config.getURLWithApiKeyList())&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(pageNumber)"
        
        HTTPRequest.request(urlString) {(response: Response<Movies>) in
            completion(response)
        }
    }
    
    func detailMoviesRequest(movieID: Int, completion: @escaping (Response<MovieDetail>) -> ()) -> (){
        
        let urlString = "\(Config.baseURLDetail)/\(movieID)?api_key=\(Config.apikey)"
        
        HTTPRequest.request(urlString) { (response: Response<MovieDetail>) in
            completion(response)
        }
    }
}
class HTTPRequest{
    
    class func request<T: Decodable>(_ url: String ,completionHandler: @escaping (Response<T>) -> ()) -> (){
        
        if !Reachability.isConnectedToNetwork() {
            completionHandler(Response.Error("network connection"))
            return
        }
        
        let requestURL = URL(string: url)!
        print(url)
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completionHandler(.Error((String(describing: error))))
                }else{
                    
                    do {
                        if let data = data {
                            let response = try JSONDecoder().decode(T.self, from: data)
                            completionHandler(Response.Success(response))
                            return
                        }
                    } catch let jsonError {
                        completionHandler(Response.Error(jsonError.localizedDescription))
                    }
                }
            })
            
        })
        task.resume()
    }
}

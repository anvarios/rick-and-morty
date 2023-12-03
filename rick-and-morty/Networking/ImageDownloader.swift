//
//  ImageDownloader.swift
//  training
//
//  Created by Anvar Kayumov on 04/12/23.
//

import Foundation

protocol ImageDownloaderProtocol {
    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ())
    func cancel()
}

final class ImageDownloader: ImageDownloaderProtocol {

    private var downloadTask: URLSessionDataTask?

    func downloadImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        downloadTask = URLSession.shared.dataTask(with: url) { data, response, networkError in
            if let networkError = networkError {
                completion(.failure(.networkError(networkError)))
                return
            }

            guard let data = data else {
                completion(.failure(.dataIsEmpty))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidStatusCode))
                return
            }

            completion(.success(data))
        }

        downloadTask?.resume()
    }

    func cancel() {
        downloadTask?.cancel()
    }
}

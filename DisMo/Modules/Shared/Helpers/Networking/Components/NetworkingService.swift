//
//  NetworkingService.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import Foundation

class NetworkingService {
    public static let shared = NetworkingService()
    
    public func request<T: Decodable>(_ method: NetworkingMethod = .get, _ endpoint: NetworkingEndpoint, headers: [String: String] = [:], parameters: [String: Any] = [:], responseType: T.Type, completion: @escaping (_ result: Result<T, CustomError>) -> Void) {

//        let defaultHeaders: [String: String] = [
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]

        guard let url = URL.construct(endpoint) else {
            fatalError("Invalid URL, please check `NetworkingEndpoint`")
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
//        request.allHTTPHeaderFields = defaultHeaders.merging(headers) { (_, value) in value }
        request.httpMethod = method.rawValue.uppercased()

        if method != .get {
            // Non GET method
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } else {
            // GET method
            request.url = URL.construct(endpoint, queries: parameters)
        }

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            let url = request.url?.absoluteString ?? ""
            var logOutput = "🚀 HTTP_REQUEST: \(method.rawValue) \(url)"
            if method != .get {
                logOutput += " 📦 BODY: \(parameters.debugDescription)"
            }
            if let responseJSON = String(data: data, encoding: .utf8) {
                logOutput += " ✅ JSON: \(responseJSON)"
            }
            print(logOutput)

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.serializationError))
            }
        })
        task.resume()
    }
}

extension URL {
    static func construct(_ endpoint: NetworkingEndpoint, queries: [String: Any] = [:]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path =  endpoint.value
        components.queryItems = queries.isEmpty ? nil : queries
            .compactMapValues({
                if let value = $0 as? String {
                    return value
                } else {
                    return "\($0)"
                }
            })
            .map({ URLQueryItem(name: $0.key, value: $0.value) })
        return components.url
    }
}

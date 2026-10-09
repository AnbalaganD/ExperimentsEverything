//
//  NetworkRequestBuilder.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 12/04/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum RequestComponent {
    case url(URL)
    case path(String)
    case method(HTTPMethod)
    case header(String, String)
    case queryItem(URLQueryItem)
    case timeout(TimeInterval)
    case body(Data)
    case cachePolicy(URLRequest.CachePolicy)
}

@resultBuilder
struct NetworkRequestBuilder {
    static func buildBlock(_ components: [RequestComponent]...) -> [RequestComponent] {
        components.flatMap { $0 }
    }

    static func buildExpression(_ expression: RequestComponent) -> [RequestComponent] {
        [expression]
    }

    static func buildExpression(_ expression: [RequestComponent]) -> [RequestComponent] {
        expression
    }

    static func buildOptional(_ component: [RequestComponent]?) -> [RequestComponent] {
        component ?? []
    }

    static func buildEither(first component: [RequestComponent]) -> [RequestComponent] {
        component
    }

    static func buildEither(second component: [RequestComponent]) -> [RequestComponent] {
        component
    }

    static func buildArray(_ components: [[RequestComponent]]) -> [RequestComponent] {
        components.flatMap { $0 }
    }
}

extension URLRequest {
    init(@NetworkRequestBuilder _ content: () -> [RequestComponent]) {
        let components = content()

        var urlComponents: URLComponents?
        var method = HTTPMethod.get
        var headers: [String: String] = [:]
        var timeoutInterval: TimeInterval = 60
        var body: Data?
        var cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy

        for component in components {
            switch component {
            case .url(let url):
                urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            case .path(let path):
                if urlComponents == nil {
                    urlComponents = URLComponents()
                }
                let existingPath = urlComponents?.path ?? ""
                urlComponents?.path = Self.combinePath(existingPath, with: path)
            case .method(let requestMethod):
                method = requestMethod
            case .header(let field, let value):
                headers[field] = value
            case .queryItem(let item):
                if urlComponents == nil {
                    urlComponents = URLComponents()
                }
                var items = urlComponents?.queryItems ?? []
                items.append(item)
                urlComponents?.queryItems = items
            case .timeout(let interval):
                timeoutInterval = interval
            case .body(let data):
                body = data
            case .cachePolicy(let policy):
                cachePolicy = policy
            }
        }

        guard let finalURL = urlComponents?.url else {
            preconditionFailure("NetworkRequestBuilder requires a valid URL.")
        }

        self.init(url: finalURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        httpMethod = method.rawValue
        allHTTPHeaderFields = headers.isEmpty ? nil : headers
        httpBody = body
    }

    private static func combinePath(_ existingPath: String, with newPath: String) -> String {
        switch (existingPath.hasSuffix("/"), newPath.hasPrefix("/")) {
        case (true, true):
            return existingPath + newPath.dropFirst()
        case (false, false) where !existingPath.isEmpty && !newPath.isEmpty:
            return existingPath + "/" + newPath
        default:
            return existingPath + newPath
        }
    }
}

func URL(_ string: String) -> RequestComponent {
    guard let url = Foundation.URL(string: string) else {
        preconditionFailure("Invalid URL string: \(string)")
    }
    return .url(url)
}

func Path(_ path: String) -> RequestComponent {
    .path(path)
}

func Method(_ method: HTTPMethod) -> RequestComponent {
    .method(method)
}

func Header(_ field: String, _ value: String) -> RequestComponent {
    .header(field, value)
}

func QueryItem(_ name: String, _ value: String?) -> RequestComponent {
    .queryItem(URLQueryItem(name: name, value: value))
}

func Timeout(_ interval: TimeInterval) -> RequestComponent {
    .timeout(interval)
}

func Body(_ data: Data) -> RequestComponent {
    .body(data)
}

func Body(_ string: String) -> RequestComponent {
    .body(Data(string.utf8))
}

func CachePolicy(_ policy: URLRequest.CachePolicy) -> RequestComponent {
    .cachePolicy(policy)
}

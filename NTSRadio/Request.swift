//
// Created by Артмеий Шлесберг on 14/08/2018.
// Copyright (c) 2018 Shlesberg. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

protocol Request {
    func make() -> Observable<JSON>
}

struct ServerError: Error {

    var title: String
    var detail: String
    var status: Int

    static func from(json: JSON) -> ServerError? {

        guard let status = json["status"].int,
            let title = json["title"].string,
            let detail = json["detail"].string else { return nil }

        return ServerError(title: title, detail: detail, status: status)
    }

    var localizedDescription: String {
        return detail
    }
}

class UnauthorizedRequest: Request {

    private var request: URLRequest

    init(path: String,
         method: HTTPMethod = .get,
         parameters: Parameters = [:],
         encoding: ParameterEncoding = URLEncoding.default,
         headers: [String: String] = [:]) throws {

        guard let url = URL(string: "https://www.nts.live/api/v2\(path)") else {
            throw RequestError()
        }

        self.request = try encoding.encode(URLRequest(url: url, method: method, headers: headers), with: parameters)
    }

    func make() -> Observable<JSON> {
        return Observable.create { [unowned self] observer in

            Alamofire.request(self.request)
                    .validate()
                    .responseJSON { response in

                        switch response.result {
                        case .success(let value):

                            observer.onNext(JSON(value))
                            observer.onCompleted()

                        case .failure(let error):


                            observer.onError(error)

                        }
                    }
            return Disposables.create()
        }
    }
}

class ImageRequest {

    private var request: URLRequest

    init(link: String) throws {

        guard let url = URL(string: link) else {
            throw RequestError()
        }

        self.request = try URLRequest(url: url, method: .get)//  try encoding.encode(URLRequest(url: url, method: method, headers: headers), with: parameters)
    }

    func make() -> Observable<UIImage> {
        return Observable.create { [unowned self] observer in
            Alamofire.request(self.request).responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    if let image = UIImage(data: data) {
                        observer.onNext(image)
                    } else {
                        observer.onError(ResponseError(message: "Image error"))
                    }
                case let .failure(error):
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}

class ResponseError: LocalizedError {

    var message: String = "Ошибка сервера"
    var description: [String]?
    var errorDescription: String? {
        return description?.joined(separator: " ") ?? message
    }

    init() {

    }

    init(message: String) {
        self.message = message
    }
}

class RequestError: LocalizedError {

    var message: String = "Ошибка запроса"
    var description: [String]?
    var errorDescription: String? {
        return description?.joined(separator: " ") ?? message
    }

    init() {

    }

    init(message: String) {
        self.message = message
    }

}

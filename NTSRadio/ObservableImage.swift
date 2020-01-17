//
//  ObservableImage.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 18/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol ObservableImage {
    func asObservable() -> Observable<UIImage>
}

class FakeObservableImage: ObservableImage {
    func asObservable() -> Observable<UIImage> {
        return Observable.just(#imageLiteral(resourceName: "sampleImage"))
    }
}


class ObservableImageFrom: ObservableImage {

    private let link: String
    private var request: ImageRequest!

    init(link: String) {
        self.link = link
    }

    func asObservable() -> Observable<UIImage> {
        guard let request = try? ImageRequest(link: link) else {
            return Observable.error(RequestError())
        }
        self.request = request
        return self.request.make()
    }
}

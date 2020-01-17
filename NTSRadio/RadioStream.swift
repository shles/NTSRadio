//
//  RadioStrem.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 03/02/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import AVFoundation
import MediaPlayer

protocol Titlable {
    var name: String {get}
}

protocol RadioStreams {
    func asObservable() -> Observable<[RadioStream]>
    func currentStream() -> Observable<RadioStream>
}

class FakeNeverPlayingStreams: RadioStreams {
    func asObservable() -> Observable<[RadioStream]> {
        return Observable.just([FakeNeverPlayingStream(), FakeNeverPlayingStream()])
    }
    
    func currentStream() -> Observable<RadioStream> {
        return Observable<RadioStream>.never()
    }
}

class StreamsFromAPI: RadioStreams {

    private var request: Request!

    func asObservable() -> Observable<[RadioStream]> {
        guard let request = try? UnauthorizedRequest(path: "/live") else {
            return Observable.error(RequestError())
        }
        self.request = request
        return self.request.make().map { json in
            json["results"].arrayValue.map {
                NTSStream(json: $0, output: StreamOutput(), link: "https://stream-relay-geo.ntslive.net/stream")
            }
        }
    }

    func currentStream() -> Observable<RadioStream> {
        return asObservable().flatMapLatest {
            Observable.merge($0.map {
                stream in stream.playing.filter{$0}.map{_ in stream }
            })
        }
    }
}

protocol RadioStream: Titlable {
    var playing: Observable<Bool> { get }
    var schedule: Schedule { get }
    func toggle()
}

protocol ObservableStream {
    func asObservable() -> Observable<RadioStream>
}

class ObservableStreamFrom: ObservableStream {
    
    private var origin: RadioStream
    
    init(origin: RadioStream) {
        self.origin = origin
    }
    
    func asObservable() -> Observable<RadioStream> {
        return Observable.just(origin)
    }
}

class NTSStream: RadioStream {
    
    private var playingVariable = Variable<Bool>(false)
    private let output: StreamOutput
    private let link: String
    
    var playing: Observable<Bool> {
        return playingVariable.asObservable()
    }
    
    var schedule: Schedule 
    var name: String
    
    init(json: JSON, output: StreamOutput, link: String) {
        self.name = "CHANNEL \(json["channel_name"].string ?? "0")"
        //TODO: schedule is no longer proper name
        self.schedule = ScheduleWithCurrentAndNextFromJSON(json: json)
        self.output = output
        self.link = link
    }
    
    func toggle() {
        if playingVariable.value {
            output.stopPlaying()
        } else {
            output.play(link: "\(link)?t=\(Date().timeIntervalSince1970)")
        }
        playingVariable.value = !playingVariable.value
    }
    
}

class FakeNeverPlayingStream: RadioStream {
    var playing: Observable<Bool> { return Observable.just(false) }
    
    var schedule: Schedule = FakeSchedule()
    
    func toggle() {
        
    }
    
    var name: String = "LIVE 1"
    
}

class StreamOutput {

    private var player: AVPlayer?

    func play(link: String) {
        if let url = URL(string: link) {
            let item = AVPlayerItem(url: url)
            item.asset.commonMetadata.first(where: { $0.commonKey?.rawValue == "Title"})?.value = "NTSRadio"

            let audioInfo = MPNowPlayingInfoCenter.default()

            player = AVPlayer(playerItem: item)
            player?.play()
        }
    }

    func stopPlaying() {
        player?.pause()
    }
}

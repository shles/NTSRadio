//
//  Program.swift
//  Differentiator
//
//  Created by Артмеий Шлесберг on 19/03/2018.
//

import Foundation
import SwiftyJSON


protocol Program: Titlable {
    var name: String { get }
    var timeSpace: TimeSpace { get }
    var image: ObservableImage { get }
    var description: String { get}
    var location: Location { get }
}

protocol Location {
    var shortString: String { get }
    var longString: String { get }
}

class LondonLocation: Location {
    var shortString: String = "LDN"
    var longString: String = "London"
}
class FakeProgramAllStyles: Program {

    var name: String = "ALL STYLES ALL SMILES (R)"
    var timeSpace: TimeSpace = TimeSpaceFrom(startDate: Date(), duration: 36000)
    var image: ObservableImage = FakeObservableImage()
    
    var description: String = "Alien Jams is a FORTNIGHTLY show focusing on electronic music throughout history. The program aims to provide background on early electronics as well as present day artists."
    
    var location: Location = LondonLocation()
    
}


class ProgramFrom: Program {
    init(json: JSON) {
        name = json["broadcast_title"].string ?? "Unknown"
        timeSpace = TimeSpaceFrom(
            startDate: Date(),//Date.from(fullString: json["start_timestamp"].string!)!,
            endDate: Date()//Date.from(fullString: json["end_timestamp"].string!)!
        )
        location = LondonLocation()
        description = json["embeds"]["details"]["description"].string ?? "No description available"
        image = ObservableImageFrom(link: json["embeds"]["details"]["media"]["picture_medium_large"].string ?? "")
    }

    private(set) var timeSpace: TimeSpace
    private(set) var image: ObservableImage
    private(set) var description: String
    private(set) var location: Location
    private(set) var name: String
}

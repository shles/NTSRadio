//
//  Schedule.swift
//  Differentiator
//
//  Created by Артмеий Шлесберг on 19/03/2018.
//

import Foundation
import SwiftyJSON

protocol Schedule {
    var programs: [Program] { get }
}

extension Schedule {
    func currentProgram() -> Program {
        return programs[0]
    }
    
    func nextProgram() -> Program {
        return programs[1]
    }
}

class ScheduleWithCurrentAndNextFromJSON: Schedule {


    var programs: [Program] = []

    init(json: JSON) {
        programs.append(contentsOf: [ProgramFrom(json: json["now"]), ProgramFrom(json: json["next"])])
    }

}


class FakeSchedule: Schedule {
    var programs: [Program] = [
        FakeProgramAllStyles(),
        FakeProgramAllStyles()
    ]
}



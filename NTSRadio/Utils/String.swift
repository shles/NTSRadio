//
// Created by Артмеий Шлесберг on 16/06/2017.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation

extension String {

    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces.union(CharacterSet(charactersIn: "\n")))
    }

    var url: URL? {
        return URL(string: self)
    }

    var phone: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }

    func convertedOnEmpty(to string: String) -> String {
        if self.isEmpty { return string } else { return self }
    }
    
    func convertedOnEmptyToNil() -> String? {
        if self.isEmpty { return nil } else { return self }
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

}

extension Optional {

    func unwrapOrThrow() throws -> Wrapped {
        guard let unwrapped = self else { throw NSError(domain: "Can't unwrap", code: 404) }
        return unwrapped
    }

}

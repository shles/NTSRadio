//
//  StandardSectionModel.swift
//  DiscountMarket
//
//  Created by Timofey on 6/6/17.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import RxDataSources

struct StandardSectionModel<T>: SectionModelType {
    var items: [T]

    init(original: StandardSectionModel<T>, items: [T]) {
        self = original
        self.items = items
    }

    init(items: [T]) {
        self.items = items
    }

}

struct HeadedSectionModel<ItemsType, HeaderType>: SectionModelType {

    var items: [ItemsType]
    var header: HeaderType
    init(original: HeadedSectionModel<ItemsType, HeaderType>, items: [ItemsType]) {
        self = original
        self.header = original.header
        self.items = items
    }

    init(items: [ItemsType], header: HeaderType) {
        self.items = items
        self.header = header
    }

}

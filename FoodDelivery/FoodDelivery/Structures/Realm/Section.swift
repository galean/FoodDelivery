//
//  Section.swift
//  FoodDelivery
//
//  Created by Galean Pallerman on 16.08.2019.
//  Copyright © 2019 GPco. All rights reserved.
//

import Foundation
import RealmSwift

struct SectionStruct: Codable {
    let id: Int
    let version: Int
    let name: String
}

class Section: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var version: Int = 0
    @objc dynamic var name: String = ""
    
    let ofRestaurants: LinkingObjects = LinkingObjects(fromType: Restaurant.self,
                                                       property: "sections")
    
    static override func primaryKey() -> String {
        return "id"
    }
    
    static func fromSectionStruct(_ sectionStruct: SectionStruct) -> Section {
        let section = Section()
        section.id = sectionStruct.id
        section.version = sectionStruct.version
        section.name = sectionStruct.name
        return section
    }
    
    func toStruct() -> SectionStruct {
        let sectStruct = SectionStruct(id: id, version: version, name: name
        )
        return sectStruct
    }
}

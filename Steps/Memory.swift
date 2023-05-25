//
//  Memory.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/24.
//

import Foundation
import RealmSwift

class Memory: Object{
    @Persisted(primaryKey: true) var date: String = ""
    @Persisted var steps_num: Int = 0
    @Persisted var distance: Float = 0.0
    @Persisted var location: String = ""
    @Persisted var photo: String = ""
}

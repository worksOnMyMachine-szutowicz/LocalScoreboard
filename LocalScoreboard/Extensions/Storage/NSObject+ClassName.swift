//
//  NSObject+ClassName.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 25/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import CoreData

extension NSManagedObject {
    static func className() -> String {
        String(describing: self)
    }
}

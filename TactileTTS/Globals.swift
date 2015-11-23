//
//  Globals.swift
//  TactileTTS
//
//  Created by Administrator on 11/21/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import Foundation

class GlobalStuff {
    
    static let sharedInstance = GlobalStuff()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}

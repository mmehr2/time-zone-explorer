//
//  RESTforPARSE.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/26/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

class PARSEAPI {
    
    private let connection = DataConnection()
    
    enum Verb {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum Header {
        case AppID
        case ApiKey
        case ContentType
    }
    
    init() {
    }
    
}
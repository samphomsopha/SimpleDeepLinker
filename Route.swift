//
//  Route.swift
//  UniversialLinkDemo
//
//  Created by sam phomsopha on 6/25/16.
//  Copyright © 2016 sam phomsopha. All rights reserved.
//

import Foundation

struct Route {
    let path: String!
    let storyBoard: String?
    let routeClass: String?
    let indentifier: String?
    let handler: String?
    var url:NSURL!
    
    init(storyBoard: String?, path: String?, indentifier: String?, routeClass: String?, handler: String?) {
        if let _storyBoard = storyBoard {
            self.storyBoard = _storyBoard
        } else {
            self.storyBoard = nil
        }
        
        if let _path = path {
            self.path = _path
        } else {
            self.path = nil
        }
        
        if let _routeClass = routeClass {
            self.routeClass = _routeClass
        } else {
            self.routeClass = nil
        }
        
        if let _ident = indentifier {
            self.indentifier = _ident
        } else {
            self.indentifier = nil
        }
        
        if let _handler = handler {
            self.handler = _handler
        } else {
            self.handler = nil
        }
    }
}
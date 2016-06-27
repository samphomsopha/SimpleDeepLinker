//
//  Router.swift
//  UniversialLinkDemo
//
//  Created by sam phomsopha on 6/25/16.
//  Copyright © 2016 sam phomsopha. All rights reserved.
//

import UIKit

class Router {
    static let sharedInstance = Router()
    private let defaultStoryBoardId: String?
    private var routes = [Route]()
    private let defaultRoute: Route?
    private var routeQueue = [Route]()
    
    private init() {
        print("INITIALIZING")
        //var routes = [String]()
        if let path = NSBundle.mainBundle().pathForResource("routes", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    let jsonArr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
                    
                    if let _defaultStoryBoard = jsonArr["storyboard"] as! String? {
                        defaultStoryBoardId = _defaultStoryBoard
                    } else {
                        defaultStoryBoardId = nil
                    }
                    
                    if let _defaultRouteArr = jsonArr["defaultRoute"] {
                        let className = _defaultRouteArr!["class"] as! String?
                        let ident = _defaultRouteArr!["identifier"] as! String?
                        
                        self.defaultRoute = Route(storyBoard: defaultStoryBoardId, path: "", indentifier: ident, routeClass: className, handler: nil)
                    } else {
                        self.defaultRoute = nil
                    }
                    if let _routes = jsonArr["routes"] {
                        for (key, item) in _routes as! [String:AnyObject] {
                            let _className = item["class"] as! String?
                            let _ident = item["identifier"] as! String?
                            var _storyBoardId = item["storyBoardId"] as! String?
                            if _storyBoardId == nil {
                                _storyBoardId = defaultStoryBoardId
                            }
                            
                            let _handler = item["handler"] as! String?

                            routes.append(Route(storyBoard: _storyBoardId, path: key, indentifier: _ident, routeClass: _className, handler: _handler))
                        }
                    }
                    
                } catch {
                    self.defaultStoryBoardId = nil
                    self.defaultRoute = nil
                    print("error serializing JSON: \(error)")
                }
            } else {
                self.defaultStoryBoardId = nil
                self.defaultRoute = nil
            }
        } else {
            self.defaultStoryBoardId = nil
            self.defaultRoute = nil
        }
        
    }
    
    func prepareToHandleRequest(url: NSURL) {
        print("PREPAPING")
        //where are we going if just scheme add default route to queue
        guard var path = url.host else {
            //do we have default route
            if let _defaultRoute = defaultRoute {
                routeQueue.append(_defaultRoute)
            }
            return
        }
        
        if let spath = url.path {
            path = path + spath
        }
        
        for testRoute in routes {
            if testRoute.path == path {
                var foundRoute = testRoute
                foundRoute.url = url
                routeQueue.append(foundRoute)
            }
        }
    }
    
    func handleQueueRequest(window: UIWindow) {
        print("HANDING")
        print(routeQueue)
        if let route = routeQueue.first {
            //print(route)
            routeQueue.removeFirst()
            //get current active story
            if let storyBoardName = route.storyBoard {
                let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
                //have handler? if so notify
                if let handler = route.handler {
                    print("FOUND HANDLER")
                    var info:[NSObject : AnyObject]!
                    
                    info["url"] = route.url
                    
                    if let _ = route.storyBoard {
                        info["storyboardId"] = route.storyBoard!
                    }
                    
                    if let _ = route.indentifier {
                        info["identifier"] = route.indentifier!
                    }
                    
                    if let _ = route.routeClass {
                        info["className"] = route.routeClass!
                    }
                    
                    if let _ = route.handler {
                        info["handler"] = route.handler!
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(handler, object: route as? AnyObject, userInfo: info)
                    return
                }
                //start with story board Id
                if let storyBoardIdentifer = route.indentifier {
                    let viewToShow = storyboard.instantiateViewControllerWithIdentifier(storyBoardIdentifer) as UIViewController
                    self.presentView(viewToShow, window: window)
                    return
                }
                //try class name
                if let _className = route.routeClass {
                    let vClass = NSClassFromString(_className) as! UIViewController.Type
                    let viewControll = vClass.init()
                    self.presentView(viewControll, window: window)
                    return
                }
            }
        }
        //print(routeQueue)
    }
    
    func presentView(viewControllToShow: UIViewController, window: UIWindow) {
        
        //check to see if root is navigation controller
        if let rootVC = window.rootViewController as? UINavigationController {
            //does the VC exist in UINAV stack?
            for existingVC in rootVC.viewControllers {
                if existingVC.isKindOfClass(viewControllToShow.self.classForCoder) {
                    print(existingVC)
                    print("POPING")
                    rootVC.popToViewController(existingVC, animated: true)
                    return
                }
            }
            if rootVC.viewControllers.contains(viewControllToShow) {
                print("POPING")
                rootVC.popToViewController(viewControllToShow, animated: true)
                return
            } else {
                //doesn't
                print("PUSING VIEW NEW")
                rootVC.pushViewController(viewControllToShow, animated: true)
            }
            return
        }
        //ok must be just UIViewController
        if let rootVC = window.rootViewController {
            rootVC.presentViewController(viewControllToShow, animated: true, completion: nil)
        }
        else {
            //we can't find the rootVC, fuck I don't know what to do
            window.rootViewController = viewControllToShow
        }

    }
}
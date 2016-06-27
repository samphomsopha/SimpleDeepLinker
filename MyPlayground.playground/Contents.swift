//: Playground - noun: a place where people can play

import Foundation

struct Route {
    let path: String!
    let storyBoard: String?
    let routeClass: String?
    let indentifier: String?
    
    init(storyBoard: String?, path: String?, routeClass: String?, indentifier: String?) {
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
        
        
    }
}

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
                        
                        self.defaultRoute = Route(storyBoard: defaultStoryBoardId, path: "", routeClass: className, indentifier: ident)
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
                            routes.append(Route(storyBoard: _storyBoardId, path: key, routeClass: _className, indentifier: _ident))
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
        //where are we going if just scheme add default route to queue
        guard let path = url.host else {
            //do we have default route
            if let _defaultRoute = defaultRoute {
                routeQueue.append(_defaultRoute)
            }
            return
        }
        
        for testRoute in routes {
            if testRoute.path == path {
                routeQueue.append(testRoute)
            }
        }
    }
}

var url = NSURL(string: "birdland://second/third?url=http://google.com")
var myRoute = Router.sharedInstance
myRoute.prepareToHandleRequest(url!)
print(myRoute.routeQueue)





import UIKit
import RLDNavigationSwift

extension RLDNavigationSetup {
    
    static let pathComponentToDestination = [
        "menu" : "NavigationPrototype.RLDMenuViewController",
        "folder" : "NavigationPrototype.RLDFolderViewController",
        "connections" : "NavigationPrototype.RLDConnectionsViewController",
        "chat" : "NavigationPrototype.RLDChatViewController",
        "profile" : "NavigationPrototype.RLDProfileViewController",
        "contact": "NavigationPrototype.RLDContactCardViewController"]
    
    init(url:String, navigationController:UINavigationController) {
        
        self.origin = NSStringFromClass(navigationController.topViewController!.dynamicType)
        self.navigationController = navigationController
        self.destination = ""
        self.properties = nil
        self.breadcrumbs = nil
        
        if let urlComponents = NSURLComponents(string:url),
            let path = urlComponents.path {
                let pathComponents = path.componentsSeparatedByString("/")
                var breadcrumbs = breadcrumbsFor(pathComponents:pathComponents)
                if count(breadcrumbs) > 0 {
                    self.destination = breadcrumbs.removeLast()
                    self.properties = propertiesWith(query:urlComponents.query)
                    self.breadcrumbs = breadcrumbs
                }
        }
    }
    
    private func breadcrumbsFor(#pathComponents:[String]) -> [String] {
        var breadcrumbs:[String] = []
        for pathComponent in pathComponents {
            if let destination = self.dynamicType.pathComponentToDestination[pathComponent] {
                breadcrumbs.append(destination)
            } else {
                return []
            }
        }
        return breadcrumbs
    }
    
    private func propertiesWith(#query:String?) -> [String:AnyObject]? {
        if let query = query {
            var properties:[String:AnyObject] = [:]
            var keyOrValue: NSString?, key: String?, value: String?
            let controlCharacters = NSCharacterSet(charactersInString:"&?=")
            let queryScanner = NSScanner(string:query)
            queryScanner.charactersToBeSkipped = controlCharacters
            
            while queryScanner.scanUpToCharactersFromSet(controlCharacters,intoString:&keyOrValue) {
                value = key != nil
                    ? String(keyOrValue!)
                    : nil
                key = key ?? String(keyOrValue!)
                if (key != nil && value != nil) {
                    properties[key!] = value
                    key = nil
                    value = nil
                }
            }
            
            return properties;
        }
        return nil
    }

}
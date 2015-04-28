import RLDNavigationSwift

class RLDConnectionsNavigationCommand:RLDPushPopNavigationCommand {
    
    override class var origins:[String]? {
        return ["NavigationPrototype.RLDMenuViewController"]
    }
    
    override class var destination:String? {
        return "NavigationPrototype.RLDConnectionsViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDConnectionsViewController"
    }

}
import Foundation

class RLDMenuNavigationCommand:RLDPushPopNavigationCommand {
   
    override class var destination:String? {
        return "NavigationPrototype.RLDMenuViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDMenuViewController"
    }

}
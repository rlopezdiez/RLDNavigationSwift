import Foundation

class RLDFolderNavigationCommand:RLDPushPopNavigationCommand {
    
    override class var origins:[String]? {
        return ["NavigationPrototype.RLDMenuViewController"]
    }

    override class var destination:String? {
        return "NavigationPrototype.RLDFolderViewController"
    }
    
    override class var viewControllerStoryboardIdentifier:String? {
        return "RLDFolderViewController"
    }
    
}
import UIKit

class RLDChatViewController:UIViewController {

    @IBOutlet weak var titleLabel:UILabel!
    
    var userId:String? {
        didSet {
            if let userId = userId {
                titleLabel.text = "Chat with user \(userId)"
            }
        }
    }
    
    @IBAction func jumpToProfileTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDProfileViewController",
            properties:["userId":userId!],
            navigationController:navigationController!).go()
    }

    @IBAction func jumpToProfileForSecondUserTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDProfileViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDChatViewController"],
            navigationController:navigationController!).go()
    }

    @IBAction func jumpToChatWithSecondUserTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDConnectionsViewController"],
            navigationController:navigationController!).go()
    }
}

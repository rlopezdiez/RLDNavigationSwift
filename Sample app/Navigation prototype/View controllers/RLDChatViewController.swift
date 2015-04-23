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
        self.goTo("NavigationPrototype.RLDProfileViewController",
            properties:["userId":userId!])
    }

    @IBAction func jumpToProfileForSecondUserTapped() {
        self.goTo("NavigationPrototype.RLDProfileViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDChatViewController"])
    }

    @IBAction func jumpToChatWithSecondUserTapped() {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDConnectionsViewController"])
    }
}

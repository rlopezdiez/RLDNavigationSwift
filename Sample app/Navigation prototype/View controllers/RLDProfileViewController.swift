import UIKit

class RLDProfileViewController:UIViewController {
    
    @IBOutlet weak var titleLabel:UILabel!
    
    var userId:String? {
        didSet {
            if let userId = userId {
                titleLabel.text = "Profile of user \(userId)"
            }
        }
    }
    
    @IBAction func chatWithUserTapped() {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":userId!])
    }
    
    @IBAction func jumpToConnectionsTapped() {
        self.goTo("NavigationPrototype.RLDConnectionsViewController")
    }
    
    @IBAction func jumpToMenuTapped() {
        self.goTo("NavigationPrototype.RLDMenuViewController")
    }
    
    @IBAction func jumpToProfileForSecondUserTapped() {
        self.goTo("NavigationPrototype.RLDProfileViewController",
            properties:["userId":"2"])
    }
    
    @IBAction func jumpToChatWithSecondUserTapped() {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDProfileViewController"])
    }
    
}

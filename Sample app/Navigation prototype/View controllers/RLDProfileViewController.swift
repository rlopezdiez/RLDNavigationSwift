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
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":userId!],
            navigationController:navigationController!).go()
    }
    
    @IBAction func jumpToConnectionsTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDConnectionsViewController",
            navigationController:navigationController!).go()
    }
    
    @IBAction func jumpToMenuTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDMenuViewController",
            navigationController:navigationController!).go()
    }
    
    @IBAction func jumpToProfileForSecondUserTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDProfileViewController",
            properties:["userId":"2"],
            navigationController:navigationController!).go()
    }
    
    @IBAction func jumpToChatWithSecondUserTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":"2"],
            breadcrumbs:["NavigationPrototype.RLDProfileViewController"],
            navigationController:navigationController!).go()
    }
    
}

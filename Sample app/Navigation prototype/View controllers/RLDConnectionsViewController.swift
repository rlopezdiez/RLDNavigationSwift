import UIKit

class RLDConnectionsViewController:UIViewController {

    @IBAction func chatWithFirstUserTapped() {
        navigateToChat(userId:"1")
    }
    
    @IBAction func chatWithSecondUserTapped() {
        navigateToChat(userId:"2")
    }
    
    private func navigateToChat(#userId:String) {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":userId],
            navigationController:navigationController!).go()
    }

}

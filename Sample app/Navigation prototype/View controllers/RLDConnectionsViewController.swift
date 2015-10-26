import UIKit

class RLDConnectionsViewController:UIViewController {

    @IBAction func chatWithFirstUserTapped() {
        navigateToChat(userId:"1")
    }
    
    @IBAction func chatWithSecondUserTapped() {
        navigateToChat(userId:"2")
    }
    
    private func navigateToChat(userId userId:String) {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":userId])
    }

}

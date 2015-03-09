import UIKit

class RLDFolderViewController:UIViewController {

    @IBAction func profileOfFirstUserTapped() {
        navigateToProfile(userId:"1")
    }
    
    @IBAction func profileOfSecondUserTapped() {
        navigateToProfile(userId:"2")
    }
    
    private func navigateToProfile(#userId:String) {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDProfileViewController",
            properties:["userId":userId],
            navigationController:navigationController!).go()
    }
    
}

import RLDNavigationSwift
import UIKit

class RLDMenuViewController:UIViewController {
    
    @IBAction func peopleNearbyTapped() {
        self.goTo("NavigationPrototype.RLDFolderViewController")
    }
    
    @IBAction func connectionsTapped() {
        self.goTo("NavigationPrototype.RLDConnectionsViewController")
    }
    
    @IBAction func chatTapped() {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":"1"])
    }
    
    @IBAction func chatFromProfileTapped() {
        self.goTo("NavigationPrototype.RLDChatViewController",
            properties:["userId":"1"],
            breadcrumbs:["NavigationPrototype.RLDProfileViewController"])
    }
    
    @IBAction func profileTapped() {
        RLDNavigationSetup(
            url:"folder/profile?userId=2",
            navigationController:navigationController!).go()
    }
    
    @IBAction func contactCardTapped() {
        let viewModel = RLDContactCardViewModel(name:"John", surname:"Doe", email:"john.doe@example.com")
        RLDNavigationSetup(
            viewModel:viewModel,
            navigationController:navigationController!).go()
    }
    
}
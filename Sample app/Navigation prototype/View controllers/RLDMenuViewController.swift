import UIKit
import Foundation

class RLDMenuViewController:UIViewController {
    
    @IBAction func peopleNearbyTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDFolderViewController",
            navigationController:navigationController!).go()
    }
    
    @IBAction func connectionsTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDConnectionsViewController",
            navigationController:navigationController!).go()
    }
    
    @IBAction func chatTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":"1"],
            navigationController:navigationController!).go()
    }
    
    @IBAction func chatFromProfileTapped() {
        RLDNavigationSetup(
            destination:"NavigationPrototype.RLDChatViewController",
            properties:["userId":"1"],
            breadcrumbs:["NavigationPrototype.RLDProfileViewController"],
            navigationController:navigationController!).go()
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
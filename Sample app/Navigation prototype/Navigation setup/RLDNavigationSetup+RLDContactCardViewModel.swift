import UIKit

extension RLDNavigationSetup {
    init(viewModel:RLDContactCardViewModel, navigationController:UINavigationController) {
        self.init(origin:NSStringFromClass(navigationController.topViewController!.dynamicType),
            destination:"NavigationPrototype.RLDContactCardViewController",
            properties:["viewModel":viewModel],
            breadcrumbs:nil,
            navigationController:navigationController)
    }
}
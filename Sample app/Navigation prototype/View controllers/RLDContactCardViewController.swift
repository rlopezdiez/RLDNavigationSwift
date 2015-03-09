import UIKit

class RLDContactCardViewController:UIViewController {

    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var surname:UILabel!
    @IBOutlet weak var email:UILabel!
    
    var viewModel:RLDContactCardViewModel? {
        didSet {
            name.text = viewModel?.name ?? ""
            surname.text = viewModel?.surname ?? ""
            email.text = viewModel?.email ?? ""
        }
    }

}

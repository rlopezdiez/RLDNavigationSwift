import UIKit

class RLDContactCardViewModel {
    
    var name:String?
    var surname:String?
    var email:String?
    
    init(name:String?, surname:String?, email:String?) {
        self.name = name
        self.surname = surname
        self.email = email
    }
}
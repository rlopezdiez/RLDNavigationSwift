import Foundation

class RLDNavigationCommandRegistrar {
    
    static var onceToken: dispatch_once_t = 0
    
    class func registerAvailableNavigationCommands() {
        dispatch_once(&onceToken) {
            RLDMenuNavigationCommand.registerCommandClass()
            RLDFolderNavigationCommand.registerCommandClass()
            RLDConnectionsNavigationCommand.registerCommandClass()
            RLDProfileNavigationCommand.registerCommandClass()
            RLDChatNavigationCommand.registerCommandClass()
            RLDContactCardViewModelNavigationCommand.registerCommandClass()
        }
    }
}
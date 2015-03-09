import Foundation
import QuartzCore

class RLDDirectNavigationCommand:RLDNavigationCommand {
    
    private lazy var navigationCommandClassChain:[String] = { [unowned self] in
        return self.navigationCommandClassChainWithNavigationSetup(self.navigationSetup, availableCommandsClasses:self.availableCommandClasses)
        }()
    
    override func execute() {
        
        if count(availableCommandClasses) == 0 {
            return
        }
        
        for navigationCommandClass in navigationCommandClassChain {

            if let navigationCommandType = NSClassFromString(navigationCommandClass) as? RLDNavigationCommand.Type {
                navigationSetup.destination = navigationCommandType.destination!
                let navigationCommand = navigationCommandType(navigationSetup:navigationSetup)! as RLDNavigationCommand
                executeSynchronously(animationClosure:{ () -> Void in
                    navigationCommand.execute()
                })
            } else {
                break
            }

            navigationSetup.origin = navigationSetup.destination
        }
        
    }
    
    private func executeSynchronously(#animationClosure:() -> Void) {
        var finished = false
        CATransaction.begin()
        CATransaction.setCompletionBlock { () -> Void in
            finished = true
        }
        
        animationClosure()
        
        CATransaction.commit()
        
        do {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:0.01))
        } while finished == false
    }
    
}
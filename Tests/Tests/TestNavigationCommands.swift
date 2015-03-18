import Foundation

let viewControllerClassNames = [
    "Tests.RLDFirstViewController",
    "Tests.RLDSecondViewController",
    "Tests.RLDThirdViewController",
    "Tests.RLDFourthViewController",
    "Tests.RLDFifthViewController"]

class RLDTestNavigationCommand:RLDPushPopNavigationCommand {
    
    static var executedCommandClasses:[String] = []
    
    override class var animatesTransitions:Bool {
        return false
    }
    
    override func execute() {
        super.execute()
        self.dynamicType.executedCommandClasses.append(NSStringFromClass(self.dynamicType))
    }
    
    class func clearExecutionRegistry() {
        executedCommandClasses = []
    }
    
    class func executed() -> Bool {
        return contains(self.executedCommandClasses, NSStringFromClass(self))
    }

    class func hasExecutionOrder(comparisonArray:[String]) -> Bool {
        return executedCommandClasses == comparisonArray
    }

}

class RLDNavigationCommandToFirstViewController:RLDTestNavigationCommand {
    
    override class var destination:String? {
        return viewControllerClassNames[0]
    }
    
}

class RLDNavigationCommandFromFirstToSecondViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[0]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[1]
    }
    
}

class RLDNavigationCommandFromFirstToThirdViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[0]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[2]
    }
    
}

class RLDNavigationCommandToSecondViewController:RLDTestNavigationCommand {
    
    override class var destination:String? {
        return viewControllerClassNames[1]
    }
    
}

class RLDNavigationCommandFromSecondToThirdViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[1]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[2]
    }
    
}

class RLDNavigationCommandToThirdViewController:RLDTestNavigationCommand {
    
    override class var destination:String? {
        return viewControllerClassNames[2]
    }
    
}

class RLDNavigationCommandFromThirdToFourthViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[2]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[3]
    }
    
}

class RLDNavigationCommandFromThirdToFifthViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[2]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[4]
    }
    
}

class RLDNavigationCommandToFourthViewController:RLDTestNavigationCommand {
    
    override class var destination:String? {
        return viewControllerClassNames[3]
    }
    
}

class RLDNavigationCommandFromFourthToFifthViewController:RLDTestNavigationCommand {
    
    override class var origins:[String]? {
        return [viewControllerClassNames[3]]
    }
    
    override class var destination:String? {
        return viewControllerClassNames[4]
    }
    
}


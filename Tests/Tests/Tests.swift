import UIKit
import XCTest

class TestsTests: XCTestCase {
    
    let navigationController:RLDCountingNavigationController = RLDCountingNavigationController()
    
    override func tearDown() {
        RLDTestNavigationCommand.clearExecutionRegistry()
        RLDNavigationCommand.clearRegisteredCommandClasses()
        super.tearDown()
    }
    
    // MARK: Helper functions
    
    func synchronousGoTo(#destination:String) {
        synchronousGoTo(destination:destination, properties:nil, breadcrumbs:nil)
    }
    
    func synchronousGoTo(#destination:String, breadcrumbs:[String]?) {
        synchronousGoTo(destination:destination, properties:nil, breadcrumbs:breadcrumbs)
    }
    
    func synchronousGoTo(#destination:String, properties:[String:AnyObject]?) {
        synchronousGoTo(destination:destination, properties:properties, breadcrumbs:nil)
    }
    
    func synchronousGoTo(#destination:String, properties:[String:AnyObject]?, breadcrumbs:[String]?) {
        RLDNavigationSetup(
            destination:destination,
            properties:properties,
            breadcrumbs:breadcrumbs,
            navigationController:navigationController).go()
        NSRunLoop.waitFor({ () -> Bool in
            return self.navigationController.topViewControllerClassName() == destination
            }, withTimeout:0.2)
    }
    
    // MARK: General navigation test cases
    
    func testDirectNavigation() {
        // GIVEN:
        //   Two view controller classes (1, 2)
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   a navigation command between the two classes (1 > 2)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 2nd view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[1])
        
        // THEN:
        //   The class chain must be 1 > 2
        //   the navigation command has been executed
        //   the navigation controller has pushed once, without any pop
        let expectedClassChain = [viewControllerClassNames[0], viewControllerClassNames[1]]
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 1)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testNavigationConservation() {
        // GIVEN:
        //   Two view controller classes (1, 2)
        //   a navigation controller with the class chain 1 > 2
        //   a navigation command (1 > 2)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1]]
        navigationController.setClassChain(expectedClassChain)
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 2nd view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[1])
        
        // THEN:
        //   The class chain will be 1 > 2
        //   the navigation comands hasn't been executed
        //   the navigation controller hasn't pushed nor popped
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertFalse(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 0)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testPopToPrevious() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   a navigation controller with the class chain 1 > 2 > 3
        //   one navigation commands (1 > 2)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 2nd view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[1])
        
        // THEN:
        //   the class chain will be 1 > 2
        //   the navigation command has been executed
        //   the navigation controller has popped once, without any push
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1]]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 0)
        XCTAssertEqual(navigationController.popCount, 1)
    }
    
    // MARK: Path searching test cases
    
    func testForwardPathSearching() {
        // GIVEN:
        //   Five view controller classes (1, 2, 3, 4, 5)
        //   a navigation controller with the class chain 1 > 2 > 3
        //   two navigation commands (3 > 4), (4 > 5)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        UIViewController.registerSubclassWithName(viewControllerClassNames[3])
        UIViewController.registerSubclassWithName(viewControllerClassNames[4])
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]])
        
        RLDNavigationCommandFromThirdToFourthViewController.registerCommandClass()
        RLDNavigationCommandFromFourthToFifthViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 5th view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[4])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3 > 4 > 5
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2],
            viewControllerClassNames[3],
            viewControllerClassNames[4]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromThirdToFourthViewController",
            "Tests.RLDNavigationCommandFromFourthToFifthViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testPopBeforePathSearching() {
        // GIVEN:
        //   Four view controller classes (1, 2, 3, 4)
        //   a navigation controller with the class chain 1 > 4
        //   three navigation commands (*, 1), (1 > 2), (2 > 3)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        UIViewController.registerSubclassWithName(viewControllerClassNames[3])
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[4]])
        
        RLDNavigationCommandToFirstViewController.registerCommandClass()
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 3rd view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[2])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3 > 4
        //   the navigation commands have been executed 1 > 2 > 3
        //   the navigation controller has pushed twice, popped once
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandToFirstViewController",
            "Tests.RLDNavigationCommandFromFirstToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 1)
    }
    
    func testBestRouteFinding() {
        // GIVEN:
        //   Five view controller classes (1, 2, 3, 4, 5)
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (1 > 3), (3 > 5)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        UIViewController.registerSubclassWithName(viewControllerClassNames[3])
        UIViewController.registerSubclassWithName(viewControllerClassNames[4])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        RLDNavigationCommandFromThirdToFourthViewController.registerCommandClass()
        RLDNavigationCommandFromFourthToFifthViewController.registerCommandClass()
        RLDNavigationCommandFromFirstToThirdViewController.registerCommandClass()
        RLDNavigationCommandFromThirdToFifthViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 5th view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[4])
        
        // THEN:
        //   The class chain will be 1 > 3 > 5
        //   the 5th and 6th navigation commands have been executed 5 > 6
        //   the navigation commands from 1st to 4th haven't been executed
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[2],
            viewControllerClassNames[4]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromFirstToThirdViewController",
            "Tests.RLDNavigationCommandFromThirdToFifthViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertFalse(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromSecondToThirdViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromThirdToFourthViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromFourthToFifthViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    // MARK: Wildcard origings test cases
    
    func testWildcardOriginsPathSearching() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   two navigation commands (* > 2), (2 > 3)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 3rd view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(destination:viewControllerClassNames[2])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testWildcardOriginsBestRouteFinding() {
        // GIVEN:
        //   Five view controller classes (1, 2, 3, 4, 5)
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (* > 3), (* > 4)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        UIViewController.registerSubclassWithName(viewControllerClassNames[3])
        UIViewController.registerSubclassWithName(viewControllerClassNames[4])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        RLDNavigationCommandFromThirdToFourthViewController.registerCommandClass()
        RLDNavigationCommandFromFourthToFifthViewController.registerCommandClass()
        RLDNavigationCommandToThirdViewController.registerCommandClass()
        RLDNavigationCommandToFourthViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 5th view controller class
        //   and we execute it
        synchronousGoTo(destination:viewControllerClassNames[4])
        
        // THEN:
        //   The class chain will be 1 > 4 > 5
        //   the 4th and 6th navigation commands have been executed 6 > 4
        //   the 1st, 2nd, 3rd, 5th navigation commands haven't been executed
        //   the navigation controller has pushed twice, without any pop
        //   and we wait until the execution finishes
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[3],
            viewControllerClassNames[4]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandToFourthViewController",
            "Tests.RLDNavigationCommandFromFourthToFifthViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertFalse(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromSecondToThirdViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromThirdToFourthViewController.executed())
        XCTAssertFalse(RLDNavigationCommandToThirdViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    // MARK: Breadcrumbs test cases
    
    func testBreadcrumbNavigation() {
        // GIVEN:
        //   Five view controller classes (1, 2, 3, 4, 5)
        //   a navigation controller with an instance of the first as the root view controller
        //   six navigation commands (1 > 2), (2 > 3), (3 > 4), (4, 5), (1 > 3), (3 > 5)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        UIViewController.registerSubclassWithName(viewControllerClassNames[3])
        UIViewController.registerSubclassWithName(viewControllerClassNames[4])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        RLDNavigationCommandFromThirdToFourthViewController.registerCommandClass()
        RLDNavigationCommandFromFourthToFifthViewController.registerCommandClass()
        RLDNavigationCommandFromFirstToThirdViewController.registerCommandClass()
        RLDNavigationCommandFromThirdToFifthViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the fifth view controller class
        //   passing by the second and fourth view controllers classes
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(
            destination:viewControllerClassNames[4],
            breadcrumbs:[viewControllerClassNames[1], viewControllerClassNames[3]])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3 > 4 > 5
        //   the navigation commands from 1st to 4th have been executed 1 > 2 > 3 > 4
        //   the 5th and 6th navigation commands haven't been executed
        //   the navigation controller has pushed four times, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2],
            viewControllerClassNames[3],
            viewControllerClassNames[4]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromFirstToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController",
            "Tests.RLDNavigationCommandFromThirdToFourthViewController",
            "Tests.RLDNavigationCommandFromFourthToFifthViewController"]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertFalse(RLDNavigationCommandFromFirstToThirdViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromThirdToFifthViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 4)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testBreadcrumbNavigationConservation() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   a navigation controller with the class chain 1 > 2 > 3
        //   three navigation commands (*, 1), (1 > 2), (2 > 3)
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]])
        
        RLDNavigationCommandToFirstViewController.registerCommandClass()
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the third view controller class
        //   passing by the second view controller class
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(
            destination:viewControllerClassNames[2],
            breadcrumbs:[viewControllerClassNames[1]])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3
        //   the navigation comands haven't been executed
        //   the navigation controller hasn't pushed nor popped
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertFalse(RLDNavigationCommandToFirstViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromFirstToSecondViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromSecondToThirdViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 0)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    // MARK: Property propagation test cases
    
    func testPropertyPropagation() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   the 2nd and 3rd ones have a readwrite property
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   two navigation commands (1 > 2), (2 > 3)
        let propertyName = "propertyName"
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1], readonlyProperties:nil, readwriteProperties:[propertyName])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2], readonlyProperties:nil, readwriteProperties:[propertyName])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 3rd view controller class
        //   propagating the readwrite property
        //   and we execute it
        //   and we wait until the execution finishes
        let propertyValue = "expectedValue"
        synchronousGoTo(
            destination:viewControllerClassNames[2],
            properties:[propertyName:propertyValue])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3
        //   the 2nd and 3rd view controllers in the navigation stack will have the propagated property set
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromFirstToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController"]
        
        let secondViewControllerHasPropertySet = navigationController.viewControllers[1].valueForKey(propertyName)!.isEqual(propertyValue)
        let thirdViewControllerHasPropertySet = navigationController.viewControllers[2].valueForKey(propertyName)!.isEqual(propertyValue)
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(secondViewControllerHasPropertySet)
        XCTAssertTrue(thirdViewControllerHasPropertySet)
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testReadonlyPropertyConservation() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   the 2nd one has a readonly property
        //   the 3rd one has a readwrite property with the same name
        //   two navigation commands (1 > 2), (2 > 3)
        let propertyName = "propertyName"
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1], readonlyProperties:[propertyName], readwriteProperties:nil)
        UIViewController.registerSubclassWithName(viewControllerClassNames[2], readonlyProperties:nil, readwriteProperties:[propertyName])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 3rd view controller class
        //   propagating a readwrite property
        //   and we execute it
        //   and we wait until the execution finishes
        let propertyValue = "expectedValue"
        synchronousGoTo(
            destination:viewControllerClassNames[2],
            properties:[propertyName:propertyValue])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3
        //   the 2nd view controller in the navigation stack won't have the propagated property set
        //   the 3rd one will
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromFirstToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController"]
        
        let secondViewControllerHasNotPropertySet = navigationController.viewControllers[1].valueForKey(propertyName) == nil
        let thirdViewControllerHasPropertySet = navigationController.viewControllers[2].valueForKey(propertyName)!.isEqual(propertyValue)
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(secondViewControllerHasNotPropertySet)
        XCTAssertTrue(thirdViewControllerHasPropertySet)
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testPropertySkipping() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   the 3rd one has a readwrite property
        //   a navigation controller with an instance of the 1st class as the root view controller
        //   two navigation commands (1 > 2), (2 > 3)
        let propertyName = "propertyName"
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2], readonlyProperties:nil, readwriteProperties:[propertyName])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 3rd view controller class
        //   propagating the readwrite property
        //   and we execute it
        //   and we wait until the execution finishes
        let propertyValue = "expectedValue"
        synchronousGoTo(
            destination:viewControllerClassNames[2],
            properties:[propertyName:propertyValue])
        
        // THEN:
        //   The class chain will be 1 > 2 > 3
        //   the 3rd view controller in the navigation stack will have the propagated property set
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has pushed twice, without any pop
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandFromFirstToSecondViewController",
            "Tests.RLDNavigationCommandFromSecondToThirdViewController"]
        
        let thirdViewControllerHasPropertySet = navigationController.viewControllers[2].valueForKey(propertyName)!.isEqual(propertyValue)
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(thirdViewControllerHasPropertySet)
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertEqual(navigationController.pushCount, 2)
        XCTAssertEqual(navigationController.popCount, 0)
    }
    
    func testPopToPreviousConsideringProperties() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   a navigation controller with the class chain 1 > 2 > 3
        //   with the 2nd navigation controller having a property set
        //   two navigation commands (* > 1), (1 > 2)
        let propertyName = "propertyName"
        let propertyValue = "expectedValue"
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1], readonlyProperties:nil, readwriteProperties:[propertyName])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]])
        
        navigationController.viewControllers[1].setValue(propertyValue, forKey:propertyName)
        
        RLDNavigationCommandToFirstViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 2nd view controller class
        //   with the property set to the expected value
        //   and we execute it
        //   and we wait until the execution finishes
        synchronousGoTo(
            destination:viewControllerClassNames[1],
            properties:[propertyName:propertyValue])
        
        // THEN:
        //   the class chain will be 1 > 2
        //   the 2nd view controller in the navigation chain has its property set
        //   the 1st navigation command hasn't been executed
        //   the 2nd navigation command has been executed
        //   the navigation controller has popped once, without any push
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1]]
        
        let thirdViewControllerHasPropertySet = navigationController.viewControllers[1].valueForKey(propertyName)!.isEqual(propertyValue)
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(thirdViewControllerHasPropertySet)
        XCTAssertFalse(RLDNavigationCommandToFirstViewController.executed())
        XCTAssertFalse(RLDNavigationCommandFromSecondToThirdViewController.executed())
        XCTAssertEqual(navigationController.pushCount, 0)
        XCTAssertEqual(navigationController.popCount, 1)
    }
    
    func testDiscardPopToPreviousConsideringProperties() {
        // GIVEN:
        //   Three view controller classes (1, 2, 3)
        //   a navigation controller with the class chain 1 > 2 > 3
        //   with the 2nd navigation controller having a property set
        //   two navigation commands (* > 1), (1 > 2)
        let propertyName = "propertyName"
        UIViewController.registerSubclassWithName(viewControllerClassNames[0])
        UIViewController.registerSubclassWithName(viewControllerClassNames[1], readonlyProperties:nil, readwriteProperties:[propertyName])
        UIViewController.registerSubclassWithName(viewControllerClassNames[2])
        
        navigationController.setRootViewControllerWithClassName(viewControllerClassNames[0])
        
        RLDNavigationCommandToFirstViewController.registerCommandClass()
        RLDNavigationCommandFromFirstToSecondViewController.registerCommandClass()
        
        navigationController.setClassChain([
            viewControllerClassNames[0],
            viewControllerClassNames[1],
            viewControllerClassNames[2]])
        
        let propertyValue = "propertyValue"
        navigationController.viewControllers[1].setValue(propertyValue, forKey:propertyName)
        
        RLDNavigationCommandToFirstViewController.registerCommandClass()
        RLDNavigationCommandFromSecondToThirdViewController.registerCommandClass()
        
        // WHEN:
        //   We create a set up asking to navigate to the 2nd view controller class
        //   with the property set to a different value
        //   and we execute it
        //   and we wait until the execution finishes
        let expectedValue = "expectedValue"
        synchronousGoTo(
            destination:viewControllerClassNames[1],
            properties:[propertyName:expectedValue])
        
        // THEN:
        //   the class chain will be 1 > 2
        //   the 2nd view controller in the navigation chain has its property set
        //   the navigation commands have been executed 1 > 2
        //   the navigation controller has popped once, pushed once
        let expectedClassChain = [
            viewControllerClassNames[0],
            viewControllerClassNames[1]]
        let expectedxecutionOrder = [
            "Tests.RLDNavigationCommandToFirstViewController",
            "Tests.RLDNavigationCommandFromFirstToSecondViewController"]
        
        let thirdViewControllerHasPropertySet = navigationController.viewControllers[1].valueForKey(propertyName)!.isEqual(expectedValue)
        
        XCTAssertTrue(navigationController.hasClassChain(expectedClassChain))
        XCTAssertTrue(RLDTestNavigationCommand.hasExecutionOrder(expectedxecutionOrder))
        XCTAssertTrue(thirdViewControllerHasPropertySet)
        XCTAssertEqual(navigationController.pushCount, 1)
        XCTAssertEqual(navigationController.popCount, 1)
    }
    
}

#import "TestHelpers.h"

#import <objc/runtime.h>

@implementation NSRunLoop (Waiting)

+ (void)waitFor:(BOOL(^)(void))conditionBlock withTimeout:(NSTimeInterval)seconds {
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    while (!conditionBlock() && [[NSDate date] compare:timeout] == NSOrderedAscending) {
        [[self currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    }
}

@end

@implementation NSObject (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name {
    return [self registerSubclassWithName:name
                       readonlyProperties:nil
                      readwriteProperties:nil];
}

+ (Class)registerSubclassWithName:(NSString *)name
               readonlyProperties:(NSArray *)readonlyPropertyNames
              readwriteProperties:(NSArray *)readwritePropertyNames {
    Class newClass = objc_getClass([name UTF8String]);
    if (newClass) objc_disposeClassPair(newClass);
    
    newClass = objc_allocateClassPair(self, [name UTF8String], 0);
    
    for (NSString *readonlyPropertyName in readonlyPropertyNames) {
        [newClass addPropertyWithName:readonlyPropertyName readonly:YES];
    }
    
    for (NSString *readwritePropertyName in readwritePropertyNames) {
        [newClass addPropertyWithName:readwritePropertyName readonly:NO];
    }
    
    objc_registerClassPair(newClass);
    
    return newClass;
}

+ (void)addPropertyWithName:(NSString *)name readonly:(BOOL)isReadonly {
    const char *propertyName = [name UTF8String];
    
    class_addIvar(self, propertyName, sizeof(id), log2(sizeof(id)), @encode(id));
    
    objc_property_attribute_t type = {"T", "@"};
    objc_property_attribute_t retainOwnership = {"&", ""};
    objc_property_attribute_t ivar  = {"V", propertyName};
    objc_property_attribute_t readonly = {"R", ""};
    objc_property_attribute_t propertyAttributes[] = {type, retainOwnership, ivar, readonly};
    
    class_addProperty(self, propertyName, propertyAttributes, (isReadonly ? 4 : 3));
}

@end

@interface NSArray (ContentsComparison)

- (BOOL)compareClassArrayContentsWith:(NSArray *)comparisonAray;

@end

@implementation NSArray (ContentsComparison)

- (BOOL)compareClassArrayContentsWith:(NSArray *)comparisonAray {
    if ([comparisonAray count] != [self count]) return NO;
    
    __block BOOL hasSameContents = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (![NSStringFromClass([obj class]) isEqualToString:comparisonAray[idx]]) {
            hasSameContents = NO;
            *stop = YES;
        }
        
    }];
    return hasSameContents;
}

@end

@implementation UINavigationController (TestingHelpers)

- (void)setRootViewControllerWithClassName:(NSString *)className {
    [self setClassChain:@[className]];
}

- (BOOL)hasClassChain:(NSArray *)classChain {
    return [self.viewControllers compareClassArrayContentsWith:classChain];
}

- (void)setClassChain:(NSArray *)classChain {
    [self setViewControllers:@[]];
    for (NSString *className in classChain) {
        Class class = NSClassFromString(className);
        UIViewController *viewController = [[class alloc] init];
        [self pushViewController:viewController animated:NO];
    }
}

- (NSString *)topViewControllerClassName {
    return NSStringFromClass([self.topViewController class]);
}

@end

@implementation RLDCountingNavigationController

- (instancetype)init {
    if (self = [super init]) {
        [self resetCounters];
    }
    return self;
}

- (void)resetCounters {
    _pushCount = 0;
    _popCount = 0;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _pushCount++;
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _popCount++;
    return [super popToViewController:viewController animated:animated];
}

- (void)setClassChain:(NSArray *)classChain {
    [super setClassChain:classChain];
    [self resetCounters];
}

@end
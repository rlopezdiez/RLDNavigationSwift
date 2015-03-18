#import <UIKit/UIKit.h>

@interface NSRunLoop (Waiting)

+ (void)waitFor:(BOOL(^)(void))conditionBlock withTimeout:(NSTimeInterval)seconds;

@end

@interface NSObject (TestingHelpers)

+ (Class)registerSubclassWithName:(NSString *)name;

+ (Class)registerSubclassWithName:(NSString *)name
               readonlyProperties:(NSArray *)readonlyPropertyNames
              readwriteProperties:(NSArray *)readwritePropertyNames;

@end

@interface UINavigationController (TestingHelpers)

- (void)setRootViewControllerWithClassName:(NSString *)className;
- (BOOL)hasClassChain:(NSArray *)classChain;
- (void)setClassChain:(NSArray *)classChain;
- (NSString *)topViewControllerClassName;

@end

@interface RLDCountingNavigationController : UINavigationController

@property (nonatomic, readonly) NSUInteger pushCount;
@property (nonatomic, readonly) NSUInteger popCount;

@end
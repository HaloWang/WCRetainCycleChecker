//
//  WCRetainCycleChecker.m
//  Pods
//
//  Created by 王策 on 16/5/5.
//
//

#import "WCRetainCycleChecker.h"
#import <objc/runtime.h>

static NSTimeInterval _WCRetainCycleCheckerCheckDelay = 4;

@implementation WCRetainCycleChecker

+ (void)setCheckDelay:(NSTimeInterval)delay {
    _WCRetainCycleCheckerCheckDelay = delay;
}

+ (void)whenRetainCheckedDo:(void (^)())doSomething {
    
}

@end

@interface UIViewController (RetainCycleChecker)

@end

@implementation UIViewController (RetainCycleChecker)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _swizzle_methods];
    });
}

+ (void)_swizzle_methods {
    Method m1 = class_getInstanceMethod(self, @selector(viewDidDisappear:));
    Method m2 = class_getInstanceMethod(self, @selector(_swizzled_viewDidDisappear:));
    method_exchangeImplementations(m1, m2);
}

- (void)_swizzled_viewDidDisappear:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_WCRetainCycleCheckerCheckDelay * NSEC_PER_SEC));
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_after(time, queue, ^{
        if (weakSelf == nil) {
            return;
        }
        
        BOOL useful = [weakSelf checkIfUseful];
        
        if (!useful) {
            [weakSelf rcc_crash];
        }
    });
    
    [self _swizzled_viewDidDisappear:animated];
}

- (BOOL)nextResponderChainHasAppDelegate {
    
    UIResponder *_nextResponder;
    _nextResponder = self.nextResponder;
    
    while (_nextResponder) {
        _nextResponder = _nextResponder.nextResponder;
        if ([_nextResponder conformsToProtocol:@protocol(UIApplicationDelegate)]) {
            return YES;
        }
    }
    
    return NO;
}

/// 检查是不是还有用
- (BOOL)checkIfUseful {
    BOOL inResponderChain            = [self nextResponderChainHasAppDelegate];
    BOOL hasNavigationController     = self.navigationController != nil;
    BOOL hasParent                   = self.parentViewController != nil;
    BOOL hasPresentingViewController = self.presentingViewController != nil;
    BOOL isUIKitClass                = [[NSString stringWithFormat:@"%s", class_getName([self class])] hasPrefix:@"UI"];
    BOOL isPrivateClass              = [[NSString stringWithFormat:@"%s", class_getName([self class])] hasPrefix:@"_"];
    
    return inResponderChain || hasNavigationController || hasParent || hasPresentingViewController || isUIKitClass || isPrivateClass;
}

/// 崩溃
- (void)rcc_crash {
#if DEBUG
    NSString *logStr = [NSString stringWithFormat:@"若该方法被调用，说明 %@ 秒后该 ViewController：%s 依然未被释放！", @(_WCRetainCycleCheckerCheckDelay),  class_getName([self class])];
    NSLog(@"❌%@", logStr);
#endif
}

@end


//
//  WCRetainCycleChecker.m
//  Pods
//
//  Created by WangCe on 20/02/2017.
//
//

#import "WCRetainCycleChecker.h"
#import <objc/runtime.h>

static NSTimeInterval _rcc_checkDelay = 4;
static void (^_rcc_callback)(UIViewController *);
static BOOL _rcc_showDefaultWarning = YES;

@implementation WCRetainCycleChecker

+ (void)setCheckDelay:(NSTimeInterval)delay {
    _rcc_checkDelay = delay;
}

+ (NSTimeInterval)checkDelay {
    return _rcc_checkDelay;
}

+ (void)retainCycleFound:(void (^)(UIViewController *))callback {
    _rcc_callback = callback;
}

+ (void)_invokeCallback:(UIViewController *)viewController {
    if (_rcc_callback != nil) {
        _rcc_callback(viewController);
    }
}

+ (void)shouldDefaultWarning:(BOOL)showWarning {
    _rcc_showDefaultWarning = showWarning;
}

@end

@implementation UIViewController (RetainCycleChecker)

+ (void)load {
    static dispatch_once_t _rcc_onceToken;
    dispatch_once(&_rcc_onceToken, ^{
        [self _rcc_swizzle_methods];
    });
}

+ (void)_rcc_swizzle_methods {
    Method m1 = class_getInstanceMethod(self, @selector(viewDidDisappear:));
    Method m2 = class_getInstanceMethod(self, @selector(_rcc_swizzled_viewDidDisappear:));
    method_exchangeImplementations(m1, m2);
}

- (void)_rcc_swizzled_viewDidDisappear:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)([WCRetainCycleChecker checkDelay] * NSEC_PER_SEC));
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_after(time, queue, ^{
        if (weakSelf == nil) {
            return;
        }
        
        BOOL useful = [weakSelf _rcc_is_useful_vc];
        
        if (!useful) {
            [weakSelf _rcc_warning];
        }
    });
    
    [self _rcc_swizzled_viewDidDisappear:animated];
}

- (BOOL)_rcc_in_responder_chain_of_application {
    
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

- (BOOL)_rcc_is_useful_vc {
    BOOL inResponderChain            = [self _rcc_in_responder_chain_of_application];
    BOOL hasNavigationController     = self.navigationController != nil;
    BOOL hasParent                   = self.parentViewController != nil;
    BOOL hasPresentingViewController = self.presentingViewController != nil;
    BOOL isUIKitClass                = [[NSString stringWithFormat:@"%s", class_getName([self class])] hasPrefix:@"UI"];
    BOOL isPrivateClass              = [[NSString stringWithFormat:@"%s", class_getName([self class])] hasPrefix:@"_"];
    
    return inResponderChain || hasNavigationController || hasParent || hasPresentingViewController || isUIKitClass || isPrivateClass;
}

- (void)_rcc_warning {
    
    if (_rcc_showDefaultWarning) {
        NSString *logStr = [NSString stringWithFormat:@"Warning：%@ still in memory after `-viewDidDisappear` (%@s passed)", self, @([WCRetainCycleChecker checkDelay])];
        NSLog(@"%@", logStr);
    }
    
    [WCRetainCycleChecker _invokeCallback:self];
}

@end


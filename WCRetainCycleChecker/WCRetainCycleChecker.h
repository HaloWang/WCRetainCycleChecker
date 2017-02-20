//
//  WCUIViewControllerRetainCycleChecker.h
//  Pods
//
//  Created by 王策 on 16/5/5.
//
//

// TODO: ⚠️ Unfinish!

#import <UIKit/UIKit.h>

@interface WCUIViewControllerRetainCycleChecker : NSObject

/**
*  Set when to check retain cycle of UIViewController custom subclasses after a viewcontroller call viewDidDisappear:
*
*  @param delay delay, default is 4 seconds
*/
+ (void)setCheckDelay:(NSTimeInterval)delay;

+ (void)whenRetainCheckedDo:(void(^)())doSomething;

@end

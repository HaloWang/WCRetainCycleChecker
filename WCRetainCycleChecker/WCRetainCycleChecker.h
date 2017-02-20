//
//  WCRetainCycleChecker.h
//  Pods
//
//  Created by WangCe on 20/02/2017.
//
//

#import <UIKit/UIKit.h>

@interface WCRetainCycleChecker : NSObject

/**
 Set when to check retain cycle of UIViewController custom subclasses after a viewcontroller call viewDidDisappear:

 @param delay default is 4 seconds
 */
+ (void)setCheckDelay:(NSTimeInterval)delay;
+ (NSTimeInterval)checkDelay;


/**
 Show WCRetainCycleChecker's default warning
 */
+ (void)shouldDefaultWarning:(BOOL)showWarning;

/**
 Call when retain cycle is found in your UIViewController subclass.

 @param callback set this block for your custom action.
 */
+ (void)retainCycleFound:(void(^)(UIViewController *viewController))callback;

@end

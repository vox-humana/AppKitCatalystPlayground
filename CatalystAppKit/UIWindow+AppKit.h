// https://gist.github.com/steipete/30c33740bf0ebc34a0da897cba52fefe

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (AppKit)

#if TARGET_OS_UIKITFORMAC

/**
    Finds the NSWindow hosting the UIWindow.
    @note This is a hack. Iterates over all windows to find match. Might fail.
 */
@property (nonatomic, readonly, nullable) NSObject *nsWindow;

#endif

@end

NS_ASSUME_NONNULL_END

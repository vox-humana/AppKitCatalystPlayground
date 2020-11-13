// https://gist.github.com/steipete/30c33740bf0ebc34a0da897cba52fefe

#import "UIWindow+AppKit.h"
#define PSPDF_SILENCE_CALL_TO_UNKNOWN_SELECTOR(expression) _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") expression _Pragma("clang diagnostic pop")

@implementation UIWindow (AppKit)

#if TARGET_OS_UIKITFORMAC

- (nullable NSObject *)nsWindow {
    id delegate = [[NSClassFromString(@"NSApplication") sharedApplication] delegate];
    const SEL hostWinSEL = NSSelectorFromString([NSString stringWithFormat:@"_%@Window%@Window:", @"host", @"ForUI"]);
    @try {
        // There's also hostWindowForUIWindow 🤷‍♂️
        PSPDF_SILENCE_CALL_TO_UNKNOWN_SELECTOR(id nsWindow = [delegate performSelector:hostWinSEL withObject:self];)
            
        // macOS 11.0 changed this to return an UINSWindowProxy
        SEL attachedWin = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"attached", @"Window"]);
        if ([nsWindow respondsToSelector:attachedWin]) {
            nsWindow = [nsWindow valueForKey:NSStringFromSelector(attachedWin)];
        }
        
        return nsWindow;
    } @catch (...) {
        NSLog(@"Failed to get NSWindow for %@.", self);
    }
    return nil;
}

#endif

@end

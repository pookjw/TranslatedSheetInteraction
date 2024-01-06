//
//  TranslatedScrollToTop.m
//  MyApp
//
//  Created by Jinwoo Kim on 1/7/24.
//

#import "TranslatedScrollToTop.hpp"

namespace TranslatedScrollToTop {
const void *useTranslatedScrollToTopKey = &useTranslatedScrollToTopKey;

BOOL isEnabled(__kindof UIScrollView *scrollView) {
    id flag = objc_getAssociatedObject(scrollView, useTranslatedScrollToTopKey);
    if (![flag isKindOfClass:NSNumber.class]) {
        return NO;
    }
    
    return static_cast<NSNumber *>(flag).boolValue;
}

namespace _contentOffsetForScrollingToTop {
CGPoint (*original)(UIScrollView *, SEL);
CGPoint custom(UIScrollView *self, SEL _cmd) {
    if (!isEnabled(self)) {
        return original(self, _cmd);
    }
    
    CGAffineTransform transform = self.transform;
    
    if (CGAffineTransformIsIdentity(transform)) {
        return original(self, _cmd);
    }
    
    CGPoint result = original(self, _cmd);
    
    CGPoint transformedResult = CGPointApplyAffineTransform(result, transform);
    CGSize transformedContentSize = CGSizeApplyAffineTransform(self.contentSize, transform);
    CGRect transformedBounds = CGRectApplyAffineTransform(self.bounds, transform);
    
    transformedResult.y -= transformedContentSize.height + transformedBounds.size.height;
    
    return transformedResult;
}

void swizzle() {
    Method method = class_getInstanceMethod(UIScrollView.class, NSSelectorFromString(@"_contentOffsetForScrollingToTop"));
    
    original = reinterpret_cast<CGPoint (*)(UIScrollView *, SEL)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}

void swizzle() {
    _contentOffsetForScrollingToTop::swizzle();
}
}

@interface UIScrollView (MA_Load)
@end

@implementation UIScrollView (MA_Load)

+ (void)load {
    TranslatedScrollToTop::swizzle();
}

@end


//
//  TranslatedSheetInteraction.mm
//  MyApp
//
//  Created by Jinwoo Kim on 1/6/24.
//

#import "TranslatedSheetInteraction.hpp"

namespace TranslatedSheetInteraction {
    const void *useTranslatedSheetInteractionKey = &useTranslatedSheetInteractionKey;

BOOL isEnabled(__kindof UIScrollView *scrollView) {
    id flag = objc_getAssociatedObject(scrollView, useTranslatedSheetInteractionKey);
    if (![flag isKindOfClass:NSNumber.class]) {
        return NO;
    }
    
    return static_cast<NSNumber *>(flag).boolValue;
}
    
//    namespace _shouldInteractWithDescendentScrollView_startOffset_maxTopOffset {
//        BOOL (*original)(id, SEL, UIScrollView *, CGPoint, CGFloat);
//        BOOL custom(id self, SEL _cmd, UIScrollView *scrollView, CGPoint startOffset, CGFloat maxTopOffset) {
//            if (!isEnabled(scrollView)) {
//                return original(self, _cmd, scrollView, startOffset, maxTopOffset);
//            }
//            
//            CGAffineTransform transform = scrollView.transform;
//            
//            if (CGAffineTransformIsIdentity(transform)) {
//                return original(self, _cmd, scrollView, startOffset, maxTopOffset);
//            }
//            
//            CGPoint transformedOffset = CGPointApplyAffineTransform(startOffset, transform);
//            CGSize transformedContentSize = CGSizeApplyAffineTransform(scrollView.contentSize, transform);
//            CGRect transformedBounds = CGRectApplyAffineTransform(scrollView.bounds, transform);
//            
//            transformedOffset.y -= transformedContentSize.height + transformedBounds.size.height;
//            
//            BOOL result = original(self, _cmd, scrollView, transformedOffset, maxTopOffset);
//            
////            NSLog(@"%@ %d", NSStringFromCGPoint(transformedOffset), result);
//            
//            return result;
//        }
//        
//        void swizzle() {
//            Method method = class_getInstanceMethod(NSClassFromString(@"_UISheetInteraction"), NSSelectorFromString(@"_shouldInteractWithDescendentScrollView:startOffset:maxTopOffset:"));
//            
//            original = reinterpret_cast<BOOL (*)(id, SEL, UIScrollView *, CGPoint, CGFloat)>(method_getImplementation(method));
//            method_setImplementation(method, reinterpret_cast<IMP>(custom));
//        }
//    }

namespace _scrollView_adjustedUnconstrainedOffsetForUnconstrainedOffset_startOffset_horizontalVelocity_verticalVelocity_animator {
CGPoint (*original)(id, SEL, __kindof UIScrollView *, CGPoint, CGPoint, CGFloat *, CGFloat *, UIViewPropertyAnimator **);
CGPoint custom(id self, SEL _cmd, __kindof UIScrollView *scrollView, CGPoint unconstrainedOffset, CGPoint startOffset, CGFloat *horizontalVelocity, CGFloat *verticalVelocity, UIViewPropertyAnimator **animator) {
    if (!isEnabled(scrollView)) {
        return original(self, _cmd, scrollView, unconstrainedOffset, startOffset, horizontalVelocity, verticalVelocity, animator);
    }
    
    CGAffineTransform transform = scrollView.transform;
    
    if (CGAffineTransformIsIdentity(transform)) {
        return original(self, _cmd, scrollView, unconstrainedOffset, startOffset, horizontalVelocity, verticalVelocity, animator);
    }
    
    CGPoint transformedUnconstrainedOffset = CGPointApplyAffineTransform(unconstrainedOffset, transform);
    CGPoint transformedStartOffset = CGPointApplyAffineTransform(startOffset, transform);
    CGSize transformedContentSize = CGSizeApplyAffineTransform(scrollView.contentSize, transform);
    CGRect transformedBounds = CGRectApplyAffineTransform(scrollView.bounds, transform);
    
    transformedUnconstrainedOffset.y -= transformedContentSize.height + transformedBounds.size.height;
    transformedStartOffset.y -= transformedContentSize.height + transformedBounds.size.height;
    
    CGPoint result = original(self, _cmd, scrollView, transformedUnconstrainedOffset, transformedStartOffset, horizontalVelocity, verticalVelocity, animator);
    
    CGAffineTransform invertedTransform = CGAffineTransformInvert(transform);
    CGPoint invertedResult = CGPointApplyAffineTransform(result, invertedTransform);
    
    invertedResult.y -= transformedContentSize.height + transformedBounds.size.height;
          
    return invertedResult;
}

void swizzle() {
    Method method = class_getInstanceMethod(NSClassFromString(@"_UISheetInteraction"), NSSelectorFromString(@"_scrollView:adjustedUnconstrainedOffsetForUnconstrainedOffset:startOffset:horizontalVelocity:verticalVelocity:animator:"));
    
    original = reinterpret_cast<CGPoint (*)(id, SEL, __kindof UIScrollView *, CGPoint, CGPoint, CGFloat *, CGFloat *, UIViewPropertyAnimator **)>(method_getImplementation(method));
    method_setImplementation(method, reinterpret_cast<IMP>(custom));
}
}
    
    void swizzle() {
//        _shouldInteractWithDescendentScrollView_startOffset_maxTopOffset::swizzle();
        _scrollView_adjustedUnconstrainedOffsetForUnconstrainedOffset_startOffset_horizontalVelocity_verticalVelocity_animator::swizzle();
    }
}

@interface UISheetPresentationController (MA_Load)
@end

@implementation UISheetPresentationController (MA_Load)

+ (void)load {
    TranslatedSheetInteraction::swizzle();
}

@end

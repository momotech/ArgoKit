//
//  ArgoKitLayoutHelper.m
//  ArgoKit
//
//  Created by Bruce on 2020/10/15.
//

#import "ArgoKitReusedLayoutHelper.h"
#import "ArgoKitNode.h"
#import "ArgoKitNodeViewModifier.h"
#import "ArgoKitLayoutEngine.h"
#import "ArgoKitNodePrivateHeader.h"
#import "ArgoKitUtils.h"
#import <os/lock.h>

@interface ArgoKitReusedLayoutHelper(){
    CFRunLoopObserverRef _observer;
}
@property(nonatomic,strong)ArgoKitLayoutEngine *layoutEngine;
@end


@implementation ArgoKitReusedLayoutHelper
static ArgoKitReusedLayoutHelper* _instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        [_instance startLayoutEngine];
    });
    return _instance;
}
-(void)dealloc{
    [self stopLayoutEngine];
}
- (ArgoKitLayoutEngine *)layoutEngine{
    if (!_layoutEngine) {
        _layoutEngine = [[ArgoKitLayoutEngine alloc]init];
    }
    return _layoutEngine;
}
+ (void)addLayoutNode:(ArgoKitNode *)node{
    [[ArgoKitReusedLayoutHelper sharedInstance] addLayoutNode:node];
}

+ (void)removeLayoutNode:(nullable ArgoKitNode *)node{
    [[ArgoKitReusedLayoutHelper sharedInstance] removeLayoutNode:node];
}

+ (void)appLayout:(ArgoKitNode *)node{
    [[ArgoKitReusedLayoutHelper sharedInstance] _layout:node];
}

+ (void)reLayoutNode:(nullable NSArray *)cellNodes frame:(CGRect)frame{
    [[ArgoKitReusedLayoutHelper sharedInstance].layoutEngine reLayoutNode:cellNodes frame:frame];
}
#pragma mark --- private methods ---
- (void)startLayoutEngine {
    __weak typeof(self)wealSelf = self;
    [self.layoutEngine startRunloop:kCFRunLoopBeforeWaiting repeats:true order:1 block:^(ArgoKitNode * _Nonnull node) {
        [wealSelf layout:node];
    }];
}
- (void)stopLayoutEngine{
    [self.layoutEngine stopRunloop];
}
- (void)addLayoutNode:(nullable ArgoKitNode *)node{
    [self.layoutEngine addLayoutNode:node];
}

- (void)removeLayoutNode:(nullable ArgoKitNode *)node{
    [self.layoutEngine removeLayoutNode:node];
}
- (void)layout:(ArgoKitNode *)node{ 
    if (node && node.isDirty) {
        [self _layout:node];
    }
}
- (void)_layout:(ArgoKitNode *)node{
    [node calculateLayoutWithSize:CGSizeMake(node.size.width, NAN)];
    [node applyLayoutAferCalculationWithView:NO];
    [ArgoKitNodeViewModifier resetNodeViewFrame:node];
}
@end
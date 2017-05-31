//
//  DesignedButton.m
//  JMSeller
//
//  Created by JM on 2017/5/19.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMDesignedButton.h"

@implementation JMDesignedButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    
    self.enlargedSize = 0;
    self.enlargedInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGRect)enlargedRect
{
    CGFloat topEdge = self.enlargedInset.top;
    CGFloat rightEdge = self.enlargedInset.right;
    CGFloat bottomEdge = self.enlargedInset.bottom;
    CGFloat leftEdge = self.enlargedInset.left;
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge,
                          self.bounds.origin.y - topEdge,
                          self.bounds.size.width + leftEdge + rightEdge,
                          self.bounds.size.height + topEdge + bottomEdge);
    }
    else
    {
        return self.bounds;
    }
}

- (void)setEnlargedSize:(CGFloat)enlargedSize {
    [self setEnlargeInsetWithEnlargeSize:enlargedSize];
}

- (void)setDesignedEnlargedSize:(CGFloat)designedEnlargedSize {
    [self setEnlargeInsetWithEnlargeSize:designedEnlargedSize];
}

- (void)setEnlargeInsetWithEnlargeSize:(CGFloat)enlargeSize {
    self.enlargedInset = UIEdgeInsetsMake(enlargeSize, enlargeSize, enlargeSize, enlargeSize);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}


@end

//
//  ColorSlider.m
//  SomeDemo
//
//  Created by Ivan Liu on 17/3/13.
//  Copyright © 2017年 Ivan Liu. All rights reserved.
//

#import "ColorSlider.h"

@implementation ColorSlider

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGFloat startX = 10;
    CGFloat lineWidth = 10;
    CGFloat stringHeight = 10;
    
    CGFloat eachWidth = (CGRectGetWidth(self.frame)-20)/4;
    
    CGFloat underStringX = startX;

    CGFloat lineYPosition = (CGRectGetHeight(self.frame)-lineWidth)/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 背景色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, self.frame);
    
    // 主体线
    if (!self.colors.count) {
        return;
    }
    for (NSInteger i = 0; i < self.colors.count; i++) {
        
        CGContextSetLineWidth(context, 10);
        CGContextBeginPath(context);
        CGContextSetStrokeColorWithColor(context, self.colors[i].CGColor);
        
        if (i == 0 || i == self.colors.count-1) {
            // 首尾为了保证单向圆角，细分为两段线画图
            CGContextSetLineCap(context, i==0?kCGLineCapRound:kCGLineCapSquare);
            CGContextMoveToPoint(context, startX+eachWidth*i, lineYPosition);
            CGContextAddLineToPoint(context, startX+eachWidth*(i+0.5), lineYPosition);
            CGContextStrokePath(context);
            CGContextSetLineCap(context, i!=0?kCGLineCapRound:kCGLineCapSquare);
            CGContextMoveToPoint(context, startX+eachWidth*(i+0.5), lineYPosition);
            CGContextAddLineToPoint(context, startX+eachWidth*(i+1)-lineWidth, lineYPosition);
            CGContextStrokePath(context);

        } else {
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextMoveToPoint(context, startX+eachWidth*i, lineYPosition);
            CGContextAddLineToPoint(context, startX+eachWidth*(i+1), lineYPosition);
            CGContextStrokePath(context);
        }
    }
    
    // 上下标签
    for (NSInteger i = 0; i < self.colors.count; i++) {
        
        CGContextSetLineWidth(context, 0.5);

        NSTextAlignment underStrAlignment = NSTextAlignmentLeft;
        if (i == 0 || i == self.colors.count-1) {
            // 调整字体位置
            if (i == self.colors.count-1) {
                underStrAlignment = NSTextAlignmentRight;
            } else {
                underStrAlignment = NSTextAlignmentLeft;
            }
        } else {
            underStrAlignment = NSTextAlignmentCenter;
        }
            
        if (self.stringLevels.count) {
            CGContextSetStrokeColorWithColor(context, self.colors[i].CGColor);
            underStringX = startX+eachWidth*i-lineWidth/2; // 由于线宽问题，每次需减去一半线宽
            NSMutableParagraphStyle *paragraf = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraf.alignment = underStrAlignment;
            CGRect stringRect = CGRectMake(underStringX, lineYPosition+lineWidth*1.2, eachWidth, stringHeight);
            [self.stringLevels[i] drawInRect:stringRect withAttributes:@{NSForegroundColorAttributeName:self.colors[i], NSFontAttributeName:[UIFont systemFontOfSize:8.0f], NSParagraphStyleAttributeName:paragraf}];
        }

        if (self.numLevels.count) {
            if (i == self.colors.count-1) break;
            CGContextSetStrokeColorWithColor(context, self.colors[i+1].CGColor);
            NSMutableParagraphStyle *upParagraf = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            upParagraf.alignment = NSTextAlignmentCenter;
            CGRect upString = CGRectMake(startX+eachWidth*(i+0.5)-lineWidth/2, lineYPosition-lineWidth*1.2-stringHeight, eachWidth, stringHeight);
            [self.numLevels[i] drawInRect:upString withAttributes:@{NSForegroundColorAttributeName:self.colors[i+1], NSFontAttributeName:[UIFont systemFontOfSize:8.0f], NSParagraphStyleAttributeName:upParagraf}];
        }

    }
    
    // 画点
    if (self.sliderValue > 0) {
        if (!self.numLevels.count) {
            return;
        }
        CGFloat maxValue = 0.0f;
        UIColor *pointColor = [UIColor clearColor];
        for (NSInteger i = 0; i < self.numLevels.count; i++) {

            NSString *string = [NSString stringWithFormat:@"%@", self.numLevels[i]];
            NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            CGFloat val =[[string stringByTrimmingCharactersInSet:nonDigits] floatValue];
            if (val >= self.sliderValue) {
                pointColor = self.colors[i];
            }
            if (i == self.numLevels.count-1) {
                maxValue = val/self.numLevels.count*(self.numLevels.count+1);
                if (self.sliderValue > val) {
                    pointColor = self.colors[i+1];
                }
            }
        }

        CGFloat pointDiameter = lineWidth*1.3;
        CGFloat ponitX = (startX+eachWidth*self.colors.count-lineWidth/2)*(self.sliderValue/maxValue);
        CGContextMoveToPoint(context, ponitX, lineYPosition);
        CGContextSetLineWidth(context, lineWidth/5);
        CGContextAddEllipseInRect(context, CGRectMake(ponitX-pointDiameter/2, lineYPosition-pointDiameter/2, pointDiameter, pointDiameter));
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, pointColor.CGColor);
        CGContextStrokePath(context);
        CGContextAddEllipseInRect(context, CGRectMake(ponitX-pointDiameter/2, lineYPosition-pointDiameter/2, pointDiameter, pointDiameter));
        CGContextFillPath(context);
    }
    
}




@end

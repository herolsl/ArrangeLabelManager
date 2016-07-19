//
//  ArrangeLabelManager.m
//  SomeDemo
//
//  Created by Sven Liu on 16/7/18.
//  Copyright © 2016年 Sven Liu. All rights reserved.
//

#import "ArrangeLabelManager.h"

#define SLRandom(n)                             arc4random() % (n);
#define SLLabelMinWidth                         60      // 标签最短长度
#define SLLabelHeight                           30      // 标签高度
#define SLLabelSpacingHorizontal                10      // 标签水平间距
#define SLLabelSpacingVertical                  10      // 标签垂直间距
#define SLLabelBoard                            10      // 标签与父试图边距
#define SLLabelInset                            10      // 标签内文本与标签边框距离

@interface ArrangeLabelManager ()

@property (nonatomic, copy) NSString *resultStr;

@end


@implementation ArrangeLabelManager

#pragma mark - 按长度随机瀑布式排列
//  按长度随机排列
- (void)layoutLabelsWithDataSource:(NSArray *)datasource superView:(UIView *)superView {

//- (void)sequenceWordsWithArray:(NSMutableArray *)arr {
    
    CGPoint startPoint = CGPointZero;
    startPoint = CGPointMake(SLLabelBoard, 80);
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:datasource];
    NSMutableArray *labelWidthArr = [NSMutableArray array];
    
    NSComparator comparator = ^(id obj1, id obj2) {
        if ([obj1 length] > [obj2 length]) {
            return NSOrderedDescending;
        } else if ([obj1 length] > [obj2 length]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    };
    [tempArr sortUsingComparator:comparator];
    
    for (NSInteger i = 0; i < tempArr.count; i++) {
        CGFloat len = [self lengthOfStringLabel:tempArr[i]];
        [labelWidthArr addObject:@(len)];
    }
    
    NSInteger itemsCount = datasource.count;
    NSInteger firstIndex = SLRandom(itemsCount);
    
    self.resultStr = [self newString:tempArr[firstIndex]];
    
    // 添加第一个标签
    UILabel *aLabel = [self getLabelWithString:tempArr[firstIndex]];
    [self resetLabel:aLabel startPoint:startPoint];
    [superView addSubview:aLabel];
    startPoint = CGPointMake(CGRectGetMaxX(aLabel.frame)+SLLabelSpacingHorizontal, CGRectGetMinY(aLabel.frame));
    
    
    [tempArr removeObjectAtIndex:firstIndex];
    [labelWidthArr removeObjectAtIndex:firstIndex];

    for (NSInteger i = 0; i < datasource.count*10; i++) {
        NSLog(@"数组个数：%@", @(tempArr.count));
        if (!tempArr.count) {
            return;
        }
        
        
        // 剩余位置
        CGFloat spacing = superView.frame.size.width-SLLabelBoard*2-startPoint.x;
        NSInteger itemsCo = tempArr.count;
        NSInteger randomNum = 0;
        
        // 匹配剩余位置，获取随机数
        for (NSInteger i = itemsCo-1; i>0; i--) {
            
            NSLog(@"空余位置：%@, 文本宽度：%@", @(spacing), labelWidthArr[i]);
            if ([labelWidthArr[i] floatValue] <= spacing) {
                randomNum = SLRandom(i);
                break;
            }
        }
//        NSInteger randomNum = SLRandom(itemsCo);
        NSLog(@"随机数：%@, 文本宽度：%@", @(randomNum), labelWidthArr[randomNum]);

        NSString *aRandomS = [self newString:tempArr[randomNum]];
        NSString *newRandomStr = [self.resultStr stringByAppendingString:aRandomS];
        
//        if ([self lengthOfStringLabel:newRandomStr] <= CGRectGetWidth(superView.frame)-20) {
        
        if (startPoint.x <= CGRectGetWidth(superView.frame)-SLLabelBoard*2) {

            self.resultStr = newRandomStr;
            //            NSLog(@"中间结果：\n%@", self.resultStr);
            
            
            UILabel *labe = [self getLabelWithString:tempArr[randomNum]];
            [self resetLabel:labe startPoint:startPoint];
            [superView addSubview:labe];
            startPoint = CGPointMake(CGRectGetMaxX(labe.frame)+SLLabelSpacingHorizontal, CGRectGetMinY(labe.frame));
            
            
            [tempArr removeObjectAtIndex:randomNum];
            [labelWidthArr removeObjectAtIndex:randomNum];

            if (!tempArr.count) {
                NSLog(@"最终结果：\n%@", self.resultStr);
                return;
            }
//            if (CGRectGetWidth(superView.frame)-20-[self lengthOfStringLabel:newRandomStr] >= [self lengthOfStringLabel:tempArr[0]]) {
            
            if ((CGRectGetWidth(superView.frame)-SLLabelBoard-startPoint.x) >= ([self getLabelWithString:tempArr[0]].frame.size.width+SLLabelBoard)) {
    
                continue;
            } else {
                self.resultStr = [newRandomStr stringByAppendingString:@"\n"];
                //                NSLog(@"中间结果：\n%@", self.resultStr);
                CGPoint point = CGPointMake(10, startPoint.y+SLLabelHeight+SLLabelSpacingVertical);
                startPoint = point;

                continue;
            }
        } else {

            self.resultStr = [self.resultStr stringByAppendingString:@"\n"];
            CGPoint point = CGPointMake(10, startPoint.y+SLLabelHeight+SLLabelSpacingVertical);
            startPoint = point;

            NSLog(@"中间结果：\n%@", self.resultStr);
            
            continue;
        }
    }
    
    
}

- (NSString *)newString:(NSString *)str {
    
    NSString *newStr = [NSString stringWithFormat:@"----%@----", str];
    return newStr;
}

- (CGFloat)lengthOfStringLabel:(NSString *)str {
    
    NSArray *strArr = [str componentsSeparatedByString:@"\n"];
    NSString *newStr = [strArr lastObject];
    CGRect strRect = [newStr boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), SLLabelHeight)
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                          context:nil];
    
    return CGRectGetWidth(strRect) + SLLabelInset*2;
}

- (UILabel *)getLabelWithString:(NSString *)string {
    
    CGFloat length = [self lengthOfStringLabel:string];
    length = (length >= SLLabelMinWidth ? length : SLLabelMinWidth);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, length, SLLabelHeight)];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 0.5f;
    return label;
}

- (void)resetLabel:(UILabel *)lab startPoint:(CGPoint)strat {
    
    [lab setFrame:CGRectMake(strat.x, strat.y, CGRectGetWidth(lab.frame), CGRectGetHeight(lab.frame))];
}

@end

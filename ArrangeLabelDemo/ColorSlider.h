//
//  ColorSlider.h
//  SomeDemo
//
//  Created by Ivan Liu on 17/3/13.
//  Copyright © 2017年 Ivan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSlider : UIView

// colors 数量等于 stringLevels， 比 numLevels 多一个
@property(nonatomic, copy) NSArray<UIColor *> *colors;
@property(nonatomic, copy) NSArray *numLevels;
@property(nonatomic, copy) NSArray *stringLevels;

@property(nonatomic) CGFloat sliderValue;

@end

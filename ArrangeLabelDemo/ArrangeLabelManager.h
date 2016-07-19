//
//  ArrangeLabelManager.h
//  SomeDemo
//
//  Created by Sven Liu on 16/7/18.
//  Copyright © 2016年 Sven Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ArrangeLabelManager : NSObject

- (void)layoutLabelsWithDataSource:(NSArray *)datasource superView:(UIView *)superView;

@end

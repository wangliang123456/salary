//
//  City.h
//  salary-calc
//
//  Created by Eric Wang on 16/5/24.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property(nonatomic,strong) NSString* ID;
@property(nonatomic,strong) NSString* cityName;
@property(nonatomic,strong) NSString* cityInitial;
@property(nonatomic,strong) NSString* formula;
@property(nonatomic) int isHot;
@end

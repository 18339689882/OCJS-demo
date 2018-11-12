//
//  NSObject+InvokeMoreMethods.h
//  OC调用JS
//
//  Created by 王泽 on 2017/8/8.
//  Copyright © 2017年 Huashankeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (InvokeMoreMethods)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;

@end

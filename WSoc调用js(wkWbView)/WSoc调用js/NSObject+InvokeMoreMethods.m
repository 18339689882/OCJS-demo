//
//  NSObject+InvokeMoreMethods.m
//  OC调用JS
//
//  Created by 王泽 on 2017/8/8.
//  Copyright © 2017年 Huashankeji. All rights reserved.
//

#import "NSObject+InvokeMoreMethods.h"

@implementation NSObject (InvokeMoreMethods)

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    // 生成一个方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    //如果方法签名没有生成成功就提示错误
    if (signature == nil)
    {
        [NSException raise:@"方法名传递有误" format:@"%@方法找不到", NSStringFromSelector(selector)];
    }
    
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    //设置参数，除self、_cmd以外的参数个数
    NSInteger paramsCount = signature.numberOfArguments - 2;
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++)
    {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]])
        {
            continue;
        }
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength)
    {
        // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    
    return returnValue;
}

@end

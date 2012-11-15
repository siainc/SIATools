//
//  TestClass.m
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/08/30.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import "TestClass.h"
#import "SIDescriptionBuilder.h"

NSString *NSStringFromTestStruct(TestStruct ts)
{
    return [NSString stringWithFormat:@"{num1=%d, num2=%d}", ts.num1, ts.num2];
}

/**
 * description出力テスト用クラス.
 */
@implementation TestClass

- (id)init
{
    self = [super init];
    if (self) {
        array = [[NSArray alloc] initWithObjects:@"a", @"b", nil];
        url = [NSURL URLWithString:@"http://www.foobar.com"];
        cls = [NSFileManager class];
        sel = @selector(method:arg1:arg2:);
        yesOrNo = YES;
        ucharv = 'A';
        intv = 11;
        uintv = 22;
        shortv = 33;
        ushortv = 44;
        longv = 55L;
        ulongv = 66LU;
        longlongv = 77LL;
        ulonglongv = 88LLU;
        floatv = 99.9f;
        doublev = 12.345f;
        boolv = false;
//        strncpy(psz, "abcdefg", 5);
        charpointer = "hijklmn";
        voidp = &url;
        integerv = 6789;
        uintegerv = 1234;
        rectv = CGRectMake(1, 2, 3, 4);
        sizev = CGSizeMake(5, 6);
        pointv = CGPointMake(7, 8);
        teststructv.num1 = 4444;
        teststructv.num2 = 8888;
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
        nsrectv = NSMakeRect(11, 22, 33, 44);
        nssizev = NSMakeSize(55, 66);
        nspointv = NSMakePoint(77, 88);
#endif
    }
    return self;
}

/**
 * descriptionメソッドをオーバーライドし、buildDescriptionが使われるように変更.
 */
- (NSString *)description
{
    return [[SIDescriptionBuilder defaultBuilder] buildDescription:self
                                                   customFormatter:^NSString *(void *p) {
                                                       if ((__unsafe_unretained id *)p == &array) {
                                                           return @"arraytest";
                                                       }
                                                       else if (p == &longv) {
                                                           return @"longvvvv";
                                                       }
                                                       return nil;
                                                   }];
}

@end

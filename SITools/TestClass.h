//
//  TestClass.h
//  SITools
//
//  Created by KUROSAKI Ryota on 2011/08/30.
//  Copyright (c) 2011 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct TestStruct {
    NSInteger num1;
    NSInteger num2;
} TestStruct;

NSString *NSStringFromTestStruct(TestStruct ts);

@interface TestClass : NSObject {
    NSArray *array;
    NSURL *url;
    Class cls;
    SEL sel;
    BOOL yesOrNo;
    unsigned char ucharv;
    int intv;
    unsigned int uintv;
    short shortv;
    unsigned short ushortv;
    long longv;
    unsigned ulongv;
    long long longlongv;
    unsigned long long ulonglongv;
    float floatv;
    double doublev;
    bool boolv;
//    char psz[100];
    char *charpointer;
    void *voidp;
    NSInteger integerv;
    NSUInteger uintegerv;
    CGRect rectv;
    CGSize sizev;
    CGPoint pointv;
    TestStruct teststructv;
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
    NSRect nsrectv;
    NSSize nssizev;
    NSPoint nspointv;
#endif
}

@property(nonatomic,retain) TestClass *testClass;

@end

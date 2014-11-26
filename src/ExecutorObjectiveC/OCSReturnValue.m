#import "OCSReturnValue.h"
#import "OCSObjectiveCtoCBridge.h"
#import "SlimListSerializer.h"

@implementation OCSReturnValue

+(NSString*) forInvocation:(NSInvocation*) invocation {
    if ([OCSReturnValue signatureHasReturnTypeVoid: invocation.methodSignature]) {
        return @"OK";
    } else {
        
        NSString* returnType = [NSString stringWithUTF8String: [invocation.methodSignature methodReturnType]];
        
        if ([returnType isEqualToString: @"@"]) {
            return [OCSReturnValue forObjectInvocation:invocation];
        } else {
            return [OCSReturnValue forPrimitiveInvocation:invocation withReturnType:returnType];
        }
    }
}

+ (NSString *)forObjectInvocation:(NSInvocation*) invocation {
    void *buffer;
    [invocation getReturnValue: &buffer];
    NSObject *object = (__bridge NSObject *)buffer;
    return [OCSReturnValue forObject:object];
}

+ (NSString *) forObject:(id)object {
    if([NSStringFromClass([object class]) isEqualToString: @"NSCFString"]) {
        return object;
    } else if([NSStringFromClass([object class]) isEqualToString: @"__NSCFString"]) {
        return object;
    } else if([NSStringFromClass([object class]) isEqualToString: @"__NSCFConstantString"]) {
        return object;
    } else if ([NSStringFromClass([object class]) isEqualToString:@"__NSArrayI"]) {
        return [OCSReturnValue forNSArray:object];
    } else if ([NSStringFromClass([object class]) isEqualToString:@"__NSCFBoolean"]) {
        return ((NSNumber *)object).boolValue ? @"true" : @"false";
    } else {
        return [object stringValue];
    }
}

+ (NSString *)forPrimitiveInvocation:(NSInvocation*) invocation withReturnType:(NSString*)returnType {
    void *primitive = malloc([invocation.methodSignature methodReturnLength]);
    [invocation getReturnValue:primitive];
    
    NSString *returnValue;
    if ([returnType isEqualToString: @"i"]) {
        returnValue = [NSString stringWithFormat: @"%i", *(int *)primitive];
    } else if ([returnType isEqualToString: @"c"]) {
        returnValue = (*(BOOL *)primitive) ? @"true" : @"false";
    } else {
        returnValue = @"OK";
    }
    
    free(primitive);
    return returnValue;
}

+(BOOL) signatureHasReturnTypeVoid:(NSMethodSignature*) methodSignature {
    return [[NSString stringWithUTF8String: [methodSignature methodReturnType]] isEqualToString: @"v"];
}

+ (NSString *) forNSArray:(NSArray *)array {
    SlimList *slimlist = NSArray_ToSlimList(array);
    NSString *result = CStringToNSString(SlimList_Serialize(slimlist));
    return result;
}

@end


#import "ValidInputTypes.h"

@implementation ValidInputTypes

-(id) init {
    if ((self = [super init])) {
        self.callWithZeroArgsCalled = NO;
    }
    return self;
}

-(void) callWithNSString: (NSString*) string {
    self.calledWithString = string;
}

-(void) callWithNSNumber: (NSNumber*) number {
    self.calledWithNSNumber = [number integerValue];
}

-(void) callWithZeroArgs {
    self.callWithZeroArgsCalled = YES;
}

-(void) callWithAndSecondArg:(NSArray*) args {
    self.firstArg = [args objectAtIndex: 0];
    self.secondArg = [args objectAtIndex: 1];
}

@end

#import "OCSStatementExecutor.h"
#import "OCSInstanceCreator.h"
#import "OCSMethodCaller.h"

static OCSStatementExecutor* sharedExecutor = NULL;

@implementation OCSStatementExecutor

+(id) sharedExecutor {
    if (sharedExecutor == NULL) {
        sharedExecutor = [self new];
    }
    return sharedExecutor;
}

-(id) init {
    if ((self = [super init])) {
        [self reset];
    }
    return self;
}

-(void) reset {
    self.instances = [NSMutableDictionary dictionary];
    self.symbolDictionary = [OCSSymbolDictionary new];
}

-(id) getInstanceWithName:(NSString*) instanceName {
    return [self.instances valueForKey: instanceName];
}

-(void) removeInstanceWithName:(NSString*) instanceName {
    [self.instances removeObjectForKey: instanceName];
    
}

-(void) setSymbol:(NSString*) symbol toValue:(NSString*) value {
    [self.symbolDictionary setSymbol: symbol toValue: value];
}

-(NSString*) makeInstanceWithName:(NSString*) instanceName
                        className:(NSString*) className
                          andArgs:(NSArray*) args {
    OCSInstanceCreator* ocsInstance;
    ocsInstance = [OCSInstanceCreator instanceWithName: instanceName
                                             ClassName: [self.symbolDictionary replaceSymbolsInString: className]
                                               andArgs: [self.symbolDictionary replaceSymbolsInArray: args]];
    id createdInstance = [ocsInstance create];
    [self.instances setValue: createdInstance forKey: instanceName];
    return [ocsInstance result];
}

-(NSString*) callMethod:(NSString*) methodName
     onInstanceWithName:(NSString*) instanceName
               withArgs:(NSArray*) args {
    OCSMethodCaller* methodCaller = [OCSMethodCaller withInstance: [self getInstanceWithName: instanceName]
                                                     instanceName: instanceName
                                                       methodName: methodName
                                                          andArgs: [self.symbolDictionary replaceSymbolsInArray: args]];
    return [methodCaller call];
}

@end

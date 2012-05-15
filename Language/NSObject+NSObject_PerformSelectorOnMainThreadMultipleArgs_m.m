#import "NSObject+NSObject_PerformSelectorOnMainThreadMultipleArgs_m.h"

@implementation NSObject (NSObject_PerformSelectorOnMainThreadMultipleArgs_m)

-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)firstObject, ...
{
    // First attempt to create the method signature with the provided selector.
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    
    if ( !signature ) {
        NSLog(@"NSObject: Method signature could not be created.");
        return;
    }
    
    // Next we create the invocation that will actually call the required selector.
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    // Now add arguments from the variable list of objects (nil terminated).
    va_list args;
    va_start(args, firstObject);
    int nextArgIndex = 2;
    
    for (NSObject *object = firstObject; object != nil; object = va_arg(args, NSObject*))
    {
        if ( object != [NSNull null] )
        {
            [invocation setArgument:&object atIndex:nextArgIndex];
        } 
        
        nextArgIndex++;
    }   
    
    va_end(args);
    
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

@end

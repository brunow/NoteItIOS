#import "Kiwi.h"

#import "MarkdownTextViewManipulation.h"

SPEC_BEGIN(MarkdownTextViewManipulationSpecs)

describe(@"MarkdownTextViewManipulationSpecs", ^{
    
    __block NSString *emptyText;
    __block NSString *oneLineText;
    __block NSString *multiLineText;
    __block TextViewManipulation *textManipulation;
    __block UITextView *textView;
    
    beforeAll(^{
        emptyText = @"";
        oneLineText = @"Hi, I'm a single line.";
        multiLineText = @"Hi, I'm a multi line.\nText with many return\nThe end.";
        
        textView = [[UITextView alloc] init];
        textManipulation = [[TextViewManipulation alloc] initWithTextView:textView];
    });
    
    it(@"sddsds", ^{
        [[@"ddd" should] beEmpty];
    });
    
    //    context(@"empty string", ^{
    //
    //        beforeAll(^{
    //            textView.text = emptyText;
    //        });
    //
    //        it(@"should be empty string", ^{
    //            id value = [textManipulation lineWithRange:NSMakeRange(10, 0)];
    //            [[value should] beEmpty];
    //        });
    //        
    //    });
});

SPEC_END
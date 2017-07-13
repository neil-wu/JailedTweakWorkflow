
#import "headers.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#define KEY_MY_STEP_VAL @"KEY_MY_STEP_VAL"


%hook WCDeviceStepObject
- (unsigned int)m7StepCount {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* stepvalStr = [userDefaultes stringForKey: KEY_MY_STEP_VAL];
    if (nil == stepvalStr || stepvalStr.integerValue <= 0 ) {
        return %orig;
    }
    return stepvalStr.integerValue;
}
%end




%hook NewSettingViewController
-(void) reloadTableData {
    %orig;

    MMTableViewInfo* tmpTableView = nil;
    object_getInstanceVariable(self, "m_tableViewInfo", (void**)&tmpTableView);

    MMTableViewSectionInfo* sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    [tmpTableView insertSection: sectionInfo At: 0];
    

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString* stepvalStr = [userDefaultes stringForKey: KEY_MY_STEP_VAL];

    MMTableViewCellInfo* oneCellInfo = [objc_getClass("MMTableViewCellInfo") editorCellForSel:@selector(handleStepCount:) target:self tip:@"input step value" focus:NO autoCorrect:NO text:stepvalStr];
    [sectionInfo addCell:oneCellInfo];

    MMTableView *tableView = [tmpTableView getTableView];
    [tableView reloadData];

}

%new
-(void) handleStepCount: (UITextField*) sender { 
	NSString* str = sender.text;
	NSInteger stepCount = str.integerValue;
	if (stepCount >= 0) {
		NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    	[userDefaultes setObject: str forKey: KEY_MY_STEP_VAL];;
    	[userDefaultes synchronize];
	}
    
}
%end


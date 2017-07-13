

#import <UIKit/UIKit.h>

@interface MMTableViewInfo : NSObject
- (id)getTableView;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;
@end

@interface MMTableViewSectionInfo : NSObject
+ (id)sectionInfoDefaut;
+ (id)sectionInfoFooter:(id)arg1;
- (void)addCell:(id)arg1;
@end

@interface MMTableViewCellInfo : NSObject
+ (id)editorCellForSel:(SEL)arg1 target:(id)arg2 tip:(id)arg3 focus:(_Bool)arg4 autoCorrect:(_Bool)arg5 text:(id)arg6;
@end

@interface MMTableView : UITableView
- (void)reloadData;
@end

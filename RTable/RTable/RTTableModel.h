#import <Foundation/Foundation.h>

@class RTCellModel;

@interface RTTableModel : NSObject
@property (nonatomic, readonly)	NSArray	*cellModels;

@property (nonatomic, readonly, getter = isLoaded)	BOOL	loaded;

- (void)addCellModel:(RTCellModel *)cellModel;
- (void)removeCellModel:(RTCellModel *)cellModel;
- (void)moveCellModelFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void)load;
- (void)save;
- (void)dump;

@end

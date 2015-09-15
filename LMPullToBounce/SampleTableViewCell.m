//
//  SampleTableViewCell.m
//  
//
//  Created by luck-mac on 15/8/19.
//
//

#import "SampleTableViewCell.h"
#import "UIView+PullToBounce.h"

@implementation SampleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *iconMock = [[UIView alloc] initWithFrame:CGRectMake(16, 16, 60, 60)];
        iconMock.layer.cornerRadius = 10;
        [iconMock setClipsToBounds:YES];
        iconMock.backgroundColor = [UIColor colorWithRed:0.700062 green:0.817345 blue:0.972549 alpha:1];;
        [self addSubview:iconMock];
        CGFloat lineLeft = iconMock.right + 16;
        CGFloat lineMargin = 12;
        
        CGRect lineFrame1 = CGRectMake(lineLeft, lineMargin + 12 , 100, 6);
        UIView *line1 = [self addLine:lineFrame1];
        CGRect lineFrame2 = CGRectMake(lineLeft, line1.bottom + lineMargin, 160, 5);
        UIView *line2 = [self addLine:lineFrame2];
        CGRect lineFrame3 = CGRectMake(lineLeft, line2.bottom + lineMargin, 180, 5);
        [self addLine:lineFrame3];
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 91, self.width, 1)];
        seperator.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [self addSubview:seperator];
    }
    return self;
}

- (UIView *)addLine:(CGRect)lineFrame {
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    line.layer.cornerRadius = line.height;
    line.backgroundColor = [UIColor colorWithRed:0.700062 green:0.817345 blue:0.972549 alpha:1];
    [self addSubview:line];
    return line;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

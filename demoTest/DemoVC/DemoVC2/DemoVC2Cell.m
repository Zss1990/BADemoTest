//
//  DemoVC2Cell.m
//  demoTest
//
//  Created by 博爱 on 16/3/15.
//  Copyright © 2016年 博爱之家. All rights reserved.
//

#import "DemoVC2Cell.h"
#import "DemoVC2Model.h"
#import "SDWeiXinPhotoContainerView.h"


const CGFloat contentLabelFontSize = 15;
const CGFloat maxContentLabelHeight = 54;

@implementation DemoVC2Cell
{
    UIImageView                 *_iconView;
    UILabel                     *_nameLable;
    UILabel                     *_contentLabel;
    SDWeiXinPhotoContainerView  *_picContainerView;
    UILabel                     *_timeLabel;
    UIButton                    *_moreButton;
    BOOL                         _shouldOpenContentLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    _shouldOpenContentLabel = NO;
    
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"显示全部" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _moreButton, _picContainerView, _timeLabel];
    
    [self.contentView BA_AddSubViewsWithArray:views];

    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(60);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:margin + 5];
}


- (void)setModel:(DemoVC2Model *)model
{
    _model = model;
    
    _shouldOpenContentLabel = NO;
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _contentLabel.text = model.content;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起文字" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(60);
            [_moreButton setTitle:@"显示全部" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    _timeLabel.text = @"1分钟前";
}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

@end

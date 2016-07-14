//
//  CustomViewCell.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "CustomViewCell.h"

@implementation CustomViewCell{
    
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGRect tweetLabelRect = CGRectMake(10, 10, 350, 70);
        _summaryLabel= [[UILabel alloc]initWithFrame:tweetLabelRect];
        _summaryLabel.numberOfLines=3;
        [_summaryLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_summaryLabel];
        
        
        CGRect imgLinkRect = CGRectMake(10, 80, 350, 50);
        _detailTextView= [[UILabel alloc]initWithFrame:imgLinkRect];
        _detailTextView.numberOfLines=3;
         [_detailTextView setFont:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:_detailTextView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) setSummary:(NSString *)summary{
    if(![summary isEqualToString:_summary]){
        _summary = [summary copy];
        _summaryLabel.text = _summary;
        
    }
    
}
-(void) setDetail:(NSString *)detail{
    if(![detail isEqualToString:_detail]){
        _detail = [detail copy];
        _detailTextView.text = _detail;
       
        
        
    }
}


@end

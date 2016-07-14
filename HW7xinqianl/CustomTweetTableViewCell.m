//
//  CustomTweetTableViewCell.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/13/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "CustomTweetTableViewCell.h"
#import "PhotoViewController.h"
@implementation CustomTweetTableViewCell{
    
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGRect tweetLabelRect = CGRectMake(10, 10, 350, 65);
        _tweetLabel= [[UITextView alloc]initWithFrame:tweetLabelRect];
        _tweetLabel.editable = NO;
        [self.contentView addSubview:_tweetLabel];
        
        CGRect imgLinkRect = CGRectMake(10, 75, 350, 30);
        _link= [[UIButton alloc]initWithFrame:imgLinkRect];
        [_link setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_link];
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
-(void) setTweet:(NSString *)tweet{
    if(![tweet isEqualToString:_tweet]){
        _tweet = [tweet copy];
        _tweetLabel.text = _tweet;
        
    }
    
}
-(void) setImage:(NSString *)image{
    if(![image isEqualToString:_image]){
        _image = [image copy];
        [_link setTitle:_image forState:UIControlStateNormal];
        
    }
}


@end
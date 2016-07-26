//
//  SampleCell.m
//  CoverFlowLayout
//
//  Created by Grigory Avdyushin on 25.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "SampleCell.h"

@implementation SampleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 2.0f;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}

- (void)setIsCopy:(BOOL)isCopy
{
    _isCopy = isCopy;
    if (isCopy) {
        self.layer.borderColor = [UIColor greenColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
}

@end

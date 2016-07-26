//
//  SampleCell.h
//  CoverFlowLayout
//
//  Created by Grigory Avdyushin on 25.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (assign, nonatomic) BOOL isCopy;

@end

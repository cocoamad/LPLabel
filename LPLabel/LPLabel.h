//
//  LPLabel.h
//  LPLabel
//
//  Created by Penny on 13/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface LPLabel : UILabel
@property (nonatomic, assign) CGFloat linespacing;  // line spacing
@property (nonatomic, assign) CGFloat characterSpacing; // character spacing

@property (nonatomic, assign) NSInteger maxLineCount; // support assign max line
@property (nonatomic, readonly) CGFloat height; // return label height
@end

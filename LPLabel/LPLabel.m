//
//  LPLabel.m
//  LPLabel
//
//  Created by Penny on 13/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import "LPLabel.h"
#define MAX_LINE_COUNT 0xffffffff
#define MAX_TEXT_HEIGHT 2000.0f
@implementation LPLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _linespacing = 0.0f;
        _characterSpacing = 0.0f;
        _maxLineCount = MAX_TEXT_HEIGHT;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (self.text == nil) {
        return;
    }
    // 创建属性字符串
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: self.text];
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [string addAttribute: (id)kCTFontAttributeName value: (id)helveticaBold range: NSMakeRange(0,[string length])];

    // 属性设置
    if(self.characterSpacing)
    {
        long number = self.characterSpacing;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [string addAttribute: (NSString *)kCTKernAttributeName value: (NSNumber *)num range: NSMakeRange(0, [string length])];
        CFRelease(num);
    }
    
    [string addAttribute: (id)kCTForegroundColorAttributeName value: (id)(self.textColor.CGColor) range: NSMakeRange(0,[string length])];
    
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    if(self.textAlignment == NSTextAlignmentCenter){
        alignment = kCTCenterTextAlignment;
    }
    if(self.textAlignment == NSTextAlignmentRight){
        alignment = kCTRightTextAlignment;
    }

    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize = sizeof(alignment);
    alignmentStyle.value = &alignment;

    CGFloat lineSpace = self.linespacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    
    CTParagraphStyleSetting settings[ ] ={alignmentStyle, lineSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));

    [string addAttribute: (id)kCTParagraphStyleAttributeName value: (id)style range: NSMakeRange(0 , [string length])];

    // 创建frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , MAX_TEXT_HEIGHT));
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // draw line
    CFArrayRef lines = CTFrameGetLines(leftFrame);
    CFIndex numLines = CFArrayGetCount(lines);
    CGFloat textOffset = 0;
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, self.bounds.origin.x, self.bounds.origin.y + floor(self.font.ascender));
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1, -1));
    
    for (int i = 0; i < _maxLineCount && i < numLines; i++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
        if (i == _maxLineCount - 1) {
            CFRange lineRange = CTLineGetStringRange(line);
            if ((lineRange.location + lineRange.length) < [string length]) {
                NSDictionary *attributes = [string attributesAtIndex: string.length-1 effectiveRange: NULL];
                CFAttributedStringRef truncatedString = CFAttributedStringCreate(NULL, CFSTR("\u2026"), (CFDictionaryRef)attributes);
                CTLineRef token = CTLineCreateWithAttributedString(truncatedString);
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(line, self.bounds.size.width - 20, kCTLineTruncationEnd, token);
                CFRelease(line);
                line = nil;
                line = truncatedLine;
            }
        }
        CGFloat penOffset = CTLineGetPenOffsetForFlush(line, 0, self.bounds.size.width);
        CGContextSetTextPosition(ctx, penOffset, textOffset);
        CTLineDraw(line, ctx);
        textOffset += ceil(_linespacing);
    }
    CGContextRestoreGState(ctx);
    
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    CFRelease(helveticaBold);
    [string release];
    UIGraphicsPushContext(ctx);
}

- (CGFloat)height
{
    if (self.text == nil) {
        return 0.0f;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: self.text];
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [string addAttribute: (id)kCTFontAttributeName value: (id)helveticaBold range: NSMakeRange(0,[string length])];
    
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(self.linespacing);
    lineSpaceStyle.value = &_linespacing;
    
    CTParagraphStyleSetting settings[ ] ={lineSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));
    
    [string addAttribute:(id)kCTParagraphStyleAttributeName value: (id)style range: NSMakeRange(0 , [string length])];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0, 0, 200, MAX_TEXT_HEIGHT));
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    CFArrayRef lines = CTFrameGetLines(leftFrame);
	CFIndex numLines = CFArrayGetCount(lines);
    
    numLines = numLines <= self.maxLineCount ? numLines : self.maxLineCount;
    CGFloat height = ceil(self.linespacing * numLines);
    
    CGPathRelease(leftColumnPath);
    CFRelease(helveticaBold);
    CFRelease(framesetter);
    CFRelease(leftFrame);
    CFRelease(style);
    [string release];
    
    return height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

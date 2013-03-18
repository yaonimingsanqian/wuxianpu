//
//  AnalysisResult.h
//  SearchBall
//
//  Created by gw zhao on 13-3-18.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisResult : NSObject
{
    int ballCount;
    int lineCount;
    int verticalLineCount;
    
    NSMutableArray *ballSet;
    NSMutableArray *lineSet;
    NSMutableArray *verticalLineSet;
}
-(void)setBallCount:(int)count;
-(void)setLineCount:(int)count;
-(void)setVerticalLineCount:(int)count;
-(void)setBallSet:(NSMutableArray*)arr;
-(void)setLineSet:(NSMutableArray*)arr;
-(void)setVerticalLineSet:(NSMutableArray*)arr;

-(int)getBallCount;
-(int)getLineCount;
-(int)getVerticalLineCount;
-(NSMutableArray*)getBallSet;
-(NSMutableArray*)getLineSet;
-(NSMutableArray*)getVerticalLineSet;
@end

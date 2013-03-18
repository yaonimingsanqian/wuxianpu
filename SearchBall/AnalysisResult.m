//
//  AnalysisResult.m
//  SearchBall
//
//  Created by gw zhao on 13-3-18.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "AnalysisResult.h"

@implementation AnalysisResult

-(id)init
{
    self = [super init];
    if(self)
    {
        lineCount = 0;
        lineSet = [[NSMutableArray alloc]init];
        ballCount = 0;
        ballSet = [[NSMutableArray alloc]init];
        verticalLineCount = 0;
        verticalLineSet = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)setLineCount:(int)count
{
    lineCount = count;
}

-(void)setLineSet:(NSMutableArray *)arr
{
    lineSet = arr;
}
-(void)setVerticalLineCount:(int)count
{
    verticalLineCount = count;
}
-(void)setVerticalLineSet:(NSMutableArray *)arr
{
    verticalLineSet = arr;
}
-(void)setBallCount:(int)count
{
    ballCount = count;
}
-(void)setBallSet:(NSMutableArray *)arr
{
 
    ballSet = arr;
}

-(int)getBallCount
{
    return ballCount;
}
-(int)getLineCount
{
    return lineCount;
}
-(int)getVerticalLineCount
{
    return verticalLineCount;
}

-(NSMutableArray*)getBallSet
{
    return ballSet;
}
-(NSMutableArray*)getLineSet
{
    return lineSet;
}
-(NSMutableArray*)getVerticalLineSet
{
    return verticalLineSet;
}
@end

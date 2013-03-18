//
//  AnalysisData.m
//  SearchBall
//
//  Created by gw zhao on 13-3-15.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "AnalysisSingleNote.h"

@implementation AnalysisData

-(id)init
{
    self = [super init];
    if(self)
    {
        verticalLineCount = 0;
        dashLineCount = 0;
        ballCount = 0;
        
        verticalLineSet = [[NSMutableArray alloc]init];
        dashLineSet = [[NSMutableArray alloc]init];
        ballSet = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setBallCount:(int)count
{
    ballCount = count;
}
-(void)setBallSet:(NSMutableArray *)arr
{
    ballSet = arr;
}
-(void)setDashLineCount:(int)count
{
    dashLineCount = count;
}
-(void)setDashLineSet:(NSMutableArray *)arr
{
    dashLineSet = arr;
}
-(void)setVerticalLineCount:(int)count
{
    verticalLineCount = count;
}
-(void)setVerticalLineSet:(NSMutableArray *)arr
{
    verticalLineSet = arr;
}

-(int)getBallCount
{
    return ballCount;
}
-(int)getDashLineCount
{
    return dashLineCount;
}
-(int)getVerticalLineCount
{
    return verticalLineCount;
}
-(NSMutableArray*)getBallSet
{
    return ballSet;
}
-(NSMutableArray*)getDashLineSet
{
    return dashLineSet;
}
-(NSMutableArray*)getVerticalLineSet
{
    return verticalLineSet;
}
@end

//
//  AnalysisData.h
//  SearchBall
//
//  Created by gw zhao on 13-3-15.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisData : NSObject
{
    int verticalLineCount;
    int dashLineCount;
    int ballCount;
    
    NSMutableArray *verticalLineSet;
    NSMutableArray *dashLineSet;
    NSMutableArray *ballSet;
    
}
-(void)setBallCount:(int)count;
-(void)setVerticalLineCount:(int)count;
-(void)setDashLineCount:(int)count;
-(void)setVerticalLineSet:(NSMutableArray*)arr;
-(void)setDashLineSet:(NSMutableArray*)arr;
-(void)setBallSet:(NSMutableArray*)arr;

-(int)getBallCount;
-(int)getDashLineCount;
-(int)getVerticalLineCount;
-(NSMutableArray*)getVerticalLineSet;
-(NSMutableArray*)getDashLineSet;
-(NSMutableArray*)getBallSet;
@end

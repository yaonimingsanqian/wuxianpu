//
//  NoteAnalysis.m
//  SearchBall
//
//  Created by gw zhao on 13-3-14.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "NoteAnalysis.h"
#import "PosPoint.h"
#import "AnalysisSingleNote.h"
#import "AnalysisResult.h"
#import "Position.h"
@implementation AnalysisSingleNote

-(void)copyPoints:(NSMutableArray*)from :(NSMutableArray*)to
{
    for(int i = 0;i != [from count];i++)
    {
        [to addObject:[from objectAtIndex:i]];
    }
}
-(PosPoint*)getMinPosXAndMinPosY:(NSMutableArray*)singleNotePoints
{
    PosPoint *min = [singleNotePoints objectAtIndex:0];
    int x,y;
    for(int j = 1;j != [singleNotePoints count];j++)
    {
        if([[singleNotePoints objectAtIndex:j] getPosX]<[min getPosX])
            min = [singleNotePoints objectAtIndex:j];
    }
    x = [min getPosX];
    min = [singleNotePoints objectAtIndex:0];
    for(int i = 1;i!=[singleNotePoints count];i++)
    {
        if([[singleNotePoints objectAtIndex:i] getPosY]<[min getPosY])
                min = [singleNotePoints objectAtIndex:i];
    }
    y = [min getPosY];
    PosPoint *p = [[PosPoint alloc]init];
    [p setPosX:x];
    [p setPosY:y];
    return p;
}
-(int)getWidth:(NSMutableArray*)singleNotePoints
{
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    [self copyPoints:singleNotePoints :arrTemp];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    PosPoint *min;
    int count = [arrTemp count];
    for(int i = 1;i != count;i++)
    {
        if([arrTemp count]>0)
            min = [arrTemp objectAtIndex:0];
        else
            break;
        for(int j=1;j < [arrTemp count];j++)
        {
            if([[arrTemp objectAtIndex:j] getPosX]<[min getPosX])
                min = [arrTemp objectAtIndex:j];
                
        }
        [arr addObject:min];
        [arrTemp removeObject:min];
    }
    int width = -[[arr objectAtIndex:0] getPosX]+[[arr objectAtIndex:([arr count]-1)] getPosX]+1;
    singleNotePoints = arr;
    return width;
}
-(int)getHeight:(NSMutableArray*)singleNotePoints
{
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    [self copyPoints:singleNotePoints :arrTemp];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    PosPoint *min;
    int count = [arrTemp count];
    for(int i = 1;i != count;i++)
    {
        if([arrTemp count]>0)
            min = [arrTemp objectAtIndex:0];
        else
            break;
        for(int j=1;j < [arrTemp count];j++)
        {
            if([[arrTemp objectAtIndex:j] getPosY]<[min getPosY])
                min = [arrTemp objectAtIndex:j];
            
        }
        [arr addObject:min];
        [arrTemp removeObject:min];
    }
    int height = -[[arr objectAtIndex:0] getPosY]+[[arr objectAtIndex:([arr count]-1)] getPosY]+1;
    return height;
}
-(int)getEei
{
    return hei;
}
-(int)getWid
{
    return wid;
}
-(BOOL)isBlackVerticalLines:(uint32_t*)data :(int)width :(int)height
{
    int count;
    for(int i = 0; i != height;i++)
    {
        for(int j = 0 ; j != width;j++)
        {
            if(data[j*width+i]!=0xffffffff)
            {
                count++;
            }
        }
    }
    if(count>3*height/4)
        return TRUE;
    return FALSE;
}
-(BOOL)isRowVerticalLine:(uint32_t*)data :(int)width :(int)height :(int)lineCount :(int*)count
{
    for(int j = 0;j!=height;j++)
    {
        if(data[j*width+lineCount]!=0xffffffff)
        {
            (*count)++;
        } 
    }
    if(*count>30)
        return TRUE;
    return FALSE;
}
-(PosPoint*)createPosPoint:(uint32_t*)data :(PosPoint*)min :(int)lineCount :(int)m :(int)width
{
    PosPoint *p = [[PosPoint alloc]init];
    [p setPosX:(lineCount+[min getPosX])];
    [p setPosY:(m+[min getPosY])];
    [p setColorSpace:(data[m*width+lineCount])];
    
    
    return p;
}
-(NSMutableArray*)pushPoints:(uint32_t*)data :(int)width :(int)height :(int)lineCount :(PosPoint*)min :(AnalysisData*)analisisData 
{
    NSMutableArray *pointArray = [[NSMutableArray alloc]init];
    for(int m = 0 ;m <height;m++)
    {
        if(lineCount==0)
        {
            if(data[m*width+lineCount]!= 0xffffffff)
                data[m*width+lineCount] = 0xffffffff; 
        }
        else
        {
            if(data[m*width+lineCount-1]==0xffffffff)
            {
                if(data[m*width+lineCount]!= 0xffffffff)
                {
                    PosPoint *p = [self createPosPoint:data :min :lineCount :m :width];
                    [pointArray addObject:p];
                    data[m*width+lineCount] = 0xffffffff; 
                }
                    
                
            }
        }
    }
    return pointArray;
}
-(void)increaseVerticalLineCounnt:(AnalysisData*)analysisData
{
   int verticalLineCount = [analysisData getVerticalLineCount];
    verticalLineCount += 1;
    [analysisData setVerticalLineCount:verticalLineCount]; 
}
-(void)analysisVerticalLines:(uint32_t*)data :(int)width :(int)height :(PosPoint*)min
{
    int count = 0;
    int p = 0;
    for(int i = 0; i != width;i++)
    {
       if([self isRowVerticalLine:data :width :height :i :&count])
       {
           
       //  NSMutableArray *pointArray = [self pushPoints:data :width :height :i :min :analysisData];
           p++;
           
        //[[analysisData getVerticalLineSet] addObject:pointArray];
           
           //[self increaseVerticalLineCounnt:analysisData];
       }
        
       count = 0;  
    }
    int c = p;
}


//新加的函数
-(BOOL)isContinuous:(NSMutableArray*)temp
{
    BOOL flag = TRUE;
    for(int i = 1;i!=[temp count];i++)
    {
       PosPoint *p1 = [temp objectAtIndex:i];
       PosPoint *p2 = [temp objectAtIndex:(i-1)];
        if([p1 getPosY]-[p2 getPosY]!=1)
        {
            flag = FALSE;
            break;
        }
        
    }
    return flag;
}
//新加的函数
-(NSMutableArray*)sequenceByPosY:(NSMutableArray*)data
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    int count = [data count];
    PosPoint *min;
    for(int i = 0;i != count;i++)
    {
        if([data count]>0)
            min = [data objectAtIndex:0];
        else
            break;
        for(int j = 1;j!=[data count];j++)
        {
            if([[data objectAtIndex:j] getPosY]<[min getPosY])
                min = [data objectAtIndex:j];
        }
        [temp addObject:min];
        [data removeObject:min];
    }
    return temp;
}

//新加函数
-(int)getBallCount:(uint32_t*)data :(int)spectrumWidth :(int)imageWidth :(int)imageHeight
{
    int count = 0;
    int ballCount = 0;
    for(int i = 0;i != imageWidth;i++)
    {
        for(int j = 0;j != imageHeight;j++)
        {
            if(data[j*imageWidth+i]!=0xffffffff)
            {
                count++;
            }
        }
        if(count==spectrumWidth||count==(spectrumWidth+1)||(count==spectrumWidth-1))
            ballCount++;
        count = 0;
    }
    return ballCount;
}
-(NSMutableArray*)getMapping:(uint32_t*)data :(int)imageWidth :(int)imageHeight :(int)spectrumWidth
{
    
    NSMutableArray *mapping = [[NSMutableArray alloc]init];
    int count = 0;
    for(int i = 0;i != imageWidth;i++)
    {
        for(int j = 0;j != imageHeight;j++)
        {
            if(data[j*imageWidth+i]!=0xffffffff)
            {
                count++;
            }
        }
        Position *p = [[Position alloc]init];
        [p setPosX:count];
        [mapping addObject:p];
        count = 0;
    }
    return mapping;
}
-(BOOL)isVertical:(Position*)first :(Position*)second :(int)spectrumInterval
{
    if([first getPosx]-[second getPosx]>spectrumInterval/1)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
-(BOOL)isContain:(AnalysisResult*)result :(Position*)p
{
    for (Position *pos in [result getVerticalLineSet])
    {
        if([pos getPosx]==[p getPosx])
            return TRUE;
    }
    return FALSE;
}
-(void)pushPosX:(int)minPosX :(int)posX :(AnalysisResult*)result
{
    Position *p = [[Position alloc]init];
    [p setPosX:minPosX+posX];
    if(![self isContain:result :p])
    {
        [[result getVerticalLineSet] addObject:p];
    }
}
-(AnalysisResult*)getVerticalPos:(NSMutableArray*)data :(int)spectrumWidth :(int)minPosx 
{
    AnalysisResult *result = [[AnalysisResult alloc]init];
    for(int i = 1;i != [data count];i++)
    {
        if([self isVertical:[data objectAtIndex:i-1] :[data objectAtIndex:i] :spectrumWidth])
        {
            [self pushPosX:minPosx :i-1 :result];            
        }
    }
    return result;
}
-(uint32_t*)getVerticalLines:(NSMutableArray*)singleNotePoints :(int)spectrumWidth
{
    int posX,posY;
    int width = [self getWidth:singleNotePoints];
    int height = [self getHeight:singleNotePoints];
    wid = width;
    hei = height;
    uint32_t *temp = malloc(height*width*sizeof(int));
    for(int i = 0;i<width*height;i++)
    {
        temp[i] = 0xffffffff;
    }
    PosPoint *min = [self getMinPosXAndMinPosY:singleNotePoints];
    for (PosPoint *p in singleNotePoints)
    {
        
        posX = [p getPosX]-[min getPosX];
        posY = [p getPosY]-[min getPosY];
        temp[posY*width+posX] = [p getColorSpace];
    }
   // NSMutableArray *mapping = [self getMapping:temp :width :height :spectrumWidth];
   // for (Position *p in mapping)
   // {
   //     NSLog(@"%d",[p getPosx]);
   // }
       
   // AnalysisResult *result = [self getVerticalPos:mapping :spectrumWidth  :[min getPosX]];
   // for (Position *p in [result getVerticalLineSet])
   // {
    //    NSLog(@"%d",[p getPosx]);
   // }
    
    return temp;
}
@end

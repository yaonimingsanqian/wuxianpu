//
//  SimplyBmp.m
//  simplyBmpPicture_
//
//  Created by gw zhao on 13-2-25.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "SimplyBmp.h"
#import "ShiftData.h"
#import "Position.h"
@implementation SimplyBmp



-(void)writeRGBtoArr:(uint32_t *)destImageData :(int)squireCount :(uint32_t*)totalPixelsA :(uint32_t*)totalPixelsR :(uint32_t*)totalPixelsG :(uint32_t*)totalPixelsB :(int*)count
{
    int i = *count;
    *totalPixelsA /= squireCount;
    *totalPixelsR /= squireCount;
    *totalPixelsG /= squireCount;
    *totalPixelsB /= squireCount;
    
    *totalPixelsA = (*totalPixelsA) * SHIFTA;
    *totalPixelsR = (*totalPixelsR) * SHIFTR;
    *totalPixelsG = (*totalPixelsG) * SHIFTG;
    
    destImageData[i] = (*totalPixelsA)+(*totalPixelsB)+(*totalPixelsG)+(*totalPixelsR);
    (*count)++;
    
    *totalPixelsA = 0;
    *totalPixelsG = 0;
    *totalPixelsR = 0;
    *totalPixelsB = 0;
}

-(void)getRGBValue:(uint32_t)data :(uint32_t*)pTotalPixelsA :(uint32_t*)pTotalPixelsR :(uint32_t*)pTotalPixelsG :(uint32_t*)pTotalPixelsB 
{    
    *pTotalPixelsA += (MASKA & data) / SHIFTA;
    *pTotalPixelsR += (MASKR & data) / SHIFTR;                   
    *pTotalPixelsG += (MASKG & data) / SHIFTG;
    *pTotalPixelsB += MASKB & data; 
}

-(void)getSquireValue:(uint32_t*)pOrgImageData :(uint32_t*)totalPixelsA :(uint32_t*)totalPixelsR:(uint32_t*)totalPixelsG :(uint32_t*)totalPixelsB :(int)pointX :(int)pointY :(int)lineCount :(int)rowCount :(int*)squireCount :(int)imageWidth :(uint32_t)pixelsData
{
    for(int i = pointY;i < pointY+rowCount;i++)
    {
        for(int j = pointX;j < pointX+lineCount;j++)
        {
            (*squireCount)++;
            pixelsData = pOrgImageData[i*imageWidth+j];
            [self getRGBValue:pixelsData:totalPixelsA :totalPixelsR :totalPixelsG :totalPixelsB ];
        }
    }
}

-(void)calculateSquireAverage:(uint32_t*)pOrgImageData:(int)destSquireWidth :(int)destSquireHeigh :(int)pointX :(int)pointY :(int)imageWidth :(int)imageHeight :(uint32_t*)destImageData :(int*)count
{
    uint32_t pixelsData;
    int squireCount = 0;
    
    uint32_t totalPixelsA = 0;
    uint32_t totalPixelsR = 0;
    uint32_t totalPixelsG = 0;
    uint32_t totalPixelsB = 0;
    int rowCount = (pointY+destSquireHeigh > imageHeight)?(imageHeight-pointY):destSquireHeigh;
    
    int lineCount = (pointX+destSquireWidth>imageWidth)?(imageWidth-pointX):destSquireWidth;
    
    [self getSquireValue:pOrgImageData :&totalPixelsA :&totalPixelsR :&totalPixelsG :&totalPixelsB :pointX :pointY :lineCount :rowCount :&squireCount :imageWidth :pixelsData];
    
    [self writeRGBtoArr:destImageData :squireCount :&totalPixelsA :&totalPixelsR :&totalPixelsG :&totalPixelsB :count];
    squireCount = 0;
}

-(void)checkAllKeyPointOnCurrentLine:(uint32_t*)pOrgImageData :(int)destSquireWidth :(int)destSquireHeight :(int)imageHeight :(int)imageWidth :(uint32_t*)destImageData :(int)keyWidth :(int*)count
{
    for(int j = 0;j < imageWidth;j +=destSquireWidth)
    {
        [self calculateSquireAverage:pOrgImageData :destSquireWidth :destSquireHeight :j :keyWidth :imageWidth :imageHeight :destImageData :count];
    }
}
-(uint32_t*)createDestImageData:(int)imageWidth :(int)imageHeight :(int)destImageWidth :(int)destImageHeight
{
    uint32_t *destImageData;
    if(imageWidth%destImageWidth==0&&imageHeight%destImageHeight==0)
    {
        destImageData = malloc(imageWidth/destImageWidth*imageHeight/destImageHeight*sizeof(int));
    }else if(imageWidth%destImageWidth==0&&imageHeight%destImageHeight!=0)
    {
        destImageData = malloc(imageWidth/destImageWidth*(imageHeight/destImageHeight+1)*sizeof(int));
    }else if(imageWidth/destImageWidth!=0&&imageHeight/destImageHeight==0)
    {
        destImageData = malloc((imageWidth/destImageWidth+1)*imageHeight/destImageHeight*sizeof(int));
    }else
    {
        destImageData = malloc((imageWidth/destImageWidth+1)*(imageHeight/destImageHeight+1)*sizeof(int));
    }
    return destImageData;
}
-(BOOL)isSpectrum:(uint32_t*)pOrgImageData :(int)imageWidth :(int)imageHeight :(int)lineCount
{
    int count = 0;
    
        for(int j = 0;j != imageWidth;j++)
        {
            if(pOrgImageData[lineCount*imageWidth+j]!=0xffffffff)
            {
                count++;
            }
        }
        if(count>3*imageWidth/4)
            return TRUE;
        return FALSE;

 
}
-(NSMutableArray*)getKeyPoint:(NSMutableArray*)arr
{
    NSMutableArray *keyPoint = [[NSMutableArray alloc]init];
    for(int i = 1;i != [arr count];i++)
    {
        if([[arr objectAtIndex:i] getPosx]-[[arr objectAtIndex:i-1] getPosx]!=1)
        {
            Position *p = [[Position alloc]init];
            [p setPosX:i];
            [keyPoint addObject:p];
        }
    }
    return keyPoint;
}
-(int)getMax:(NSMutableArray*)keyPoint :(NSMutableArray*)arr
{
    int max = 0;
    for(int i = 1;i!=[keyPoint count];i++)
    {
        
        if([[keyPoint objectAtIndex:i] getPosx]-[[keyPoint objectAtIndex:i-1] getPosx]>max)
        {
            max = [[keyPoint objectAtIndex:i] getPosx]-[[keyPoint objectAtIndex:i-1] getPosx];
        }
    }
    if([[keyPoint objectAtIndex:0] getPosx]>max)
        max = [[keyPoint objectAtIndex:0] getPosx];
    if([arr count]-[[keyPoint lastObject] getPosx]>max)
        max = [arr count]-[[keyPoint lastObject] getPosx]>max;
    return max;
}
-(int)getMaxWidth:(NSMutableArray*)arr
{
    NSMutableArray *keyPoint = [self getKeyPoint:arr];
    int max = [self getMax:keyPoint :arr];
    return max;
}
-(int)getMaxSpectrumWidth:(uint32_t*)pOrgImageData :(int)imageWidth :(int)imageHeight
{
    NSMutableArray *temp_i = [[NSMutableArray alloc]init];
    for(int i = 0;i != imageHeight;i++)
    {
        if([self isSpectrum:pOrgImageData :imageWidth :imageHeight :i])
        {
            Position *p = [[Position alloc]init];
            [p setPosX:i];
            [temp_i addObject:p];
        }
    }
    int max = [self getMaxWidth:temp_i];
    return max;
}
-(uint32_t*)mergePix:(uint32_t*)pOrgImageData
               :(int)imageWidth 
               :(int)imageHeight 
               :(int)destSquireWidth 
               :(int)destSquireHeight 
{
    /*NSMutableArray *arr = [[NSMutableArray alloc]init];
    Position *p1 = [[Position alloc]init];
    [p1 setPosX:1];
    Position *p2 = [[Position alloc]init];
    [p2 setPosX:2];
    Position *p3 = [[Position alloc]init];
    [p3 setPosX:3];
    Position *p4 = [[Position alloc]init];
    [p4 setPosX:7];
    Position *p5 = [[Position alloc]init];
    [p5 setPosX:8];
    Position *p6 = [[Position alloc]init];
    [p6 setPosX:9];
    Position *p7 = [[Position alloc]init];
    [p7 setPosX:10];
    Position *p8 = [[Position alloc]init];
    [p8 setPosX:11];
    Position *p9 = [[Position alloc]init];
    [p9 setPosX:12];
    Position *p10 = [[Position alloc]init];
    [p10 setPosX:15];
    Position *p11 = [[Position alloc]init];
    [p11 setPosX:16];
    [arr addObject:p1];
    [arr addObject:p2];
    [arr addObject:p3];
    [arr addObject:p4];
    [arr addObject:p5];
    [arr addObject:p6];
    [arr addObject:p7];
    [arr addObject:p8];
    [arr addObject:p9];
    [arr addObject:p10];
    [arr addObject:p11];
    int max = [self getMaxWidth:arr];*/


    
    uint32_t *destImageData_ = [self createDestImageData:imageWidth :imageHeight :destSquireWidth :destSquireHeight];
    int count = 0;
    for(int i = 0;i < imageHeight;i += destSquireHeight)
    {
        [self checkAllKeyPointOnCurrentLine:pOrgImageData :destSquireWidth :destSquireHeight :imageHeight :imageWidth :destImageData_ :i :&count];
    }
    return destImageData_;
}
@end

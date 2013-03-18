//
//  NoteAnalysis.h
//  SearchBall
//
//  Created by gw zhao on 13-3-14.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleNote.h"

@interface AnalysisSingleNote : NSObject
{
    int wid;
    int hei;
}
-(int)getWid;
-(int)getEei;
-(uint32_t*)getVerticalLines :(NSMutableArray*)              
                               singleNote
                             :(int)spectrumWidth;
@end

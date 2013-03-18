//
//  ViewController.m
//  SearchBall
//
//  Created by gw zhao on 13-3-14.
//  Copyright (c) 2013年 hebust. All rights reserved.
//


#import "ViewController.h"
#import "PosPoint.h"
#import "NoteAnalysis.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"danhang.bmp"]
    ;
    CGImageRef imageRef = [image CGImage];
    uint32_t *pOrgImageData = malloc(image.size.width*image.size.height*sizeof(int));
    
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pOrgImageData, imageWidth, imageHeight, 8, 4*imageWidth,colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    CGContextRelease(context);
    
    simply = [[SimplyBmp alloc]init];
    int max = [simply getMaxSpectrumWidth:pOrgImageData :imageWidth :imageHeight];
    
    //int destSquireWidth = max;
    //int destSquireHeight = max;
    uint32_t *destImageData;
    
    destImageData = [simply mergePix:pOrgImageData :imageWidth :imageHeight :max :max];
    
    CGContextRef context1 = CGBitmapContextCreate(destImageData, imageWidth/max+1, imageHeight/max+1, 8, 4*(imageWidth/max+1),colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    CGImageRef imageRef1 = CGBitmapContextCreateImage(context1);
    UIImage *image1 = [[UIImage alloc]initWithCGImage:imageRef1];
    UIImageView *view1 = [[UIImageView alloc]initWithImage:image1];
    view1.frame = CGRectMake(0, 200, image1.size.width, image1.size.height);
    [self.view addSubview:view1];
    
    
    
    
    
    
    
    
    noteRecognize = [[NoteRecognition alloc]init];
    int spectrumWidth = [noteRecognize getSpectrWidth:destImageData :imageWidth/max+1 :imageHeight/max+1];
    //int w = [clear getSpectrWidth:destImageData :imageWidth/max+1 :imageHeight/max+1];
    NoteSet *t =  [noteRecognize getAllNote :destImageData :imageWidth/max+1 :imageHeight/max+1];
    uint32_t *d = malloc((imageWidth/max+1)*(imageHeight/max+1)*sizeof(int));
    for (int i=0; i<(imageWidth/max+1)*(imageHeight/max+1); i++)
    {
        d[i] = 0xffffffff;
    }
    NSMutableArray *arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    //arr = [t next];
    
    
    
    for (PosPoint *p in arr) 
    {
        d[[p getPosY]*(imageWidth/max+1)+[p getPosX]] = [p getColorSpace];
    }
    
    CGContextRef context_ = CGBitmapContextCreate(d, imageWidth/max+1, imageHeight/max+1, 8, 4*(imageWidth/max+1),colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    CGImageRef imageRef_ = CGBitmapContextCreateImage(context_);
    UIImage *image_ = [[UIImage alloc]initWithCGImage:imageRef_];
    UIImageView *view = [[UIImageView alloc]initWithImage:image_];
    [self.view addSubview:view];
    
    
    AnalysisSingleNote *analysis = [[AnalysisSingleNote alloc]init];
    uint32_t* temp =[analysis getVerticalLines:arr :spectrumWidth];
    
    CGContextRef context2 = CGBitmapContextCreate(temp, [analysis getWid], [analysis getEei], 8, 4*[analysis getWid],colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    CGImageRef imageRef2 = CGBitmapContextCreateImage(context2);
    UIImage *image2 = [[UIImage alloc]initWithCGImage:imageRef2];
    UIImageView *view2 = [[UIImageView alloc]initWithImage:image2];
    view2.frame = CGRectMake(30, 350, [analysis getWid], [analysis getEei]);
    [self.view addSubview:view2];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end

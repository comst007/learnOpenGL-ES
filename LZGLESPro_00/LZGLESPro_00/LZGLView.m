//
//  LZGLView.m
//  LZGLESPro_00
//
//  Created by comst on 2018/3/15.
//  Copyright © 2018年 comst. All rights reserved.
//

#import "LZGLView.h"
#import <OpenGLES/ES2/gl.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LZGLView()
@property (strong, nonatomic)  CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint glRenderB;
@property (nonatomic, assign) GLuint glFrameB;
@property (nonatomic, strong) EAGLContext* glContext;

-(void)setupLayer;
-(void)setupContex;
-(void)setupRenderBuffer;
-(void)setupFrameBuffer;
-(void)removeRenderAndFrameBuffers;
-(void)render;

@end

@implementation LZGLView

+(Class)layerClass {
    return [CAEAGLLayer class];
}
- (void)layoutSubviews{
    [self setupLayer];
    [self setupContex];
    [self removeRenderAndFrameBuffers];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self render];
}
-(void)setupLayer{
    self.glLayer = (CAEAGLLayer *)self.layer;
    self.glLayer.opaque = YES;
    
    NSDictionary *config = @{
                             kEAGLDrawablePropertyRetainedBacking: @(false),
                             kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
                             };
    self.glLayer.drawableProperties = config;
}

- (void)setupContex{
   
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_glContext) {
        NSLog(@"init glCOntext failed!");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:self.glContext]){
        NSLog(@"set current context failed");
        exit(1);
    }
    
}

-(void)setupRenderBuffer{
    GLuint renderB ;
    glGenRenderbuffers(1, &renderB);
    glBindRenderbuffer(GL_RENDERBUFFER, renderB);
    
    self.glRenderB = renderB;
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
}
-(void)setupFrameBuffer{
  
    GLuint frameB ;
    glGenFramebuffers(1, &frameB);
    
    glBindFramebuffer(GL_FRAMEBUFFER, frameB);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.glRenderB);
    
    
    self.glFrameB = frameB;
    
}

-(void)removeRenderAndFrameBuffers{
    glDeleteFramebuffers(1, &_glFrameB);
    _glFrameB = 0;
    glDeleteRenderbuffers(1, &_glRenderB);
    _glRenderB = 0 ;
}

-(void)render{
    glClearColor(0.7, 1, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
    
}

@end

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
#import "LZGLUtil.h"

@interface LZGLView()
@property (strong, nonatomic)  CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint glRenderB;
@property (nonatomic, assign) GLuint glFrameB;
@property (nonatomic, strong) EAGLContext* glContext;
@property (nonatomic, assign) GLuint programe;
@property (nonatomic, assign) GLint vPosition;
@property (nonatomic, assign) GLint vColor;
-(void)setupLayer;
-(void)setupContex;
-(void)setupRenderBuffer;
-(void)setupFrameBuffer;
-(void)removeRenderAndFrameBuffers;
- (void)setupShaderProgram;
-(void)render;

@end

@implementation LZGLView

+(Class)layerClass {
    return [CAEAGLLayer class];
}
- (void)layoutSubviews{
    [self setupLayer];
    [self setupContex];
    [self setupShaderProgram];
    
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
    glClearColor(0.7, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat vetexs[] = {
        0.5f, 0.5f, 0.0f,0.1, 0.2, 0.8,
        0.5f, -0.5f, 0.0f,0.5, 0.9, 0.1,
        -0.5f, -0.5f, 0.0f,0.4, 0.8, 0.9,
        -0.5f, 0.5f, 0.0f,0.6, 0.6, 0.3,
        0.0f, 0.0f, -0.707f, 0.7, 0.1, 0.2
    };
    
    GLubyte indices[] = {
        0, 1, 1, 2, 2, 3, 3, 0,
        4, 0, 4, 1, 4, 2, 4, 3
    };
    
    glVertexAttribPointer(_vPosition, 3, GL_FLOAT, false, 6 * sizeof(GLfloat), vetexs);
    glEnableVertexAttribArray(_vPosition);
    
    glVertexAttribPointer(_vColor, 3, GL_FLOAT, false, 6 * sizeof(GLfloat), vetexs + 3);
    glEnableVertexAttribArray(_vColor);
    
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
    //glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
    
}

- (void)setupShaderProgram{
    NSString *vsPath = [[NSBundle mainBundle] pathForResource:@"LZVertextShader" ofType:@"glsl"];
    NSString *fsPath = [[NSBundle mainBundle] pathForResource:@"GLFragementShader" ofType:@"glsl"];
    
    GLuint vShader = [LZGLUtil loadShaderWithType:GL_VERTEX_SHADER fromFilePath:vsPath];
    GLuint fShader = [LZGLUtil loadShaderWithType:GL_FRAGMENT_SHADER fromFilePath:fsPath];
    
    GLuint program ;
    program = glCreateProgram();
    glAttachShader(program, vShader);
    glAttachShader(program , fShader);
    glLinkProgram(program);
    
    GLint status ;
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (!status) {
        GLint logLen ;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLen);
        
        char *logB = (char*)malloc((logLen + 1) * sizeof(char));
        memset(logB, 0, logLen + 1);
        glGetProgramInfoLog(program, logLen, NULL, logB);
        
        NSString *logS = [NSString stringWithUTF8String:logB];
        NSLog(@"program link failed: %@-----\n", logS);
        free(logB);
        exit(1);
    }
    self.programe = program;
     glUseProgram(program);
    _vPosition  = glGetAttribLocation(program, "vPosition");
    _vColor = glGetAttribLocation(program, "vColor");
}
@end

//
//  LZGLUtil.m
//  LZGLESPro_00
//
//  Created by comst on 2018/3/15.
//  Copyright © 2018年 comst. All rights reserved.
//

#import "LZGLUtil.h"

@implementation LZGLUtil

+ (GLuint)loadShaderWithType:(GLenum)type fromString:(NSString *)source{
    GLuint shader;
    shader = glCreateShader(type);
    const char *cStr = source.UTF8String ;
    glShaderSource(shader, 1, &cStr, 0);
    
    glCompileShader(shader);
    
    GLint status ;
    
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    
    if (!status) {
        GLint logLen;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLen);
        char *logB = (char*)malloc((logLen + 1) * sizeof(char));
        memset(logB, 0, logLen + 1);
        glGetShaderInfoLog(shader, logLen, NULL, logB);
        
        NSString *logS = [NSString stringWithUTF8String:logB];
        NSLog(@"shade compile failed: %@-----\n", logS);
        free(logB);
        exit(1);
        
    }
    return shader;
}

+ (GLuint)loadShaderWithType:(GLenum)type fromFilePath:(NSString *)path{
    NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return [self loadShaderWithType:type fromString:source];
}
@end

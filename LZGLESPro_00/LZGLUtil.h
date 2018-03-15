//
//  LZGLUtil.h
//  LZGLESPro_00
//
//  Created by comst on 2018/3/15.
//  Copyright © 2018年 comst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
@interface LZGLUtil : NSObject

+(GLuint)loadShaderWithType:(GLuint)type fromString:(NSString *)source;
+(GLuint)loadShaderWithType:(GLuint)type fromFilePath:(NSString *)path;
@end

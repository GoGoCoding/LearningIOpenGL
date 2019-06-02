//
//  GLESUtils.h
//  OpenGL ES-01
//
//  Created by 郝琦 on 2019/5/19.
//  Copyright © 2019 GoGoCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLESUtils : NSObject
// Create a shader object, load the shader source string, and compile the shader.

+(GLuint) loadShader:(GLenum)type withString:(NSString *)shaderString;

+(GLuint) loadShader:(GLenum)type withFilePath:(NSString *)shaderFilePath;
@end

NS_ASSUME_NONNULL_END

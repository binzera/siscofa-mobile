//
//  Criptografia.h
//  ConsultaRestituicao
//
//  Created by Robson Ximenes on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "Base64.h"

@interface Criptografia : NSObject

+(NSString *) codificarSha1EmBase64:(NSString *)textoBruto;
+(NSString *) codificarHmacAlgSHA1:(NSString *)chave :(NSString*)mensagem;
+(void)test;
+(NSString *) codificarMD5:(NSString *) mensagem;
@end

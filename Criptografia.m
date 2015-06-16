//
//  Criptografia.m
//  ConsultaRestituicao
//
//  Created by Robson Ximenes on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Criptografia.h"

@implementation Criptografia


+(NSString *)codificarSha1EmBase64:(NSString *)textoBruto{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    const char *cStr = [textoBruto UTF8String];
    CC_SHA1(cStr, strlen(cStr), result); 
    NSData *pwHashData = [[NSData alloc] initWithBytes:result length: sizeof result];  
    NSString *base64 = [Base64 encode:pwHashData];  
    return  base64;
}

+(NSString *) codificarHmacAlgSHA1:(NSString *)chave :(NSString*)mensagem
{
    const char *cKey  = [chave cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [mensagem cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString   stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    
    NSLog(@"HMAC em hex %@",hash);    
    return hash;
}

+ (NSString *) codificarMD5:(NSString *)mensagem{
    const char *cStr = [mensagem UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02x", digest[i]];
    
    return  hash;
}


+(void)test
{
    //Assert.assertEquals("9baed91be7f58b57c824b60da7cb262b2ecafbd2", Hash.generateHash("secret", "foo"));
    
    NSString *key =  @"shienshenlhq";
    NSString *data = @"foo";
    NSString *digestAnswerHMAC =@"9baed91be7f58b57c824b60da7cb262b2ecafbd2";
    NSString *digestAnswerSHA1HEX =@"9baed91be7f58b57c824b60da7cb262b2ecafbd2";
    //NSData *stringBytes = [key dataUsingEncoding: NSUTF8StringEncoding]; 
    
    NSString *hash = [Criptografia codificarHmacAlgSHA1:key :data];
    
    NSLog(@"testing encryptions");
    NSLog(@"testing HMAC encryptions is :\n%@ should be :\n%@",hash,digestAnswerHMAC);
    NSLog(@"testing SHA1 in HEX encryption is :\n%@ should be :\n%@",[Criptografia codificarSha1EmBase64:hash],digestAnswerSHA1HEX);
    NSLog(@"testing sha1 in 64 1234 is %@ and should be cRDtpNCeBiql5KOQsKVyrA0sAiA=",[Criptografia codificarSha1EmBase64:@"1234"]);
}


@end

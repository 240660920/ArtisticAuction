//
//  RSADataSigner.m
//  SafepayService
//
//  Created by wenbi on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSADataSigner.h"
#import "openssl_wrapper.h"
#import "NSDataEx.h"

@implementation RSADataSigner

- (id)initWithPrivateKey:(NSString *)privateKey {
	if (self = [super init]) {
		_privateKey = [privateKey copy];
	}
	return self;
}

- (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}


- (NSString *)formatPrivateKey:(NSString *)privateKey {
    const char *pstr = [privateKey UTF8String];
    int len = [privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
    int index = 0;
	int count = 0;
    while (index < len) {
        char ch = pstr[index];
		if (ch == '\r' || ch == '\n') {
			++index;
			continue;
		}
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
			count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PRIVATE KEY-----"];
    return result;
}

- (NSString *)formatPublicKey:(NSString *)publicKey
{
    const char *pstr = [publicKey UTF8String];
    int len = [publicKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 79)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END PUBLIC KEY-----"];
    return result;

}

- (NSString *)algorithmName {
	return @"RSA";
}

//该签名方法仅供参考,外部商户可用自己方法替换
- (NSString *)signString:(NSString *)string {
	
	//在Document文件夹下创建私钥文件
	NSString * signedString = nil;
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [documentPath stringByAppendingPathComponent:@"AlixPay-RSAPrivateKey"];
	
	//
	// 把密钥写入文件
	//
	NSString *formatKey = [self formatPrivateKey:_privateKey];
	[formatKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
	unsigned int sig_len;
    int ret = rsa_sign_with_private_key_pem((char *)message, messageLength, sig, &sig_len, (char *)[path UTF8String]);
	//签名成功,需要给签名字符串base64编码和UrlEncode,该两个方法也可以根据情况替换为自己函数
    if (ret == 1) {
        NSString * base64String = base64StringFromData([NSData dataWithBytes:sig length:sig_len]);
		//NSData * UTF8Data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
		signedString = [self urlEncodedString:base64String];
    }
    
	free(sig);
    return signedString;
}

-(NSString *)verifySignString:(NSString *)string
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"AlixPay-RSAPublicKey"];
    
    NSString *_publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZhgXDBeEiPzQ1VoNBiZnw/Z3RyZjl2p1tKbMHtrgBnrMH9errTwU17z7CT0Dq3HOzq5QhGISHgHPnGTvgcpkbjRqcy/WY4id8HmLfW0ksfsTYZHYtnUU642fwYxu8bEu8V/+6mf+ZR2iNKfHBzYamHvOODu4K1YTuEtysMyt/jQIDAQAB";
    NSString *publicKey = [self formatPublicKey:_publicKey];
    [publicKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = strlen(message);
    unsigned char *sig = [publicKey cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned int sig_length;
    int ret = rsa_verify_with_public_key_pem((char *)message, messageLength, sig, sig_length, (char *)[path UTF8String]);
    if (ret == 1) {
        NSString *str = [[NSString alloc]initWithData:[NSData dataWithBytes:sig length:sig_length] encoding:NSUTF8StringEncoding];
        return str;
    }
    return @"";
}

@end

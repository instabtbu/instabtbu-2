//
//  testc.c
//  instabtbu
//
//  Created by 杨培文 on 14/12/15.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

#include "testc.h"
#include "openssl/rsa.h"
#include "openssl/bn.h"

static char n[] = "EA32BA96FCC395CC766EAFFEBC8EFE1F0886E99504CB7C3877548698793446BA7BA07CF915DBB5BE69337A3697B4DC354DA78ABAE17ED33EDAD87674D0D0D2B54D549E566AF0C016C276F327ADC3D4EE06E64EBC608E4AC9E3CE63416C246FD57DBEA8ADA036AA683F9A812CD8ECA705E019D6A943121CDDB2CF9BF1BCD0F5F9";
static char e[] = "10001";

void rsajiami(const unsigned char* in,int size,unsigned char* out){
    RSA *a = RSA_new();
    BIGNUM *bn = BN_new();
    BN_hex2bn(&bn, n);
    BIGNUM *be = BN_new();
    BN_hex2bn(&be, e);
    a->e=be;a->n=bn;
    RSA_public_encrypt(size, in, out, a, RSA_PKCS1_PADDING);
}

void rsajiemi(const unsigned char* in,unsigned char* out){
    RSA *a = RSA_new();
    BIGNUM *bn = BN_new();
    BN_hex2bn(&bn, n);
    BIGNUM *be = BN_new();
    BN_hex2bn(&be, e);
    a->e=be;a->n=bn;
    RSA_public_decrypt(128, in, out, a, RSA_PKCS1_PADDING);
}
//
//  ytcp.h
//  instabtbu
//
//  Created by 杨培文 on 16/3/24.
//  Copyright © 2016年 instabtbu. All rights reserved.
//

#ifndef ytcp_h
#define ytcp_h

void ytcpsocket_set_block(int socket,int on);
int ytcpsocket_connect(const char *host,int port,int timeout);
int ytcpsocket_close(int socketfd);
int ytcpsocket_pull(int socketfd,const unsigned char *data,int len);
int ytcpsocket_send(int socketfd,const unsigned char *data,int len);
int ytcpsocket_listen(const unsigned char *addr,int port);
int ytcpsocket_accept(int onsocketfd,char *remoteip,int* remoteport);

int yudpsocket_server(const char *addr,int port);
int yudpsocket_recive(int socket_fd,const unsigned char *outdata,int expted_len,const char *remoteip,int* remoteport);
int yudpsocket_close(int socket_fd);
int yudpsocket_client();
int yudpsocket_get_server_ip(const char *host,const char *ip);
int yudpsocket_sentto(int socket_fd,const unsigned char *msg,int len, const char *toaddr, int topotr);



#endif /* ytcp_h */

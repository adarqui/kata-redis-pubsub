#include <stdio.h>
#include <unistd.h>
#include <hiredis/hiredis.h>

int main(int argc, char *argv[]){
		struct redisReply * rr = NULL;
		redisContext * sub, * pub;
		int ret = 0;

		sub = redisConnect("127.0.0.1", 6379);
		if(!sub && sub->err) {
				printf("c: [sub] Error connecting: %s\n", sub->errstr);
				exit(-1);
		}

		pub = redisConnect("127.0.0.1", 6379);
		if(!pub && pub->err) {
				printf("c: [pub] Error connecting: %s\n", pub->errstr);
				exit(-1);
		}

		rr = redisCommand(sub, "SUBSCRIBE %s %s", "ping", "vping");

		if(!rr) {
				printf("c: [sub] Failed to subscribe!\n");
				exit(-1);
		}


		printf("c: Connected & subscribed to redis\n");

		while(1) {

				ret = redisGetReply(sub,(void **)&rr);
				if(ret != REDIS_OK && rr->type != REDIS_REPLY_ARRAY) {
						goto cleanup;
				}

				redisReply * rr_ptr=NULL;
				char * response = "unknown";

				if(rr->elements < 3) continue;

				rr_ptr = rr->element[1];

				if(rr_ptr->str == NULL) goto cleanup;

				printf("c: Received packet => { channel : %s , message : %s }\n",
								rr_ptr->str, rr->element[2]->str);

				if(!strcasecmp(rr_ptr->str, "ping")) {
						response = rr->element[2]->str;
				}
				else if(!strcasecmp(rr_ptr->str, "vping")) {
						response = "c";
				}


				rr_ptr = redisCommand(pub, "PUBLISH %s %s", "pong", response);
				if(rr_ptr == NULL) {
						printf("c: [pub] Error!\n");
				} else {
						freeReplyObject(rr_ptr);
				}


				cleanup:
				if(rr) {
						freeReplyObject(rr);
				}
		}

		redisFree(pub);
		redisFree(sub);
}

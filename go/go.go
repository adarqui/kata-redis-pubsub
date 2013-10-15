package main

import (
		"fmt"
		"log"
		"menteslibres.net/gosexy/redis"
		)

func publish(red * redis.Client, channel string, response string) {
		red.Publish(channel, response)
}

func main() {

		pub := redis.New()

		err := pub.ConnectNonBlock("127.0.0.1", 6379)
		if err != nil {
			log.Fatalf("go: [pub] Connect failed: %s\n", err.Error())
		}

		sub := redis.New()
		err = sub.ConnectNonBlock("127.0.0.1", 6379)
		if err != nil {
			log.Fatalf("go: [sub] Connect failed: %s\n", err.Error())
		}


		rec := make(chan []string)

		go sub.Subscribe(rec, "ping")
		go sub.Subscribe(rec, "vping")

		for {
				packet := <-rec
				response := "unknown";
				fmt.Println("go: Received packet =>", packet)
				switch packet[1] {
						default : continue
						case "ping" :
								response = packet[2]
								break;
						case "vping" :
								response = "go"
								break;
				}

				publish(pub, "pong", response)
		}

		sub.Quit()
		pub.Quit()
}



#docker run -t -d --restart=always -p 127.0.0.1:2376:2375 --network jenkins -v /var/run/docker.sock:/var/run/docker.sock mgudik/flutter

docker run -i -d -t --rm --name agent --init mgudik/aarch64 java -jar /usr/share/jenkins/agent.jar
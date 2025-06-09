#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define PORT 12345

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    const char *message = "Ahoj ze strany klienta!";

    // Vytvoření socketu
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }

    // Nastavení adresy serveru
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr);

    // Blokující odeslání datagramu
    ssize_t sent = send(sockfd, message, strlen(message), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (sent < 0) {
        perror("sendto");
        close(sockfd);
        exit(1);
    }

    printf("Zpráva odeslána na server.\n");

    close(sockfd);
    return 0;
}

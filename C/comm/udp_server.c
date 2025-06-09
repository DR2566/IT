#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 12345
#define BUF_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUF_SIZE];
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);

    // Vytvoření socketu
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }

    // Nastavení adresy serveru
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;  // přijímá na všech IP
    server_addr.sin_port = htons(PORT);

    // Připojení socketu k portu
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(sockfd);
        exit(1);
    }

    printf("Server čeká na zprávu...\n");

    // Blokující příjem datagramu
    ssize_t n = recvfrom(sockfd, buffer, BUF_SIZE - 1, 0,
                         (struct sockaddr *)&client_addr, &client_len);
    if (n < 0) {
        perror("recvfrom");
        close(sockfd);
        exit(1);
    }

    buffer[n] = '\0';
    printf("Přijato od klienta: %s\n", buffer);

    close(sockfd);
    return 0;
}

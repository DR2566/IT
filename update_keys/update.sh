#!/bin/bash


# SONEX
=== Configuration ===
REMOTE_USER="dr"
REMOTE_HOST="sonex"
CURR_PID="$$"
KEY_ID="$(echo $USER)@$(hostname).$CURR_PID"
KEY_PATH="$HOME/.ssh/${REMOTE_HOST}.$KEY_ID"

# === Step 1: Generate RSA Key Pair ===

echo "[*] Generating RSA key pair..."
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "$KEY_ID"

# Set secure permissions for private key
chmod 600 "$KEY_PATH"

# === Step 2: Copy Public Key to Remote Server ===
echo "[*] Sending public key to $REMOTE_USER@$REMOTE_HOST..."
ssh-copy-id -i "${KEY_PATH}.pub" "$REMOTE_USER@$REMOTE_HOST"

sudo ssh-add "${KEY_PATH}"
# === Step 3: Test SSH login ===
echo "[*] Testing SSH login..."
ssh "$REMOTE_USER@$REMOTE_HOST" 'echo "✅ SSH login successful"'


# #=== Step 2: Delete old ssh key ===
# === Step 1: Get private and public key filenames, excluding those with $$ ===
# Match 'sonex' in the filename, but exclude process ID
SSH_DIR="$HOME/.ssh/"
PRIVATE_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep -v "pub" )
PUBLIC_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep "pub" )
OLD_KEY_PID=$(echo "$PRIVATE_KEY" | sed -E 's/.*\.(.*)$/\1/')

ssh "$REMOTE_USER@$REMOTE_HOST" "sed -i /${OLD_KEY_PID}/d ~/.ssh/authorized_keys"

ssh-add -d ${SSH_DIR}$PRIVATE_KEY
echo "removing ${SSH_DIR}$PRIVATE_KEY"
echo "removing ${SSH_DIR}$PUBLIC_KEY"
rm ${SSH_DIR}$PRIVATE_KEY
rm ${SSH_DIR}$PUBLIC_KEY




# AISA
# === Configuration ===
REMOTE_USER="xrocek"
REMOTE_HOST="aisa"
CURR_PID="$$"
KEY_ID="$(echo $USER)@$(hostname).$CURR_PID"
KEY_PATH="$HOME/.ssh/${REMOTE_HOST}.$KEY_ID"

# === Step 1: Generate RSA Key Pair ===

echo "[*] Generating RSA key pair..."
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "$KEY_ID"

# Set secure permissions for private key
chmod 600 "$KEY_PATH"

# === Step 2: Copy Public Key to Remote Server ===
echo "[*] Sending public key to $REMOTE_USER@$REMOTE_HOST..."
ssh-copy-id -i "${KEY_PATH}.pub" "$REMOTE_USER@$REMOTE_HOST"

sudo ssh-add "${KEY_PATH}"
# === Step 3: Test SSH login ===
echo "[*] Testing SSH login..."
ssh "$REMOTE_USER@$REMOTE_HOST" 'echo "✅ SSH login successful"'


# #=== Step 2: Delete old ssh key ===
# === Step 1: Get private and public key filenames, excluding those with $$ ===
# Match 'sonex' in the filename, but exclude process ID
SSH_DIR="$HOME/.ssh/"
PRIVATE_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep -v "pub" )
PUBLIC_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep "pub" )
OLD_KEY_PID=$(echo "$PRIVATE_KEY" | sed -E 's/.*\.(.*)$/\1/')

ssh "$REMOTE_USER@$REMOTE_HOST" "sed -i /${OLD_KEY_PID}/d ~/.ssh/authorized_keys"


ssh-add -d ${SSH_DIR}$PRIVATE_KEY
echo "removing ${SSH_DIR}$PRIVATE_KEY"
echo "removing ${SSH_DIR}$PUBLIC_KEY"
rm ${SSH_DIR}$PRIVATE_KEY
rm ${SSH_DIR}$PUBLIC_KEY


# ALTRADE
# === Configuration ===
REMOTE_USER="ubuntu"
REMOTE_HOST="algapia.zapto.org"
CURR_PID="$$"
KEY_ID="$(echo $USER)@$(hostname).$CURR_PID"
KEY_PATH="$HOME/.ssh/${REMOTE_HOST}.$KEY_ID"

# === Step 1: Generate RSA Key Pair ===

echo "[*] Generating RSA key pair..."
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "$KEY_ID"

# Set secure permissions for private key
chmod 600 "$KEY_PATH"

# === Step 2: Copy Public Key to Remote Server ===
echo "[*] Sending public key to $REMOTE_USER@$REMOTE_HOST..."
ssh-copy-id -i "${KEY_PATH}.pub" "$REMOTE_USER@$REMOTE_HOST"

sudo ssh-add "${KEY_PATH}"
# === Step 3: Test SSH login ===
echo "[*] Testing SSH login..."
ssh "$REMOTE_USER@$REMOTE_HOST" 'echo "✅ SSH login successful"'


# #=== Step 2: Delete old ssh key ===
# === Step 1: Get private and public key filenames, excluding those with $$ ===
# Match 'sonex' in the filename, but exclude process ID
SSH_DIR="$HOME/.ssh/"
PRIVATE_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep -v "pub" )
PUBLIC_KEY=$(cd "$SSH_DIR" && ls | grep -E "$REMOTE_HOST" | grep -v "$CURR_PID" | grep "pub" )
OLD_KEY_PID=$(echo "$PRIVATE_KEY" | sed -E 's/.*\.(.*)$/\1/')

ssh "$REMOTE_USER@$REMOTE_HOST" "sed -i /${OLD_KEY_PID}/d ~/.ssh/authorized_keys"


ssh-add -d ${SSH_DIR}$PRIVATE_KEY
echo "removing ${SSH_DIR}$PRIVATE_KEY"
echo "removing ${SSH_DIR}$PUBLIC_KEY"
rm ${SSH_DIR}$PRIVATE_KEY
rm ${SSH_DIR}$PUBLIC_KEY
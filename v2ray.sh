#!/bin/sh

# Set ARG
ARCH="64"
DOWNLOAD_PATH="/tmp/v2ray"

mkdir -p ${DOWNLOAD_PATH}
cd ${DOWNLOAD_PATH} || exit

TAG=$(wget --no-check-certificate -qO- https://api.github.com/repos/v2fly/v2ray-core/releases/latest | grep 'tag_name' | cut -d\" -f4)
if [ -z "${TAG}" ]; then
    echo "Error: Get v2ray latest version failed" && exit 1
fi
echo "The v2ray latest version: ${TAG}"

# Download files
V2RAY_FILE="v2ray-linux-${ARCH}.zip"
DGST_FILE="v2ray-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${V2RAY_FILE}"
echo "Downloading binary file: ${DGST_FILE}"

# TAG=$(wget -qO- https://raw.githubusercontent.com/v2fly/docker/master/ReleaseTag | head -n1)
wget -O ${DOWNLOAD_PATH}/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/${TAG}/${V2RAY_FILE} >/dev/null 2>&1
wget -O ${DOWNLOAD_PATH}/v2ray.zip.dgst https://github.com/v2fly/v2ray-core/releases/download/${TAG}/${DGST_FILE} >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${V2RAY_FILE} ${DGST_FILE}" && exit 1
fi
echo "Download binary file: ${V2RAY_FILE} ${DGST_FILE} completed"

# Check SHA512
LOCAL=$(openssl dgst -sha512 v2ray.zip | sed 's/([^)]*)//g')
STR=$(cat < v2ray.zip.dgst | grep 'SHA512' | head -n1)

if [ "${LOCAL}" = "${STR}" ]; then
    echo " Check passed" && rm -fv v2ray.zip.dgst
else
    echo " Check have not passed yet " && exit 1
fi

# Prepare
echo "Prepare to use"
unzip v2ray.zip && chmod +x v2ray v2ctl
mv v2ray v2ctl /usr/bin/
mv geosite.dat geoip.dat /usr/local/share/v2ray/
# mv config.json /etc/v2ray/config.json

# Set config file
cat <<EOF >/etc/v2ray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 443,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 0
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Clean
cd ~ || return
rm -rf ${DOWNLOAD_PATH:?}/*
echo "Install done"

echo "--------------------------------"
echo "Fly App Name: ${FLY_APP_NAME}"
echo "Fly App Region: ${FLY_REGION}"
echo "V2Ray UUID: ${UUID}"
echo "--------------------------------"

# Run v2ray
/usr/bin/v2ray -config /etc/v2ray/config.json

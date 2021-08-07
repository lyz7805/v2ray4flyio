# V2Ray4Fly.io

## 概述
通过 GitHub Actions 自动在 [Fly.io](https://fly.io/) 上部署 [V2Ray](https://www.v2fly.org/)

## 配置
1. GitHub Actions 增加`FLY_API_TOKEN`和`UUID`两个安全字段
* FLY_API_TOKEN - Fly API 接口 Token 值，可访问 <https://web.fly.io/user/personal_access_tokens> 或在本地执行`flyctl auth token`查看
* UUID - 供用户连接的 UUID，可通过 <http://www.uuid.online/> 或 <https://www.uuidgenerator.net/> 生成
2. 修改`fly.toml`文件中的`app`名称

## 部署
只要配置 GitHub Actions，将代码推送到仓库即可自动部署

## 客户端连接
* 协议（protocol） - vmess
* 地址（address） - [FLY_APP_NAME].fly.dev
* 端口（port） - 443
* 用户ID（id） - [UUID]
* 额外ID（alterId） - 64
* 传输协议（network） - ws
* 底层传输安全（tls) - tls

```json
{
  "inbounds": [],
  "outbounds": [
    {
      "tag": "proxy",
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "[FLY_APP_NAME].fly.dev",
            "port": 443,
            "users": [
              {
                "id": "[UUID]",
                "alterId": 64,
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true
        }
      }
    }
  ]
}
```

## 参考
* [V2Ray4Heroku](https://github.com/lyz7805/v2ray4heroku)

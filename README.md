> ！！！本仓库最开始只是为了 `git clone` 之后再 `push` 到个人仓库触发 Github Actions 自动构建的，没想到后来大家都直接 Fork 仓库，导致很多人提 Issue 说不会触发构建。
> 
> 在此，本人统一回复下：**Fork 后，配置完，最后也要 Push 一次代码才可触发构建**。

# V2Ray4Fly.io

## 概述
通过 GitHub Actions 自动在 [Fly.io](https://fly.io/) 上部署 [V2Ray](https://www.v2fly.org/)

## 配置部署
1. 先到 [Fly.io](https://fly.io/) 注册账号，***注意：注册时要记得绑定信用卡，银联的就行***
2. GitHub Actions 增加`FLY_API_TOKEN`、`APP_NAME`和`UUID`三个安全字段
* FLY_API_TOKEN - Fly API 接口 Token 值，可访问 <https://web.fly.io/user/personal_access_tokens> 或在本地执行`flyctl auth token`查看
* APP_NAME - 应用名称，注意此名称全局唯一
* UUID - 供用户连接的 UUID，可通过 <http://www.uuid.online/> 或 <https://www.uuidgenerator.net/> 生成
3. 推送代码即可触发部署，另外已设置每月一号四点（UTC）自动部署

## 客户端连接
* 协议（protocol） - vmess
* 地址（address） - [APP_NAME].fly.dev
* 端口（port） - 443
* 用户ID（id） - [UUID]
* 额外ID（alterId） - 0 （！！！）
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
            "address": "[APP_NAME].fly.dev",
            "port": 443,
            "users": [
              {
                "id": "[UUID]",
                "alterId": 0,
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

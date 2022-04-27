# :u7981:	 紧急提醒 :exclamation::exclamation::exclamation:
2022年4月27日 03：59 收到 Fly.io 官方邮件，邮件正文和 Issue https://github.com/lyz7805/v2ray4flyio/issues/22 中的一致。

邮件解读：**Fly.io 免费版不允许安装 V2Ray 此类代理，只能用于 Web 应用。只有付费套餐才能用，要是还想用，那就得升级套餐，而且人家还给自动升级到 10 美元、月。如果不想升级，那就得在 24 小时内删除应用。**

## 如何应对？
- 如果您准备用付费套餐（10 美元/月），可以无视此次提醒。
- 但是如果您不准备付费，最好按照官方提示删除应用。如果没有及时删除，那等待你的只能是**信用卡扣费账单**啦。

  删除操作有两种：
    1. 浏览器打开 [Web 控制台](https://fly.io/apps)，点击进入对应应用，点击【Settings】标签，点击【Delete】按钮进行删除。
    2. 通过命令行进行操作，此操作需要在本地安装 `flyctl` 命令行并登录，之后允许命令 `flyctl apps destroy [APP_NAME]` 也能删除对应应用。

  ---
  不想删除的同学，根据 https://github.com/lyz7805/v2ray4flyio/issues/22 那个朋友所说猜测：暂时官方应该只对**香港**的节点发警告了，可以将节点切到其他节点试试。
  > 此操作暂未测试证实，请慎重，不保证您一定躲过本次风波！！
    1. 将 `deploy.sh` 文件第 5 行区域代码改为其他区域代码，区域代码请参考官方文档 https://fly.io/docs/reference/regions/ ；
      https://github.com/lyz7805/v2ray4flyio/blob/f6e6ecbe916ca4bd516e82255b12dc1b2f45aaf0/deploy.sh#L5
    2. 将最新代码提交触发再次构建。

---

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

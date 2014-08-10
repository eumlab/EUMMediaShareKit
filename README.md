EUMMediaShareKit
================

使用MSShareController类进行video和audio的分享.

如果需要soundcloud或者youtube分享, 需要配置相关的clientKey,配置方式是继承DefaultSHKConfigurator类, 重写相关的值, 并在appDelegate里进行初始化.
具体的解释见:https://github.com/ShareKit/ShareKit/wiki/Configuration, 或者查看项目里的配置(ULShareKitConfigurator类).

import UIKit

class APILoader: NSObject {
    func loadPrivateConstant() {
        /*
        
        注意：
        'PrivateConstant.swift' 不包含在项目中，因为他包含了MC服务器不对外公开的接口。
        NyaaCat 服务器并非为所有人开放，请勿传播此服务器的接口。
        如果你刚从Github下载这个项目，你会收到一个缺失类的错误。
        你可以参照下面的示例创建一个新的 'PrivateConstant.swift'，
        替换里面的的'???'为你自己的动态地图网址，并填写相关的具体参数。
        
        Warning:
        'PrivateConstant' Is a closed source class
        'PrivateConstant.swift' Demo:
        
        */
        /*
        
        import UIKit
        class PrivateConstant: NSObject {
        let PrivateConstant:Dictionary<String,String> = [
        "动态地图域名":"https://???",
        "动态地图主页":"https://???/index.html",
        "动态地图登录接口":"https://???/up/login",
        "32px头像接口":"https://???/tiles/faces/32x32/",
        "消息发送接口":"https://???/up/sendmessage",
        "论坛地址":"https://???",
        "测试动态地图用户名":"username",
        "测试动态地图密码":"password",
        "静态地图接口":"https://???/?worldname=???&mapname=???&zoom=0&nogui=true",
        "注册页面标题":"Login/Register",
         "地图页面标题":"my world",
         "Ilse地图":"http://???",
         "关于和许可":"https://???/README.html",
         "游戏直播":"https://???/LIVE.html"],
         "API域名":"https://???.com"
         "API路径":"https://???.com/api/"
        }
        
        */
        
        //在未补充 'PrivateConstant.swift' 的情况下，此行代码会被标记为 error ：
        let PrivateConstantData:Dictionary<String,String> = PrivateConstant().PrivateConstantData
        
        全局_喵窩API = PrivateConstantData
    }
}

# flutter_xjy_app
在原生工程里集成了 flutter 模块


集成按照 flutter 官方 wiki （https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps）文档描述，
集成过程中有几个坑：

###  Android 集成

集成过程还好吧，主要是 H5 对 Android 不熟悉，遇见的问题：
1. 允许网络访问权限
`app/src/main/AndroidManifest.xml`


```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.jd.zhaohongyun1.nativeapp">

    <uses-permission android:name="android.permission.INTERNET"/> //加上这一句

    <application
        android:name="io.flutter.app.FlutterApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme"
        tools:ignore="GoogleAppIndexingWarning">
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name"
            android:theme="@style/AppTheme.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```
2. 不要请求 localhost 接口。。。
3. 尽量真机调试



### Ios 集成

1. Podfile 设置
```
//  这里的 'path/to/flutter_app/' 是 flutter 模块的绝对路径
flutter_application_path = 'path/to/flutter_app/' 
  eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)
```
2. Enable Bitcode 设置为 NO
Build Settings --> Build Options --> Enable Bitcode


3. 如果中途更改过工程的文件名称或工程的文件路径，build 或报错 文件找不到
这种问题需要手动改一下文件路径

位置：Build Settings --> User-Defined 下面有`FLUTTER_APPLICATION_PATH`、`FLUTTER_ROOT` 等变量的值

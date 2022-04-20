package com.tn.tnsocialpro;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterPluginSendToAct implements MethodChannel.MethodCallHandler {

    public static String CHANNEL = "com.demo.testphone";

    static MethodChannel channel;

    private Activity activity;

    public FlutterPluginSendToAct(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        FlutterPluginSendToAct instance = new FlutterPluginSendToAct(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        //接收来自flutter的指令
        if (call.method.equals("methodChannelphone")) {
//            String str = call.argument("text");
//            //返回给flutter的参数
//            result.success("收到Flutter的消息" + str +" ，返回消息给Flutter!");
            if (!isExistIndexActivity(activity)) {
                //打开自定义的Activity
                Intent intentReceive = new Intent(activity, MainActivity.class);
                intentReceive.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
                intentReceive.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                intentReceive.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                intentReceive.setPackage("com.xrd.limaoniao");
                activity.startActivity(intentReceive);
            }
        }
    }

    private boolean isExistIndexActivity(Context mContext) {
        Intent intent = new Intent(mContext, MainActivity.class);
        ComponentName cmpName = intent.resolveActivity(mContext.getPackageManager());
        boolean flag = false;
        if (null != cmpName) {
            // 说明系统中存在这个activity
            ActivityManager am = (ActivityManager)mContext.getSystemService(mContext.ACTIVITY_SERVICE);
            List<ActivityManager.RunningTaskInfo> taskInfoList = am.getRunningTasks(10);
            //获取从栈顶开始往下查找的10个activity
            for (ActivityManager.RunningTaskInfo taskInfo : taskInfoList) {
                if(taskInfo.equals(cmpName)){
                    // 说明它已经启动了
                    flag = true;
                }
            }
        }
        return flag;
    }
}


package com.aniu.flutter.muscio.nuitr;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.widget.Toast;


import androidx.annotation.NonNull;



import java.lang.ref.WeakReference;
import java.util.Objects;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import plugins.UsbPlugin;

public class MainActivity extends FlutterActivity {


    public static UsbPlugin usbPlugin;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        usbPlugin = new UsbPlugin();
        flutterEngine.getPlugins().add(usbPlugin);
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        //解决从后台切换到前台flutter黑屏的问题
        Objects.requireNonNull(getFlutterEngine()).getLifecycleChannel().appIsResumed();
    }

}
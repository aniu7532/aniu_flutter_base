package com.aniu.flutter.muscio.nuitr;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import androidx.annotation.CallSuper;
import androidx.annotation.RequiresApi;

import com.cdhwkj.basecore.application.BaseApplication;
import com.cdhwkj.basecore.notification.NotificationChannelBean;
import com.cdhwkj.basecore.util.AndroidVersionUtils;

import io.flutter.view.FlutterMain;

/**
 * author:created by Deng Donglin on 2019/7/11 16:20
 * E-Mail:dengdonglin@cdhwkj.cn
 * description:
 */
public class MyApplication extends BaseApplication {
    public static final String CHANNEL_NAME_1 = "cha_name_rmis";
    public static final String CHANNEL_ID_1 = "cha_id_rmis";
    public static final String CHANNEL_GROUP_NAME_1 = "cha_group_rmis";
    public static final String CHANNEL_DES_1 = "关于RMIS的通知通道";

    public static final NotificationChannelBean NOTIFICATION_CHANNEL_BEAN_1 =
            new NotificationChannelBean(CHANNEL_ID_1, CHANNEL_NAME_1,
                    CHANNEL_DES_1, CHANNEL_GROUP_NAME_1);

    private Activity mCurrentActivity = null;
    @Override
    protected void initNotification() {
        if (AndroidVersionUtils.isAndroid8_0Plus()) {
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                notificationManager.createNotificationChannel(initNotificationChannel1(notificationManager, NOTIFICATION_CHANNEL_BEAN_1));
            }
        }
    }

    /**
     * @param notificationManager
     * @param channelBean
     * @return
     */
    @RequiresApi(api = Build.VERSION_CODES.O)
    protected NotificationChannel initNotificationChannel1(NotificationManager notificationManager, NotificationChannelBean channelBean) {
        NotificationChannel channel = new NotificationChannel(channelBean.getChannelId(),
                channelBean.getChannelName(), NotificationManager.IMPORTANCE_HIGH);
        if (notificationManager != null) {
            channel.setDescription(channelBean.getChannelDes());
            channel.enableLights(true);//闪光灯
            channel.setLockscreenVisibility(Notification.VISIBILITY_SECRET);//设置是否应在锁定屏幕上显示此频道的通知
            channel.setLightColor(Color.RED);
            channel.enableVibration(true);
            channel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
            channel.setShowBadge(false);
            channel.setImportance(NotificationManager.IMPORTANCE_HIGH);//是否会有灯光
        }
        return channel;
    }
    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    public Activity getCurrentActivity() {
        return this.mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }
}

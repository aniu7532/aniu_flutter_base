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
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
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

    /*
     * Notifications from VirtuallyUsbService will be received here.
     */
    private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            switch (intent.getAction()) {
                case VirtuallyUsbService.ACTION_USB_PERMISSION_GRANTED: // USB PERMISSION GRANTED
                    Toast.makeText(context, "USB Ready", Toast.LENGTH_SHORT).show();
                    Pub.g_bIsConn = true;
                    break;
                case VirtuallyUsbService.ACTION_USB_PERMISSION_NOT_GRANTED: // USB PERMISSION NOT GRANTED
                    Toast.makeText(context, "USB Permission not granted", Toast.LENGTH_SHORT).show();
                    break;
                case VirtuallyUsbService.ACTION_NO_USB: // NO USB CONNECTED
                    Toast.makeText(context, "No USB connected", Toast.LENGTH_SHORT).show();
                    Pub.g_bIsConn = false;
                    break;
                case VirtuallyUsbService.ACTION_USB_DISCONNECTED: // USB DISCONNECTED
                    Toast.makeText(context, "USB disconnected", Toast.LENGTH_SHORT).show();
                    Pub.g_bIsConn = false;
                    break;
                case VirtuallyUsbService.ACTION_USB_NOT_SUPPORTED: // USB NOT SUPPORTED
                    Toast.makeText(context, "USB device not supported", Toast.LENGTH_SHORT).show();
                    break;
            }
        }
    };
    private VirtuallyUsbService virtuallyUsbService;

    private MyHandler mHandler;

    private final ServiceConnection usbConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName arg0, IBinder arg1) {
            virtuallyUsbService = ((VirtuallyUsbService.UsbBinder) arg1).getService();
            virtuallyUsbService.setHandler(mHandler);
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            virtuallyUsbService = null;
        }
    };


    @Override
    public void onResume() {
        super.onResume();
        mHandler = new MyHandler(this);
        setFilters();  // Start listening notifications from VirtuallyUsbService
        startService(VirtuallyUsbService.class, usbConnection, null); // Start VirtuallyUsbService(if it was not started before) and Bind it
    }

    @Override
    public void onPause() {
        super.onPause();
        unregisterReceiver(mUsbReceiver);
        unbindService(usbConnection);
    }

    private void startService(Class<?> service, ServiceConnection serviceConnection, Bundle extras) {
        if (!VirtuallyUsbService.SERVICE_CONNECTED) {
            Intent startService = new Intent(this, service);
            if (extras != null && !extras.isEmpty()) {
                Set<String> keys = extras.keySet();
                for (String key : keys) {
                    String extra = extras.getString(key);
                    startService.putExtra(key, extra);
                }
            }
            startService(startService);
        }
        Intent bindingIntent = new Intent(this, service);
        bindService(bindingIntent, serviceConnection, Context.BIND_AUTO_CREATE);
    }

    private void setFilters() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(VirtuallyUsbService.ACTION_USB_PERMISSION_GRANTED);
        filter.addAction(VirtuallyUsbService.ACTION_NO_USB);
        filter.addAction(VirtuallyUsbService.ACTION_USB_DISCONNECTED);
        filter.addAction(VirtuallyUsbService.ACTION_USB_NOT_SUPPORTED);
        filter.addAction(VirtuallyUsbService.ACTION_USB_PERMISSION_NOT_GRANTED);
        registerReceiver(mUsbReceiver, filter);
    }

    /*
     * This handler will be passed to VirtuallyUsbService. Data received from serial port is displayed through this handler
     */
    private static class MyHandler extends Handler {
        private final WeakReference<MainActivity> mActivity;

        public MyHandler(MainActivity activity) {
            mActivity = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case VirtuallyUsbService.MESSAGE_FROM_SERIAL_PORT:
                    String data = (String) msg.obj;
                    if(usbPlugin !=null){
                        usbPlugin.callGetCode(data);
                    }
                    break;
                case VirtuallyUsbService.CTS_CHANGE:
                    Toast.makeText(mActivity.get(), "CTS_CHANGE",Toast.LENGTH_LONG).show();
                    break;
                case VirtuallyUsbService.DSR_CHANGE:
                    Toast.makeText(mActivity.get(), "DSR_CHANGE",Toast.LENGTH_LONG).show();
                    break;
            }
        }
    }

    //  private TextView display;
    //  private EditText editText;
    //   private static CheckBox chbHexIn;
    //   private static CheckBox chbHexout;
  /*  @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_usb);



        display = (TextView) findViewById(R.id.textView1);
        editText = (EditText) findViewById(R.id.editText1);
        Button sendButton = (Button) findViewById(R.id.buttonSend);
        Button clearButton = (Button) findViewById(R.id.buttonClear);
        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!editText.getText().toString().equals("")) {
                    String data = editText.getText().toString();
                    if (virtuallyUsbService != null) { // if VirtuallyUsbService was correctly binded, Send data
                        if(chbHexIn.isChecked()){
                            SimpleDateFormat sDateFormat = new SimpleDateFormat("hh:mm:ss.SSS");
                            String sRecTime = sDateFormat.format(new java.util.Date());
                            Log.d("usbCDCDemo", "qutu-开始发送指令： "+ sRecTime);
                            virtuallyUsbService.write(HexUtil.decodeHex(data.replaceAll(" ", "")));
                        } else {
                            virtuallyUsbService.write(data.getBytes());
                        }
                    }
                }
            }
        });

        clearButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                display.setText("");

            }
        });

        chbHexIn = findViewById(R.id.checkBox);
        chbHexIn.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){
            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                // TODO Auto-generated method stub
                if(isChecked){
                    Log.d("testponint","hex in checked");
                }else{
                    Log.d("testponint","hex in unchecked");
                }
            }
        });
        chbHexout = findViewById(R.id.checkBox2);
        chbHexout.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){
            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                // TODO Auto-generated method stub
                if(isChecked){
                    Log.d("testponint","hex out checked");
                }else{
                    Log.d("testponint","hex out unchecked");
                }
            }
        });
    }
*/

}
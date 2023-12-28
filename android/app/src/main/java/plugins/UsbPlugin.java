package plugins;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class UsbPlugin implements FlutterPlugin {
    private static final String CHANNEL = "CHANEL_NAME_USB_SCAN";
    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        // 声明通道，第二个参数 name 要和 Flutter 中定义的通道名称保持一致
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
        // 在此通道上注册方法调用将要处理的功能(函数)
        methodChannel.setMethodCallHandler(this::onMethodCall);
    }

    private void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        // call.method 回调中的方法名，要和在 Flutter 中定义的保持一致
        switch (methodCall.method) {
            case "install":
                break;
            case "other":
                break;
            default:
                // 如果回调异常，则设置相关信息
                result.error("错误码","错误信息","错误详情");
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }



    public  void callGetCode(String code){
        methodChannel.invokeMethod("getUsbQrcode",code);
    }
}





package com.craftsilicon.hfbbank

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import android.view.WindowManager.LayoutParams
import com.example.icebergocr.IcebergSDK
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "native_bridge")
            .setMethodCallHandler { call, result ->
                if (call.method == "getPlatformVersion") {

                    getPlatformVersionFromKotlinNative()

                } else {
                    result.notImplemented()
                }
            }

        window.addFlags(LayoutParams.FLAG_SECURE)
    }


    fun ocrInit() {

    }

    private fun getPlatformVersionFromKotlinNative() {

        IcebergSDK.Builder(this)
            .ActionType("idFront")
            .Country("UGANDA")
            .ScanDoneClass(OCRResultActivity::class.java)
            .AppName("HFB")
            .init()
        // Your Kotlin Native method implementation goes here
//        return "Kotlin Native Version"
    }

}

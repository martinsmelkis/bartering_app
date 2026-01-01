package org.barter.barterapp.barter_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "org.barter.barterapp.barter_app/integrity"
    private lateinit var integrityHelper: IntegrityHelper

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        integrityHelper = IntegrityHelper(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSignature" -> {
                    val signature = integrityHelper.getSignatureSHA256()
                    if (signature != null) {
                        result.success(signature)
                    } else {
                        result.error("UNAVAILABLE", "Could not get signature", null)
                    }
                }

                "getInstallSource" -> {
                    val source = integrityHelper.getInstallSource()
                    result.success(source)
                }

                "isDeviceRooted" -> {
                    val isRooted = integrityHelper.isDeviceRooted()
                    result.success(isRooted)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

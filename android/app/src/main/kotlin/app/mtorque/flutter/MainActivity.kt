package app.mtorque.flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var soundBridge: MtorqueSoundBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        soundBridge = MtorqueSoundBridge(this).also {
            it.register(flutterEngine.dartExecutor.binaryMessenger)
        }
    }

    override fun onDestroy() {
        soundBridge?.dispose()
        soundBridge = null
        super.onDestroy()
    }
}
package app.mtorque.flutter

import android.content.Context
import android.media.AudioManager
import android.media.ToneGenerator
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MtorqueSoundBridge(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    private var tone: ToneGenerator? = null
    private var metronomeEngine: MetronomeSoundEngine? = null
    private var channel: MethodChannel? = null

    fun register(messenger: BinaryMessenger) {
        tone = ToneGenerator(AudioManager.STREAM_MUSIC, 80)
        channel = MethodChannel(messenger, "mtorque/sound").also {
            it.setMethodCallHandler(this)
        }
    }

    fun dispose() {
        try {
            metronomeEngine?.stop()
        } catch (_: Throwable) {
        }
        try {
            metronomeEngine?.release()
        } catch (_: Throwable) {
        }
        metronomeEngine = null

        try {
            tone?.release()
        } catch (_: Throwable) {
        }
        tone = null

        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "timerBeep" -> {
                playTimerBeep()
                result.success(null)
            }

            "timerDone" -> {
                playTimerDone()
                result.success(null)
            }

            "metronomeStartLoop" -> {
                val concentricMs = call.argument<Int>("concentricMs")?.toLong() ?: 1500L
                val holdTopMs = call.argument<Int>("holdTopMs")?.toLong() ?: 0L
                val eccentricMs = call.argument<Int>("eccentricMs")?.toLong() ?: 1500L
                val holdBottomMs = call.argument<Int>("holdBottomMs")?.toLong() ?: 0L

                startMetronomeLoop(
                    concentricMs = concentricMs,
                    holdTopMs = holdTopMs,
                    eccentricMs = eccentricMs,
                    holdBottomMs = holdBottomMs
                )
                result.success(null)
            }

            "metronomeStopLoop" -> {
                stopMetronomeLoop()
                result.success(null)
            }

            "getMetronomePositionMs" -> {
                val position = try {
                    metronomeEngine?.getPositionMs() ?: 0L
                } catch (_: Throwable) {
                    0L
                }
                result.success(position.toInt())
            }

            else -> result.notImplemented()
        }
    }

    private fun playTimerBeep() {
        try {
            tone?.startTone(ToneGenerator.TONE_PROP_BEEP, 130)
        } catch (_: Throwable) {
        }
    }

    private fun playTimerDone() {
        try {
            tone?.startTone(ToneGenerator.TONE_PROP_ACK, 220)
        } catch (_: Throwable) {
        }
    }

    private fun startMetronomeLoop(
        concentricMs: Long,
        holdTopMs: Long,
        eccentricMs: Long,
        holdBottomMs: Long
    ) {
        stopMetronomeLoop()

        try {
            metronomeEngine = MetronomeSoundEngine(context).also {
                it.startLoop(
                    concentricMs = concentricMs,
                    holdTopMs = holdTopMs,
                    eccentricMs = eccentricMs,
                    holdBottomMs = holdBottomMs
                )
            }
        } catch (_: Throwable) {
            try {
                metronomeEngine?.release()
            } catch (_: Throwable) {
            }
            metronomeEngine = null
        }
    }

    private fun stopMetronomeLoop() {
        try {
            metronomeEngine?.stop()
        } catch (_: Throwable) {
        }
        try {
            metronomeEngine?.release()
        } catch (_: Throwable) {
        }
        metronomeEngine = null
    }
}
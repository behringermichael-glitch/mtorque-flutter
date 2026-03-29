package app.mtorque.flutter

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import kotlin.math.PI
import kotlin.math.sin

class MetronomeSoundEngine(private val ctx: Context) {

    private var track: AudioTrack? = null
    private var cycleMs: Long = 1L
    private var sampleRate: Int = 48000
    private var totalSamples: Int = 1

    fun startLoop(
        concentricMs: Long,
        holdTopMs: Long,
        eccentricMs: Long,
        holdBottomMs: Long
    ) {
        stop()
        release()

        val phases = listOf(
            Phase(Kind.CONCENTRIC, concentricMs.coerceAtLeast(0L)),
            Phase(Kind.HOLD_TOP, holdTopMs.coerceAtLeast(0L)),
            Phase(Kind.ECCENTRIC, eccentricMs.coerceAtLeast(0L)),
            Phase(Kind.HOLD_BOTTOM, holdBottomMs.coerceAtLeast(0L))
        ).filter { it.ms > 0L }

        cycleMs = phases.sumOf { it.ms }.coerceAtLeast(1L)

        val am = ctx.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val native = try {
            am.getProperty(AudioManager.PROPERTY_OUTPUT_SAMPLE_RATE)?.toInt()
        } catch (_: Throwable) {
            null
        }
        sampleRate = (native ?: 48000).coerceIn(22050, 96000)
        totalSamples = ((cycleMs * sampleRate) / 1000L).toInt().coerceAtLeast(1)

        val buffer = ShortArray(totalSamples)

        val beepLenMs = 70L
        val beepLenSamples = ((beepLenMs * sampleRate) / 1000L).toInt().coerceAtLeast(1)

        val nLow = Note(freq = 523.25, gain = 1.20)
        val nMid = Note(freq = 659.25, gain = 1.00)
        val nHigh = Note(freq = 783.99, gain = 0.92)

        val events = mutableListOf<Event>()

        fun addEventAt(msFromStart: Long, note: Note) {
            val s = ((msFromStart * sampleRate) / 1000L).toInt().coerceIn(0, totalSamples - 1)
            events.add(Event(s, note.freq, note.gain))
        }

        var t0 = 0L
        for (ph in phases) {
            when (ph.kind) {
                Kind.CONCENTRIC -> {
                    addEventAt(t0, nLow)
                    addEventAt(t0 + ph.ms / 2L, nMid)
                    addEventAt(t0 + ph.ms, nHigh)
                }
                Kind.HOLD_TOP -> {
                    addEventAt(t0, nHigh)
                }
                Kind.ECCENTRIC -> {
                    addEventAt(t0, nHigh)
                    addEventAt(t0 + ph.ms / 2L, nMid)
                    addEventAt(t0 + ph.ms, nLow)
                }
                Kind.HOLD_BOTTOM -> {
                    addEventAt(t0, nLow)
                }
            }
            t0 += ph.ms
        }

        val uniq = events
            .sortedWith(compareBy<Event> { it.sampleIndex }.thenBy { it.freq }.thenBy { it.gain })
            .fold(mutableListOf<Event>()) { acc, e ->
                val last = acc.lastOrNull()
                if (last != null &&
                    last.sampleIndex == e.sampleIndex &&
                    last.freq == e.freq &&
                    last.gain == e.gain
                ) {
                    acc
                } else {
                    acc.apply { add(e) }
                }
            }

        for (e in uniq) {
            mixSineBeep(
                buffer = buffer,
                start = e.sampleIndex,
                length = beepLenSamples,
                freq = e.freq,
                gain = e.gain,
                sr = sampleRate
            )
        }

        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()

        val fmt = AudioFormat.Builder()
            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
            .setSampleRate(sampleRate)
            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
            .build()

        val t = AudioTrack.Builder()
            .setAudioAttributes(attrs)
            .setAudioFormat(fmt)
            .setBufferSizeInBytes(buffer.size * 2)
            .setTransferMode(AudioTrack.MODE_STATIC)
            .build()

        t.write(buffer, 0, buffer.size)
        t.setLoopPoints(0, buffer.size, -1)
        t.play()
        try {
            t.setVolume(1.0f)
        } catch (_: Throwable) {
        }

        track = t
    }

    fun getPositionMs(): Long {
        val t = track ?: return 0L
        val head = try {
            t.playbackHeadPosition
        } catch (_: Throwable) {
            0
        }
        val posSamples = head % totalSamples
        return (posSamples.toLong() * 1000L) / sampleRate.toLong()
    }

    fun stop() {
        try {
            track?.pause()
        } catch (_: Throwable) {
        }
        try {
            track?.flush()
        } catch (_: Throwable) {
        }
        try {
            track?.stop()
        } catch (_: Throwable) {
        }
    }

    fun release() {
        try {
            track?.release()
        } catch (_: Throwable) {
        }
        track = null
    }

    private fun mixSineBeep(
        buffer: ShortArray,
        start: Int,
        length: Int,
        freq: Double,
        gain: Double,
        sr: Int
    ) {
        val end = (start + length).coerceAtMost(buffer.size)
        if (start >= end) return

        val baseAmp = 0.32
        val amp = (baseAmp * gain).coerceIn(0.0, 0.95)
        val fade = (0.12 * length).toInt().coerceAtLeast(1)

        for (i in start until end) {
            val local = i - start
            val t = local.toDouble() / sr.toDouble()
            var a = amp
            if (local < fade) a *= local.toDouble() / fade.toDouble()
            val tail = end - i - 1
            if (tail < fade) a *= tail.toDouble() / fade.toDouble()

            val v = sin(2.0 * PI * freq * t) * a
            val mixed = buffer[i].toInt() + (v * Short.MAX_VALUE).toInt()
            buffer[i] = mixed.coerceIn(
                Short.MIN_VALUE.toInt(),
                Short.MAX_VALUE.toInt()
            ).toShort()
        }
    }

    private data class Note(val freq: Double, val gain: Double)
    private data class Event(val sampleIndex: Int, val freq: Double, val gain: Double)
    private data class Phase(val kind: Kind, val ms: Long)
    private enum class Kind { CONCENTRIC, HOLD_TOP, ECCENTRIC, HOLD_BOTTOM }
}
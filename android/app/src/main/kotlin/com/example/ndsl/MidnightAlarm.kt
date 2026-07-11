package com.example.ndsl

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import java.util.Calendar

/**
 * Inexact alarm at the next local midnight. Fires the shared Dart rollover
 * (uncheck all, settle streak) headlessly and re-arms itself.
 */
object MidnightAlarm {
    const val ACTION_MIDNIGHT = "com.example.ndsl.MIDNIGHT"

    fun schedule(context: Context) {
        val midnight = Calendar.getInstance().apply {
            add(Calendar.DAY_OF_YEAR, 1)
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val intent = Intent(context, MidnightAlarmReceiver::class.java)
            .setAction(ACTION_MIDNIGHT)
        val pending = PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        // Inexact by design: rollover is lazy (also runs on app resume), the
        // widget just needs a refresh sometime after midnight.
        alarmManager.set(AlarmManager.RTC, midnight.timeInMillis, pending)
    }
}

class MidnightAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Handles both BOOT_COMPLETED (alarms are lost on reboot) and the
        // midnight fire itself: always re-arm for the next midnight.
        MidnightAlarm.schedule(context)
        if (intent.action == MidnightAlarm.ACTION_MIDNIGHT) {
            HomeWidgetBackgroundIntent
                .getBroadcast(context, Uri.parse("ndsl://rollover"))
                .send()
        }
    }
}

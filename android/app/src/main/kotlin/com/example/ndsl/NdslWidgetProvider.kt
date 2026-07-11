package com.example.ndsl

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class NdslWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        // Widget on screen implies the rollover alarm must be armed.
        MidnightAlarm.schedule(context)

        val streak = widgetData.getInt("streak", 0)
        val uncompleted = JSONArray(widgetData.getString("uncompleted", "[]") ?: "[]")

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.ndsl_widget)
            if (uncompleted.length() == 0) {
                views.setViewVisibility(R.id.big_streak, View.VISIBLE)
                views.setViewVisibility(R.id.item_list, View.GONE)
                views.setViewVisibility(R.id.corner_streak, View.GONE)
                views.setTextViewText(R.id.big_streak, streak.toString())
                views.setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            } else {
                views.setViewVisibility(R.id.big_streak, View.GONE)
                views.setViewVisibility(R.id.item_list, View.VISIBLE)
                views.setViewVisibility(R.id.corner_streak, View.VISIBLE)
                views.setTextViewText(R.id.corner_streak, streak.toString())
                views.removeAllViews(R.id.item_list)
                // ponytail: rows via RemoteViews.addView; RemoteViewsService only
                // if lists ever grow beyond what a widget can show anyway.
                for (i in 0 until uncompleted.length()) {
                    val item = uncompleted.getJSONObject(i)
                    val row = RemoteViews(context.packageName, R.layout.ndsl_widget_item)
                    row.setTextViewText(R.id.item_name, "○  " + item.getString("name"))
                    row.setOnClickPendingIntent(
                        R.id.item_name,
                        HomeWidgetBackgroundIntent.getBroadcast(
                            context,
                            Uri.parse("ndsl://complete?id=${item.getLong("id")}"),
                        ),
                    )
                    views.addView(R.id.item_list, row)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

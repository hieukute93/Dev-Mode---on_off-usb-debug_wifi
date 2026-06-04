package com.cherihub.devmode

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.widget.RemoteViews

class DevModeWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_TOGGLE_DEV_MODE = "com.cherihub.devmode.ACTION_TOGGLE_DEV_MODE"
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (ACTION_TOGGLE_DEV_MODE == intent.action) {
            val isAdbEnabled = getAdbEnabled(context)
            val isWifiAdbEnabled = getWirelessAdbEnabled(context)
            
            // If both are enabled, turn them off. Else turn them on.
            val newState = !(isAdbEnabled && isWifiAdbEnabled)
            
            setAdbEnabled(context, newState)
            setWirelessAdbEnabled(context, newState)
            
            // Update all widgets
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, DevModeWidgetProvider::class.java))
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        val isAdbEnabled = getAdbEnabled(context)
        val isWifiAdbEnabled = getWirelessAdbEnabled(context)

        val views = RemoteViews(context.packageName, R.layout.widget_dev_toggle)

        // Setup click intent
        val intent = Intent(context, DevModeWidgetProvider::class.java)
        intent.action = ACTION_TOGGLE_DEV_MODE
        
        // Use FLAG_UPDATE_CURRENT and FLAG_IMMUTABLE for Android 12+ compatibility
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, flags)
        views.setOnClickPendingIntent(R.id.widget_background_image, pendingIntent)

        // Update UI based on state
        if (isAdbEnabled && isWifiAdbEnabled) {
            views.setTextViewText(R.id.widget_text, "Bật")
            views.setImageViewResource(R.id.widget_background_image, R.drawable.widget_bg_on)
        } else if (isAdbEnabled || isWifiAdbEnabled) {
            views.setTextViewText(R.id.widget_text, "Bật 1 phần")
            views.setImageViewResource(R.id.widget_background_image, R.drawable.widget_bg_partial)
        } else {
            views.setTextViewText(R.id.widget_text, "Tắt")
            views.setImageViewResource(R.id.widget_background_image, R.drawable.widget_bg_off)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun getAdbEnabled(context: Context): Boolean {
        return try {
            Settings.Global.getInt(context.contentResolver, Settings.Global.ADB_ENABLED) == 1
        } catch (e: Exception) {
            false
        }
    }

    private fun getWirelessAdbEnabled(context: Context): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Settings.Global.getInt(context.contentResolver, "adb_wifi_enabled", 0) == 1
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun setAdbEnabled(context: Context, enabled: Boolean) {
        try {
            val value = if (enabled) 1 else 0
            Settings.Global.putInt(context.contentResolver, Settings.Global.ADB_ENABLED, value)
        } catch (e: Exception) {
            Log.e("DevModeWidget", "Error setting ADB: ${e.message}")
        }
    }

    private fun setWirelessAdbEnabled(context: Context, enabled: Boolean) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val value = if (enabled) 1 else 0
                Settings.Global.putInt(context.contentResolver, "adb_wifi_enabled", value)
            }
        } catch (e: Exception) {
            Log.e("DevModeWidget", "Error setting Wifi ADB: ${e.message}")
        }
    }
}

package com.cherihub.devmode

import android.os.Build
import android.provider.Settings
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.util.Log

class QuickToggleTileService : TileService() {
    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()
        val isAdbEnabled = getAdbEnabled()
        val isWifiAdbEnabled = getWirelessAdbEnabled()
        
        // If both are active, turn them off. Otherwise, turn both on.
        val newState = !(isAdbEnabled && isWifiAdbEnabled)
        
        setAdbEnabled(newState)
        setWirelessAdbEnabled(newState)
        
        updateTileState()
    }

    private fun updateTileState() {
        val tile = qsTile ?: return
        val isAdbEnabled = getAdbEnabled()
        val isWifiAdbEnabled = getWirelessAdbEnabled()

        if (isAdbEnabled && isWifiAdbEnabled) {
            tile.state = Tile.STATE_ACTIVE
            tile.label = "Gỡ Lỗi (Bật)"
        } else if (isAdbEnabled || isWifiAdbEnabled) {
            tile.state = Tile.STATE_ACTIVE
            tile.label = "Gỡ Lỗi (Bật 1 phần)"
        } else {
            tile.state = Tile.STATE_INACTIVE
            tile.label = "Gỡ Lỗi (Tắt)"
        }
        tile.updateTile()
    }

    private fun getAdbEnabled(): Boolean {
        return try {
            Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED) == 1
        } catch (e: Exception) {
            false
        }
    }

    private fun getWirelessAdbEnabled(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Settings.Global.getInt(contentResolver, "adb_wifi_enabled", 0) == 1
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun setAdbEnabled(enabled: Boolean) {
        try {
            val value = if (enabled) 1 else 0
            Settings.Global.putInt(contentResolver, Settings.Global.ADB_ENABLED, value)
        } catch (e: Exception) {
            Log.e("QuickToggle", "Error setting ADB: ${e.message}")
        }
    }

    private fun setWirelessAdbEnabled(enabled: Boolean) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val value = if (enabled) 1 else 0
                Settings.Global.putInt(contentResolver, "adb_wifi_enabled", value)
            }
        } catch (e: Exception) {
            Log.e("QuickToggle", "Error setting Wifi ADB: ${e.message}")
        }
    }
}

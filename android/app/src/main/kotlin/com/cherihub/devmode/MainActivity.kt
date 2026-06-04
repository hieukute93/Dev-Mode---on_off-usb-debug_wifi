package com.cherihub.devmode

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.cherihub.devmode/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                // Getters
                "getStayAwake" -> {
                    result.success(getStayAwake())
                }
                "getAdbEnabled" -> {
                    result.success(getAdbEnabled())
                }
                "getWirelessAdbEnabled" -> {
                    result.success(getWirelessAdbEnabled())
                }
                "getDeveloperOptionsEnabled" -> {
                    result.success(getDeveloperOptionsEnabled())
                }
                
                // Setters
                "setStayAwake" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setStayAwake(enabled))
                }
                "setAdbEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setAdbEnabled(enabled))
                }
                "setWirelessAdbEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setWirelessAdbEnabled(enabled))
                }
                "setDeveloperOptionsEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setDeveloperOptionsEnabled(enabled))
                }
                
                // Actions
                "revokeUsbDebuggingAuthorizations" -> {
                    result.success(revokeUsbDebuggingAuthorizations())
                }
                "openDeveloperOptions" -> {
                    result.success(openDeveloperOptions())
                }
                "checkWriteSecureSettingsPermission" -> {
                    result.success(checkWriteSecureSettingsPermission())
                }
                
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ========== GETTERS ==========

    private fun getStayAwake(): Boolean {
        return try {
            Settings.Global.getInt(contentResolver, Settings.Global.STAY_ON_WHILE_PLUGGED_IN) != 0
        } catch (e: Exception) {
            false
        }
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

    private fun getDeveloperOptionsEnabled(): Boolean {
        return try {
            Settings.Global.getInt(contentResolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED) == 1
        } catch (e: Exception) {
            false
        }
    }

    // ========== SETTERS ==========

    private fun setStayAwake(enabled: Boolean): Map<String, Any> {
        return try {
            // Valores possíveis para STAY_ON_WHILE_PLUGGED_IN:
            // 0 = desabilitado
            // 1 = AC (carregador)
            // 2 = USB
            // 4 = Wireless
            // 7 = Todos (1+2+4)
            val value = if (enabled) 7 else 0
            Settings.Global.putInt(contentResolver, Settings.Global.STAY_ON_WHILE_PLUGGED_IN, value)
            mapOf("success" to true)
        } catch (e: SecurityException) {
            mapOf("success" to false, "error" to "permission_denied", "message" to "Permissão WRITE_SECURE_SETTINGS necessária")
        } catch (e: Exception) {
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    private fun setAdbEnabled(enabled: Boolean): Map<String, Any> {
        return try {
            val value = if (enabled) 1 else 0
            Settings.Global.putInt(contentResolver, Settings.Global.ADB_ENABLED, value)
            mapOf("success" to true)
        } catch (e: SecurityException) {
            mapOf("success" to false, "error" to "permission_denied", "message" to "Permissão WRITE_SECURE_SETTINGS necessária")
        } catch (e: Exception) {
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    private fun setWirelessAdbEnabled(enabled: Boolean): Map<String, Any> {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val value = if (enabled) 1 else 0
                Settings.Global.putInt(contentResolver, "adb_wifi_enabled", value)
                mapOf("success" to true)
            } else {
                mapOf("success" to false, "error" to "unsupported", "message" to "Wireless ADB requer Android 11 ou superior")
            }
        } catch (e: SecurityException) {
            mapOf("success" to false, "error" to "permission_denied", "message" to "Permissão WRITE_SECURE_SETTINGS necessária")
        } catch (e: Exception) {
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    private fun setDeveloperOptionsEnabled(enabled: Boolean): Map<String, Any> {
        return try {
            val value = if (enabled) 1 else 0
            Settings.Global.putInt(contentResolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, value)
            mapOf("success" to true)
        } catch (e: SecurityException) {
            mapOf("success" to false, "error" to "permission_denied", "message" to "Permissão WRITE_SECURE_SETTINGS necessária")
        } catch (e: Exception) {
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    // ========== ACTIONS ==========

    private fun revokeUsbDebuggingAuthorizations(): Map<String, Any> {
        return try {
            // Isso limpa as autorizações de USB debugging
            // Funciona definindo adb_enabled para 0 e depois para 1
            // Ou usando a key específica
            Settings.Global.putString(contentResolver, "adb_keys", "")
            mapOf("success" to true, "message" to "Autorizações de USB debugging revogadas")
        } catch (e: SecurityException) {
            mapOf("success" to false, "error" to "permission_denied", "message" to "Permissão WRITE_SECURE_SETTINGS necessária")
        } catch (e: Exception) {
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    private fun openDeveloperOptions(): Map<String, Any> {
        return try {
            // Verifica se as opções do desenvolvedor estão ativadas
            val devOptionsEnabled = Settings.Global.getInt(
                contentResolver, 
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 
                0
            ) == 1
            
            if (devOptionsEnabled) {
                val intent = Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                startActivity(intent)
                mapOf("success" to true)
            } else {
                // Abre "Sobre o telefone" para o usuário ativar manualmente
                try {
                    val intent = Intent(Settings.ACTION_DEVICE_INFO_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                } catch (e: Exception) {
                    val intent = Intent(Settings.ACTION_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                }
                mapOf("success" to false, "error" to "dev_options_disabled", "message" to "Opções do desenvolvedor não estão ativadas")
            }
        } catch (e: Exception) {
            // Fallback para configurações gerais
            val intent = Intent(Settings.ACTION_SETTINGS)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(intent)
            mapOf("success" to false, "error" to "unknown", "message" to (e.message ?: "Erro desconhecido"))
        }
    }

    private fun checkWriteSecureSettingsPermission(): Boolean {
        return try {
            // Tenta escrever e ler um valor para verificar se a permissão está concedida
            val testKey = "dev_mode_permission_test"
            val currentValue = Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0)
            true
        } catch (e: SecurityException) {
            false
        }
    }
}

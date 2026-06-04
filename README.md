# Dev Mode - App de Configurações do Desenvolvedor Android

[![Open Source](https://img.shields.io/badge/Open%20Source-MIT-green.svg)](https://github.com/cheri-hub)
[![GitHub](https://img.shields.io/badge/GitHub-cheri--hub-blue.svg)](https://github.com/cheri-hub)

Um aplicativo Flutter simples para controlar as configurações do modo desenvolvedor do Android sem necessidade de root.

**Desenvolvido por [cheri-hub](https://github.com/cheri-hub)**

## Funcionalidades

- ✅ **Stay Awake** - Manter a tela ligada enquanto carrega
- ✅ **USB Debugging** - Ativar/desativar depuração USB
- ✅ **Wireless Debugging** - Ativar/desativar depuração sem fio (Android 11+)
- ✅ **Revogar Autorizações USB** - Remover todos os computadores autorizados
- ✅ **Abrir Opções do Desenvolvedor** - Atalho para as configurações

## Requisitos

- Android 7.0 (API 24) ou superior
- Flutter 3.0+
- ADB instalado no computador (para conceder permissão)

## Instalação

### 1. Compilar o APK

```bash
cd dev-mode
flutter pub get
flutter build apk --release
```

O APK será gerado em `build/app/outputs/flutter-apk/app-release.apk`

### 2. Instalar no dispositivo

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 3. Conceder Permissão (OBRIGATÓRIO)

Para que o app funcione, você precisa conceder a permissão `WRITE_SECURE_SETTINGS` via ADB **uma única vez**:

```bash
adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS
```

> ⚠️ **Nota**: O USB Debugging precisa estar ativado para executar este comando. Se você desativar o USB debugging pelo app, ainda poderá ativá-lo novamente pelas configurações normais do Android.

## Como Funciona

O app usa a permissão `WRITE_SECURE_SETTINGS` do Android para modificar configurações do sistema. Esta permissão:

- Não requer root
- É persistente (sobrevive a reinicializações)
- Pode ser revogada a qualquer momento com:
  ```bash
  adb shell pm revoke com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS
  ```

## Estrutura do Projeto

```
dev-mode/
├── lib/
│   └── main.dart              # Interface Flutter
├── android/
│   └── app/
│       └── src/
│           └── main/
│               ├── kotlin/    # Código nativo Android
│               └── AndroidManifest.xml
└── pubspec.yaml
```

## Limitações

1. **Ativar/Desativar Modo Desenvolvedor**: Não é possível ativar programaticamente o modo desenvolvedor. O usuário deve fazer isso manualmente nas configurações.

2. **Wireless Debugging**: Disponível apenas no Android 11 (API 30) ou superior.

3. **Algumas configurações**: Certas configurações podem variar dependendo do fabricante do dispositivo.

## Troubleshooting

### "Permissão WRITE_SECURE_SETTINGS necessária"

Execute o comando ADB mencionado acima para conceder a permissão.

### "adb: device not found"

1. Certifique-se que o USB Debugging está ativado
2. Aceite a autorização no dispositivo
3. Verifique o cabo USB

### App não modifica as configurações

1. Verifique se a permissão foi concedida corretamente:
   ```bash
   adb shell dumpsys package com.cherihub.devmode | findstr WRITE_SECURE_SETTINGS
   ```

2. Reinicie o app após conceder a permissão

## Licença

MIT License - Open Source por [cheri-hub](https://github.com/cheri-hub)

Use livremente!

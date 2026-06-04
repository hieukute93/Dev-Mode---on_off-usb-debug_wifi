Dev Mode - Ứng dụng Cấu hình cho Trình phát triển Android
Mã nguồn mở GitHub

Ứng dụng Flutter đơn giản hóa bộ điều khiển dưới dạng cấu hình để giải mã trình điều khiển Android nếu cần thiết.

Được phát triển bởi cheri-hub

Chức năng
✅ Luôn tỉnh táo - Manter a tela ligada enquanto carrega
✅ Gỡ lỗi USB - Lỗi/tắt USB
✅ Gỡ lỗi không dây - Ativar/desativar depuração sem fio (Android 11+)
✅ Revogar Autorizações USB - Loại bỏ tất cả các máy tính tự động xóa
✅ Các tùy chọn mở rộng của Desenvolver - Atalho para as configurações
Yêu cầu
Android 7.0 (API 24) hoặc cao cấp hơn
Flutter 3.0 trở lên
ADB cài đặt không có máy tính (để được phép)
Instalação
1. Biên dịch APK
2. 
cd dev-mode

flutter pub get

flutter build apk --release

O APK será gerado embuild/app/outputs/flutter-apk/app-release.apk

4. Instalar no dispositivo
adb install build/app/outputs/flutter-apk/app-release.apk
5. Giấy phép nhượng quyền (OBRIGATÓRIO)
Đối với chức năng của ứng dụng, bạn có thể đồng ý cho phép WRITE_SECURE_SETTINGSthông qua ADB một cách dễ dàng :

adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS
⚠️ Lưu ý : Gỡ lỗi USB trước tiên phải được thực hiện để thực thi lệnh này. Nếu bạn muốn gỡ bỏ ứng dụng gỡ lỗi USB, bạn có thể làm mới các cấu hình bình thường của Android.

Como Funciona
Ứng dụng này được phép sử dụng WRITE_SECURE_SETTINGSAndroid để sửa đổi cấu hình hệ thống. Sự cho phép này:

Không yêu cầu quyền root
É Persiste (viết tắt của reinicializações)
Pode ser revogada a qualquer momento com:
adb shell pm revoke com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS
Estrutura do Projeto
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
Giới hạn
Ativar/Desativar Modo Desenvolvedor : Không có khả năng lập trình hoặc modo desenvolvedor. Người sử dụng cần phải có hướng dẫn sử dụng cấu hình.

Gỡ lỗi không dây : Hỗ trợ trên Android 11 (API 30) hoặc cao cấp hơn.

Một số cấu hình : Một số cấu hình có thể khác nhau tùy thuộc vào việc chế tạo thiết bị.

Khắc phục sự cố
"Cần có giấy phép WRITE_SECURE_SETTINGS"
Thực hiện mệnh lệnh của ADB để đưa ra quyết định cho phép.

"adb: không tìm thấy thiết bị"
Chứng chỉ của USB Debugging đã được chứng minh
Aceite a autorização no dispositivo
Verifique o cabo USB
Ứng dụng không sửa đổi cấu hình
Xác minh xem sự cho phép của bạn có được thừa nhận đúng hay không:

adb shell dumpsys package com.cherihub.devmode | findstr WRITE_SECURE_SETTINGS
Reinicie hoặc ứng dụng sau đó đã chấp nhận sự cho phép

Giấy phép
Giấy phép MIT - Mã nguồn mở bởi cheri-hub

Use livremete!

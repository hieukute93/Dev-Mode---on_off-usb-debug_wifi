import 'dart:io';

void main() {
  var file = File('lib/main.dart');
  if (!file.existsSync()) {
    print('main.dart not found!');
    return;
  }
  
  var c = file.readAsStringSync();

  c = c.replaceAll("'Erro ao carregar configurações: \$e'", "'Lỗi khi tải cấu hình: \$e'");
  c = c.replaceAll("'Erro desconhecido'", "'Lỗi không xác định'");
  c = c.replaceAll("'Erro: \$e'", "'Lỗi: \$e'");
  c = c.replaceAll("'Modo desenvolvedor ativado!'", "'Đã bật Chế độ nhà phát triển!'");
  c = c.replaceAll("'Modo desenvolvedor desativado!'", "'Đã tắt Chế độ nhà phát triển!'");
  c = c.replaceAll("'Revogar Autorizações'", "'Thu hồi Quyền truy cập'");
  c = c.replaceAll(
    "'Isso irá revogar todas as autorizações de USB debugging. '\n          'Você precisará autorizar novamente cada computador que conectar.'", 
    "'Hành động này sẽ thu hồi tất cả các quyền gỡ lỗi USB. '\n          'Bạn sẽ cần cấp quyền lại cho mỗi máy tính khi kết nối.'"
  );
  c = c.replaceAll("'Cancelar'", "'Hủy'");
  c = c.replaceAll("'Revogar'", "'Thu hồi'");
  c = c.replaceAll("'Autorizações revogadas com sucesso'", "'Thu hồi quyền thành công'");
  c = c.replaceAll("'Erro ao abrir configurações: \$e'", "'Lỗi khi mở cấu hình: \$e'");
  c = c.replaceAll("'Ativar Modo Desenvolvedor'", "'Bật Chế độ Nhà phát triển'");
  c = c.replaceAll(
    "'As opções do desenvolvedor precisam ser ativadas manualmente primeiro.'", 
    "'Tùy chọn nhà phát triển cần được bật thủ công trước.'"
  );
  c = c.replaceAll("'Como ativar:'", "'Cách bật:'");
  c = c.replaceAll(
    "'1. Vá em Configurações → Sobre o telefone\\n'\n"
    "                '2. Encontre \"Número da versão\" (ou \"Build number\")\\n'\n"
    "                '3. Toque 7 vezes seguidas\\n'\n"
    "                '4. Digite sua senha/PIN se solicitado\\n'\n"
    "                '5. Você verá \"Você agora é um desenvolvedor!\"\\n'\n"
    "                '6. Volte e abra as Opções do desenvolvedor'",
    "'1. Vào Cài đặt → Giới thiệu về điện thoại\\n'\n"
    "                '2. Tìm \"Số bản dựng\" (hoặc \"Build number\")\\n'\n"
    "                '3. Chạm 7 lần liên tiếp\\n'\n"
    "                '4. Nhập mật khẩu/Mã PIN nếu được yêu cầu\\n'\n"
    "                '5. Bạn sẽ thấy thông báo \"Bạn đã là nhà phát triển!\"\\n'\n"
    "                '6. Quay lại và mở Tùy chọn nhà phát triển'"
  );
  c = c.replaceAll("'💡 Abrimos a tela \"Sobre o telefone\" para você.'", "'💡 Chúng tôi đã mở sẵn màn hình \"Giới thiệu về điện thoại\" cho bạn.'");
  c = c.replaceAll("'Entendi'", "'Đã hiểu'");
  c = c.replaceAll("'Permissão Necessária'", "'Cần cấp quyền'");
  c = c.replaceAll(
    "'Para modificar as configurações do desenvolvedor, você precisa conceder a permissão WRITE_SECURE_SETTINGS via ADB.'", 
    "'Để thay đổi cài đặt nhà phát triển, bạn cần cấp quyền WRITE_SECURE_SETTINGS qua ADB.'"
  );
  c = c.replaceAll(
    "'Execute o seguinte comando no terminal do seu computador:'", 
    "'Hãy chạy lệnh sau trong terminal trên máy tính của bạn:'"
  );
  c = c.replaceAll(
    "'Passos:\\n'\n"
    "                '1. Conecte seu celular ao computador via USB\\n'\n"
    "                '2. Certifique-se que o USB debugging está ativo\\n'\n"
    "                '3. Execute o comando acima\\n'\n"
    "                '4. Reinicie o app'",
    "'Các bước:\\n'\n"
    "                '1. Kết nối điện thoại với máy tính qua cổng USB\\n'\n"
    "                '2. Đảm bảo tính năng Gỡ lỗi USB đã bật\\n'\n"
    "                '3. Chạy lệnh phía trên\\n'\n"
    "                '4. Khởi động lại ứng dụng'"
  );
  c = c.replaceAll("'Copiar Comando'", "'Sao chép Lệnh'");
  c = c.replaceAll("'Comando copiado!'", "'Đã sao chép lệnh!'");
  c = c.replaceAll("'Fechar'", "'Đóng'");
  c = c.replaceAll("'Dev Mode'", "'Chế độ Lập trình'"); // In title and AppBar
  c = c.replaceAll("'Atualizar'", "'Làm mới'");
  c = c.replaceAll(
    "'Permissão necessária para modificar configurações'", 
    "'Cần cấp quyền để thay đổi cài đặt'"
  );
  c = c.replaceAll("'Ver Instruções'", "'Xem hướng dẫn'");
  c = c.replaceAll("'Modo Desenvolvedor'", "'Chế độ Nhà phát triển'");
  c = c.replaceAll("'Ativado - Toque para desativar'", "'Đang bật - Chạm để tắt'");
  c = c.replaceAll("'Desativado - Toque para ativar'", "'Đang tắt - Chạm để bật'");
  c = c.replaceAll("'Configurações'", "'Cài đặt'");
  c = c.replaceAll("'Manter Tela Ligada'", "'Luôn sáng màn hình'");
  c = c.replaceAll("'Não desligar a tela enquanto estiver carregando'", "'Không tắt màn hình khi đang sạc'");
  c = c.replaceAll("'USB Debugging'", "'Gỡ lỗi USB'");
  c = c.replaceAll("'Permite depuração via USB'", "'Cho phép gỡ lỗi qua USB'");
  c = c.replaceAll("'Wireless Debugging'", "'Gỡ lỗi không dây'");
  c = c.replaceAll("'Permite depuração sem fio (Android 11+)'", "'Cho phép gỡ lỗi không dây (Android 11+)'");
  c = c.replaceAll("'Ações'", "'Hành động'");
  c = c.replaceAll("'Revogar Autorizações USB'", "'Thu hồi quyền Gỡ lỗi USB'");
  c = c.replaceAll("'Remove todos os computadores autorizados'", "'Xóa tất cả các máy tính đã được cấp quyền'");
  c = c.replaceAll("'Abrir Opções do Desenvolvedor'", "'Mở Tùy chọn Nhà phát triển'");
  c = c.replaceAll("'Acesse todas as configurações'", "'Truy cập toàn bộ cài đặt'");
  c = c.replaceAll("'Abrir'", "'Mở'");
  c = c.replaceAll("'Informações'", "'Thông tin'");
  c = c.replaceAll(
    "'Este app requer a permissão WRITE_SECURE_SETTINGS '\n"
    "                            'que deve ser concedida uma única vez via ADB. '\n"
    "                            'Não é necessário root.'",
    "'Ứng dụng yêu cầu quyền WRITE_SECURE_SETTINGS, '\n"
    "                            'chỉ cần cấp 1 lần qua ADB. '\n"
    "                            'Không cần Root.'"
  );
  c = c.replaceAll("'Comando ADB:'", "'Lệnh ADB:'");
  c = c.replaceAll("'Copiar'", "'Sao chép'");
  c = c.replaceAll("'Desenvolvido por cheri-hub'", "'Phát triển bởi cheri-hub'");

  file.writeAsStringSync(c);
  print('Translated successfully.');
}

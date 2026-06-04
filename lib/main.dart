import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DevModeApp());
}

class DevModeApp extends StatelessWidget {
  const DevModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chế độ Lập trình',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.cherihub.devmode/settings');

  bool _isLoading = true;
  bool _hasPermission = false;
  bool _stayAwake = false;
  bool _adbEnabled = false;
  bool _wirelessAdbEnabled = false;
  bool _developerOptionsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        platform.invokeMethod('getStayAwake'),
        platform.invokeMethod('getAdbEnabled'),
        platform.invokeMethod('getWirelessAdbEnabled'),
        platform.invokeMethod('getDeveloperOptionsEnabled'),
        platform.invokeMethod('checkWriteSecureSettingsPermission'),
      ]);

      setState(() {
        _stayAwake = results[0] as bool? ?? false;
        _adbEnabled = results[1] as bool? ?? false;
        _wirelessAdbEnabled = results[2] as bool? ?? false;
        _developerOptionsEnabled = results[3] as bool? ?? false;
        _hasPermission = results[4] as bool? ?? false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Lỗi khi tải cấu hình: $e');
    }
  }

  Future<void> _setStayAwake(bool enabled) async {
    try {
      final result = await platform.invokeMethod<Map>('setStayAwake', {'enabled': enabled});
      if (result?['success'] == true) {
        setState(() => _stayAwake = enabled);
      } else {
        _showError(result?['message'] ?? 'Lỗi không xác định');
      }
    } catch (e) {
      _showError('Lỗi: $e');
    }
  }

  Future<void> _setAdbEnabled(bool enabled) async {
    try {
      final result = await platform.invokeMethod<Map>('setAdbEnabled', {'enabled': enabled});
      if (result?['success'] == true) {
        setState(() => _adbEnabled = enabled);
      } else {
        _showError(result?['message'] ?? 'Lỗi không xác định');
      }
    } catch (e) {
      _showError('Lỗi: $e');
    }
  }

  Future<void> _setWirelessAdbEnabled(bool enabled) async {
    try {
      final result = await platform.invokeMethod<Map>('setWirelessAdbEnabled', {'enabled': enabled});
      if (result?['success'] == true) {
        setState(() => _wirelessAdbEnabled = enabled);
      } else {
        _showError(result?['message'] ?? 'Lỗi không xác định');
      }
    } catch (e) {
      _showError('Lỗi: $e');
    }
  }

  Future<void> _setDeveloperOptionsEnabled(bool enabled) async {
    try {
      final result = await platform.invokeMethod<Map>('setDeveloperOptionsEnabled', {'enabled': enabled});
      if (result?['success'] == true) {
        setState(() => _developerOptionsEnabled = enabled);
        _showSuccess(enabled ? 'Đã bật Chế độ nhà phát triển!' : 'Đã tắt Chế độ nhà phát triển!');
      } else {
        _showError(result?['message'] ?? 'Lỗi không xác định');
      }
    } catch (e) {
      _showError('Lỗi: $e');
    }
  }

  Future<void> _revokeUsbAuthorizations() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thu hồi Quyền truy cập'),
        content: const Text(
          'Hành động này sẽ thu hồi tất cả các quyền gỡ lỗi USB. '
          'Bạn sẽ cần cấp quyền lại cho mỗi máy tính khi kết nối.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Thu hồi'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await platform.invokeMethod<Map>('revokeUsbDebuggingAuthorizations');
        if (result?['success'] == true) {
          _showSuccess('Thu hồi quyền thành công');
        } else {
          _showError(result?['message'] ?? 'Lỗi không xác định');
        }
      } catch (e) {
        _showError('Lỗi: $e');
      }
    }
  }

  Future<void> _openDeveloperOptions() async {
    try {
      final result = await platform.invokeMethod<Map>('openDeveloperOptions');
      if (result?['success'] != true && result?['error'] == 'dev_options_disabled') {
        _showEnableDevOptionsDialog();
      }
    } catch (e) {
      _showError('Lỗi khi mở cấu hình: $e');
    }
  }

  void _showEnableDevOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.developer_mode, color: Colors.orange),
            SizedBox(width: 8),
            Text('Bật Chế độ Nhà phát triển'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tùy chọn nhà phát triển cần được bật thủ công trước.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Cách bật:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Vào Cài đặt → Giới thiệu về điện thoại\n'
                '2. Tìm "Số bản dựng" (hoặc "Build number")\n'
                '3. Chạm 7 lần liên tiếp\n'
                '4. Nhập mật khẩu/Mã PIN nếu được yêu cầu\n'
                '5. Bạn sẽ thấy thông báo "Bạn đã là nhà phát triển!"\n'
                '6. Quay lại và mở Tùy chọn nhà phát triển',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                '💡 Chúng tôi đã mở sẵn màn hình "Giới thiệu về điện thoại" cho bạn.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cần cấp quyền'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Để thay đổi cài đặt nhà phát triển, bạn cần cấp quyền WRITE_SECURE_SETTINGS qua ADB.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Hãy chạy lệnh sau trong terminal trên máy tính của bạn:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              SelectableText(
                'adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: Colors.amber,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Các bước:\n'
                '1. Kết nối điện thoại với máy tính qua cổng USB\n'
                '2. Đảm bảo tính năng Gỡ lỗi USB đã bật\n'
                '3. Chạy lệnh phía trên\n'
                '4. Khởi động lại ứng dụng',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(
                text: 'adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sao chép lệnh!')),
              );
            },
            child: const Text('Sao chép Lệnh'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chế độ Lập trình'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSettings,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSettings,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Permission Warning Card
                  if (!_hasPermission)
                    Card(
                      color: Colors.orange[900],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Cần cấp quyền để thay đổi cài đặt',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _showPermissionDialog,
                                child: const Text('Xem hướng dẫn'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Developer Options Toggle Card
                  Card(
                    child: SwitchListTile(
                      secondary: Icon(
                        _developerOptionsEnabled
                            ? Icons.developer_mode
                            : Icons.developer_mode_outlined,
                        size: 32,
                        color: _developerOptionsEnabled
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: const Text(
                        'Chế độ Nhà phát triển',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _developerOptionsEnabled
                            ? 'Đang bật - Chạm để tắt'
                            : 'Đang tắt - Chạm để bật',
                        style: TextStyle(
                          color: _developerOptionsEnabled
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      value: _developerOptionsEnabled,
                      onChanged: _setDeveloperOptionsEnabled,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Settings Section
                  const Text(
                    'Cài đặt',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Stay Awake
                  _buildSettingCard(
                    icon: Icons.visibility,
                    title: 'Luôn sáng màn hình',
                    subtitle: 'Không tắt màn hình khi đang sạc',
                    value: _stayAwake,
                    onChanged: _setStayAwake,
                  ),

                  // USB Debugging
                  _buildSettingCard(
                    icon: Icons.usb,
                    title: 'Gỡ lỗi USB',
                    subtitle: 'Cho phép gỡ lỗi qua USB',
                    value: _adbEnabled,
                    onChanged: _setAdbEnabled,
                  ),

                  // Wireless Debugging
                  _buildSettingCard(
                    icon: Icons.wifi,
                    title: 'Gỡ lỗi không dây',
                    subtitle: 'Cho phép gỡ lỗi không dây (Android 11+)',
                    value: _wirelessAdbEnabled,
                    onChanged: _setWirelessAdbEnabled,
                  ),

                  const SizedBox(height: 24),

                  // Actions Section
                  const Text(
                    'Hành động',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Quick Enable Both
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.bolt, color: Colors.amber),
                      title: const Text('Bật Nhanh Gỡ Lỗi (USB + Không dây)'),
                      subtitle: const Text('Tiện ích: Bật cả 2 tính năng cùng lúc'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                        ),
                        onPressed: () async {
                          await _setAdbEnabled(true);
                          await _setWirelessAdbEnabled(true);
                          _showSuccess('Đã bật thành công cả 2 chế độ Gỡ lỗi!');
                        },
                        child: const Text('Bật Ngay'),
                      ),
                    ),
                  ),

                  // Revoke USB Authorizations
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Thu hồi quyền Gỡ lỗi USB'),
                      subtitle: const Text('Xóa tất cả các máy tính đã được cấp quyền'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                        ),
                        onPressed: _revokeUsbAuthorizations,
                        child: const Text('Thu hồi'),
                      ),
                    ),
                  ),

                  // Open Developer Options
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings, color: Colors.blue),
                      title: const Text('Mở Tùy chọn Nhà phát triển'),
                      subtitle: const Text('Truy cập toàn bộ cài đặt'),
                      trailing: ElevatedButton(
                        onPressed: _openDeveloperOptions,
                        child: const Text('Mở'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info Card
                  Card(
                    color: Colors.blue[900]?.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Thông tin',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ứng dụng yêu cầu quyền WRITE_SECURE_SETTINGS, '
                            'chỉ cần cấp 1 lần qua ADB. '
                            'Không cần Root.',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Lệnh ADB:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: SelectableText(
                                    'adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18),
                                  onPressed: () {
                                    Clipboard.setData(const ClipboardData(
                                      text: 'adb shell pm grant com.cherihub.devmode android.permission.WRITE_SECURE_SETTINGS',
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Đã sao chép lệnh!')),
                                    );
                                  },
                                  tooltip: 'Sao chép',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.code, size: 18),
                              const SizedBox(width: 8),
                              const Text(
                                'Open Source',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => _launchUrl('https://github.com/cheri-hub'),
                                icon: const Icon(Icons.open_in_new, size: 16),
                                label: const Text('GitHub'),
                              ),
                            ],
                          ),
                          const Text(
                            'Phát triển bởi cheri-hub',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: (newValue) => onChanged(newValue),
      ),
    );
  }
}

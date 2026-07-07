import 'package:flutter/material.dart';

void main() {
  runApp(const CampaignApp());
}

class CampaignApp extends StatelessWidget {
  const CampaignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campaign Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Blue theme
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CampaignDashboard(),
      },
    );
  }
}

class CampaignDashboard extends StatelessWidget {
  const CampaignDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('کمپین ڈیش بورڈ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('نئی کمپین'),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSummaryCards(context, isMobile: true),
        const SizedBox(height: 24),
        Text('فعال کمپینز', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildCampaignList(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              _buildSummaryCards(context, isMobile: false),
              const SizedBox(height: 32),
              Text('فعال کمپینز', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildCampaignList(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حالیہ سرگرمیاں', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildActivityLog(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, {required bool isMobile}) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _SummaryCard(title: 'کل کمپینز', value: '24', icon: Icons.campaign, color: Colors.blue),
        _SummaryCard(title: 'فعال', value: '8', icon: Icons.play_circle_outline, color: Colors.green),
        _SummaryCard(title: 'مکمل', value: '16', icon: Icons.check_circle_outline, color: Colors.orange),
      ],
    );
  }

  Widget _buildCampaignList() {
    final campaigns = [
      {'name': 'عید آفر 2026', 'status': 'فعال', 'reach': '12.5k', 'progress': 0.7},
      {'name': 'موسم گرما کی سیل', 'status': 'فعال', 'reach': '8.2k', 'progress': 0.4},
      {'name': 'نئے ممبرز پرومو', 'status': 'مسودہ', 'reach': '-', 'progress': 0.0},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        final isActive = campaign['status'] == 'فعال';

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: isActive ? Colors.green.shade50 : Colors.grey.shade100,
              child: Icon(Icons.campaign, color: isActive ? Colors.green : Colors.grey),
            ),
            title: Text(campaign['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('رسائی: ${campaign['reach']}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: campaign['progress'] as double,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(isActive ? Colors.green : Colors.grey),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(campaign['status'] as String, style: TextStyle(color: isActive ? Colors.green.shade700 : Colors.grey.shade700)),
              backgroundColor: isActive ? Colors.green.shade50 : Colors.grey.shade100,
              side: BorderSide.none,
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildActivityLog() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.history, size: 20),
          title: const Text('نئی کمپین شامل کی گئی'),
          subtitle: Text('${index + 1} گھنٹے پہلے', style: const TextStyle(fontSize: 12)),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      ),
    );
  }
}

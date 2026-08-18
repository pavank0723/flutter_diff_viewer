class SampleData {
  static const String shortOld = '''Hello World
This is the original text.
Some content here.
End of document.''';

  static const String shortNew = '''Hello Dart
This is the modified text with changes.
Some content here.
New line added.
End of document.''';

  static const String privacyOld = '''Privacy Notice
Document: PN00736 v1.2

1. Introduction
This Privacy Notice describes how Acme Corp ("we", "us", or "our")
collects, uses, and shares personal data about you.

2. Data We Collect
We collect the following categories of personal data:
- Name and contact information
- Account credentials
- Usage data and analytics
- Payment information

3. How We Use Your Data
We use your personal data to:
- Provide and improve our services
- Process payments
- Send important notifications
- Comply with legal obligations

4. Data Retention
We retain personal data for as long as necessary to fulfill the
purposes outlined in this notice.

5. Your Rights
You have the right to:
- Access your personal data
- Correct inaccurate data
- Request deletion of your data
- Object to processing

6. Contact
For privacy inquiries contact: privacy@acme.com''';

  static const String privacyNew = '''Privacy Notice
Document: PN00736 v1.3

1. Introduction
This Privacy Notice describes how Acme Corp ("we", "us", or "our")
collects, uses, shares, and protects personal data about you.

2. Data We Collect
We collect the following categories of personal data:
- Name and contact information
- Account credentials
- Usage data and analytics
- Payment information
- Device and browser information
- Location data (where permitted)

3. How We Use Your Data
We use your personal data to:
- Provide and improve our services
- Process payments securely
- Send important notifications and updates
- Comply with legal obligations
- Detect and prevent fraud

4. Data Retention
We retain personal data for as long as necessary to fulfill the
purposes outlined in this notice, typically no longer than 7 years.

5. Your Rights
You have the right to:
- Access your personal data
- Correct inaccurate data
- Request deletion of your data
- Object to processing
- Data portability
- Lodge a complaint with a supervisory authority

6. International Transfers
Your data may be transferred to and processed in countries outside
your country of residence.

7. Contact
For privacy inquiries contact: privacy@acme.com
Data Protection Officer: dpo@acme.com''';

  static const String wordOld = 'The quick brown fox jumps over the lazy dog.';
  static const String wordNew =
      'The fast red cat jumps over the energetic puppy.';

  static const String codeOld = '''void main() {
  print('Hello, World!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}''';

  static const String codeNew = '''void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print('Hello, Flutter!');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}''';

  static String generateLargeOld(int lines) {
    final buffer = StringBuffer();
    for (var i = 1; i <= lines; i++) {
      if (i % 20 == 0) {
        buffer.writeln(
          'Line $i: This line has been modified from the original content',
        );
      } else {
        buffer.writeln(
          'Line $i: This is unchanged content line number $i in the document',
        );
      }
    }
    return buffer.toString().trimRight();
  }

  static String generateLargeNew(int lines) {
    final buffer = StringBuffer();
    for (var i = 1; i <= lines; i++) {
      if (i % 20 == 0) {
        buffer.writeln(
          'Line $i: This line has been updated to new content in version 2',
        );
      } else {
        buffer.writeln(
          'Line $i: This is unchanged content line number $i in the document',
        );
      }
    }
    return buffer.toString().trimRight();
  }
}

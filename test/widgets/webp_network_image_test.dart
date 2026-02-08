import 'package:flutter_test/flutter_test.dart';
import 'package:barter_app/widgets/webp_network_image.dart';

void main() {
  group('WebPNetworkImage', () {
    test('creates provider with correct URL and scale', () {
      const url = 'https://example.com/image.jpg';
      const scale = 2.0;
      
      const provider = WebPNetworkImage(url, scale: scale);
      
      expect(provider.url, equals(url));
      expect(provider.scale, equals(scale));
    });

    test('default scale is 1.0', () {
      const url = 'https://example.com/image.jpg';
      const provider = WebPNetworkImage(url);
      
      expect(provider.scale, equals(1.0));
    });

    test('equality works correctly', () {
      const url = 'https://example.com/image.jpg';
      const provider1 = WebPNetworkImage(url);
      const provider2 = WebPNetworkImage(url);
      const provider3 = WebPNetworkImage('https://example.com/other.jpg');
      
      expect(provider1, equals(provider2));
      expect(provider1, isNot(equals(provider3)));
    });

    test('hashCode is consistent', () {
      const url = 'https://example.com/image.jpg';
      const provider1 = WebPNetworkImage(url);
      const provider2 = WebPNetworkImage(url);
      
      expect(provider1.hashCode, equals(provider2.hashCode));
    });
  });

  group('WebPImage', () {
    testWidgets('creates widget with required imageUrl', (tester) async {
      const imageUrl = 'https://example.com/image.jpg';
      
      await tester.pumpWidget(
        const WebPImage(imageUrl: imageUrl),
      );
      
      // Widget should be created without errors
      expect(find.byType(WebPImage), findsOneWidget);
    });
  });
}

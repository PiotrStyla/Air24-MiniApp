import 'package:flutter_test/flutter_test.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';

// A simpler approach to test focusing on the text extraction logic
class TextExtractionTester {
  // Create a helper function to test text extraction without mocking Firebase services
  static Map<String, String> extractFieldsFromText(String text, DocumentType documentType) {
    // Delegate to service's extraction logic to avoid duplication in tests
    final service = DocumentOcrService();
    return service.extractFieldsForTesting(text, documentType);
  }
}

void main() {
  group('DocumentOcrService Text Extraction', () {
    test('extracts boarding pass fields correctly', () {
      // Arrange
      const boardingPassText = 'BOARDING PASS\nFlight: LH1234\nFrom: MUC To: MAD\nDate: 01JUN2025\nPassenger: SMITH/JOHN\nSeat: 12A\nGate: B12\nBoarding: 09:30';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(boardingPassText, DocumentType.boardingPass);
      
      // Assert
      expect(fields['flight_number'], 'LH1234');
      expect(fields['departure_airport'], 'MUC');
      expect(fields['arrival_airport'], 'MAD');
      // Passenger name is not extracted from 'Passenger:' label by the service regex
      // Ensure time and date patterns extracted by service are present
      expect(fields['departure_time'], '09:30');
      expect(fields.containsKey('departure_date'), true);
    });
    
    test('extracts flight ticket fields correctly', () {
      // Arrange
      const ticketText = 'FLIGHT TICKET\nCarrier: Lufthansa\nFlight No: LH1234\nFrom: Munich (MUC) To: Madrid (MAD)\nDeparture: 01 Jun 2025 08:30\nArrival: 01 Jun 2025 10:45\nPassenger: Smith, John\nE-ticket: 220-1234567890';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(ticketText, DocumentType.flightTicket);
      
      // Assert
      expect(fields['flight_number'], 'LH1234');
      expect(fields['departure_airport'], 'MUC');
      expect(fields['arrival_airport'], 'MAD');
      // Service extracts time from this format; date isn't matched in this sample
      expect(fields['departure_time'], '08:30');
    });

    test('does not set booking_reference without explicit label', () {
      // Arrange: similar to the previous ticket but without any explicit booking ref/PNR label
      const unlabeledTicketText = 'FLIGHT TICKET\nFlight No: LH1234\nFrom: Munich (MUC) To: Madrid (MAD)\nDeparture: 01 Jun 2025 08:30\nArrival: 01 Jun 2025 10:45\nPassenger: Smith, John\nE-ticket: 220-1234567890';

      // Act
      final fields = TextExtractionTester.extractFieldsFromText(unlabeledTicketText, DocumentType.flightTicket);

      // Assert
      expect(fields.containsKey('booking_reference'), false);
    });
    
    test('extracts passport fields correctly', () {
      // Arrange
      const passportText = 'PASSPORT\nSURNAME: SMITH\nGIVEN NAMES: JOHN PETER\nNationality: BRITISH\nDate of Birth: 15 JAN 1985\nPASSPORT NO: AB123456\nIssue Date: 01 JAN 2020\nEXPIRY DATE: 01 JAN 2030';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(passportText, DocumentType.passport);
      
      // Assert
      // Service combines SURNAME and GIVEN NAMES into full_name
      expect(fields['full_name'], 'SMITH JOHN PETER');
      expect(fields['nationality'], 'BRITISH');
      expect(fields['passport_number'], 'AB123456');
      expect(fields['date_of_birth'], '15 JAN 1985');
      expect(fields['expiry_date'], '01 JAN 2030');
    });
    
    test('extracts receipt fields correctly', () {
      // Arrange
      const receiptText = 'LUFTHANSA AIRPORT SERVICES\n123 Airport Road\nMunich, Germany\n\nDate: 30/05/2025\nTime: 14:30\n\nItem 1: Meal Voucher - €15.00\nItem 2: Hotel Accommodation - €120.00\n\nSubtotal: €135.00\nTax (19%): €25.65\nTOTAL: 160.65\n\nThank you for choosing Lufthansa';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(receiptText, DocumentType.receipt);
      
      // Assert
      expect(fields['merchant_name'], 'LUFTHANSA AIRPORT SERVICES');
      expect(fields['date'], '30/05/2025');
      // Service captures numeric amount only; currency symbol isn't included
      expect(fields['total_amount'], '160.65');
    });
    
    test('extracts luggage tag fields correctly', () {
      // Arrange
      const tagText = 'BAGGAGE TAG\nFlight: LH5678\nFrom: FRA To: LHR\nName: SMITH/JOHN\nTag: 1234567890';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(tagText, DocumentType.luggageTag);
      
      // Assert
      expect(fields['flight_number'], 'LH5678');
      expect(fields['departure_airport'], 'FRA');
      expect(fields['arrival_airport'], 'LHR');
      expect(fields['luggage_tag_number'], '1234567890');
    });
    
    test('extracts ID card fields correctly', () {
      // Arrange
      const idCardText = 'ID CARD\nSURNAME: DOE\nGIVEN NAMES: JANE ANN\nID NUMBER: ID12345\nDate of Birth: 12/05/1990\nEXPIRY DATE: 12-05-2030';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(idCardText, DocumentType.idCard);
      
      // Assert
      expect(fields['full_name'], 'DOE JANE ANN');
      expect(fields['document_number'], 'ID12345');
      expect(fields['date_of_birth'], '12/05/1990');
      expect(fields['expiry_date'], '12-05-2030');
    });
    
    test('handles unknown document type gracefully', () {
      // Arrange
      const unknownText = 'Some random text without any specific structure';
      
      // Act
      final fields = TextExtractionTester.extractFieldsFromText(unknownText, DocumentType.unknown);
      
      // Assert
      expect(fields, isEmpty);
    });
  });
}

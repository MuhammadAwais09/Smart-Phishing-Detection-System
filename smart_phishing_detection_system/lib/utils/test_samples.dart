class TestSamples {
  static const List<Map<String, String>> phishingExamples = [
    {
      'type': 'sms',
      'content':
          'Congratulations! You won \$1,000,000! Click bit.ly/claim-now to claim immediately!',
      'description': 'Classic prize-scam SMS'
    },
    {
      'type': 'url',
      'content': 'arnazon.com/account-verify',
      'description': 'Typosquatting Amazon URL'
    },
  ];

  static const List<Map<String, String>> legitExamples = [
    {
      'type': 'url',
      'content': 'https://www.amazon.com/gp/css/order-history',
      'description': 'Legit Amazon URL'
    },
  ];
}
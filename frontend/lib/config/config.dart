class Config {
  static const String apiUrl = String.fromEnvironment('API_URL',
      defaultValue: 'http://backend:3000/api/v1');
}

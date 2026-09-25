/// Runtime configuration for future Supabase integration.
///
/// Values are intentionally supplied by the host environment. Never commit
/// real project URLs, anonymous keys, service-role keys, or passwords.
class AppConfig {
  const AppConfig({this.supabaseUrl = '', this.supabaseAnonKey = ''});

  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get hasSupabase =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  factory AppConfig.fromEnvironment() => const AppConfig(
        supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
        supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      );
}

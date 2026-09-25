/// Runtime configuration for future Supabase integration.
///
/// Values are intentionally supplied by the host environment. Never commit
/// real project URLs, anonymous keys, service-role keys, or passwords.
class AppConfig {
  const AppConfig({
    this.supabaseUrl = '',
    String? supabasePublishableKey,
    String? supabaseAnonKey,
  })  : supabasePublishableKey =
            supabasePublishableKey ?? supabaseAnonKey ?? '',
        supabaseAnonKey = supabaseAnonKey ?? supabasePublishableKey ?? '';

  final String supabaseUrl;
  final String supabasePublishableKey;
  // Kept as an alias for existing callers from v0.5.
  final String supabaseAnonKey;

  bool get hasSupabase =>
      supabaseUrl.trim().isNotEmpty && supabasePublishableKey.trim().isNotEmpty;

  factory AppConfig.fromEnvironment() => const AppConfig(
        supabaseUrl: String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://fmuhpybmqicsovmetvao.supabase.co',
        ),
        supabasePublishableKey:
            String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
      );
}

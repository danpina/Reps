import Foundation

/// Where the app talks to. Both values are the public ones the website already ships
/// in its browser bundle (NEXT_PUBLIC_SUPABASE_URL / NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY):
/// the publishable key is not a secret, and every row is protected by row level security.
/// The service-role key and the Anthropic key stay on the server and never belong here.
enum BackendConfig {
    static let supabaseURL = URL(string: "https://bgzdojqraasewmirlijv.supabase.co")!
    static let publishableKey = "sb_publishable_M7iHgFaf-MVTnEaraMm_fg_IOzfk2HV"
}

/**
 * The cookie proving a password-recovery link was actually clicked.
 *
 * Set by /auth/callback the moment it verifies a link with `type=recovery`,
 * read by /reset-password before it lets anyone set a new password, and
 * cleared the moment that happens. Its own file rather than a constant beside
 * the route handler and the page, since both need it and neither should
 * import from the other.
 */
export const PASSWORD_RECOVERY_COOKIE = "password_recovery";

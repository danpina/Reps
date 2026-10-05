import "server-only";

import { AsyncLocalStorage } from "node:async_hooks";

/**
 * The bearer token of the request being served, if it came from the iOS app.
 *
 * Everything in `lib/` and every server action reaches the database through
 * `createClient()` and learns who is asking through `getSessionUser()`, and both
 * read a cookie. The app has no cookie — it holds a Supabase access token. Rather
 * than fork every query and action into a second copy for the app, those two
 * entry points check here first: when a request is running inside
 * `runWithBearer`, they act as the token's owner instead of the cookie's.
 *
 * Scoped to one request by AsyncLocalStorage, so two requests in flight at once
 * never see each other's token, and a cookie request is untouched because there
 * is nothing in the store for it.
 */
const storage = new AsyncLocalStorage<{ token: string }>();

export function bearerToken(): string | undefined {
  return storage.getStore()?.token;
}

export function runWithBearer<T>(token: string, fn: () => Promise<T>): Promise<T> {
  return storage.run({ token }, fn);
}

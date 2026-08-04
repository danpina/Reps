/**
 * Offline shell.
 *
 * Deliberately narrow. Every page in this app is private and personal, so
 * nothing signed-in is ever written to the cache: on a shared device a cached
 * page could otherwise be served to whoever opens the app next.
 *
 * What is cached: static build assets, the icons, and one offline page.
 * What is never cached: navigations, anything under /auth, and any request
 * that is not a plain GET.
 */

const VERSION = "reps-v1";
const OFFLINE_URL = "/offline";

const PRECACHE = [OFFLINE_URL, "/icon-192.png", "/icon-512.png", "/icon.svg"];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches
      .open(VERSION)
      .then((cache) => cache.addAll(PRECACHE))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(keys.filter((k) => k !== VERSION).map((k) => caches.delete(k))),
      )
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;

  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;
  if (url.pathname.startsWith("/auth")) return;

  // Navigations always go to the network. A stale dashboard is worse than an
  // honest offline page, and a cached one could leak between users.
  if (request.mode === "navigate") {
    event.respondWith(
      fetch(request).catch(() => caches.match(OFFLINE_URL)),
    );
    return;
  }

  // Build output is content-hashed, so it is safe to serve from cache first.
  if (url.pathname.startsWith("/_next/static") || PRECACHE.includes(url.pathname)) {
    event.respondWith(
      caches.match(request).then(
        (hit) =>
          hit ??
          fetch(request).then((response) => {
            const copy = response.clone();
            caches.open(VERSION).then((cache) => cache.put(request, copy));
            return response;
          }),
      ),
    );
  }
});

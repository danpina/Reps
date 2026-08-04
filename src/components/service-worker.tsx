"use client";

import { useEffect } from "react";

/**
 * Registers the offline shell. Registration is deliberately skipped in
 * development, where a cached build is far more likely to cause confusion than
 * to be useful.
 */
export function ServiceWorker() {
  useEffect(() => {
    if (process.env.NODE_ENV !== "production") return;
    if (!("serviceWorker" in navigator)) return;

    const register = () => {
      navigator.serviceWorker.register("/sw.js").catch(() => {
        // Offline support is a bonus. Failing to register must not be visible.
      });
    };

    // Waiting for load keeps the worker off the critical path.
    if (document.readyState === "complete") register();
    else window.addEventListener("load", register, { once: true });

    return () => window.removeEventListener("load", register);
  }, []);

  return null;
}

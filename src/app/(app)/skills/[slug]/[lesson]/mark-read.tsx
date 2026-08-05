"use client";

import { useEffect, useRef } from "react";

import { markLessonRead } from "./actions";

/**
 * Records the lesson as read once it has actually been opened.
 *
 * Renders nothing. A ref guards against React's development double-invoke, and
 * the server side is idempotent anyway.
 */
export function MarkRead({ lessonId }: { lessonId: string }) {
  const done = useRef<string | null>(null);

  useEffect(() => {
    if (done.current === lessonId) return;
    done.current = lessonId;
    void markLessonRead(lessonId);
  }, [lessonId]);

  return null;
}

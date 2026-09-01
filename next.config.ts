import type { NextConfig } from "next";
import createNextIntlPlugin from "next-intl/plugin";

const nextConfig: NextConfig = {
  // The dev overlay badge sits bottom-left, directly on top of the phone tab
  // bar, which makes the mobile layout impossible to check honestly. Build
  // errors still surface in the terminal and the browser console.
  devIndicators: false,
};

const withNextIntl = createNextIntlPlugin();

export default withNextIntl(nextConfig);

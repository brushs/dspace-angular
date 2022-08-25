import { GlobalConfig } from '../config/global-config.interface';

export const environment: Partial<GlobalConfig> = {
  production: false,
  // Angular Universal server settings.
  // NOTE: these must be "synced" with the 'dspace.ui.url' setting in your backend's local.cfg.
  ui: {
    ssl: false,
    host: 'localhost',
    port: 4000,
    // NOTE: Space is capitalized because 'namespace' is a reserved string in TypeScript
    nameSpace: '/',
    // The rateLimiter settings limit each IP to a "max" of 500 requests per "windowMs" (1 minute).
    rateLimiter: {
      windowMs: 1 * 60 * 1000,   // 1 minute
      max: 500 // limit each IP to 500 requests per windowMs
    }
  },
  // The REST API server settings.
  // NOTE: these must be "synced" with the 'dspace.server.url' setting in your backend's local.cfg.
  rest: {
    ssl: false,
    host: 'localhost',
    port: 8080,
    // NOTE: Space is capitalized because 'namespace' is a reserved string in TypeScript
    nameSpace: '/server',
  },
}

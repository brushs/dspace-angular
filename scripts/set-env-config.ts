import { AppConfig } from '../src/config/app-config.interface';
import { buildAppConfig } from '../src/config/config.server';
import { join } from 'path';

const appConfig: AppConfig = buildAppConfig(join(process.cwd(), 'src/assets/config.json'));

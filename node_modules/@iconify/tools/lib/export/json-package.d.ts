import { IconSet } from '../icon-set/index.js';
import { ExportTargetOptions } from './helpers/prepare.js';
import { ExportOptionsWithCustomFiles } from './helpers/custom-files.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';
import '../icon-set/types.js';
import '../svg/index.js';
import '@iconify/utils/lib/icon-set/tree';

/**
 * Options
 */
interface ExportJSONPackageOptions extends ExportTargetOptions, ExportOptionsWithCustomFiles {
    package?: Record<string, unknown>;
}
/**
 * Export icon set as JSON package
 *
 * Used for exporting `@iconify-json/{prefix}` packages
 */
declare function exportJSONPackage(iconSet: IconSet, options: ExportJSONPackageOptions): Promise<string[]>;

export { ExportJSONPackageOptions, exportJSONPackage };

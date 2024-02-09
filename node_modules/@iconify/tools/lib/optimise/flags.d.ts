import { SVG } from '../svg/index.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';

/**
 * De-optimise paths. Compressed paths are still not supported by some software.
 */
declare function deOptimisePaths(svg: SVG): Promise<void>;

export { deOptimisePaths };

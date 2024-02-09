import { SVG } from '../svg/index.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';

/**
 * Expand global style
 */
declare function cleanupGlobalStyle(svg: SVG): Promise<void>;

export { cleanupGlobalStyle };

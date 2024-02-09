import { SVG } from '../svg/index.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';

/**
 * Removes clip path from SVG, which Figma adds to icons that might have overflowing elements
 */
declare function removeFigmaClipPathFromSVG(svg: SVG): boolean;

export { removeFigmaClipPathFromSVG };

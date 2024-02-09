import { SVG } from '../svg/index.js';
import { ParseColorsOptions, FindColorsResult, ParseColorsSyncOptions } from './parse.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';
import '@iconify/utils/lib/colors/types';
import './attribs.js';
import '../svg/analyse/types.js';

/**
 * Validate colors in icon
 *
 * If icon is monotone,
 *
 * Throws exception on error
 */
declare function validateColors(svg: SVG, expectMonotone: boolean, options?: ParseColorsOptions): Promise<FindColorsResult>;
/**
 * Validate colors in icon, synchronous version
 *
 * If icon is monotone,
 *
 * Throws exception on error
 */
declare function validateColorsSync(svg: SVG, expectMonotone: boolean, options?: ParseColorsSyncOptions): FindColorsResult;

export { validateColors, validateColorsSync };

import { Color } from '@iconify/utils/lib/colors/types';
import { SVG } from '../svg/index.js';
import { ColorAttributes } from './attribs.js';
import { ElementsTreeItem, AnalyseSVGStructureResult, ExtendedTagElement, AnalyseSVGStructureOptions } from '../svg/analyse/types.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';

/**
 * Result
 */
interface FindColorsResult {
    colors: (Color | string)[];
    hasUnsetColor: boolean;
    hasGlobalStyle: boolean;
}
/**
 * Callback to call for each found color
 *
 * Callback should return:
 * - new color value to change color
 * - first parameter to keep old value
 * - 'unset' to delete old value
 * - 'remove' to remove shape or rule
 */
type ParseColorsCallbackResult = Color | string | 'remove' | 'unset';
type ParseColorsCallback<T> = (attr: ColorAttributes, colorString: string, parsedColor: Color | null, tagName?: string, item?: ExtendedTagElementWithColors) => T;
/**
 * Callback for default color
 */
type ParseColorOptionsDefaultColorCallback = (prop: string, item: ExtendedTagElementWithColors, treeItem: ElementsTreeItem, iconData: AnalyseSVGStructureResult) => Color;
/**
 * Options
 */
interface Options<T> extends AnalyseSVGStructureOptions {
    callback?: T;
    defaultColor?: Color | string | ParseColorOptionsDefaultColorCallback;
}
type ParseColorsOptions = Options<ParseColorsCallback<ParseColorsCallbackResult | Promise<ParseColorsCallbackResult>>>;
type ParseColorsSyncOptions = Options<ParseColorsCallback<ParseColorsCallbackResult>>;
/**
 * Extend properties for element
 */
type ItemColors = Partial<Record<ColorAttributes, Color | string>>;
interface ExtendedTagElementWithColors extends ExtendedTagElement {
    _colors?: ItemColors;
    _removed?: boolean;
}
/**
 * Find colors in icon
 *
 * Clean up icon before running this function to convert style to attributes using
 * cleanupInlineStyle() or cleanupSVG(), otherwise results might be inaccurate
 */
declare function parseColors(svg: SVG, options?: ParseColorsOptions): Promise<FindColorsResult>;
/**
 * Find colors in icon, synchronous version
 *
 * Clean up icon before running this function to convert style to attributes using
 * cleanupInlineStyle() or cleanupSVG(), otherwise results might be inaccurate
 */
declare function parseColorsSync(svg: SVG, options?: ParseColorsSyncOptions): FindColorsResult;
/**
 * Check if color is empty, such as 'none' or 'transparent'
 */
declare function isEmptyColor(color: Color): boolean;

export { ExtendedTagElementWithColors, FindColorsResult, ParseColorOptionsDefaultColorCallback, ParseColorsOptions, ParseColorsSyncOptions, isEmptyColor, parseColors, parseColorsSync };

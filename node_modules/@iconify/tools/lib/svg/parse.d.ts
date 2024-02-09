import { CheerioElement, WrappedCheerioElement } from '../misc/cheerio.js';
import { SVG } from './index.js';
import '@iconify/types';
import '@iconify/utils/lib/customisations/defaults';

/**
 * Item in callback
 */
interface ParseSVGCallbackItem {
    tagName: string;
    element: CheerioElement;
    $element: WrappedCheerioElement;
    svg: SVG;
    parents: ParseSVGCallbackItem[];
    testChildren: boolean;
    removeNode: boolean;
}
/**
 * Callback function
 */
type Callback<T> = (item: ParseSVGCallbackItem) => T;
type ParseSVGCallback = Callback<void | Promise<void>>;
type ParseSVGCallbackSync = Callback<void>;
/**
 * Parse SVG
 *
 * This function finds all elements in SVG and calls callback for each element.
 * Callback can be asynchronous.
 */
declare function parseSVG(svg: SVG, callback: ParseSVGCallback): Promise<void>;
/**
 * Sync version
 */
declare function parseSVGSync(svg: SVG, callback: ParseSVGCallbackSync): void;

export { ParseSVGCallback, ParseSVGCallbackItem, ParseSVGCallbackSync, parseSVG, parseSVGSync };

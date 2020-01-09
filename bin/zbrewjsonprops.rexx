/* REXX */
/* 
 * Parse a JSON stream and write out a set of key/value pairs (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Parse arg opts .

if (opts <> '') then do
  call SayErr 'Syntax: zbrewjsonprops'
  call SayErr '  The JSON key/value pairs are read in from stdin'
  call SayErr '  The parsed key/value pairs are written out to stdout'
  return 4
end

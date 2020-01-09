/* REXX */
/* 
 * Parse a JSON stream and write out a set of key/value pairs (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname .

if (swname = '' | swname = '?') then do
  call SayErr 'Syntax: zbrewjsonprops <sw>'
  call SayErr '  The JSON key/value pairs are read in from stdin'
  call SayErr '  The parsed key/value pairs are written out to stdout'
  return 4
end

rc=readJSON()
if (rc <> 0) then do
  return rc
end

do el = 1 to json.software.elements
  entry = json.software.el.name
  if (entry = swname) then do
    props = json.software.el.properties
    do p = 1 to json.software.el.properties.fields
      key = json.software.el.properties.field.p
      INTERPRET 'val = json.software.' || el || '.properties.' || key
      /* val = json.software.el.properties.key */
      say key || '=' || val
    end
    return 0
  end
end

SayErr 'Unable to find software: ' || swname
return 4

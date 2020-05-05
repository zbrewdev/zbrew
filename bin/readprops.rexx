/* REXX */
/* 
 * Parse a JSON stream and write out a set of key/value pairs (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname category . 

if (swname = '' | category = '' | swname = '?') then do
  call SayErr 'Syntax: readprops <sw> <category>'
  call SayErr '  The JSON key/value pairs are read in from stdin'
  call SayErr '  The parsed key/value pairs are written out to stdout'
  return 4
end

rc=readJSON()
if (rc <> 0) then do
  call SayErr 'readprops failed'
  return rc
end

do el = 1 to json.software.0
  entry = json.software.el.relid
  if (entry = swname) then do
    props = json.software.el.category
    do p = 1 to json.software.el.category.0
      key = json.software.el.category.field.p
      val = json.software.el.category.key
      say key || '=' || CleanValue(val)
    end
    return 0
  end
end

SayErr 'readprops: Unable to find software: ' || swname
return 4

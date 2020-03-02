/* REXX */
/* 
 * Parse a JSON stream for SMP/E Library datasets and write out a set of dataset entries (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname .

  if (swname = '' | swname = '?') then do
    call SayErr 'Syntax: readparent <swname>'
    call SayErr '  Where <swname> is the name of the software product, e.g. ZHW110'
    call SayErr '  The JSON bill of materials is read in from stdin'
    call SayErr '  The parsed values are written out to stdout'
    return 4
  end

  rc = readJSON()
  if (rc <> 0) then do
    return rc
  end
  do el = 1 to json.software.0
    parent = json.software.el.parent
    say parent
  end
  return 0

  call SayErr 'Unable to find software: ' || swname
  return 4

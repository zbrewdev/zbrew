/* REXX */
/* 
 * Parse a JSON stream for SMP/E Library datasets and write out a set of dataset entries (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname .

  if (swname = '' | swname = '?') then do
    call SayErr 'Syntax: zbrewjsonbom <swname>'
    call SayErr '  Where <swname> is the name of the software product, e.g. ZHW110'
    call SayErr '  The JSON key/value pairs are read in from stdin'
    call SayErr '  The parsed key/value pairs are written out to stdout'
    return 4
  end

  rc = readJSON()
  if (rc <> 0) then do
    return rc
  end

  do el = 1 to json.software.0
    entry = json.software.el.name
    if (entry = swname) then do
      do p = 1 to json.software.el.datasets.0
        name = json.software.el.datasets.p.dsname
        say name
      end
      return 0
    end
  end

  SayErr 'Unable to find software: ' || swname
  return 0

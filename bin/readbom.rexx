/* REXX */
/* 
 * Parse a JSON stream for SMP/E Library datasets and write out a set of dataset entries (one per line)
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname .

  if (swname = '' | swname = '?') then do
    call SayErr 'Syntax: readbom <swname>'
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
    entry = json.software.el.name
    if (entry = swname) then do
      do d = 1 to json.software.el.datasets.0
        n = json.software.el.datasets.d.dsname
        t = json.software.el.datasets.d.dstype
        p = json.software.el.datasets.d.primary
        s = json.software.el.datasets.d.secondary
        zn= json.software.el.datasets.d.zones.0
        zn= 1
        if (zn <> 1) then do
          call SayErr 'Expected exactly one zone for dataset: ' name 'but:' zn 'were specified.'
          return 4
        end
        z = json.software.el.datasets.d.zones.1
        select 
        when (t = 'ZFS') then do
            w = json.software.el.datasets.d.dddefpath
            x = json.software.el.datasets.d.mountpnt
            say n t p s z w x
          end
          when (t = 'PDS') then do
            l = json.software.el.datasets.d.lrecl
            o = json.software.el.datasets.d.dirblks
            r = json.software.el.datasets.d.recfm
            say n t r l p s z o 
          end
          otherwise do
            l = json.software.el.datasets.d.lrecl
            r = json.software.el.datasets.d.recfm
            say n t r l p s z
          end
        end
      end
      return 0
    end
  end

  call SayErr 'Unable to find software: ' || swname
  return 4

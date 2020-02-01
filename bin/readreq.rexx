/* REXX */
/* 
 * Parse a JSON stream for SMP/E Requisites
 * See: http://tech.mikefulton.ca/WebEnablementToolkit for details on the REXX JSON parsing services
 */

trace 'o'
Arg swname .

  if (swname = '' | swname = '?') then do
    call SayErr 'Syntax: readreq <swname>'
    call SayErr '  Where <swname> is the name of the software product, e.g. ZHW110'
    call SayErr '  The JSON requisites are read in from stdin'
    call SayErr '  The parsed values are written out to stdout'
    return 4
  end

  rc = readJSON()
  if (rc <> 0) then do
    return rc
  end

  found = 0
  do el = 1 to json.software.0
    entry = json.software.el.relid
    if (entry = swname) then do
      found = 1
      do p = 1 to json.software.el.prereq.0
        r = json.software.el.prereq.p.relid.0 
        do r = 1 to json.software.el.prereq.p.release.0
          rid = json.software.el.prereq.p.release.r.relid
          do f = 1 to json.software.el.prereq.p.release.r.fmids.0
            fid = json.software.el.prereq.p.release.r.fmids.f.fmid
            list = ''
            do s = 1 to json.software.el.prereq.p.release.r.fmids.f.ptfs.0
              list = list json.software.el.prereq.p.release.r.fmids.f.ptfs.s
            end
            say 'PREREQ' rid fid || list
          end
        end
      end
      do p = 1 to json.software.el.coreq.0
        r = json.software.el.coreq.p.relid.0 
        do r = 1 to json.software.el.coreq.p.release.0
          rid = json.software.el.coreq.p.release.r.relid
          do f = 1 to json.software.el.coreq.p.release.r.fmids.0
            fid = json.software.el.coreq.p.release.r.fmids.f.fmid
            list = ''
            do s = 1 to json.software.el.coreq.p.release.r.fmids.f.ptfs.0
              list = list json.software.el.coreq.p.release.r.fmids.f.ptfs.s
            end
            say 'COREQ' rid fid || list
          end
        end
      end
    end
  end

  if (\found) then do
    call SayErr 'Unable to find software: ' || swname
    return 4
  end

  return 0

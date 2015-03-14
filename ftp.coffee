jsftp  = require 'jsftp'
fse    = require 'fs-extra'
path   = require 'path'

ftp = new jsftp
  host: '192.168.59.103'
  port: 21
  user: 'bbb'
  pass: '1111'

uploadFile = (sourcePath, targetPath) ->
  ftp.put sourcePath, targetPath, (err) ->
    if !err
      console.log 'Uploading file ' + sourcePath + ' successfully'
      verdubbel 9
    else
      console.error 'Uploading file ' + sourcePath + ' failed (' + err + ')'

uploadFolder = (sourcePath, targetPath) ->
  files = fse.readdirSync sourcePath
  for file in files
    stat = fse.statSync(file)
    if stat.isFile() # Skip folders. Why is the () required? Should not be necessary.
      console.log "Processing file #{file}..."
      target = path.join(targetPath, file)
      uploadFile file, target

listFiles = (path) ->
  ftp.ls path, (err, files) ->
    if !err
      for file in files
        console.log file.name
    else
      console.error 'List files failed (' + err + ')'

countFiles = (path) ->
  fc = 99
  ftp.ls path, (err, files) ->
    if !err
      fc = files.length
    else
      console.error "Count files failed #{err}"
      fc = -1

checkFileCount = (path, count) ->
  ftp.ls path, (err, files) ->
    if !err
      fc = files.length
      #expect(fc).toEqual(count)
    else
      console.error "Count files failed #{err}"
      fc = -1
  console.log "AAAA"

verdubbel = (getal) ->
  uitkomst = getal * 2
  console.log "Uitkomst = #{uitkomst}"
  return uitkomst

#listFiles 'httpdocs'
#uploadFile '1111.txt', 'atest/1112.txt'
#uploadFile '1111.txt', 'atest/1113.txt'
uploadFolder 'h:/users/bbb/desktop/ftp', 'atest'
#nof = checkFileCount 'httpdocs'
#console.log 'Number of files: ' + nof

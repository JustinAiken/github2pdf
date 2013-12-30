github         = require "./lib/github_file_list_fetcher.coffee"
page_maker     = require "./lib/page_object.coffee"
page_processor = require "./lib/page_processor.coffee"
system         = require("system")

if system.args.length is 1
  console.log "Usage: phantomjs github2pdf.coffee rails activerecord"
  phantom.exit()
else
  owner = system.args[1]
  repo  = system.args[2]

fetcher = new github.file_list_fetcher owner, repo
fetcher.fetch_paths()

just_wait = ->
  setTimeout (->

    get_ext     = /(?:\.([^.]+))?$/
    ignore_exts = /png|gitkeep|log|ico|jpg|gif/

    urls = fetcher.urls.filter (url) ->
      file_ext = get_ext.exec(url)[1]
      return true unless file_ext
      ignore_exts.exec(file_ext) == null

    processer = new page_processor.page_processor(page_maker.page)
    processer.process(urls)
  ), 2000
just_wait()

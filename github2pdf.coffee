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
    processer = new page_processor.page_processor(page_maker.page)
    processer.process(fetcher.urls)
  ), 2000
just_wait()

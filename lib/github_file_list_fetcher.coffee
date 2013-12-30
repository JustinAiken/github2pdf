exports.file_list_fetcher = class FileListFetcher

  constructor: (@owner, @repo) ->
    # @recursive     = ""
    @recursive     = "?recursive=1"
    @github_url    = "https://api.github.com/repos/#{@owner}/#{@repo}/git/trees/master#{@recursive}"
    @github_api    = require("webpage").create()
    @urls          = []
    @finished      = false

  fetch_paths: ->
    @github_api.onLoadStarted = =>
      console.log "Loading #{@github_url}..."

    @github_api.onLoadFinished = (status) =>
      if status is "success"
        resultObject = JSON.parse(@github_api.plainText)
        for key, value of resultObject["tree"]
          if value['type'] is "blob"
            @urls.push "https://www.github.com/#{@owner}/#{@repo}/blob/master/#{value['path']}"
        @finished = true
        console.log "Done loading file list."
      else
        console.log "Failed to github."
        phantom.exit()

    @github_api.open @github_url

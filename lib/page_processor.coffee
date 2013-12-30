exports.page_processor = class PagePressor

  constructor: (@page) ->
    @loadInProgress    = false
    @jqueryResource    = "http://code.jquery.com/jquery-1.7.1.min.js"
    @resourceIndex     = 0

  process: (urls) =>
    console.log "Processing..."
    interval = setInterval( =>
      if not @loadInProgress and @resourceIndex < urls.length
        @page.open urls[@resourceIndex]
    , 250)

    @page.onLoadStarted = =>
      @loadInProgress = true
      @resourceIndex++
      console.log "Loading page " + urls[(@resourceIndex + 1)]

    @page.onLoadFinished = (status) =>
      if status is "success"
        @page.includeJs @jqueryResource, =>
          @loadInProgress = false
          elementClipRect = @page.evaluate((selector) ->
            elementToRasterize = document.querySelector(selector)
            unless elementToRasterize
              return
            else
              elementRect = elementToRasterize.getBoundingClientRect()
              top: elementRect.top
              left: elementRect.left
              width: elementRect.width
              height: elementRect.height
          , ".js-blob-data")
          unless elementClipRect
            console.log "[error] - Unable to locate element for provided selector! (.blob-wrapper)"
          else
            file_name = ("file_" + @resourceIndex + ".png")
            console.log "[info] - Clipping rectangle for selection #{file_name} - #{JSON.stringify(elementClipRect)}"
            @page.clipRect = elementClipRect
            @page.render file_name
            console.log "Saved #{file_name}"
            if @resourceIndex is urls.length
              console.log "image render complete!"
              phantom.exit()
      else
        console.log "ERROR LOADING PAGE " + @resourceIndex + ": " + urls[@resourceIndex]

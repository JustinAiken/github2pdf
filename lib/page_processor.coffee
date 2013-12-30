exports.page_processor = class PagePressor

  constructor: (@page) ->
    @loadInProgress    = false
    @jqueryResource    = "http://code.jquery.com/jquery-1.7.1.min.js"
    @resourceIndex     = 0

  process: (urls) =>
    console.log "Processing..."
    interval = setInterval( =>
      if not @loadInProgress and (@resourceIndex < urls.length)
        @page.open urls[@resourceIndex]
    , 500)

    @page.onLoadStarted = =>
      @loadInProgress = true
      console.log "[info] Loading page #{@resourceIndex + 1}: #{urls[(@resourceIndex)]}"

    @page.onLoadFinished = (status) =>
      if status is "success"
        @page.includeJs @jqueryResource, =>
          @load_clip_area(".js-blob-data")
          unless @elementClipRect
            @load_clip_area(".instapaper_body")
          unless @elementClipRect
            console.log "[error] - Unable to locate code on the page!"
          else
            file_name = ("file_" + (@resourceIndex + 1) + ".png")
            console.log "[info] - Clipping rectangle for selection #{file_name} - #{JSON.stringify(@elementClipRect)}"
            @page.clipRect = @elementClipRect
            @page.render file_name
            console.log "[info] Saved #{file_name}"
            @loadInProgress = false
            @resourceIndex++
            if @resourceIndex is urls.length
              console.log "[info] image render complete!"
              phantom.exit()
      else
        console.log "[error] Error loading page #{@resourceIndex + 1}: #{urls[(@resourceIndex)]}"

  load_clip_area: (selector_name) =>
    @elementClipRect = @page.evaluate((selector) ->
      elementToRasterize = document.querySelector(selector)
      unless elementToRasterize
        return
      else
        elementRect = elementToRasterize.getBoundingClientRect()
        top: elementRect.top
        left: elementRect.left
        width: elementRect.width
        height: elementRect.height
    , selector_name)

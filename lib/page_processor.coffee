exports.page_processor = class PagePressor

  constructor: (@page) ->
    @loadInProgress    = false
    @resourceIndex     = 0

  process: (urls) =>
    console.log "Processing..."
    interval = setInterval( =>
      if not @loadInProgress and (@resourceIndex < urls.length)
        @page.open urls[@resourceIndex]
    , 500)

    @page.onLoadStarted = =>
      @loadInProgress = true
      console.log "[info] Loading page #{@resourceIndex}: #{urls[(@resourceIndex)]}"

    @page.onLoadFinished = (status) =>
      if status is "success"
        @add_title(@get_title(), '.js-blob-data')
        @load_clip_area(".js-blob-data")
        unless @elementClipRect
          @add_title(@get_title(), '.instapaper_body')
          @load_clip_area(".instapaper_body")
        unless @elementClipRect
          console.log "[error] - Unable to locate code on the page!"
        else
          console.log "[info] - Clipping rectangle for #{@file_name()} - #{JSON.stringify(@elementClipRect)}"
          @page.clipRect = @elementClipRect
          @page.render @file_name()
          console.log "[info] Saved #{@file_name()}"
          @loadInProgress = false
          @resourceIndex++
          if @resourceIndex is urls.length
            console.log "[info] image render complete!"
            phantom.exit()
      else
        console.log "[error] Error loading page #{@resourceIndex}: #{urls[(@resourceIndex)]}"

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

  add_title: (title, selector) =>
    eval "function workaround(){ window.my_title = \"" + title + "\";}"
    @page.evaluate workaround

    eval "function workaround2(){ window.my_selector = \"" + selector + "\";}"
    @page.evaluate workaround2

    @page.evaluate =>
      $(window.my_selector).prepend "<center><h3> #{window.my_title} </h3></center>"

  get_title: ->
    return @page.url.split("blob/master/")[1]

  file_name: ->
    return "file_#{@resourceIndex}.png"

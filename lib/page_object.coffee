page = require("webpage").create()
page.viewportSize =
  width: 1920
  height: 1080
#TODO: UNCOMMENT THIS WHEN YOU CAN .PDF and still clipRect
# page.paperSize =
#   format: "A4"
#   orientation: "portrait"
#   margin: "1cm"
page.zoomFactor = 1

page.onConsoleMessage = (msg) ->
  console.log msg

exports.page = page

#import "@preview/tiaoma:0.3.0"

#let linear-gradient-to-svg(g, name) = {
  let stops = g.stops().map(((c, percentage)) => {
    "<stop offset=\"" + str(percentage / 1%) + "%\" stop-color=\"" + c.to-hex() + "\" />"
  }).join()

  let x1 = 0
  let y1 = 0
  let x2 = calc.cos(g.angle())
  let y2 = calc.sin(g.angle())

  "<linearGradient id=\"Gradient2\" x1=\"" + str(x1) + "\" x2=\"" + str(x2) + "\" y1=\"" + str(y1) + "\" y2=\"" + str(y2) + "\">" + stops + "</linearGradient>"
}

#let gradient-to-svg(g, name) = {
  if g.kind() == gradient.linear {
    linear-gradient-to-svg(g, name)
  } else {
    panic("Unsupported gradient kind")
  }
}

#let g = gradient.linear(
  //dir: ttb,
  angle: 45deg,
  blue.darken(30%),
  //green,
  fuchsia.darken(30%),
)

#let barcode(data, symbology, options: (:), ..args) = {
  let data = data
  if type(data) == str {
    data = bytes(data)
  } else if type(data) == array {
    data = bytes(data)
  }

  let (options, g) = if "fg-color" in options and type(options.fg-color) == gradient {
    let gradient-name = "Gradient2"
    let svg = gradient-to-svg(options.fg-color, gradient-name)
    options.fg-color = color.rgb("#deadbeef")
    (options, (svg, gradient-name))
  } else {
    (options, none)
  }

  let xml = tiaoma.zint-wasm.gen_with_options(
    cbor.encode((symbology: symbology, ..tiaoma._proc_options(options))),
    data,
  )

  let xml = if g != none {
    let (svg-defs, gradient-name) = g
    bytes(str(xml).replace(regex("<g id=\"barcode\" fill=\".*?\""), "<defs>"+ svg-defs + "</defs>" + "<g id=\"barcode\" fill=\"url(#" + gradient-name + ")\""))
  } else {
    xml
  }

  image(
    xml,
    format: "svg",
    ..args,
  )
}

#let qrcode(data, options: (:), ..args) = barcode(
  data,
  "QRCode",
  options: options,
  ..args,
)

#qrcode("aaa", options: (fg-color: g))



#import "bg-1.typ": drawing as bg-graphic
#import "@preview/fontawesome:0.6.0" as fa

#let _st-theme = state("theme", (
  //header-bg-color: rgb("#35414d").darken(30%),
  header-bg-color: rgb("#35414d"),
  //header-text-color: luma(220),
  header-text-color: luma(255),
  //header-subtext-color: luma(180),
  header-subtext-color: luma(220),
  accent-color: rgb("#4682b4"),
))

/// Gap between the header (colored block at the top) and body
#let HEADER_BODY_GAP = 2mm
/// Horizontal page margin
#let HORIZONTAL_PAGE_MARGIN = 12mm
/// All page margins, defined explicitly
#let PAGE_MARGIN = (
  left: HORIZONTAL_PAGE_MARGIN / 2,
  right: HORIZONTAL_PAGE_MARGIN,
  top: HORIZONTAL_PAGE_MARGIN - HEADER_BODY_GAP,
  bottom: HORIZONTAL_PAGE_MARGIN,
)

#let fa-icon(name, ..args) = context {
  text(fill: _st-theme.final().accent-color, fa.fa-icon(name, ..args))
}

#let with-left-icon(icon, body) = grid(
  columns: 2,
  gutter: 0.25em,
  if icon != none { fa-icon(icon) } else { box() },
  body
)

#let side(content) = {
  state("side-content").update(content)
}

#let cv-template(
  name: "John Doe",
  position: (),
  description: [],
  keywords: (),
  body
) = {
  let full-name = name.first + " " + name.last

  set document(
    title: [CV #full-name - Resume - #position.join(",")],
    author: full-name,
    description: [
      CV of #full-name.

      #description
    ],
    keywords: keywords,
  )
  set text(lang: "en")

  //set block(spacing: 0em)

  set page(
    margin: PAGE_MARGIN,
  )

  show link: it => context {
    set text(fill: _st-theme.final().accent-color.darken(50%))
    it
  }

  context {
    let theme = _st-theme.final()

    block(
      fill: theme.header-bg-color,
      outset: (
        left: page.margin.left,
        right: page.margin.right,
        top: page.margin.top,
        bottom: 0mm,
      ),
      inset: (
        bottom: 1.5em,
      ),
      width: 100%,
      {
        place(
          bottom + left,
          dy: 1.5em,
          dx: - page.margin.left,
          //image("bg-1.png", width: 100% + page.margin.left + page.margin.right, height: auto, fit: "cover"),
          bg-graphic(w: page.width + 2pt, h: 4cm)
        )

        block(inset: (left: 2cm), width: 100%, {
          set par(spacing: 0em)
          set align(center)
          {
            set text(fill: theme.header-text-color)
            //set text(font: "Liberation Sans")
            text(size: 3em)[
              #text(weight: "light")[#name.first]
              #text(weight: "bold")[#name.last]
            ]
          }
          v(0.75em)
          //set text(font: "DejaVu Sans")
          set text(fill: theme.header-subtext-color, weight: "bold")
          set text(size: 1.125em)
          rect(stroke: none, position.map(it => smallcaps(it)).join([ #sym.and ]))
          set text(size: 0.9em)
          //rect(stroke: none)[
          //  #emoji.phone.receiver #link("tel:" + cv-data.info.phone.replace(" ", ""), cv-data.info.phone)
          //  |
          //  #emoji.mail #link("mailto:" + cv-data.info.emails.at(0), cv-data.info.emails.at(0))
          //  |
          //  #emoji.globe.meridian #link(cv-data.info.website, cv-data.info.website.replace("https://", ""))
          //]
        })
      }
    )

    grid(
      columns: (1fr, 3fr,),
      //gutter: 1em,
      //fill: (red, green),
      inset: (col, _) => {
      if col == 0 {
          (right: (HORIZONTAL_PAGE_MARGIN / 2), y: 1mm)
        } else {
          (left: (HORIZONTAL_PAGE_MARGIN / 2), y: 1mm)
        }
      },
      {
        let d = 3.5cm
        v(-d * 3 / 4)
        align(center, block(
          width: d,
          radius: d / 8,
          stroke: theme.accent-color + 1.5pt,
          clip: true,
          image("img/me_r300.jpg"),
        ))

        set text(size: 0.8em)
        set par(justify: true)

        show heading.where(level: 1): it => block(width: 100%, above: 2em)[
          #set text(
            font: "FreeSans",
            fill: theme.accent-color,
            weight: "regular",
            size: 0.9em,
          )

          #let o = 0.5em
          #grid(
            columns: (0pt, 1fr),
            align: horizon,
            box(
              fill: theme.accent-color,
              outset: (
                left: o,
              ),
              width: 0.2em - o,
              height: 1em,
            ),
            it.body,
          )
        ]
        state("side-content").final()
      },
      grid.vline(stroke: luma(180)),
      {
        show heading.where(): it => block(width: 100%)[
          #if it.level > 2 {
            text(fill: theme.accent-color.transparentize(50%), "-" * (it.level - 2))
          }
          #text(fill: theme.accent-color)[#if it.level == 1 { smallcaps(it.body) } else { it.body }]
          #if it.level == 1 {
            box(width: 1fr, line(length: 100%, stroke: theme.accent-color))
          }
        ]

        set par(justify: true)

        body
      }
    )
  }
}

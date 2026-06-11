#import "lib.typ": *
#import "@preview/cmarker:0.1.8"
#import "tiaoma-hacked.typ": qrcode

#let render(md) = cmarker.render(md)
#let cv = yaml("cv-LC.yaml")
#let name-parts = cv.name.split(" ")
#let item-title(item) = if type(item) == str { item } else { item.title }

#let timeline(entries) = context text(size: 0.9em, table(
  columns: (1fr, 3fr),
  stroke: none,
  gutter: 0.5em,
  ..for entry in entries {
    (
      table.cell(
        stroke: (right: 1pt + theme.final().accent-color),
        align(right, text(size: 0.8em)[
          #entry.period
          #if "image" in entry {
            image(
              "img/" + entry.image,
              alt: entry.title,
              width: 70%,
              height: auto,
              fit: "contain",
            )
          }
        ]),
      ),
      [
        #text(size: 1em, weight: "bold", entry.title.trim())\
        #render(entry.description.trim())
      ],
    )
  },
))

#show: cv-template.with(
  name: (
    first: name-parts.first(),
    last: name-parts.slice(1).join(" "),
  ),
  position: (cv.role,),
  description: cv.summary,
  keywords: cv.keywords,
)

#side[
  = About me

  #render(cv.summary)

  = Interests

  #for group in cv.interests.groups [
    - #group.title
  ]

  = Contact Info

  #with-left-icon("globe", link(cv.info.website, cv.info.website))
  #let address = cv.info.home_address
  #with-left-icon("home", link(address.link)[
    #address.street, #address.number, #address.city, #address.province, #address.country
  ])
  #with-left-icon("phone", link("tel:" + cv.info.phone.replace(" ", ""), cv.info.phone))
  #with-left-icon("envelope")[
    #for (i, email) in cv.info.mails.enumerate() [
      #link("mailto:" + email, email)#if i == 0 { context text(theme.final().accent-color, sym.star.filled) }\
    ]
  ]

  #align(bottom)[
    #context align(center, link(cv.info.website, box(
      inset: 0.5em,
      radius: 0.5em,
      stroke: 2pt + theme.final().accent-color.transparentize(50%),
      qrcode(
        cv.info.website,
        options: (
          fg-color: gradient.linear(
            angle: 45deg,
            blue.darken(30%),
            purple.darken(30%),
          ),
        ),
        width: 2cm,
      ),
    )))

    = Social Links

    #set par(spacing: 0.5em)
    #for social in cv.socials {
      with-left-icon(
        social.at("icon", default: none),
        link(social.link, social.username),
      )
    }
  ]
]

#place(bottom, hide([#for entry in yaml("publications.yaml").keys() {
  ref(label(entry))
}]))

// Compact spacing keeps the printable CV within a few pages.
#let leading = 1.5em * 0.9 - 0.75em
#set block(spacing: leading)
#set par(spacing: leading)
#set par(leading: leading)

= Main Interests

#list(
  ..for group in cv.interests.groups {
    (list.item[
      *#group.title*: #render(group.description)
      #if "items" in group [
        #group.items.map(item-title).join(", ")
      ]
    ],)
  },
)

= Work Experience

#for entry in cv.work_experience [
  == #entry.role \@ #entry.company #if "period" in entry [
    (#entry.period.from \~ #entry.period.to)
  ]

  #render(entry.description)
]

= Publications & Contributions

#bibliography("publications.yaml", full: true, title: none)

= Education

#timeline(cv.education)

== Educational projects

#timeline(cv.educational_projects)

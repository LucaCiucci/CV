
#import "lib.typ": *
#import "@preview/cmarker:0.1.8"
#import "tiaoma-hacked.typ": qrcode

#let render(md) = {
  cmarker.render(md)
}

#let cv-data = yaml("cv-LC.yaml")

//#set text(font: "Roboto")

#show: cv-template.with(
  name: cv-data.name,
  position: cv-data.position,
  description: render(cv-data.professional_summary),
  keywords: cv-data.keywords,
)

#side[
  = About me

  #render(cv-data.professional_summary)

  = Interests

  #for interest in cv-data.interests [
    - #interest.topic
  ]

  = Contact Info
  #if "website" in cv-data.info {
    with-left-icon("globe", link(cv-data.info.website, cv-data.info.website))
  }
  #if "home_address" in cv-data.info {
    let home_address = cv-data.info.home_address
    let content = [
      #home_address.street, #home_address.city, #home_address.province, #home_address.country
    ]
    with-left-icon("home", if "link" in home_address {
      link(home_address.link, content)
    } else {
      content
    })
  }
  #if "phone" in cv-data.info {
    with-left-icon("phone", link("tel:" + cv-data.info.phone.replace(" ", ""), cv-data.info.phone))
  }
  #if "emails" in cv-data.info {
    with-left-icon("envelope")[
      #for (i, email) in cv-data.info.emails.enumerate() {
        [#link("mailto:" + email, email) #if i == 0 { context text(theme.final().accent-color, sym.star.filled) } \ ]
      }
    ]
  }

  #align(bottom)[
    #context align(center, link(cv-data.info.website, box(
    inset: 0.5em,
    radius: 0.5em,
    stroke: 2pt + theme.final().accent-color.transparentize(50%),
    qrcode(
      cv-data.info.website,
      options: (
        fg-color: gradient.linear(
          angle: 45deg,
          blue.darken(30%),
          purple.darken(30%),
        ),
      ),
      width: 2cm,
    )
  )))

    //= Skills
    #if "socials" in cv-data [
      = Social Links
      #set par(spacing: 0.5em)
      #for social in cv-data.socials {
        let content = social.username
        let content = if "link" in social {
          link(social.link, content)
        } else {
          content
        }
        with-left-icon(social.at("fontawesome_icon", default: none), content)
      }
    ]
  ]

  #colbreak()
  foo
]

#place(bottom, hide([#for entry in yaml("publications.yaml").keys() {
  ref(label(entry))
}]))

// WTF? See https://forum.typst.app/t/whats-the-equivalent-of-ms-words-1-5-line-spacing/1057
#let leading = 1.5em * 0.9
#let leading = leading - 0.75em // "Normalization"
#set block(spacing: leading)
#set par(spacing: leading)
#set par(leading: leading)

= Main Interests

#list(
  ..for interest in cv-data.interests {
    (list.item[
      *#interest.topic*#if "description" in interest {
        [: #render(interest.description)]
      }
    ],)
  }
)

= Work Experience

#for entry in cv-data.work_experiences [
  == #entry.position \@ #entry.at #if "time" in entry {
    if entry.time.start != none and entry.time.end != none {
      [ (#entry.time.start \~ #entry.time.end) ]
    } else if entry.time.start != none {
      [ (since #entry.time.start) ]
    } else if entry.time.end != none {
      [ (until #entry.time.end) ]
    }
  }

  #render(entry.description)
]

= Publications & Contributions

#bibliography("publications.yaml", full: true, title: none)

/*
#enum(numbering: "[1]", ..{
    for (k, v) in yaml("publications.yaml") {
        let authors = if v.author.len() == 1 {
            v.author.at(0)
        } else if v.author.len() == 2 {
            v.author.at(0) + " and " + v.author.at(1)
        } else {
            //v.author.slice(0, v.author.len() - 1).join(", ") + ", and " + v.author.at(v.author.len() - 1)
            let first = v.author.at(0);
            [#first _et al._]
        }
        let date = if "date" in v {
            let date = v.date.split("-"); // YYYY-MM-DD
            if date.len() == 3 {
                datetime(year: int(date.at(0)), month: int(date.at(1)), day: int(date.at(2))).display()
            } else if date.len() == 2 {
                datetime(year: int(date.at(0)), month: int(date.at(1)), day: 1).display()
            } else {
                panic("invalid date format")
            }
        } else {
            []
        }
        let url = if "url" in v {
            [\[Online\]. Available: #link(v.url)[#v.url]]
        } else {
            []
        }
        (enum.item[#authors: _#(v.title)_. #date #url],)
    }
})
*/

= Education

#context table(
  columns: (1fr, 3fr),
  stroke: none,
  gutter: 0.5em,
  ..for entry in cv-data.education {
    (
      table.cell(stroke: (right: 1pt + theme.final().accent-color), align(right, text(size: 0.8em)[
        #if "time" in entry {
          if entry.time.start != none and entry.time.end != none {
            [ (#entry.time.start \~ #entry.time.end) ]
          } else if entry.time.start != none {
            [ (since #entry.time.start) ]
          } else if entry.time.end != none {
            [ (until #entry.time.end) ]
          }
        } else {
          []
        }
        #if "image" in entry {
          image(
            entry.image.path,
            alt: entry.image.at("alt", default: ""),
            width: 80%,
            height: auto,
            fit: "contain",
          )
        } else {
          []
        }
      ])),
      [
        #text(size: 1em, weight: "bold", entry.title.trim())\
        #render(entry.description.trim())
      ],
    )
  }
)

== Educational projects

#context table(
  columns: (1fr, 3fr),
  stroke: none,
  gutter: 0.5em,
  ..for project in cv-data.educational_projects {
    (
      table.cell(stroke: (right: 1pt + theme.final().accent-color), align(right, text(size: 0.8em)[
        #if "time" in project {
          if project.time.start != none and project.time.end != none {
            [ (#project.time.start \~ #project.time.end) ]
          } else if project.time.start != none {
            [ (since #project.time.start) ]
          } else if project.time.end != none {
            [ (until #project.time.end) ]
          }
        } else {
          []
        }
        #if "image" in project {
          image(
            project.image.path,
            alt: project.image.at("alt", default: ""),
            width: 80%,
            height: auto,
            fit: "contain",
          )
        } else {
          []
        }
      ])),
      [
        #text(size: 1em, weight: "bold", project.title.trim())\
        #render(project.description.trim())
      ],
    )
  }
)

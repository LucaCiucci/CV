#import "@preview/cetz:0.4.2"

#set page(margin: 0cm, width: auto, height: auto, fill: white.transparentize(100%))

#import "@preview/suiji:0.5.0": *
#import "@preview/voronay:0.1.0": *
#import "@preview/voronay:0.1.0" as vv

//#let w = 19
//#let h = 2.75

#let drawing(w: 19cm, h: 2.75cm) = {
  let w = w / 1cm
  let h = h / 1cm

  let points = hilbert-point-sort({

    let rng = gen-rng-f(1234)

    let points = (
      (0, 0),
      (w, 0),
      (w, h),
      (0, h),
    )
    let v = ()
    for _ in range(200) {
      (rng, v) = uniform-f(rng, low: 0.0, high: 1.0, size: 2)
      points = points + ((v.at(0) * w, v.at(1) * h),)
    }

    points
  })

  let faces = delaunay-triangulate(points)
  let dual-vertices = get-circumcenters(points, faces)
  let dual-edges = get-dual-edges(faces)

  let canvas = cetz.canvas(length: 1cm, {
    import cetz.draw: *

    let col-1(t) = {
      let t1 = (t) / w - 0.125
      let colors = (blue, green)
      //let colors = (purple, rgb(64, 0, 255))
      color.mix((colors.at(0).transparentize(20%), 1 - t1), (colors.at(1).transparentize(20%), t1))
    }
    let col(p) = col-1(p.at(0)).transparentize(75%)

    // Your drawing code goes here
    for face in faces {
      let (a, b, c) = face
      let pa = points.at(a)
      let pb = points.at(b)
      let pc = points.at(c)
      let mid = ((pa.at(0) + pb.at(0) + pc.at(0)) / 3, (pa.at(1) + pb.at(1) + pc.at(1)) / 3)
      merge-path(fill: col(pa).transparentize(150% * mid.at(1) / h), stroke: 1.0pt + gray.transparentize(90%).transparentize(100% - 100% * pa.at(0) / w), {
        line(pa, pb)
        line(pb, pc)
        line(pc, pa)
      })
    }

    let c-color(c, p) = c.transparentize(100% * (p.at(0) / 10))

    for point in points {
      if point.at(0) <= 0 or point.at(0) >= w or point.at(1) <= 0 or point.at(1) >= h {
        continue
      }

      circle(
        point,
        radius: 0.025,
        //stroke: 0.5pt + c-color(gray, point),
        stroke: none,
        fill: white.transparentize(80%),
      )
    }

    for dual-edge in dual-edges {
      let (a, b) = dual-edge
      let pa = dual-vertices.at(a)
      let pb = dual-vertices.at(b)
      let pc = ((pa.at(0) + pb.at(0)) / 2, (pa.at(1) + pb.at(1)) / 2)

      if pa.at(0) <= 0 or pa.at(0) >= w or pa.at(1) <= 0 or pa.at(1) >= h {
        continue
      }

      if pb.at(0) <= 0 or pb.at(0) >= w or pb.at(1) <= 0 or pb.at(1) >= h {
        continue
      }

      line(
        pa,
        pb,
        stroke: 1.0pt + rgb("#b9228c").transparentize(50%).transparentize(100% * pc.at(0) / w),
      )
    }

    //for idx in path-1.zip(path-1.slice(1, path-1.len())) {
    //  let p = points.at(idx.at(0))
    //  let t = points.at(idx.at(1))
    //  line(
    //    p,
    //    t,
    //    stroke: 1.5pt + red.transparentize(50%),
    //  )
    //}
  })

  canvas
}

#rect(inset: 0pt, stroke: none, drawing())

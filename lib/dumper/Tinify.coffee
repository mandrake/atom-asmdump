module.exports =
Tinify =
  hex: (n, digits) ->
    # console.log n, parseInt(n), parseInt(n.toString())
    n = parseInt(n).toString(16).toUpperCase()
    n = "0#{n}" while n.length < digits
    return "0x#{n}"

  instr: (i) ->
    r = ""
    if i.length == 1
      r += "<div style='display:inline' class='operator'>#{i[0]}</div>"
    else
      r += "<div style='display:inline' class='operator'>#{i[0]} </div>"
    for operand in i.slice(1, i.length-1)
      q = operand.split(':')
      r += "<div style='display:inline' class='#{q[0]}'>#{q[1]}</div>, "

    q = i[i.length-1].split(':')
    r += "<div style='display:inline' class='#{q[0]}'>#{q[1]}</div>"

    r

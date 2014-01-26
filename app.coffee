$ ->
  $("#userNavigation").append """
    <li class="menuDivider"></li>
    <li role="menuitem"><a class="navSubmenu" href="#" onclick="return MathToggle(this)" role="button">Stop LaTeX rendering</a></li>
  """

  head = document.getElementsByTagName("head")[0]
  script = document.createElement("script")
  script.type = "text/x-mathjax-config"
  script[(if window.opera then "innerHTML" else "text")] = """
    MathJax.Hub.Config({
      tex2jax: {
        inlineMath: [["$", "$"]],
        displayMath: [["$$", "$$"]]
      }, showMathMenu: false
    });

    var MathQueue = null

    var MathEnable = function() {
      MathQueue = setInterval(function() {
        MathJax.Hub.queue.pending = 0
        MathJax.Hub.Queue(["Typeset", MathJax.Hub])
      }, 2000)
    }

    var MathRevert = function() {
      var HTML = MathJax.HTML
        , jax = MathJax.Hub.getAllJax()

      for (var i = 0, ii = jax.length; i < ii; i++) {
        var script = jax[i].SourceElement()
          , tex = jax[i].originalText

        if (script.type.match(/display/))
          tex = "$$ "+ tex +" $$"
        else
          tex = "$"+ tex +"$"

        jax[i].Remove()

        var preview = script.previousSibling
        if (preview && preview.className === "MathJax_Preview")
          preview.parentNode.removeChild(preview)

        preview = HTML.Element("span", {className: "MathJax_Preview"}, [tex])
        script.parentNode.insertBefore(preview,script)
      }

      window.clearInterval(MathQueue)
      MathJax.Hub.queue.pending = 1
    }

    var MathText = ""
    var MathToggle = function(el) {
      console.log(el.innerHTML)
      console.log(el.innerHTML == "Stop LaTeX rendering")
      MathText = ""

      if (el.innerHTML == "Stop LaTeX rendering") {
        el.innerHTML = "Running..."
        MathText = "Start LaTeX rendering"
        MathRevert()

        setTimeout(function() { el.innerHTML = MathText }, 1000)
        return false
      }
      if (el.innerHTML == "Start LaTeX rendering") {
        el.innerHTML = "Running..."
        MathText = "Stop LaTeX rendering"
        MathEnable()

        setTimeout(function() { el.innerHTML = MathText }, 2000)
        return false
      }
      return false
    }

    MathEnable()
  """
  head.appendChild(script)
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src  = "https://c328740.ssl.cf1.rackcdn.com/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"
  head.appendChild(script)

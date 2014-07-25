$ ->
  $("#userNavigation").append """
    <li class="menuDivider"></li>
    <li role="menuitem"><a class="navSubmenu" href="#" onclick="return MathToggle(this)" role="button">Stop LaTeX rendering</a></li>
  """

  head = document.getElementsByTagName("head")[0]
  script = document.createElement("script")
  script.type = "text/x-mathjax-config"
  script.text = """
    MathJax.Hub.Config({
      tex2jax: {
        inlineMath: [["$ ", " $"]],
        displayMath: [["$$ ", " $$"]],
        processClass: "userContent"
      },
      jax: ["input/TeX", "output/SVG"],
      showMathMenu: false
    });

    MathJax.Hub.setRenderer("SVG")

    var MathQueue = null

    var MathEnable = function() {
      MathQueue = setInterval(function() {
        var _userContent, _wbr, _all_span, _span;
        // wbr remove
        _userContent = document.getElementsByClassName("userContent")
        for (var i = 0, ii = _userContent.length; i < ii; i++) {
          _wbr = _userContent[i].getElementsByTagName("wbr")
          for (var j = 0, jj = _wbr.length; j < jj; j++) {
            _wbr[j].remove()
          }
        }

        // span.word_break remove
        _userContent = document.getElementsByClassName("userContent")
        for (var i = 0, ii = _userContent.length; i < ii; i++) {
          _wbr = _userContent[i].getElementsByClassName("word_break")
          for (var j = 0, jj = _wbr.length; j < jj; j++) {
            _wbr[j].remove()
          }
        }

        // span tag unwrap
        _userContent = document.getElementsByClassName("userContent")
        for (var i = 0, ii = _userContent.length; i < ii; i++) {
          _all_span = _userContent[i].getElementsByTagName("span")
          _span = []
          for (var j = 0, jj = _all_span.length; j < jj; j++) {
            if (! _all_span[j].getAttribute("class"))
              _span.push(_all_span[j])
          }

          while (_span.length) {
            var _parent = _span[0].parentNode
            if (_span[0].firstChild) {
              _parent.insertBefore(_span[0].firstChild, _span[0])
            }
            if (_parent) {
              _parent.removeChild(_span[0])
            } else { break }
          }
        }

        MathJax.Hub.Queue(["setRenderer", MathJax.Hub, "SVG"])
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
          tex = "$ "+ tex +" $"

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
  script.src = "//cdn.mathjax.org/mathjax/latest/unpacked/MathJax.js?config=TeX-AMS-MML_SVG"
  head.appendChild(script)

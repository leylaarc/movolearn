(function () {
  var APP_STORE_URL = "https://apps.apple.com/us/app/movo-learn/id6822238237";

  document.querySelectorAll("[data-app-store]").forEach(function (link) {
    link.setAttribute("href", APP_STORE_URL);
  });

  var lesson = document.getElementById("lesson-play");
  if (lesson) mountLesson(lesson);

  var toggle = document.querySelector(".nav-toggle");
  var menu = document.getElementById("nav-menu");
  if (!toggle || !menu) return;

  function setOpen(open) {
    menu.classList.toggle("is-open", open);
    toggle.setAttribute("aria-expanded", open ? "true" : "false");
  }

  toggle.addEventListener("click", function () {
    setOpen(toggle.getAttribute("aria-expanded") !== "true");
  });

  menu.querySelectorAll("a").forEach(function (link) {
    link.addEventListener("click", function () {
      setOpen(false);
    });
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") setOpen(false);
  });

  function mountLesson(root) {
    var labels = ["Story", "Launch", "Question", "Word"];
    var pipsFor = { story: 0, count: 1, read: 1, ask: 2, word: 3 };
    var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    var num = document.getElementById("play-num");
    var note = document.getElementById("play-note");
    var step = document.getElementById("play-step");
    var pips = root.querySelectorAll(".play-pip");
    var askNext = root.querySelector('[data-beat="ask"] .play-next');
    var readNext = root.querySelector('[data-beat="read"] .play-next');
    var choices = root.querySelector(".play-choices");
    var launching = false;
    var countTimer = 0;

    function show(name, moveFocus) {
      root.querySelectorAll("[data-beat]").forEach(function (el) {
        var on = el.getAttribute("data-beat") === name;
        el.hidden = !on;
        el.classList.toggle("is-on", on);
      });
      var pip = pipsFor[name];
      step.textContent = labels[pip] + " · " + (pip + 1) + " of 4";
      pips.forEach(function (mark, index) {
        mark.classList.toggle("is-done", index <= pip);
      });
      if (!moveFocus) return;
      var slide = root.querySelector('[data-beat="' + name + '"]');
      var target = slide.querySelector(".play-q, .play-word, .play-next");
      if (target) target.focus();
    }

    function clearAnswers() {
      choices.removeAttribute("data-locked");
      choices.querySelectorAll("button").forEach(function (button) {
        button.classList.remove("is-wrong", "is-right", "is-shake");
      });
      note.textContent = "";
      askNext.hidden = true;
    }

    function resetRocket() {
      window.clearTimeout(countTimer);
      launching = false;
      root.classList.remove("is-flying", "is-up");
      num.textContent = "";
      num.classList.remove("is-pop");
      readNext.hidden = false;
    }

    function finishFlight() {
      root.classList.add("is-up");
      num.textContent = "";
      readNext.hidden = false;
      launching = false;
      show("read", true);
    }

    function launch() {
      if (launching) return;
      launching = true;
      readNext.hidden = true;
      show("count", false);
      var line = root.querySelector(".play-countline");
      if (line) line.focus();
      var n = 5;

      function tick() {
        if (n < 1) {
          root.classList.add("is-flying");
          if (reduce) finishFlight();
          else countTimer = window.setTimeout(finishFlight, 1400);
          return;
        }
        num.textContent = String(n);
        num.classList.remove("is-pop");
        void num.offsetWidth;
        num.classList.add("is-pop");
        n -= 1;
        if (reduce) tick();
        else countTimer = window.setTimeout(tick, 560);
      }

      tick();
    }

    root.addEventListener("click", function (event) {
      var go = event.target.closest("[data-go]");
      if (go && root.contains(go)) {
        var dest = go.getAttribute("data-go");
        if (dest === "launch") {
          launch();
          return;
        }
        if (dest === "story") {
          resetRocket();
          clearAnswers();
          show("story", true);
          return;
        }
        show(dest, true);
        return;
      }

      var choice = event.target.closest("[data-answer]");
      if (!choice || !root.contains(choice)) return;
      if (choices.getAttribute("data-locked") === "true") return;

      choices.querySelectorAll("button").forEach(function (button) {
        button.classList.remove("is-wrong", "is-shake");
      });

      if (choice.getAttribute("data-answer") === "right") {
        choices.setAttribute("data-locked", "true");
        choice.classList.add("is-right");
        note.textContent = "She counts down from five.";
        askNext.hidden = false;
        askNext.focus();
        return;
      }

      choice.classList.add("is-wrong", "is-shake");
      note.textContent = "The story says she counts down from five.";
    });

    show("story", false);
  }
})();

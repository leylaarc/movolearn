(function () {
  var APP_STORE_URL = "https://apps.apple.com/us/app/movo-learn/id6822238237";

  document.querySelectorAll("[data-app-store]").forEach(function (link) {
    link.setAttribute("href", APP_STORE_URL);
  });

  var lesson = document.getElementById("lesson-play");
  if (lesson) mountLesson(lesson);
  mountLayers();
  mountFaq();
  mountHelp();
  mountRiver();
  if (!document.documentElement.classList.contains("is-gated")) mountReveal();

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

  function mountLayers() {
    var known = { lesson: 1, how: 1, topics: 1, parents: 1, look: 1 };
    window.addEventListener("hashchange", function () {
      var id = location.hash.slice(1);
      if (!known[id]) return;
      var root = document.getElementById(id);
      if (!root) return;
      var head = root.querySelector("h2");
      if (!head) return;
      if (!head.hasAttribute("tabindex")) head.setAttribute("tabindex", "-1");
      head.focus({ preventScroll: true });
    });

    document.addEventListener("keydown", function (event) {
      if (event.key !== "Escape") return;
      if (location.hash === "#topics") {
        var picked = document.querySelector(".topic-stage input:checked:not(.go-all)");
        var back = document.querySelector(".topic-stage .go-all");
        if (picked && back) {
          back.checked = true;
          return;
        }
      }
      if (location.hash === "#how") {
        var deeper = document.querySelector(".step-stage input:checked:not(.go-1)");
        var start = document.querySelector(".step-stage .go-1");
        if (deeper && start) {
          start.checked = true;
          return;
        }
      }
      var id = location.hash.slice(1);
      if (known[id] && id !== "look") location.hash = "look";
    });
  }

  function mountFaq() {
    var faqs = document.querySelectorAll(".faq details");
    if (!faqs.length) return;

    function openFromHash() {
      var id = location.hash.slice(1);
      if (!id) return;
      var el = document.getElementById(id);
      if (el && el.tagName === "DETAILS") el.open = true;
    }

    openFromHash();
    window.addEventListener("hashchange", openFromHash);
  }

  function mountHelp() {
    var river = document.getElementById("help-river");
    var answers = document.getElementById("help-answers");
    if (!river || !answers) return;

    function show(id) {
      var button = river.querySelector('[data-target="' + id + '"]');
      var article = document.getElementById(id);
      if (!button || !article || !answers.contains(article)) return false;
      river.querySelectorAll("button").forEach(function (item) {
        var on = item === button;
        item.classList.toggle("is-on", on);
        item.setAttribute("aria-selected", on ? "true" : "false");
      });
      answers.querySelectorAll("article").forEach(function (item) {
        var on = item === article;
        item.classList.toggle("is-on", on);
        item.setAttribute("aria-hidden", on ? "false" : "true");
      });
      article.classList.remove("is-swap");
      void article.offsetWidth;
      article.classList.add("is-swap");
      button.scrollIntoView({ inline: "center", block: "nearest", behavior: "smooth" });
      return true;
    }

    river.hidden = false;
    document.documentElement.classList.add("is-help");
    answers.querySelectorAll("article").forEach(function (item) {
      item.setAttribute("aria-hidden", item.classList.contains("is-on") ? "false" : "true");
    });

    river.addEventListener("click", function (event) {
      var button = event.target.closest("button");
      if (!button || !river.contains(button)) return;
      var id = button.getAttribute("data-target");
      if (!show(id)) return;
      if (history.replaceState) history.replaceState(null, "", "#" + id);
    });

    function fromHash() {
      var id = location.hash.slice(1);
      if (id) show(id);
    }

    fromHash();
    window.addEventListener("hashchange", fromHash);
  }

  function mountRiver() {
    var river = document.getElementById("topic-river");
    var line = document.getElementById("river-line");
    if (!river || !line) return;
    river.addEventListener("click", function (event) {
      var button = event.target.closest("button");
      if (!button || !river.contains(button)) return;
      river.querySelectorAll("button").forEach(function (item) {
        item.classList.toggle("is-on", item === button);
      });
      line.textContent = button.getAttribute("data-line") || "";
      line.classList.remove("is-swap");
      void line.offsetWidth;
      line.classList.add("is-swap");
      button.scrollIntoView({ inline: "center", block: "nearest", behavior: "smooth" });
    });
  }

  var revealed = false;
  function mountReveal() {
    if (revealed) return;
    revealed = true;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    if (!("IntersectionObserver" in window)) return;
    var nodes = document.querySelectorAll(".flow-statement, .flow-band, .flow-parents");
    nodes.forEach(function (node) { node.classList.add("reveal"); });
    var seen = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-in");
        seen.unobserve(entry.target);
      });
    }, { threshold: 0.18 });
    nodes.forEach(function (node) { seen.observe(node); });
  }

  function mountLesson(root) {
    var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    var num = document.getElementById("play-num");
    var note = document.getElementById("play-note");
    var result = document.getElementById("play-result");
    var choices = root.querySelector(".play-choices");
    var launching = false;
    var countTimer = 0;

    function showStore() {
      num.textContent = "";
      launching = false;
      root.classList.remove("is-flying");
      root.classList.add("is-settled");
      document.documentElement.classList.remove("is-gated");
      document.documentElement.classList.add("is-store");
    }

    function finishFlight() {
      window.setTimeout(showStore, reduce ? 0 : 280);
    }

    function launch() {
      if (launching) return;
      launching = true;
      var n = 5;

      function tick() {
        if (n < 1) {
          root.classList.add("is-flying");
          if (reduce) finishFlight();
          else countTimer = window.setTimeout(finishFlight, 1500);
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

    var details = document.getElementById("open-details");
    if (details) {
      details.addEventListener("click", function () {
        document.documentElement.classList.remove("is-store");
        document.documentElement.classList.add("is-open");
        mountReveal();
        var site = document.getElementById("site");
        if (site) site.scrollIntoView({ behavior: reduce ? "auto" : "smooth", block: "start" });
      });
    }

    root.addEventListener("click", function (event) {
      var choice = event.target.closest("[data-answer]");
      if (!choice || !choices || !root.contains(choice)) return;
      if (choices.getAttribute("data-locked") === "true") return;

      choices.querySelectorAll("button").forEach(function (button) {
        button.classList.remove("is-wrong", "is-shake");
      });

      if (choice.getAttribute("data-answer") === "right") {
        choices.setAttribute("data-locked", "true");
        choice.classList.add("is-right");
        note.textContent = "She counts down from five.";
        if (result) result.hidden = false;
        return;
      }

      choice.classList.add("is-wrong", "is-shake");
      note.textContent = "The story says she counts down from five.";
    });

    window.setTimeout(launch, reduce ? 0 : 700);
  }
})();

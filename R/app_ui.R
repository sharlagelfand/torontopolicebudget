#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @importFrom shinyWidgets pickerInput
#' @noRd
app_ui <- function(request) {
  tagList(
    tags$style(HTML("
    body, pre { font-size: 22pt; }
  ")),
    fluidPage(
      rep_br(5),
      column(width = 8, offset = 2,
      epoxy::epoxyHTML(
        .id = "demo",
        .watch = list(click = c("year", "program")),
        "<center><p>In {{year}}, the Toronto Police Service budget was <b>{{times}}</b> times {{times_direction}} the {{program}} budget.</p></center>"),
      tags$style(
        # not necessary, just looks cool
        '[data-epoxy-input-click]:hover { background-color: #fcf0cb; }'
      )
    ),
    rep_br(10),
    HTML("Data: <a href = 'https://open.toronto.ca/dataset/budget-operating-budget-program-summary-by-expenditure-category/'> Toronto Open Data</a>, Code: <a href = 'https://github.com/sharlagelfand/torontobudget'>GitHub</a>")
  )
  )
}

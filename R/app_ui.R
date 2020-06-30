#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fillPage(
      fillRow(
        class = "main-container",
        div(
          class = "main-text",
          epoxy::epoxyHTML(
            .id = "demo",
            "<p>In ",
            epoxy:::epoxyInlineClickChoice(
              "year",
              "Year",
              as.character(2019:2014)
            ),
            " the Toronto Police Service budget was <b>{{times}}</b> times {{times_direction}} the ",
            epoxy:::epoxyInlineClickChoice(
              "program",
              "City Program",
              {
                programs <- unique(budget[["program"]])
                programs[which(programs != "Toronto Police Service")]
              }
            ),
            " budget.</p>"
          ),
          rep_br(1),
          HTML("<p>Data: <a href = 'https://open.toronto.ca/dataset/budget-operating-budget-program-summary-by-expenditure-category/'> Toronto Open Data</a>, Code: <a href = 'https://github.com/sharlagelfand/torontobudget'>GitHub</a></p>")
        )
      )
    )
  )
}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "Toronto Police Budget"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session ) {
  year <- reactive({
    input$demo_year_clicked
    as.character(sample(2014:2019, 1))
  })

  program <- reactive({
    input$demo_program_clicked
    programs <- unique(budget[["program"]])
    sample(programs[which(programs != "Toronto Police Service")], 1)
  })

  police_times <- reactive({
    program_amount <- program_expenses[[year()]][[program()]]
    police_amount <- police_expenses[[year()]]
    round(police_amount / program_amount, 2)
  })

  times_direction <- reactive({
    ifelse(police_times() > 1, 'larger than', 'as large as')
  })

  output$demo <- epoxy::renderEpoxyHTML(
    year = year(),
    times = police_times(),
    times_direction = times_direction(),
    program = program()
  )
}

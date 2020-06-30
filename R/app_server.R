#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session ) {

  police_times <- reactive({
    program_amount <- program_expenses[[input$year]][[input$program]]
    police_amount <- police_expenses[[input$year]]
    round(police_amount / program_amount, 2)
  })

  times_direction <- reactive({
    ifelse(police_times() > 1, 'larger than', 'as large as')
  })

  output$demo <- epoxy::renderEpoxyHTML(
    times = police_times(),
    times_direction = times_direction()
  )
}

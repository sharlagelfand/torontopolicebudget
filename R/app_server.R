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
    amount <- round(police_amount / program_amount, 2)
    if (length(amount)) amount else "¯\\_(ツ)_/"
  })

  times_direction <- reactive({
    if (is.character(police_times())) return("larger than")
    ifelse(police_times() > 1, 'larger than', 'as large as')
  })

  output$budget <- epoxy::renderEpoxyHTML(
    times = police_times(),
    times_direction = times_direction()
  )
}

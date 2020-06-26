#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @importFrom shinyWidgets pickerInput
#' @noRd
app_ui <- function(request) {
  tagList(
    tags$style(HTML("
    body, pre { font-size: 22pt; }
    body {
      transition: all 0.2s ease-in-out;
    }
    .epoxy-inline-clickChoice-input:hover,
    .epoxy-inline-clickChoice-input:focus {
      background-color: #FFF3B7;
      outline: none;
    }
    :root {
      --epoxy-inline-clickChoice-color-hover: #F21B3F;
      --epoxy-inline-clickChoice-color-focus: #7E3F8F;
    }
    #budget-container {
      min-height: 90vh;
      display: flex;
      padding: 1em;
      align-items: center;
    }
    #budget {
      max-width: 600px;
      text-align: center;
    }
    #budget-container {
      justify-content: center;
    }
    #footer { text-align: center; }
    @media screen and (min-width: 1200px) {
      body, pre { font-size: 36pt; }
      #budget { max-width: 850px; }
    }
    @media screen and (max-width: 768px) {
      #footer { font-size: 12pt; }
    }
    ")),
    fluidPage(
      div(
        id = "budget-container",
        epoxy::epoxyHTML(
          .id = "budget",
          "In ",
          epoxy:::epoxyInlineClickChoice("year", "Year", sort(unique(budget$year))),
          ", the Toronto Police Service budget was {{strong times}} times ",
          "{{times_direction}} the ",
          epoxy:::epoxyInlineClickChoice("program", "Toronto City Program", sample(unique(budget$program))),
          " budget."
        )
      ),
      div(
        id = "footer",
        "Data:",
        tags$a(
          href = "https://open.toronto.ca/dataset/budget-operating-budget-program-summary-by-expenditure-category/",
          "Toronto Open Data",
          .noWS = "after"
        ),
        ", Code:",
        tags$a(
          href = "https://github.com/sharlagelfand/torontobudget",
          "GitHub"
        )
      )
    )
  )
}

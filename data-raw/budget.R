library(ckanr)
library(opendatatoronto)
library(dplyr)
library(stringr)
library(purrr)
library(readxl)
library(janitor)

odt_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/"

resources <- tibble(year = 2014:2019) %>%
  mutate(name = glue::glue("approved-operating-budget-summary-{year}"))

resources <- package_show(id = "2c90a5d3-5598-4c02-abf2-169456c8f1f1", url = odt_url, as = "table")[["resources"]] %>%
  as_tibble() %>%
  select(name, url, format) %>%
  inner_join(resources, by = "name") %>%
  mutate(file = here::here("data-raw", glue::glue("{name}.xlsx")))

walk2(resources[["url"]], resources[["file"]], ~ ckan_fetch(x = .x, store = "disk", path = .y))

resources <- resources %>%
  mutate(sheet = case_when(
    year == 2014 ~ "2014",
    year == 2015 ~ "summary",
    year == 2016 ~ "Open Data Summary",
    year == 2017 ~ "2017",
    year == 2018 ~ "Open Data",
    year == 2019 ~ "2019"
  ))

resources <- resources %>%
  mutate(
    data = map2(file, sheet, ~ read_excel(path = .x, sheet = .y, col_types = "text")),
    data = map2(data, year, function(x, y) {
      col <- as.character(y)
      x[["amount"]] <- as.numeric(x[[col]])
      x <- x[which(names(x) != col)]
    })
  )

budget <- resources %>%
  split(.$year) %>%
  map("data") %>%
  map(unlist, recursive = FALSE) %>%
  bind_rows(.id = "year") %>%
  clean_names() %>%
  select(year, program, category = category_name, expense_revenue, service, activity, amount)

budget <- budget %>%
  mutate(program = case_when(
    program == "Long Term Care Homes & Services" ~ "Long-Term Care Homes & Services",
    program == "Office of the Chief financial Officer" ~ "Office of the Chief Financial Officer",
    TRUE ~ program
  ))

usethis::use_data(budget, overwrite = TRUE)

expenses <- budget %>%
  filter(expense_revenue == "Expenses")

program_expenses <- expenses %>%
  group_by(year, program) %>%
  summarise(amount = sum(amount)) %>%
  ungroup()

program_expenses <- program_expenses %>%
  split(.$year) %>%
  map(~ split(.x, .$program)) %>%
  map_depth(2, "amount")

usethis::use_data(program_expenses, overwrite = TRUE)

police_expenses <- expenses %>%
  filter(program == "Toronto Police Service") %>%
  group_by(year, program) %>%
  summarise(amount = sum(amount)) %>%
  ungroup()

police_expenses <- police_expenses %>%
  split(.$year) %>%
  map("amount")

usethis::use_data(police_expenses, overwrite = TRUE)

box::use(
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, uiOutput],
)

box::use(
  app/view/demo_table
)

box::use(
  app/logic/gargledata[fetch_data],
  app/logic/data_transformation,
  app/logic/tables[create_demo_table]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    demo_table$ui(ns("my_table")),
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    df <- fetch_data()
    df_list <- data_transformation$transform_data(df)
    df_table <- create_demo_table(df_list$demo_df)

    demo_table$server("my_table", demo_df = df_table)
  })
}

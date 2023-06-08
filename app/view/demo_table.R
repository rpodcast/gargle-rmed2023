box::use(
  reactable[...],
  htmlwidgets[JS],
  Tplyr[...],
  glue[glue]
)

box::use(
  shiny[moduleServer, NS, req, reactive, tagList]
)

box::use(
  app/logic/tables[create_demo_table]
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(ns("df_table")),
    reactableOutput(ns("demoList"))
  )
}

#' @export
server <- function(id, demo_df) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    row <- reactive({
      message("entered row")
      
      demo_df[input$row$index,1]$row_id
    })
    col <- reactive(input$col$column)

    output$df_table <- renderReactable(
      reactable(
        demo_df,
        sortable = FALSE,
        onClick = JS(glue("function(rowInfo, colInfo) {
                      if (window.Shiny) {
                        Shiny.setInputValue(<<row_p>>, { index: rowInfo.index + 1 })
                        Shiny.setInputValue(<<col_p>>, { column: colInfo.id })
                        }
                    }", 
                    row_p = ns("row"),
                    col_p = ns("col"),
                    .open = "<<",
                    .close = ">>"
        ))
      )
    )

    sub_data <- reactive({
      req(row(), col())
      tmp <- get_meta_subset(tab, row(), col())
      tmp
    })

    output$demoList <- renderReactable({
      req(sub_data())
      reactable(
        sub_data(),
        sortable = FALSE,
        height = 450,
        defaultPageSize = 11
      )
    })
  })
}

library(Tplyr)
demo_df <- new_df_list$demo_df

tdf <- tplyr_table(demo_df, treat) |>
  add_layer(group_count(gender, by = "Gender")) |>
  add_layer(group_count(smoking, by = "Smoking")) |>
  add_layer(group_count(pain, by = "Pain")) |>
  add_layer(group_desc(age, by = "Age (years)"))

tdf |> build()

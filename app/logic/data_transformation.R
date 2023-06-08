# declare dependencies
box::use(
  tidyr[pivot_longer, pivot_wider, separate],
  dplyr[filter, mutate, select, row_number, rename, rename_with, left_join, bind_rows, arrange, case_when, case_match],
  tidyselect[starts_with, ends_with, one_of],
  labelled,
  forcats[fct],
  utils[View]
)

# declare dependent functions
box::use(
  app/logic/gargledata
)

transform_data <- function(data) {
  # extract PDF table of data dictionary PDF in docs folder PDF file
  # use that to add labels: https://www.pipinghotdata.com/posts/2022-09-13-the-case-for-variable-labels-in-r/
  gargle_metadata <- tibble::tribble(
    ~variable,             ~variable_label,
    "gender",              "Gender",
    "asa",                 "American Society of Anesthesiologists physical status",
    "calcBMI",             "Body Mass Index",
    "age",                 "Age",
    "mallampati",          "Mallampati Score",
    "smoking",             "Smoking Status",
    "pain",                "Preoperative Pain",
    "treat",               "Intervention",
    "surgerySize",         "Surgery Size",
    "cough",               "Amount of coughing",
    "throatPain",          "Sore throat pain score at rest",
    "swallowPain",         "Sore throat pain score during swallowing"
  )

  df <- data |>
    mutate(id = row_number()) |>
    rename_with(~stringr::str_replace(., "^preOp_", "")) |>
    rename_with(~stringr::str_replace(., "^intraOp_", ""))

  # demo/baseline variables
  # transform key categorical variables into factors
  demo_df <- df |>
    select(id, gender, asa, calcBMI, age, mallampati, smoking, pain, treat, surgerySize, extubation_cough) |>
    # recode key variables
    mutate(
      gender = case_match(
        gender,
        0 ~ "Male",
        1 ~ "Female"
      ),
      asa = case_match(
        asa,
        1 ~ "Normal",
        2 ~ "Mild",
        3 ~ "Severe"
      ),
      smoking = case_match(
        smoking,
        1 ~ "Current",
        2 ~ "Past",
        3 ~ "Never" 
      ),
      pain = case_match(
        pain,
        0 ~ "No",
        1 ~ "Yes"
      ),
      treat = case_match(
        treat,
        0 ~ "Sugar 5g",
        1 ~ "Licorice 0.5g"
      ),
      surgerySize = case_match(
        surgerySize,
        1 ~ "Small",
        2 ~ "Medium",
        3 ~ "Large"
      ),
      extubation_cough = case_match(
        extubation_cough,
        0 ~ "No cough",
        1 ~ "Mild",
        2 ~ "Moderate",
        3 ~ "Severe"
      )
    ) |>
    # convert key variables to factor
    mutate(
      asa = fct(asa, levels = c("Normal", "Mild", "Severe")),
      smoking = fct(smoking, levels = c("Current", "Past", "Never")),
      pain = fct(pain, levels = c("No", "Yes")),
      surgerySize = fct(surgerySize, levels = c("Small", "Medium", "Large")),
      extubation_cough = fct(extubation_cough, levels = c("No cough", "Mild", "Moderate", "Severe"))
    )

  # pacu variables
  pacu_df <- df |>
    select(id, starts_with("pacu")) |>
    pivot_longer(-id, names_to = c("time", "param"), values_to = "value", names_sep = "_")
  
  # postOp variables
  postOp_df <- df |>
    select(id, starts_with("postOp")) |>
    pivot_longer(-id, names_to = c("time", "param"), values_to = "value", names_sep = "_")

  # pod variables
  pod_df <- df |>
    select(id, starts_with("pod")) |>
    pivot_longer(-id, names_to = c("time", "param"), values_to = "value", names_sep = "_")

  # combine efficacy data sets by row
  eff_df <- bind_rows(
    pacu_df,
    postOp_df,
    pod_df
  )
  
  final_df <- demo_df |>
    left_join(eff_df, by = "id") |>
    arrange(id, param)

  return(
    list(
      demo_df = demo_df,
      eff_df = eff_df,
      final_df = final_df
    )
  )
}

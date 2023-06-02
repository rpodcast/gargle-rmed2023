# declare dependencies
box::use(
  tidyr,
  dplyr
)

# declare dependent functions
box::use(
  app/logic/gargledata
)

transform_data <- function(data) {
  # extract PDF table of data dictionary PDF in docs folder PDF file
  # use that to add labels: https://www.pipinghotdata.com/posts/2022-09-13-the-case-for-variable-labels-in-r/
  # demographic/baseline char variables: gender, asa, calcBMI, age, mallampati, smoking, pain, surgerySize
  # experiment variables: trt
  # efficacy variables: cough, throatPain, swallowPain
  # pacu30min, pacu90min, postOp4hour, pod1am

  # step 1: create a random patient ID for later use
  # TODO: Add code

  # step 2: obtain baseline characteristics
}

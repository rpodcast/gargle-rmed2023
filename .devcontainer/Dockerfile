FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.3

# key dependencies for utilities
RUN apt-get update -qq \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libxt6 curl libglpk-dev

# install R package dependencies
RUN install2.r tidyr rlang shiny htmltools shinyWidgets rstudio/shinyuieditor rstudio/bslib Tplyr echarts4r rhino shiny.blueprint shiny.telemetry crew gt crosstalk plotly httpgd languageserver medicaldata janitor shinyvalidate plumber
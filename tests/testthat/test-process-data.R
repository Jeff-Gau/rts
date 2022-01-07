test_that("Out of schedule times result in an error", {
  expect_error(
    get_survey(
      full_data,
      severity = "moderate/severe",
      schedule = "36",
      survey = "parent"
    )
  )
})

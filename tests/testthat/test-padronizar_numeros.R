tester <- function(numeros = "01") padronizar_numeros(numeros)

test_that("da erro com inputs != de caracteres e numeros", {
  expect_error(tester(as.factor(22290140)))
})

test_that("lida com vetores vazios corretamente", {
  expect_equal(tester(character(0)), character(0))
  expect_equal(tester(integer(0)), character(0))
  expect_equal(tester(numeric(0)), character(0))
})

test_that("padroniza corretamente - numero", {
  skip_if_not_installed("tibble")

  gabarito <- tibble::tribble(
    ~original,   ~padronizado_esperado,
    1,           "1",
    1.1,         "1",
    NA_integer_, NA_character_,
    NA_real_,    NA_character_
  )

  expect_equal(tester(gabarito$original), gabarito$padronizado_esperado)
})

test_that("padroniza corretamente - numero", {
  skip_if_not_installed("tibble")

  gabarito <- tibble::tribble(
    ~original,   ~padronizado_esperado,
    1,           "1",
    1.1,         "1",
    NA_integer_, NA_character_,
    NA_real_,    NA_character_
  )

  expect_equal(tester(gabarito$original), gabarito$padronizado_esperado)
})

test_that("padroniza corretamente - caracter", {
  skip_if_not_installed("tibble")

  gabarito <- tibble::tribble(
    ~original,     ~padronizado_esperado,
    " 1 ",         "1",
    "s/n",         "S/N",
    "NÚMERO",      "NUMERO",

    "0001",        "1",
    "01 02",       "1 2",

    "SN",          "S/N",
    "SNº",         "S/N",
    "S N",         "S/N",
    "S Nº",        "S/N",
    "S.N.",        "S/N",
    "S.Nº.",       "S/N",
    "S. N.",       "S/N",
    "S. Nº.",      "S/N",
    "S/N",         "S/N",
    "S/Nº",        "S/N",
    "S./N.",       "S/N",
    "S./Nº.",      "S/N",
    "S./N. S N",   "S/N S/N",
    "SEM NUMERO",  "S/N",
    "X",           "S/N",
    "XX",          "S/N",
    "0",           "S/N",
    "00",          "S/N",
    "-",           "S/N",
    "--",          "S/N",

    "",            NA_character_,
    NA_character_, NA_character_
  )

  expect_equal(tester(gabarito$original), gabarito$padronizado_esperado)
})

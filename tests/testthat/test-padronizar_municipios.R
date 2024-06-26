test_that("da erro com inputs != de caracteres e municipios", {
  expect_error(padronizar_municipios(as.factor(3304557)))
})

test_that("padroniza corretamente", {
  expect_equal(padronizar_municipios("3304557"), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios("330455"), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios("03304557"), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios("0330455"), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios(" 3304557 "), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios("rio de janeiro"), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios(NA_character_), NA_character_)
  expect_equal(padronizar_municipios(""), NA_character_)

  expect_equal(padronizar_municipios(3304557), "RIO DE JANEIRO")
  expect_equal(padronizar_municipios(NA_integer_), NA_character_)
  expect_equal(padronizar_municipios(c(3304557, NA)), c("RIO DE JANEIRO", NA_character_))

  # manipulacao de strings
  expect_equal(padronizar_municipios("SÃO PAULO"), "SAO PAULO")
  expect_equal(padronizar_municipios("MOJI MIRIM"), "MOGI MIRIM")
  expect_equal(padronizar_municipios("PARATI"), "PARATY")
})

test_that("lida com vetores vazios corretamente", {
  expect_equal(padronizar_municipios(character(0)), character(0))
  expect_equal(padronizar_municipios(integer(0)), character(0))
  expect_equal(padronizar_municipios(numeric(0)), character(0))
})

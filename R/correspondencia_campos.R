#' Correspondência entre campos e colunas
#'
#' Cria um vetor de caracteres que especifica as colunas que representam cada
#' campo de endereço em um dataframe.
#'
#' @param logradouro,numero,complemento,cep,bairro,municipio,estado Uma string.
#'   O nome da coluna que representa o respectivo campo de endereço no
#'   dataframe. Pode ser `NULL`, no caso do campo não estar listado. Ao menos um
#'   dos campos deve receber um valor não nulo.
#'
#' @return Um vetor nomeado de caracteres, em que os nomes representam os campos
#'   do endereço e os valores as colunas que os descrevem no dataframe.
#'
#' @examples
#' correspondencia_campos(
#'   logradouro = "logradouro",
#'   numero = "nroLogradouro",
#'   complemento = "complemento",
#'   cep = "cep",
#'   bairro = "bairro",
#'   municipio = "codmun_dom",
#'   estado = "uf_dom"
#' )
#'
#' @export
correspondencia_campos <- function(logradouro = NULL,
                                   numero = NULL,
                                   complemento = NULL,
                                   cep = NULL,
                                   bairro = NULL,
                                   municipio = NULL,
                                   estado = NULL) {
  col <- checkmate::makeAssertCollection()
  checkmate::assert_string(logradouro, null.ok = TRUE, add = col)
  checkmate::assert_string(numero, null.ok = TRUE, add = col)
  checkmate::assert_string(complemento, null.ok = TRUE, add = col)
  checkmate::assert_string(cep, null.ok = TRUE, add = col)
  checkmate::assert_string(bairro, null.ok = TRUE, add = col)
  checkmate::assert_string(municipio, null.ok = TRUE, add = col)
  checkmate::assert_string(estado, null.ok = TRUE, add = col)
  checkmate::reportAssertions(col)

  vetor_correspondencia <- c(
    logradouro = logradouro,
    numero = numero,
    complemento = complemento,
    cep = cep,
    bairro = bairro,
    municipio = municipio,
    estado = estado
  )

  if (is.null(vetor_correspondencia)) erro_correspondencia_nula()

  return(vetor_correspondencia)
}

erro_correspondencia_nula <- function() {
  cli::cli_abort(
    paste0(
      "Ao menos um dos argumentos da {.fn correspondencia_campos} ",
      "deve ser diferente de {.code NULL}."
    ),
    class = "correspondencia_nula",
    call = rlang::caller_env()
  )
}

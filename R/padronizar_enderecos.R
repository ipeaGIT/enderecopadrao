#' Padronizar endereços
#'
#' Padroniza um dataframe contendo diversos campos de um endereço.
#'
#' @param enderecos Um dataframe. Os endereços a serem padronizados. Cada uma de
#'   suas colunas deve corresponder a um campo do endereço (e.g. logradouro,
#'   cidade, bairro, etc).
#' @param campos_do_endereco Um vetor nomeado de caracteres. A correspondência
#'   entre os campos a serem padronizados (nomes do vetor) e as colunas que os
#'   representam no dataframe (valores em si). A função
#'   `correspondencia_campos()` facilita a criação deste vetor, fazendo também
#'   algumas verificações do conteúdo imputado. Argumentos dessa função com
#'   valor `NULL` são ignorados, e ao menos um valor diferente de nulo deve ser
#'   fornecido. Caso deseje criar o vetor manualmente, note que seus nomes devem
#'   ser os mesmos nomes dos parâmetros da função `correspondencia_campos()`.
#' @param manter_cols_extras Um logical. Se colunas não especificadas em
#'   `campos_do_endereco` devem ser mantidas ou não (por exemplo, uma coluna de
#'   id do conjunto de dados sendo padronizado). Por padrão, `TRUE`.
#'
#' @return Um dataframe com colunas adicionais, representando os campos de
#'   endereço padronizados.
#'
#' @examples
#' enderecos <- data.frame(
#'   id = 1,
#'   logradouro = "r ns sra da piedade",
#'   nroLogradouro = 20,
#'   complemento = "qd 20",
#'   cep = 25220020,
#'   bairro = "jd botanico",
#'   codmun_dom = 3304557,
#'   uf_dom = "rj"
#' )
#'
#' campos <- correspondencia_campos(
#'   logradouro = "logradouro",
#'   numero = "nroLogradouro",
#'   complemento = "complemento",
#'   cep = "cep",
#'   bairro = "bairro",
#'   municipio = "codmun_dom",
#'   estado = "uf_dom"
#' )
#'
#' padronizar_enderecos(enderecos, campos)
#'
#' padronizar_enderecos(enderecos, campos, manter_cols_extras = FALSE)
#'
#' @export
padronizar_enderecos <- function(
  enderecos,
  campos_do_endereco = correspondencia_campos(),
  manter_cols_extras = TRUE
) {
  checkmate::assert_data_frame(enderecos)
  checkmate::assert_logical(manter_cols_extras, any.missing = FALSE, len = 1)
  checa_campos_do_endereco(campos_do_endereco, enderecos)

  enderecos_padrao <- data.table::as.data.table(enderecos)

  campos_padronizados <- paste0(campos_do_endereco, "_padr")
  names(campos_padronizados) <- names(campos_do_endereco)

  if ("logradouro" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["logradouro"]
    col_padr <- campos_padronizados["logradouro"]
    enderecos_padrao[
      ,
      c(col_padr) := padronizar_logradouros(enderecos[[col_orig]])
    ]
  }

  if ("numero" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["numero"]
    col_padr <- campos_padronizados["numero"]
    enderecos_padrao[
      ,
      c(col_padr) := padronizar_numeros(enderecos[[col_orig]])
    ]
  }

  if ("complemento" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["complemento"]
    col_padr <- campos_padronizados["complemento"]
    enderecos_padrao[
      ,
      c(col_padr) := padronizar_complementos(enderecos[[col_orig]])
    ]
  }

  if ("cep" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["cep"]
    col_padr <- campos_padronizados["cep"]
    enderecos_padrao[, c(col_padr) := padronizar_ceps(enderecos[[col_orig]])]
  }

  if ("bairro" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["bairro"]
    col_padr <- campos_padronizados["bairro"]
    enderecos_padrao[, c(col_padr) := padronizar_bairros(enderecos[[col_orig]])]
  }

  if ("municipio" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["municipio"]
    col_padr <- campos_padronizados["municipio"]
    enderecos_padrao[
      ,
      c(col_padr) := padronizar_municipios(enderecos[[col_orig]])
    ]
  }

  if ("estado" %in% names(campos_do_endereco)) {
    col_orig <- campos_do_endereco["estado"]
    col_padr <- campos_padronizados["estado"]
    enderecos_padrao[
      ,
      c(col_padr) := padronizar_estados(enderecos[[col_orig]])
    ]
  }

  campos_extras <- setdiff(names(enderecos), campos_do_endereco)

  if (!manter_cols_extras) {
    enderecos_padrao[, (campos_extras) := NULL]
  } else {
    data.table::setcolorder(enderecos_padrao, campos_extras)
  }

  return(enderecos_padrao[])
}

checa_campos_do_endereco <- function(campos_do_endereco, enderecos) {
  col <- checkmate::makeAssertCollection()
  checkmate::assert_character(
    campos_do_endereco,
    any.missing = FALSE,
    add = col
  )
  checkmate::assert_names(
    names(campos_do_endereco),
    type = "unique",
    subset.of = c(
      "logradouro",
      "numero",
      "complemento",
      "cep",
      "bairro",
      "municipio",
      "estado"
    ),
    add = col
  )
  checkmate::assert_names(
    campos_do_endereco,
    subset.of = names(enderecos),
    add = col
  )
  checkmate::reportAssertions(col)

  return(invisible(TRUE))
}

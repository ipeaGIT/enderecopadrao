#' Padronizar estados
#'
#' Padroniza um vetor de caracteres ou números representando estados
#' brasileiros. Veja a seção *Detalhes* para mais informações sobre a
#' padronização.
#'
#' @param estados Um vetor de caracteres ou números. Os estados a serem
#'   padronizados.
#'
#' @return Um vetor de caracteres com os estados padronizados.
#'
#' @section Detalhes:
#' Operações realizadas durante a padronização:
#'
#' 1. conversão para caracter, se o input for numérico;
#' 2. remoção de espaços em branco antes e depois dos valores e remoção de
#' espaços em excesso entre palavras;
#' 3. conversão de caracteres para caixa alta;
#' 4. remoção de zeros à esquerda;
#' 5. busca, a partir do código numérico ou da abreviação da UF, do nome
#' completo de cada estado;
#' 6. caso a busca não tenha encontrado determinado valor, remoção de acentos e
#' caracteres não ASCII - esta etapa, de manipulação de strings, pode ser
#' incrementada para adequação futura a bases de dados com as quais as etapas
#' anteriores não resultem em valores padronizados.
#'
#' @examples
#' estados <- c("21", "021", "MA", " 21", " MA ", "ma", "", NA)
#' padronizar_estados(estados)
#'
#' estados <- c(21, NA)
#' padronizar_estados(estados)
#'
#' @export
padronizar_estados <- function(estados) {
  checkmate::assert(
    checkmate::check_character(estados),
    checkmate::check_numeric(estados),
    combine = "or"
  )

  estados_dedup <- unique(estados)

  # alguns estados podem vir vazios e devem permanecer vazios ao final.
  # identificamos o indice dos estados vazios para "reesvazia-los" ao final, ja
  # que a sequencia de operacoes abaixo acabaria atribuindo um valor a eles

  indice_estado_vazio <- which(is.na(estados))

  if (is.numeric(estados_dedup)) {
    estados_padrao_dedup <- formatC(estados_dedup, format = "d")
  } else {
    estados_padrao_dedup <- stringr::str_squish(estados_dedup)
    estados_padrao_dedup <- toupper(estados_padrao_dedup)
    estados_padrao_dedup <- stringr::str_replace_all(
      estados_padrao_dedup,
      c("\\b0+(\\d+)\\b" = "\\1")
    )
  }

  # em uma primeira etapa, fazemos uma busca dos nomes completos dos estados a
  # partir de seus códigos numericos e de suas abreviacoes. apos essa etapa, se
  # ainda houver algum registro de valor diferente dos nomes completos padroes,
  # fazemos uma serie de manipulacoes de string que tomam um pouco mais de tempo

  vetor_busca_com_cod <- vetor_busca_com_abrev <- codigos_estados$nome_estado
  names(vetor_busca_com_cod) <- codigos_estados$codigo_estado
  names(vetor_busca_com_abrev) <- codigos_estados$abrev_estado

  result_busca_com_cod <- vetor_busca_com_cod[estados_padrao_dedup]
  result_busca_com_abrev <- vetor_busca_com_abrev[estados_padrao_dedup]

  estados_padrao_dedup <- ifelse(
    is.na(result_busca_com_cod),
    result_busca_com_abrev,
    result_busca_com_cod
  )
  names(estados_padrao_dedup) <- NULL

  estados_padrao_dedup <- ifelse(
    is.na(estados_padrao_dedup),
    estados,
    estados_padrao_dedup
  )

  if (any(! estados_padrao_dedup %in% c(codigos_estados$nome_estado, "", NA))) {
    # aqui com certeza podem entrar outras manipulacoes, como substituir GDE por
    # GRANDE (em RIO GDE DO SUL, por exemplo), corrigir registros com ortografia
    # errada, etc. mas ainda nao encontrei nenhuma base com esse problemas,
    # entao optei por deixar apenas o comando abaixo como exemplo de manipulacao
    # a ser feita, e a medida que forem surgindo problemas vou atualizando aqui.

    estados_padrao_dedup <- stringi::stri_trans_general(
      estados_padrao_dedup,
      "Latin-ASCII"
    )
  }

  names(estados_padrao_dedup) <- estados_dedup
  estados_padrao <- estados_padrao_dedup[as.character(estados)]
  names(estados_padrao) <- NULL

  estados_padrao[indice_estado_vazio] <- NA_character_

  return(estados_padrao)
}

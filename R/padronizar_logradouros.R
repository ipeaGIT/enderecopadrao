#' Padronizar logradouros
#'
#' Padroniza um vetor de caracteres representando logradouros de municípios
#' brasileiros. Veja a seção *Detalhes* para mais informações sobre a
#' padronização.
#'
#' @param logradouros Um vetor de caracteres. Os logradouros a serem
#'   padronizados.
#'
#' @return Um vetor de caracteres com os logradouros padronizados.
#'
#' @section Detalhes:
#' Operações realizadas durante a padronização:
#'
#' 1. remoção de espaços em branco antes e depois das strings e remoção de
#' espaços em excesso entre palavras;
#' 2. conversão de caracteres para caixa alta;
#' 3. remoção de acentos e caracteres não ASCII;
#' 4. adição de espaços após abreviações sinalizadas por pontos.
#'
#' @examples
#' logradouros <- c("r. gen.. glicério")
#' padronizar_logradouros(logradouros)
#'
#' @export
padronizar_logradouros <- function(logradouros) {
  checkmate::assert_character(logradouros)

  logradouros_dedup <- unique(logradouros)

  # alguns logradouros podem vir vazios e devem permanecer vazios ao final.
  # identificamos o indice dos logradouros vazios para "reesvazia-los" ao final,
  # ja que a sequencia de operacoes abaixo acabaria atribuindo um valor a eles

  indice_logradouro_vazio <- which(is.na(logradouros) | logradouros == "")

  logradouros_padrao_dedup <- stringr::str_squish(logradouros_dedup)
  logradouros_padrao_dedup <- toupper(logradouros_padrao_dedup)
  logradouros_padrao_dedup <- stringi::stri_trans_general(
    logradouros_padrao_dedup,
    "Latin-ASCII"
  )

  logradouros_padrao_dedup <- stringr::str_replace_all(
    logradouros_padrao_dedup,
    c(
      # pontuacao
      "\\.\\.+" = ".",         # ponto repetido
      ",,+" = ",",             # virgula repetida
      "\\.([^ ])" = "\\. \\1", # garantir que haja um espaco depois dos pontos
      ",([^ ])" = ", \\1",     # garantir que haja um espaco depois das virgulas
      " \\." = "\\.",          # garantir que não haja um espaco antes dos pontos
      " ," = ",",          # garantir que não haja um espaco antes dos pontos

      # tipos de logradouro
      "^RU?\\b(\\.|,)?" = "RUA",                                 # R. AZUL -> RUA AZUL
      "^(RUA|RODOVIA|ROD(\\.|,)?) (RUA|RU?)\\b(\\.|,)?" = "RUA", # RUA R. AZUL -> RUA AZUL
      "^RUA\\b(-|,|\\.) *" = "RUA ",                             # R-AZUL -> RUA AZUL

      "^(ROD|RDV)\\b(\\.|,)?" = "RODOVIA",
      "^(RODOVIA|RUA) (RODOVIA|ROD|RDV)\\b(\\.|,)?" = "RODOVIA",
      "^RODOVIA\\b(-|,|\\.) *" = "RODOVIA ",

      # outros pra rodovia: "RO", "RO D", "ROV"

      "^AV(E|N|D|DA|I)?\\b(\\.|,)?" = "AVENIDA",
      "^(AVENIDA|RUA|RODOVIA) (AVENIDA|AV(E|N|D|DA|I)?)\\b(\\.|,)?" = "AVENIDA",
      "^AVENIDA\\b(-|,|\\.) *" = "AVENIDA ",

      # EST pode ser estancia ou estrada. será que deveríamos assumir que é estrada mesmo?
      "^(ESTR?|ETR)\\b(\\.|,)?" = "ESTRADA",
      "^(ESTRADA|RUA|RODOVIA) (ESTRADA|ESTR?|ETR)\\b(\\.|,)?" = "ESTRADA",
      "^ESTRADA\\b(-|,|\\.) *" = "ESTRADA ",

      "^(PCA?|PRC)\\b(\\.|,)?" = "PRACA",
      "^(PRACA|RUA|RODOVIA) (PRACA|PCA?|PRC)\\b(\\.|,)?" = "PRACA",
      "^PRACA\\b(-|,|\\.) *" = "PRACA ",

      "^BE?CO?\\b(\\.|,)?" = "BECO",
      "^(BECO|RUA|RODOVIA) BE?CO?\\b(\\.|,)?" = "BECO",
      "^BE?CO?\\b(-|,|\\.) *" = "BECO ",

      "^(TV|TRV|TRAV?)\\b(\\.|,)?" = "TRAVESSA", # tem varios casos de TR tambem, mas varios desses sao abreviacao de TRECHO, entao eh dificil fazer uma generalizacao
      "^(TRAVESSA|RODOVIA) (TRAVESSA|TV|TRV|TRAV?)\\b(\\.|,)?" = "TRAVESSA", # nao botei RUA nas opcoes iniciais porque tem varios ruas que realmente sao RUA TRAVESSA ...
      "^TRAVESSA\\b(-|,|\\.) *" = "TRAVESSA ",
      "^(TRAVESSA|RUA|RODOVIA) (TRAVESSA|TV|TRV|TRAV?)\\b- *" = "TRAVESSA ", # aqui ja acho que faz sentido botar o RUA porque so da match com padroes como RUA TRAVESSA-1

      "^P((A?R)?Q|QU?E)\\b(\\.|,)?" = "PARQUE",
      "^(PARQUE|RODOVIA) (PARQUE|P((A?R)?Q|QU?E))\\b(\\.|,)?" = "PARQUE", # mesmo caso de travessa
      "^PARQUE\\b(-|,|\\.) *" = "PARQUE ",
      "^(PARQUE|RUA|RODOVIA) (PARQUE|P((A?R)?Q|QU?E))\\b- *" = "PARQUE ", # mesmo caso de travessa

      "^ALA?\\b(\\.|,)?" = "ALAMEDA",
      "^ALAMEDA (ALAMEDA|ALA?)\\b(\\.|,)?" = "ALAMEDA", # mesmo caso de travessa
      "^RODOVIA (ALAMEDA|ALA)\\b(\\.|,)?" = "ALAMEDA", # RODOVIA precisa ser separado porque nesse caso nao podemos mudar RODOVIA AL pra ALAMEDA, ja que pode ser uma rodovia estadual de alagoas
      "^ALAMEDA\\b(-|,|\\.) *" = "ALAMEDA ",
      "^(ALAMEDA|RUA) (ALAMEDA|ALA?)\\b- *" = "ALAMEDA ", # mesmo caso de travessa
      "^RODOVIA (ALAMEDA|ALA)\\b- *" = "ALAMEDA ", # mesmo caso acima

      "^LOT\\b(\\.|,)?" = "LOTEAMENTO",
      "^(LOTEAMENTO|RUA|RODOVIA) LOT\\b(\\.|,)?" = "LOTEAMENTO",
      "^LOTEAMENTO?\\b(-|,|\\.) *" = "LOTEAMENTO ",

      "^LOC\\b(\\.|,)?" = "LOCALIDADE",
      "^(LOCALIDADE|RUA) LOC\\b(\\.|,)?" = "LOCALIDADE",
      "^LOCALIDADE?\\b(-|,|\\.) *" = "LOCALIDADE ",

      "^VL\\b(\\.|,)?" = "VILA",
      "^VILA VILA\\b(\\.|,)?" = "VILA",
      "^VILA?\\b(-|,|\\.) *" = "VILA ",

      "^LAD\\b(\\.|,)?" = "LADEIRA",
      "^LADEIRA LADEIRA\\b(\\.|,)?" = "LADEIRA",
      "^LADEIRA?\\b(-|,|\\.) *" = "LADEIRA ",

      "^DT\\b(\\.|,)?" = "DISTRITO",
      "\\bDISTR?\\b\\.?" = "DISTRITO",
      "^DISTRITO DISTRITO\\b(\\.|,)?" = "DISTRITO",
      "^DISTRITO?\\b(-|,|\\.) *" = "DISTRITO ",

      "^NUC\\b(\\.|,)?" = "NUCLEO",
      "^NUCLEO NUCLEO\\b(\\.|,)?" = "NUCLEO",
      "^NUCLEO?\\b(-|,|\\.) *" = "NUCLEO ",

      "^L(RG|GO)\\b(\\.|,)?" = "LARGO",
      "^LARGO L(RG|GO)\\b(\\.|,)?" = "LARGO",
      "^LARGO?\\b(-|,|\\.) *" = "LARGO ",

      # estabelecimentos
      "^AER(OP)?\\b(\\.|,)?" = "AEROPORTO", # sera que vale? tem uns casos estranhos aqui, e.g. "AER GUANANDY, 1", "AER WASHINGTON LUIZ, 3318"
      "^AEROPORTO (AEROPORTO|AER)\\b(\\.|,)?" = "AEROPORTO",
      "^AEROPORTO INT(ERN?)?\\b(\\.|,)?" = "AEROPORTO INTERNACIONAL",

      "^COND\\b(\\.|,)?" = "CONDOMINIO",
      "^(CONDOMINIO|RODOVIA) (CONDOMINIO|COND)\\b(\\.|,)?" = "CONDOMINIO",

      "^FAZ(EN?)?\\b\\.?" = "FAZENDA",
      "^(FAZENDA|RODOVIA) (FAZ(EN?)?|FAZENDA)\\b(\\.|,)?" = "FAZENDA",

      "^COL\\b\\.?" = "COLONIA",
      "\\bCOLONIA AGRI?C?\\b\\.?" = "COLONIA AGRICOLA",

      # títulos
      "\\bSTA\\b\\.?" = "SANTA",
      "\\bSTO\\b\\.?" = "SANTO",
      "\\b(N(OS|SS?A?)?\\.? S(RA|ENHORA)|(NOSSA|NSA\\.?) (S(RA?)?|SEN(H(OR)?)?))\\b\\.?" = "NOSSA SENHORA",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( DE?)?|NOSSA SENHORA) (FAT.*|LO?UR.*|SANTANA|GUADALUPE|NAZ.*|COP*)\\b" = "NOSSA SENHORA DE \\4",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( D(A|E)?)?|NOSSA SENHORA) (GRACA|VITORIA|PENHA|CONCEICAO|PAZ|GUIA|AJUDA|CANDELARIA|PURIFICACAO|SAUDE|PIEDADE|ABADIA|GLORIA|SALETE|APRESENTACAO)\\b" = "NOSSA SENHORA DA \\5",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( D(A|E)?)?|NOSSA SENHORA D(A|E)) (APA.*|AUX.*|MEDIANEIRA|CONSOLADORA)\\b" = "NOSSA SENHORA \\6",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( D(OS?)?)?|NOSSA SENHORA) (NAVEGANTES)\\b" = "NOSSA SENHORA DOS \\5",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( DO?)?|NOSSA SENHORA) (CARMO|LIVRAMENTO|RETIRO|SION|ROSARIO|PILAR|ROCIO|CAMINHO|DESTERRO|BOM CONSELHO|AMPARO|PERP.*|P.* S.*)\\b" = "NOSSA SENHORA DO \\4",
      "\\b(NS?\\.? S(R|ENH?)?\\.?( D(AS?)?)?|NOSSA SENHORA) (GRACAS|DORES)\\b" = "NOSSA SENHORA DAS \\5",
      "\\bNOSSO (SR?|SEN)\\b\\.?" = "NOSSO SENHOR",

      "\\bALM?TE\\b\\.?" = "ALMIRANTE",
      "\\bMAL\\b\\.?" = "MARECHAL",
      "\\b(GEN|GAL)\\b\\.?" = "GENERAL",
      "\\b(SGTO?|SARG)\\b\\.?" = "SARGENTO",
      "\\b(PRIMEIRO|PRIM|1)\\.? SARGENTO\\b" = "PRIMEIRO-SARGENTO",
      "\\b(SEGUNDO|SEG|2)\\.? SARGENTO\\b" = "SEGUNDO-SARGENTO",
      "\\b(TERCEIRO|TERC|3)\\.? SARGENTO\\b" = "TERCEIRO-SARGENTO",
      "\\bCEL\\b\\.?" = "CORONEL",
      "\\bBRIG\\b\\.?" = "BRIGADEIRO",
      "\\bTEN\\b\\.?" = "TENENTE",
      "\\bTENENTE CORONEL\\b" = "TENENTE-CORONEL",
      "\\bTENENTE BRIGADEIRO\\b" = "TENENTE-BRIGADEIRO",
      "\\bTENENTE AVIADOR\\b" = "TENENTE-AVIADOR",
      "\\bSUB TENENTE\\b" = "SUBTENENTE",
      "\\b(PRIMEIRO|PRIM\\.?) TENENTE\\b" = "PRIMEIRO-TENENTE",
      "\\b(SEGUNDO|SEG\\.?) TENENTE\\b" = "SEGUNDO-TENENTE",
      "\\bSOLD\\b\\.?" = "SOLDADO",
      "\\bMAJ\\b\\.?" = "MAJOR",

      "\\bPROF\\b\\.?" = "PROFESSOR",
      "\\bPROFA\\b\\.?" = "PROFESSORA",
      "\\bDR\\b\\.?" = "DOUTOR",
      "\\bDRA\\b\\.?" = "DOUTORA",
      "\\bENG\\b\\.?" = "ENGENHEIRO",
      "\\bENGA\\b\\.?" = "ENGENHEIRA",
      "\\bPE\\b\\." = "PADRE", # PE pode ser só pe mesmo, entao forcando o PE. (com ponto) pra ser PADRE
      "\\bMONS\\b\\.?" = "MONSENHOR",

      "\\bPRES(ID)?\\b\\.?" = "PRESIDENTE",
      "\\bGOV\\b\\.?" = "GOVERNADOR",
      "\\bSEN\\b\\.?" = "SENADOR",
      "\\bPREF\\b\\.?" = "PREFEITO",
      "\\bDEP\\b\\.?" = "DEPUTADO",
      "\\bVER\\b\\.?[^$ ]" = "VEREADOR",
      "\\bESPL?\\.? (DOS )?MIN(IST(ERIOS?)?)?\\b\\.?" = "ESPLANADA DOS MINISTERIOS",
      "\\bMIN\\b\\.?[^$ ]" = "MINISTRO",

      # abreviacoes
      "\\bUNID\\b\\.?" = "UNIDADE",
      "\\b(CJ|CONJ)\\b\\.?" = "CONJUNTO",
      "\\bLT\\b\\.?" = "LOTE",
      "\\bLTS\\b\\.?" = "LOTES",
      "\\bQDA?\\b\\.?" = "QUADRA",
      "\\bLJ\\b\\.?" = "LOJA",
      "\\bLJS\\b\\.?" = "LOJAS",
      "\\bAPTO?\\b\\.?" = "APARTAMENTO",
      "\\bBL\\b\\.?" = "BLOCO",
      "\\bSLS\\b\\.?" = "SALAS",
      "\\bEDI?F\\.? EMP\\b\\.?" = "EDIFICIO EMPRESARIAL",
      "\\bEDI?F\\b\\.?" = "EDIFICIO",
      "\\bCOND\\b\\.?" = "CONDOMINIO", # apareceu antes mas como tipo de logradouro
      "\\bKM\\b\\." = "KM",
      "\\bS\\.? ?N\\b\\.?" = "S/N",
      # SL pode ser sobreloja ou sala

      # intersecao entre nomes e titulos
      #   - D. pode ser muita coisa (e.g. dom vs dona), entao nao da pra
      #   simplesmente assumir que vai ser um valor especifico, so no contexto
      #   - MAR pode ser realmente só mar ou uma abreviação pra marechal
      "\\bD\\b\\.? (PEDRO|JOAO|HENRIQUE)" = "DOM \\1",
      "\\bI(NF)?\\.? DOM\\b" = "INFANTE DOM",
      "\\bMAR\\b\\.? ((CARMONA|JOFRE|HERMES|MALLET|DEODORO|MARCIANO|OTAVIO|FLORIANO|BARBACENA|FIUZA|MASCARENHAS|MASCARENHA|TITO|FONTENELLE|XAVIER|BITENCOURT|BITTENCOURT|CRAVEIRO|OLIMPO|CANDIDO|RONDON|HENRIQUE|MIGUEL|JUAREZ|FONTENELE|FONTENELLE|DEADORO|HASTIMPHILO|NIEMEYER|JOSE|LINO|MANOEL|HUMB?|HUMBERTO|ARTHUR|ANTONIO|NOBREGA|CASTELO|DEODORA)\\b)" = "MARECHAL \\1",

      # nomes
      "\\b(GETULHO|JETULHO|JETULIO|JETULHO|GET|JET)\\.? VARGAS\\b" = "GETULIO VARGAS",
      "\\b(J(U[A-Z]*)?)\\.? (K(U[A-Z]*)?)\\b\\.?" = "JUSCELINO KUBITSCHEK",

      # expressoes hifenizadas ou nao
      #   - beira-mar deveria ter pelo novo acordo ortografico, mas a grafia da
      #   grande maioria das ruas (se nao todas, nao tenho certeza) eh beira
      #   mar, sem hifen
      "\\bBEIRA-MAR\\b" = "BEIRA MAR",

      # rodovias
      "\\b(RODOVIA|BR\\.?|RODOVIA BR\\.?) CENTO D?E (DESESSEIS|DESESEIS|DEZESSEIS|DEZESEIS)\\b" = "RODOVIA BR-116",
      "\\b(RODOVIA|BR\\.?|RODOVIA BR\\.?) CENTO D?E H?UM\\b" = "RODOVIA BR-101",
      # será que essas duas de baixo valem?
      "\\bBR\\.? ?(\\d{3})" = "BR-\\1",
      # essa aqui é complicada... AL, AP, SE, entre outras, são siglas que podem aparecer sem serem rodovias
      "\\b(RO|AC|AM|RR|PA|AP|TO|MA|PI|CE|RN|PB|PE|AL|SE|BA|MG|ES|RJ|SP|PR|SC|RS|MS|MT|GO|DF) ?(\\d{3})" = "\\1-\\2",

      # 0 à esquerda
      " (0)(\\d+)" = " \\2",

      # correcoes de problemas ocasionados pelos filtros acima
      "\\bTENENTE SHI\\b" = "TEN SHI",
      "\\bHO SHI MINISTRO\\b" = "HO SHI MIN"

      # ALM é um caso complicado, pode ser alameda ou almirante. inclusive no mesmo endereço podem aparecer os dois rs
    )
  )

  names(logradouros_padrao_dedup) <- logradouros_dedup
  logradouros_padrao <- logradouros_padrao_dedup[logradouros]
  names(logradouros_padrao) <- NULL

  logradouros_padrao[indice_logradouro_vazio] <- ""

  return(logradouros_padrao)
}

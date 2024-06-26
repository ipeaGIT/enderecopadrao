tester <- function(tipos = "R") {
  padronizar_tipos_de_logradouro(tipos)
}

test_that("da erro com inputs != de caracteres", {
  expect_error(tester(12))
})

test_that("lida com vetores vazios corretamente", {
  expect_equal(tester(character(0)), character(0))
})

test_that("padroniza corretamente", {
  skip_if_not_installed("tibble")

  gabarito <- tibble::tribble(
    ~original,    ~padronizado_esperado,
    " RUA ",      "RUA",
    "rua",        "RUA",
    "RU\u00C1",   "RUA", # RUÁ
    "RUA..",      "RUA",
    "..RUA",      ". RUA",
    "1.000",      NA_character_,
    "ROD.UM",     "RODOVIA UM",
    "RUA - UM",   "RUA UM",
    "RUA . UM",   "RUA UM",
    "RUA.",       "RUA",
    "\"",         "'",
    "AA",         NA_character_,
    "AAAAAA",     NA_character_,
    "1",          NA_character_,
    "1111",       NA_character_,
    "-",          NA_character_,
    "--",         NA_character_,

    "1A",         NA_character_,
    "1O",         NA_character_,
    "10A",        NA_character_,
    "11A RUA",    "RUA",
    "1O BECO",    "BECO",

    "R",          "RUA",
    "R.",         "RUA",
    "RA",         "RUA",
    "RA.",        "RUA",
    "RU",         "RUA",
    "RU.",        "RUA",

    "ROD",        "RODOVIA",
    "ROD.",       "RODOVIA",
    "RDV",        "RODOVIA",
    "RDV.",       "RODOVIA",

    "AV",         "AVENIDA",
    "AV.",        "AVENIDA",
    "AVE",        "AVENIDA",
    "AVE.",       "AVENIDA",
    "AVN",        "AVENIDA",
    "AVN.",       "AVENIDA",
    "AVD",        "AVENIDA",
    "AVD.",       "AVENIDA",
    "AVDA",       "AVENIDA",
    "AVDA.",      "AVENIDA",
    "AVI",        "AVENIDA",
    "AVI.",       "AVENIDA",

    "EST",        "ESTRADA",
    "EST.",       "ESTRADA",
    "ESTR",       "ESTRADA",
    "ESTR.",      "ESTRADA",

    "PC",         "PRACA",
    "PC.",        "PRACA",
    "PCA",        "PRACA",
    "PCA.",       "PRACA",
    "PRA",        "PRACA",
    "PRA.",       "PRACA",
    "PRC",        "PRACA",
    "PRC.",       "PRACA",

    "BC",         "BECO",
    "BC.",        "BECO",
    "BEC",        "BECO",
    "BEC.",       "BECO",
    "BCO",        "BECO",
    "BCO.",       "BECO",

    "TV",         "TRAVESSA",
    "TV.",        "TRAVESSA",
    "TRV",        "TRAVESSA",
    "TRV.",       "TRAVESSA",
    "TRAV",       "TRAVESSA",
    "TRAV.",      "TRAVESSA",
    "TRA",        "TRAVESSA",
    "TRA.",       "TRAVESSA",

    "PQ",         "PARQUE",
    "PQ.",        "PARQUE",
    "PRQ",        "PARQUE",
    "PRQ.",       "PARQUE",
    "PARQ",       "PARQUE",
    "PARQ.",      "PARQUE",
    "PQE",        "PARQUE",
    "PQE.",       "PARQUE",
    "PQUE",       "PARQUE",
    "PQUE.",      "PARQUE",

    "AL",         "ALAMEDA",
    "AL.",        "ALAMEDA",
    "ALA",        "ALAMEDA",
    "ALA.",       "ALAMEDA",
    "ALM",        "ALAMEDA",
    "ALM.",       "ALAMEDA",
    "RODOVIA AL", "RODOVIA AL",

    "LOT",        "LOTEAMENTO",
    "LOT.",       "LOTEAMENTO",

    "VL",         "VILA",
    "VL.",        "VILA",
    "VIL",        "VILA",
    "VIL.",       "VILA",

    "LAD",        "LADEIRA",
    "LAD.",       "LADEIRA",

    "DIS",        "DISTRITO",
    "DIS.",       "DISTRITO",
    "DIST",       "DISTRITO",
    "DIST.",      "DISTRITO",
    "DISTR",      "DISTRITO",
    "DISTR.",     "DISTRITO",

    "LAR",        "LARGO",
    "LAR.",       "LARGO",
    "LRG",        "LARGO",
    "LRG.",       "LARGO",
    "LGO",        "LARGO",
    "LGO.",       "LARGO",

    "AER",        "AEROPORTO",
    "AER.",       "AEROPORTO",
    "AEROP",      "AEROPORTO",
    "AEROP.",     "AEROPORTO",

    "FAZ",        "FAZENDA",
    "FAZ.",       "FAZENDA",
    "FAZE",       "FAZENDA",
    "FAZE.",      "FAZENDA",
    "FAZEN",      "FAZENDA",
    "FAZEN.",     "FAZENDA",

    "COND",       "CONDOMINIO",
    "COND.",      "CONDOMINIO",

    "SIT",        "SITIO",
    "SIT.",       "SITIO",

    "RES",        "RESIDENCIAL",
    "RES.",       "RESIDENCIAL",
    "RESID",      "RESIDENCIAL",
    "RESID.",     "RESIDENCIAL",

    "QU",         "QUADRA",
    "QU.",        "QUADRA",
    "QUA",        "QUADRA",
    "QUA.",       "QUADRA",
    "QUAD",       "QUADRA",
    "QUAD.",      "QUADRA",
    "QD",         "QUADRA",
    "QD.",        "QUADRA",
    "QDR",        "QUADRA",
    "QDR.",       "QUADRA",
    "QDRA",       "QUADRA",
    "QDRA.",      "QUADRA",

    "CHAC",       "CHACARA",
    "CHAC.",      "CHACARA",

    "CPO",        "CAMPO",
    "CPO.",       "CAMPO",

    "COL",        "COLONIA",
    "COL.",       "COLONIA",

    "CONJ",       "CONJUNTO",
    "CONJ.",      "CONJUNTO",
    "CJ",         "CONJUNTO",
    "CJ.",        "CONJUNTO",

    "JD",         "JARDIM",
    "JD.",        "JARDIM",
    "JDM",        "JARDIM",
    "JDM.",       "JARDIM",
    "JDIM",       "JARDIM",
    "JDIM.",      "JARDIM",
    "JRD",        "JARDIM",
    "JRD.",       "JARDIM",
    "JARD",       "JARDIM",
    "JARD.",      "JARDIM",

    "FAV",        "FAVELA",
    "FAV.",       "FAVELA",

    "NUC",        "NUCLEO",
    "NUC.",       "NUCLEO",

    "VIE",        "VIELA",
    "VIE.",       "VIELA",

    "SET",        "SETOR",
    "SET.",       "SETOR",

    "ILH",        "ILHA",
    "ILH.",       "ILHA",
    "VER",        "VEREDA",
    "VER.",       "VEREDA",
    "ACA",        "ACAMPAMENTO",
    "ACA.",       "ACAMPAMENTO",
    "ACE",        "ACESSO",
    "ACE.",       "ACESSO",
    "ADR",        "ADRO",
    "ADR.",       "ADRO",
    "ALT",        "ALTO",
    "ALT.",       "ALTO",
    "ARE",        "AREA",
    "ARE.",       "AREA",
    "ART",        "ARTERIA",
    "ART.",       "ARTERIA",
    "ATA",        "ATALHO",
    "ATA.",       "ATALHO",
    "BAI",        "BAIXA",
    "BAI.",       "BAIXA",
    "BLO",        "BLOCO",
    "BLO.",       "BLOCO",
    "BOS",        "BOSQUE",
    "BOS.",       "BOSQUE",
    "BOU",        "BOULEVARD",
    "BOU.",       "BOULEVARD",
    "BUR",        "BURACO",
    "BUR.",       "BURACO",
    "CAI",        "CAIS",
    "CAI.",       "CAIS",
    "CAL",        "CALCADA",
    "CAL.",       "CALCADA",
    "ELE",        "ELEVADA",
    "ELE.",       "ELEVADA",
    "ESP",        "ESPLANADA",
    "ESP.",       "ESPLANADA",
    "FEI",        "FEIRA",
    "FEI.",       "FEIRA",
    "FER",        "FERROVIA",
    "FER.",       "FERROVIA",
    "FON",        "FONTE",
    "FON.",       "FONTE",
    "FOR",        "FORTE",
    "FOR.",       "FORTE",
    "GAL",        "GALERIA",
    "GAL.",       "GALERIA",
    "GRA",        "GRANJA",
    "GRA.",       "GRANJA",
    "MOD",        "MODULO",
    "MOD.",       "MODULO",
    "MON",        "MONTE",
    "MON.",       "MONTE",
    "MOR",        "MORRO",
    "MOR.",       "MORRO",
    "PAT",        "PATIO",
    "PAT.",       "PATIO",
    "POR",        "PORTO",
    "POR.",       "PORTO",
    "REC",        "RECANTO",
    "REC.",       "RECANTO",
    "RET",        "RETA",
    "RET.",       "RETA",
    "ROT",        "ROTULA",
    "ROT.",       "ROTULA",
    "SER",        "SERVIDAO",
    "SER.",       "SERVIDAO",
    "SUB",        "SUBIDA",
    "SUB.",       "SUBIDA",
    "TER",        "TERMINAL",
    "TER.",       "TERMINAL",
    "TRI",        "TRINCHEIRA",
    "TRI.",       "TRINCHEIRA",
    "TUN",        "TUNEL",
    "TUN.",       "TUNEL",
    "UNI",        "UNIDADE",
    "UNI.",       "UNIDADE",
    "VAL",        "VALA",
    "VAL.",       "VALA",
    "VAR",        "VARIANTE",
    "VAR.",       "VARIANTE",
    "ZIG",        "ZIGUE-ZAGUE",
    "ZIG.",       "ZIGUE-ZAGUE",

    "OUTROS", NA_character_
  )

  expect_equal(tester(gabarito$original), gabarito$padronizado_esperado)
})

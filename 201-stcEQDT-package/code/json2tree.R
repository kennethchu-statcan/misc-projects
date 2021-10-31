#' json2tree
#'
#' This function accepts a EQDT JSON file of an electronic questionnaire, and
#' visualizes the logic structure of the electronic questionnaire in a tree
#' structure, and prints that tree structure to file.
#'
#' @docType class
#'
#' @import dplyr
#' @import R6
#' @import rjson
#'
#' @return NULL
#'
#' @examples
#' # See the vignette 'stcEQDT-usage' for more details, by executing the command: vignette("stcEQDT-usage")
#' library(stcEQDT)
#'
#' json2tree(
#'     eqdt.json = system.file("extdata", "OID-exit.json", package = "stcEQDT"),
#'     file.output = 'EQtree-OID-exit.txt'
#'     )
#'
#' json2tree(
#'     eqdt.json = system.file("extdata", "Industry-Classification-Survey.json", package = "stcEQDT"),
#'     file.output = 'EQtree-Industry-Classification-Survey.txt'
#'     )
#'
#' json2tree(
#'     eqdt.json = system.file("extdata", "CSBC4-2021.json", package = "stcEQDT"),
#'     file.output = 'EQtree-CSBC4-2021.txt'
#'     )
#'
#' json2tree(
#'     eqdt.json = system.file("extdata", "flow-extraction.json", package = "stcEQDT"),
#'     file.output = 'EQtree-flow-extraction.txt'
#'     )
#'
#' @param eqdt.json character vector of length 1, containing path to EQDT JSON file
#' @param file.output character vector of length 1, containing path to output file
#'
#' @export

json2tree <- function(
    eqdt.json   = NULL,
    file.output = 'EQtree.txt'
    ) {

    # thisFunctionName <- "EQtree";
    # cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    # cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.json        <- getData(input.file = eqdt.json);
    list.data.frames <- tabularizeData(list.input = list.json);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.QGuid.to.QNumber <- getQGuidToQNumber(
        DF.nested = list.data.frames[['DF.nested']]
        );
    utils::write.csv(file = "DF-QGuid-to-QNumber.csv",   x      = DF.QGuid.to.QNumber, row.names = FALSE);
    base::saveRDS(  file = "DF-QGuid-to-QNumber.RData", object = DF.QGuid.to.QNumber);

    DF.PGuid.to.PNumber <- getPGuidToPNumber(
        DF.nested = list.data.frames[['DF.nested']]
        );
    utils::write.csv(file = "DF-PGuid-to-PNumber.csv",   x      = DF.PGuid.to.PNumber, row.names = FALSE);
    base::saveRDS(  file = "DF-PGuid-to-PNumber.RData", object = DF.PGuid.to.PNumber);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.referenceID.to.elementID <- getReferenceIDToElementID(
        DF.nested           = list.data.frames[['DF.nested']],
        DF.QGuid.to.QNumber = DF.QGuid.to.QNumber,
        DF.PGuid.to.PNumber = DF.PGuid.to.PNumber
        );
    DF.referenceID.to.elementID <- list.referenceID.to.elementID[['referenceID.to.elementID']];
    DF.referentID.to.elementID  <- list.referenceID.to.elementID[[ 'referentID.to.elementID']];

    utils::write.csv(file = "DF-referenceID-to-elementID.csv",   x      = DF.referenceID.to.elementID, row.names = FALSE);
    base::saveRDS(  file = "DF-referenceID-to-elementID.RData", object = DF.referenceID.to.elementID);

    utils::write.csv(file = "DF-referentID-to-elementID.csv",   x      = DF.referentID.to.elementID, row.names = FALSE);
    base::saveRDS(  file = "DF-referentID-to-elementID.RData", object = DF.referentID.to.elementID);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # DF.element.to.localization <- getElementToLocalization(
    #     DF.nested                   = list.data.frames[['DF.nested']],
    #     DF.referenceID.to.elementID = DF.referenceID.to.elementID,
    #     DF.localization             = list.data.frames[['DF.localization']],
    #     element.types               = c('datapointValue','displayTarget','gotoTarget','setTarget')
    #     );
    # utils::write.csv(file = "DF-element-to-location.csv",   x      = DF.element.to.localization, row.names = FALSE);
    # base::saveRDS(  file = "DF-element-to-location.RData", object = DF.element.to.localization);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.getListOfNodes <- getListOfNodes(
        list.input                  = list.json,
        DF.localization             = list.data.frames[['DF.localization']],
      # DF.element.to.localization  = DF.element.to.localization,
        DF.referenceID.to.elementID = DF.referenceID.to.elementID,
        DF.referentID.to.elementID  = DF.referentID.to.elementID
        );

    DF.nodes   <- results.getListOfNodes[[  'DF.nodes']];
    list.nodes <- results.getListOfNodes[['list.nodes']];

    utils::write.csv(file = "DF-nodes.csv",     x      =   DF.nodes);
    base::saveRDS(  file = "DF-nodes.RData",   object =   DF.nodes);
    base::saveRDS(  file = "list-nodes.RData", object = list.nodes);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    printListOfNodes(
        list.nodes = list.nodes,
        txt.output = file.output
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # cat(paste0("\n",thisFunctionName,"() quits."));
    # cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

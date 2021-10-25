
EQtree <- function(
    file.json   = NULL,
    file.output = 'EQtree.txt'
    ) {

    thisFunctionName <- "EQtree";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.json        <- getData(input.file = file.json);
    list.data.frames <- tabularizeData(list.input = list.json);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.QGuid.to.QNumber <- getQGuidToQNumber(
        DF.nested = list.data.frames[['DF.nested']]
        );
    write.csv(file = "DF-QGuid-to-QNumber.csv",   x      = DF.QGuid.to.QNumber);
    saveRDS(  file = "DF-QGuid-to-QNumber.RData", object = DF.QGuid.to.QNumber);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.referenceID.to.elementID <- getReferenceIDToElementID(
        DF.nested           = list.data.frames[['DF.nested']],
        DF.QGuid.to.QNumber = DF.QGuid.to.QNumber
        );
    DF.referenceID.to.elementID <- list.referenceID.to.elementID[['referenceID.to.elementID']];
    DF.referentID.to.elementID  <- list.referenceID.to.elementID[[ 'referentID.to.elementID']];

    write.csv(file = "DF-referenceID-to-elementID.csv",   x      = DF.referenceID.to.elementID);
    saveRDS(  file = "DF-referenceID-to-elementID.RData", object = DF.referenceID.to.elementID);

    write.csv(file = "DF-referentID-to-elementID.csv",   x      = DF.referentID.to.elementID);
    saveRDS(  file = "DF-referentID-to-elementID.RData", object = DF.referentID.to.elementID);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.element.to.localization <- getElementToLocalization(
        DF.nested                   = list.data.frames[['DF.nested']],
        DF.referenceID.to.elementID = DF.referenceID.to.elementID,
        DF.localization             = list.data.frames[['DF.localization']],
        element.types               = c('datapointValue','displayTarget','gotoTarget','setTarget')
        );
    write.csv(file = "DF-element-to-location.csv",   x      = DF.element.to.localization);
    saveRDS(  file = "DF-element-to-location.RData", object = DF.element.to.localization);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    results.getListOfNodes <- getListOfNodes(
        list.input                  = list.json,
        DF.localization             = list.data.frames[['DF.localization']],
        DF.element.to.localization  = DF.element.to.localization,
        DF.referenceID.to.elementID = DF.referenceID.to.elementID,
        DF.referentID.to.elementID  = DF.referentID.to.elementID
        );

    DF.nodes   <- results.getListOfNodes[[  'DF.nodes']];
    list.nodes <- results.getListOfNodes[['list.nodes']];

    write.csv(file = "DF-nodes.csv",     x      =   DF.nodes);
    saveRDS(  file = "DF-nodes.RData",   object =   DF.nodes);
    saveRDS(  file = "list-nodes.RData", object = list.nodes);

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    printListOfNodes(
        list.nodes = list.nodes,
        txt.output = file.output
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( NULL );

    }

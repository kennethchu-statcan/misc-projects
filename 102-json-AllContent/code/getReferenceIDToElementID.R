
getReferenceIDToElementID <- function(
    DF.nested           = NULL,
    DF.QGuid.to.QNumber = NULL
    ) {

    thisFunctionName <- "getReferenceIDToElementID";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.referenceID.to.referentID <- DF.nested[DF.nested[,'key2'] == 'References',];
    DF.referenceID.to.referentID <- DF.referenceID.to.referentID[DF.referenceID.to.referentID[,'key4'] %in% c('referentId'),c('key3','value')];
    colnames(DF.referenceID.to.referentID) <- gsub(x = colnames(DF.referenceID.to.referentID), pattern = "^key3$",  replacement = "referenceID");
    colnames(DF.referenceID.to.referentID) <- gsub(x = colnames(DF.referenceID.to.referentID), pattern = "^value$", replacement = "referentID" );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.referentID.to.elementID <- DF.nested[DF.nested[,'key2'] == 'Referents',];
    DF.referentID.to.elementID <- DF.referentID.to.elementID[DF.referentID.to.elementID[,'key4'] %in% c('id'),c('key3','value')];
    colnames(DF.referentID.to.elementID) <- gsub(x = colnames(DF.referentID.to.elementID), pattern = "^key3$",  replacement = "referentID");
    colnames(DF.referentID.to.elementID) <- gsub(x = colnames(DF.referentID.to.elementID), pattern = "^value$", replacement = "elementtID" );

    temp.colnames <- colnames(DF.referentID.to.elementID);
    DF.referentID.to.elementID <- merge(
        x     = DF.referentID.to.elementID,
        y     = DF.QGuid.to.QNumber,
        all.x = TRUE,
        by.x  = "elementtID",
        by.y  = "guid"
        );
    DF.referentID.to.elementID <- DF.referentID.to.elementID[,c(temp.colnames,'questionNumber')];

    cat("\nDF.referentID.to.elementID\n");
    print( DF.referentID.to.elementID   );

    is.na.questionNumber <- is.na(DF.referentID.to.elementID[,'questionNumber']);
    DF.referentID.to.elementID[!is.na.questionNumber,'elementtID'] <- paste0("questionNumber ",DF.referentID.to.elementID[!is.na.questionNumber,'questionNumber']);

    cat("\nDF.referentID.to.elementID\n");
    print( DF.referentID.to.elementID   );

    DF.referentID.to.elementID <- DF.referentID.to.elementID[,setdiff(colnames(DF.referentID.to.elementID),c("questionNumber"))];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.referenceID.to.elementID <- merge(
        x     = DF.referenceID.to.referentID,
        y     = DF.referentID.to.elementID,
        all.x = TRUE,
        by    = "referentID"
        );

    cat("\n# str(DF.referenceID.to.elementID)\n");
    print(   str(DF.referenceID.to.elementID)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.output <- list(
        referenceID.to.elementID = DF.referenceID.to.elementID,
        referentID.to.elementID  = DF.referentID.to.elementID
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list.output );

    }

##################################################

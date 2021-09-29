
getReferenceIDToElementID <- function(
    DF.nested = NULL
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

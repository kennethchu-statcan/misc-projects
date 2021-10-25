
getReferenceIDToElementID <- function(
    DF.nested           = NULL,
    DF.QGuid.to.QNumber = NULL,
    DF.PGuid.to.PNumber = NULL
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
    colnames(DF.referentID.to.elementID) <- gsub(x = colnames(DF.referentID.to.elementID), pattern = "^value$", replacement = "elementID" );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.referentID.to.elementID[,'elementID'] <- apply(
        X      = DF.referentID.to.elementID[,c('referentID','elementID')],
        MARGIN = 1,
        FUN    = function(x) {
            if ( x[2] %in% DF.QGuid.to.QNumber[,'guid'] ) {
                temp.string <- DF.QGuid.to.QNumber[DF.QGuid.to.QNumber[,'guid'] == x[2],'questionNumber'];
                temp.string <- paste0("questionNumber ",temp.string);
                return( temp.string );
            } else {
                return( x[2] );
                }
            }
        );

    DF.referentID.to.elementID[,'elementID'] <- apply(
        X      = DF.referentID.to.elementID[,c('referentID','elementID')],
        MARGIN = 1,
        FUN    = function(x) {
            if ( x[2] %in% DF.PGuid.to.PNumber[,'guid'] ) {
                temp.string <- DF.PGuid.to.PNumber[DF.PGuid.to.PNumber[,'guid'] == x[2],'pageNumber'];
                temp.string <- paste0("pageNumber ",temp.string);
                return( temp.string );
            } else {
                return( x[2] );
                }
            }
        );

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

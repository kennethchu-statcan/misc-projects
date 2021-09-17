
getItemToElementID <- function(
    DF.nested                    = NULL,
    DF.referenceID.to.referentID = NULL,
    DF.referentID.to.elementID   = NULL
    ) {

    thisFunctionName <- "getItemToElementID";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key1'] != 'Reference',];
    DF.output <- DF.output[DF.output[,'key4'] %in% c('datapointValue','displayTarget','gotoTarget'),c('key4','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement = "referenceID")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x  = DF.output,
        y  = DF.referenceID.to.referentID,
        by = "referenceID"
        );
    DF.output <- DF.output[,setdiff(colnames(DF.output),"key4")];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.output,
        y     = DF.referentID.to.elementID,
        all.x = TRUE,
        by.x  = 'referentID',
        by.y  = 'referentID'
        );
    DF.output <- DF.output[,c('referenceID','referentID','elementID')];

    cat("\n# str(DF.output)\n");
    print(   str(DF.output)   );

    cat("\n# DF.output\n");
    print(   DF.output   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################

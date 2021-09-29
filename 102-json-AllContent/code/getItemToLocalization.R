
getItemToLocalization <- function(
    DF.nested                    = NULL,
    DF.referenceID.to.referentID = NULL,
    DF.localization              = NULL
    ) {

    thisFunctionName <- "getItemToLocalization";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- DF.nested[DF.nested[,'key1'] != 'Reference',];
    DF.output <- DF.output[DF.output[,'key4'] %in% c('datapointValue','displayTarget','gotoTarget'),c('key4','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement = "referenceID");

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
        y     = DF.nested[DF.nested[,'key4'] == 'id',c('value','key2')],
        all.x = TRUE,
        by.x  = 'referentID',
        by.y  = 'value'
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.output,
        y     = DF.nested[DF.nested[,'key4'] == 'text',c('key2','value')],
        all.x = TRUE,
        by    = 'key2'
        );
    DF.output <- DF.output[,c('referenceID','referentID','key2','value')];
    colnames(DF.output) <- gsub(x = colnames(DF.output), pattern = "^value$", replacement = "localizationID")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.output <- merge(
        x     = DF.output,
        y     = DF.localization,
        all.x = TRUE,
        by.x  = 'localizationID',
        by.y  = 'localizationID'
        );
    DF.output <- DF.output[,c('referenceID','referentID','key2','localizationID','english','french')];

    cat("\n# DF.output\n");
    print(   DF.output   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( DF.output );

    }

##################################################

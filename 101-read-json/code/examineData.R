
examineData <- function(
    list.input       = NULL,
    csv.nested       = "table-nested.csv",
    csv.non.nested   = "table-non-nested.csv",
    csv.reference    = "table-reference.csv",
    csv.localization = "table-localization.csv"
    ) {

    thisFunctionName <- "examineData";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nnames(list.input)\n");
    print( names(list.input)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.diagnostics <- examineData_list.names(list.input = list.input);

    write.csv(
        x         = DF.diagnostics,
        file      = "table-diagnostics.csv",
        row.names = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # temp.names <- c('Reference','Localization');
    # for ( temp.name in temp.names ) {
    #     examineData_str(list.input = list.input, temp.name = temp.name);
    #     }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nested <- examineData_nested(
        list.input = list.input
        );

    cat("\nstr(DF.nested)\n");
    print( str(DF.nested)   );

    cat("\nunique(DF.nested[,'key1'])\n");
    print( unique(DF.nested[,'key1'])   );

    cat("\ntable(DF.nested[DF.nested[,'key1'] != 'Reference',c('key1','key3')])\n");
    print( table(DF.nested[DF.nested[,'key1'] != 'Reference',c('key1','key3')])   );

    write.csv(
        x         = DF.nested,
        file      = csv.nested,
        row.names = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.non.nested <- examineData_non.nested(
        list.input = list.input
        );

    cat("\nstr(DF.non.nested)\n");
    print( str(DF.non.nested)   );

    write.csv(
        x         = DF.non.nested,
        file      = csv.non.nested,
        row.names = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.localization <- examineData_localization(
        list.input = list.input
        );

    cat("\nstr(DF.localization)\n");
    print( str(DF.localization)   );

    write.csv(
        x         = DF.localization,
        file      = csv.localization,
        row.names = FALSE
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    list.output <- list(
        DF.diagnostics  = DF.diagnostics,
        DF.nested       = DF.nested,
        DF.non.nested   = DF.non.nested,
        DF.localization = DF.localization
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list.output );

    }

##################################################
examineData_localization <- function(
    list.input = NULL
    ) {

    DF.english <- list.input[['Localization']][['English']];
    DF.english <- data.frame(
        ID      = names(DF.english),
        english = as.character(DF.english)
        );
    DF.english[,'index'] <- seq(1,nrow(DF.english));

    DF.french   <- list.input[['Localization']][['French']];
    temp.french <- as.character(DF.french);
    Encoding(temp.french) <- "UTF-8";
    DF.french <- data.frame(
        ID     = names(DF.french),
        french = temp.french
        );

    DF.output <- merge(
        x   = DF.english,
        y   = DF.french,
        by  = "ID",
        all = TRUE
        );

    colnames(DF.output) <- gsub(
        x           = colnames(DF.output),
        pattern     = "^ID$",
        replacement = "localizationID"
        );

    DF.output <- DF.output[order(DF.output[,'index']),];
    DF.output <- DF.output[,setdiff(colnames(DF.output),'index')];
    return( DF.output );

    }

examineData_nested <- function(
    list.input = NULL
    ) {
    DF.output   <- data.frame();
    temp.groups <- names(list.input);
    temp.groups <- setdiff(temp.groups,c('Localization'));
    for ( temp.group in temp.groups ) {

        list.entities <- list.input[[temp.group]];
        for ( entityID in names(list.entities) ) {
            list.attributes <- list.entities[[entityID]];
            temp.attributes <- names(list.attributes);
            for ( temp.attribute in temp.attributes ) {
                if ( temp.attribute %in% c('properties','parent') ) {
                    if ( length(list.attributes[[temp.attribute]]) > 0 ) {
                        temp.keys <- setdiff(names(list.attributes[[temp.attribute]]),"type");
                        for ( temp.key in temp.keys ) {
                            DF.temp <- data.frame(
                                key1  = temp.group,
                                key2  = entityID,
                                key3  = temp.attribute,
                                index = 1,
                                key4  = temp.key,
                                value = list.attributes[[temp.attribute]][[temp.key]]
                                );
                            DF.output <- rbind(DF.output,DF.temp);
                            }
                        }
                } else {

                    if ( 'Reference' == temp.group ) {
                        temp.keys <- setdiff(names(list.attributes[[temp.attribute]]),"type");
                        for ( temp.key in temp.keys ) {
                            DF.temp <- data.frame(
                                key1  = temp.group,
                                key2  = entityID,
                                key3  = temp.attribute,
                                index = temp.index,
                                key4  = temp.key,
                                value = list.attributes[[temp.attribute]][[temp.key]]
                                );
                            DF.output <- rbind(DF.output,DF.temp);
                            }
                    } else {
                        temp.length <- length(list.attributes[[temp.attribute]]);
                        if ( temp.length > 0 ) {
                            for ( temp.index in seq(1,temp.length) ) {
                                temp.keys <- setdiff(names(list.attributes[[temp.attribute]][[temp.index]]),"type");
                                for ( temp.key in temp.keys ) {
                                    DF.temp <- data.frame(
                                        key1  = temp.group,
                                        key2  = entityID,
                                        key3  = temp.attribute,
                                        index = temp.index,
                                        key4  = temp.key,
                                        value = list.attributes[[temp.attribute]][[temp.index]][[temp.key]]
                                        );
                                    DF.output <- rbind(DF.output,DF.temp);
                                    }
                                }
                            }
                        }

                    }
                }
            }

        }
    return( DF.output );
    }

examineData_non.nested <- function(
    list.input = NULL
    ) {
    DF.output   <- data.frame();
    temp.groups <- names(list.input);
    # temp.groups <- setdiff(temp.groups,c('Reference','Localization'))
    temp.groups <- setdiff(temp.groups,c('Localization'))
    for ( temp.group in temp.groups ) {
        if ( is.list(list.input[[temp.group]]) ) {
            if ( 0 == length(list.input[[temp.group]]) ) {
                DF.temp <- data.frame(
                    key1  = temp.group,
                    value = NA
                    );
                DF.output <- rbind(DF.output,DF.temp);
                }
        } else {
            DF.temp <- data.frame(
                key1  = temp.group,
                value = list.input[[temp.group]]
                );
            DF.output <- rbind(DF.output,DF.temp);
            }
        }
    return( DF.output );
    }

examineData_str <- function(
    list.input = NULL,
    temp.name  = NULL
    ) {
    cat(paste0("\nstr(list.input[[",temp.name,"]])\n"));
    print(        str(list.input[[  temp.name  ]])    );
    }

examineData_list.names <- function(
    list.input = NULL
    ) {
    DF.output <- data.frame();
    for ( temp.name in names(list.input) ) {
        temp.components <- lapply( X = list.input[[temp.name]], FUN = function(x) return(paste(names(x),collapse=",")) );
        temp.components <- paste(unique(as.character(temp.components)),collapse=" # ");
        # temp.components <- ifelse(temp.name %in% c('Localization'), "", temp.components);
        DF.temp <- data.frame(
            key1             = temp.name,
            typeof           = typeof(list.input[[temp.name]]),
            length           = length(list.input[[temp.name]]),
            components       = temp.components,
            stringsAsFactors = FALSE
            );
        DF.output <- rbind(DF.output,DF.temp);
        }
    return( DF.output );
    }

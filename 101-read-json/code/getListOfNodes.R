
getListOfNodes <- function(
    list.input                 = NULL,
    DF.localization            = NULL,
    DF.item.to.localization    = NULL,
    DF.guid.to.elementID       = NULL,
    DF.referentID.to.elementID = NULL,
    DF.item.to.elementID       = NULL
    ) {

    thisFunctionName <- "getListOfNodes";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.localization)\n");
    print( str(DF.localization)   );

    cat("\nstr(DF.item.to.localization)\n");
    print( str(DF.item.to.localization)   );

    cat("\nstr(DF.referenceID.to.referentID)\n");
    print( str(DF.referenceID.to.referentID)   );

    cat("\nstr(DF.referentID.to.elementID)\n");
    print( str(DF.referentID.to.elementID)   );

    cat("\nstr(DF.item.to.elementID)\n");
    print( str(DF.item.to.elementID)   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nested <- examineData_nested(
        list.input = list.input
        );

    DF.nested <- DF.nested[DF.nested[,'key1'] != 'Reference',];

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    DF.nested[DF.nested[,'key3'] == 'if',  'key3'] <- 'condition.if';
    DF.nested[DF.nested[,'key3'] == 'then','key3'] <- 'condition.then';

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat("\nstr(DF.nested)\n");
    print( str(DF.nested)   );

    cat("\nunique(DF.nested[,'key1'])\n");
    print( unique(DF.nested[,'key1'])   );

    cat("\ntable(DF.nested[,c('key1','key3')])\n");
    print( table(DF.nested[,c('key1','key3')])   );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    current.depth <- 0;
    current.guid  <- 'Root';

    DF.nested[,'depth'] <- NA;
    DF.nested[DF.nested[,'key2'] == current.guid,'depth'] <- current.depth;

    list.nodes <- list();
    list.attributes <- getListOfNodes_get.attributes(
        DF.input                   = DF.nested[DF.nested[,'key2'] == current.guid,],
        DF.localization            = DF.localization,
        DF.item.to.localization    = DF.item.to.localization,
        DF.guid.to.elementID       = DF.guid.to.elementID,
        DF.referentID.to.elementID = DF.referentID.to.elementID,
        DF.item.to.elementID       = DF.item.to.elementID
        );
    list.nodes[[ current.guid ]] <- node$new(
        guid           = current.guid,
        depth          = current.depth,
        type           = list.attributes[['type'          ]],
        properties     = list.attributes[['properties'    ]],
        parent         = list.attributes[['parent'        ]],
        children       = list.attributes[['children'      ]],
        rows           = list.attributes[['rows'          ]],
        columns        = list.attributes[['columns'       ]],
        displayLogic   = list.attributes[['displayLogic'  ]],
        enterLogic     = list.attributes[['enterLogic'    ]],
        condition.if   = list.attributes[['condition.if'  ]],
        condition.then = list.attributes[['condition.then']]
        );

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    current.guids <- setdiff(unique(DF.nested[,'key2']),current.guid);
    while ( length(current.guids) > 0 & sum(DF.nested[!is.na(DF.nested[,'depth']) & DF.nested[,'depth'] == current.depth,'key3'] == 'children') > 0 ) {

        DF.temp        <- DF.nested[!is.na(DF.nested[,'depth']) & DF.nested[,'depth'] == current.depth,];
        # children.IDs <- unique(DF.temp[DF.temp[,'key3'] == 'children','value']);
        children.IDs   <- unique(DF.temp[DF.temp[,'key3'] %in% c('children','rows','columns','displayLogic','enterLogic','condition.if','condition.then'),'value']);
        current.guids  <- setdiff(current.guids,children.IDs);

        current.depth <- current.depth + 1;
        DF.nested[DF.nested[,'key2'] %in% children.IDs,'depth'] <- current.depth;

        for ( guid in children.IDs ) {
            list.attributes <- getListOfNodes_get.attributes(
                DF.input                   = DF.nested[DF.nested[,'key2'] == guid,],
                DF.localization            = DF.localization,
                DF.item.to.localization    = DF.item.to.localization,
                DF.guid.to.elementID       = DF.guid.to.elementID,
                DF.referentID.to.elementID = DF.referentID.to.elementID,
                DF.item.to.elementID       = DF.item.to.elementID
                );
            list.nodes[[ guid ]] <- node$new(
                guid           = guid,
                depth          = current.depth,
                type           = list.attributes[['type'          ]],
                properties     = list.attributes[['properties'    ]],
                parent         = list.attributes[['parent'        ]],
                children       = list.attributes[['children'      ]],
                rows           = list.attributes[['rows'          ]],
                columns        = list.attributes[['columns'       ]],
                displayLogic   = list.attributes[['displayLogic'  ]],
                enterLogic     = list.attributes[['enterLogic'    ]],
                condition.if   = list.attributes[['condition.if'  ]],
                condition.then = list.attributes[['condition.then']]
                );
            }

        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list(DF.nodes = DF.nested , list.nodes = list.nodes) );

    }

##################################################
getListOfNodes_get.attributes <- function(
    DF.input                   = NULL,
    DF.localization            = NULL,
    DF.item.to.localization    = NULL,
    DF.guid.to.elementID       = NULL,
    DF.referentID.to.elementID = NULL,
    DF.item.to.elementID       = NULL
    ) {

    list.attributes <- list();
    list.attributes[[ 'type' ]] <- DF.input[1,'key1'];

    attribute.types <- c(
        'parent',
        'properties',
        'children',
        'rows',
        'columns',
        'displayLogic',
        'enterLogic',
        'condition.if',
        'condition.then'
        )

    for ( attribute.type in attribute.types ) {

        list.attributes[[ attribute.type ]] <- NULL;

        DF.attributes <- DF.input[DF.input[,'key3'] == attribute.type,];

        temp.indexes <- unique(DF.attributes[,'index']);
        list.indexes <- list();
        for ( temp.index in temp.indexes ) {

            DF.temp <- DF.attributes[DF.attributes[,'index'] == temp.index,];

            temp.key4s <- unique(DF.temp[,'key4']);
            list.key4s <- list();
            for ( temp.key4 in temp.key4s ) {

                temp.value  <- DF.temp[DF.temp[,'key4'] == temp.key4,'value'];
                temp.string <- temp.value;

                if ( temp.value %in% DF.item.to.elementID[,"referenceID"] ) {
                    DF.one.row  <- DF.item.to.elementID[DF.item.to.elementID[,"referenceID"] == temp.value,];
                    DF.one.row  <- DF.one.row[,setdiff(colnames(DF.one.row),"referenceID")];
                    temp.string <- paste0(temp.string," (",paste(DF.one.row,collapse=", "),")");
                    }
                if ( temp.value %in% DF.referentID.to.elementID[,"referentID"] ) {
                    DF.one.row  <- DF.referentID.to.elementID[DF.referentID.to.elementID[,"referentID"] == temp.value,];
                    DF.one.row  <- DF.one.row[,setdiff(colnames(DF.one.row),"referentID")];
                    temp.string <- paste0(temp.string," (",paste(DF.one.row,collapse=", "),")");
                    }
                if ( temp.value %in% DF.localization[,"localizationID"] ) {
                    DF.one.row  <- DF.localization[DF.localization[,"localizationID"] == temp.value,];
                    # temp.string <- paste0(temp.string," (",DF.one.row[,"english"],", ",DF.one.row[,"french" ],")");
                    temp.string <- paste0("(",DF.one.row[,"english"],", ",DF.one.row[,"french" ],")");
                    }

                list.key4s[[ temp.key4 ]] <- temp.string;

                }
            list.indexes[[ temp.index ]] <- list.key4s;

            }
        list.attributes[[ attribute.type ]] <- list.indexes;

        }

    return( list.attributes );

    }

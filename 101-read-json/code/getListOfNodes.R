
getListOfNodes <- function(
    list.input = NULL
    ) {

    thisFunctionName <- "getListOfNodes";
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###");
    cat(paste0("\n",thisFunctionName,"() starts.\n\n"));

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
    nodeIDs <- unique(DF.nested[,'key2']);

    list.nodes <- list();
    for ( nodeID in nodeIDs ) {

        DF.temp <- DF.nested[DF.nested[,'key2'] == nodeID,];

        list.attributes <- getListOfNodes_get.attributes(
            DF.input = DF.temp
            );

        list.nodes[[ nodeID ]] <- node$new(
            type           = list.attributes[['type'          ]],
            parent         = list.attributes[['parent'        ]],
            children       = list.attributes[['children'      ]],
            columns        = list.attributes[['columns'       ]],
            displayLogic   = list.attributes[['displayLogic'  ]],
            enterLogic     = list.attributes[['enterLogic'    ]],
            properties     = list.attributes[['properties'    ]],
            rows           = list.attributes[['rows'          ]],
            condition.if   = list.attributes[['condition.if'  ]],
            condition.then = list.attributes[['condition.then']]
            );

        }


    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    cat(paste0("\n",thisFunctionName,"() quits."));
    cat("\n### ~~~~~~~~~~~~~~~~~~~~ ###\n");
    return( list.nodes );

    }

##################################################
getListOfNodes_get.attributes <- function(
    DF.input = NULL
    ) {

    list.attributes <- list();
    list.attributes[[ 'type' ]] <- DF.input[1,'key1'];

    attribute.types <- c(
        'parent',
        'children',
        'columns',
        'displayLogic',
        'enterLogic',
        'properties',
        'rows',
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
                list.key4s[[ temp.key4 ]] <- DF.temp[DF.temp[,'key4'] == temp.key4,'value'];
                }
            list.indexes[[ temp.index ]] <- list.key4s;

            }
        list.attributes[[ attribute.type ]] <- list.indexes;

        }

    return( list.attributes );

    }

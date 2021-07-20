
require(R6);

node <- R6::R6Class(

    classname = "node",

    public = list(

        # instantiation attributes
        nodeID         = NULL,
        depth          = NULL,
        type           = NULL,
        properties     = NULL,
        parent         = NULL,
        children       = NULL,
        rows           = NULL,
        columns        = NULL,
        displayLogic   = NULL,
        enterLogic     = NULL,
        condition.if   = NULL,
        condition.then = NULL,

        # derived attributes

        # methods
        initialize = function(
            nodeID         = NULL,
            depth          = NULL,
            type           = NULL,
            properties     = NULL,
            parent         = NULL,
            children       = NULL,
            rows           = NULL,
            columns        = NULL,
            displayLogic   = NULL,
            enterLogic     = NULL,
            condition.if   = NULL,
            condition.then = NULL
            ) {
                self$nodeID         <- nodeID;
                self$depth          <- depth;
                self$type           <- type;
                self$properties     <- properties;
                self$parent         <- parent;
                self$children       <- children;
                self$rows           <- rows;
                self$columns        <- columns;
                self$displayLogic   <- displayLogic;
                self$enterLogic     <- enterLogic;
                self$condition.if   <- condition.if;
                self$condition.then <- condition.then;
            },

        print_node = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            base::cat("\n");
            base::cat(base::paste0(base::rep(indent,self$depth),collapse="") );
            base::cat(base::paste0("(",self$nodeID,") "));
            if ( length(self$properties) > 0 ) {
                properties.vector <- c();
                for ( i in seq(1,length(self$properties)) ) {
                    for ( temp.key in names(self$properties[[i]]) ) {
                        temp.value        <- self$properties[[i]][[temp.key]]
                        temp.string       <- paste0(temp.key," = ",paste0(temp.value,collapse=", "));
                        properties.vector <- c(properties.vector,temp.string);
                        }
                    }
                base::cat(": ");
                base::cat(paste0(properties.vector, collapse = "; "));
                }
            },

        get_offspring_IDs = function() {
            vector.output <- unique(c(
                as.vector(unlist(self$children      )),
                as.vector(unlist(self$rows          )),
                as.vector(unlist(self$columns       )),
                as.vector(unlist(self$displayLogic  )),
                as.vector(unlist(self$enterLogic    )),
                as.vector(unlist(self$condition.if  )),
                as.vector(unlist(self$condition.then))
                ));
            return(vector.output);
            }

        ), # public = list()

    private = list() # private = list()

    );

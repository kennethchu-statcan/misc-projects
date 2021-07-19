
require(R6);

node <- R6::R6Class(

    classname = "node",

    public = list(

        initialize = function(
            parent         = NULL,
            children       = NULL,
            columns        = NULL,
            displayLogic   = NULL,
            enterLogic     = NULL,
            properties     = NULL,
            rows           = NULL,
            condition.if   = NULL,
            condition.then = NULL
            ) {
                private$parent         <- parent;
                private$children       <- children;
                private$columns        <- columns;
                private$displayLogic   <- displayLogic;
                private$enterLogic     <- enterLogic;
                private$properties     <- properties;
                private$rows           <- rows;
                private$condition.if   <- condition.if;
                private$condition.then <- condition.then;
            },

        print_node = function(
            indent     = '  ',
            FUN.format = function(x) { return(x) }
            ) {
            base::cat("\n");
            base::cat(base::paste0(base::rep(indent,self$depth),collapse="") );
            base::cat(base::paste0("(",self$nodeID,") "));
            if (0 == self$nodeID) {
                base::cat("[root]");
                }
            else {
                base::cat(base::paste0("[",
                    self$birthCriterion$varname,   " ",
                    self$birthCriterion$comparison," ",
                    #FUN.format(self$birthCriterion$threshold),
                    self$birthCriterion$threshold,
                    "]"));
                }
            base::cat(base::paste0(", impurity = ",FUN.format(self$impurity)));
            base::cat(base::paste0(", np.count = ",FUN.format(base::length(self$np.rowIDs))));
            base::cat(base::paste0(", p.count = ", FUN.format(base::length(self$p.rowIDs))));
            }

        ), # public = list()

    private = list(

        parent         = NULL,
        children       = NULL,
        columns        = NULL,
        displayLogic   = NULL,
        enterLogic     = NULL,
        properties     = NULL,
        rows           = NULL,
        condition.if   = NULL,
        condition.then = NULL

        ) # private = list()

    );

|                       |model 1            |model 2            |model 3           |model 4             |
|:----------------------|:------------------|:------------------|:-----------------|:-------------------|
|Dependent Var.:        |lt_growth          |lt_growth          |lt_growth         |lt_growth           |
|                       |                   |                   |                  |                    |
|treat x post           |-0.0012** (0.0004) |-0.0015** (0.0006) |                  |-0.0021*** (0.0005) |
|treated_unit x post    |                   |                   |-0.0010* (0.0004) |                    |
|Population weights     |                   |                   |                  |Yes                 |
|Heterogeneous trends   |                   |Yes                |Yes               |Yes                 |
|Treated municipalities |10                 |10                 |10                |10                  |
|Control municipalities |50                 |50                 |26                |50                  |
|Fixed-Effects:         |------------------ |------------------ |----------------- |------------------- |
|municipality           |Yes                |Yes                |No                |Yes                 |
|date                   |Yes                |Yes                |Yes               |Yes                 |
|match_id               |No                 |No                 |Yes               |No                  |
|______________________ |__________________ |__________________ |_________________ |___________________ |
|S.E.: Clustered        |by: municipality   |by: municipality   |by: match_id      |by: municipality    |
|Observations           |4,320              |4,320              |4,248             |4,320               |
|R2                     |0.44418            |0.44559            |0.37821           |0.69312             |
|Dep. Var. mean         |-0.00045           |-0.00045           |-0.00040          |-0.00045            |
|RMSE                   |0.01410            |0.01409            |0.01773           |0.00101             |

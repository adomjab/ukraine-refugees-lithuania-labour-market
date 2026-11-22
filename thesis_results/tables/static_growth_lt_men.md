|                       |model 1          |model 2           |model 3          |model 4           |
|:----------------------|:----------------|:-----------------|:----------------|:-----------------|
|Dependent Var.:        |lt_growth        |lt_growth         |lt_growth        |lt_growth         |
|                       |                 |                  |                 |                  |
|treat x post           |-0.0004 (0.0004) |-0.0011. (0.0006) |                 |-0.0011. (0.0006) |
|treated_unit x post    |                 |                  |2.28e-5 (0.0004) |                  |
|Population weights     |                 |                  |                 |Yes               |
|Heterogeneous trends   |                 |Yes               |Yes              |Yes               |
|Treated municipalities |10               |10                |10               |10                |
|Control municipalities |50               |50                |26               |50                |
|Fixed-Effects:         |---------------- |----------------- |---------------- |----------------- |
|municipality           |Yes              |Yes               |No               |Yes               |
|date                   |Yes              |Yes               |Yes              |Yes               |
|match_id               |No               |No                |Yes              |No                |
|______________________ |________________ |_________________ |________________ |_________________ |
|S.E.: Clustered        |by: municipality |by: municipality  |by: match_id     |by: municipality  |
|Observations           |4,320            |4,320             |4,248            |4,320             |
|R2                     |0.46175          |0.46305           |0.43231          |0.56107           |
|Dep. Var. mean         |-0.00128         |-0.00128          |-0.00131         |-0.00128          |
|RMSE                   |0.01197          |0.01196           |0.01322          |0.00100           |

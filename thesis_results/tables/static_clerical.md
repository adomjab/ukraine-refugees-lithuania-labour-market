|                       |model 1         |model 2         |model 3          |model 4          |
|:----------------------|:---------------|:---------------|:----------------|:----------------|
|Dependent Var.:        |clerical        |clerical        |clerical         |clerical         |
|                       |                |                |                 |                 |
|treat x post           |0.0009 (0.0007) |0.0011 (0.0009) |                 |0.0010. (0.0005) |
|treated_unit x post    |                |                |-0.0056 (0.0034) |                 |
|Population weights     |                |                |                 |Yes              |
|Heterogeneous trends   |                |Yes             |Yes              |Yes              |
|Treated municipalities |10              |10              |10               |10               |
|Control municipalities |50              |50              |26               |50               |
|Fixed-Effects:         |--------------- |--------------- |---------------- |---------------- |
|municipality           |Yes             |Yes             |No               |Yes              |
|date                   |Yes             |Yes             |Yes              |Yes              |
|match_id               |No              |No              |Yes              |No               |
|______________________ |_______________ |_______________ |________________ |________________ |
|S.E.: Clustered        |by: municipal.. |by: municipal.. |by: match_id     |by: municipality |
|Observations           |4,320           |4,320           |4,248            |4,320            |
|R2                     |0.94013         |0.95031         |0.69139          |0.99351          |
|Dep. Var. mean         |0.03344         |0.03344         |0.03452          |0.03344          |
|RMSE                   |0.00219         |0.00200         |0.00570          |0.00016          |
